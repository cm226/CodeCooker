window.UML.Pulse.SingleArrowActivated = new Event()
window.UML.Pulse.BackgroundClick = new Event()
window.UML.Pulse.MoveableObjectActivated = new Event()
window.UML.Pulse.MoveableObjectDeActivated = new Event()



class Selections
	constructor: () ->
		@selectedGroup = new SelectedGroup()


		@activeClass = -1
		@activeArrow = -1
		@moveableObjectActive = false;

		@singleArrowSelectedHandel = ((evt) ->@onSingleArrowSelected(evt)).bind(@)
		@backgroundClickHandel = ((evt) ->@onBackgroundClick(evt)).bind(@)
		@textboxSelectedHandle = ((evt) ->@onTextBoxSelected(evt)).bind(@)
		@textboxGroupSelectedHandle = ((evt) ->@onTextBoxGroupSelected(evt)).bind(@)
		@onMoveableObjectSelectHandle = ((evt) ->@onMoveableObjectSelect(evt)).bind(@)
		@onMoveableObjectDeSelectHandle = ((evt) ->@onMoveableObjectDeSelect(evt)).bind(@)


		window.UML.Pulse.SingleArrowActivated.add(@singleArrowSelectedHandel)
		window.UML.Pulse.BackgroundClick.add(@backgroundClickHandel)
		window.UML.Pulse.TextBoxSelected.add(@textboxSelectedHandle)
		window.UML.Pulse.TextBoxGroupSelected.add(@textboxGroupSelectedHandle)
		window.UML.Pulse.MoveableObjectActivated.add(@onMoveableObjectSelectHandle);
		window.UML.Pulse.MoveableObjectDeActivated.add(@onMoveableObjectDeSelectHandle);

	onBackgroundClick:(evt) ->
		@selectedGroup.deactivate()
		@activeArrow = -1
		@selectedGroup.clear()
		return

	onSingleArrowSelected:(evt) ->
		@selectedGroup.deactivate()
		@activeArrow = evt.arrow
		@selectedGroup.clear()
		@selectedGroup.add(@activeArrow)
		return

	onMoveableObjectSelect: (evt) ->
		@selectedGroup.deactivate();
		@selectedGroup.clear();
		@selectedGroup.add(evt.moveableObject)
		@moveableObjectActive = true;
		return

	onMoveableObjectDeSelect: (evt) ->
		@moveableObjectActive = false;
		return


	onTextBoxGroupSelected: (evt) ->
		@selectedGroup.deactivate();
		@selectedGroup.add(evt.textBoxGroup)

	onTextBoxSelected: (evt) ->
