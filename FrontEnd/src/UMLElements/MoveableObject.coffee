

leftMouse = 0;
rightMouse = 2;

class MoveableObject

	constructor:(@position)->
		@NameChangeHndl = (((evt)->@OnNameChange(evt)).bind(@))
		
		@myID = @model.modelItemID

		if !@model.get("Name")
			@model.setNoLog("Name","Item"+@myID.toString())

		@name = new EdiableTextBox(new Point(10, 6), @model.get("Name"));
		@name.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@name.selectTextOnShow = true;
		@routeResolver = new RouteResolver()
		@Size = new Point(150,200)
		@Owner = globals.document
		@onDelete = new Event()
		@moveStart = null
		@model.set("Position",@position)

		@name.onTextChange.add(@NameChangeHndl)

	SetNewOwner:(@Owner)->

	GetOwnerFrameOfReffrence:()->
		@Owner.getCTM()

	GetPosition:()-> @position

	Move:(To)->
		@position = To;
		@Redraw()

	OnNameChange:(evt)->
		@model.set("Name",evt.newText)

	Del:()->
		@Owner.removeChild(@graphics.group);
		evt = new Object()
		evt.ID = @myID;
		@onDelete.pulse(evt)

	Resize:->
		@graphics.box.setAttribute("width",@Size.x);
		@graphics.box.setAttribute("height",@Size.y);
		@graphics.BoxHeader.setAttribute("width",@Size.x);
		
		namePosition = new Point((@Size.x/2)-@name.Size.x/2, @name.relPosition.y);
		if namePosition.x < 20
			namePosition.x = 20;
		@name.Move(namePosition) #maintain name in center of box
 
	Redraw:->
		@graphics.group.setAttribute('transform', "translate("+@position.x+","+@position.y+")");
		return
		
	OnTextElemetChangeSizeHandler:(evt)->
		@Resize()
	
	CreateGraphicsObject:(baseClass)->
		graphics = new Object();
		graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		graphics.box = document.createElementNS("http://www.w3.org/2000/svg", 'rect');
		graphics.BoxHeader = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@Dragger = new window.UML.Interaction.Draggable(@ActivateMove.bind(@),
														@On_mouse_move.bind(@),
														@On_mouse_up.bind(@),
														graphics.box,
														@GetPosition.bind(@));

		graphics.group.setAttribute("class","classObj");

		classes = "classBox"
		if(typeof(baseClass) != 'undefined' && baseClass != null)
			classes = classes+" "+baseClass

		graphics.box.setAttribute("class",classes);	
		graphics.box.setAttribute("x","0");
		graphics.box.setAttribute("y","0");
		graphics.box.setAttribute("rx","3");
		graphics.box.setAttribute("ry","3");
		graphics.box.setAttribute("width",@Size.x);
		graphics.box.setAttribute("height","200");
		graphics.box.setAttribute("onmouseover",@routeResolver.resolveRoute("GlobalObject")+"("+@myID+").OnMouseOverHeader(evt);");
		graphics.box.setAttribute("onmouseout",@routeResolver.resolveRoute("GlobalObject")+"("+@myID+").OnMouseExitHeader(evt);");


		graphics.BoxHeader.setAttribute("class","ClassHeaderBar")
		graphics.BoxHeader.setAttribute("x","0");
		graphics.BoxHeader.setAttribute("y","0");
		graphics.BoxHeader.setAttribute("width",@Size.x);
		graphics.BoxHeader.setAttribute("height","30");
		graphics.BoxHeader.setAttribute("onmouseover",@routeResolver.resolveRoute("GlobalObject")+"("+@myID+").OnMouseOverHeader(evt);");
		graphics.BoxHeader.setAttribute("onmouseout",@routeResolver.resolveRoute("GlobalObject")+"("+@myID+").OnMouseExitHeader(evt);");


		graphics.group.appendChild(graphics.box)
		graphics.group.appendChild(graphics.BoxHeader)

		graphics.group.appendChild(@name.CreateGraphics("ClassName ClassTextAttribute"));
		@name.Move(new Point((@Size.x/2)-@name.Size.x, @name.relPosition.y));
		graphics.group.setAttribute('transform', "translate("+@position.x+","+@position.y+")");
		
		@graphics = graphics;

		return

	OnMouseOverHeader:(evt) ->
		window.UML.globals.highlights.HighlightClass(@)

	OnMouseExitHeader:(evt) ->
		window.UML.globals.highlights.UnHighlightClass(@)

	Highlight:()->
		$(@graphics.BoxHeader).addClass('ClassHeaderBarHover')
		$(@graphics.cornerHack).addClass("ClassHeaderBarHover")
		$(@graphics.box).addClass("ClassOutlineHover")
	Unhighlight:()->
		$(@graphics.BoxHeader).removeClass("ClassHeaderBarHover")
		$(@graphics.cornerHack).removeClass("ClassHeaderBarHover");
		$(@graphics.box).removeClass("ClassOutlineHover")

	Select:() ->

	deactivate:() ->

	ActivateMove:(evt) ->
		@graphics.group.setAttribute("pointer-events","none")
		evt = new Object();
		evt.moveableObject = @
		@moveStart = @position
		@prevOwner = @Owner
		window.UML.Pulse.MoveableObjectActivated.pulse(evt)
		@Select();

	On_mouse_move:(to) ->
		@Move(to);

	On_mouse_up:(evt) ->
		@graphics.group.setAttribute("pointer-events","all")
		window.UML.Pulse.MoveableObjectDeActivated.pulse()
		@model.set("Position",@position)


	OnModelChange:(evt)->
		if evt.name == "Position"
			@Move(evt.new_value)

