window.Interface = window.Interface || {};
window.Interface.GroupActivity = {};

(function(namespace) 
{
	var isOpen = false;

	var flashOn  = false;
	var flashNotify = function()
	{
		if(flashOn)
		{
			$("#groupActivityTab").css({"color":"#A3A3A3",
										"border-style":"none"});
			
		}
		else
		{
			$("#groupActivityTab").css({"color":"#FF6600",
										"border-bottom-style":"solid"});
		}
		flashOn = !flashOn;

	}
	var notifyer= null;

	namespace.open = function()
	{
		if(!isOpen)
		{
			$("#GroupActivity").animate({bottom: "+=400"});
			isOpen = true;
			namespace.stopNotify()
		}
	}

	namespace.close = function()
	{
		if(isOpen)
		{
			$("#GroupActivity").animate({bottom: "-=400"});
			isOpen = false;
		}
	}

	namespace.toggel = function()
	{
		if(isOpen)
		{
			namespace.close();
		}
		else
		{
			namespace.open();
		}
	}

	namespace.notify = function()
	{
		if (notifyer === null)
			notifyer = setInterval(flashNotify, 500);

		setTimeout(function(){
			namespace.stopNotify()
		}, 3000);
	}

	namespace.stopNotify = function()
	{
		if(notifyer !== null) 
			clearInterval(notifyer);
			flashOn = true;
			flashNotify();
			notifyer = null;
	}

	namespace.display = function()
	{
		namespace.notify();
		$("#groupActivityTab").css("display", "list-item");
	}

	namespace.setGroupID = function(groupID)
	{
		$("#groupID").html(groupID)
	}

	namespace.copyGroupID = function()
	{
		window.prompt("Copy to clipboard: Ctrl+C, Enter", $("#groupID").html());
	}

	namespace.pushMessage = function(msg, from)
	{
		namespace.notify();
		$(".chattMessagesInner").append("<div class='message'><span class='from'>"+from+":</span>"+msg+"</div>")
		this.scrollMessagesToBottom();
	}


	namespace.pushMessageMe = function(msg)
	{
		$(".chattMessagesInner").append("<div class='messageMe'><span class='from'>Me:</span>"+msg+"</div>")
		this.scrollMessagesToBottom();
	}

	namespace.scrollMessagesToBottom = function()
	{
		$('#groupChatt').scrollTop($('#groupChatt')[0].scrollHeight);
	}

	namespace.sendMessage = function(networkLayer)
	{
		msg = $("#chattMessage input").val()
		networkLayer.sendChattMessage(msg);
		$("#chattMessage input").val("")
		this.pushMessageMe(msg);
	}

	
})(window.Interface.GroupActivity);