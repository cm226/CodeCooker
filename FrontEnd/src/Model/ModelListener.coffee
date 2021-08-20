class window.UML.MODEL.ModelListener
	constructor:(modelLists, modelItems)->
		@onModelChange = new Event()

		for list in modelLists
			@ListenToNewMode(list)

		for item in modelItems
			@ListenToNewMode(item)

		@PulseModelChangeFunc = (evt) -> @onModelChange.pulse(evt);

	ListenToNewMode:(model)->
		model.onChangeInternal.add(@PulseModelChange.bind(@))

	StopListening:()->
		@PulseModelChangeFunc = (evt)->
	
	PulseModelChange:(evt)->
		@PulseModelChangeFunc(evt)


