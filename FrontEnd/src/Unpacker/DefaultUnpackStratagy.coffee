class window.UML.Unpacker.DefaultUnpackStratagy
	constructor:()->


	unpack:(item, unpacker)->
		if window.UML.typeIsArray item
			unpacker.UnpackArray(item)
		else 
			unpacker.UnpackItem(item)	