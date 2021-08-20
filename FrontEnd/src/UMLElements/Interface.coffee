
class Interface extends InheritableObject
	constructor:(@position, @model, popoutView)->
		super(@position);

		@NameChangeHndl = (((evt)-> @OnNameChange(evt)).bind(@))
		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))

		@IsInterface = true;
		@Methods = new EditableTextBoxTable(new Point(15,105),@model.get("Methods"))
		@Methods.rowFactory = new MethodRowFactory()
		@Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Methods");
		@Methods.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@Methods.minHeight = 85
		@Methods.height = 85
		@routeResolver.createRoute("GlobalObject","window.UML.globals.classes.get");
		@ClassPropertyDropDown = new ClassPropertyPopout(new Point(15,15),popoutView, @model)

		window.UML.Pulse.TypeNameChanged.pulse({prevText:"";newText:@model.get("Name")})
		@name.onTextChange.add(@NameChangeHndl)

		@minwidth = 150;
	SetID:(@myID)->
		@Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Methods");

	Del:()->
		super();
		window.UML.Pulse.TypeDeleted.pulse({typeText:@name.text})

	OnNameChange:(evt)->
		@model.set("Name",evt.newText)
		window.UML.Pulse.TypeNameChanged.pulse(evt)

	Resize:->
		super();
		@graphics.methodSeperator.setAttribute("x2", @Size.x);
		@graphics.interfaceText.setAttribute("x",(@Size.x/2)-@graphics.interfaceText.getBBox().width/2);
		@Methods.Resize()

	OnTextElemetChangeSizeHandler:(evt)->
		@Methods.Resize()
		@Size.x = (Math.max( @Methods.width+ @Methods.position.x, @name.Size.x+20,@minwidth))+7
		@Size.y =  @Methods.height + 30 + 20 # + header size + nooks and craneys (I KNOW DNT HARD CODE THIS SHIT BUT IM A LAZY ASS WHAT U GONNA DO!)
		super();

	Highlight:()->
		super()
		@addMethodBttn.Show();

	Unhighlight:()->
		super()
		@addMethodBttn.Hide();

	CreateGraphicsObject:()->
		super();

		@graphics.group.setAttribute("class",@graphics.group.getAttribute("class") + " interfaceObj");

		@graphics.interfaceText = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@graphics.methodSeperator = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@graphics.methodHeader = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@graphics.methodSeperator2 = document.createElementNS("http://www.w3.org/2000/svg", 'line');

		@graphics.interfaceText.setAttribute("class","greyText ClassTextAttribute");
		@graphics.interfaceText.textContent = "<<Interface>>";

		
		@graphics.interfaceText.setAttribute("y","17");
		@graphics.BoxHeader.appendChild(@graphics.interfaceText);
		@name.Move(new Point(5, 18));

		globals.LayerManager.InsertClassLayer(@graphics.group); # append the element early so that we can use the size to position other elements

		headerHeight = @name.Size.y + @name.relPosition.y
		headerEndY = parseInt(@graphics.BoxHeader.getAttribute("y")) + parseInt(headerHeight)+ 10;

		@methodsExpand = new ExpandButton(@Methods, 3,headerEndY, @model.get("Methods"));
		@addMethodBttn = new SVGButton("Add", new Point(80, headerEndY - 2))

		@addMethodBttn.AddOnClick((()->
			rowModel = new window.UML.MODEL.ModelItem()
			rowModel.setNoLog("Name","Method")
			rowModel.setNoLog("Return","Int")
			rowModel.setNoLog("Vis","+")
			rowModel.setNoLog("Args","arg1 : Int, arg2 : Float")
			rowModel.setNoLog("Comment","")
			rowModel.setNoLog("Static",false)
			rowModel.setNoLog("Absract",false)
			@model.get("Methods").get("Items").push(rowModel)).bind(@));

		@graphics.methodSeperator.setAttribute("class", "ClassBarSeperator");
		@graphics.methodSeperator.setAttribute("x1", "80");
		@graphics.methodSeperator.setAttribute("y1", headerEndY);
		@graphics.methodSeperator.setAttribute("x2", @Size.x);
		@graphics.methodSeperator.setAttribute("y2", headerEndY);

		@graphics.methodSeperator2.setAttribute("class", "ClassBarSeperator");
		@graphics.methodSeperator2.setAttribute("x1", "0");
		@graphics.methodSeperator2.setAttribute("y1", headerEndY);
		@graphics.methodSeperator2.setAttribute("x2", 6);
		@graphics.methodSeperator2.setAttribute("y2", headerEndY);

		@graphics.methodHeader.setAttribute("x",25);
		@graphics.methodHeader.setAttribute("y", headerEndY+6);
		@graphics.methodHeader.setAttribute("height", 12)
		@graphics.methodHeader.setAttribute("width", 40)
		@graphics.methodHeader.setAttribute("class","ClassSectionHeader");
		@graphics.methodHeader.textContent = "Methods";

		@graphics.group.appendChild(@Methods.CreateGraphics({0:"+",1:"retType", 2:"name", 3:"int arg1, float arg2"}));
		@graphics.group.appendChild(@graphics.methodSeperator);
		@graphics.group.appendChild(@graphics.methodSeperator2);

		@Methods.Move(new Point(15,headerEndY))

		@graphics.group.appendChild(@ClassPropertyDropDown.CreateGraphicsObject())
		@graphics.group.appendChild(@methodsExpand.CreateGraphics())

		@graphics.group.appendChild(@graphics.methodHeader)
		@graphics.group.appendChild(@addMethodBttn.CreateGraphics());
		

		# resize elements after being added to the dom
		@name.resize();
		@Methods.Resize()
		@Resize()

		@Methods.InitView();
		return

	OnMouseOverHeader:(evt) ->
		window.UML.globals.highlights.HighlightInterface(@)
	OnMouseExitHeader:(evt) ->
		window.UML.globals.highlights.UnHighlightInterface(@)

	OnModelChange:(evt)->
		if evt.name == "Name"
			@name.UpdateText(evt.new_value);
		else
			super(evt)