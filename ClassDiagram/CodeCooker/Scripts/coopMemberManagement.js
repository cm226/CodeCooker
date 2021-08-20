window.Interface.CoOpMemberManagement = window.Interface.CoOpMemberManagement || {};

(function(namespace) 
{

	var networkLayer = null
	
	namespace.startup = function(ntwork)
	{
		networkLayer = ntwork;
	}

	namespace.registerHandlers = function(messageHandlers)
	{
		messageHandlers.receveJoinRequest = this.receveJoinRequest;
		messageHandlers.joinRequestAccepted = this.joinRequestAccepted;
		messageHandlers.userDisconected = this.userDisconected;
		messageHandlers.userConnected = this.userConnected;
	}

	namespace.userDisconected = function(user)
	{
		window.Interface.GroupActivity.pushMessage("Disconnected",user);
		window.Interface.GroupActivity.Members.removeMember({id: user, memberName : user});
	}

	namespace.userConnected = function(user)
    {
    	window.Interface.GroupActivity.pushMessage("Connected",user);
    	window.Interface.GroupActivity.Members.addMember({id: user, memberName : user});
    }

    namespace.requestJoinGroup = function()
    {
    	var id = prompt("Doc:", "");
        if(id !== undefined)
            networkLayer.requestJoinCollabirators(id)
    }

	namespace.receveJoinRequest = function(from, name)
	{
	    window.Interface.GroupActivity.Requests.addRequest({memberName : name, from : from})
    }

    namespace.joinRequestAccepted = function(collaberation_id)
    {
    	window.UML.MODEL.ModelGlobalUtils.listener.StopListening();
	    window.UML.globals.Model.clearModel();
	    window.Interface.StatusBar.setLoadingStatus("Connecting");
	    window.Interface.CoOpGlobals.setCollaberationID(collaberation_id);
	    networkLayer.requestFullModel(window.Interface.CoOpGlobals.getCollaberationID());
	    window.Interface.GroupActivity.display();
	}

	namespace.acceptJoinRequest = function(from)
	{
		networkLayer.acceptJoinCollabirators(window.Interface.CoOpGlobals.getCollaberationID(), from);
	}

	namespace.rejectJoinRequest = function(from)
	{
		networkLayer.rejectJoinCollabirators(window.Interface.CoOpGlobals.getCollaberationID(), from);
	}	

	

})(window.Interface.CoOpMemberManagement);