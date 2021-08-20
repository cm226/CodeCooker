class Namespaces extends IDIndexedList
	constructor:(IDResolver)->
		super(IDResolver)

	Create:()->
		pos = window.UML.findEmptySpaceOnScreen();
		namespaceModel = new window.UML.MODEL.Namespace()
		namespaceModel.setNoLog("Size", new Point(150, 200))
		namespaceModel.setNoLog("Position", pos)
		namespaceModel.setNoLog("classes", new window.UML.MODEL.ModelList())
		
		globals.Model.namespaceList.push(namespaceModel)

		return @get(namespaceModel.get("id"))

	Listen:()->
		globals.Model.namespaceList.onChange.add(((evt)->@OnModelChange(evt)).bind(@))
		@Listen = ()-> 


	OnModelChange:(evt)->
		if evt.changeType == "ADD"
			evt.item.flagAsValid()
			# first convert the position attribute back to a Point object if required
			evt.item.setNoLog("Position",window.UML.ModelItemToPoint(evt.item.get("Position")))
			evt.item.setNoLog("Size",window.UML.ModelItemToPoint(evt.item.get("Size")))
			
			newNamespace = new Namespace(evt.item.get("Position"),evt.item)
			newNamespace.CreateGraphicsObject()
			newNamespace.Move(evt.item.get("Position"))

			@add(newNamespace)

		else if evt.changeType == "DEL"
			for namespaceItem in globals.namespaces.List
				if namespaceItem.model == evt.item
					namespaceItem.Del()
					@remove(namespaceItem.myID)
					break