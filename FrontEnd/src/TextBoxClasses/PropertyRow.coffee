window.UML.Pulse.TextBoxGroupSelected = new Event()

class PropertyRow extends DefaultRow
	constructor:(width,@position,@model)->
		super(width, @position)

		@OnVisibilitySizeChange  = ((evt) ->@OnVisibilityChangeSizeHandler(evt)).bind(@)
		@OnNameSizeChange  = ((evt) ->@OnNameChangeSizeHandler(evt)).bind(@)

		@OnNameChange = ((evt) ->@OnNameChangeHandler(evt)).bind(@)
		@OnTypeChange = ((evt) ->@OnTypeChangeHandler(evt)).bind(@)
		@OnVisChange = ((evt) ->@OnVisChangeHandler(evt)).bind(@)
		

		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))

	
	CreateGraphics:(@RowNumber)->
		@graphics = new Object();
		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.VisibiityDropDown = new EdiableDropDown(new Point(0,0),@model.model.Vis,["+","-","#"])
		@graphics.VisibiityDropDown.onTabPressedHandler = ((evt)-> @graphics.VisibiityDropDown.onEditBoxBlur(); @graphics.NameTexBox.OnSelect(); false;).bind(@)

		@graphics.TypeTextBox = new ReturnValueTextBox(new Point(10,0),@model.get("Type"))
		@graphics.TypeTextBox.selectTextOnShow = true;
		@graphics.TypeTextBox.onTabPressedHandler = ((evt)-> 
			@graphics.TypeTextBox.onTabPress()
			@graphics.TypeTextBox.hideEditBox();
			@graphics.VisibiityDropDown.OnSelect();
			false;).bind(@)

		@graphics.NameTexBox = new EdiableTextBox(new Point(30,0),@model.model.Name)
		@graphics.NameTexBox.selectTextOnShow = true;
		@graphics.NameTexBox.onTabPressedHandler = ((evt)->	@graphics.NameTexBox.onEditBoxBlur(); @graphics.TypeTextBox.OnSelect(); false;).bind(@)

		@graphics.VisibiityDropDown.highlightBox.passive = true;
		@graphics.TypeTextBox.highlightBox.passive = true;
		@graphics.NameTexBox.highlightBox.passive = true;

		@graphics.NameTexBox.onTextChange.add(@OnNameChange)
		@graphics.TypeTextBox.onTextChange.add(@OnTypeChange)
		@graphics.VisibiityDropDown.onTextChange.add(@OnVisChange)
		
		

		# connect sub componentes of row and use there ui triggers as our own
		@graphics.VisibiityDropDown.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.VisibiityDropDown.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.VisibiityDropDown.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)

		@graphics.TypeTextBox.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.TypeTextBox.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.TypeTextBox.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)

		@graphics.NameTexBox.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.NameTexBox.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.NameTexBox.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)


		@graphics.VisibiityDropDown.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@graphics.TypeTextBox.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@graphics.NameTexBox.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))

		@highlightBox.CreateGraphics(@graphics)

		@graphics.group.appendChild(@graphics.border)
		@graphics.group.appendChild(@graphics.VisibiityDropDown.CreateGraphics("TextElement"))
		@graphics.group.appendChild(@graphics.TypeTextBox.CreateGraphics("TextElement"))
		@graphics.group.appendChild(@graphics.NameTexBox.CreateGraphics("TextElement"))

		@graphics.group.setAttribute("class", "EditBoxRow")
		@graphics.group.setAttribute("transform", "translate("+@position.x+" "+@position.y+")")
		@graphics

	OnTextElemetChangeSizeHandler:(evt)->
		@ReCalculateSize()
		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)

	Resize:()->
		@graphics.TypeTextBox.resize()
		@graphics.VisibiityDropDown.resize()
		@graphics.NameTexBox.resize()
		@ReCalculateSize()
		@highlightBox.Resize()
		super()
		

	ReCalculateSize:()->
		spaceing = 10
		@Size.x = @graphics.VisibiityDropDown.Size.x + spaceing
		@graphics.NameTexBox.Move(new Point(@Size.x,0)); 

		@Size.x+= @graphics.NameTexBox.Size.x + spaceing
		@graphics.TypeTextBox.Move(new Point(@Size.x,0));

		@Size.x+= @graphics.TypeTextBox.Size.x + spaceing

	OnSelect:()->
		evt = new Object()
		evt.textBoxGroup = @
		window.UML.Pulse.TextBoxGroupSelected.pulse(evt)
		
		$(@graphics.border).addClass("selectedRow")

		windowCoord = window.UML.Utils.getScreenCoordForSVGElement(@graphics.border)

		positionValues = window.UML.TextBoxes.IntelligentPopoutPositioning.Position({right: $('#popoverLinkPropR'), left: $('#popoverLinkPropL')},
			new Point(107, 0),
			windowCoord,
			@Size);

		@popoverLink = positionValues.element
		popoutPosition = positionValues.position

		@popoverLink.css("top",popoutPosition.y)
		@popoverLink.css("left",popoutPosition.x)
		@popoverLink.attr("data-original-title","Property Edit")

		if @model.get("Static")
			StaticString = "<input type=\"checkbox\" checked id=\"Static\">Static"
		else
			StaticString = "<input type=\"checkbox\" id=\"Static\">Static"

		StaticString += "<br/><br/><button type=\"button\" class=\"btn btn-danger\" onClick=\""+@routeResolver.resolveRoute("Table")+".rows.get("+@RowNumber+").model.del();\">Delete</button>"

		@popoverLink.popover('hide')
		@popoverLink.attr("data-content",StaticString)
		@popoverLink.popover('show')

		@graphics.VisibiityDropDown.highlightBox.passive = false;
		@graphics.TypeTextBox.highlightBox.passive = false;
		@graphics.NameTexBox.highlightBox.passive = false;

	deactivate:()->
		$(@graphics.border).removeClass("selectedRow")
		@model.set("Static", $('#Static').is(':checked'))

		if @popoverLink
			@popoverLink.popover('destroy')

		@graphics.VisibiityDropDown.highlightBox.passive = true;
		@graphics.TypeTextBox.highlightBox.passive = true;
		@graphics.NameTexBox.highlightBox.passive = true;
	
	OnVisibilityChangeSizeHandler:(evt)->
		@graphics.TypeTextBox.resize()
		@graphics.NameTexBox.resize()
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)

	OnNameChangeSizeHandler:(evt)->
		@graphics.TypeTextBox.resize()
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)

	onDelete:()->

	OnNameChangeHandler:(evt)->
		@model.set("Name", evt.newText)

	OnTypeChangeHandler:(evt)->
		@model.set("Type", evt.newText)	

	OnVisChangeHandler:(evt)->
		@model.set("Vis", evt.newText)			

	OnModelChange:(evt)->
		if evt.name == "Name"
			@graphics.NameTexBox.UpdateText(evt.new_value)
		else if evt.name == "Type"
			@graphics.TypeTextBox.UpdateText(evt.new_value)
		else if evt.name == "Vis"
			@graphics.VisibiityDropDown.UpdateText(evt.new_value)


	
	


