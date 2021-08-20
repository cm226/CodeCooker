window.UML.Serialize.SerializeArrows= (serilizer)->
	arrows = new Array()
	for arrow in globals.arrows.List
		arrows.push(serilizer.SerializeItem(arrow.model))
	return arrows

