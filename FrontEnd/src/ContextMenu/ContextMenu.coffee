class ContextMenu
	constructor:()->
		@initHandle =  ((evt) ->@onInitialise(evt)).bind(@) 
		@backgroundClick = ((evt) ->@onBackgroundClick(evt)).bind(@) 
		@showContextMenuAddEvtHndl = ((evt) ->@showContextMenuAddEvt(evt)).bind(@) 
		@showContextMenuAttatchEvtHndl = ((evt) ->@showContextMenuAttatchEvt(evt)).bind(@) 
		@hideContextMenuHndl = ((evt) ->@hideContextMenu(evt)).bind(@) 

		window.UML.Pulse.Initialise.add(@initHandle)
		window.UML.Pulse.BackgroundClick.add(@backgroundClick)
		@contextMenuOnShow = false;
	
	onBackgroundClick:(e)->
		if(@contextMenuOnShow)
			@ContextMenuEl.css({display: "none"});

		@contextMenuOnShow = false

	bindContextMenu:()->
		if (document.addEventListener)
	        document.addEventListener('contextmenu', @showContextMenuAddEvtHndl, false);
	    else
	        document.attachEvent('oncontextmenu',@showContextMenuAttatchEvtHndl);

	    @ContextMenuEl.on("click", "a", @hideContextMenuHndl);

	onInitialise:()->
		@bindContextMenu()

	hideContextMenu:(e) ->
		@ContextMenuEl.hide()

	showContextMenuAddEvt:(e) -> #override this
		return; 

	showContextMenuAttatchEvt:() ->
		alert("You've tried to open context menu");
		window.event.returnValue = false;

	
