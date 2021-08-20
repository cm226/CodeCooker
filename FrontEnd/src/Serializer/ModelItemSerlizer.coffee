class ModelItemSerilzer
	constructor:(@obj)->

	serialize:(serialiseSelector)->
		ref = @;
		serilizedObject = {};

		for subObj of @obj
			do(ref,serilizedObject)->
				serializer = serialiseSelector.select(ref.obj[subObj])
				serilizedObject[subObj] = serializer.serialize(serialiseSelector);

		return serilizedObject;