class MethodRow extends DefaultRow
	constructor:(width,@position, @model)->
		super(width, @position)

		@OnVisibilitySizeChange  = ((evt) ->@OnVisibilityChangeSizeHandler(evt)).bind(@) 
		@OnArgumentsSizeChange  = ((evt) ->@OnArgumentsChangeSizeHandler(evt)).bind(@) 
		@OnNameTxtBxSizeChange  = ((evt) ->@OnNameChangeSizeHandler(evt)).bind(@) 
		@OnReturnTxtBxSizeChange  = ((evt) ->@OnReturnChangeSizeHandler(evt)).bind(@)

		@OnNameChange = ((evt) ->@OnNameChangeHandler(evt)).bind(@)
		@OnReturnChange = ((evt) ->@OnReturnChangeHandler(evt)).bind(@) 
		@OnArgsChange = ((evt) ->@OnArgsChangeHandler(evt)).bind(@) 
		@OnVisChange = ((evt) ->@OnVisChangeHandler(evt)).bind(@) 


		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))
		@popoutDisplayed = false;


	CreateGraphics:(@RowNumber)->
		@graphics = new Object();
		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.VisibiityDropDown = new EdiableDropDown(new Point(0,0),@model.get("Vis"),["+","-","#"])
		@graphics.VisibiityDropDown.onTabPressedHandler = ((evt)->	@graphics.VisibiityDropDown.onEditBoxBlur(); @graphics.NameTexBox.OnSelect(); false;).bind(@)

		@graphics.NameTexBox = new EdiableTextBox(new Point(30,0),@model.get("Name"))
		@graphics.NameTexBox.onTabPressedHandler = ((evt)->	@graphics.NameTexBox.onEditBoxBlur(); @graphics.ArgumentsTextBox.OnSelect(); false;).bind(@)
		@graphics.NameTexBox.selectTextOnShow = true;

		@graphics.ArgumentsTextBox = new MemberArgumentsTextBox(new Point(30,0),@model.get("Args"))
		@graphics.ArgumentsTextBox.onTabPressedHandler = ((evt)->
			if !@graphics.ArgumentsTextBox.currentMemberArg.TypeSugestionBox.displayed
				@graphics.ArgumentsTextBox.onEditBoxBlur();
				@graphics.ReturnTextBox.OnSelect();
				false;).bind(@)

		@graphics.ReturnTextBox = new ReturnValueTextBox(new Point(30,0),@model.get("Return"))
		@graphics.ReturnTextBox.selectTextOnShow = true;
		@graphics.ReturnTextBox.onTabPressedHandler = ((evt)-> 
			@graphics.ReturnTextBox.onTabPress()
			@graphics.ReturnTextBox.onEditBoxBlur();
			@graphics.VisibiityDropDown.OnSelect();
			false;).bind(@)

		@graphics.NameTexBox.onTextChange.add(@OnNameChange)
		@graphics.ReturnTextBox.onTextChange.add(@OnReturnChange)
		@graphics.ArgumentsTextBox.onTextChange.add(@OnArgsChange)
		@graphics.VisibiityDropDown.onTextChange.add(@OnVisChange)

		@graphics.VisibiityDropDown.highlightBox.passive = true;
		@graphics.ReturnTextBox.highlightBox.passive = true;
		@graphics.ArgumentsTextBox.highlightBox.passive = true;
		@graphics.NameTexBox.highlightBox.passive = true;

		# connect sub componentes of row and use there ui triggers as our own
		@graphics.VisibiityDropDown.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.VisibiityDropDown.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.VisibiityDropDown.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)

		@graphics.ReturnTextBox.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.ReturnTextBox.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.ReturnTextBox.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)

		@graphics.ArgumentsTextBox.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.ArgumentsTextBox.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.ArgumentsTextBox.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)

		@graphics.NameTexBox.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.NameTexBox.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.NameTexBox.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)


		@graphics.VisibiityDropDown.onSizeChange.add(@OnVisibilitySizeChange)
		@graphics.ArgumentsTextBox.onSizeChange.add(@OnArgumentsSizeChange)
		@graphics.NameTexBox.onSizeChange.add(@OnNameTxtBxSizeChange)
		@graphics.ReturnTextBox.onSizeChange.add(@OnReturnTxtBxSizeChange)

		@highlightBox.CreateGraphics(@graphics)

		@graphics.group.appendChild(@graphics.border)
		@graphics.group.appendChild(@graphics.VisibiityDropDown.CreateGraphics("TextElement"))
		@graphics.group.appendChild(@graphics.ArgumentsTextBox.CreateGraphics("TextElement"))
		@graphics.group.appendChild(@graphics.NameTexBox.CreateGraphics("TextElement"))
		@graphics.group.appendChild(@graphics.ReturnTextBox.CreateGraphics("TextElement"))

		@graphics.group.setAttribute("class", "EditBoxRow")
		@graphics.group.setAttribute("transform", "translate("+@position.x+" "+@position.y+")")

		if @model.get("Abstract")
			@SetAbstractGraphics()

		@graphics

	Resize:()->
		@graphics.VisibiityDropDown.resize()
		@graphics.NameTexBox.resize()
		@graphics.ArgumentsTextBox.resize()
		@graphics.ReturnTextBox.resize()
		@ReCalculateSize()
		super()
		
	ReCalculateSize:()->
		spaceing = 10
		@Size.x = @graphics.VisibiityDropDown.Size.x + spaceing
		@graphics.NameTexBox.Move(new Point(@Size.x,0)); 

		@Size.x+= @graphics.NameTexBox.Size.x + spaceing
		@graphics.ArgumentsTextBox.Move(new Point(@Size.x,0));
		
		@Size.x+= @graphics.ArgumentsTextBox.Size.x + spaceing
		@graphics.ReturnTextBox.Move(new Point(@Size.x,0));

		@Size.x+= @graphics.ReturnTextBox.Size.x + spaceing

		if @popoutDisplayed
			@MovePopout()

	MovePopout:()->
		windowCoord = window.UML.Utils.getScreenCoordForSVGElement(@graphics.border)

		positionValues = window.UML.TextBoxes.IntelligentPopoutPositioning.Position({right: $('#popoverLinkMethR'), left: $('#popoverLinkMethL')},
			new Point(280, 0),
			windowCoord,
			@Size);

		if positionValues.element[0] != @popoverLink[0]
			@popoverLink.popover('hide')
			@popoverLink = positionValues.element
			@InitialisePopover()

		popoutPosition = positionValues.position
		
		@popoverLink.css("top",popoutPosition.y)
		@popoverLink.css("left",popoutPosition.x)
		@popoverLink.popover('show')

	OnVisibilityChangeSizeHandler:(evt)->
		@graphics.NameTexBox.resize()
		@graphics.ArgumentsTextBox.resize()
		@graphics.ReturnTextBox.resize()
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)


	OnNameChangeSizeHandler:(evt)->
		@graphics.ArgumentsTextBox.resize()
		@graphics.ReturnTextBox.resize()
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)


	OnArgumentsChangeSizeHandler:(evt)->
		@graphics.ReturnTextBox.resize()
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)

	OnReturnChangeSizeHandler:(evt)->
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)

	SetAbstractGraphics:()->
		$(@graphics.VisibiityDropDown.graphics.text).addClass("AbstractMethod")
		$(@graphics.NameTexBox.graphics.text).addClass("AbstractMethod")
		$(@graphics.ArgumentsTextBox.graphics.text).addClass("AbstractMethod")
		$(@graphics.ReturnTextBox.graphics.text).addClass("AbstractMethod")

	UnsetAbstractGraphics:()->
		$(@graphics.VisibiityDropDown.graphics.text).removeClass("AbstractMethod")
		$(@graphics.NameTexBox.graphics.text).removeClass("AbstractMethod")
		$(@graphics.ArgumentsTextBox.graphics.text).removeClass("AbstractMethod")
		$(@graphics.ReturnTextBox.graphics.text).removeClass("AbstractMethod")	

	SetAbstract:()->
		@model.set("Abstract", true);
		@SetAbstractGraphics();
		
	UnsetAbstract:()->
		@model.set("Abstract", false);
		@UnsetAbstractGraphics();

	InitialisePopover:()->
		@popoverLink.attr("data-original-title","Method Edit")

		if @model.get("Abstract")
			AbstractString = "<input type=\"checkbox\" checked id=\"Abstract\">Abstract"
		else
			AbstractString = "<input type=\"checkbox\" id=\"Abstract\">Abstract"

		if @model.get("Static")
			StaticString = "<input type=\"checkbox\" checked id=\"Static\">Static"
		else
			StaticString = "<input type=\"checkbox\" id=\"Static\">Static"

		StaticString+= "<div><span>Method Comment:</span><textarea id=\"classPropertyDescription\">"
		StaticString+=@model.get("Comment");
		StaticString+="</textarea></div>";

		StaticString += "<br/><br/><button type=\"button\" class=\"btn btn-danger\" onClick=\""+@routeResolver.resolveRoute("Table")+".rows.get("+@RowNumber+").model.del();\" >Delete</button>"

		@popoverLink.attr("data-content",AbstractString+"<br>"+StaticString)


	OnSelect:()->
		evt = new Object()
		evt.textBoxGroup = @
		window.UML.Pulse.TextBoxGroupSelected.pulse(evt)

		$(@graphics.border).addClass("selectedRow")
		windowCoord = window.UML.Utils.getScreenCoordForSVGElement(@graphics.border)
		
		positionValues = window.UML.TextBoxes.IntelligentPopoutPositioning.Position({right: $('#popoverLinkMethR'), left: $('#popoverLinkMethL')},
			new Point(280, 0),
			windowCoord,
			@Size);

		@popoverLink = positionValues.element
		popoutPosition = positionValues.position
		
		@popoverLink.css("top",popoutPosition.y)
		@popoverLink.css("left",popoutPosition.x)
		
		@popoverLink.popover('hide')
		@InitialisePopover()
		@popoverLink.popover('show')

		@popoutDisplayed = true;

		@graphics.VisibiityDropDown.highlightBox.passive = false;
		@graphics.ReturnTextBox.highlightBox.passive = false;
		@graphics.NameTexBox.highlightBox.passive = false;
		@graphics.ArgumentsTextBox.highlightBox.passive = false;

	deactivate:()->
		$(@graphics.border).removeClass("selectedRow")
		@model.set("Static",$('#Static').is(':checked'));

		if not @model.get("Abstract")  and $('#Abstract').is(':checked')
			@SetAbstract()
		else if @model.get("Abstract") and not $('#Abstract').is(':checked')
			@UnsetAbstract()
		@model.set("Comment",$("#classPropertyDescription").val())
		
		if @popoverLink
			@popoverLink.popover('destroy')

		@popoutDisplayed = false;

		@graphics.VisibiityDropDown.highlightBox.passive = true;
		@graphics.ReturnTextBox.highlightBox.passive = true;
		@graphics.NameTexBox.highlightBox.passive = true;
		@graphics.ArgumentsTextBox.highlightBox.passive = true;

	onDelete:()->

	OnNameChangeHandler:(evt)->
		@model.set("Name",evt.newText);
	OnReturnChangeHandler:(evt)->
		@model.set("Return",evt.newText);
	OnArgsChangeHandler:(evt)-> 
		@model.set("Args",evt.newText);
	OnVisChangeHandler:(evt)->
		@model.set("Vis",evt.newText);

	OnModelChange:(evt)->
		if evt.name == "Name"
			@graphics.NameTexBox.UpdateText(evt.new_value)
		else if evt.name == "Return"
			@graphics.ReturnTextBox.UpdateText(evt.new_value)
		else if evt.name == "Vis"
			@graphics.VisibiityDropDown.UpdateText(evt.new_value)
		else if evt.name == "Args"
			 @graphics.ArgumentsTextBox.UpdateText(evt.new_value)
		else if evt.name == "Abstract"
			if evt.new_value
				@SetAbstractGraphics();
			else
				@UnsetAbstractGraphics();



		


