window.Interface = window.Interface || {};
window.Interface.GroupActivity = window.Interface.GroupActivity || {}
window.Interface.GroupActivity.Members = {};

(function(namespace) 
{
	
	namespace.addMember = function(memberData)
	{
		$("#groupMemberList").append("<li>"+memberData.memberName+"</li>")
	}

	namespace.removeMember = function(memberData)
	{
		$( "#groupMemberList li" ).each(function( index ) {
  			if( $(this).text() === memberData.memberName)
  			{
  				$(this).remove();
  			}
		});	
	}

	
})(window.Interface.GroupActivity.Members);