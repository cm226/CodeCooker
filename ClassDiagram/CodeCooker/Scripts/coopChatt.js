window.Interface.CoOpChatt = window.Interface.CoOpChatt || {};

(function(namespace) 
{

	var networkLayer = null
	namespace.registerHandlers = function(messageHandlers)
	{
		messageHandlers.onReceveMessage = this.receveMessage;
	}

	namespace.startup = function(network)
	{
		networkLayer = network;
	}

	namespace.sendChattMessage = function(msg)
	{
		if(networkLayer != null)
		{
			networkLayer.sendChatMessage(msg,window.Interface.CoOpGlobals.getCollaberationID());
		}
		else
		{
			console.log("Error: Chatt message sent before startup was called")
		}

	}	

	namespace.receveMessage = function(sender, message)
	{
		window.Interface.GroupActivity.pushMessage(message,sender);
	}
	

})(window.Interface.CoOpChatt);