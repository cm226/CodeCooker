class Class extends InheritableObject

	constructor:(@position, @model, popoutView)->
		super(@position);

		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))
		
		@Properties = new EditableTextBoxTable(new Point(15,35),@model.get("Properties"));
		@Properties.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@Properties.rowFactory = new PropertyRowFactory()
		@Properties.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Properties.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Properties");

		@Methods = new EditableTextBoxTable(new Point(15,105),@model.get("Methods"))
		@Methods.rowFactory = new MethodRowFactory(@model.get("Methods"))
		@Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Methods");
		@Methods.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@Methods.minHeight = 85
		@Methods.height = 85
		@routeResolver.createRoute("GlobalObject","window.UML.globals.classes.get");
		@Attributes = [@Properties, @Methods]
		@ClassPropertyDropDown = new ClassPropertyPopout(new Point(10,10),popoutView,@model)

		window.UML.Pulse.TypeNameChanged.pulse({prevText:"";newText:@model.get("Name")})

	SetID:(@myID)->
		@Properties.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Properties.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Properties");
		@Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Methods");
		
	Del:()->
		super();
		window.UML.Pulse.TypeDeleted.pulse({typeText:@name.text})
		@name.onTextChange.remove(@NameChangeHndl)

	Resize:->
		super();
		
		@graphics.propertySeperator.setAttribute("x2", @Size.x);
		@graphics.methodSeperator.setAttribute("x2", @Size.x);

		methodHeight = @Properties.height+40;

		@graphics.methodSeperator.setAttribute("y1", methodHeight);
		@graphics.methodSeperator.setAttribute("y2", methodHeight);

		@graphics.methodSeperator2.setAttribute("y1", methodHeight);
		@graphics.methodSeperator2.setAttribute("y2", methodHeight);

		@graphics.methodHeader.setAttribute("y", methodHeight+6);
		@methodsExpand.MoveDown(methodHeight)
		@addMethodBttn.MoveDown(methodHeight-3)

		@Methods.Move(new Point(@Methods.position.x,methodHeight))

	OnNameChange:(evt)->
		super(evt)
		window.UML.Pulse.TypeNameChanged.pulse(evt)
 
	OnTextElemetChangeSizeHandler:(evt)->
		@Methods.Resize()
		@Properties.Resize()
		@Size.x= (Math.max(@Properties.width+@Properties.position.x, @Methods.width+ @Methods.position.x, @name.Size.x+20))+7
		@Size.y = @Properties.height + @Methods.height + 30 + 20 # + header size + nooks and craneys (I KNOW DNT HARD CODE THIS SHIT BUT IM A LAZY ASS WHAT U GONNA DO!)
		super();

	Highlight:()->
		super()
		@addPropertyBttn.Show()
		@addMethodBttn.Show();

	Unhighlight:()->
		super()
		@addPropertyBttn.Hide()
		@addMethodBttn.Hide();

	CreateGraphicsObject:()->
		super();

		@graphics.propertyHeader = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@graphics.methodHeader = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@graphics.propertySeperator = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@graphics.propertySeperator2 = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@graphics.methodSeperator = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@graphics.methodSeperator2 = document.createElementNS("http://www.w3.org/2000/svg", 'line');

		headerEndY = parseInt(@graphics.BoxHeader.getAttribute("x")) + parseInt(@graphics.BoxHeader.getAttribute("height"));
		propertyHeight = 70;

		@propertysExpand = new ExpandButton(@Properties, 3,headerEndY, @model.get("Properties"));
		@methodsExpand = new ExpandButton(@Methods, 3,propertyHeight + headerEndY, @model.get("Methods"));

		@addPropertyBttn = new SVGButton("Add", new Point(90, headerEndY - 2))
		@addMethodBttn = new SVGButton("Add", new Point(80, propertyHeight + headerEndY - 2))
		
		@addPropertyBttn.AddOnClick((()->
			rowModel = new window.UML.MODEL.ModelItem()
			rowModel.setNoLog("Name","name");
			rowModel.setNoLog("Vis","+");
			rowModel.setNoLog("Type","type");
			rowModel.setNoLog("Static",false);
			@model.get("Properties").get("Items").push(rowModel)).bind(@))

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



		@graphics.propertyHeader.setAttribute("x",25);
		@graphics.propertyHeader.setAttribute("y",headerEndY+6);
		@graphics.propertyHeader.setAttribute("height", 12)
		@graphics.propertyHeader.setAttribute("width", 40)
		@graphics.propertyHeader.setAttribute("class","ClassSectionHeader");
		@graphics.propertyHeader.textContent = "Properties";

		@graphics.methodHeader.setAttribute("x",25);
		@graphics.methodHeader.setAttribute("y",propertyHeight + headerEndY);
		@graphics.methodHeader.setAttribute("height", 12)
		@graphics.methodHeader.setAttribute("width", 40)
		@graphics.methodHeader.setAttribute("class","ClassSectionHeader");
		@graphics.methodHeader.textContent = "Methods";

		@graphics.propertySeperator.setAttribute("class", "ClassBarSeperator");
		@graphics.propertySeperator.setAttribute("x1", "90");
		@graphics.propertySeperator.setAttribute("y1", headerEndY);
		@graphics.propertySeperator.setAttribute("x2", @Size.x);
		@graphics.propertySeperator.setAttribute("y2", headerEndY);
		@graphics.propertySeperator.setAttribute("height", propertyHeight);
		@graphics.propertySeperator.setAttribute("stroke", "black");

		@graphics.propertySeperator2.setAttribute("class", "ClassBarSeperator");
		@graphics.propertySeperator2.setAttribute("x1", "0");
		@graphics.propertySeperator2.setAttribute("y1", headerEndY);
		@graphics.propertySeperator2.setAttribute("x2", 6);
		@graphics.propertySeperator2.setAttribute("y2", headerEndY);
		@graphics.propertySeperator2.setAttribute("height", propertyHeight);
		@graphics.propertySeperator2.setAttribute("stroke", "black");

		@graphics.methodSeperator.setAttribute("class", "ClassBarSeperator");
		@graphics.methodSeperator.setAttribute("x1", "80");
		@graphics.methodSeperator.setAttribute("y1", propertyHeight + headerEndY);
		@graphics.methodSeperator.setAttribute("x2", @Size.x);
		@graphics.methodSeperator.setAttribute("y2", propertyHeight + headerEndY);

		@graphics.methodSeperator2.setAttribute("class", "ClassBarSeperator");
		@graphics.methodSeperator2.setAttribute("x1", "0");
		@graphics.methodSeperator2.setAttribute("y1", propertyHeight + headerEndY);
		@graphics.methodSeperator2.setAttribute("x2", 6);
		@graphics.methodSeperator2.setAttribute("y2", propertyHeight + headerEndY);

		@graphics.group.appendChild(@Methods.CreateGraphics());
		@graphics.group.appendChild(@methodsExpand.CreateGraphics());
		@graphics.group.appendChild(@Properties.CreateGraphics())
		@graphics.group.appendChild(@propertysExpand.CreateGraphics());
		@graphics.group.appendChild(@graphics.propertySeperator);
		@graphics.group.appendChild(@graphics.propertySeperator2);
		@graphics.group.appendChild(@graphics.methodSeperator);
		@graphics.group.appendChild(@graphics.propertyHeader);
		@graphics.group.appendChild(@graphics.methodHeader);
		@graphics.group.appendChild(@graphics.methodSeperator2);
		@graphics.group.appendChild(@addPropertyBttn.CreateGraphics());
		@graphics.group.appendChild(@addMethodBttn.CreateGraphics());
		

		@graphics.group.appendChild(@ClassPropertyDropDown.CreateGraphicsObject())

		globals.LayerManager.InsertClassLayer(@graphics.group);


		# resize elements after being added to the dom
		@name.resize();
		@Properties.Resize();
		@Methods.Resize();
		@Resize()

		@Methods.InitView()
		@Properties.InitView()
		return

	OnModelChange:(evt)->
		if evt.name == "Name"
			@name.UpdateText(evt.new_value);
		else
			super(evt)	
		