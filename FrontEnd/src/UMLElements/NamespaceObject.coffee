class Namespace extends MoveableObject

	constructor:(@position, @model)->
		super(@position);

		onChangeHandler = ((evt)->@OnModelChange(evt)).bind(@)
		@model.onChange.add(onChangeHandler)

		@model.get("classes").onChange.add(onChangeHandler)

		@Size = @model.get("Size");

		@routeResolver.createRoute("GlobalObject","window.UML.globals.namespaces.get");
		@resizers = new ResizeDraggers(@);
		@resizers.onSizeChange.add(((evt)->@onDraggerResize(evt)).bind(@))
		@resizers.onDragEnd.add((()->@onDragEnd()).bind(@))

		@resizers.MinSize = new Point(@Size.x, @Size.y);

		@onMouseOverHandel = ((evt)->@onMouseOverWithMoveable(evt)).bind(@);
		@onMouseExitHandel = ((evt)->@onMouseExitWithMoveable(evt)).bind(@);
		@onChildDeletedHandel = ((evt)->@onChildDeleted(evt)).bind(@);

		window.UML.Pulse.MoveableObjectActivated.add(((evt)->@onMoveableActivated(evt)).bind(@))
		window.UML.Pulse.MoveableObjectDeActivated.add(((evt)->@onMoveableDeactivated(evt)).bind(@))
		
		@potentialNewChild = null
		@potentialNewChildIsOverMe = false

		@contents = new Array();

		

		@isNamespace = true

	Del:()->
		super()
		globals.namespaces.remove(@myID)
		for child in @contents
			child.model.del()

	Resize:->
		super()
		@resizers.Resize(@Size);

	CreateGraphicsObject:()->
		super("Namespace");

		@resizers.CreateGraphicsObject();
		globals.LayerManager.InsertNamespaceLayer(@graphics.group);

		for childID in @model.get("classes").list
			@AddChild(childID.get("classID"))

		@name.resize()
		@Resize();

	onDragEnd:()->
		@model.set("Size", new Point(@Size.x, @Size.y))

	onDraggerResize:(evt)->
		@Size = evt.newSize
		@Resize()

	onMoveableActivated:(evt)->
		if evt.moveableObject != @
			@graphics.box.addEventListener("mouseover",@onMouseOverHandel,false);
			@graphics.box.addEventListener("mouseout",@onMouseExitHandel,false);

	onMoveableDeactivated:(evt)->
		@graphics.box.removeEventListener("mouseover",@onMouseOverHandel,false);
		@graphics.box.removeEventListener("mouselout",@onMouseExitHandel,false);
		potentialNewChildIsAMemberOfMe = @contents.indexOf(@potentialNewChild) != -1;

		if @potentialNewChild != null && @potentialNewChildIsOverMe && !potentialNewChildIsAMemberOfMe
			childIDItem = new window.UML.MODEL.ModelItem();
			childIDItem.setNoLog("classID", @potentialNewChild.myID)
			@model.get("classes").push(childIDItem)

		else if @potentialNewChild != null && !@potentialNewChildIsOverMe && potentialNewChildIsAMemberOfMe
			for childItemId in @model.get("classes").list
				if childItemId.get("classID") == @potentialNewChild.myID
					@model.get("classes").remove(childItemId)

		else if @potentialNewChild != null && @potentialNewChildIsOverMe && potentialNewChildIsAMemberOfMe
			@recalculateMinimumSize();
			
		@potentialNewChildIsOverMe = false;
		@potentialNewChild = null
		return

	AddChild:(newChildID)->

		newChild = window.UML.globals.classes.get(newChildID)
		@graphics.group.appendChild(newChild.graphics.group)
		childPositionLocal = window.UML.Utils.ConvertFrameOfReffrence(newChild.position, newChild.GetOwnerFrameOfReffrence(), @graphics.group.getCTM())
		
		if childPositionLocal.x < 0 
			childPositionLocal.x = 10
		if childPositionLocal.y < 0 
			childPositionLocal.y = 50

		newChild.Move(childPositionLocal)
		newChild.SetNewOwner(@graphics.group)
		@contents.push(newChild)

		newChild.onDelete.add(@onChildDeletedHandel)
		@resizeForNewChild(newChild)
		@recalculateMinimumSize();

	resizeForNewChild:(newChild)->
		padding = new Point(10,10)
		requiredSize = newChild.position.add(newChild.Size).add(padding)
		if(@Size.x < requiredSize.x)
			@Size.x = requiredSize.x
		if(@Size.y < requiredSize.y)
			@Size.y = requiredSize.y

		@Resize()

	onChildDeleted:(evt)->
		index = @contents.indexOf(evt.ID)
		if index > -1
			@contents.splice(index,1)
			@model.get("classes").removeAt(index)


	onMouseOverWithMoveable:(evt)->
		$(@graphics.box).addClass("namespaceMoveableOver")
		@potentialNewChild =globals.selections.selectedGroup.selectedItems[0] 
		@potentialNewChildIsOverMe = true;

	onMouseExitWithMoveable:(evt)->
		$(@graphics.box).removeClass("namespaceMoveableOver")
		@potentialNewChildIsOverMe = false;
	
	recalculateMinimumSize:()->
		minSize = new Point(0,0);
		for item in @contents
			do(minSize,item)->
				itemBottemLeft = item.position.add(item.Size)
				if(itemBottemLeft.x > minSize.x)
					minSize.x = itemBottemLeft.x;
				if(itemBottemLeft.y > minSize.y)
					minSize.y = itemBottemLeft.y;

		minSize = minSize.add(new Point(10,10)); # add some padding
		@resizers.UpdateMinimumSize(minSize);


	Move:(To)->
		super(To)
		ref = @
		for classItem in @contents
			do(classItem,ref)->
				classItem.Move(classItem.model.get("Position")) #notify the class items that we are moveing so they update there arrow positions

	Select:() ->
		@resizers.showDraggers(globals.document);

	deactivate:() ->
		@resizers.hideDraggers(globals.document);

	OnMouseOverHeader:(evt)->
		window.UML.globals.highlights.HighlightNamespace(@)

	OnMouseExitHeader:(evt) ->
		window.UML.globals.highlights.UnhighlightNamespace(@)	

	OnModelChange:(evt)->
		if evt.name == "Name"
			@name.UpdateText(evt.new_value);
		else if evt.name == "Size"
			@Size = evt.new_value;
			@Resize();
		else if evt.changeType == "ADD"
			@AddChild(evt.item.get("classID"))
		else if evt.changeType == "DEL"
			classItem = window.UML.globals.classes.get(evt.item.get("classID"))
			if classItem != null
				index = @contents.indexOf(classItem)
				@contents.splice(index,1)
				globals.document.appendChild(classItem.graphics.group)
				classItem.SetNewOwner(globals.document)

		else
			super(evt)		