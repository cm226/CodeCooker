window.Interface.RolloverList = {};

(function(namespace) 
{
	var rolledOutItem = null;
	namespace.animateOpen = function(listItem)
	{
		if (rolledOutItem !== null && rolledOutItem === listItem)
			return;

		var doOpenAnimation = function(){$( listItem ).animate({
							    width: "150px"
							  }, 500, function() {});};



		if( rolledOutItem !== null)
			namespace.animateClose(rolledOutItem,doOpenAnimation);
		else
			doOpenAnimation();

		rolledOutItem = listItem;
	}

	namespace.animateClose = function(listItem, onComplete)
	{
		$( listItem ).animate({
		    width: "30"
		  }, 500,
		  onComplete);
		rolledOutItem = null;
	}	
	

})(window.Interface.RolloverList);