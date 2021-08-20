class window.UML.Arrows.Arrows extends IDIndexedList
	constructor:(IDResolver)->
		super(IDResolver)

	Create:(start,end, ownderID, index)->
		arrowModel = new window.UML.MODEL.Arrow()
		arrowModel.model.Tail.setNoLog("Position",start)
		arrowModel.model.Tail.setNoLog("LockedClass",ownderID)
		arrowModel.model.Tail.setNoLog("LockedIndex",index)

		arrowModel.model.Head.setNoLog("Position",end)
		arrowModel.model.Head.setNoLog("LockedClass",-1)
		arrowModel.model.Head.setNoLog("LockedIndex",-1)

		Debug.write("Arrow created with ID: "+arrowModel.modelItemID);

		globals.Model.arrowList.push(arrowModel);
		globals.arrows.get(arrowModel.modelItemID) # HACK alert

	Listen:()->
		globals.Model.arrowList.onChange.add(((evt)->@OnModelChange(evt)).bind(@))
		@Listen = ()-> 

	OnModelChange:(evt)->
		if evt.changeType == "ADD"
			evt.item.get("Head").setNoLog("Position", window.UML.ModelItemToPoint( evt.item.get("Head").get("Position") ))
			evt.item.get("Tail").setNoLog("Position", window.UML.ModelItemToPoint( evt.item.get("Tail").get("Position") ))
			
			arrow = new window.UML.Arrows.Arrow(evt.item)
			globals.arrows.add(arrow)
			arrow.arrowTail.Connection.ReconnectFrom(evt.item.get("Tail").get("LockedClass"), evt.item.get("Tail").get("LockedIndex"))
		else if evt.changeType == "DEL"
			for arrow in globals.arrows.List
				if arrow.model == evt.item
					arrow.del()
					break



