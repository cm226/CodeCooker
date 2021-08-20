class window.UML.Arrows.ArrowHeadPoint extends window.UML.Arrows.ArrowEndPoint
	constructor:(@arrow,@model) ->
		super(@arrow, @model)
		@endPoint.setAttribute("onmousedown","window.UML.SetArrowHeadFollow("+@arrow.model.get("id")+")")
		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))

		if @model.get("Locked") and @model.get("LockedClass") != -1 and @model.get("LockedIndex") != -1
				@Connection.ReconnectTo(@model.get("LockedClass"), @model.get("LockedIndex"))
		

	OnMouseUp:(evt)->
		@UnFollow()

	Follow: ()->
		super
		@mouseUpHandle = ((evt) ->@OnMouseUp(evt)).bind(@)
		document.addEventListener("mouseup", @mouseUpHandle, false);
		@Connection.Disconnect();
		

	UnFollow: ()->
		#Check to see if the class is being connected to itself if so then veto the connection
		if @preliminaryLockedData.LockedClass != @arrow.model.get("Tail").get("LockedClass") ||
		@preliminaryLockedData.LockedClass == -1
			@ApplyPrelimineryLockData();
		else
			Debug.write("Arrow ConnectionVetoed (same class)")
		@ResetPreliminery();
		document.removeEventListener("mouseup", @mouseUpHandle, false);
		@mouseUpHandle =0

		super

	OnModelChange:(evt)->
		if evt.name  == "Position"
			@position.x = evt.new_value.x
			@position.y = evt.new_value.y
		else if evt.name == "Locked"
			@CheckForConnectionChange()
		else if evt.name == "LockedIndex"
			@CheckForConnectionChange()
		else if evt.name == "LockedClass"
			@CheckForConnectionChange()

		@arrow.redraw()

	CheckForConnectionChange:()->
		if @model.get("Locked") and @model.get("LockedClass") != -1 and @model.get("LockedIndex") != -1
			@Connection.ReconnectTo(@model.get("LockedClass"), @model.get("LockedIndex"))
			@arrow.CheckForArrowTypeChange();
		else
			@Connection.Disconnect();

	del: ()->
		super
		@Connection.Disconnect();