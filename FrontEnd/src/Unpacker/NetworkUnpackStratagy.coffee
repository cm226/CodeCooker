class window.UML.Unpacker.NetworkUnpackStratagy
	constructor:()->

	unpack:(item, unpacker)->
		
		if item.hasOwnProperty("model")
			@unpackModelWrapedElement(unpacker, item)
		else
			@unpackElement(unpacker, item)
	
	unpackModelWrapedElement:(unpacker, modelItem)->
		if window.UML.typeIsArray modelItem.model
			return unpacker.UnpackArray(modelItem.model, modelItem.modelListID)
		else
			return unpacker.UnpackItem(modelItem.model, modelItem.modelItemID)

	unpackElement:(unpacker, modelItem)->
		if window.UML.typeIsArray modelItem
			return unpacker.UnpackArray(modelItem, -2)
		else
			return unpacker.UnpackItem(modelItem, -2)    	