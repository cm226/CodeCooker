class MemberArgument
	constructor:()->
		@importantKeyHndl = (@onImportantKey).bind(@) 

		@nameComplete = false
		@TypeSugestionBox = new window.UML.TextBoxes.TypeSugestionBox()
		@TypeSugestionBox.onTypeSugestionMade.add((@TypeSugestionClicked).bind(@))
		@KeyPressHandl = ((evt)->@UpdateTypeSugestionBox(evt)).bind(@)
		@tabPressHandl = ((evt)->@onTabPress(evt)).bind(@)



	activate:(@textElemenet, @refeshTxtBox)->
		window.UML.globals.KeyboardListener.RegisterKeyInterest(' '.charCodeAt(0), @importantKeyHndl)
		window.UML.globals.KeyboardListener.RegisterKeyInterest(','.charCodeAt(0), @importantKeyHndl)
		window.UML.globals.KeyboardListener.RegisterDownKeyInterest('\t'.charCodeAt(0), @tabPressHandl)
		window.UML.globals.KeyboardListener.RegisterDownKeyInterest(13, @tabPressHandl) #EnterKey
		@textElemenet.keyup(@KeyPressHandl)

	deactivate:()->
		window.UML.globals.KeyboardListener.UnRegisterKeyInterest(' '.charCodeAt(0), @importantKeyHndl)
		window.UML.globals.KeyboardListener.UnRegisterKeyInterest(','.charCodeAt(0), @importantKeyHndl)
		window.UML.globals.KeyboardListener.UnRegisterDownKeyInterest('\t'.charCodeAt(0), @tabPressHandl)
		window.UML.globals.KeyboardListener.UnRegisterDownKeyInterest(13, @tabPressHandl) #EnterKey
		@textElemenet.unbind("keyup",@KeyPressHandl)
		@TypeSugestionBox.Hide();

	onImportantKey:()->
		@parse(@ExtractCurrentArgString())

		if(@nameComplete)
			@ComepleteType()
		else
			@CompleteName()

	removeLastChar:(str)->
		lastChar = str[str.length-1]
		if(lastChar == " " || lastChar ==",")
			str = str.substring(0,str.length-1)
		str

	CheckForValidName:()->
		argString = @ExtractCurrentArgString();
		argString = argString.trim();
		return argString.length >0


	CompleteName:()->

		if !@CheckForValidName()
			return 

		textboxText = @textElemenet.val()


		cursorPos = @textElemenet[0].selectionStart
		if cursorPos == 0
			cursorPos = textboxText.length # seems selection start is 0 for the first time you call it this is a hack fix

		textAfterCursor = textboxText.substring(cursorPos)
		trimedText = @removeLastChar(textboxText.substring(0,cursorPos))
		trimedText = trimedText + " : "
		@textElemenet.val(trimedText + textAfterCursor)

		cursorPos = trimedText.length

		@refeshTxtBox()

		@textElemenet[0].setSelectionRange(cursorPos,cursorPos)

		@UpdateTypeSugestionBox({keyCode : 48})
		point = new Point(@textElemenet.css("left"), parseInt(@textElemenet.css("top")) + parseInt(@textElemenet.css("height")) + 5);
		@TypeSugestionBox.Show(point);

	UpdateTypeSugestionBox:(evt)->
		key = if evt.keyCode then evt.keyCode else evt.which;
		if(key >= 48 || key == 8) # exclude whitespace chars
			@parse(@ExtractCurrentArgString())
			if(@TypeString != null && @nameComplete)
				@TypeSugestionBox.UpdateStringPartial(@TypeString)


	ComepleteType:()->

		cursorPos = @GetCursorPosition()

		textboxText = @textElemenet.val()
		postTypeText = textboxText.substring(cursorPos)
		textboxText = @removeLastChar(textboxText.substring(0,cursorPos))

		textboxText += ", "
		@textElemenet.val(textboxText + postTypeText)
		@refeshTxtBox()
		@TypeSugestionBox.Hide();

	ExtractCurrentArgString:()->
		element = @textElemenet[0]
		textVal = @textElemenet.val()
		currentArgStart = textVal.lastIndexOf(',',element.selectionStart)
		if(currentArgStart < 0)
			currentArgStart = 0
		else
			currentArgStart++;

		currentArgEnd = textVal.indexOf(',',element.selectionStart)
		if(currentArgEnd < 0)
			currentArgEnd = textVal.length

		return textVal.substring(currentArgStart, currentArgEnd);


	parse:(argsString)->
		@nameComplete = argsString.indexOf(':') != -1
		
		if(@nameComplete)
			@TypeString = argsString.substring(argsString.indexOf(':')+1).trim();
		else 
			@TypeString = ""

	onTabPress:(evt)->
		if(@TypeSugestionBox.displayed)
			selectedText = @TypeSugestionBox.GetSelectedText()
			@SetCurrentType(selectedText)

		return false

	TypeSugestionClicked:(evt)->
		if(@TypeSugestionBox.displayed)
			@SetCurrentType(evt.selection[0].innerHTML)

	SetCurrentType:(typeString)->
		element = @textElemenet[0]
		textVal = @textElemenet.val()
		typeStartIndex = @textElemenet.val().substring(0,@GetCursorPosition()).lastIndexOf(' ')+1
		preType = textVal.substring(0, typeStartIndex)

		typeStopIndex = textVal.indexOf(',',typeStartIndex)
		if typeStopIndex == -1
			typeStopIndex = textVal.length

		postType = textVal.substring(typeStopIndex).trim()

		@textElemenet.val(preType + typeString + postType)
		@refeshTxtBox()

		return

	GetCursorPosition:()->
		element = @textElemenet[0]
		if element.selectionStart == 0
			return @textElemenet.val().length;
		else
			return element.selectionStart


