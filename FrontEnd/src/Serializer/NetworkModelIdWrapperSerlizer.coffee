class NetworkModelIdWrapperSerlizer
	constructor:(@modelItemID, @modelItem)->

	serialize:(serialiseSelector)->
		serilizedObject = {};
		serilizedObject.modelItemID = @modelItemID;
		serilizedObject.model = @modelItem.serialize(serialiseSelector);
		
		return serilizedObject;