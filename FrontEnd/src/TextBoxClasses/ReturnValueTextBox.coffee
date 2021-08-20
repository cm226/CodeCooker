class ReturnValueTextBox extends EdiableTextBox
	constructor:(relPos, text)->
		super(relPos, text)

		@TypeSugestionBox = new window.UML.TextBoxes.TypeSugestionBox()
		@TypeSugestionBox.onTypeSugestionMade.add((@TypeSugestionClicked).bind(@))
		@tabPressHandl = ((evt)->@onTabPress(evt)).bind(@)
		@KeyPressHandl = ((evt)->@UpdateTypeSugestionBox(evt)).bind(@)

	CreateGraphics:(classNames)->
		super(classNames)

		@MemberGraphics = new Object();
		@MemberGraphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@MemberGraphics.text = document.createElementNS("http://www.w3.org/2000/svg", 'text');

		@MemberGraphics.text.setAttribute("class",classNames);
		@MemberGraphics.text.textContent = ":"

		ypos = @relPosition.y+20
		@MemberGraphics.text.setAttribute("transform", "translate("+@relPosition.x+" "+ypos+")")

		@MemberGraphics.group.appendChild(@MemberGraphics.text)
		@MemberGraphics.group.appendChild(@graphics.group)

		@MemberGraphics.group;

	getGraphics:()->
		return @MemberGraphics;

	resize:()->
		super()
		ypos = @relPosition.y+20
		@MemberGraphics.text.setAttribute("transform", "translate("+@relPosition.x+" "+ypos+")")

	Move:(@position)->
		super(@position)
		ypos = @relPosition.y+20
		@MemberGraphics.text.setAttribute("transform", "translate("+@relPosition.x+" "+ypos+")")

	showEditBox:()->
		super()
		editBox = $(@currentEditBox)
		point = new Point(editBox.css("left"), parseInt(editBox.css("top")) + parseInt(editBox.css("height")) + 5);

		editBox.keyup(@KeyPressHandl)
		@TypeSugestionBox.Show(point);

	hideEditBox:()->
		super()
		@TypeSugestionBox.Hide();
		editBox = $(@currentEditBox)
		editBox.unbind("keyup",@KeyPressHandl)

	SetReturnValue:(value)->
		@SetText(value);

	onTabPress:(evt)->
		if(@TypeSugestionBox.displayed)
			selectedText = @TypeSugestionBox.GetSelectedText()
			if selectedText != null # will be null if no selections made
				@SetReturnValue(selectedText)
		return true

	UpdateTypeSugestionBox:(evt)->
		key = if evt.keyCode then evt.keyCode else evt.which;
		if(key >= 48 || key == 8) # exclude whitespace chars
			@TypeSugestionBox.UpdateStringPartial(@currentEditBox.value)

	TypeSugestionClicked:(evt)->
		@SetReturnValue(evt.selection[0].innerHTML)