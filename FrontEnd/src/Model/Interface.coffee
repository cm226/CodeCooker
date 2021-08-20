class window.UML.MODEL.Interface extends window.UML.MODEL.ModelItem
	constructor:()->
		super()
		@setNoLog("Methods", new window.UML.MODEL.ModelItem())
		@get("Methods").setNoLog("Items", new window.UML.MODEL.ModelList)
