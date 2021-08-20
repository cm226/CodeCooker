class window.UML.Arrows.ArrowTailPoint extends window.UML.Arrows.ArrowEndPoint
	constructor:(@arrow, @model) ->
		super(@arrow, @model)

		@model.set("Locked", true)
		@endPoint.setAttribute("onmousedown","window.UML.SetArrowTailFollow("+@arrow.model.get("id")+")")
		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))

		connectTest = @model.get("Locked")
		connectTest = connectTest and @model.get("LockedClass") and @model.get("LockedClass") != -1
		connectTest = connectTest and @model.get("LockedIndex") and @model.get("LockedIndex") != -1

		if connectTest
				@Connection.ReconnectFrom(@model.get("LockedClass"), @model.get("LockedIndex"))

	OnMouseUp:(evt)->
		@UnFollow()

	Follow: ()->
		super
		@mouseUpHandle = ((evt) ->@OnMouseUp(evt)).bind(@)
		document.addEventListener("mouseup", @mouseUpHandle, false);

		@Connection.Disconnect();

	OnModelChange:(evt)->
		if evt.name  == "Position"
			@position.x = evt.new_value.x
			@position.y = evt.new_value.y
		else if evt.name == "Locked"
			if !evt.new_value
				@Connection.Disconnect();
		else if evt.name == "LockedClass"
			if @model.get("Locked") and @model.get("LockedClass") != -1 and @model.get("LockedIndex") != -1
				@Connection.ReconnectFrom(@model.get("LockedClass"), @model.get("LockedIndex"))
				@arrow.CheckForArrowTypeChange();
		else if evt.name == "LockedIndex"
			@lockedIndex = evt.new_value

		@arrow.redraw()

	UnFollow: ()->
		#Check to see if the class is being connected to itself if so then veto the connection
		if @preliminaryLockedData.LockedClass != @arrow.model.get("Head").get("LockedClass") ||
		@preliminaryLockedData.LockedClass == -1
			@ApplyPrelimineryLockData();
		else
			Debug.write("Arrow Connection Vetoed (same class)")

		@ResetPreliminery();
		document.removeEventListener("mouseup", @mouseUpHandle, false);
		@mouseUpHandle =0
		@model.set("Position",@position)

		super

	del: ()->
		super
		
		@Connection.Disconnect();