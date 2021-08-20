window.UML.Pulse.TextBoxSelected = new Event()

class EdiableDropDown extends EdiableTextBox
	constructor:(@relPosition, @text, @choices)->
		super(@relPosition, @text)

	repopulateTextFromEditBox:()->
		@SetText(@currentDropdown.value);
		
		@resize();

		if(@text == "")
			evt = new Object()
			evt.trigger = @
			@onBecomeEmpty.pulse(evt)

	showEditBox:()->
		#NEEDS OPTIMISATION 
		@currentDropdown = document.createElement("select")
		currentDropdown = @currentDropdown

		for choice in @choices
			do (choice, currentDropdown)->
				option = document.createElement("option");
				option.setAttribute("value",choice)
				option.text = choice
				currentDropdown.appendChild(option)

		@BindEditBoxEvents()
		windowCoord = window.UML.Utils.getScreenCoordForSVGElement(@graphics.border)

		dropdwnWidth = @Size.x + 50; # +20 for roominess
		dropdwnHeight = @Size.y + 10; # +10 for roominess
		@currentDropdown.setAttribute("style","position: fixed;height: "+dropdwnHeight+"px;width: "+dropdwnWidth+"px;top: "+windowCoord.y+"px; left: "+windowCoord.x+"px;")
		@currentDropdown.addEventListener("blur", @editBoxBlur)
		document.getElementById('WorkArea').appendChild(@currentDropdown)

		@currentDropdown.focus();
		window.UML.Pulse.TextBoxSelected.pulse(null);

	hideEditBox:()->
		@UnBindEditBoxEvents();
		@currentDropdown.removeEventListener("blur", @editBoxBlur)
		document.getElementById('WorkArea').removeChild(@currentDropdown)