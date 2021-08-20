window.CodeCooker = window.CodeCooker || {};
window.CodeCooker.HighLatency = window.CodeCooker.HighLatency || {};

(function(namespace) 
{

	var networkLayer = null
	var inHighLatensy = false;
	
	namespace.setHighLatensy = function()
	{
		
		if(!inHighLatensy)
		{
			$('#modelHighLatensy').modal({
				backdrop: "static",
	  			keyboard: false,
	  			show : true
			});
			inHighLatensy = true;
		}	
	}

	namespace.clearHighLatensy = function()
	{
		if(inHighLatensy)
		{
			$("#modelHighLatensy").modal("hide");
			inHighLatensy = false;	
		}
	}
	

})(window.CodeCooker.HighLatency);