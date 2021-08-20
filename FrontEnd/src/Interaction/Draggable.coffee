class window.UML.Interaction.Draggable
	constructor:(@on_drag_start, @on_drag, @on_drag_end, object, @getPosition)->
		@mouse_down_Handel = ((evt) ->@on_mouse_down(evt)).bind(@)
		@mouse_move_Handle = null
		@mouse_move_Up_Handle = null

		object.addEventListener("mousedown", @mouse_down_Handel, false);

	detatch_for_GC:(object)->
		object.removeEventListener("mousedown", @mouse_down_Handel, false);
		@mouse_down_Handel = null;

	on_mouse_down:(evt)->
		if(@mouse_move_Handle == null && @mouse_move_Up_Handle == null && evt.button != rightMouse)
			@mouse_move_Handle = ((evt) ->@on_mouse_move(evt)).bind(@) 
			@mouse_move_Up_Handle  = ((evt) ->@on_mouse_up(evt)).bind(@)

			@cursorDelta = new Point(0,0);
			@cursorDelta = @cursorDelta.add(window.UML.Utils.mousePositionFromEvent(evt))
			@cursorDelta = @cursorDelta.sub(@getPosition());

			globals.document.addEventListener("mousemove",@mouse_move_Handle,false);
			globals.document.addEventListener("mouseup", @mouse_move_Up_Handle,false);

			@on_drag_start();

	on_mouse_up:(evt)->
		globals.document.removeEventListener("mousemove",@mouse_move_Handle,false);
		globals.document.removeEventListener("mouseup", @mouse_move_Up_Handle,false);

		@mouse_move_Handle = null;
		@mouse_move_Up_Handle = null;

		@cursorDelta = null;

		@on_drag_end();


	on_mouse_move:(evt)->
		loc = window.UML.Utils.mousePositionFromEvent(evt)
		moveTo = new Point(loc.x, loc.y)
		
		@on_drag(moveTo.sub(@cursorDelta))

