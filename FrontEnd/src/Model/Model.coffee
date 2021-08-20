class window.UML.MODEL.MODEL
	constructor:()->
		@classList = new window.UML.MODEL.ModelList()
		@interfaceList = new window.UML.MODEL.ModelList()
		@namespaceList = new window.UML.MODEL.ModelList()
		@arrowList = new window.UML.MODEL.ModelList()

	clearModel:()->
		@classList.clear()
		@interfaceList.clear()
		@namespaceList.clear()
		@arrowList.clear()
