window.UML.MODEL.ModelGlobalUtils.listener ={
	ListenToNewMode : (model)->
		return;
	StopListening : ()->
		return;} # stub the model listener initially as its only required for collabiration stuff
window.UML.CollaberationSyncBuffer.ModelBuffer = new window.UML.CollaberationSyncBuffer.SyncBuffer();
window.UML.MODEL.ModelGlobalUtils.ItemIDManager = new window.UML.MODEL.ModelIDManager({
	currentID : 0
	maxOverrideAllocated : 0
	Request:()->
		ItemIDManager = window.UML.MODEL.ModelGlobalUtils.ItemIDManager
		ItemIDManager.AddToWorkingSet(@currentID, @currentID+50);
		@currentID = @currentID+50;
	FlushIDs:()->
		@currentID = 0;

	allocateOverrideID:(id)->
		if(id > @maxOverrideAllocated)
			@maxOverrideAllocated = id

		@currentID = @maxOverrideAllocated+1
})

window.UML.MODEL.ModelGlobalUtils.ListIDManager = new window.UML.MODEL.ModelIDManager({
	currentID : 0
	maxOverrideAllocated : 0
	Request:()->
		ListIDManager = window.UML.MODEL.ModelGlobalUtils.ListIDManager
		ListIDManager.AddToWorkingSet(@currentID, @currentID+50);
		@currentID = @currentID+50;
	FlushIDs:()->
		@currentID = 0;

	allocateOverrideID:(id)->
		if(id > @maxOverrideAllocated)
			@maxOverrideAllocated = id

		@currentID = @maxOverrideAllocated+1
})
	
globals = new Globals()
window.UML.globals = globals
globals.contextMenu = new ClassMenu()
globals.InterfaceMenu = new InterfaceMenu()
globals.NamespaceMenu = new NamespaceMenu()
globals.ArrowMenu = new ArrowMenu()
globals.KeyboardListener = new KeyboardListener();
 

window.UML.backgroundMouseUp=(evt)->
	if(globals.selections.moveableObjectActive)
		for item in globals.selections.selectedGroup.selectedItems
			if not item.isNamespace
				window.UML.SetItemOwnedByBackground(item)


window.UML.SetItemOwnedByBackground=(item)->
	globals.LayerManager.InsertClassLayer(item.graphics.group)
	childPositionLocal = window.UML.Utils.ConvertFrameOfReffrence(item.position, item.GetOwnerFrameOfReffrence(), globals.document.getCTM())
	item.Move(childPositionLocal)
	item.SetNewOwner(globals.document)


$(document).ready( ()->
	globals.document = document.getElementsByTagName('svg')[0]

	globals.classes.Listen();
	globals.arrows.Listen();
	globals.namespaces.Listen();

	window.UML.MODEL.ModelGlobalUtils.ItemIDManager.RequestMoreIds()
	window.UML.MODEL.ModelGlobalUtils.ItemIDManager.RequestMoreIds()
	

	window.UML.Pulse.Initialise.pulse();
	window.UML.globals.CtrlZBuffer.Start();
	Debug.Startup();
	)

####################################################
#												   #
# This is a utility function that allows the debug #
# value to be set from outside the coffee script   #
# execution enviroment      					   #
#												   #
####################################################
window.UML.setDebug= ()->
	Debug.IsDebug = true;



window.UML.hideOverlay= () ->
	$("#windowOverlay").removeClass("overlayVisabal");
	$("#windowOverlay").addClass("overlayHidden");
	
	$("#overlayBackground").removeClass("overlayVisabal");
	$("#overlayBackground").addClass("overlayHidden");

	return


