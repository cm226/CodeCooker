window.Interface = {};
window.Interface.StatusBar = {};

(function(namespace) 
{
	var loadingBar = "<div class=\"bar\"><span></span></div>";

	namespace.setNewStatus = function(line1, line2)
	{
		$("#statusBar div:first").html(line1);
		$("#statusBar div:nth-child(2)").html(line2);
	}

	namespace.setLoadingStatus = function(line)
	{
		$("#statusBar div:first").html(line);
		$("#statusBar div:nth-child(2)").html(loadingBar);
	}	

})(window.Interface.StatusBar);