window.Interface.CoOpGlobals = window.Interface.CoOpGlobals || {};

(function(namespace) 
{

	var my_model_collaberation_id = null;

	namespace.setCollaberationID = function(collaberationID)
	{
		this.my_model_collaberation_id = collaberationID;
		window.Interface.GroupActivity.setGroupID(collaberationID);
	}

	namespace.getCollaberationID = function()
	{
		if(this.my_model_collaberation_id !== null)
		{
			return this.my_model_collaberation_id;
		}
		else
		{
			console.log("Error: collaberation ID requested before setting it.")
			return -1;
		}
	}	

})(window.Interface.CoOpGlobals);