class window.UML.Serialize.SerializeModel

	constructor:(@serialiseSelector)->

	Serialize:()->
		model = new Object()
		model["Name"] =  window.UML.globals.CommonData.filename;
		model["Version"] = window.UML.globals.CommonData.version;
		classList = window.UML.Serialize.SerializeClasses(@);
		interfaceList = window.UML.Serialize.SerializeInterfaces(@);
		namespaceList = window.UML.Serialize.SerializeNamespaces(@);
		arrowList = window.UML.Serialize.SerializeArrows(@);

		
		model["classList"] = classList
		model["arrowList"] = arrowList
		model["interfaceList"] = interfaceList;
		model["namespaceList"] = namespaceList;

		if Debug.IsDebug
			modelText = JSON.stringify(model,null, '\t')
		else
			modelText = JSON.stringify(model)
			
		return modelText

	SerializeItem:(item)->
	
		serilzer = @serialiseSelector.select(item)
		return serilzer.serialize(@serialiseSelector)