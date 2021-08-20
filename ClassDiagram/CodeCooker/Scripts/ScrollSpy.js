Window.ScrollSpy = {}

Window.ScrollSpy.Handlers = null;
Window.ScrollSpy.Element = null;
Window.ScrollSpy.CurrentDeltaHandler = null;

$(window).scroll(function(){

	if(Window.ScrollSpy.Handlers === null && Window.ScrollSpy.Element === null)
		return

	var fromTop = $(this).scrollTop();

	for (var deltaHandlerKey in Window.ScrollSpy.Handlers)
	{
		var deltaHandler = Window.ScrollSpy.Handlers[deltaHandlerKey]

		if((fromTop + deltaHandler.deltaStart) - Window.ScrollSpy.Element.offsetTop > 0 &&
		   (fromTop + deltaHandler.deltaEnd) - Window.ScrollSpy.Element.offsetTop < 0)
		{
			if(Window.ScrollSpy.CurrentDeltaHandler !== deltaHandler)
			{
				deltaHandler.handler();
				Window.ScrollSpy.CurrentDeltaHandler = deltaHandler;
			}
		}
	}


});

/*
	deltaHandelrs{
				"delatHandler1": {
					"delta":"50"
					"handler": handler1
				}
				"delatHandler2": {
					"delta":"100"
					"handler": handler2
				}
				
	}
*/
Window.ScrollSpy.Spy = function(element, deltaHandlers)
{
	Window.ScrollSpy.Element = element;
	Window.ScrollSpy.Handlers = deltaHandlers;

}