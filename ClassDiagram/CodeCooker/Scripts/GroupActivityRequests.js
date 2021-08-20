window.Interface = window.Interface || {};
window.Interface.GroupActivity = window.Interface.GroupActivity || {}
window.Interface.GroupActivity.Requests = {};

(function(namespace) 
{
	
	namespace.addRequest = function(requestData)
	{
		var accept = $("<button class='btn-primary'>Accept</button>")
		var reject = $("<button class='btn-danger pull-right'>Reject</button>")
		var title = $("<p>"+requestData.memberName+"</p>")
		var listItem = $("<li></li>")

		accept.click(function(){
			window.Interface.CoOpMemberManagement.acceptJoinRequest(requestData.from)
			namespace.removeRequest(requestData);
		});

		reject.click(function(){
			//window.Interface.CoOpMemberManagement.rejectJoinRequest(requestData.from)
			namespace.removeRequest(requestData);
		});

		listItem.append(title).append(accept).append(reject);

		$("#joinRequestsLists").append(listItem);

		$("#joinRequestsLists").append("")

		window.Interface.GroupActivity.notify();
	}

	namespace.removeRequest = function(requestData)
	{
		$( "#joinRequestsLists li" ).each(function( index ) {
  			if( $(this).children("p").text() === requestData.memberName)
  			{
  				$(this).remove();
  			}
		});	
	}

	
})(window.Interface.GroupActivity.Requests);