class ClassText

	constructor:(@relPosition, @classID, @AttributeIndex) ->
		@onSizeChange = new Event()
		@height = 65
		@width = 142
		@minWidth = 142
		@minHeight = 65

	Move:(@to) ->
		@relPosition = @to
		@graphics.group.setAttribute("transform", "translate("+@relPosition.x+" "+@relPosition.y+")")		

	Resize:() ->
		@graphics.border.setAttribute("height", @height)
		@graphics.border.setAttribute("width", @width)

	CreateGraphics:(@text) ->
		@graphics = new Object()

		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.text = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@graphics.tspan = document.createElementNS("http://www.w3.org/2000/svg", 'tspan');
		@graphics.border = document.createElementNS("http://www.w3.org/2000/svg", 'rect');

		@graphics.text.setAttribute("x",1);
		@graphics.text.setAttribute("y",5);
		@graphics.text.setAttribute("class","classAttribute");
		@graphics.text.setAttribute("onmouseover", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onMouseOver(evt);");
		@graphics.text.setAttribute("onclick", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onClick(evt);");

		@graphics.tspan.setAttribute("x",10);
		@graphics.tspan.setAttribute("dy","1.2em");
		@graphics.tspan.textContent = @text;
		@graphics.text.appendChild(@graphics.tspan)

		@graphics.border.setAttribute("stroke", "none")
		@graphics.border.setAttribute("x", 1)
		@graphics.border.setAttribute("y", 1)
		@graphics.border.setAttribute("height", @height)
		@graphics.border.setAttribute("width", @width)
		@graphics.border.setAttribute("fill", "white")
		@graphics.border.setAttribute("onmouseout", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onMouseExit(evt);");
		@graphics.border.setAttribute("onmouseover", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onMouseOver(evt);");
		@graphics.border.setAttribute("onclick", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onClick(evt);");

		@graphics.group.setAttribute("transform", "translate("+@relPosition.x+" "+@relPosition.y+")")

		@graphics.group.appendChild(@graphics.border)
		@graphics.group.appendChild(@graphics.text)

		return @graphics

	onClick:(evt) ->
		#NEEDS OPTIMISATION 
		@currentEditBox = document.createElement("textArea")
		@currentBackground = document.createElement("div")

		@currentEditBox.value = @text
		@currentEditBox.setAttribute("type", "text")
		@currentEditBox.setAttribute("style","position: absolute;height: 200px;width: 400px;margin: -100px 0 0 -200px;top: 50%; left: 50%;")

		@currentBackground.setAttribute("style", "background-color: rgba(0,0,0,0.4); height:100%; width:100%; position:fixed; top:0px; left:0px; right:0px; bottom:0px")
		@currentEditBox.setAttribute("onBlur", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onBlur();")

		@currentBackground.appendChild(@currentEditBox)
		document.getElementById('WorkArea').appendChild(@currentBackground)

		@currentEditBox.focus();

	onBlur:() ->
		@text = @currentEditBox.value
		@repopulateText(@text)	
		@currentBackground.parentNode.removeChild(@currentBackground)

	repopulateText:(text) ->
		properties = text.split("\n") # is this safe? neet to check (probably not for UNIX line endings)
		@graphics.text.textContent = "";
		ref = @
		for property in properties
			do (property, ref)->
				newSpan = document.createElementNS("http://www.w3.org/2000/svg", 'tspan');
				newSpan.setAttribute("x",10);
				newSpan.setAttribute("dy","1.2em");
				newSpan.textContent = property;
				
				ref.graphics.text.appendChild(newSpan);
				return 

		@recalculateSize()
		@graphics.border.setAttribute("height", @height)
		@graphics.border.setAttribute("width", @width)
		@onSizeChange.pulse(null)

	onMouseOver:(evt) ->
		@graphics.border.setAttribute("stroke", "#3385D6")
	onMouseExit:(evt) ->
		@graphics.border.setAttribute("stroke", "none")

	recalculateSize:() ->
		newWidth = @graphics.text.getBBox().width
		newHeight = @graphics.text.getBBox().height

		@width = @calculateWidth(newWidth)
		@height = @calculateHeight(newHeight)

	calculateWidth:(newWidth)->
		sizeToUse = @width
		if newWidth > @width-20 then sizeToUse = newWidth+40
		else if newWidth < @width-50 then sizeToUse = newWidth+ 40;
		Math.max(@minWidth, sizeToUse)

	calculateHeight:(newHeight)->
		Math.max(newHeight, @minHeight)