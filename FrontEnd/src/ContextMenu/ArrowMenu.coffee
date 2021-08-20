class ArrowMenu extends ContextMenu
	constructor:()->
		super();

	showContextMenuAddEvt:(e) ->
		@contextMenuOnShow = true;
		if(window.UML.globals.highlights.highlightedArrow != null)
			@Arrow = window.UML.globals.selections.activeArrow
			@ContextMenuEl.css({display: "block",left: e.pageX,top: e.pageY});
			@position = window.UML.Utils.mousePositionFromEvent(e);
			e.preventDefault();

	onInitialise:()->
		@ContextMenuEl = $("#ArrowContextMenu")
		super()

	Bend:() ->
		@Arrow.Bend(@position);