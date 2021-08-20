window.Interface.CoOpSinc = window.Interface.CoOpSinc || {};

(function(namespace) 
{

	var networkLayer = null
	namespace.registerHandlers = function(messageHandlers)
	{
		messageHandlers.receveModelUpdate = this.receveModelUpdate;
		messageHandlers.receveRequestForCurrentModel = this.receveRequestForCurrentModel;
		messageHandlers.receveFullModel = this.receveFullModel;
		messageHandlers.receveModelIDChunck = this.receveModelIDChunck;
		messageHandlers.receveModelListIDChunck = this.receveModelListIDChunck;
	}

	namespace.startup = function(network)
	{
		networkLayer = network;
	}


	namespace.receveModelUpdate = function(modelUpdate)
	{
    	window.CodeCooker.Debug.write("Model Update Receved: "+JSON.stringify(modelUpdate));
        window.UML.CollaberationSyncBuffer.ModelBuffer.addItem(modelUpdate)
    }

    namespace.receveRequestForCurrentModel = function(from)
    {
        saveSerilzer = new window.UML.Serialize.SerializeModel(new window.UML.Serialize.NetworkSincSerlizationSelector());
        model = saveSerilzer.Serialize()
        networkLayer.sendFullModel(window.Interface.CoOpGlobals.getCollaberationID(), from, model);
    }

    namespace.receveFullModel = function(model){

        window.UML.MODEL.ModelGlobalUtils.ItemIDManager.ClearValidIds();
        window.UML.MODEL.ModelGlobalUtils.ListIDManager.ClearValidIds();
        window.UML.MODEL.ModelGlobalUtils.ItemIDManager.ClearOverrideIDs();
        window.UML.MODEL.ModelGlobalUtils.ListIDManager.ClearOverrideIDs();

        var unpacker = new window.UML.Unpacker.Unpacker(new window.UML.Unpacker.NetworkUnpackStratagy());
        unpacker.Unpack(model);
        window.Interface.StatusBar.setNewStatus("OK", "");

        window.UML.MODEL.ModelGlobalUtils.ItemIDManager.ClearValidIds();
        window.UML.MODEL.ModelGlobalUtils.ListIDManager.ClearValidIds();

        window.UML.MODEL.ModelGlobalUtils.listener 
            = new window.UML.MODEL.ModelListener(window.UML.MODEL.ModelItems.List,
                                                 window.UML.MODEL.ModelLists.List);

        window.UML.MODEL.ModelGlobalUtils.ItemIDManager.ClearValidIds();
        window.UML.MODEL.ModelGlobalUtils.ItemIDManager.SetIdRequester({
            Request : function(){
                networkLayer.requestModelItemIDSet(window.Interface.CoOpGlobals.getCollaberationID());
            },
            FlushIDs : function(){},
            allocateOverrideID: function(id){}
        })
        //Allocate some initial IDs 
        window.UML.MODEL.ModelGlobalUtils.ItemIDManager.RequestMoreIds();


        window.UML.MODEL.ModelGlobalUtils.ItemIDManager.ClearValidIds();
        window.UML.MODEL.ModelGlobalUtils.ListIDManager.SetIdRequester({
            Request: function () {
                networkLayer.requestModelListIDSet(window.Interface.CoOpGlobals.getCollaberationID());
            },
            FlushIDs: function () { },
            allocateOverrideID: function(id){}
        })
        //Allocate some initial IDs 
        window.UML.MODEL.ModelGlobalUtils.ListIDManager.RequestMoreIds();


        // bind to the model and notify of any updates
        window.UML.MODEL.ModelGlobalUtils.listener.onModelChange.add(function(evt){
            networkLayer.sendModelUpdate(window.Interface.CoOpGlobals.getCollaberationID(),evt);
        });

        // flush the undo buffer of any stale model updates
        window.UML.globals.CtrlZBuffer.flushBuffer();
    }

    namespace.receveModelIDChunck = function(start, end){
        if(start < 0){
            // we got an invalid ID back (try one more time)
            window.UML.MODEL.ModelGlobalUtils.ItemIDManager.RequestMoreIds();
        }
        else{
            window.UML.MODEL.ModelGlobalUtils.ItemIDManager.AddToWorkingSet(start, end);
            console.log("new item ids:" + start);
        }
    }

    namespace.receveModelListIDChunck = function(start, end){
        if(start < 0){
            // we got an invalid ID back (try one more time)
            window.UML.MODEL.ModelGlobalUtils.ListIDManager.RequestMoreIds();
        }
        else{
            window.UML.MODEL.ModelGlobalUtils.ListIDManager.AddToWorkingSet(start, end);
            console.log("new list ids:" + start);
        }
    }

	
	

})(window.Interface.CoOpSinc);