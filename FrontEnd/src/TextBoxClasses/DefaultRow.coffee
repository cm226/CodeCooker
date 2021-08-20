class DefaultRow
	constructor:(width,@position)->
		@Size = new Point(width, 20)
		@onSizeChange = new Event();
		@highlightBox = new HighlightableTextBox(new Point(0,0),@)
		@routeResolver = undefined;

	CreateGraphics:(@RowNumber)->
		@graphics = new Object();
		@graphics

	Move:(@position)->
		@graphics.group.setAttribute("transform", "translate("+@position.x+" "+@position.y+")")

	Highlight:()->
		@highlightBox.Highlight()
	Unhighlight:()->
		@highlightBox.Unhighlight()

	DoHighlight:()->
		window.UML.globals.highlights.HighlightTextElement(@)
	DoUnhighlight:()->
		window.UML.globals.highlights.UnHighlightTextElement(@)

	Resize:()->
		@highlightBox.Resize()

	OnTextElemetChangeSizeHandler:(evt)->
		@ReCalculateSize()
		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)

