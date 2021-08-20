window.UML.Pulse.DropZoneEnter = new Event()
window.UML.Pulse.DropZoneLeave = new Event()

class DropZone
	constructor:(@index) ->
		window.UML.Arrows.Arrow_On_Follow.add((@Show).bind(@));
		window.UML.Arrows.Arrow_Un_Follow.add((@Hide).bind(@));

	Move:(To) ->
		@position = To
		@Redraw()

	CreateGraphics:(@classID) ->
		@graphics = new Object()

		@graphics.arrowDrop = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
		@graphics.arrowDrop.setAttribute("cx", @position.x);
		@graphics.arrowDrop.setAttribute("cy", @position.y);
		@graphics.arrowDrop.setAttribute("r", "3");
		@graphics.arrowDrop.setAttribute("style", "fill:none");

		@graphics.hiddenDropRange = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
		
		@graphics.hiddenDropRange.setAttribute("onmousedown","window.UML.globals.classes.get("+@classID+").DropZones["+@index+"].OnMouseDown(evt);");
		@graphics.hiddenDropRange.setAttribute("class","dropZone");
		@graphics.hiddenDropRange.setAttribute("cx", @position.x);
		@graphics.hiddenDropRange.setAttribute("cy", @position.y);
		@graphics.hiddenDropRange.setAttribute("r", "20");
		@graphics.hiddenDropRange.setAttribute("style","fill-opacity:0.0");	
		@graphics.hiddenDropRange.setAttribute("onmouseover", "window.UML.globals.classes.get("+@classID+").DropZones["+@index+"].OnMouseOver(evt);");
		@graphics.hiddenDropRange.setAttribute("onmouseout", "window.UML.globals.classes.get("+@classID+").DropZones["+@index+"].OnMouseOut(evt)");
		return @graphics

	Redraw:() ->
		@graphics.arrowDrop.setAttribute("cx", @position.x);
		@graphics.arrowDrop.setAttribute("cy", @position.y);
		@graphics.hiddenDropRange.setAttribute("cx", @position.x);
		@graphics.hiddenDropRange.setAttribute("cy", @position.y);

	Hide:()->
		@graphics.arrowDrop.setAttribute("style", "fill:none");

	Show:()->
		@graphics.arrowDrop.setAttribute("style", "fill:black");

	OnMouseOver:(evt) ->
		$(@graphics.hiddenDropRange).animate({'fill-opacity': 0.15}, 100)

		evt.position = @GetSnapPosition()
		evt.classID = @classID
		evt.index = @index
		window.UML.Pulse.DropZoneEnter.pulse(evt)

	OnMouseOut:(evt) ->
		$(@graphics.hiddenDropRange).stop()
		@graphics.hiddenDropRange.setAttribute("style","fill-opacity:0.0");
		window.UML.Pulse.DropZoneLeave.pulse(evt)

	OnMouseDown:(evt) ->

		arrow = globals.arrows.Create(@GetSnapPosition(),
											 window.UML.Utils.mousePositionFromEvent(evt),
											 @classID,
											 @index)
		arrow.arrowHead.Follow()

	GetSnapPosition:() ->
		window.UML.Utils.getSVGCoordForGroupedElement(@graphics.arrowDrop).add(@position)
