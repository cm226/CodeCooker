class ResizeDragger
	constructor:(Position)->
		@onSizeChange = new Event();
		@onDragEnd = new Event();

		@Position = Position
		@rotation = 0;

		@mousemoveHandle = null
		@mousemoveUp = null
		@mousedownHandle = ((evt) ->@On_mouse_down(evt)).bind(@) 

	Rotate:(angle)->
		@rotation = angle;
		@graphics.group.setAttribute("transform","translate("+@Position.x+","+@Position.y+") rotate("+@rotation+")")

	Move:(To)->
		@Position = To
		@graphics.group.setAttribute("transform","translate("+@Position.x+","+@Position.y+") rotate("+@rotation+")")

	CreateGraphicsObject:()->
		@graphics = new Object();
		
		@graphics.group  = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.leftLine = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@graphics.rightLine = document.createElementNS("http://www.w3.org/2000/svg", 'line');

		@graphics.leftLine.setAttribute("x1","0");
		@graphics.leftLine.setAttribute("y1","0");
		@graphics.leftLine.setAttribute("x2","10");
		@graphics.leftLine.setAttribute("y2","0");
		
		@graphics.rightLine.setAttribute("x1","0");
		@graphics.rightLine.setAttribute("y1","0");
		@graphics.rightLine.setAttribute("x2","0");
		@graphics.rightLine.setAttribute("y2","10");

		@graphics.leftLine.setAttribute("class","Resizer")
		@graphics.rightLine.setAttribute("class","Resizer")
		@graphics.group.setAttribute("transform","translate("+@Position.x+","+@Position.y+") rotate("+@rotation+")")

		@graphics.group.addEventListener("mousedown",@mousedownHandle)
		@graphics.group.appendChild(@graphics.leftLine)
		@graphics.group.appendChild(@graphics.rightLine)

		return @graphics;


	show:(@docRoot)->
		docRoot.appendChild(@graphics.group)
	hide:(@docRoot)->
		docRoot.removeChild(@graphics.group)


	On_mouse_down:(evt) ->
		if(@mousemoveHandle == null && @mousemoveUp == null)
			@mousemoveHandle = ((evt) ->@On_mouse_move(evt)).bind(@) 
			@mousemoveUp  = ((evt) ->@On_mouse_up(evt)).bind(@)
			globals.document.addEventListener("mousemove",@mousemoveHandle,false);
			globals.document.addEventListener("mouseup", @mousemoveUp,false);

	On_mouse_move:(evt) ->
		loc=  window.UML.Utils.mousePositionFromEvent(evt)
		@Position= window.UML.Utils.fromSVGCoordForGroupedElement(loc,@docRoot)
		@onSizeChange.pulse(evt)

	On_mouse_up:(evt) ->
		globals.document.removeEventListener("mousemove",@mousemoveHandle, false);
		globals.document.removeEventListener("mouseup",@mousemoveUp, false);

		@mousemoveHandle = null
		@mousemoveUp = null

		@onDragEnd.pulse()