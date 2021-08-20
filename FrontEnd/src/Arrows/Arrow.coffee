window.UML.Arrows.Arrow_On_Follow = new Event();
window.UML.Arrows.Arrow_Un_Follow = new Event();

class window.UML.Arrows.Arrow
	constructor: (@model)->
		
		@model.set("id",@model.modelItemID)
		@ARROW_HEAD_LENGTH = 10;
		@segments = new Array();
		@bendPoints = new Array();

		@hoveredLineSegment = null;

		@arrow = document.createElementNS("http://www.w3.org/2000/svg", 'use');
		@arrow.setAttributeNS('http://www.w3.org/1999/xlink','xlink:href','#arrowHeadU');
		@arrow.setAttribute("class","ArrowHead");
			
		@On_Follow_Handel = ((evt)->@On_Follow(evt)).bind(@);
		@On_UnFollow_Handel = ((evt)->@On_UnFollow(evt)).bind(@);
		@On_Mouse_down_handel = ((evt)->@OnMouseDown(evt)).bind(@);
		@On_Mouse_hover_handel = ((evt)->@OnMouseOver(evt)).bind(@);
		@On_Mouse_leave_handel = ((evt)->@OnMouseLeave(evt)).bind(@);

		start = @model.get("Head").get("Position")
		end = @model.get("Tail").get("Position")
		@firstSegment = new window.UML.Arrows.LineSegment(new Point(start.x,start.y), new Point(end.x,end.y))
		@arrowHead = new window.UML.Arrows.ArrowHeadPoint(@,@model.get("Head"))
		@arrowHead.Followed.add(@On_Follow_Handel)
		@arrowHead.UnFollowed.add(@On_UnFollow_Handel)
		@arrowTail = new window.UML.Arrows.ArrowTailPoint(@,@model.get("Tail"))
		@arrowTail.Followed.add(@On_Follow_Handel)
		@arrowTail.UnFollowed.add(@On_UnFollow_Handel)

		@firstSegment.Connect(@arrowTail,@arrowHead)

		@firstSegment.Clicked.add(@On_Mouse_down_handel);
		@firstSegment.MouseHover.add(@On_Mouse_hover_handel);
		@firstSegment.MouseLeave.add(@On_Mouse_leave_handel);

		@firstSegment.CreateGraphicsObject()
		@segments.push(@firstSegment)

		@model.onChange.add(((evt)->@On_Model_Change(evt)).bind(@))

		@CheckForArrowTypeChange()
		@redraw()
		globals.document.appendChild(@arrow)

		return

	Bend:(at)->
			newSegment = new window.UML.Arrows.LineSegment(at, new Point(@hoveredLineSegment.position2.x,@hoveredLineSegment.position2.y))
			newSegment.Clicked.add(@On_Mouse_down_handel);
			newSegment.MouseHover.add(@On_Mouse_hover_handel);
			newSegment.MouseLeave.add(@On_Mouse_leave_handel);

			@segments.push(newSegment)
			newBendPoint = new window.UML.Arrows.BendPoint(at,@)
			@bendPoints.push(newBendPoint)
			newBendPoint.CreateGraphicsObject();
			newSegment.CreateGraphicsObject();

			newSegment.Connect(newBendPoint,@hoveredLineSegment.Connection2)

			@hoveredLineSegment.Connect(@hoveredLineSegment.Connection1,newBendPoint)
			newBendPoint.Move(at);
			
			@CheckForArrowTypeChange()

	del: ()->
		globals.document.removeChild(@arrow)
		
		for segment in @segments
			do(segment)->
				segment.del()

		for bendPoint in @bendPoints
			do(bendPoint)->
				bendPoint.del();

		@arrowTail.del()
		@arrowHead.del()

		globals.arrows.remove(@model.get("id"))


	recalculateHeadAngle:(end)->
		if @arrowHead.arrowEndPoint # if this is not set we are not done initialising yet
			lastSegmentPos = @arrowHead.arrowEndPoint.ref.position1
			rad = Math.atan2((end.y - lastSegmentPos.y),(end.x - lastSegmentPos.x));
			deg = rad * (180/Math.PI)
			return deg + 90
		else 
			return 0;


	redraw:->
		end = @arrowHead.getLastestPosition(); # redraw with the latest value of the position
		start = @arrowTail.getLastestPosition();

		@arrowHead.Redraw()
		@arrowTail.Redraw()

		for segment in @segments
			do(segment)->
				segment.Redraw()

		arrowHeadAng = @recalculateHeadAngle(end)
		arrowHeadAngRad = arrowHeadAng* (Math.PI / 180)
		xLineOffset = Math.sin(arrowHeadAngRad) * @ARROW_HEAD_LENGTH
		yLineOffset = Math.cos(arrowHeadAngRad) * @ARROW_HEAD_LENGTH


		@arrow.setAttribute("x",end.x)
		@arrow.setAttribute("y",end.y)
		@arrow.setAttribute("transform","rotate("+arrowHeadAng.toString()+" "+end.x+" "+end.y+")")
		return

	setDashedArrow: ->
		for segment in @segments
			do(segment)->
				segment.SetDashedArrow()

	setNormalArrow:->
		for segment in @segments
			do(segment)->
				segment.SetNormalArrow()

	deactivate:->
		if @active
			@active = false
			@arrowHead.Hide()
			@arrowTail.Hide()
			for bendpoint in @bendPoints
				do(bendpoint)->
					bendpoint.Hide();
			
			@OnMouseLeave()
		return

	OnMouseDown:(evt) ->
		@active = true;
		@arrowHead.Show();
		@arrowTail.Show();
		for bendpoint in @bendPoints
			do(bendpoint)->
				bendpoint.Show();

		evt.arrow = @
		window.UML.Pulse.SingleArrowActivated.pulse(evt)

	OnMouseOver:(evt) ->
		@hoveredLineSegment = evt.lineSegment;
		globals.highlights.HighlightArrow(@);

	OnMouseLeave:(evt) ->
		globals.highlights.UnHighlightArrow();

	Unhighlight:()->
		if not @active
			for segment in @segments
				do(segment)->
					segment.ArrowUnHover()

		$(@arrow).removeClass("ArrowHeadHover")	

	Highlight:()->
		for segment in @segments
			do(segment)->
				segment.ArrowHover()
		$(@arrow).addClass("ArrowHeadHover")

	DisablePointerEvents: ->
		@arrow.setAttribute("pointer-events","none");
		for segment in @segments
				do(segment)->
					segment.DisablePointerEvents()
		return

	CheckForArrowTypeChange: ->
		@setNormalArrow();
		if(@model.get("Head").get("Locked") && @model.get("Tail").get("Locked"))
			headClass = globals.classes.get(@model.get("Head").get("LockedClass"))

			if headClass.IsInterface
				@setDashedArrow()

	EnablePointerEvents: ->
		@arrow.setAttribute("pointer-events","all");
		for segment in @segments
			do(segment)->
				segment.EnablePointerEvents()
		return 

	On_Follow:()->
		@DisablePointerEvents()
		window.UML.Arrows.Arrow_On_Follow.pulse()

	On_UnFollow:()->
		@EnablePointerEvents()
		window.UML.Arrows.Arrow_Un_Follow.pulse()

	On_Model_Change:(evt)->
