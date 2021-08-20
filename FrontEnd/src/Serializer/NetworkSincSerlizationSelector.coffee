class window.UML.Serialize.NetworkSincSerlizationSelector
	constructor:()->

	select:(modelObject)->
		if (modelObject.hasOwnProperty("modelItemID"))
			return new NetworkModelIdWrapperSerlizer(modelObject.modelItemID ,new ModelItemSerilzer(modelObject.model))

		else if(modelObject.hasOwnProperty("modelListID"))

			itemListModel = new Array();
			for subItem in modelObject.list
				itemListModel.push(subItem)
			
			return new NetworkModelListIdWrapperSerlizer(modelObject.modelListID, new ModelListSerlizer(itemListModel))

		else if (((typeof classItem == "object") && (classItem != null) ) && not jQuery.isFunction(classItem)) # if a complex data item)
			return new ComplexObjectSerlizer(modelObject)
			
		else
			return new BaseObjectSerlizer(modelObject);