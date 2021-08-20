class HighlightableTextBox
	constructor:(@relPosition, @context)->
		@passive = false
		@OnMouseOver = new Event()
		@OnMouseUp = new Event()
		@OnMouseExit = new Event()

		@borderMarginHeight = 2;
		@borderMarginWidth = 5;

		@mouseUpHandle  = ((evt) ->@onMouseUp(evt)).bind(@) 
		@mouseOverHandle= ((evt) ->@onMouseOver(evt)).bind(@)
		@mouseOutHandle	= ((evt) ->@onMouseOut(evt)).bind(@)

	SetPassive:()->
		@passive = true
		
	SetActive:()->
		@passive = false

	CreateGraphics:(graphics)->
		graphics.border = document.createElementNS("http://www.w3.org/2000/svg", 'rect');

		graphics.border.setAttribute("stroke", "none")
		graphics.border.setAttribute("x", 1)
		graphics.border.setAttribute("y", 5)
		graphics.border.setAttribute("height", @context.Size.y+@borderMarginHeight)
		graphics.border.setAttribute("width", @context.Size.x+@borderMarginWidth)
		graphics.border.setAttribute("fill-opacity", 0)

		graphics.border.addEventListener("mouseout",@mouseOutHandle );
		graphics.border.addEventListener("mouseover",@mouseOverHandle );
		graphics.border.addEventListener("mouseup", @mouseUpHandle);

	Resize:()->
		@context.graphics.border.setAttribute("height", @context.Size.y+@borderMarginHeight)
		@context.graphics.border.setAttribute("width", @context.Size.x+@borderMarginWidth)

	onMouseOver:()->
		if not @passive
			@context.DoHighlight()
		else
			@OnMouseOver.pulse(null)
		
	onMouseOut:()->
		if not @passive
			@context.DoUnhighlight()
		else
			@OnMouseExit.pulse(null)
		
	onMouseUp:()->
		if not @passive
			@context.OnSelect()
		else
			@OnMouseUp.pulse(null)

	Highlight:()->
		@context.graphics.border.setAttribute("stroke", "#3385D6")
	Unhighlight:()->
		@context.graphics.border.setAttribute("stroke", "none")