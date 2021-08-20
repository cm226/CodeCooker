window.Interface = {};
window.Interface.StatusBar = {};

(function(namespace) 
{
	var loadingBar = "<div class=\"bar\"><span></span></div>";
	var loadingBarDisplayed = false;


	namespace.setReadyState =function()
	{
		namespace.setNewStatus("Ready","");	
	}
	
	namespace.setNewStatus = function(line1, line2)
	{
		$("#statusBar div:first").html(line1);
		$("#statusBar div:nth-child(2)").html(line2);
		loadingBarDisplayed = false;
	}

	namespace.setLoadingStatus = function(line)
	{
		$("#statusBar div:first").html(line);
		if( !loadingBarDisplayed )
		{
			$("#statusBar div:nth-child(2)").html(loadingBar);
			loadingBarDisplayed = true;
		}
	}	

})(window.Interface.StatusBar);