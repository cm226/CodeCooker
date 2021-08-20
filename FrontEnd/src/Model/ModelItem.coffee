window.UML.MODEL.ModelItems = new IDIndexedList((modelItem)-> modelItem.modelItemID)

class window.UML.MODEL.ModelItem
	constructor:(IDOverride)->
		IDOverride ?= -1;

		if(IDOverride != -1)
			@modelItemID = IDOverride;
			window.UML.MODEL.ModelGlobalUtils.ItemIDManager.AllocateOverrideID(IDOverride)
		else
			@modelItemID = window.UML.MODEL.ModelGlobalUtils.ItemIDManager.AllocateID()

		window.UML.MODEL.ModelItems.add(@);

		@model = new Object()
		@onChange = new Event()			#event that is fired when model is changed
		@onChangeInternal = new Event() #event thet is fired when model is changed by this client
		@onDelete = new Event()
		@modelValid = true

		window.UML.MODEL.ModelGlobalUtils.listener.ListenToNewMode(@)

	#####################################################################
	# This Method should be called when the ModelItem is 				#
	# in the process of being deleted, seeting the invalid flag will	#
	# prevent any further model changes from occuring					#
	#####################################################################
	flagAsInvalid:()->
		@modelValid = false

	#####################################################################
	# This Method should be called when the ModelItem is 				#
	# first created and ensures that the model changes will react       #
	# properly                                                          #
	#####################################################################
	flagAsValid:()->
		@modelValid = true		

	######################################################################
	# Calling this method will set the value of this model, but will not #
	# log the change to the undo buffer									 #
	#																	 #
	######################################################################
	setNoLog:(name, value, pulseAnyway)->
		pulseAnyway ?= false;
		if @modelValid and (pulseAnyway || @model[name] != value)
			@model[name] = value
			@onChange.pulse({modelID: @modelItemID, name: name, new_value: value, prev_value: @model[name]})
			@onChangeInternal.pulse({modelID: @modelItemID, name: name, new_value: value, prev_value: @model[name]})

	set:(name, value)->
		if @modelValid and @model[name] != value
			evt = {modelID: @modelItemID, name: name, prev_value: @model[name], value: value}
			globals.CtrlZBuffer.Push(evt)
			@setNoLog(name,value)

	##########################################################################
	# This function should be used to update the model with updated from the #
	# network layer, This prevents model updated from bouncing back out		 #
	# of the model and over the network again (via events)					 #
	##########################################################################
	setFromNetwork:(name, value, pulseAnyway)->
		pulseAnyway ?= false;
		if @modelValid and (pulseAnyway || @model[name] != value)
			@model[name] = value
			@onChange.pulse({modelID: @modelItemID, name: name, new_value: value, prev_value: @model[name]})

	setGroup:(keyValues)->
		if @modelValid
			ref = @
			names = []
			previousValues =[]
			newValues = []

			for keyValue in keyValues
				do(ref,keyValue)->
					names.push(keyValue.name)
					previousValues.push(ref.model[keyValue.name])
					newValues.push(keyValue.value)
					ref.setNoLog(keyValue.name, keyValue.value, true)

			evt = {modelID: @modelItemID, names:names, prev_values: previousValues, newValues: newValues}
			globals.CtrlZBuffer.Push(evt)

	get:(name)-> @model[name];

	del:()->
		for item, value of @model
			if value && (value.hasOwnProperty("modelItemID") || value.hasOwnProperty("modelListID"))
				value.del();

		window.UML.MODEL.ModelItems.remove(@modelItemID)
		@onDelete.pulse({item:@})