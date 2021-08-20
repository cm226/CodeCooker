class InterfaceMenu extends ContextMenu
	constructor:()->
		super();

	showContextMenuAddEvt:(e) ->
		@contextMenuOnShow = true;
		if(window.UML.globals.highlights.highlightedInterface != null)
			@Interface = window.UML.globals.highlights.highlightedInterface
			@ContextMenuEl.css({display: "block",left: e.pageX,top: e.pageY});
			e.preventDefault();

	onInitialise:()->
		@ContextMenuEl = $("#interfaceContextMenu")
		super()

	AddMethod:() ->
		rowModel = new window.UML.MODEL.ModelItem()
		rowModel.setNoLog("Name","Method")
		rowModel.setNoLog("Return","Int")
		rowModel.setNoLog("Vis","+")
		rowModel.setNoLog("Args","arg1 : Int, arg2 : Float")
		rowModel.setNoLog("Comment","")
		rowModel.setNoLog("Static",false)
		rowModel.setNoLog("Absract",false)
		@Interface.Methods.model.get("Items").push(rowModel)
	Delete:() ->
		@Interface.model.del();