class window.UML.Arrows.ArrowEndPoint
	constructor: (@context, @model) ->
		@displayed = false
		@inArrowFollow = false
		@endPoint = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
		@endPoint.setAttribute("r","5")
		@endPoint.setAttribute("fill","#3385D6")
		@endPoint.setAttribute("class","arrowDrag")

		@preliminaryLockedData = {};
		@preliminaryLockedData.Position = @model.get("Position")
		@latestPositionForDraw = @model.get("Position")

		@Followed = new Event();
		@UnFollowed = new Event()

		@position = @model.get("Position") # cach a copy of the model position

		@Connection = new window.UML.Arrows.ArrowConnection(@arrow)

	getLastestPosition: ()->
		if @inArrowFollow
			return @preliminaryLockedData.Position
		else
			return @model.get("Position")

	del: ()->
		if @displayed
			globals.document.removeChild(@endPoint)

	Show: () ->
		@displayed = true
		globals.document.appendChild(@endPoint)
	Hide: () ->
		@displayed = false
		globals.document.removeChild(@endPoint)

	Redraw:() ->
		pos = @getLastestPosition();
		if @arrowEndPoint
			@arrowEndPoint.Move(pos);
			
		@endPoint.setAttribute("cx",pos.x)
		@endPoint.setAttribute("cy",pos.y)

	ResetEndpoint1:(@arrowEndPoint)->
		
	ResetEndpoint2:(@arrowEndPoint)->

	OnMouseMove:(evt) ->
		if @preliminaryLockedData.Locked
			return

		loc = window.UML.Utils.mousePositionFromEvent(evt);

		@preliminaryLockedData.Position = loc
		@context.redraw();
		return

	OnDropZoneActive:(evt)->
		@preliminaryLockedData.Locked = true;
		@preliminaryLockedData.LockedClass = evt.classID
		@preliminaryLockedData.LockedIndex = evt.index
		@preliminaryLockedData.Position = evt.position
		@position = evt.position;

		@context.redraw();
		return

	OnDropZoneLeave:(evt)->
		@preliminaryLockedData.Locked = false;
		@preliminaryLockedData.LockedClass = -1
		@preliminaryLockedData.LockedIndex = 0
		return

	Follow:()->
		@inArrowFollow = true
		@Followed.pulse()
		@endPoint.setAttribute("pointer-events","none");

		@mouseMoveHandle = ((evt) ->@OnMouseMove(evt)).bind(@) 
		@dropZoneLeave = ((evt) ->@OnDropZoneLeave(evt)).bind(@)
		@dropZoneActive = ((evt) ->@OnDropZoneActive(evt)).bind(@)

		document.addEventListener("mousemove",@mouseMoveHandle,false);

		window.UML.Pulse.DropZoneEnter.add(@dropZoneActive)	
		window.UML.Pulse.DropZoneLeave.add(@dropZoneLeave)	

	UnFollow:()->
		@inArrowFollow = false
		document.removeEventListener("mousemove",@mouseMoveHandle,false);
		window.UML.Pulse.DropZoneEnter.remove(@dropZoneActive)
		window.UML.Pulse.DropZoneLeave.remove(@dropZoneLeave)
		@mouseMoveHandle = 0
		@dropZoneLeave = 0
		@dropZoneActive = 0

		@UnFollowed.pulse()
		@endPoint.setAttribute("pointer-events","all");

	# This method applys the model data stored in the preliminaryLockedData
	# the preliminaryLockedData is populated when the arrow is being dragged arround
	ApplyPrelimineryLockData:()->
		@model.setGroup([{name: "Position", value: @preliminaryLockedData.Position},
						 {name: "Locked", value: @preliminaryLockedData.Locked},
						 {name: "LockedIndex", value: @preliminaryLockedData.LockedIndex},
						 {name: "LockedClass", value: @preliminaryLockedData.LockedClass}]);
	
	ResetPreliminery:()->
		@preliminaryLockedData.Position = @model.get("Position")
		@preliminaryLockedData.Locked = @model.get("Locked")
		@preliminaryLockedData.LockedIndex = @model.get("LockedIndex")
		@preliminaryLockedData.LockedClass = @model.get("LockedClass")