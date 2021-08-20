window.UML.Serialize.SerializeNamespaces= (serilizer)->
	namespaces = new Array()
	for ns in globals.namespaces.List
		namespaces.push(serilizer.SerializeItem(ns.model))

	return namespaces
