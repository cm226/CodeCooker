window.UML.MODEL.ModelLists = new IDIndexedList((modelList)-> modelList.modelListID)

class window.UML.MODEL.ModelList
	constructor:(IDOverride)->

		IDOverride ?= -1;

		if(IDOverride != -1)
			@modelListID = IDOverride;
			window.UML.MODEL.ModelGlobalUtils.ListIDManager.AllocateOverrideID(IDOverride)
		else
			@modelListID = window.UML.MODEL.ModelGlobalUtils.ListIDManager.AllocateID()

		window.UML.MODEL.ModelLists.add(@)
		@list = new Array();
		@onChange = new Event()
		@onChangeInternal = new Event()
		@onDelete = new Event()
		@onDeleteHandler = (((evt)-> @onChildDelete(evt)).bind(@))

		window.UML.MODEL.ModelGlobalUtils.listener.ListenToNewMode(@)

	pushNoLog:(item)->
		@list.push(item)
		item.onDelete.add(@onDeleteHandler)
		
		evt = {modelListID: @modelListID, changeType: "ADD", item: item}
		@onChange.pulse(evt)
		@onChangeInternal.pulse(evt)
		return evt

	##########################################################################
	# This function should be used to update the model from the				 #
	# network layer, This prevents model updated from bouncing back out		 #
	# of the model and over the network again (via events)					 #
	##########################################################################
	pushFromNetwork:(item)->
		@list.push(item)
		item.onDelete.add(@onDeleteHandler)
		
		evt = {modelListID: @modelListID, changeType: "ADD", item: item}
		@onChange.pulse(evt)
		return evt

	push:(item)->
		evt = @pushNoLog(item)
		globals.CtrlZBuffer.Push(evt)

	removeAtNoLog:(index)->
		removed = @list.splice(index,1)
		
		if removed.length > 0
			removed[0].flagAsInvalid();
			evt = {modelListID: @modelListID, changeType: "DEL", item: removed[0]}
			@onChange.pulse(evt)
			@onChangeInternal.pulse(evt)

			removed[0].onDelete.remove(@onDeleteHandler)
			removed[0].onDelete.pulse(evt)
			return evt
		return false

	removeAt:(index)->
		evt = @removeAtNoLog(index)
		if evt
			globals.CtrlZBuffer.Push(evt)
		
	remove:(item)->
		itemIndex = @list.indexOf(item)
		if(itemIndex > -1)
			@removeAt(itemIndex)

	##########################################################################
	# This function should be used to update the model from the				 #
	# network layer, This prevents model updated from bouncing back out		 #
	# of the model and over the network again (via events)					 #
	##########################################################################
	removeFromNetwork:(item)->
		itemIndex = @list.indexOf(item)
		if(itemIndex > -1)
			removed = @list.splice(itemIndex,1)
			if removed.length > 0
				removed[0].flagAsInvalid();
				evt = {modelListID: @modelListID, changeType: "DEL", item: removed[0]}
				@onChange.pulse(evt)

				removed[0].onDelete.remove(@onDeleteHandler)
				removed[0].onDelete.pulse(evt)
				return evt
			return false



	removeNoLog:(item)->
		itemIndex = @list.indexOf(item)
		if(itemIndex > -1)
			@removeAtNoLog(itemIndex)

	onChildDelete:(evt)->
		@remove(evt.item)

	clear:()->
		while @list.length > 0
			@list[0].del()
		@list = []

	del:()->
		@clear()
		@onDelete.pulse({item:@})
		window.UML.MODEL.ModelLists.remove(@modelListID)
