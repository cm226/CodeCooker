class LayerManager
	constructor:()->


	InsertArrowLayer:(element)->
		#globals.document.appendChild(element);	
		# This method is not called because there is no need to yet, arrows should be on top off eveythign else

	InsertNamespaceLayer:(element)->
		namespaceLayer = globals.document.getElementById("namespaceLayerMarker");
		globals.document.insertBefore(element,namespaceLayer);	

	InsertClassLayer:(element)->
		classLayer = globals.document.getElementById("classLayerMarker");
		globals.document.insertBefore(element, classLayer);
	
		
