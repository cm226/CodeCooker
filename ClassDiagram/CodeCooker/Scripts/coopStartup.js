window.Interface.CoOpStartup = window.Interface.CoOpStartup || {};

(function(namespace) 
{

	var networkLayer = null
	
	namespace.startup = function(ntwork)
	{
		networkLayer = ntwork;
	}

	namespace.registerHandlers = function(messageHandlers)
	{
		messageHandlers.initHostData = this.initHostData;
		messageHandlers.newCollabirationID = this.newCollabirationID;
	}

	namespace.newCollabirationID = function(collabirationID)
	{
    	console.log(collabirationID);
    	window.Interface.CoOpGlobals.setCollaberationID(collabirationID);

    }

	namespace.hostCoOpDoc = function()
	{
		if(networkLayer != null)
		{
			networkLayer.createCollabirationDocument();
			window.Interface.GroupActivity.display();
		}
		else
		{
			console.log("Error: network host co op doc called before network init")
		}
	}

	namespace.initHostData = function()
	{
		modelItemID = window.UML.MODEL.ModelGlobalUtils.ItemIDManager.AllocateID();
		modelListID = window.UML.MODEL.ModelGlobalUtils.ListIDManager.AllocateID();
		networkLayer.initModelIds(modelItemID, modelListID, window.Interface.CoOpGlobals.getCollaberationID());
		console.log("Initialiseing Ids Item: "+modelItemID+" List: "+modelListID);
		window.UML.MODEL.ModelGlobalUtils.listener 
		    = new window.UML.MODEL.ModelListener(window.UML.MODEL.ModelItems.List,
		                                         window.UML.MODEL.ModelLists.List);
		// bind to the model and notify of any updates
		window.UML.MODEL.ModelGlobalUtils.listener.onModelChange.add(function(evt){
		    networkLayer.sendModelUpdate(window.Interface.CoOpGlobals.getCollaberationID(),evt);
		});

		window.UML.MODEL.ModelGlobalUtils.ListIDManager.ClearValidIds();
		window.UML.MODEL.ModelGlobalUtils.ItemIDManager.ClearValidIds();

		window.UML.MODEL.ModelGlobalUtils.ListIDManager.SetIdRequester({
		    Request : function(){
		        networkLayer.requestModelListIDSet(window.Interface.CoOpGlobals.getCollaberationID());
		    },
		    FlushIDs: function () { },
		    allocateOverrideID: function(id){}
		})

		window.UML.MODEL.ModelGlobalUtils.ItemIDManager.SetIdRequester({
		    Request: function () {
		        networkLayer.requestModelItemIDSet(window.Interface.CoOpGlobals.getCollaberationID());
		    },
		    FlushIDs: function () { },
		    allocateOverrideID: function(id){}
		})
		//Allocate some initial IDs 
		window.UML.MODEL.ModelGlobalUtils.ItemIDManager.RequestMoreIds();
		window.UML.MODEL.ModelGlobalUtils.ListIDManager.RequestMoreIds();
    }

	

})(window.Interface.CoOpStartup);