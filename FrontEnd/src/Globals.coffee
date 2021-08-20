window.UML.Pulse.TypeNameChanged = new Event()
window.UML.Pulse.TypeDeleted = new Event()

class Globals
	constructor: ->
		
		@document = null
		@classes = new classes((Item)-> Item.model.modelItemID)
		@arrows = new window.UML.Arrows.Arrows((ArrowItem)-> ArrowItem.model.get("id"))
		@namespaces = new Namespaces((NamespaceItem)-> NamespaceItem.myID)
		@textBoxes = new IDIndexedList((TextBoxItem)->TextBoxItem.myID)
		@selections = new Selections()
		@highlights = new Highlights()
		@LayerManager = new LayerManager();
		@CtrlZBuffer = new window.UML.Ctrlz.CtrlzBuffer();
		@Model = new window.UML.MODEL.MODEL();
		
		
		@CommonData = {version : "0.0.0";
		filename : "Diagram01";
		Types : (new window.UML.StringTree.StringTree())} 

		@CommonData.Types.Build("Int")
		@CommonData.Types.Build("Float")
		@CommonData.Types.Build("String")
		@CommonData.Types.Build("Boolean")
		@CommonData.Types.Build("Time")
		@CommonData.Types.Build("Date")
		@CommonData.Types.Build("DateTime");


		window.UML.Pulse.TypeNameChanged.add((evt)->
			window.UML.globals.CommonData.Types.Remove(evt.prevText)
			window.UML.globals.CommonData.Types.Build(evt.newText))

		window.UML.Pulse.TypeDeleted.add((evt)->
			window.UML.globals.CommonData.Types.Remove(evt.typeText))

