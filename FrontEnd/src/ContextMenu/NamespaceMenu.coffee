class NamespaceMenu extends ContextMenu
	constructor:()->
		super();

	showContextMenuAddEvt:(e) ->
		@contextMenuOnShow = true;
		if(window.UML.globals.highlights.highlightedNamespace != null)
			@Namespace = window.UML.globals.highlights.highlightedNamespace
			@ContextMenuEl.css({display: "block",left: e.pageX,top: e.pageY});
			e.preventDefault();

	onInitialise:()->
		@ContextMenuEl = $("#namespaceContextMenu")
		super()

	Delete:() ->
		@Namespace.Del();