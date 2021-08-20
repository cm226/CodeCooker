class window.UML.MODEL.Arrow extends window.UML.MODEL.ModelItem
	constructor:()->
		super()
		
		@setNoLog("Head",new window.UML.MODEL.ModelItem())
		@setNoLog("Tail", new window.UML.MODEL.ModelItem())
		
