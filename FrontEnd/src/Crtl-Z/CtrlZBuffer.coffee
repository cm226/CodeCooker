class window.UML.Ctrlz.CtrlzBuffer
	constructor:()->
		@ZBufferStack = new Array()
		@UndoHandl = (@Undo).bind(@)
		@RedoHandl = (@Redo).bind(@)
		@bufferSize = 30
		@bufferIndex = -1
		@started = false;

	Start:()->
		window.UML.globals.KeyboardListener.RegisterKeyWithAlthernate(window.UML.AlternateKeys.CTRL,'Z'.charCodeAt(0),@UndoHandl)
		window.UML.globals.KeyboardListener.RegisterKeyWithAlthernate(window.UML.AlternateKeys.CTRL,'Y'.charCodeAt(0),@RedoHandl)
		@started = true;

	flushBuffer:()->
		@ZBufferStack = []
		@bufferIndex = -1;


	Push:(action)->
		if @started
			if @ZBufferStack.length > @bufferSize
				@ZBufferStack.shift()
				@bufferIndex--

			@bufferIndex++
			@ZBufferStack[@bufferIndex] = action;

			@ZBufferStack.splice(@bufferIndex+1, @bufferSize-@bufferIndex); #invalidate all actions after current index (so that after a push you cannot "Redo" old actions)

	Redo:()->
		
		redoAction = @ZBufferStack[@bufferIndex+1]
		if redoAction
			@bufferIndex++;
			Debug.write("Redo Action: "+Debug.unpack(redoAction))
			@SendAction(redoAction)

	clone:(obj)->
		
		if null == obj || "object" != typeof obj
			return obj;

		copy = obj.constructor();
		
		for attr of obj
			if obj.hasOwnProperty(attr)
				copy[attr] = obj[attr];
		
		return copy;

	Undo:()->
		undoAction = @ZBufferStack[@bufferIndex]
		if undoAction
			@bufferIndex--;
			undoAction = @InvertAction(@clone(undoAction))
			Debug.write("Undo Action: "+Debug.unpack(undoAction))
			@SendAction(undoAction)

	InvertAction:(action)->
		if action.hasOwnProperty("modelListID")
			if action.changeType == "DEL"
				action.changeType = "ADD"
			else
				action.changeType = "DEL"
		else if action.hasOwnProperty("modelID")
			if action.hasOwnProperty("names") # if set is a multi value set
					prevValues = action.prev_values
					action.prev_values = action.values
					action.values = prevValues
			else
					prevValue = action.prev_value
					action.prev_value = action.values
					action.value = prevValue
		action
		
	SendAction:(action)->
		if action
			if action.hasOwnProperty("modelListID")

				modelList = window.UML.MODEL.ModelLists.get(action.modelListID)
				if action.changeType == "DEL"
					modelList.removeNoLog(action.item)
				else if action.changeType == "ADD"
					modelList.pushNoLog(action.item)

			else if action.hasOwnProperty("modelID") 
				if action.hasOwnProperty("names") # if set is a multi value set
					((i)->
						modelItem = window.UML.MODEL.ModelItems.get(action.modelID);
						modelItem.setNoLog(action.names[i],action.values[i]);)(i) for i in [0 .. action.names.length]
				else
					modelItem = window.UML.MODEL.ModelItems.get(action.modelID);
					modelItem.setNoLog(action.name,action.value);
