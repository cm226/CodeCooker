window.UML.Serialize.SerializeClasses= (serilizer)->
	classes = new Array()
	for classItem in globals.classes.List
		if !classItem.IsInterface
			classes.push(serilizer.SerializeItem(classItem.model))

	return classes;

window.UML.Serialize.SerializeInterfaces= (serilizer)->
	interfaces = new Array()
	for interfaceItem in globals.classes.List
		if interfaceItem.IsInterface
			interfaces.push(serilizer.SerializeItem(interfaceItem.model))

	return interfaces;


