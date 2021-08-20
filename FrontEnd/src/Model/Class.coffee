class window.UML.MODEL.Class extends window.UML.MODEL.ModelItem
	constructor:()->
		super()

		@setNoLog("Properties", new window.UML.MODEL.ModelItem())
		@setNoLog("Methods", new window.UML.MODEL.ModelItem())

		@get("Properties").setNoLog("Items", new window.UML.MODEL.ModelList())
		@get("Methods").setNoLog("Items", new window.UML.MODEL.ModelList())
