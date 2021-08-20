class window.UML.Arrows.BendPoint
	constructor:(@position, @context)->
		@displayed = false;

	GetPosition:()-> @position

	CreateGraphicsObject:()->
		@endPoint = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
		@endPoint.setAttribute("r","5")
		@endPoint.setAttribute("cx",@position.x)
		@endPoint.setAttribute("cy",@position.y)
		@endPoint.setAttribute("class","ArrowBend")

		@Draggable = new window.UML.Interaction.Draggable(@On_Drag_Start.bind(@),
														@On_Drag.bind(@),
														@On_Drag_End.bind(@),
														@endPoint,
														@GetPosition.bind(@));

		@displayed = true;
		window.UML.globals.document.appendChild(@endPoint);

	del:()->
		@Hide()
		@Draggable.detatch_for_GC(@endPoint)
		@endpoint = null;
		@position = null;

	Move:(to)->
		@position = to;
		@endPoint.setAttribute("cx",@position.x)
		@endPoint.setAttribute("cy",@position.y)
		@segment1.Move(to);
		@segment2.Move(to);
		@context.redraw();

	ResetEndpoint1:(@segment1)->
		@position = @segment1.GetPosition();

	ResetEndpoint2:(@segment2)->
		@position = @segment2.GetPosition();

	On_Drag_Start:()->

	On_Drag:(to)->
		@Move(to)
	On_Drag_End:()->

	Show: () ->
		@displayed = true
		globals.document.appendChild(@endPoint)
	Hide: () ->
		@displayed = false
		globals.document.removeChild(@endPoint)


