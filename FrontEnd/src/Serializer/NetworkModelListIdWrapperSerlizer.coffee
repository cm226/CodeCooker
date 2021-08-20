class NetworkModelListIdWrapperSerlizer
	constructor:(@modelItemID, @modelItem)->

	serialize:(serialiseSelector)->
		serilizedObject = {};
		serilizedObject.modelListID = @modelItemID;
		serilizedObject.model = @modelItem.serialize(serialiseSelector);
		
		return serilizedObject;