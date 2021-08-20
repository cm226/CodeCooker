class window.UML.Unpacker.Unpacker
	constructor:(@unpackingStratagy)->


	Unpack:(model)->
		deepModel = JSON.parse(model)
		
		classList = deepModel.classList;
		interfaceList = deepModel.interfaceList
		namespaceList = deepModel.namespaceList
		arrowList = deepModel.arrowList

		classList = @UnpackObject(classList)
		interfaceList = @UnpackObject(interfaceList)
		namespaceList = @UnpackObject(namespaceList)
		arrowList = @UnpackObject(arrowList)

		if deepModel.Name
			window.UML.globals.CommonData.filename = deepModel.Name

		if deepModel.Version
			window.UML.globals.CommonData.version = deepModel.Version
		
		for classItem in classList.list
			globals.Model.classList.pushNoLog(classItem)

		for interfaceItem in interfaceList.list
			globals.Model.interfaceList.pushNoLog(interfaceItem)

		for namespace in namespaceList.list
			globals.Model.namespaceList.pushNoLog(namespace)

		for arrowModel in arrowList.list
			globals.Model.arrowList.pushNoLog(arrowModel);

	UnpackObject:(obj)->
		@unpackingStratagy.unpack(obj,@)

	UnpackArray:(obj, IDOverride)->
		
		# HACK allert
		# this hack means that if we have an array of basic items then a basic array of items is returned not a model list
		if obj.length > 0 && not (IDOverride?) && not (IDOverride > -1)
			if not window.UML.typeIsObject(obj[0]) && not window.UML.typeIsArray obj[0]
				modelList = new Array();
				for item in obj
					modelList.push(item)
				return modelList

		# non hacky bit
		if(IDOverride?)
			modelList = new window.UML.MODEL.ModelList(IDOverride)
		else
			modelList = new window.UML.MODEL.ModelList()

		for item in obj
			modelList.pushNoLog(@UnpackObject(item))

		return modelList

	UnpackItem:(obj, IDOverride)->
		if(IDOverride?)
			model = new window.UML.MODEL.ModelItem(IDOverride)
		else
			model = new window.UML.MODEL.ModelItem()

		for item of obj # unpack a model object
			if window.UML.typeIsObject(obj[item]) # if a complex data item
				model.setNoLog(item, @UnpackObject(obj[item]))
			else
				model.setNoLog(item, obj[item])

		return model


