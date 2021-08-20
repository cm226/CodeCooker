class ModelListSerlizer

	constructor:(@obj)->

	serialize:(serialiseSelector)->
		ref = @
		serilizedList = []

		for subObj in @obj
			do(ref, serilizedList)->
				serializer = serialiseSelector.select(subObj)
				serilizedList[ref.obj.indexOf(subObj)] = serializer.serialize(serialiseSelector);

		return serilizedList