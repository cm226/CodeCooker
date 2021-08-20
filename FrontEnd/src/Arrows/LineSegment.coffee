class window.UML.Arrows.EndpointConnector1
	constructor:(@ref)->

	Move:(to)-> @ref.MoveEnd1(to);
	GetPosition:()-> @ref.position1;


class window.UML.Arrows.EndpointConnector2
	constructor:(@ref)->

	Move:(to)-> @ref.MoveEnd2(to);
	GetPosition:()-> @ref.position2;


class window.UML.Arrows.LineSegment
	constructor:(@position1, @position2)->

		@OnClickHandel = ((evt) ->@On_Click(evt)).bind(@)
		@OnHoverHandel = ((evt) ->@On_Hover(evt)).bind(@)
		@OnLeaveHandel = ((evt) ->@On_Leave(evt)).bind(@)

		@Clicked = new Event();
		@MouseHover = new Event();
		@MouseLeave = new Event();

		@endpoint1 = new window.UML.Arrows.EndpointConnector1(@)
		@endpoint2 = new window.UML.Arrows.EndpointConnector2(@)


	Connect:(@Connection1, @Connection2)->
		@Connection1.ResetEndpoint1(@Endpoint1())
		@Connection2.ResetEndpoint2(@Endpoint2())

	Endpoint1:()-> @endpoint1;
	Endpoint2:()-> @endpoint2;

	MoveEnd1:(to)->
		@position1 = to;
		@line.setAttribute("x1",@position1.x)
		@line.setAttribute("y1",@position1.y)
		@hitbox.setAttribute("x1",@position1.x)
		@hitbox.setAttribute("y1",@position1.y)

	MoveEnd2:(to)->
		@position2 = to;
		@line.setAttribute("x2",@position2.x)
		@line.setAttribute("y2",@position2.y)
		@hitbox.setAttribute("x2",@position2.x)
		@hitbox.setAttribute("y2",@position2.y)

	Redraw:()->
		@line.setAttribute("x1",@position1.x)
		@line.setAttribute("y1",@position1.y)
		@hitbox.setAttribute("x1",@position1.x)
		@hitbox.setAttribute("y1",@position1.y)
		
		@line.setAttribute("x2",@position2.x)
		@line.setAttribute("y2",@position2.y)
		@hitbox.setAttribute("x2",@position2.x)
		@hitbox.setAttribute("y2",@position2.y)

	del:()->
		globals.document.removeChild(@line)
		globals.document.removeChild(@hitbox)


	CreateGraphicsObject:()->
		@line = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@line.setAttribute("x1",@position1.x)
		@line.setAttribute("y1",@position1.y)
		@line.setAttribute("x2",@position2.x)
		@line.setAttribute("y2",@position2.y)
		@line.setAttribute("class","ArrowLine")

		@hitbox = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@hitbox.setAttribute("style","fill-opacity:1.0;stroke-width:20");
		@hitbox.setAttribute("pointer-events", "all");
		@hitbox.addEventListener("mousedown", @OnClickHandel, false);
		@hitbox.addEventListener("mouseover", @OnHoverHandel, false);
		@hitbox.addEventListener("mouseleave", @OnLeaveHandel, false);

		@hitbox.setAttribute("x1",@position1.x)
		@hitbox.setAttribute("y1",@position1.y)
		@hitbox.setAttribute("x2",@position2.x)
		@hitbox.setAttribute("y2",@position2.y)

		window.UML.globals.document.appendChild(@line);
		window.UML.globals.document.appendChild(@hitbox);

	EnablePointerEvents:()->
		@line.setAttribute("pointer-events","all");
		@hitbox.setAttribute("pointer-events","all");

	DisablePointerEvents:()->
		@line.setAttribute("pointer-events","none");
		@hitbox.setAttribute("pointer-events","none");

	SetNormalArrow:()->
		@line.setAttribute("stroke-dasharray","0")

	SetDashedArrow:()->
		@line.setAttribute("stroke-dasharray","5, 5")

	ArrowHover:()->
		$(@line).addClass("ArrowOutlineHover")

	ArrowUnHover:()->
		$(@line).removeClass("ArrowOutlineHover")		

	On_Click:(evt)->
		@Clicked.pulse(evt)

	On_Hover:(evt)->
		evt.lineSegment = @;
		@MouseHover.pulse(evt)

	On_Leave:(evt)->
		@MouseLeave.pulse()