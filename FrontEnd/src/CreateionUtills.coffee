classCreatePos = new Point(50,50)
window.UML.findEmptySpaceOnScreen= () ->
	classCreatePos.x += 10;
	if(classCreatePos.x > 500)
		classCreatePos.y += 100;
		classCreatePos.x = 50;

	window.UML.Utils.getSVGCorrdforScreenPos(classCreatePos)


window.UML.CreateClass=() ->
	newClass = globals.classes.Create();
	return newClass

window.UML.CreateClassForDocInit=(id) ->	
	classModel = new window.UML.MODEL.Class()
	classPos = window.UML.findEmptySpaceOnScreen();
	classModel.setNoLog("Position", classPos)
	classModel.setNoLog("id",id)

	globals.Model.classList.push(classModel);

	newClass = globals.classes.get(id)

	return newClass

window.UML.CreateInterface=() ->
	newInterface = globals.classes.CreateInterface();
	return newInterface

window.UML.CreateInterfaceForDocInit=(id) ->
	interfaceModel = new window.UML.MODEL.Interface()
	
	interfacePos = window.UML.findEmptySpaceOnScreen();
	interfaceModel.setNoLog("Position", interfacePos)
	interfaceModel.setNoLog("id",id)

	globals.Model.interfaceList.push(interfaceModel)

	newInterface = globals.classes.get(id)

	return newInterface

window.UML.CreateNamespace=() ->
	newNamespace = globals.namespaces.Create();
	return newNamespace


window.UML.CreateNamespaceForDocInit=(id) ->
	pos = window.UML.findEmptySpaceOnScreen();
	namespaceModel = new window.UML.MODEL.Namespace()
	namespaceModel.setNoLog("Size", new Point(150, 200))
	namespaceModel.setNoLog("id", id)
	namespaceModel.setNoLog("Position", pos)

	newNamespace = new Namespace(pos,namespaceModel)

	newNamespace.CreateGraphicsObject()
	newNamespace.Move(pos)
	globals.namespaces.add(newNamespace)
	globals.Model.namespaceList.push(namespaceModel)
	return newNamespace