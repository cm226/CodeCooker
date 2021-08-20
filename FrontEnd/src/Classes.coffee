class classes extends IDIndexedList
	constructor:(IDResolver)->
		super(IDResolver)

	Create:()->
		classPos = window.UML.findEmptySpaceOnScreen();

		classModel = new window.UML.MODEL.Class()
		classModel.setNoLog("id", classModel.modelItemID)
		classModel.setNoLog("Comment", "")
		classModel.setNoLog("Position", classPos)
		classModel.setNoLog("vis", "Public")

		propertyModel = new window.UML.MODEL.ModelItem()
		propertyModel.setNoLog("Name","name");
		propertyModel.setNoLog("Vis","+");
		propertyModel.setNoLog("Type","Int");
		propertyModel.setNoLog("Static",false);
		classModel.get("Properties").get("Items").pushNoLog(propertyModel)

		methodModel = new window.UML.MODEL.ModelItem()
		methodModel.setNoLog("Name","Method")
		methodModel.setNoLog("Return","Int")
		methodModel.setNoLog("Vis","+")
		methodModel.setNoLog("Args","arg1 : Int, arg2 : Float")
		methodModel.setNoLog("Comment","")
		methodModel.setNoLog("Static",false)
		methodModel.setNoLog("Absract",false)
		classModel.get("Methods").get("Items").pushNoLog(methodModel)

		globals.Model.classList.push(classModel)
		return @get(classModel.modelItemID);

	CreateInterface:()->
		classPos = window.UML.findEmptySpaceOnScreen();

		interfacePos = window.UML.findEmptySpaceOnScreen();

		interfaceModel = new window.UML.MODEL.Interface()
		interfaceModel.setNoLog("id", interfaceModel.modelItemID)
		interfaceModel.setNoLog("Comment", "")
		interfaceModel.setNoLog("Position", classPos)
		interfaceModel.setNoLog("vis", "Public")

		methodModel = new window.UML.MODEL.ModelItem()
		methodModel.setNoLog("Name","Method")
		methodModel.setNoLog("Return","Int")
		methodModel.setNoLog("Vis","+")
		methodModel.setNoLog("Args","arg1 : Int, arg2 : Float")
		methodModel.setNoLog("Comment","")
		methodModel.setNoLog("Static",false)
		methodModel.setNoLog("Absract",false)
		interfaceModel.get("Methods").get("Items").pushNoLog(methodModel)

		globals.Model.interfaceList.push(interfaceModel)
		return @get(interfaceModel.modelItemID)

	Listen:()->
		globals.Model.classList.onChange.add(((evt)->@OnModelChange(evt)).bind(@))
		globals.Model.interfaceList.onChange.add(((evt)->@OnInterfaceModelChange(evt)).bind(@))

		@Listen = ()-> 


	OnModelChange:(evt)->
		if evt.changeType == "ADD"
			evt.item.flagAsValid()
			# first convert the position attribute back to a Point object if required
			evt.item.setNoLog("Position",window.UML.ModelItemToPoint(evt.item.get("Position")))
			
			newClass =	new Class(evt.item.get("Position"),evt.item,
			{popover : ()-> $('#popoverLink'),
			visibility : ()-> $('#classVisibiltySelect'),
			static : ()-> $('#Static'),
			comment : ()-> $("#classPropertyDescription")
			});
			newClass.CreateGraphicsObject()
			@add(newClass)

		else if evt.changeType == "DEL"
			for classItem in globals.classes.List
				if classItem.model == evt.item
					classItem.Del()
					@remove(classItem.myID)
					break

	OnInterfaceModelChange:(evt)->
		if evt.changeType == "ADD"
			# first convert the position attribute back to a Point object if required
			evt.item.setNoLog("Position",window.UML.ModelItemToPoint(evt.item.get("Position")))

			newClass =	new Interface(evt.item.get("Position"),evt.item,
			{popover : ()-> $('#popoverLink'),
			visibility : ()-> $('#classVisibiltySelect'),
			static : ()-> $('#Static'),
			comment : ()-> $("#classPropertyDescription")
			});
			newClass.CreateGraphicsObject()
			@add(newClass)

		else if evt.changeType == "DEL"
			for classItem in globals.classes.List
				if classItem.model == evt.item
					classItem.Del()
					@remove(classItem.myID)
					break