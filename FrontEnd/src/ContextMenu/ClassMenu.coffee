class ClassMenu extends ContextMenu
	constructor:()->
		super();

	showContextMenuAddEvt:(e) ->
		@contextMenuOnShow = true;
		if(window.UML.globals.highlights.highlightedClass != null)
			@class = window.UML.globals.highlights.highlightedClass
			@ContextMenuEl.css({display: "block",left: e.pageX,top: e.pageY});
			e.preventDefault();

	onInitialise:()->
		@ContextMenuEl = $("#contextMenu")
		super()
	AddProperty:() ->
		rowModel = new window.UML.MODEL.ModelItem()
		rowModel.setNoLog("Name","name");
		rowModel.setNoLog("Vis","+");
		rowModel.setNoLog("Type","type");
		rowModel.setNoLog("Static",false);

		@class.Properties.model.get("Items").push(rowModel)
	AddMethod:() ->
		rowModel = new window.UML.MODEL.ModelItem()
		rowModel.setNoLog("Name","Method")
		rowModel.setNoLog("Return","Int")
		rowModel.setNoLog("Vis","+")
		rowModel.setNoLog("Args","arg1 : Int, arg2 : Float")
		rowModel.setNoLog("Comment","")
		rowModel.setNoLog("Static",false)
		rowModel.setNoLog("Absract",false)
		@class.Methods.model.get("Items").push(rowModel)
	Delete:() ->
		@class.model.del();

	