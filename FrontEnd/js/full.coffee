window.UML = {}
window.UML.Pulse = {}
window.UML.Utils = {}

window.UML.Arrows={} 

window.UML.CollaberationSyncBuffer = {}

window.UML.Ctrlz={}

window.UML.Interaction={};

window.UML.MODEL={}
window.UML.MODEL.ModelGlobalUtils = {}

window.UML.Serialize = {}


window.UML.StringTree={}

window.UML.TextBoxes={}
window.UML.TextBoxes.IntelligentPopoutPositioning = {}

window.UML.Unpacker = {}


class IDIndexedList
	constructor:(IDResolver) ->
		@List = new Array()
		@resolver = IDResolver

	get:(id) ->
		item = (item for item in @List when @resolver(item) == id)
		if(item.length > 0)
			return item[0]
		else
			return null
	add:(item) ->
		@List.push(item)
		return

	remove: (id)->
		item = (item for item in @List when @resolver(item) == id)
		if(item.length > 0)
			@List.splice(@List.indexOf(item[0]),1)
		else
			Debug.write("Invalid Id removed from list: "+id)

		item[0]

	contains:(item)->
		return @List.indexOf(item) != -1;

	clear:()->
		@List = [];

class Point
	@x = 0
	@y = 0
	
	constructor:(@x, @y) ->

	add:(p) ->
		new Point(@x+p.x, @y+p.y)
	sub:(p) ->
		new Point(@x-p.x, @y-p.y)




class Event
	constructor:()->
		@subscribers = new Array()

	add:(func) ->
		@subscribers.push(func)
	remove:(func) ->
		index = @subscribers.indexOf(func)
		if(index != -1)
			@subscribers.splice(index,1)
	pulse:(evt) ->
		subCount = 0
		while subCount < @subscribers.length # pulsing some subscribers might remove elements from the list!
			@subscribers[subCount](evt)	
			subCount++;	

window.UML.Pulse.Initialise = new Event()

class HighlightableTextBox
	constructor:(@relPosition, @context)->
		@passive = false
		@OnMouseOver = new Event()
		@OnMouseUp = new Event()
		@OnMouseExit = new Event()

		@borderMarginHeight = 2;
		@borderMarginWidth = 5;

		@mouseUpHandle  = ((evt) ->@onMouseUp(evt)).bind(@) 
		@mouseOverHandle= ((evt) ->@onMouseOver(evt)).bind(@)
		@mouseOutHandle	= ((evt) ->@onMouseOut(evt)).bind(@)

	SetPassive:()->
		@passive = true
		
	SetActive:()->
		@passive = false

	CreateGraphics:(graphics)->
		graphics.border = document.createElementNS("http://www.w3.org/2000/svg", 'rect');

		graphics.border.setAttribute("stroke", "none")
		graphics.border.setAttribute("x", 1)
		graphics.border.setAttribute("y", 5)
		graphics.border.setAttribute("height", @context.Size.y+@borderMarginHeight)
		graphics.border.setAttribute("width", @context.Size.x+@borderMarginWidth)
		graphics.border.setAttribute("fill-opacity", 0)

		graphics.border.addEventListener("mouseout",@mouseOutHandle );
		graphics.border.addEventListener("mouseover",@mouseOverHandle );
		graphics.border.addEventListener("mouseup", @mouseUpHandle);

	Resize:()->
		@context.graphics.border.setAttribute("height", @context.Size.y+@borderMarginHeight)
		@context.graphics.border.setAttribute("width", @context.Size.x+@borderMarginWidth)

	onMouseOver:()->
		if not @passive
			@context.DoHighlight()
		else
			@OnMouseOver.pulse(null)
		
	onMouseOut:()->
		if not @passive
			@context.DoUnhighlight()
		else
			@OnMouseExit.pulse(null)
		
	onMouseUp:()->
		if not @passive
			@context.OnSelect()
		else
			@OnMouseUp.pulse(null)

	Highlight:()->
		@context.graphics.border.setAttribute("stroke", "#3385D6")
	Unhighlight:()->
		@context.graphics.border.setAttribute("stroke", "none")

window.UML.Pulse.TextBoxSelected = new Event()

window.UML.EditableTextBoxID = 0;
window.UML.NextTextBoxID = ()-> 
	window.UML.EditableTextBoxID += 1
	window.UML.EditableTextBoxID;

class EdiableTextBox
	constructor:(@relPosition, @text)->

		@myID = window.UML.NextTextBoxID();
		globals.textBoxes.add(@);
		@onTextChange = new Event()
		@onSizeChange = new Event()
		@onBecomeEmpty = new Event()
		@onTabPressedHandler= null;
		@currentEditBox = null

		@highlightBox = new HighlightableTextBox(new Point(0,0),@)

		@minWidth = 0
		@minHeight = 20
		@minEditBoxWidth = 30

		@Size = new Point(@minWidth,@minHeight)

		@passive = false
		@selectTextOnShow = false;

	Move:(to) ->
		@relPosition = to
		@graphics.group.setAttribute("transform", "translate("+@relPosition.x+" "+@relPosition.y+")")

	CreateGraphics:(textClass)->
		@graphics = new Object()

		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.text = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@editBoxBlur   = ((evt) ->@onEditBoxBlur(evt)).bind(@)

		@graphics.text.setAttribute("x",5);
		@graphics.text.setAttribute("y",20);
		@graphics.text.setAttribute("height", @Size.y)
		@graphics.text.setAttribute("width", @Size.x)
		@graphics.text.setAttribute("class",textClass);
		@graphics.text.textContent = @text;
		@graphics.text.addEventListener("mouseover", @highlightBox.mouseOverHandle, false);
		@graphics.text.addEventListener("mouseup", @highlightBox.mouseUpHandle, false);

		@graphics.group.setAttribute("transform", "translate("+@relPosition.x+" "+@relPosition.y+")")
		@graphics.group.setAttribute("class", "EditBox")
		
		@graphics.group.addEventListener("mouseover", @mouseOverHandle, false);

		@highlightBox.CreateGraphics(@graphics)
		@graphics.group.appendChild(@graphics.border)
		@graphics.group.appendChild(@graphics.text)

		return @graphics.group

	getGraphics:()->
		return @graphics;

	resize:()->
		if(@text == "")
			@setDefaultSize()
		else
			@recalculateSize();

		newSize = new Object()
		newSize.width = @Size.x;
		newSize.height = @Size.y;

		@onSizeChange.pulse(newSize)

		@graphics.text.setAttribute("height", @Size.y)
		@graphics.text.setAttribute("width", @Size.x)
		@highlightBox.Resize();

	setDefaultSize:()->
		@Size.x =  @minWidth
		@Size.y = @minHeight



	recalculateSize:() ->
		@Size.x = @graphics.text.getBBox().width
		@Size.y = @graphics.text.getBBox().height

	calculateWidth:(newWidth)->
		sizeToUse = @Size.x
		if newWidth > @Size.x-20 then sizeToUse = newWidth+40
		else if newWidth < @Size.x-50 then sizeToUse = newWidth+ 40;
		Math.max(@minWidth, sizeToUse)

	calculateHeight:(newHeight)->
		Math.max(newHeight, @minHeight)

	onMouseOver:()->
		if not @passive
			window.UML.globals.highlights.HighlightTextElement(@)
		
	onMouseOut:()->
		if not @passive
			window.UML.globals.highlights.UnHighlightTextElement(@)
		
	onMouseUp:()->
		if not @passive
			@showEditBox();

	onEditBoxBlur:(evt)->
		@repopulateTextFromEditBox();
		@hideEditBox();
		

	OnSelect:()->
		@showEditBox();

	SelectAllText:()->
		@currentEditBox.select();

	Highlight:()->
		@highlightBox.Highlight()
	Unhighlight:()->
		@highlightBox.Unhighlight()

	DoHighlight:()->
		window.UML.globals.highlights.HighlightTextElement(@)
	DoUnhighlight:()->
		window.UML.globals.highlights.UnHighlightTextElement(@)


	SetText:(@text)->
		@onTextChange.pulse({prevText: @graphics.text.textContent;
		newText : @text});
		@UpdateText(@text)
		
		return;

	UpdateText:(@text)->
		@graphics.text.textContent = @text;

		if @currentEditBox != null
			@currentEditBox.value = @text

		@resize();

	repopulateTextFromEditBox:()->
		prevText = @text
		if(@currentEditBox != null)
			@SetText(@currentEditBox.value);
		
		@resize();

		if(@text == "")
			evt = new Object()
			evt.trigger = @
			@onBecomeEmpty.pulse(evt)

	showEditBox:()->
		#NEEDS OPTIMISATION 
		@currentEditBox = document.createElement("input")
		@currentEditBox.setAttribute("type", "text")
		@currentEditBox.setAttribute("id","CurrentlyActiveEditBox")
		@currentEditBox.value = @text

		windowCoord = window.UML.Utils.getScreenCoordForSVGElement(@graphics.border)
		@BindEditBoxEvents()
		@currentEditBox.setAttribute("style","position: fixed;height: "+@Size.y+"px;width: "+@SelectEditWidthSize()+"px;top: "+windowCoord.y+"px; left: "+windowCoord.x+"px;")
		@currentEditBox.addEventListener("blur", @editBoxBlur)

		document.getElementById('WorkArea').appendChild(@currentEditBox)

		if @selectTextOnShow
			@SelectAllText();

		@currentEditBox.focus();
		window.UML.Pulse.TextBoxSelected.pulse(null);

	BindEditBoxEvents:()->
		if @onTabPressedHandler != null
			globals.KeyboardListener.RegisterDownKeyInterest(9, @onTabPressedHandler) # tab press

	UnBindEditBoxEvents:()->
		if @onTabPressedHandler != null
			globals.KeyboardListener.UnRegisterDownKeyInterest(9, @onTabPressedHandler) #tab press

	SelectEditWidthSize:()->
		if @Size.x < @minEditBoxWidth
			return @minEditBoxWidth

		return @Size.x

	hideEditBox:()->
		@currentEditBox.removeEventListener("blur", @editBoxBlur)
		@UnBindEditBoxEvents();
		document.getElementById('WorkArea').removeChild(@currentEditBox)
		@currentEditBox = null

window.UML.TextBoxes.IntelligentPopoutPositioning.Position = (positionElements, popoutSize, targetPosition, targetSize)->
	windowWidth = window.innerWidth;

	targetPosition_Right = targetPosition.x + targetSize.x
	if targetPosition_Right + popoutSize.x > windowWidth
		return {element : positionElements.left, position : new Point(targetPosition.x, targetPosition.y + targetSize.y/2)}
	else 
		return {element : positionElements.right, position : new Point(targetPosition.x + targetSize.x, targetPosition.y+targetSize.y/2)}



class DefaultRow
	constructor:(width,@position)->
		@Size = new Point(width, 20)
		@onSizeChange = new Event();
		@highlightBox = new HighlightableTextBox(new Point(0,0),@)
		@routeResolver = undefined;

	CreateGraphics:(@RowNumber)->
		@graphics = new Object();
		@graphics

	Move:(@position)->
		@graphics.group.setAttribute("transform", "translate("+@position.x+" "+@position.y+")")

	Highlight:()->
		@highlightBox.Highlight()
	Unhighlight:()->
		@highlightBox.Unhighlight()

	DoHighlight:()->
		window.UML.globals.highlights.HighlightTextElement(@)
	DoUnhighlight:()->
		window.UML.globals.highlights.UnHighlightTextElement(@)

	Resize:()->
		@highlightBox.Resize()

	OnTextElemetChangeSizeHandler:(evt)->
		@ReCalculateSize()
		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)



class DefaultRowFactory
	constructor:()->

	Create:(position,width)-> new DefaultRow(width,position)

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

class EditableTextBoxTable
	constructor:(@position,@model)->
		@NextRowID = 0
		@height = 0
		@width = 50
		@onSizeChange = new Event()
		@onChildSizeChangeHandle  = ((evt) ->@onChildResize(evt)).bind(@)
		@rows = new IDIndexedList((RowItem)->RowItem.RowNumber)
		@rowFactory = new DefaultRowFactory()
		@routeResolver = new RouteResolver()
		@expanded = true;
		@model.onChange.add((@onModelChange).bind(@));
		@model.get("Items").onChange.add((@onModelListChange).bind(@));

	Move:(@position)->
		@graphics.group.setAttribute("transform", "translate("+@position.x+" "+@position.y+")")

	onChildResize:(evt)->
		@UpdateWidth(evt.width)
		@onSizeChange.pulse(null);

	UpdateWidth:(newWidth)->
		if @width < newWidth
			@width = newWidth
		else
			maxWidth = new Object();
			maxWidth.value = 0
			for row in @rows.List
				do (row,maxWidth)->
					if row.Size.x > maxWidth.value
						maxWidth.value = row.Size.x
			@width = maxWidth.value

	CreateGraphics:()->
		@graphics = new Object()
		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.group.setAttribute("transform", "translate("+@position.x+" "+@position.y+")")

		return @graphics.group;

	InitView:()->
		for model in @model.get("Items").list
			@addRow(model)

	addRow:(model)->
		@model.set("expanded", true)
		yPos = @height-20;

		row = @rowFactory.Create(new Point(0, yPos),@width,model)
		row.onSizeChange.add(@onChildSizeChangeHandle)
		
		row.routeResolver = new RouteResolver()
		row.routeResolver.routes = @routeResolver.routes
		row.routeResolver.createRoute("Row",row.routeResolver.resolveRoute("Table")+".rows.get("+@NextRowID+")")

		@rows.add(row)
		newRow = row.CreateGraphics(@NextRowID)
		@graphics.group.appendChild(newRow.group);
		row.Resize()
		@UpdateWidth(row.Size.x)
		@NextRowID += 1
		@onSizeChange.pulse(null)
		return row

	deleteRow:(rowModel)->
		row = null
		for rowit in @rows.List
			if rowit.model == rowModel
				row = rowit
				break

		if row == null
			return

		row = @rows.remove(row.RowNumber)
		row.deactivate()
		row.onDelete()
		@graphics.group.removeChild(row.graphics.group);
		ypos = new Point(0,0)
		for row in @rows.List
			do (row,ypos)->
				ypos.x = row.position.x
				row.Move(new Point(ypos.x, ypos.y))
				ypos.y+= 20

		@onSizeChange.pulse(null)


	Resize:()->
		if !@expanded
			@height = 5;
			return 

		@height = ((@rows.List.length*20)+20);
		for row in @rows
			row.Resize()

	Collapse:()->
		if @expanded
			@expanded = false;
			for row in @rows.List
				@graphics.group.removeChild(row.graphics.group)

			@onSizeChange.pulse(null)

	Expand:()->
		if !@expanded
			@expanded = true;
			for row in @rows.List
				@graphics.group.appendChild(row.graphics.group)


			@onSizeChange.pulse(null)

	onModelListChange:(evt)->
		if evt.changeType == "ADD"
			@addRow(evt.item)
		else if evt.changeType == "DEL"
			@deleteRow(evt.item)

	onModelChange:(evt)->
		if evt.name == "expanded"
			if evt.new_value
				@Expand();
			else
				@Collapse();


class ExpandButton
	constructor:(@context, @posX, @posY, @model)->
		@model.onChange.add((@OnModelChange).bind(@));
		
	CreateGraphics:()->
		@graphics = new Object();
		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.Symbol = document.createElementNS("http://www.w3.org/2000/svg", 'text');

		@graphics.group.setAttribute("transform","translate("+@posX+","+@posY+")")
		@graphics.group.setAttribute("class","expandButton")

		@graphics.group.addEventListener("mouseup", @onClick.bind(@));

		@graphics.Symbol.setAttribute("x",6);
		@graphics.Symbol.setAttribute("y",6);
		@graphics.Symbol.setAttribute("height", 12)
		@graphics.Symbol.setAttribute("width", 12)
		@graphics.Symbol.setAttribute("class","ClassSectionHeader");

		if(@model.get("extanded"))
			@SetExpanded();
		else
			@SetCollapsed();

		@graphics.group.appendChild(@graphics.Symbol);
		return @graphics.group;


	onClick:()->
		if @model.get("expanded")
			@model.set("expanded", false);
		else
			@model.set("expanded", true);

	SetExpanded:()->
		@graphics.Symbol.textContent = "[+]"

	SetCollapsed:()->
		@graphics.Symbol.textContent = "[-]"

	MoveDown:(@posY)->
		if @graphics
			@graphics.group.setAttribute("transform","translate("+@posX+","+@posY+")")

	OnModelChange:(evt)->
		if evt.name== "expanded"
			if evt.new_value
				@SetExpanded();
			else
				@SetCollapsed();

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




class MemberArgumentsTextBox extends EdiableTextBox
	constructor:(relPos, text)->
		super(relPos, text)

		@arguments = new Array();
		@currentMemberArg = new MemberArgument();
		@arguments.push(@currentMemberArg)


	CreateGraphics:(textClass)->
		super(textClass)

		@MemberGraphics = new Object();
		@MemberGraphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@MemberGraphics.text1 = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@MemberGraphics.text2 = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@MemberGraphics.text1.setAttribute("class",textClass);
		@MemberGraphics.text2.setAttribute("class",textClass);

		@MemberGraphics.text1.textContent = "("
		@MemberGraphics.text2.textContent = ")"
		ypos = @relPosition.y+20
		xpos = @relPosition.x + @Size.x
		@MemberGraphics.text1.setAttribute("transform", "translate("+@relPosition.x+" "+ypos+")")
		@MemberGraphics.text2.setAttribute("transform", "translate("+xpos+" "+ypos+")")

		@MemberGraphics.group.appendChild(@MemberGraphics.text1)
		@MemberGraphics.group.appendChild(@graphics.group)
		@MemberGraphics.group.appendChild(@MemberGraphics.text2)

		

		@MemberGraphics.group;

	getGraphics:()->
		return @MemberGraphics;

	resize:()->
		super()
		ypos = @relPosition.y+20
		xpos = @relPosition.x + @Size.x + 5 #+5 for padding 
		@MemberGraphics.text1.setAttribute("transform", "translate("+@relPosition.x+" "+ypos+")")
		@MemberGraphics.text2.setAttribute("transform", "translate("+xpos+" "+ypos+")")

	Move:(@position)->
		@relPosition = @position
		@graphics.group.setAttribute("transform", "translate("+@position.x+" "+@position.y+")")


	showEditBox:()->
		super()
		@currentMemberArg.activate($("#CurrentlyActiveEditBox"), @RefreshArgBox.bind(@))

	hideEditBox:()->
		super()
		@currentMemberArg.deactivate()

	RefreshArgBox:()->
		element = $("#CurrentlyActiveEditBox")[0]
		cursorIndex = element.selectionStart
		@onEditBoxBlur();
		@showEditBox();
		element = $("#CurrentlyActiveEditBox")[0]
		element.focus();
		element.setSelectionRange(cursorIndex,cursorIndex);

class MethodRow extends DefaultRow
	constructor:(width,@position, @model)->
		super(width, @position)

		@OnVisibilitySizeChange  = ((evt) ->@OnVisibilityChangeSizeHandler(evt)).bind(@) 
		@OnArgumentsSizeChange  = ((evt) ->@OnArgumentsChangeSizeHandler(evt)).bind(@) 
		@OnNameTxtBxSizeChange  = ((evt) ->@OnNameChangeSizeHandler(evt)).bind(@) 
		@OnReturnTxtBxSizeChange  = ((evt) ->@OnReturnChangeSizeHandler(evt)).bind(@)

		@OnNameChange = ((evt) ->@OnNameChangeHandler(evt)).bind(@)
		@OnReturnChange = ((evt) ->@OnReturnChangeHandler(evt)).bind(@) 
		@OnArgsChange = ((evt) ->@OnArgsChangeHandler(evt)).bind(@) 
		@OnVisChange = ((evt) ->@OnVisChangeHandler(evt)).bind(@) 


		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))
		@popoutDisplayed = false;


	CreateGraphics:(@RowNumber)->
		@graphics = new Object();
		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.VisibiityDropDown = new EdiableDropDown(new Point(0,0),@model.get("Vis"),["+","-","#"])
		@graphics.VisibiityDropDown.onTabPressedHandler = ((evt)->	@graphics.VisibiityDropDown.onEditBoxBlur(); @graphics.NameTexBox.OnSelect(); false;).bind(@)

		@graphics.NameTexBox = new EdiableTextBox(new Point(30,0),@model.get("Name"))
		@graphics.NameTexBox.onTabPressedHandler = ((evt)->	@graphics.NameTexBox.onEditBoxBlur(); @graphics.ArgumentsTextBox.OnSelect(); false;).bind(@)
		@graphics.NameTexBox.selectTextOnShow = true;

		@graphics.ArgumentsTextBox = new MemberArgumentsTextBox(new Point(30,0),@model.get("Args"))
		@graphics.ArgumentsTextBox.onTabPressedHandler = ((evt)->
			if !@graphics.ArgumentsTextBox.currentMemberArg.TypeSugestionBox.displayed
				@graphics.ArgumentsTextBox.onEditBoxBlur();
				@graphics.ReturnTextBox.OnSelect();
				false;).bind(@)

		@graphics.ReturnTextBox = new ReturnValueTextBox(new Point(30,0),@model.get("Return"))
		@graphics.ReturnTextBox.selectTextOnShow = true;
		@graphics.ReturnTextBox.onTabPressedHandler = ((evt)-> 
			@graphics.ReturnTextBox.onTabPress()
			@graphics.ReturnTextBox.onEditBoxBlur();
			@graphics.VisibiityDropDown.OnSelect();
			false;).bind(@)

		@graphics.NameTexBox.onTextChange.add(@OnNameChange)
		@graphics.ReturnTextBox.onTextChange.add(@OnReturnChange)
		@graphics.ArgumentsTextBox.onTextChange.add(@OnArgsChange)
		@graphics.VisibiityDropDown.onTextChange.add(@OnVisChange)

		@graphics.VisibiityDropDown.highlightBox.passive = true;
		@graphics.ReturnTextBox.highlightBox.passive = true;
		@graphics.ArgumentsTextBox.highlightBox.passive = true;
		@graphics.NameTexBox.highlightBox.passive = true;

		# connect sub componentes of row and use there ui triggers as our own
		@graphics.VisibiityDropDown.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.VisibiityDropDown.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.VisibiityDropDown.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)

		@graphics.ReturnTextBox.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.ReturnTextBox.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.ReturnTextBox.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)

		@graphics.ArgumentsTextBox.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.ArgumentsTextBox.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.ArgumentsTextBox.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)

		@graphics.NameTexBox.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.NameTexBox.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.NameTexBox.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)


		@graphics.VisibiityDropDown.onSizeChange.add(@OnVisibilitySizeChange)
		@graphics.ArgumentsTextBox.onSizeChange.add(@OnArgumentsSizeChange)
		@graphics.NameTexBox.onSizeChange.add(@OnNameTxtBxSizeChange)
		@graphics.ReturnTextBox.onSizeChange.add(@OnReturnTxtBxSizeChange)

		@highlightBox.CreateGraphics(@graphics)

		@graphics.group.appendChild(@graphics.border)
		@graphics.group.appendChild(@graphics.VisibiityDropDown.CreateGraphics("TextElement"))
		@graphics.group.appendChild(@graphics.ArgumentsTextBox.CreateGraphics("TextElement"))
		@graphics.group.appendChild(@graphics.NameTexBox.CreateGraphics("TextElement"))
		@graphics.group.appendChild(@graphics.ReturnTextBox.CreateGraphics("TextElement"))

		@graphics.group.setAttribute("class", "EditBoxRow")
		@graphics.group.setAttribute("transform", "translate("+@position.x+" "+@position.y+")")

		if @model.get("Abstract")
			@SetAbstractGraphics()

		@graphics

	Resize:()->
		@graphics.VisibiityDropDown.resize()
		@graphics.NameTexBox.resize()
		@graphics.ArgumentsTextBox.resize()
		@graphics.ReturnTextBox.resize()
		@ReCalculateSize()
		super()
		
	ReCalculateSize:()->
		spaceing = 10
		@Size.x = @graphics.VisibiityDropDown.Size.x + spaceing
		@graphics.NameTexBox.Move(new Point(@Size.x,0)); 

		@Size.x+= @graphics.NameTexBox.Size.x + spaceing
		@graphics.ArgumentsTextBox.Move(new Point(@Size.x,0));
		
		@Size.x+= @graphics.ArgumentsTextBox.Size.x + spaceing
		@graphics.ReturnTextBox.Move(new Point(@Size.x,0));

		@Size.x+= @graphics.ReturnTextBox.Size.x + spaceing

		if @popoutDisplayed
			@MovePopout()

	MovePopout:()->
		windowCoord = window.UML.Utils.getScreenCoordForSVGElement(@graphics.border)

		positionValues = window.UML.TextBoxes.IntelligentPopoutPositioning.Position({right: $('#popoverLinkMethR'), left: $('#popoverLinkMethL')},
			new Point(280, 0),
			windowCoord,
			@Size);

		if positionValues.element[0] != @popoverLink[0]
			@popoverLink.popover('hide')
			@popoverLink = positionValues.element
			@InitialisePopover()

		popoutPosition = positionValues.position
		
		@popoverLink.css("top",popoutPosition.y)
		@popoverLink.css("left",popoutPosition.x)
		@popoverLink.popover('show')

	OnVisibilityChangeSizeHandler:(evt)->
		@graphics.NameTexBox.resize()
		@graphics.ArgumentsTextBox.resize()
		@graphics.ReturnTextBox.resize()
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)


	OnNameChangeSizeHandler:(evt)->
		@graphics.ArgumentsTextBox.resize()
		@graphics.ReturnTextBox.resize()
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)


	OnArgumentsChangeSizeHandler:(evt)->
		@graphics.ReturnTextBox.resize()
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)

	OnReturnChangeSizeHandler:(evt)->
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)

	SetAbstractGraphics:()->
		$(@graphics.VisibiityDropDown.graphics.text).addClass("AbstractMethod")
		$(@graphics.NameTexBox.graphics.text).addClass("AbstractMethod")
		$(@graphics.ArgumentsTextBox.graphics.text).addClass("AbstractMethod")
		$(@graphics.ReturnTextBox.graphics.text).addClass("AbstractMethod")

	UnsetAbstractGraphics:()->
		$(@graphics.VisibiityDropDown.graphics.text).removeClass("AbstractMethod")
		$(@graphics.NameTexBox.graphics.text).removeClass("AbstractMethod")
		$(@graphics.ArgumentsTextBox.graphics.text).removeClass("AbstractMethod")
		$(@graphics.ReturnTextBox.graphics.text).removeClass("AbstractMethod")	

	SetAbstract:()->
		@model.set("Abstract", true);
		@SetAbstractGraphics();
		
	UnsetAbstract:()->
		@model.set("Abstract", false);
		@UnsetAbstractGraphics();

	InitialisePopover:()->
		@popoverLink.attr("data-original-title","Method Edit")

		if @model.get("Abstract")
			AbstractString = "<input type=\"checkbox\" checked id=\"Abstract\">Abstract"
		else
			AbstractString = "<input type=\"checkbox\" id=\"Abstract\">Abstract"

		if @model.get("Static")
			StaticString = "<input type=\"checkbox\" checked id=\"Static\">Static"
		else
			StaticString = "<input type=\"checkbox\" id=\"Static\">Static"

		StaticString+= "<div><span>Method Comment:</span><textarea id=\"classPropertyDescription\">"
		StaticString+=@model.get("Comment");
		StaticString+="</textarea></div>";

		StaticString += "<br/><br/><button type=\"button\" class=\"btn btn-danger\" onClick=\""+@routeResolver.resolveRoute("Table")+".rows.get("+@RowNumber+").model.del();\" >Delete</button>"

		@popoverLink.attr("data-content",AbstractString+"<br>"+StaticString)


	OnSelect:()->
		evt = new Object()
		evt.textBoxGroup = @
		window.UML.Pulse.TextBoxGroupSelected.pulse(evt)

		$(@graphics.border).addClass("selectedRow")
		windowCoord = window.UML.Utils.getScreenCoordForSVGElement(@graphics.border)
		
		positionValues = window.UML.TextBoxes.IntelligentPopoutPositioning.Position({right: $('#popoverLinkMethR'), left: $('#popoverLinkMethL')},
			new Point(280, 0),
			windowCoord,
			@Size);

		@popoverLink = positionValues.element
		popoutPosition = positionValues.position
		
		@popoverLink.css("top",popoutPosition.y)
		@popoverLink.css("left",popoutPosition.x)
		
		@popoverLink.popover('hide')
		@InitialisePopover()
		@popoverLink.popover('show')

		@popoutDisplayed = true;

		@graphics.VisibiityDropDown.highlightBox.passive = false;
		@graphics.ReturnTextBox.highlightBox.passive = false;
		@graphics.NameTexBox.highlightBox.passive = false;
		@graphics.ArgumentsTextBox.highlightBox.passive = false;

	deactivate:()->
		$(@graphics.border).removeClass("selectedRow")
		@model.set("Static",$('#Static').is(':checked'));

		if not @model.get("Abstract")  and $('#Abstract').is(':checked')
			@SetAbstract()
		else if @model.get("Abstract") and not $('#Abstract').is(':checked')
			@UnsetAbstract()
		@model.set("Comment",$("#classPropertyDescription").val())
		
		if @popoverLink
			@popoverLink.popover('destroy')

		@popoutDisplayed = false;

		@graphics.VisibiityDropDown.highlightBox.passive = true;
		@graphics.ReturnTextBox.highlightBox.passive = true;
		@graphics.NameTexBox.highlightBox.passive = true;
		@graphics.ArgumentsTextBox.highlightBox.passive = true;

	onDelete:()->

	OnNameChangeHandler:(evt)->
		@model.set("Name",evt.newText);
	OnReturnChangeHandler:(evt)->
		@model.set("Return",evt.newText);
	OnArgsChangeHandler:(evt)-> 
		@model.set("Args",evt.newText);
	OnVisChangeHandler:(evt)->
		@model.set("Vis",evt.newText);

	OnModelChange:(evt)->
		if evt.name == "Name"
			@graphics.NameTexBox.UpdateText(evt.new_value)
		else if evt.name == "Return"
			@graphics.ReturnTextBox.UpdateText(evt.new_value)
		else if evt.name == "Vis"
			@graphics.VisibiityDropDown.UpdateText(evt.new_value)
		else if evt.name == "Args"
			 @graphics.ArgumentsTextBox.UpdateText(evt.new_value)
		else if evt.name == "Abstract"
			if evt.new_value
				@SetAbstractGraphics();
			else
				@UnsetAbstractGraphics();



		




class MethodRowFactory
	constructor:()->

	Create:(position,width, model)-> 

		methodRow = new MethodRow(width,position, model)
		
		return methodRow


window.UML.Pulse.TextBoxGroupSelected = new Event()

class PropertyRow extends DefaultRow
	constructor:(width,@position,@model)->
		super(width, @position)

		@OnVisibilitySizeChange  = ((evt) ->@OnVisibilityChangeSizeHandler(evt)).bind(@)
		@OnNameSizeChange  = ((evt) ->@OnNameChangeSizeHandler(evt)).bind(@)

		@OnNameChange = ((evt) ->@OnNameChangeHandler(evt)).bind(@)
		@OnTypeChange = ((evt) ->@OnTypeChangeHandler(evt)).bind(@)
		@OnVisChange = ((evt) ->@OnVisChangeHandler(evt)).bind(@)
		

		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))

	
	CreateGraphics:(@RowNumber)->
		@graphics = new Object();
		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.VisibiityDropDown = new EdiableDropDown(new Point(0,0),@model.model.Vis,["+","-","#"])
		@graphics.VisibiityDropDown.onTabPressedHandler = ((evt)-> @graphics.VisibiityDropDown.onEditBoxBlur(); @graphics.NameTexBox.OnSelect(); false;).bind(@)

		@graphics.TypeTextBox = new ReturnValueTextBox(new Point(10,0),@model.get("Type"))
		@graphics.TypeTextBox.selectTextOnShow = true;
		@graphics.TypeTextBox.onTabPressedHandler = ((evt)-> 
			@graphics.TypeTextBox.onTabPress()
			@graphics.TypeTextBox.hideEditBox();
			@graphics.VisibiityDropDown.OnSelect();
			false;).bind(@)

		@graphics.NameTexBox = new EdiableTextBox(new Point(30,0),@model.model.Name)
		@graphics.NameTexBox.selectTextOnShow = true;
		@graphics.NameTexBox.onTabPressedHandler = ((evt)->	@graphics.NameTexBox.onEditBoxBlur(); @graphics.TypeTextBox.OnSelect(); false;).bind(@)

		@graphics.VisibiityDropDown.highlightBox.passive = true;
		@graphics.TypeTextBox.highlightBox.passive = true;
		@graphics.NameTexBox.highlightBox.passive = true;

		@graphics.NameTexBox.onTextChange.add(@OnNameChange)
		@graphics.TypeTextBox.onTextChange.add(@OnTypeChange)
		@graphics.VisibiityDropDown.onTextChange.add(@OnVisChange)
		
		

		# connect sub componentes of row and use there ui triggers as our own
		@graphics.VisibiityDropDown.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.VisibiityDropDown.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.VisibiityDropDown.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)

		@graphics.TypeTextBox.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.TypeTextBox.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.TypeTextBox.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)

		@graphics.NameTexBox.highlightBox.OnMouseOver.add(@highlightBox.mouseOverHandle)
		@graphics.NameTexBox.highlightBox.OnMouseUp.add(@highlightBox.mouseUpHandle)
		@graphics.NameTexBox.highlightBox.OnMouseExit.add(@highlightBox.mouseOutHandle)


		@graphics.VisibiityDropDown.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@graphics.TypeTextBox.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@graphics.NameTexBox.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))

		@highlightBox.CreateGraphics(@graphics)

		@graphics.group.appendChild(@graphics.border)
		@graphics.group.appendChild(@graphics.VisibiityDropDown.CreateGraphics("TextElement"))
		@graphics.group.appendChild(@graphics.TypeTextBox.CreateGraphics("TextElement"))
		@graphics.group.appendChild(@graphics.NameTexBox.CreateGraphics("TextElement"))

		@graphics.group.setAttribute("class", "EditBoxRow")
		@graphics.group.setAttribute("transform", "translate("+@position.x+" "+@position.y+")")
		@graphics

	OnTextElemetChangeSizeHandler:(evt)->
		@ReCalculateSize()
		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)

	Resize:()->
		@graphics.TypeTextBox.resize()
		@graphics.VisibiityDropDown.resize()
		@graphics.NameTexBox.resize()
		@ReCalculateSize()
		@highlightBox.Resize()
		super()
		

	ReCalculateSize:()->
		spaceing = 10
		@Size.x = @graphics.VisibiityDropDown.Size.x + spaceing
		@graphics.NameTexBox.Move(new Point(@Size.x,0)); 

		@Size.x+= @graphics.NameTexBox.Size.x + spaceing
		@graphics.TypeTextBox.Move(new Point(@Size.x,0));

		@Size.x+= @graphics.TypeTextBox.Size.x + spaceing

	OnSelect:()->
		evt = new Object()
		evt.textBoxGroup = @
		window.UML.Pulse.TextBoxGroupSelected.pulse(evt)
		
		$(@graphics.border).addClass("selectedRow")

		windowCoord = window.UML.Utils.getScreenCoordForSVGElement(@graphics.border)

		positionValues = window.UML.TextBoxes.IntelligentPopoutPositioning.Position({right: $('#popoverLinkPropR'), left: $('#popoverLinkPropL')},
			new Point(107, 0),
			windowCoord,
			@Size);

		@popoverLink = positionValues.element
		popoutPosition = positionValues.position

		@popoverLink.css("top",popoutPosition.y)
		@popoverLink.css("left",popoutPosition.x)
		@popoverLink.attr("data-original-title","Property Edit")

		if @model.get("Static")
			StaticString = "<input type=\"checkbox\" checked id=\"Static\">Static"
		else
			StaticString = "<input type=\"checkbox\" id=\"Static\">Static"

		StaticString += "<br/><br/><button type=\"button\" class=\"btn btn-danger\" onClick=\""+@routeResolver.resolveRoute("Table")+".rows.get("+@RowNumber+").model.del();\">Delete</button>"

		@popoverLink.popover('hide')
		@popoverLink.attr("data-content",StaticString)
		@popoverLink.popover('show')

		@graphics.VisibiityDropDown.highlightBox.passive = false;
		@graphics.TypeTextBox.highlightBox.passive = false;
		@graphics.NameTexBox.highlightBox.passive = false;

	deactivate:()->
		$(@graphics.border).removeClass("selectedRow")
		@model.set("Static", $('#Static').is(':checked'))

		if @popoverLink
			@popoverLink.popover('destroy')

		@graphics.VisibiityDropDown.highlightBox.passive = true;
		@graphics.TypeTextBox.highlightBox.passive = true;
		@graphics.NameTexBox.highlightBox.passive = true;
	
	OnVisibilityChangeSizeHandler:(evt)->
		@graphics.TypeTextBox.resize()
		@graphics.NameTexBox.resize()
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)

	OnNameChangeSizeHandler:(evt)->
		@graphics.TypeTextBox.resize()
		@ReCalculateSize()

		@highlightBox.Resize()
		evt = new Object()
		evt.width = @Size.x
		@onSizeChange.pulse(evt)

	onDelete:()->

	OnNameChangeHandler:(evt)->
		@model.set("Name", evt.newText)

	OnTypeChangeHandler:(evt)->
		@model.set("Type", evt.newText)	

	OnVisChangeHandler:(evt)->
		@model.set("Vis", evt.newText)			

	OnModelChange:(evt)->
		if evt.name == "Name"
			@graphics.NameTexBox.UpdateText(evt.new_value)
		else if evt.name == "Type"
			@graphics.TypeTextBox.UpdateText(evt.new_value)
		else if evt.name == "Vis"
			@graphics.VisibiityDropDown.UpdateText(evt.new_value)


	
	




class PropertyRowFactory
	constructor:()->

	Create:(position,width,model)->

		newproptery = new PropertyRow(width,position,model)

		return newproptery

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

class SVGButton
	constructor:(@bttnText, @position)->
		@onClickEvt = new Event();

	AddOnClick:(handler)->
		@onClickEvt.add(handler);

	MoveDown:(ypos)->
		@position.y = ypos;
		@graphics.group.setAttribute("transform","translate("+@position.x+","+@position.y+")")

	CreateGraphics:()->
		@graphics = new Object();
		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.bttn = document.createElementNS("http://www.w3.org/2000/svg", 'rect');
		@graphics.txt = document.createElementNS("http://www.w3.org/2000/svg", 'text');

		@graphics.group.setAttribute("transform","translate("+@position.x+","+@position.y+")")
		@graphics.group.setAttribute("class","SVGButton")
		@graphics.group.setAttribute("fill-opacity",0)
		@graphics.group.setAttribute("stroke-opacity",0)
		@graphics.group.addEventListener("mouseup", (@onClick).bind(@));

		@graphics.bttn.setAttribute("x",0);
		@graphics.bttn.setAttribute("y",0);
		@graphics.bttn.setAttribute("rx",4);
		@graphics.bttn.setAttribute("ry",4);
		@graphics.bttn.setAttribute("height", 14)
		@graphics.bttn.setAttribute("width", 25)
		@graphics.bttn.setAttribute("class","SVGBttnBorder");

		@graphics.txt.setAttribute("x", 2)
		@graphics.txt.setAttribute("y", 11)
		@graphics.txt.setAttribute("class", "SVGBttnText")
		@graphics.txt.textContent = @bttnText;

		@graphics.group.appendChild(@graphics.bttn);
		@graphics.group.appendChild(@graphics.txt);

		return @graphics.group;

	############################################
	#	Called When Button Clicked from UI
	############################################
	onClick:(evt)->
		@onClickEvt.pulse(null);

	SetButtonText:(@bttnText)->
		@graphics.txt.textContent = @bttnText;

	Hide:()->
		@graphics.group.setAttribute("fill-opacity",0)
		@graphics.group.setAttribute("stroke-opacity",0)

	Show:()->
		@graphics.group.setAttribute("fill-opacity",1)
		@graphics.group.setAttribute("stroke-opacity",1)



class TableColumn
	constructor:(@width, @position)->
		@onWidthChange = new Event()
		@onHeightChange = new Event()
		@onCellBecomesEmpty = new Event()
		@rows = new Array()
		@height = 0
		@defaultValue = ""
		@onWidthChangeHandle  = ((evt) ->@onItemWidthChange(evt)).bind(@)
		@onCellEmptyHandl = ((evt) ->@onCellBecameEmpty(evt)).bind(@)

	Move:(@position)->
		@graphics.group.setAttribute("transform", "translate("+@position.x+" "+@position.y+")")

	CreateGraphics:()->
		@graphics = new Object()
		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');

		@graphics.group.setAttribute("transform", "translate("+@position.x+" "+@position.y+")")
		return @graphics.group

	Resize:()->
		for row in @rows
			do (row)->
				row.resize() 

	addRow:(value)->
		if(typeof value == "undefined" || value == null)
			value = @defaultValue

		txtBx = new EdiableTextBox(new Point(0,@height), value)
		txtBx.onBecomeEmpty.add(@onCellEmptyHandl)

		@height += txtBx.height+5
		txtBx.onSizeChange.add(@onWidthChangeHandle)
		@rows.push(txtBx)
		@graphics.group.appendChild(txtBx.CreateGraphics())
		@onHeightChange.pulse(null)

	deleteRow:(index)->
		txtBx = @rows[index]
		@height -= txtBx.height+5
		txtBx.onSizeChange.remove(@onWidthChangeHandle)
		@graphics.group.removeChild(txtBx.getGraphics().group)
		@rows.splice(index, 1)
		@onHeightChange.pulse(null)
		ref = @
		yDelta = txtBx.height+5

		if(@rows.length > 0)
			for row in [index..@rows.length-1]
				do(row,ref, yDelta)->
					txtBox = ref.rows[row]
					txtBox.Move(new Point(txtBox.relPosition.x,txtBox.relPosition.y - yDelta))



	onItemWidthChange:(evt)->
		ref = @
		prevWidth = @width
		@width = 0;
		for row in @rows
			do(row,ref)->
				if(row.width > ref.width)
					ref.width = row.width

		if(@width !=prevWidth)
			@onWidthChange.pulse(null)

		return

	onCellBecameEmpty:(evt)->
		evtArg = new Object()
		evtArg.EmptyRow = @rows.indexOf(evt.trigger)
		@onCellBecomesEmpty.pulse(evtArg)


window.UML.Pulse.TypeSugestionClicked = new Event()

class window.UML.TextBoxes.TypeSugestionBox
	constructor:()->
		@NO_SELECTION = 0
		
		@onTypeSugestionMade = new Event()

		@SelectedIndex = @NO_SELECTION
		@displayed = false
		window.UML.Pulse.TypeSugestionClicked.add(((evt)-> @onTypeClicked(evt)).bind(@))

	Show:(@Position)->
		@UpdateStringPartial("")
		$("#typeSugestionList").css({display: "block",left: @Position.x,top: @Position.y});

		window.UML.globals.KeyboardListener.RegisterDownKeyInterest(40, @MoveSelectionDown.bind(@))
		window.UML.globals.KeyboardListener.RegisterDownKeyInterest(38, @MoveSelectionUp.bind(@))
		@displayed = true

	Hide:()->
		$("#typeSugestionList").css({display: "none"});

		window.UML.globals.KeyboardListener.UnRegisterDownKeyInterest(40, @MoveSelectionDown.bind(@))
		window.UML.globals.KeyboardListener.UnRegisterDownKeyInterest(38, @MoveSelectionUp.bind(@))
		@displayed = false

	UpdateStringPartial:(str)->
		selections = new Array();
		node = globals.CommonData.Types.GetSelections(str);
		node.ListChildren(selections);

		$("#typeSugestionList ul").html("")
		@SelectionLength = selections.length
		for selection in selections 
			do(selection)->
				$("#typeSugestionList ul").append("<li><a>"+selection+"</a></li>")

		$("#typeSugestionList ul li a").mousedown((evt)-> window.UML.Pulse.TypeSugestionClicked.pulse({selection : $(this)}))

		# if the root node is returned then no matches were found so select nothing
		if globals.CommonData.Types.IsRoot(node)
			@SelectedIndex = @NO_SELECTION
		else
			@SelectedIndex = 1

		@ActivateSelected()

	onTypeClicked:(evt)->
		if @displayed
			@onTypeSugestionMade.pulse(evt)

	MoveSelectionDown:(evt)->
		@DeActivateSelected()
		@SelectedIndex++;
		@SelectedIndex =  if @SelectedIndex > @SelectionLength then 0 else @SelectedIndex
		@ActivateSelected()

		evt.preventDefault();
		return false;

	MoveSelectionUp:(evt)->
		@DeActivateSelected()
		@SelectedIndex--;
		@SelectedIndex =  if @SelectedIndex <= 0 then @SelectionLength else @SelectedIndex
		@ActivateSelected()

		evt.preventDefault();
		return false

	DeActivateSelected:()->
		$("#typeSugestionList ul li:nth-child("+@SelectedIndex+")").removeClass("active");

	ActivateSelected:()->
		$("#typeSugestionList ul li:nth-child("+@SelectedIndex+")").addClass("active");

	GetSelectedText:()->
		if @SelectedIndex != @NO_SELECTION
			$("#typeSugestionList ul li:nth-child("+@SelectedIndex+") a").html()
		else
			null

class window.UML.Arrows.ArrowEndPoint
	constructor: (@context, @model) ->
		@displayed = false
		@inArrowFollow = false
		@endPoint = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
		@endPoint.setAttribute("r","5")
		@endPoint.setAttribute("fill","#3385D6")
		@endPoint.setAttribute("class","arrowDrag")

		@preliminaryLockedData = {};
		@preliminaryLockedData.Position = @model.get("Position")
		@latestPositionForDraw = @model.get("Position")

		@Followed = new Event();
		@UnFollowed = new Event()

		@position = @model.get("Position") # cach a copy of the model position

		@Connection = new window.UML.Arrows.ArrowConnection(@arrow)

	getLastestPosition: ()->
		if @inArrowFollow
			return @preliminaryLockedData.Position
		else
			return @model.get("Position")

	del: ()->
		if @displayed
			globals.document.removeChild(@endPoint)

	Show: () ->
		@displayed = true
		globals.document.appendChild(@endPoint)
	Hide: () ->
		@displayed = false
		globals.document.removeChild(@endPoint)

	Redraw:() ->
		pos = @getLastestPosition();
		if @arrowEndPoint
			@arrowEndPoint.Move(pos);
			
		@endPoint.setAttribute("cx",pos.x)
		@endPoint.setAttribute("cy",pos.y)

	ResetEndpoint1:(@arrowEndPoint)->
		
	ResetEndpoint2:(@arrowEndPoint)->

	OnMouseMove:(evt) ->
		if @preliminaryLockedData.Locked
			return

		loc = window.UML.Utils.mousePositionFromEvent(evt);

		@preliminaryLockedData.Position = loc
		@context.redraw();
		return

	OnDropZoneActive:(evt)->
		@preliminaryLockedData.Locked = true;
		@preliminaryLockedData.LockedClass = evt.classID
		@preliminaryLockedData.LockedIndex = evt.index
		@preliminaryLockedData.Position = evt.position
		@position = evt.position;

		@context.redraw();
		return

	OnDropZoneLeave:(evt)->
		@preliminaryLockedData.Locked = false;
		@preliminaryLockedData.LockedClass = -1
		@preliminaryLockedData.LockedIndex = 0
		return

	Follow:()->
		@inArrowFollow = true
		@Followed.pulse()
		@endPoint.setAttribute("pointer-events","none");

		@mouseMoveHandle = ((evt) ->@OnMouseMove(evt)).bind(@) 
		@dropZoneLeave = ((evt) ->@OnDropZoneLeave(evt)).bind(@)
		@dropZoneActive = ((evt) ->@OnDropZoneActive(evt)).bind(@)

		document.addEventListener("mousemove",@mouseMoveHandle,false);

		window.UML.Pulse.DropZoneEnter.add(@dropZoneActive)	
		window.UML.Pulse.DropZoneLeave.add(@dropZoneLeave)	

	UnFollow:()->
		@inArrowFollow = false
		document.removeEventListener("mousemove",@mouseMoveHandle,false);
		window.UML.Pulse.DropZoneEnter.remove(@dropZoneActive)
		window.UML.Pulse.DropZoneLeave.remove(@dropZoneLeave)
		@mouseMoveHandle = 0
		@dropZoneLeave = 0
		@dropZoneActive = 0

		@UnFollowed.pulse()
		@endPoint.setAttribute("pointer-events","all");

	# This method applys the model data stored in the preliminaryLockedData
	# the preliminaryLockedData is populated when the arrow is being dragged arround
	ApplyPrelimineryLockData:()->
		@model.setGroup([{name: "Position", value: @preliminaryLockedData.Position},
						 {name: "Locked", value: @preliminaryLockedData.Locked},
						 {name: "LockedIndex", value: @preliminaryLockedData.LockedIndex},
						 {name: "LockedClass", value: @preliminaryLockedData.LockedClass}]);
	
	ResetPreliminery:()->
		@preliminaryLockedData.Position = @model.get("Position")
		@preliminaryLockedData.Locked = @model.get("Locked")
		@preliminaryLockedData.LockedIndex = @model.get("LockedIndex")
		@preliminaryLockedData.LockedClass = @model.get("LockedClass")

window.UML.Arrows.Arrow_On_Follow = new Event();
window.UML.Arrows.Arrow_Un_Follow = new Event();

class window.UML.Arrows.Arrow
	constructor: (@model)->
		
		@model.set("id",@model.modelItemID)
		@ARROW_HEAD_LENGTH = 10;
		@segments = new Array();
		@bendPoints = new Array();

		@hoveredLineSegment = null;

		@arrow = document.createElementNS("http://www.w3.org/2000/svg", 'use');
		@arrow.setAttributeNS('http://www.w3.org/1999/xlink','xlink:href','#arrowHeadU');
		@arrow.setAttribute("class","ArrowHead");
			
		@On_Follow_Handel = ((evt)->@On_Follow(evt)).bind(@);
		@On_UnFollow_Handel = ((evt)->@On_UnFollow(evt)).bind(@);
		@On_Mouse_down_handel = ((evt)->@OnMouseDown(evt)).bind(@);
		@On_Mouse_hover_handel = ((evt)->@OnMouseOver(evt)).bind(@);
		@On_Mouse_leave_handel = ((evt)->@OnMouseLeave(evt)).bind(@);

		start = @model.get("Head").get("Position")
		end = @model.get("Tail").get("Position")
		@firstSegment = new window.UML.Arrows.LineSegment(new Point(start.x,start.y), new Point(end.x,end.y))
		@arrowHead = new window.UML.Arrows.ArrowHeadPoint(@,@model.get("Head"))
		@arrowHead.Followed.add(@On_Follow_Handel)
		@arrowHead.UnFollowed.add(@On_UnFollow_Handel)
		@arrowTail = new window.UML.Arrows.ArrowTailPoint(@,@model.get("Tail"))
		@arrowTail.Followed.add(@On_Follow_Handel)
		@arrowTail.UnFollowed.add(@On_UnFollow_Handel)

		@firstSegment.Connect(@arrowTail,@arrowHead)

		@firstSegment.Clicked.add(@On_Mouse_down_handel);
		@firstSegment.MouseHover.add(@On_Mouse_hover_handel);
		@firstSegment.MouseLeave.add(@On_Mouse_leave_handel);

		@firstSegment.CreateGraphicsObject()
		@segments.push(@firstSegment)

		@model.onChange.add(((evt)->@On_Model_Change(evt)).bind(@))

		@CheckForArrowTypeChange()
		@redraw()
		globals.document.appendChild(@arrow)

		return

	Bend:(at)->
			newSegment = new window.UML.Arrows.LineSegment(at, new Point(@hoveredLineSegment.position2.x,@hoveredLineSegment.position2.y))
			newSegment.Clicked.add(@On_Mouse_down_handel);
			newSegment.MouseHover.add(@On_Mouse_hover_handel);
			newSegment.MouseLeave.add(@On_Mouse_leave_handel);

			@segments.push(newSegment)
			newBendPoint = new window.UML.Arrows.BendPoint(at,@)
			@bendPoints.push(newBendPoint)
			newBendPoint.CreateGraphicsObject();
			newSegment.CreateGraphicsObject();

			newSegment.Connect(newBendPoint,@hoveredLineSegment.Connection2)

			@hoveredLineSegment.Connect(@hoveredLineSegment.Connection1,newBendPoint)
			newBendPoint.Move(at);
			
			@CheckForArrowTypeChange()

	del: ()->
		globals.document.removeChild(@arrow)
		
		for segment in @segments
			do(segment)->
				segment.del()

		for bendPoint in @bendPoints
			do(bendPoint)->
				bendPoint.del();

		@arrowTail.del()
		@arrowHead.del()

		globals.arrows.remove(@model.get("id"))


	recalculateHeadAngle:(end)->
		if @arrowHead.arrowEndPoint # if this is not set we are not done initialising yet
			lastSegmentPos = @arrowHead.arrowEndPoint.ref.position1
			rad = Math.atan2((end.y - lastSegmentPos.y),(end.x - lastSegmentPos.x));
			deg = rad * (180/Math.PI)
			return deg + 90
		else 
			return 0;


	redraw:->
		end = @arrowHead.getLastestPosition(); # redraw with the latest value of the position
		start = @arrowTail.getLastestPosition();

		@arrowHead.Redraw()
		@arrowTail.Redraw()

		for segment in @segments
			do(segment)->
				segment.Redraw()

		arrowHeadAng = @recalculateHeadAngle(end)
		arrowHeadAngRad = arrowHeadAng* (Math.PI / 180)
		xLineOffset = Math.sin(arrowHeadAngRad) * @ARROW_HEAD_LENGTH
		yLineOffset = Math.cos(arrowHeadAngRad) * @ARROW_HEAD_LENGTH


		@arrow.setAttribute("x",end.x)
		@arrow.setAttribute("y",end.y)
		@arrow.setAttribute("transform","rotate("+arrowHeadAng.toString()+" "+end.x+" "+end.y+")")
		return

	setDashedArrow: ->
		for segment in @segments
			do(segment)->
				segment.SetDashedArrow()

	setNormalArrow:->
		for segment in @segments
			do(segment)->
				segment.SetNormalArrow()

	deactivate:->
		if @active
			@active = false
			@arrowHead.Hide()
			@arrowTail.Hide()
			for bendpoint in @bendPoints
				do(bendpoint)->
					bendpoint.Hide();
			
			@OnMouseLeave()
		return

	OnMouseDown:(evt) ->
		@active = true;
		@arrowHead.Show();
		@arrowTail.Show();
		for bendpoint in @bendPoints
			do(bendpoint)->
				bendpoint.Show();

		evt.arrow = @
		window.UML.Pulse.SingleArrowActivated.pulse(evt)

	OnMouseOver:(evt) ->
		@hoveredLineSegment = evt.lineSegment;
		globals.highlights.HighlightArrow(@);

	OnMouseLeave:(evt) ->
		globals.highlights.UnHighlightArrow();

	Unhighlight:()->
		if not @active
			for segment in @segments
				do(segment)->
					segment.ArrowUnHover()

		$(@arrow).removeClass("ArrowHeadHover")	

	Highlight:()->
		for segment in @segments
			do(segment)->
				segment.ArrowHover()
		$(@arrow).addClass("ArrowHeadHover")

	DisablePointerEvents: ->
		@arrow.setAttribute("pointer-events","none");
		for segment in @segments
				do(segment)->
					segment.DisablePointerEvents()
		return

	CheckForArrowTypeChange: ->
		@setNormalArrow();
		if(@model.get("Head").get("Locked") && @model.get("Tail").get("Locked"))
			headClass = globals.classes.get(@model.get("Head").get("LockedClass"))

			if headClass.IsInterface
				@setDashedArrow()

	EnablePointerEvents: ->
		@arrow.setAttribute("pointer-events","all");
		for segment in @segments
			do(segment)->
				segment.EnablePointerEvents()
		return 

	On_Follow:()->
		@DisablePointerEvents()
		window.UML.Arrows.Arrow_On_Follow.pulse()

	On_UnFollow:()->
		@EnablePointerEvents()
		window.UML.Arrows.Arrow_Un_Follow.pulse()

	On_Model_Change:(evt)->


class window.UML.Arrows.ArrowConnection
	constructor:(@arrow)->
		@currentConnection = null
		@connected = false


	ReconnectTo:(Class, index)->
		@Disconnect()		
		@currentConnection = globals.classes.get(Class).Arrows.To
		@currentIndex = index;
		@currentConnection.Attatch(index, @arrow)
		@connected = true;
		Debug.write("Arrow Head connected to Class: "+Class+" at index: "+index)

	ReconnectFrom:(Class, index)->
		@Disconnect()		
		@currentConnection = globals.classes.get(Class).Arrows.From
		@currentIndex = index;
		@currentConnection.Attatch(index, @arrow)
		@connected = true;
		Debug.write("Arrow Tail connected from Class: "+Class+" at index: "+index)


	Disconnect:()->
		if @connected
			@currentConnection.Detatch(@currentIndex, @arrow)
			@connected = false
			Debug.write("Arrow disconnected to at index: "+@currentIndex)

class window.UML.Arrows.ArrowHeadPoint extends window.UML.Arrows.ArrowEndPoint
	constructor:(@arrow,@model) ->
		super(@arrow, @model)
		@endPoint.setAttribute("onmousedown","window.UML.SetArrowHeadFollow("+@arrow.model.get("id")+")")
		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))

		if @model.get("Locked") and @model.get("LockedClass") != -1 and @model.get("LockedIndex") != -1
				@Connection.ReconnectTo(@model.get("LockedClass"), @model.get("LockedIndex"))
		

	OnMouseUp:(evt)->
		@UnFollow()

	Follow: ()->
		super
		@mouseUpHandle = ((evt) ->@OnMouseUp(evt)).bind(@)
		document.addEventListener("mouseup", @mouseUpHandle, false);
		@Connection.Disconnect();
		

	UnFollow: ()->
		#Check to see if the class is being connected to itself if so then veto the connection
		if @preliminaryLockedData.LockedClass != @arrow.model.get("Tail").get("LockedClass") ||
		@preliminaryLockedData.LockedClass == -1
			@ApplyPrelimineryLockData();
		else
			Debug.write("Arrow ConnectionVetoed (same class)")
		@ResetPreliminery();
		document.removeEventListener("mouseup", @mouseUpHandle, false);
		@mouseUpHandle =0

		super

	OnModelChange:(evt)->
		if evt.name  == "Position"
			@position.x = evt.new_value.x
			@position.y = evt.new_value.y
		else if evt.name == "Locked"
			@CheckForConnectionChange()
		else if evt.name == "LockedIndex"
			@CheckForConnectionChange()
		else if evt.name == "LockedClass"
			@CheckForConnectionChange()

		@arrow.redraw()

	CheckForConnectionChange:()->
		if @model.get("Locked") and @model.get("LockedClass") != -1 and @model.get("LockedIndex") != -1
			@Connection.ReconnectTo(@model.get("LockedClass"), @model.get("LockedIndex"))
			@arrow.CheckForArrowTypeChange();
		else
			@Connection.Disconnect();

	del: ()->
		super
		@Connection.Disconnect();

class window.UML.Arrows.ArrowTailPoint extends window.UML.Arrows.ArrowEndPoint
	constructor:(@arrow, @model) ->
		super(@arrow, @model)

		@model.set("Locked", true)
		@endPoint.setAttribute("onmousedown","window.UML.SetArrowTailFollow("+@arrow.model.get("id")+")")
		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))

		connectTest = @model.get("Locked")
		connectTest = connectTest and @model.get("LockedClass") and @model.get("LockedClass") != -1
		connectTest = connectTest and @model.get("LockedIndex") and @model.get("LockedIndex") != -1

		if connectTest
				@Connection.ReconnectFrom(@model.get("LockedClass"), @model.get("LockedIndex"))

	OnMouseUp:(evt)->
		@UnFollow()

	Follow: ()->
		super
		@mouseUpHandle = ((evt) ->@OnMouseUp(evt)).bind(@)
		document.addEventListener("mouseup", @mouseUpHandle, false);

		@Connection.Disconnect();

	OnModelChange:(evt)->
		if evt.name  == "Position"
			@position.x = evt.new_value.x
			@position.y = evt.new_value.y
		else if evt.name == "Locked"
			if !evt.new_value
				@Connection.Disconnect();
		else if evt.name == "LockedClass"
			if @model.get("Locked") and @model.get("LockedClass") != -1 and @model.get("LockedIndex") != -1
				@Connection.ReconnectFrom(@model.get("LockedClass"), @model.get("LockedIndex"))
				@arrow.CheckForArrowTypeChange();
		else if evt.name == "LockedIndex"
			@lockedIndex = evt.new_value

		@arrow.redraw()

	UnFollow: ()->
		#Check to see if the class is being connected to itself if so then veto the connection
		if @preliminaryLockedData.LockedClass != @arrow.model.get("Head").get("LockedClass") ||
		@preliminaryLockedData.LockedClass == -1
			@ApplyPrelimineryLockData();
		else
			Debug.write("Arrow Connection Vetoed (same class)")

		@ResetPreliminery();
		document.removeEventListener("mouseup", @mouseUpHandle, false);
		@mouseUpHandle =0
		@model.set("Position",@position)

		super

	del: ()->
		super
		
		@Connection.Disconnect();

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





class window.UML.Arrows.BendPoint
	constructor:(@position, @context)->
		@displayed = false;

	GetPosition:()-> @position

	CreateGraphicsObject:()->
		@endPoint = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
		@endPoint.setAttribute("r","5")
		@endPoint.setAttribute("cx",@position.x)
		@endPoint.setAttribute("cy",@position.y)
		@endPoint.setAttribute("class","ArrowBend")

		@Draggable = new window.UML.Interaction.Draggable(@On_Drag_Start.bind(@),
														@On_Drag.bind(@),
														@On_Drag_End.bind(@),
														@endPoint,
														@GetPosition.bind(@));

		@displayed = true;
		window.UML.globals.document.appendChild(@endPoint);

	del:()->
		@Hide()
		@Draggable.detatch_for_GC(@endPoint)
		@endpoint = null;
		@position = null;

	Move:(to)->
		@position = to;
		@endPoint.setAttribute("cx",@position.x)
		@endPoint.setAttribute("cy",@position.y)
		@segment1.Move(to);
		@segment2.Move(to);
		@context.redraw();

	ResetEndpoint1:(@segment1)->
		@position = @segment1.GetPosition();

	ResetEndpoint2:(@segment2)->
		@position = @segment2.GetPosition();

	On_Drag_Start:()->

	On_Drag:(to)->
		@Move(to)
	On_Drag_End:()->

	Show: () ->
		@displayed = true
		globals.document.appendChild(@endPoint)
	Hide: () ->
		@displayed = false
		globals.document.removeChild(@endPoint)




class window.UML.Arrows.EndpointConnector1
	constructor:(@ref)->

	Move:(to)-> @ref.MoveEnd1(to);
	GetPosition:()-> @ref.position1;


class window.UML.Arrows.EndpointConnector2
	constructor:(@ref)->

	Move:(to)-> @ref.MoveEnd2(to);
	GetPosition:()-> @ref.position2;


class window.UML.Arrows.LineSegment
	constructor:(@position1, @position2)->

		@OnClickHandel = ((evt) ->@On_Click(evt)).bind(@)
		@OnHoverHandel = ((evt) ->@On_Hover(evt)).bind(@)
		@OnLeaveHandel = ((evt) ->@On_Leave(evt)).bind(@)

		@Clicked = new Event();
		@MouseHover = new Event();
		@MouseLeave = new Event();

		@endpoint1 = new window.UML.Arrows.EndpointConnector1(@)
		@endpoint2 = new window.UML.Arrows.EndpointConnector2(@)


	Connect:(@Connection1, @Connection2)->
		@Connection1.ResetEndpoint1(@Endpoint1())
		@Connection2.ResetEndpoint2(@Endpoint2())

	Endpoint1:()-> @endpoint1;
	Endpoint2:()-> @endpoint2;

	MoveEnd1:(to)->
		@position1 = to;
		@line.setAttribute("x1",@position1.x)
		@line.setAttribute("y1",@position1.y)
		@hitbox.setAttribute("x1",@position1.x)
		@hitbox.setAttribute("y1",@position1.y)

	MoveEnd2:(to)->
		@position2 = to;
		@line.setAttribute("x2",@position2.x)
		@line.setAttribute("y2",@position2.y)
		@hitbox.setAttribute("x2",@position2.x)
		@hitbox.setAttribute("y2",@position2.y)

	Redraw:()->
		@line.setAttribute("x1",@position1.x)
		@line.setAttribute("y1",@position1.y)
		@hitbox.setAttribute("x1",@position1.x)
		@hitbox.setAttribute("y1",@position1.y)
		
		@line.setAttribute("x2",@position2.x)
		@line.setAttribute("y2",@position2.y)
		@hitbox.setAttribute("x2",@position2.x)
		@hitbox.setAttribute("y2",@position2.y)

	del:()->
		globals.document.removeChild(@line)
		globals.document.removeChild(@hitbox)


	CreateGraphicsObject:()->
		@line = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@line.setAttribute("x1",@position1.x)
		@line.setAttribute("y1",@position1.y)
		@line.setAttribute("x2",@position2.x)
		@line.setAttribute("y2",@position2.y)
		@line.setAttribute("class","ArrowLine")

		@hitbox = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@hitbox.setAttribute("style","fill-opacity:1.0;stroke-width:20");
		@hitbox.setAttribute("pointer-events", "all");
		@hitbox.addEventListener("mousedown", @OnClickHandel, false);
		@hitbox.addEventListener("mouseover", @OnHoverHandel, false);
		@hitbox.addEventListener("mouseleave", @OnLeaveHandel, false);

		@hitbox.setAttribute("x1",@position1.x)
		@hitbox.setAttribute("y1",@position1.y)
		@hitbox.setAttribute("x2",@position2.x)
		@hitbox.setAttribute("y2",@position2.y)

		window.UML.globals.document.appendChild(@line);
		window.UML.globals.document.appendChild(@hitbox);

	EnablePointerEvents:()->
		@line.setAttribute("pointer-events","all");
		@hitbox.setAttribute("pointer-events","all");

	DisablePointerEvents:()->
		@line.setAttribute("pointer-events","none");
		@hitbox.setAttribute("pointer-events","none");

	SetNormalArrow:()->
		@line.setAttribute("stroke-dasharray","0")

	SetDashedArrow:()->
		@line.setAttribute("stroke-dasharray","5, 5")

	ArrowHover:()->
		$(@line).addClass("ArrowOutlineHover")

	ArrowUnHover:()->
		$(@line).removeClass("ArrowOutlineHover")		

	On_Click:(evt)->
		@Clicked.pulse(evt)

	On_Hover:(evt)->
		evt.lineSegment = @;
		@MouseHover.pulse(evt)

	On_Leave:(evt)->
		@MouseLeave.pulse()



leftMouse = 0;
rightMouse = 2;

class MoveableObject

	constructor:(@position)->
		@NameChangeHndl = (((evt)->@OnNameChange(evt)).bind(@))
		
		@myID = @model.modelItemID

		if !@model.get("Name")
			@model.setNoLog("Name","Item"+@myID.toString())

		@name = new EdiableTextBox(new Point(10, 6), @model.get("Name"));
		@name.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@name.selectTextOnShow = true;
		@routeResolver = new RouteResolver()
		@Size = new Point(150,200)
		@Owner = globals.document
		@onDelete = new Event()
		@moveStart = null
		@model.set("Position",@position)

		@name.onTextChange.add(@NameChangeHndl)

	SetNewOwner:(@Owner)->

	GetOwnerFrameOfReffrence:()->
		@Owner.getCTM()

	GetPosition:()-> @position

	Move:(To)->
		@position = To;
		@Redraw()

	OnNameChange:(evt)->
		@model.set("Name",evt.newText)

	Del:()->
		@Owner.removeChild(@graphics.group);
		evt = new Object()
		evt.ID = @myID;
		@onDelete.pulse(evt)

	Resize:->
		@graphics.box.setAttribute("width",@Size.x);
		@graphics.box.setAttribute("height",@Size.y);
		@graphics.BoxHeader.setAttribute("width",@Size.x);
		
		namePosition = new Point((@Size.x/2)-@name.Size.x/2, @name.relPosition.y);
		if namePosition.x < 20
			namePosition.x = 20;
		@name.Move(namePosition) #maintain name in center of box
 
	Redraw:->
		@graphics.group.setAttribute('transform', "translate("+@position.x+","+@position.y+")");
		return
		
	OnTextElemetChangeSizeHandler:(evt)->
		@Resize()
	
	CreateGraphicsObject:(baseClass)->
		graphics = new Object();
		graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		graphics.box = document.createElementNS("http://www.w3.org/2000/svg", 'rect');
		graphics.BoxHeader = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@Dragger = new window.UML.Interaction.Draggable(@ActivateMove.bind(@),
														@On_mouse_move.bind(@),
														@On_mouse_up.bind(@),
														graphics.box,
														@GetPosition.bind(@));

		graphics.group.setAttribute("class","classObj");

		classes = "classBox"
		if(typeof(baseClass) != 'undefined' && baseClass != null)
			classes = classes+" "+baseClass

		graphics.box.setAttribute("class",classes);	
		graphics.box.setAttribute("x","0");
		graphics.box.setAttribute("y","0");
		graphics.box.setAttribute("rx","3");
		graphics.box.setAttribute("ry","3");
		graphics.box.setAttribute("width",@Size.x);
		graphics.box.setAttribute("height","200");
		graphics.box.setAttribute("onmouseover",@routeResolver.resolveRoute("GlobalObject")+"("+@myID+").OnMouseOverHeader(evt);");
		graphics.box.setAttribute("onmouseout",@routeResolver.resolveRoute("GlobalObject")+"("+@myID+").OnMouseExitHeader(evt);");


		graphics.BoxHeader.setAttribute("class","ClassHeaderBar")
		graphics.BoxHeader.setAttribute("x","0");
		graphics.BoxHeader.setAttribute("y","0");
		graphics.BoxHeader.setAttribute("width",@Size.x);
		graphics.BoxHeader.setAttribute("height","30");
		graphics.BoxHeader.setAttribute("onmouseover",@routeResolver.resolveRoute("GlobalObject")+"("+@myID+").OnMouseOverHeader(evt);");
		graphics.BoxHeader.setAttribute("onmouseout",@routeResolver.resolveRoute("GlobalObject")+"("+@myID+").OnMouseExitHeader(evt);");


		graphics.group.appendChild(graphics.box)
		graphics.group.appendChild(graphics.BoxHeader)

		graphics.group.appendChild(@name.CreateGraphics("ClassName ClassTextAttribute"));
		@name.Move(new Point((@Size.x/2)-@name.Size.x, @name.relPosition.y));
		graphics.group.setAttribute('transform', "translate("+@position.x+","+@position.y+")");
		
		@graphics = graphics;

		return

	OnMouseOverHeader:(evt) ->
		window.UML.globals.highlights.HighlightClass(@)

	OnMouseExitHeader:(evt) ->
		window.UML.globals.highlights.UnHighlightClass(@)

	Highlight:()->
		$(@graphics.BoxHeader).addClass('ClassHeaderBarHover')
		$(@graphics.cornerHack).addClass("ClassHeaderBarHover")
		$(@graphics.box).addClass("ClassOutlineHover")
	Unhighlight:()->
		$(@graphics.BoxHeader).removeClass("ClassHeaderBarHover")
		$(@graphics.cornerHack).removeClass("ClassHeaderBarHover");
		$(@graphics.box).removeClass("ClassOutlineHover")

	Select:() ->

	deactivate:() ->

	ActivateMove:(evt) ->
		@graphics.group.setAttribute("pointer-events","none")
		evt = new Object();
		evt.moveableObject = @
		@moveStart = @position
		@prevOwner = @Owner
		window.UML.Pulse.MoveableObjectActivated.pulse(evt)
		@Select();

	On_mouse_move:(to) ->
		@Move(to);

	On_mouse_up:(evt) ->
		@graphics.group.setAttribute("pointer-events","all")
		window.UML.Pulse.MoveableObjectDeActivated.pulse()
		@model.set("Position",@position)


	OnModelChange:(evt)->
		if evt.name == "Position"
			@Move(evt.new_value)



class InheritableObject extends MoveableObject

	constructor:(@position)->
		super(@position);

		@BottomDropZone = new DropZone(0)
		@TopDropZone = new DropZone(1)
		@LeftDropZone = new DropZone(2)
		@RightDropZone = new DropZone(3)
		@DropZones = [@BottomDropZone, @TopDropZone, @LeftDropZone, @RightDropZone]
		
		@Arrows = new ClassArrows()


	Move:(To)->
		super(To);
		GlobalCoords = window.UML.Utils.getSVGCoordForGroupedElement(@graphics.box)
		@Arrows.Move(GlobalCoords, @Size.y, @Size.x)

	Del:()->
		super()
		ref = @
		for arrowList in [@Arrows.BOTTOM .. @Arrows.RIGHT]
			do (arrowList, ref)->
				for arrow in ref.Arrows.From[arrowList]
					do (arrow)->
						arrow.del();

		for arrow in globals.arrows.List
			do(arrow, ref)->
				if(arrow.arrowHead.lockedClass == ref.myID)
					arrow.arrowHead.lockedClass = -1;
					arrow.arrowHead.locked = false;

	Resize:->
		super()
		@LeftDropZone.Move(new Point(0, @Size.y/2));
		@RightDropZone.Move( new Point(@Size.x,@Size.y/2));
		@BottomDropZone.Move( new Point(@Size.x/2, @Size.y));
		@TopDropZone.Move(new Point(@Size.x/2, 0));
		GlobalCoords = window.UML.Utils.getSVGCoordForGroupedElement(@graphics.box)
		@Arrows.Move(GlobalCoords, @Size.y,@Size.x)



	CreateGraphicsObject:()->
		super()

		@LeftDropZone.position = new Point(0, @Size.y/2);
		@RightDropZone.position = new Point(@Size.x,@Size.y/2);
		@BottomDropZone.position = new Point(@Size.x/2, @Size.y);
		@TopDropZone.position = new Point(@Size.x/2, 0);

		leftdropZoneGraphics = @LeftDropZone.CreateGraphics(@myID)
		rightdropZoneGraphics = @RightDropZone.CreateGraphics(@myID)
		topdropZoneGraphics = @TopDropZone.CreateGraphics(@myID)
		bottomdropZoneGraphics = @BottomDropZone.CreateGraphics(@myID)

		@graphics.group.appendChild(bottomdropZoneGraphics.arrowDrop);
		@graphics.group.insertBefore(topdropZoneGraphics.arrowDrop,@graphics.box);
		@graphics.group.appendChild(leftdropZoneGraphics.arrowDrop);
		@graphics.group.appendChild(rightdropZoneGraphics.arrowDrop);

		@graphics.group.insertBefore(topdropZoneGraphics.hiddenDropRange,@graphics.box);
		@graphics.group.appendChild(bottomdropZoneGraphics.hiddenDropRange);
		@graphics.group.appendChild(leftdropZoneGraphics.hiddenDropRange);
		@graphics.group.appendChild(rightdropZoneGraphics.hiddenDropRange);	

	Highlight:()->
		super()
		@LeftDropZone.Show();
		@RightDropZone.Show();
		@BottomDropZone.Show();
		@TopDropZone.Show()

	Unhighlight:()->
		super()
		@LeftDropZone.Hide();
		@RightDropZone.Hide();
		@BottomDropZone.Hide();
		@TopDropZone.Hide()


class Class extends InheritableObject

	constructor:(@position, @model, popoutView)->
		super(@position);

		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))
		
		@Properties = new EditableTextBoxTable(new Point(15,35),@model.get("Properties"));
		@Properties.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@Properties.rowFactory = new PropertyRowFactory()
		@Properties.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Properties.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Properties");

		@Methods = new EditableTextBoxTable(new Point(15,105),@model.get("Methods"))
		@Methods.rowFactory = new MethodRowFactory(@model.get("Methods"))
		@Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Methods");
		@Methods.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@Methods.minHeight = 85
		@Methods.height = 85
		@routeResolver.createRoute("GlobalObject","window.UML.globals.classes.get");
		@Attributes = [@Properties, @Methods]
		@ClassPropertyDropDown = new ClassPropertyPopout(new Point(10,10),popoutView,@model)

		window.UML.Pulse.TypeNameChanged.pulse({prevText:"";newText:@model.get("Name")})

	SetID:(@myID)->
		@Properties.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Properties.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Properties");
		@Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Methods");
		
	Del:()->
		super();
		window.UML.Pulse.TypeDeleted.pulse({typeText:@name.text})
		@name.onTextChange.remove(@NameChangeHndl)

	Resize:->
		super();
		
		@graphics.propertySeperator.setAttribute("x2", @Size.x);
		@graphics.methodSeperator.setAttribute("x2", @Size.x);

		methodHeight = @Properties.height+40;

		@graphics.methodSeperator.setAttribute("y1", methodHeight);
		@graphics.methodSeperator.setAttribute("y2", methodHeight);

		@graphics.methodSeperator2.setAttribute("y1", methodHeight);
		@graphics.methodSeperator2.setAttribute("y2", methodHeight);

		@graphics.methodHeader.setAttribute("y", methodHeight+6);
		@methodsExpand.MoveDown(methodHeight)
		@addMethodBttn.MoveDown(methodHeight-3)

		@Methods.Move(new Point(@Methods.position.x,methodHeight))

	OnNameChange:(evt)->
		super(evt)
		window.UML.Pulse.TypeNameChanged.pulse(evt)
 
	OnTextElemetChangeSizeHandler:(evt)->
		@Methods.Resize()
		@Properties.Resize()
		@Size.x= (Math.max(@Properties.width+@Properties.position.x, @Methods.width+ @Methods.position.x, @name.Size.x+20))+7
		@Size.y = @Properties.height + @Methods.height + 30 + 20 # + header size + nooks and craneys (I KNOW DNT HARD CODE THIS SHIT BUT IM A LAZY ASS WHAT U GONNA DO!)
		super();

	Highlight:()->
		super()
		@addPropertyBttn.Show()
		@addMethodBttn.Show();

	Unhighlight:()->
		super()
		@addPropertyBttn.Hide()
		@addMethodBttn.Hide();

	CreateGraphicsObject:()->
		super();

		@graphics.propertyHeader = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@graphics.methodHeader = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@graphics.propertySeperator = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@graphics.propertySeperator2 = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@graphics.methodSeperator = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@graphics.methodSeperator2 = document.createElementNS("http://www.w3.org/2000/svg", 'line');

		headerEndY = parseInt(@graphics.BoxHeader.getAttribute("x")) + parseInt(@graphics.BoxHeader.getAttribute("height"));
		propertyHeight = 70;

		@propertysExpand = new ExpandButton(@Properties, 3,headerEndY, @model.get("Properties"));
		@methodsExpand = new ExpandButton(@Methods, 3,propertyHeight + headerEndY, @model.get("Methods"));

		@addPropertyBttn = new SVGButton("Add", new Point(90, headerEndY - 2))
		@addMethodBttn = new SVGButton("Add", new Point(80, propertyHeight + headerEndY - 2))
		
		@addPropertyBttn.AddOnClick((()->
			rowModel = new window.UML.MODEL.ModelItem()
			rowModel.setNoLog("Name","name");
			rowModel.setNoLog("Vis","+");
			rowModel.setNoLog("Type","type");
			rowModel.setNoLog("Static",false);
			@model.get("Properties").get("Items").push(rowModel)).bind(@))

		@addMethodBttn.AddOnClick((()->
			rowModel = new window.UML.MODEL.ModelItem()
			rowModel.setNoLog("Name","Method")
			rowModel.setNoLog("Return","Int")
			rowModel.setNoLog("Vis","+")
			rowModel.setNoLog("Args","arg1 : Int, arg2 : Float")
			rowModel.setNoLog("Comment","")
			rowModel.setNoLog("Static",false)
			rowModel.setNoLog("Absract",false)
			@model.get("Methods").get("Items").push(rowModel)).bind(@));



		@graphics.propertyHeader.setAttribute("x",25);
		@graphics.propertyHeader.setAttribute("y",headerEndY+6);
		@graphics.propertyHeader.setAttribute("height", 12)
		@graphics.propertyHeader.setAttribute("width", 40)
		@graphics.propertyHeader.setAttribute("class","ClassSectionHeader");
		@graphics.propertyHeader.textContent = "Properties";

		@graphics.methodHeader.setAttribute("x",25);
		@graphics.methodHeader.setAttribute("y",propertyHeight + headerEndY);
		@graphics.methodHeader.setAttribute("height", 12)
		@graphics.methodHeader.setAttribute("width", 40)
		@graphics.methodHeader.setAttribute("class","ClassSectionHeader");
		@graphics.methodHeader.textContent = "Methods";

		@graphics.propertySeperator.setAttribute("class", "ClassBarSeperator");
		@graphics.propertySeperator.setAttribute("x1", "90");
		@graphics.propertySeperator.setAttribute("y1", headerEndY);
		@graphics.propertySeperator.setAttribute("x2", @Size.x);
		@graphics.propertySeperator.setAttribute("y2", headerEndY);
		@graphics.propertySeperator.setAttribute("height", propertyHeight);
		@graphics.propertySeperator.setAttribute("stroke", "black");

		@graphics.propertySeperator2.setAttribute("class", "ClassBarSeperator");
		@graphics.propertySeperator2.setAttribute("x1", "0");
		@graphics.propertySeperator2.setAttribute("y1", headerEndY);
		@graphics.propertySeperator2.setAttribute("x2", 6);
		@graphics.propertySeperator2.setAttribute("y2", headerEndY);
		@graphics.propertySeperator2.setAttribute("height", propertyHeight);
		@graphics.propertySeperator2.setAttribute("stroke", "black");

		@graphics.methodSeperator.setAttribute("class", "ClassBarSeperator");
		@graphics.methodSeperator.setAttribute("x1", "80");
		@graphics.methodSeperator.setAttribute("y1", propertyHeight + headerEndY);
		@graphics.methodSeperator.setAttribute("x2", @Size.x);
		@graphics.methodSeperator.setAttribute("y2", propertyHeight + headerEndY);

		@graphics.methodSeperator2.setAttribute("class", "ClassBarSeperator");
		@graphics.methodSeperator2.setAttribute("x1", "0");
		@graphics.methodSeperator2.setAttribute("y1", propertyHeight + headerEndY);
		@graphics.methodSeperator2.setAttribute("x2", 6);
		@graphics.methodSeperator2.setAttribute("y2", propertyHeight + headerEndY);

		@graphics.group.appendChild(@Methods.CreateGraphics());
		@graphics.group.appendChild(@methodsExpand.CreateGraphics());
		@graphics.group.appendChild(@Properties.CreateGraphics())
		@graphics.group.appendChild(@propertysExpand.CreateGraphics());
		@graphics.group.appendChild(@graphics.propertySeperator);
		@graphics.group.appendChild(@graphics.propertySeperator2);
		@graphics.group.appendChild(@graphics.methodSeperator);
		@graphics.group.appendChild(@graphics.propertyHeader);
		@graphics.group.appendChild(@graphics.methodHeader);
		@graphics.group.appendChild(@graphics.methodSeperator2);
		@graphics.group.appendChild(@addPropertyBttn.CreateGraphics());
		@graphics.group.appendChild(@addMethodBttn.CreateGraphics());
		

		@graphics.group.appendChild(@ClassPropertyDropDown.CreateGraphicsObject())

		globals.LayerManager.InsertClassLayer(@graphics.group);


		# resize elements after being added to the dom
		@name.resize();
		@Properties.Resize();
		@Methods.Resize();
		@Resize()

		@Methods.InitView()
		@Properties.InitView()
		return

	OnModelChange:(evt)->
		if evt.name == "Name"
			@name.UpdateText(evt.new_value);
		else
			super(evt)	
		


class Interface extends InheritableObject
	constructor:(@position, @model, popoutView)->
		super(@position);

		@NameChangeHndl = (((evt)-> @OnNameChange(evt)).bind(@))
		@model.onChange.add(((evt)->@OnModelChange(evt)).bind(@))

		@IsInterface = true;
		@Methods = new EditableTextBoxTable(new Point(15,105),@model.get("Methods"))
		@Methods.rowFactory = new MethodRowFactory()
		@Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Methods");
		@Methods.onSizeChange.add(@OnTextElemetChangeSizeHandler.bind(@))
		@Methods.minHeight = 85
		@Methods.height = 85
		@routeResolver.createRoute("GlobalObject","window.UML.globals.classes.get");
		@ClassPropertyDropDown = new ClassPropertyPopout(new Point(15,15),popoutView, @model)

		window.UML.Pulse.TypeNameChanged.pulse({prevText:"";newText:@model.get("Name")})
		@name.onTextChange.add(@NameChangeHndl)

		@minwidth = 150;
	SetID:(@myID)->
		@Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get("+@myID+")");
		@Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get("+@myID+").Methods");

	Del:()->
		super();
		window.UML.Pulse.TypeDeleted.pulse({typeText:@name.text})

	OnNameChange:(evt)->
		@model.set("Name",evt.newText)
		window.UML.Pulse.TypeNameChanged.pulse(evt)

	Resize:->
		super();
		@graphics.methodSeperator.setAttribute("x2", @Size.x);
		@graphics.interfaceText.setAttribute("x",(@Size.x/2)-@graphics.interfaceText.getBBox().width/2);
		@Methods.Resize()

	OnTextElemetChangeSizeHandler:(evt)->
		@Methods.Resize()
		@Size.x = (Math.max( @Methods.width+ @Methods.position.x, @name.Size.x+20,@minwidth))+7
		@Size.y =  @Methods.height + 30 + 20 # + header size + nooks and craneys (I KNOW DNT HARD CODE THIS SHIT BUT IM A LAZY ASS WHAT U GONNA DO!)
		super();

	Highlight:()->
		super()
		@addMethodBttn.Show();

	Unhighlight:()->
		super()
		@addMethodBttn.Hide();

	CreateGraphicsObject:()->
		super();

		@graphics.group.setAttribute("class",@graphics.group.getAttribute("class") + " interfaceObj");

		@graphics.interfaceText = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@graphics.methodSeperator = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@graphics.methodHeader = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@graphics.methodSeperator2 = document.createElementNS("http://www.w3.org/2000/svg", 'line');

		@graphics.interfaceText.setAttribute("class","greyText ClassTextAttribute");
		@graphics.interfaceText.textContent = "<<Interface>>";

		
		@graphics.interfaceText.setAttribute("y","17");
		@graphics.BoxHeader.appendChild(@graphics.interfaceText);
		@name.Move(new Point(5, 18));

		globals.LayerManager.InsertClassLayer(@graphics.group); # append the element early so that we can use the size to position other elements

		headerHeight = @name.Size.y + @name.relPosition.y
		headerEndY = parseInt(@graphics.BoxHeader.getAttribute("y")) + parseInt(headerHeight)+ 10;

		@methodsExpand = new ExpandButton(@Methods, 3,headerEndY, @model.get("Methods"));
		@addMethodBttn = new SVGButton("Add", new Point(80, headerEndY - 2))

		@addMethodBttn.AddOnClick((()->
			rowModel = new window.UML.MODEL.ModelItem()
			rowModel.setNoLog("Name","Method")
			rowModel.setNoLog("Return","Int")
			rowModel.setNoLog("Vis","+")
			rowModel.setNoLog("Args","arg1 : Int, arg2 : Float")
			rowModel.setNoLog("Comment","")
			rowModel.setNoLog("Static",false)
			rowModel.setNoLog("Absract",false)
			@model.get("Methods").get("Items").push(rowModel)).bind(@));

		@graphics.methodSeperator.setAttribute("class", "ClassBarSeperator");
		@graphics.methodSeperator.setAttribute("x1", "80");
		@graphics.methodSeperator.setAttribute("y1", headerEndY);
		@graphics.methodSeperator.setAttribute("x2", @Size.x);
		@graphics.methodSeperator.setAttribute("y2", headerEndY);

		@graphics.methodSeperator2.setAttribute("class", "ClassBarSeperator");
		@graphics.methodSeperator2.setAttribute("x1", "0");
		@graphics.methodSeperator2.setAttribute("y1", headerEndY);
		@graphics.methodSeperator2.setAttribute("x2", 6);
		@graphics.methodSeperator2.setAttribute("y2", headerEndY);

		@graphics.methodHeader.setAttribute("x",25);
		@graphics.methodHeader.setAttribute("y", headerEndY+6);
		@graphics.methodHeader.setAttribute("height", 12)
		@graphics.methodHeader.setAttribute("width", 40)
		@graphics.methodHeader.setAttribute("class","ClassSectionHeader");
		@graphics.methodHeader.textContent = "Methods";

		@graphics.group.appendChild(@Methods.CreateGraphics({0:"+",1:"retType", 2:"name", 3:"int arg1, float arg2"}));
		@graphics.group.appendChild(@graphics.methodSeperator);
		@graphics.group.appendChild(@graphics.methodSeperator2);

		@Methods.Move(new Point(15,headerEndY))

		@graphics.group.appendChild(@ClassPropertyDropDown.CreateGraphicsObject())
		@graphics.group.appendChild(@methodsExpand.CreateGraphics())

		@graphics.group.appendChild(@graphics.methodHeader)
		@graphics.group.appendChild(@addMethodBttn.CreateGraphics());
		

		# resize elements after being added to the dom
		@name.resize();
		@Methods.Resize()
		@Resize()

		@Methods.InitView();
		return

	OnMouseOverHeader:(evt) ->
		window.UML.globals.highlights.HighlightInterface(@)
	OnMouseExitHeader:(evt) ->
		window.UML.globals.highlights.UnHighlightInterface(@)

	OnModelChange:(evt)->
		if evt.name == "Name"
			@name.UpdateText(evt.new_value);
		else
			super(evt)

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

class ResizeDragger
	constructor:(Position)->
		@onSizeChange = new Event();
		@onDragEnd = new Event();

		@Position = Position
		@rotation = 0;

		@mousemoveHandle = null
		@mousemoveUp = null
		@mousedownHandle = ((evt) ->@On_mouse_down(evt)).bind(@) 

	Rotate:(angle)->
		@rotation = angle;
		@graphics.group.setAttribute("transform","translate("+@Position.x+","+@Position.y+") rotate("+@rotation+")")

	Move:(To)->
		@Position = To
		@graphics.group.setAttribute("transform","translate("+@Position.x+","+@Position.y+") rotate("+@rotation+")")

	CreateGraphicsObject:()->
		@graphics = new Object();
		
		@graphics.group  = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.leftLine = document.createElementNS("http://www.w3.org/2000/svg", 'line');
		@graphics.rightLine = document.createElementNS("http://www.w3.org/2000/svg", 'line');

		@graphics.leftLine.setAttribute("x1","0");
		@graphics.leftLine.setAttribute("y1","0");
		@graphics.leftLine.setAttribute("x2","10");
		@graphics.leftLine.setAttribute("y2","0");
		
		@graphics.rightLine.setAttribute("x1","0");
		@graphics.rightLine.setAttribute("y1","0");
		@graphics.rightLine.setAttribute("x2","0");
		@graphics.rightLine.setAttribute("y2","10");

		@graphics.leftLine.setAttribute("class","Resizer")
		@graphics.rightLine.setAttribute("class","Resizer")
		@graphics.group.setAttribute("transform","translate("+@Position.x+","+@Position.y+") rotate("+@rotation+")")

		@graphics.group.addEventListener("mousedown",@mousedownHandle)
		@graphics.group.appendChild(@graphics.leftLine)
		@graphics.group.appendChild(@graphics.rightLine)

		return @graphics;


	show:(@docRoot)->
		docRoot.appendChild(@graphics.group)
	hide:(@docRoot)->
		docRoot.removeChild(@graphics.group)


	On_mouse_down:(evt) ->
		if(@mousemoveHandle == null && @mousemoveUp == null)
			@mousemoveHandle = ((evt) ->@On_mouse_move(evt)).bind(@) 
			@mousemoveUp  = ((evt) ->@On_mouse_up(evt)).bind(@)
			globals.document.addEventListener("mousemove",@mousemoveHandle,false);
			globals.document.addEventListener("mouseup", @mousemoveUp,false);

	On_mouse_move:(evt) ->
		loc=  window.UML.Utils.mousePositionFromEvent(evt)
		@Position= window.UML.Utils.fromSVGCoordForGroupedElement(loc,@docRoot)
		@onSizeChange.pulse(evt)

	On_mouse_up:(evt) ->
		globals.document.removeEventListener("mousemove",@mousemoveHandle, false);
		globals.document.removeEventListener("mouseup",@mousemoveUp, false);

		@mousemoveHandle = null
		@mousemoveUp = null

		@onDragEnd.pulse()

class ResizeDraggers
	constructor:(@context)->
		@onSizeChange = new Event();
		@onDragEnd = new Event();

		@Size = @context.Size;
		@BottomRightDragger = new ResizeDragger(new Point(@Size.x+5, @Size.y+5));
		@onBRResizeHandel = ((evt) ->@On_BR_dragger_resize(evt)).bind(@) 
		@BottomRightDragger.onSizeChange.add(@onBRResizeHandel)
		@BottomRightDragger.onDragEnd.add((()-> @OnDraggerDragEnd()).bind(@))

		@draggersShown = false;
		@MinSize = new Point(0,0)

	OnDraggerDragEnd:()->
		@onDragEnd.pulse();


	Resize:(@Size)->
		bottomRightResizerPos = new Point(0,0);
		if(@Size.x > @MinSize.x)
			bottomRightResizerPos.x = @Size.x
		else 
			bottomRightResizerPos.x = @MinSize.x

		if(@Size.y > @MinSize.y)
			bottomRightResizerPos.y = @Size.y
		else 
			bottomRightResizerPos.y = @MinSize.y

		@BottomRightDragger.Move(bottomRightResizerPos);

	UpdateMinimumSize:(@MinSize)->
		bottomRightResizerPos = new Point(0,0);
		if(@Size.x > @MinSize.x)
			bottomRightResizerPos.x = @Size.x
		else 
			bottomRightResizerPos.x = @MinSize.x

		if(@Size.y > @MinSize.y)
			bottomRightResizerPos.y = @Size.y
		else 
			bottomRightResizerPos.y = @MinSize.y

		@BottomRightDragger.Move(bottomRightResizerPos);
		@On_BR_dragger_resize();


	CreateGraphicsObject:()->

		BottomRightGraphics = @BottomRightDragger.CreateGraphicsObject();

		@BottomRightDragger.Rotate(180)

	showDraggers:()->
		@draggersShown = true;
		@BottomRightDragger.show(@context.graphics.group)


	hideDraggers:()->
		@draggersShown = false;
		@BottomRightDragger.hide(@context.graphics.group)

	On_BR_dragger_resize:(evt)->
		@Size.x = @MinSize.x
		@Size.y = @MinSize.y
		
		if(@BottomRightDragger.Position.x > @MinSize.x)
			@Size.x = @BottomRightDragger.Position.x 
		if(@BottomRightDragger.Position.y > @MinSize.y)
			@Size.y = @BottomRightDragger.Position.y 
			
		evt = new Object()
		evt.newSize = @Size;
		@onSizeChange.pulse(evt)



class ContextMenu
	constructor:()->
		@initHandle =  ((evt) ->@onInitialise(evt)).bind(@) 
		@backgroundClick = ((evt) ->@onBackgroundClick(evt)).bind(@) 
		@showContextMenuAddEvtHndl = ((evt) ->@showContextMenuAddEvt(evt)).bind(@) 
		@showContextMenuAttatchEvtHndl = ((evt) ->@showContextMenuAttatchEvt(evt)).bind(@) 
		@hideContextMenuHndl = ((evt) ->@hideContextMenu(evt)).bind(@) 

		window.UML.Pulse.Initialise.add(@initHandle)
		window.UML.Pulse.BackgroundClick.add(@backgroundClick)
		@contextMenuOnShow = false;
	
	onBackgroundClick:(e)->
		if(@contextMenuOnShow)
			@ContextMenuEl.css({display: "none"});

		@contextMenuOnShow = false

	bindContextMenu:()->
		if (document.addEventListener)
	        document.addEventListener('contextmenu', @showContextMenuAddEvtHndl, false);
	    else
	        document.attachEvent('oncontextmenu',@showContextMenuAttatchEvtHndl);

	    @ContextMenuEl.on("click", "a", @hideContextMenuHndl);

	onInitialise:()->
		@bindContextMenu()

	hideContextMenu:(e) ->
		@ContextMenuEl.hide()

	showContextMenuAddEvt:(e) -> #override this
		return; 

	showContextMenuAttatchEvt:() ->
		alert("You've tried to open context menu");
		window.event.returnValue = false;

	


class ArrowMenu extends ContextMenu
	constructor:()->
		super();

	showContextMenuAddEvt:(e) ->
		@contextMenuOnShow = true;
		if(window.UML.globals.highlights.highlightedArrow != null)
			@Arrow = window.UML.globals.selections.activeArrow
			@ContextMenuEl.css({display: "block",left: e.pageX,top: e.pageY});
			@position = window.UML.Utils.mousePositionFromEvent(e);
			e.preventDefault();

	onInitialise:()->
		@ContextMenuEl = $("#ArrowContextMenu")
		super()

	Bend:() ->
		@Arrow.Bend(@position);

class ClassMenu extends ContextMenu
	constructor:()->
		super();

	showContextMenuAddEvt:(e) ->
		@contextMenuOnShow = true;
		if(window.UML.globals.highlights.highlightedClass != null)
			@class = window.UML.globals.highlights.highlightedClass
			@ContextMenuEl.css({display: "block",left: e.pageX,top: e.pageY});
			e.preventDefault();

	onInitialise:()->
		@ContextMenuEl = $("#contextMenu")
		super()
	AddProperty:() ->
		rowModel = new window.UML.MODEL.ModelItem()
		rowModel.setNoLog("Name","name");
		rowModel.setNoLog("Vis","+");
		rowModel.setNoLog("Type","type");
		rowModel.setNoLog("Static",false);

		@class.Properties.model.get("Items").push(rowModel)
	AddMethod:() ->
		rowModel = new window.UML.MODEL.ModelItem()
		rowModel.setNoLog("Name","Method")
		rowModel.setNoLog("Return","Int")
		rowModel.setNoLog("Vis","+")
		rowModel.setNoLog("Args","arg1 : Int, arg2 : Float")
		rowModel.setNoLog("Comment","")
		rowModel.setNoLog("Static",false)
		rowModel.setNoLog("Absract",false)
		@class.Methods.model.get("Items").push(rowModel)
	Delete:() ->
		@class.model.del();

	

class InterfaceMenu extends ContextMenu
	constructor:()->
		super();

	showContextMenuAddEvt:(e) ->
		@contextMenuOnShow = true;
		if(window.UML.globals.highlights.highlightedInterface != null)
			@Interface = window.UML.globals.highlights.highlightedInterface
			@ContextMenuEl.css({display: "block",left: e.pageX,top: e.pageY});
			e.preventDefault();

	onInitialise:()->
		@ContextMenuEl = $("#interfaceContextMenu")
		super()

	AddMethod:() ->
		rowModel = new window.UML.MODEL.ModelItem()
		rowModel.setNoLog("Name","Method")
		rowModel.setNoLog("Return","Int")
		rowModel.setNoLog("Vis","+")
		rowModel.setNoLog("Args","arg1 : Int, arg2 : Float")
		rowModel.setNoLog("Comment","")
		rowModel.setNoLog("Static",false)
		rowModel.setNoLog("Absract",false)
		@Interface.Methods.model.get("Items").push(rowModel)
	Delete:() ->
		@Interface.model.del();

class NamespaceMenu extends ContextMenu
	constructor:()->
		super();

	showContextMenuAddEvt:(e) ->
		@contextMenuOnShow = true;
		if(window.UML.globals.highlights.highlightedNamespace != null)
			@Namespace = window.UML.globals.highlights.highlightedNamespace
			@ContextMenuEl.css({display: "block",left: e.pageX,top: e.pageY});
			e.preventDefault();

	onInitialise:()->
		@ContextMenuEl = $("#namespaceContextMenu")
		super()

	Delete:() ->
		@Namespace.Del();

class SelectedGroup
	constructor: ()->
		@selectedItems = new Array()

	add: (item)->
		@selectedItems.push(item)
	clear: ()->
		@selectedItems.length = 0
	move: ()->
		#TODO
	del: ()->
		for item in @selectedItems
			do (item)->
				if item.hasOwnProperty("model")
					item.model.del();
				else
					item.del()

		@clear()

	deactivate: ()->
		for item in @selectedItems
			do (item)->
				item.deactivate()

		@clear()
	copy: ()->
		#TODO

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


class window.UML.StringTree.Node

	constructor:(@myChar)->
		@children = new IDIndexedList((item)-> item.myChar);
		@leafValue = null;

	NewString:(string, index)->
		if(index == string.length-1)
			@leafValue = string;
		else
			code = string.toUpperCase().charCodeAt(index)
			if(@children.get(code)==null)
				@children.add(new window.UML.StringTree.Node(code))

			@children.get(code).NewString(string,index+1);	

	Remove:(string, index)->
		if(index == string.length-1)
			@leafValue = null
		else
			code = string.toUpperCase().charCodeAt(index)
			child = @children.get(code)
			if(child !=null)
				childDeleted = child.Remove(string, index+1)
				if(childDeleted)
					@children.remove(child.myChar)

		if @children.List.length == 0
				return true
		
		return false

	ListChildren:(list)->
		if(@leafValue != null)
			list.push(@leafValue)

		for child in @children.List
			do(child)->
				child.ListChildren(list)





class window.UML.StringTree.StringTree 
	constructor:()->
		@rootNode = new window.UML.StringTree.Node()

	IsRoot:(node)-> node == @rootNode;

	Build:(string)->
		@rootNode.NewString(string,0)

	Remove:(string)->
		@rootNode.Remove(string,0)

	GetSelections:(string)->
		node = @FindRootNode(@rootNode, string)
		if(node == null)
			node = @rootNode

		return node

	FindRootNode:(node, string)->
		if string.length > 0
			child = node.children.get(string.toUpperCase().charCodeAt(0))
			if(child)
				@FindRootNode(child, string.substring(1))
			else
				return null;
		else
			return node;

window.UML.MODEL.ModelItems = new IDIndexedList((modelItem)-> modelItem.modelItemID)

class window.UML.MODEL.ModelItem
	constructor:(IDOverride)->
		IDOverride ?= -1;

		if(IDOverride != -1)
			@modelItemID = IDOverride;
			window.UML.MODEL.ModelGlobalUtils.ItemIDManager.AllocateOverrideID(IDOverride)
		else
			@modelItemID = window.UML.MODEL.ModelGlobalUtils.ItemIDManager.AllocateID()

		window.UML.MODEL.ModelItems.add(@);

		@model = new Object()
		@onChange = new Event()			#event that is fired when model is changed
		@onChangeInternal = new Event() #event thet is fired when model is changed by this client
		@onDelete = new Event()
		@modelValid = true

		window.UML.MODEL.ModelGlobalUtils.listener.ListenToNewMode(@)

	#####################################################################
	# This Method should be called when the ModelItem is 				#
	# in the process of being deleted, seeting the invalid flag will	#
	# prevent any further model changes from occuring					#
	#####################################################################
	flagAsInvalid:()->
		@modelValid = false

	#####################################################################
	# This Method should be called when the ModelItem is 				#
	# first created and ensures that the model changes will react       #
	# properly                                                          #
	#####################################################################
	flagAsValid:()->
		@modelValid = true		

	######################################################################
	# Calling this method will set the value of this model, but will not #
	# log the change to the undo buffer									 #
	#																	 #
	######################################################################
	setNoLog:(name, value, pulseAnyway)->
		pulseAnyway ?= false;
		if @modelValid and (pulseAnyway || @model[name] != value)
			@model[name] = value
			@onChange.pulse({modelID: @modelItemID, name: name, new_value: value, prev_value: @model[name]})
			@onChangeInternal.pulse({modelID: @modelItemID, name: name, new_value: value, prev_value: @model[name]})

	set:(name, value)->
		if @modelValid and @model[name] != value
			evt = {modelID: @modelItemID, name: name, prev_value: @model[name], value: value}
			globals.CtrlZBuffer.Push(evt)
			@setNoLog(name,value)

	##########################################################################
	# This function should be used to update the model with updated from the #
	# network layer, This prevents model updated from bouncing back out		 #
	# of the model and over the network again (via events)					 #
	##########################################################################
	setFromNetwork:(name, value, pulseAnyway)->
		pulseAnyway ?= false;
		if @modelValid and (pulseAnyway || @model[name] != value)
			@model[name] = value
			@onChange.pulse({modelID: @modelItemID, name: name, new_value: value, prev_value: @model[name]})

	setGroup:(keyValues)->
		if @modelValid
			ref = @
			names = []
			previousValues =[]
			newValues = []

			for keyValue in keyValues
				do(ref,keyValue)->
					names.push(keyValue.name)
					previousValues.push(ref.model[keyValue.name])
					newValues.push(keyValue.value)
					ref.setNoLog(keyValue.name, keyValue.value, true)

			evt = {modelID: @modelItemID, names:names, prev_values: previousValues, newValues: newValues}
			globals.CtrlZBuffer.Push(evt)

	get:(name)-> @model[name];

	del:()->
		for item, value of @model
			if value && (value.hasOwnProperty("modelItemID") || value.hasOwnProperty("modelListID"))
				value.del();

		window.UML.MODEL.ModelItems.remove(@modelItemID)
		@onDelete.pulse({item:@})

class window.UML.MODEL.Arrow extends window.UML.MODEL.ModelItem
	constructor:()->
		super()
		
		@setNoLog("Head",new window.UML.MODEL.ModelItem())
		@setNoLog("Tail", new window.UML.MODEL.ModelItem())
		


class window.UML.MODEL.Class extends window.UML.MODEL.ModelItem
	constructor:()->
		super()

		@setNoLog("Properties", new window.UML.MODEL.ModelItem())
		@setNoLog("Methods", new window.UML.MODEL.ModelItem())

		@get("Properties").setNoLog("Items", new window.UML.MODEL.ModelList())
		@get("Methods").setNoLog("Items", new window.UML.MODEL.ModelList())


class window.UML.MODEL.Interface extends window.UML.MODEL.ModelItem
	constructor:()->
		super()
		@setNoLog("Methods", new window.UML.MODEL.ModelItem())
		@get("Methods").setNoLog("Items", new window.UML.MODEL.ModelList)


class window.UML.MODEL.MODEL
	constructor:()->
		@classList = new window.UML.MODEL.ModelList()
		@interfaceList = new window.UML.MODEL.ModelList()
		@namespaceList = new window.UML.MODEL.ModelList()
		@arrowList = new window.UML.MODEL.ModelList()

	clearModel:()->
		@classList.clear()
		@interfaceList.clear()
		@namespaceList.clear()
		@arrowList.clear()


class window.UML.MODEL.ModelIDManager
	constructor:(@IDRequester)->
		@workingSet = new Array()
		@overridenIDs = new Array()
		@requestOutstanding = false;

	SetIdRequester:(@IDRequester)->

	ClearValidIds:()->
		@workingSet = [];
		@IDRequester.FlushIDs();

	ClearOverrideIDs:()->
		@overridenIDs = []

	AllocateID:()->
		if @workingSet.length <= 10 && !@requestOutstanding
			@RequestMoreIds()

		if @workingSet.length <= 1
			window.CodeCooker.HighLatency.setHighLatensy();

		return @workingSet.shift()

	AllocateOverrideID:(id)->
		if(id >= 0 && @overridenIDs.indexOf(id) != -1)
			# crash and burn TODO
			Debug.write("duplicate id overide requsted for id: "+id)

		@overridenIDs.push(id)
		if @workingSet.indexOf(id) != -1
			@workingSet.splice(@workingSet.indexOf(id),1)
			
		@IDRequester.allocateOverrideID(id);

	AddToWorkingSet:(start, end)->
		Debug.write("Receved more ids")
		window.CodeCooker.HighLatency.clearHighLatensy();
		@workingSet = @workingSet.concat([start..end]);
		@requestOutstanding = false

	RequestMoreIds:()->
		Debug.write("Requesting more Ids")
		@requestOutstanding = true;
		@IDRequester.Request();

window.UML.MODEL.ModelLists = new IDIndexedList((modelList)-> modelList.modelListID)

class window.UML.MODEL.ModelList
	constructor:(IDOverride)->

		IDOverride ?= -1;

		if(IDOverride != -1)
			@modelListID = IDOverride;
			window.UML.MODEL.ModelGlobalUtils.ListIDManager.AllocateOverrideID(IDOverride)
		else
			@modelListID = window.UML.MODEL.ModelGlobalUtils.ListIDManager.AllocateID()

		window.UML.MODEL.ModelLists.add(@)
		@list = new Array();
		@onChange = new Event()
		@onChangeInternal = new Event()
		@onDelete = new Event()
		@onDeleteHandler = (((evt)-> @onChildDelete(evt)).bind(@))

		window.UML.MODEL.ModelGlobalUtils.listener.ListenToNewMode(@)

	pushNoLog:(item)->
		@list.push(item)
		item.onDelete.add(@onDeleteHandler)
		
		evt = {modelListID: @modelListID, changeType: "ADD", item: item}
		@onChange.pulse(evt)
		@onChangeInternal.pulse(evt)
		return evt

	##########################################################################
	# This function should be used to update the model from the				 #
	# network layer, This prevents model updated from bouncing back out		 #
	# of the model and over the network again (via events)					 #
	##########################################################################
	pushFromNetwork:(item)->
		@list.push(item)
		item.onDelete.add(@onDeleteHandler)
		
		evt = {modelListID: @modelListID, changeType: "ADD", item: item}
		@onChange.pulse(evt)
		return evt

	push:(item)->
		evt = @pushNoLog(item)
		globals.CtrlZBuffer.Push(evt)

	removeAtNoLog:(index)->
		removed = @list.splice(index,1)
		
		if removed.length > 0
			removed[0].flagAsInvalid();
			evt = {modelListID: @modelListID, changeType: "DEL", item: removed[0]}
			@onChange.pulse(evt)
			@onChangeInternal.pulse(evt)

			removed[0].onDelete.remove(@onDeleteHandler)
			removed[0].onDelete.pulse(evt)
			return evt
		return false

	removeAt:(index)->
		evt = @removeAtNoLog(index)
		if evt
			globals.CtrlZBuffer.Push(evt)
		
	remove:(item)->
		itemIndex = @list.indexOf(item)
		if(itemIndex > -1)
			@removeAt(itemIndex)

	##########################################################################
	# This function should be used to update the model from the				 #
	# network layer, This prevents model updated from bouncing back out		 #
	# of the model and over the network again (via events)					 #
	##########################################################################
	removeFromNetwork:(item)->
		itemIndex = @list.indexOf(item)
		if(itemIndex > -1)
			removed = @list.splice(itemIndex,1)
			if removed.length > 0
				removed[0].flagAsInvalid();
				evt = {modelListID: @modelListID, changeType: "DEL", item: removed[0]}
				@onChange.pulse(evt)

				removed[0].onDelete.remove(@onDeleteHandler)
				removed[0].onDelete.pulse(evt)
				return evt
			return false



	removeNoLog:(item)->
		itemIndex = @list.indexOf(item)
		if(itemIndex > -1)
			@removeAtNoLog(itemIndex)

	onChildDelete:(evt)->
		@remove(evt.item)

	clear:()->
		while @list.length > 0
			@list[0].del()
		@list = []

	del:()->
		@clear()
		@onDelete.pulse({item:@})
		window.UML.MODEL.ModelLists.remove(@modelListID)


class window.UML.MODEL.ModelListener
	constructor:(modelLists, modelItems)->
		@onModelChange = new Event()

		for list in modelLists
			@ListenToNewMode(list)

		for item in modelItems
			@ListenToNewMode(item)

		@PulseModelChangeFunc = (evt) -> @onModelChange.pulse(evt);

	ListenToNewMode:(model)->
		model.onChangeInternal.add(@PulseModelChange.bind(@))

	StopListening:()->
		@PulseModelChangeFunc = (evt)->
	
	PulseModelChange:(evt)->
		@PulseModelChangeFunc(evt)




class window.UML.MODEL.Namespace extends window.UML.MODEL.ModelItem
	constructor:()->
		super()
		@Children = new window.UML.MODEL.ModelList()


#########################################################################
#																		#
# When using the networked collaberation it may be they 				#
# case that updates to model objects are being applied					#
# before they are part of the model. This class bufferes and applys they#
# updated to models untill they are added to the document model.		#
#																		#
#########################################################################
class window.UML.CollaberationSyncBuffer.SyncBuffer
	constructor:()->
		@modelBufferedItems = new IDIndexedList((item)-> item.modelItemID)

	addItem:(item)->
		if(item.hasOwnProperty("modelID"))
			@addItemUpdate(item)
		else if(item.hasOwnProperty("modelListID"))
			@addListUpdate(item)
		else
			Debug.write("invalid Model object supplied for network update: "+item)


	addItemUpdate:(item)->
			modelItem = window.UML.MODEL.ModelItems.get(item.modelID) 
			if(modelItem != null)
				@assignNewValue(item, modelItem);
			else
				@createNewItem(item);

	createNewItem:(item)->
		modelItem = new window.UML.MODEL.ModelItem(item.modelID)
		@assignNewValue(item, modelItem);

	assignNewValue:(update, modelItem)->
		if(update.new_value.hasOwnProperty("modelListID")) #check if we are adding a new list to the object
			modelList = new window.UML.MODEL.ModelList(update.new_value.modelListID)
			modelItem.setFromNetwork(update.name, modelList)
		else if(update.new_value.hasOwnProperty("modelItemID")) #check if we are adding a new item to the object
			newmodelItem = window.UML.MODEL.ModelItems.get(update.new_value.modelItemID)
			if newmodelItem == null
				newmodelItem = new window.UML.MODEL.ModelItem(update.new_value.modelItemID)
			modelItem.setFromNetwork(update.name, newmodelItem)
		else
			if window.UML.typeIsObject(update.new_value)

				if modelItem.get(update.name)
					# if the update is a full object the copy the feilds over individually
					# this is to prevent an update object stamping over a type
					for key, value of update.new_value
							modelItem.get(update.name)[key] = value;

					# assign value to itself to force an update
					modelItem.setFromNetwork(update.name,modelItem.get(update.name), true)
				else
					modelItem.setFromNetwork(update.name, @inferType(update.new_value));
			else
				modelItem.setFromNetwork(update.name,update.new_value)

	inferType:(value)->
		if value.hasOwnProperty("x") && value.hasOwnProperty("y")
			return new Point(value.x, value.y);

	addListUpdate:(list)->
			listItem = window.UML.MODEL.ModelLists.get(list.modelListID)
			if(listItem != null)
				if(list.changeType =="ADD")
					if(list.item.hasOwnProperty("modelItemID"))
						listModelItem = list.item
						modelItem = window.UML.MODEL.ModelItems.get(listModelItem.modelItemID)
						if modelItem == null
							@createNewItem(listModelItem)
							modelItem = window.UML.MODEL.ModelItems.get(listModelItem.modelItemID)

						listItem.pushFromNetwork(modelItem)
							
					else if(list.item.hasOwnProperty("modelListID"))
						Debug.write("Adding list to list Unimplemented ERROR: ")
					else
						Debug.write("invalid model item requested to append to list: "+list.item)
				else if(list.changeType == "DEL")

					if(list.item.hasOwnProperty("modelItemID"))
							listModelItem = list.item
							modelItem = window.UML.MODEL.ModelItems.get(listModelItem.modelItemID)
							if modelItem == null
								Debug.write("invalid model item requested to append to list: "+list.item)

							listItem.removeFromNetwork(modelItem)
								
					else if(list.item.hasOwnProperty("modelListID"))
							listModellist = list.item
							listModellist = window.UML.MODEL.ModelLists.get(list.modelListID)
							if listModellist == null
								Debug.write("invalid model list requested to append to list: "+list.item)

							listItem.removeFromNetwork(listModellist)

					

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

class ClassArrows
	constructor:() ->
		@To = new ClassArrowHead()
		@From = new ClassArrowTail()
		@position = new Point(0,0)
		return

	Move:(to, height, width)->
		half_width = width/2
		half_height = height/2
		
		@To.Move(to,height, width, half_height, half_width)
		@From.Move(to, height, width, half_height, half_width)

class ClassArrowsGroup
	constructor:()->
		@BOTTOM = 0
		@TOP = 1
		@LEFT = 2
		@RIGHT = 3
		@Content=  new Array(new Array(),new Array(),new Array(),new Array())

	Attatch:(index, arrow)->
		if(index >= 0 and index <= 3 and @Content[index].indexOf(arrow) == -1)
			@Content[index].push(arrow)

	Detatch:(index, arrow)->
		arrowIndex = @Content[index].indexOf(arrow)
		if(arrowIndex >= 0)
			@Content[index].splice(arrowIndex, 1);
			@content

class ClassArrowHead extends ClassArrowsGroup
	constructor:()->
		super()

	Move:(position, height, width, half_height, half_width)->
		
		for arrow in @Content[@BOTTOM]
			do (arrow)->(
				arrowHeadPosition = arrow.arrowHead.model.get("Position");
				arrowHeadPosition.x = position.x+half_width
				arrowHeadPosition.y = position.y+height
				arrow.redraw())

		for arrow in @Content[@TOP]
			do (arrow)->(
				arrowHeadPosition = arrow.arrowHead.model.get("Position");
				arrowHeadPosition.x = position.x+half_width
				arrowHeadPosition.y = position.y
				arrow.redraw())

		for arrow in @Content[@LEFT]
			do (arrow)->(
				arrowHeadPosition = arrow.arrowHead.model.get("Position");
				arrowHeadPosition.x = position.x
				arrowHeadPosition.y = position.y + half_height
				arrow.redraw()) 

		for arrow in @Content[@RIGHT]
			do (arrow)->(
				arrowHeadPosition = arrow.arrowHead.model.get("Position");
				arrowHeadPosition.x = position.x+ width
				arrowHeadPosition.y = position.y + half_height
				arrow.redraw())




class ClassArrowTail extends ClassArrowsGroup
	constructor:()->
		super()

	Move:(position, height, width, half_height, half_width)->
		for arrow in @Content[@BOTTOM]
			do (arrow)->(
				arrowTailPosition = arrow.arrowTail.model.get("Position");
				arrowTailPosition.x = position.x+half_width
				arrowTailPosition.y = position.y+height
				arrow.redraw())

		for arrow in @Content[@TOP]
			do (arrow)->(
				arrowTailPosition = arrow.arrowTail.model.get("Position");
				arrowTailPosition.x = position.x+half_width
				arrowTailPosition.y = position.y
				arrow.redraw())

		for arrow in @Content[@LEFT]
			do (arrow)->(
				arrowTailPosition = arrow.arrowTail.model.get("Position");
				arrowTailPosition.x = position.x
				arrowTailPosition.y = position.y + half_height
				arrow.redraw()) 

		for arrow in @Content[@RIGHT]
			do (arrow)->(
				arrowTailPosition = arrow.arrowTail.model.get("Position");
				arrowTailPosition.x = position.x + width
				arrowTailPosition.y = position.y + half_height
				arrow.redraw())

class ClassPropertyPopout
	constructor:(@Position,@view, @model)->

		@mouseUpHandle  = ((evt) ->@onMouseUp(evt)).bind(@) 

	CreateGraphicsObject:()->
		@graphics = new Object();
		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.buttonCircle = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
		@graphics.arrowOne = document.createElementNS("http://www.w3.org/2000/svg", 'polyline');
		@graphics.arrowTwo = document.createElementNS("http://www.w3.org/2000/svg", 'polyline');

		@graphics.group.setAttribute("transform","translate("+@Position.x+","+@Position.y+")");
		
		@graphics.buttonCircle.setAttribute("class","classPropertyDropdown")
		@graphics.buttonCircle.setAttribute("cx","0")
		@graphics.buttonCircle.setAttribute("cy","0")
		@graphics.buttonCircle.setAttribute("r","7")
		@graphics.buttonCircle.addEventListener("mouseup", @mouseUpHandle);

		@graphics.arrowOne.setAttribute("points","-5,-3 0,0 5,-3")
		@graphics.arrowOne.setAttribute("class","classPropertyArrow")
		@graphics.arrowOne.setAttribute("pointer-events","none")

		@graphics.arrowTwo.setAttribute("points","-5,0 0,3 5,0")
		@graphics.arrowTwo.setAttribute("class","classPropertyArrow")
		@graphics.arrowTwo.setAttribute("pointer-events","none")

		@graphics.group.appendChild(@graphics.buttonCircle)
		@graphics.group.appendChild(@graphics.arrowOne)
		@graphics.group.appendChild(@graphics.arrowTwo)

		return @graphics.group;

	onMouseUp:()->
		evt = new Object()
		evt.textBoxGroup = @
		window.UML.Pulse.TextBoxGroupSelected.pulse(evt)

		windowCoord = window.UML.Utils.getScreenCoordForCircleSVGElement(@graphics.group)

		popoverLink = @view.popover();
		popoverLink.css("top",windowCoord.y + 7)
		popoverLink.css("left",windowCoord.x)
		popoverLink.attr("data-original-title","Class Properties")
		VisibilityString = "<div class=\"popoverRow\"> \
						<span class=\"popOverItem\">Visibility: </span>\
							<select id=\"classVisibiltySelect\" class=\"popOverItem popoverSelect\">\
								<option value=\"Public\" ";

		if @model.get("vis") == "Public"
			VisibilityString+=" selected "
		VisibilityString+=">Public</option>\

		<option value=\"Protected\""

		if @model.get("vis") == "Protected"
			VisibilityString+=" selected "

		VisibilityString +=">Protected</option>\
		<option value=\"Private\" "

		if @model.get("vis") == "Private"
			VisibilityString+=" selected "

		VisibilityString += ">Private</option>\
	</select></div>"

		if @model.get("Static")
			StaticString = "<div class=\"popoverRow\"><input type=\"checkbox\" checked id=\"Static\">Static</div>"
		else
			StaticString = "<div class=\"popoverRow\"><input type=\"checkbox\" id=\"Static\">Static</div>"

		textBoxString = "<div><span>Class Description:</span><textarea id=\"classPropertyDescription\">"
		textBoxString+= @model.get("Comment")
		textBoxString+="</textarea></div>";

		popoverLink.attr("data-content",VisibilityString+"<br>"+StaticString+textBoxString+"<h5><small>Right click on classes to add methods and members</small></h5>")
		popoverLink.popover('show')

	deactivate:()->
		popoverLink = @view.popover();
		visibilitySelect = @view.visibility();

		@model.set("vis",visibilitySelect.val());
		@model.set("st", @view.static().is(':checked'));
		@model.set("Comment",@view.comment().val());
		popoverLink.popover('destroy')

class ClassText

	constructor:(@relPosition, @classID, @AttributeIndex) ->
		@onSizeChange = new Event()
		@height = 65
		@width = 142
		@minWidth = 142
		@minHeight = 65

	Move:(@to) ->
		@relPosition = @to
		@graphics.group.setAttribute("transform", "translate("+@relPosition.x+" "+@relPosition.y+")")		

	Resize:() ->
		@graphics.border.setAttribute("height", @height)
		@graphics.border.setAttribute("width", @width)

	CreateGraphics:(@text) ->
		@graphics = new Object()

		@graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
		@graphics.text = document.createElementNS("http://www.w3.org/2000/svg", 'text');
		@graphics.tspan = document.createElementNS("http://www.w3.org/2000/svg", 'tspan');
		@graphics.border = document.createElementNS("http://www.w3.org/2000/svg", 'rect');

		@graphics.text.setAttribute("x",1);
		@graphics.text.setAttribute("y",5);
		@graphics.text.setAttribute("class","classAttribute");
		@graphics.text.setAttribute("onmouseover", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onMouseOver(evt);");
		@graphics.text.setAttribute("onclick", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onClick(evt);");

		@graphics.tspan.setAttribute("x",10);
		@graphics.tspan.setAttribute("dy","1.2em");
		@graphics.tspan.textContent = @text;
		@graphics.text.appendChild(@graphics.tspan)

		@graphics.border.setAttribute("stroke", "none")
		@graphics.border.setAttribute("x", 1)
		@graphics.border.setAttribute("y", 1)
		@graphics.border.setAttribute("height", @height)
		@graphics.border.setAttribute("width", @width)
		@graphics.border.setAttribute("fill", "white")
		@graphics.border.setAttribute("onmouseout", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onMouseExit(evt);");
		@graphics.border.setAttribute("onmouseover", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onMouseOver(evt);");
		@graphics.border.setAttribute("onclick", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onClick(evt);");

		@graphics.group.setAttribute("transform", "translate("+@relPosition.x+" "+@relPosition.y+")")

		@graphics.group.appendChild(@graphics.border)
		@graphics.group.appendChild(@graphics.text)

		return @graphics

	onClick:(evt) ->
		#NEEDS OPTIMISATION 
		@currentEditBox = document.createElement("textArea")
		@currentBackground = document.createElement("div")

		@currentEditBox.value = @text
		@currentEditBox.setAttribute("type", "text")
		@currentEditBox.setAttribute("style","position: absolute;height: 200px;width: 400px;margin: -100px 0 0 -200px;top: 50%; left: 50%;")

		@currentBackground.setAttribute("style", "background-color: rgba(0,0,0,0.4); height:100%; width:100%; position:fixed; top:0px; left:0px; right:0px; bottom:0px")
		@currentEditBox.setAttribute("onBlur", "window.UML.globals.classes["+@classID+"].Attributes["+@AttributeIndex+"].onBlur();")

		@currentBackground.appendChild(@currentEditBox)
		document.getElementById('WorkArea').appendChild(@currentBackground)

		@currentEditBox.focus();

	onBlur:() ->
		@text = @currentEditBox.value
		@repopulateText(@text)	
		@currentBackground.parentNode.removeChild(@currentBackground)

	repopulateText:(text) ->
		properties = text.split("\n") # is this safe? neet to check (probably not for UNIX line endings)
		@graphics.text.textContent = "";
		ref = @
		for property in properties
			do (property, ref)->
				newSpan = document.createElementNS("http://www.w3.org/2000/svg", 'tspan');
				newSpan.setAttribute("x",10);
				newSpan.setAttribute("dy","1.2em");
				newSpan.textContent = property;
				
				ref.graphics.text.appendChild(newSpan);
				return 

		@recalculateSize()
		@graphics.border.setAttribute("height", @height)
		@graphics.border.setAttribute("width", @width)
		@onSizeChange.pulse(null)

	onMouseOver:(evt) ->
		@graphics.border.setAttribute("stroke", "#3385D6")
	onMouseExit:(evt) ->
		@graphics.border.setAttribute("stroke", "none")

	recalculateSize:() ->
		newWidth = @graphics.text.getBBox().width
		newHeight = @graphics.text.getBBox().height

		@width = @calculateWidth(newWidth)
		@height = @calculateHeight(newHeight)

	calculateWidth:(newWidth)->
		sizeToUse = @width
		if newWidth > @width-20 then sizeToUse = newWidth+40
		else if newWidth < @width-50 then sizeToUse = newWidth+ 40;
		Math.max(@minWidth, sizeToUse)

	calculateHeight:(newHeight)->
		Math.max(newHeight, @minHeight)

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

class window.UML.Ctrlz.CtrlzBuffer
	constructor:()->
		@ZBufferStack = new Array()
		@UndoHandl = (@Undo).bind(@)
		@RedoHandl = (@Redo).bind(@)
		@bufferSize = 30
		@bufferIndex = -1
		@started = false;

	Start:()->
		window.UML.globals.KeyboardListener.RegisterKeyWithAlthernate(window.UML.AlternateKeys.CTRL,'Z'.charCodeAt(0),@UndoHandl)
		window.UML.globals.KeyboardListener.RegisterKeyWithAlthernate(window.UML.AlternateKeys.CTRL,'Y'.charCodeAt(0),@RedoHandl)
		@started = true;

	flushBuffer:()->
		@ZBufferStack = []
		@bufferIndex = -1;


	Push:(action)->
		if @started
			if @ZBufferStack.length > @bufferSize
				@ZBufferStack.shift()
				@bufferIndex--

			@bufferIndex++
			@ZBufferStack[@bufferIndex] = action;

			@ZBufferStack.splice(@bufferIndex+1, @bufferSize-@bufferIndex); #invalidate all actions after current index (so that after a push you cannot "Redo" old actions)

	Redo:()->
		
		redoAction = @ZBufferStack[@bufferIndex+1]
		if redoAction
			@bufferIndex++;
			Debug.write("Redo Action: "+Debug.unpack(redoAction))
			@SendAction(redoAction)

	clone:(obj)->
		
		if null == obj || "object" != typeof obj
			return obj;

		copy = obj.constructor();
		
		for attr of obj
			if obj.hasOwnProperty(attr)
				copy[attr] = obj[attr];
		
		return copy;

	Undo:()->
		undoAction = @ZBufferStack[@bufferIndex]
		if undoAction
			@bufferIndex--;
			undoAction = @InvertAction(@clone(undoAction))
			Debug.write("Undo Action: "+Debug.unpack(undoAction))
			@SendAction(undoAction)

	InvertAction:(action)->
		if action.hasOwnProperty("modelListID")
			if action.changeType == "DEL"
				action.changeType = "ADD"
			else
				action.changeType = "DEL"
		else if action.hasOwnProperty("modelID")
			if action.hasOwnProperty("names") # if set is a multi value set
					prevValues = action.prev_values
					action.prev_values = action.values
					action.values = prevValues
			else
					prevValue = action.prev_value
					action.prev_value = action.values
					action.value = prevValue
		action
		
	SendAction:(action)->
		if action
			if action.hasOwnProperty("modelListID")

				modelList = window.UML.MODEL.ModelLists.get(action.modelListID)
				if action.changeType == "DEL"
					modelList.removeNoLog(action.item)
				else if action.changeType == "ADD"
					modelList.pushNoLog(action.item)

			else if action.hasOwnProperty("modelID") 
				if action.hasOwnProperty("names") # if set is a multi value set
					((i)->
						modelItem = window.UML.MODEL.ModelItems.get(action.modelID);
						modelItem.setNoLog(action.names[i],action.values[i]);)(i) for i in [0 .. action.names.length]
				else
					modelItem = window.UML.MODEL.ModelItems.get(action.modelID);
					modelItem.setNoLog(action.name,action.value);


Debug = {}
Debug.IsDebug = false


Debug.Startup= ()->
	if not Debug.IsDebug
		Debug.write = (msg)-> return
		Debug.unpack = (obj)-> ""

Debug.write= (msg)->
		console.log("CODE COOKER DEBUG MESSAGE: "+msg)

Debug.unpack = (obj)->
		JSON.stringify(obj)

window.CodeCooker = window.CodeCooker || {}
window.CodeCooker.Debug = Debug;

window.UML.Pulse.DropZoneEnter = new Event()
window.UML.Pulse.DropZoneLeave = new Event()

class DropZone
	constructor:(@index) ->
		window.UML.Arrows.Arrow_On_Follow.add((@Show).bind(@));
		window.UML.Arrows.Arrow_Un_Follow.add((@Hide).bind(@));

	Move:(To) ->
		@position = To
		@Redraw()

	CreateGraphics:(@classID) ->
		@graphics = new Object()

		@graphics.arrowDrop = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
		@graphics.arrowDrop.setAttribute("cx", @position.x);
		@graphics.arrowDrop.setAttribute("cy", @position.y);
		@graphics.arrowDrop.setAttribute("r", "3");
		@graphics.arrowDrop.setAttribute("style", "fill:none");

		@graphics.hiddenDropRange = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
		
		@graphics.hiddenDropRange.setAttribute("onmousedown","window.UML.globals.classes.get("+@classID+").DropZones["+@index+"].OnMouseDown(evt);");
		@graphics.hiddenDropRange.setAttribute("class","dropZone");
		@graphics.hiddenDropRange.setAttribute("cx", @position.x);
		@graphics.hiddenDropRange.setAttribute("cy", @position.y);
		@graphics.hiddenDropRange.setAttribute("r", "20");
		@graphics.hiddenDropRange.setAttribute("style","fill-opacity:0.0");	
		@graphics.hiddenDropRange.setAttribute("onmouseover", "window.UML.globals.classes.get("+@classID+").DropZones["+@index+"].OnMouseOver(evt);");
		@graphics.hiddenDropRange.setAttribute("onmouseout", "window.UML.globals.classes.get("+@classID+").DropZones["+@index+"].OnMouseOut(evt)");
		return @graphics

	Redraw:() ->
		@graphics.arrowDrop.setAttribute("cx", @position.x);
		@graphics.arrowDrop.setAttribute("cy", @position.y);
		@graphics.hiddenDropRange.setAttribute("cx", @position.x);
		@graphics.hiddenDropRange.setAttribute("cy", @position.y);

	Hide:()->
		@graphics.arrowDrop.setAttribute("style", "fill:none");

	Show:()->
		@graphics.arrowDrop.setAttribute("style", "fill:black");

	OnMouseOver:(evt) ->
		$(@graphics.hiddenDropRange).animate({'fill-opacity': 0.15}, 100)

		evt.position = @GetSnapPosition()
		evt.classID = @classID
		evt.index = @index
		window.UML.Pulse.DropZoneEnter.pulse(evt)

	OnMouseOut:(evt) ->
		$(@graphics.hiddenDropRange).stop()
		@graphics.hiddenDropRange.setAttribute("style","fill-opacity:0.0");
		window.UML.Pulse.DropZoneLeave.pulse(evt)

	OnMouseDown:(evt) ->

		arrow = globals.arrows.Create(@GetSnapPosition(),
											 window.UML.Utils.mousePositionFromEvent(evt),
											 @classID,
											 @index)
		arrow.arrowHead.Follow()

	GetSnapPosition:() ->
		window.UML.Utils.getSVGCoordForGroupedElement(@graphics.arrowDrop).add(@position)


window.UML.Pulse.TypeNameChanged = new Event()
window.UML.Pulse.TypeDeleted = new Event()

class Globals
	constructor: ->
		
		@document = null
		@classes = new classes((Item)-> Item.model.modelItemID)
		@arrows = new window.UML.Arrows.Arrows((ArrowItem)-> ArrowItem.model.get("id"))
		@namespaces = new Namespaces((NamespaceItem)-> NamespaceItem.myID)
		@textBoxes = new IDIndexedList((TextBoxItem)->TextBoxItem.myID)
		@selections = new Selections()
		@highlights = new Highlights()
		@LayerManager = new LayerManager();
		@CtrlZBuffer = new window.UML.Ctrlz.CtrlzBuffer();
		@Model = new window.UML.MODEL.MODEL();
		
		
		@CommonData = {version : "0.0.0";
		filename : "Diagram01";
		Types : (new window.UML.StringTree.StringTree())} 

		@CommonData.Types.Build("Int")
		@CommonData.Types.Build("Float")
		@CommonData.Types.Build("String")
		@CommonData.Types.Build("Boolean")
		@CommonData.Types.Build("Time")
		@CommonData.Types.Build("Date")
		@CommonData.Types.Build("DateTime");


		window.UML.Pulse.TypeNameChanged.add((evt)->
			window.UML.globals.CommonData.Types.Remove(evt.prevText)
			window.UML.globals.CommonData.Types.Build(evt.newText))

		window.UML.Pulse.TypeDeleted.add((evt)->
			window.UML.globals.CommonData.Types.Remove(evt.typeText))



#I dont like this Idea seems like a hack, i wanna change it..
#this is such a shit class 

class Highlights
	constructor:()->
		@highlightedClass = null
		@highlightedTextElement = null
		@highlightedTextTextGroup = null
		@highlightedInterface = null
		@highlightedNamespace = null
		@highlightedArrow = null

	HighlightClass:(element)->
		if(@highlightedClass != null)
			@UnHighlightClass()
		if(@highlightedInterface != null)
			@UnHighlightInterface();
		if(@highlightedNamespace != null)
			@UnHighlightInterface();
		if(@highlightedArrow != null)
			@UnHighlightArrow();

		@highlightedClass = element
		@highlightedClass.Highlight()

	HighlightInterface:(element)->
		if(@highlightedInterface != null)
			@UnHighlightInterface();
		if(@highlightedClass != null)
			@UnHighlightClass();
		if(@highlightedNamespace != null)
			@UnHighlightInterface();
		if(@highlightedArrow != null)
			@UnHighlightArrow();

		@highlightedInterface = element;
		@highlightedInterface.Highlight();

	HighlightArrow:(element)->
		if(@highlightedInterface != null)
			@UnHighlightInterface();
		if(@highlightedClass != null)
			@UnHighlightClass();
		if(@highlightedNamespace != null)
			@UnHighlightInterface();
		if(@highlightedArrow != null)
			@UnHighlightArrow();

		@highlightedArrow = element;
		@highlightedArrow.Highlight();

	HighlightTextElement:(element)->
		if(@highlightedTextElement != null)
			@highlightedTextElement.Unhighlight()

		@highlightedTextElement = element
		@highlightedTextElement.Highlight()

	HighlightNamespace:(element)->
		if(@highlightedInterface != null)
			@UnHighlightInterface();
		if(@highlightedClass != null)
			@UnHighlightClass();
		if(@highlightedNamespace != null)
			@UnHighlightInterface();
		if(@highlightedArrow != null)
			@UnHighlightArrow();

		@highlightedNamespace = element
		@highlightedNamespace.Highlight();

	UnhighlightNamespace:()->
		if(@highlightedNamespace != null)
			@highlightedNamespace.Unhighlight();

		@highlightedNamespace = null;

	UnHighlightClass:()->
		if(@highlightedClass != null)
			@highlightedClass.Unhighlight();
		
		@highlightedClass = null
		@UnHighlightTextElement()

	UnHighlightInterface:()->
		if(@highlightedInterface != null)
			@highlightedInterface.Unhighlight();

		@highlightedInterface = null;
		@UnHighlightTextElement();

	UnHighlightArrow:()->
		if(@highlightedArrow != null)
			@highlightedArrow.Unhighlight();

		@highlightedArrow = null;

	UnHighlightTextElement:()->
		if(@highlightedTextElement != null)
			@highlightedTextElement.Unhighlight()

		@highlightedTextElement = null


class window.UML.Interaction.Draggable
	constructor:(@on_drag_start, @on_drag, @on_drag_end, object, @getPosition)->
		@mouse_down_Handel = ((evt) ->@on_mouse_down(evt)).bind(@)
		@mouse_move_Handle = null
		@mouse_move_Up_Handle = null

		object.addEventListener("mousedown", @mouse_down_Handel, false);

	detatch_for_GC:(object)->
		object.removeEventListener("mousedown", @mouse_down_Handel, false);
		@mouse_down_Handel = null;

	on_mouse_down:(evt)->
		if(@mouse_move_Handle == null && @mouse_move_Up_Handle == null && evt.button != rightMouse)
			@mouse_move_Handle = ((evt) ->@on_mouse_move(evt)).bind(@) 
			@mouse_move_Up_Handle  = ((evt) ->@on_mouse_up(evt)).bind(@)

			@cursorDelta = new Point(0,0);
			@cursorDelta = @cursorDelta.add(window.UML.Utils.mousePositionFromEvent(evt))
			@cursorDelta = @cursorDelta.sub(@getPosition());

			globals.document.addEventListener("mousemove",@mouse_move_Handle,false);
			globals.document.addEventListener("mouseup", @mouse_move_Up_Handle,false);

			@on_drag_start();

	on_mouse_up:(evt)->
		globals.document.removeEventListener("mousemove",@mouse_move_Handle,false);
		globals.document.removeEventListener("mouseup", @mouse_move_Up_Handle,false);

		@mouse_move_Handle = null;
		@mouse_move_Up_Handle = null;

		@cursorDelta = null;

		@on_drag_end();


	on_mouse_move:(evt)->
		loc = window.UML.Utils.mousePositionFromEvent(evt)
		moveTo = new Point(loc.x, loc.y)
		
		@on_drag(moveTo.sub(@cursorDelta))



window.UML.AlternateKeys = {CTRL : 17, ALT : 18}

class KeyboardListener
	constructor: ()->
		@keyCodes = new Object();
		@keyCodes.Del = 46
		@KeysWithInterests = new Array();
		@KeyDownWithInterests = new Array();
		@KeyWithAlternate = {}
		@KeyWithAlternate[window.UML.AlternateKeys.CTRL] = new Array()
		@KeyWithAlternate[window.UML.AlternateKeys.ALT] = new Array()

		@currentAlternate = null;

		window.onkeyup = ((evt) ->@onkeyup(evt)).bind(@) 
		window.onkeydown = ((evt) ->@onkeydown(evt)).bind(@) 

	isAltKey:(key)->
		for own prop, value of window.UML.AlternateKeys
			if value == key
				return true
		return false

	onkeyup: (evt)->
		key = if evt.keyCode then evt.keyCode else evt.which;
		if(key == @keyCodes.Del)
			globals.selections.selectedGroup.del()

		if @isAltKey(key)
			@currentAlternate = null

		retVal = true
		kayInterests = @KeysWithInterests[key]
		if(@KeysWithInterests[key])
			for interestedHandler in @KeysWithInterests[key]
				do(interestedHandler)->
					if(!interestedHandler(evt))
						retVal = false

		return retVal;


	onkeydown: (evt)->
		key = if evt.keyCode then evt.keyCode else evt.which;
		if(key == @keyCodes.Del)
			globals.selections.selectedGroup.del()

		isAltKey = @isAltKey(key)
		if(isAltKey)
			@currentAlternate = key
		else # handlers with aluternates take priority
			if(@currentAlternate != null && @KeyWithAlternate[@currentAlternate][key])
				for interestedHandler in @KeyWithAlternate[@currentAlternate][key]
					do(interestedHandler)->
						if(!interestedHandler(evt))
							retVal = false
				return retVal

		retVal = true
		kayInterests = @KeyDownWithInterests[key]
		if(@KeyDownWithInterests[key])
			for interestedHandler in @KeyDownWithInterests[key]
				do(interestedHandler)->
					if(interestedHandler) # check the handerl is still valid as it make have been removed by a previous handler
						if(!interestedHandler(evt))
							retVal = false

		return retVal;


	RegisterKeyInterest:(key, handler)->
		if(!@KeysWithInterests[key])
			@KeysWithInterests[key] = new Array();

		@KeysWithInterests[key].push(handler);

	UnRegisterKeyInterest:(key, handler)->
		if(@KeysWithInterests[key])
			index = @KeysWithInterests[key].indexOf(handler) 
			@KeysWithInterests[key].splice(index, 1)


	RegisterDownKeyInterest:(key, handler)->
		if(!@KeyDownWithInterests[key])
			@KeyDownWithInterests[key] = new Array();

		@KeyDownWithInterests[key].push(handler);

	UnRegisterDownKeyInterest:(key, handler)->
		if(@KeyDownWithInterests[key])
			index = @KeyDownWithInterests[key].indexOf(handler) 
			@KeyDownWithInterests[key].splice(index, 1)

	RegisterKeyWithAlthernate:(alternateKey, key, handler)->
		if(@KeyWithAlternate[alternateKey])
			if(!@KeyWithAlternate[alternateKey][key])
				@KeyWithAlternate[alternateKey][key] = new Array()

			@KeyWithAlternate[alternateKey][key].push(handler)

class LayerManager
	constructor:()->


	InsertArrowLayer:(element)->
		#globals.document.appendChild(element);	
		# This method is not called because there is no need to yet, arrows should be on top off eveythign else

	InsertNamespaceLayer:(element)->
		namespaceLayer = globals.document.getElementById("namespaceLayerMarker");
		globals.document.insertBefore(element,namespaceLayer);	

	InsertClassLayer:(element)->
		classLayer = globals.document.getElementById("classLayerMarker");
		globals.document.insertBefore(element, classLayer);
	
		


window.UML.LayoutEngine = window.UML.LayoutEngine || {};

((namespace)->
	GridElementRegister = []
	GridElementID = 0;

	namespace.register = (gridElement)->
		GridElementRegister[GridElementID++] = gridElement;
		return gridElement;

	namespace.resolve = (gridID)->
		return GridElementRegister[gridID]


)(window.UML.LayoutEngine)


class GridShiftUtill.MoveDown
	constructor:()->

	increment_cell_in_move_direction:(cell)-> cell.y += 1
	translate:(gridElement, size)->	gridElement.translate(0, size)
	direction:(girdElement)-> return girdElement.y
	translate_non_direction_value:(element, value)-> element.x += value;

class GridShiftUtill.MoveUp
	constructor:()->

	increment_cell_in_move_direction:(cell)-> cell.y -= 1
	translate:(gridElement, size)->	gridElement.translate(0, -size)
	direction:(girdElement)-> return girdElement.y
	translate_non_direction_value:(element, value)->element.x -= value;

class GridShiftUtill.MoveLeft
	constructor:()->

	increment_cell_in_move_direction:(cell)-> cell.x -= 1
	translate:(gridElement, size)->	gridElement.translate(-size,0)
	direction:(girdElement)-> return girdElement.x
	translate_non_direction_value:(element, value)->element.y -= value;

class GridShiftUtill.MoveRight
	constructor:()->

	increment_cell_in_move_direction:(cell)-> cell.x += 1
	translate:(gridElement, size)->	gridElement.translate(size,0)
	direction:(girdElement)-> return girdElement.x
	translate_non_direction_value:(element, value)->element.y += value;

class GridShifter
	constructor:(@shift, @grid)->


#######################################################################
#
#	this function takes a grid element and attempts to move it 
#	down the grid by selecting the grid elements below the current
#	element and recursivly moveing them down by the requested amount.
#   gaps in the grid are handled by moveing the grid elements below 
#   us by a proportinally smaller ammount so as to close the gaps
#
#######################################################################
	move:(gridElement, moveSize)->
		nextElementLocation = gridElement.position.add(gridElement.size)
		@increment_cell_in_move_direction(nextElementLocation)

		endDirectionPosition = @shift.direction(gridElement.position) + moveSize
		currentDirectionPosition = @shift.direction(nextElementLocation)

		while (currentDirectionPosition < endDirectionPosition) || moveSize >= 0

			row_start  = @shift.non_direction(nextElementLocation)
			row_end	   = @shift.non_direction(gridElement.position) + @shift.non_direction(gridElement.size)
			row_height = @shift.direction(gridElement.position) 

			elementsInRow = @get_elements_in_row(row_start,row_end,row_height);

			if !elementsInRow
				moveSize --

			@increment_cell_in_move_direction(nextElementLocation)

			for element in elementsInRow
				@move(element, moveSize)

		@shift.translate(gridElement, moveSize)

	get_elements_in_row:(rowStart, rowEnd, rowY)->
		
		widestElement = 0
		emptyRow = true
		elementsInRow = []

		currentGridCell = new Point(rowStart, rowY)

		while @shift.non_direction(currentGridCell) < rowEnd
				
				elements = @grid.getGridElementsAt(currentGridCell)
				elementsInRow = elementsInRow.concat(elements)

				if elements.length != 0
					emptyRow = false
					
					for element in elements
						if @shift.non_direction(element) > widestElement
							widestElement = @shift.non_direction(element)

				@shift.translate_non_direction_value(currentGridCell, widestElement + 1)

		if emptyRow
			return false;
		else
			return elementsInRow;

		

class LayoutGrid

	constructor:(girdSize)->
		@grid = [0..girdSize.x]
		for x in [0 .. girdSize.x]
			@grid[x] = [0..girdSize.y]
			for y in [0 .. girdSize.y]
				@grid[x][y] = [];

		@leftShifter = new GridShifter(new GridShiftUtill.MoveLeft(),@)
		@rightShifter = new GridShifter(new GridShiftUtill.MoveRight(),@)
		@upShifter = new GridShifter(new GridShiftUtill.MoveUp(),@)
		@downShifter = new GridShifter(new GridShiftUtill.MoveDown(),@)


	moveElementDown:(gridElement, moveSize)->
		@downShifter.move(gridElement, moveSize)

	moveElementUp:(gridElement, moveSize)->
		@upShifter.move(gridElement, moveSize)

	moveElementLeft:(gridElement, moveSize)->
		@leftShifter.move(gridElement, moveSize)

	moveElementRight:(gridElement, moveSize)->
		@rightShifter.move(gridElement, moveSize)
		

	getGridElementsAt:(point)->
		resolvedGridElements = []

		elementIds = @grid[point.x][point.y];
		for id in elementIds
			resolvedGridElements.push(window.UML.LayoutEngine.resolve(id))

		return resolvedGridElements;



	isEmpty:(topLeft, size)->
		empty = true;
		for x in [gridLayoutElement.position.x .. gridLayoutElement.position.x + gridLayoutElement.size.x]
			for y in [gridLayoutElement.position.y .. gridLayoutElement.position.y + gridLayoutElement.size.y]
				empty = empty && @cellIsEmpty(x,y)

	cellIsEmpty:(x, y)->
		return @grid[x][y].length == 0

	occupy:(gridLayoutElement)->
		for x in [gridLayoutElement.position.x .. gridLayoutElement.position.x + gridLayoutElement.size.x]
			for y in [gridLayoutElement.position.y .. gridLayoutElement.position.y + gridLayoutElement.size.y]
				@grid[x][y].push(gridLayoutElement.elementRegisterID)

	free:(gridLayoutElement)->
		for x in [gridLayoutElement.position.x .. gridLayoutElement.position.x + gridLayoutElement.size.x]
			for y in [gridLayoutElement.position.y .. gridLayoutElement.position.y + gridLayoutElement.size.y]
				@grid[x][y] = @grid[x][y].filter(gridLayoutElement.elementRegisterID)


class LayoutGridElement
	constructor:(@grid, @size, @position, @content, register)->
		@elementRegisterID = register.register(@);

	translate:(x, y)->

		@grid.free(@)
		
		@position.x = x
		@position.y = y

		@grid.occupy(@)
		@content.set("Position", new Point(x,y)


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




class RouteResolver
	constructor:()->
		@routes = new Array()


	createRoute:(routeName, value)->
		@routes[routeName] = value;

	appendRoute:(value)->
		if value of @routes
			@routes[routeName]+= value;
		else
			console.log("Unknown Route requested: "+routeName)
	resolveRoute:(routeName)->
		if routeName of @routes
			return @routes[routeName]
		else
			console.log("Unknown Route requested: "+routeName)
			return "";


window.UML.Serialize.SerializeArrows= (serilizer)->
	arrows = new Array()
	for arrow in globals.arrows.List
		arrows.push(serilizer.SerializeItem(arrow.model))
	return arrows



class BaseObjectSerlizer
	constructor:(@obj)->

	serialize:(serialiseSelector)->
		return @obj;

window.UML.Serialize.SerializeClasses= (serilizer)->
	classes = new Array()
	for classItem in globals.classes.List
		if !classItem.IsInterface
			classes.push(serilizer.SerializeItem(classItem.model))

	return classes;

window.UML.Serialize.SerializeInterfaces= (serilizer)->
	interfaces = new Array()
	for interfaceItem in globals.classes.List
		if interfaceItem.IsInterface
			interfaces.push(serilizer.SerializeItem(interfaceItem.model))

	return interfaces;




class ComplexObjectSerlizer
	constructor:(@obj)->

	serialize:(serialiseSelector)->
		return @obj;

class ModelItemSerilzer
	constructor:(@obj)->

	serialize:(serialiseSelector)->
		ref = @;
		serilizedObject = {};

		for subObj of @obj
			do(ref,serilizedObject)->
				serializer = serialiseSelector.select(ref.obj[subObj])
				serilizedObject[subObj] = serializer.serialize(serialiseSelector);

		return serilizedObject;

class ModelListSerlizer

	constructor:(@obj)->

	serialize:(serialiseSelector)->
		ref = @
		serilizedList = []

		for subObj in @obj
			do(ref, serilizedList)->
				serializer = serialiseSelector.select(subObj)
				serilizedList[ref.obj.indexOf(subObj)] = serializer.serialize(serialiseSelector);

		return serilizedList

window.UML.Serialize.SerializeNamespaces= (serilizer)->
	namespaces = new Array()
	for ns in globals.namespaces.List
		namespaces.push(serilizer.SerializeItem(ns.model))

	return namespaces


class NetworkModelIdWrapperSerlizer
	constructor:(@modelItemID, @modelItem)->

	serialize:(serialiseSelector)->
		serilizedObject = {};
		serilizedObject.modelItemID = @modelItemID;
		serilizedObject.model = @modelItem.serialize(serialiseSelector);
		
		return serilizedObject;

class NetworkModelListIdWrapperSerlizer
	constructor:(@modelItemID, @modelItem)->

	serialize:(serialiseSelector)->
		serilizedObject = {};
		serilizedObject.modelListID = @modelItemID;
		serilizedObject.model = @modelItem.serialize(serialiseSelector);
		
		return serilizedObject;

class window.UML.Serialize.NetworkSincSerlizationSelector
	constructor:()->

	select:(modelObject)->
		if (modelObject.hasOwnProperty("modelItemID"))
			return new NetworkModelIdWrapperSerlizer(modelObject.modelItemID ,new ModelItemSerilzer(modelObject.model))

		else if(modelObject.hasOwnProperty("modelListID"))

			itemListModel = new Array();
			for subItem in modelObject.list
				itemListModel.push(subItem)
			
			return new NetworkModelListIdWrapperSerlizer(modelObject.modelListID, new ModelListSerlizer(itemListModel))

		else if (((typeof classItem == "object") && (classItem != null) ) && not jQuery.isFunction(classItem)) # if a complex data item)
			return new ComplexObjectSerlizer(modelObject)
			
		else
			return new BaseObjectSerlizer(modelObject);

class SaveModelSerilzationSelector
	constructor:()->

	select:(modelObject)->
		if (modelObject.hasOwnProperty("modelItemID"))
			return new ModelItemSerilzer(modelObject.model)

		else if(modelObject.hasOwnProperty("modelListID"))

			itemListModel = new Array();
			for subItem in modelObject.list
				itemListModel.push(subItem)
			
			return new ModelListSerlizer(itemListModel)

		else if (((typeof classItem == "object") && (classItem != null) ) && not jQuery.isFunction(classItem)) # if a complex data item)
			return new ComplexObjectSerlizer(modelObject)
			
		else
			return new BaseObjectSerlizer(modelObject);

class window.UML.Serialize.SerializeModel

	constructor:(@serialiseSelector)->

	Serialize:()->
		model = new Object()
		model["Name"] =  window.UML.globals.CommonData.filename;
		model["Version"] = window.UML.globals.CommonData.version;
		classList = window.UML.Serialize.SerializeClasses(@);
		interfaceList = window.UML.Serialize.SerializeInterfaces(@);
		namespaceList = window.UML.Serialize.SerializeNamespaces(@);
		arrowList = window.UML.Serialize.SerializeArrows(@);

		
		model["classList"] = classList
		model["arrowList"] = arrowList
		model["interfaceList"] = interfaceList;
		model["namespaceList"] = namespaceList;

		if Debug.IsDebug
			modelText = JSON.stringify(model,null, '\t')
		else
			modelText = JSON.stringify(model)
			
		return modelText

	SerializeItem:(item)->
	
		serilzer = @serialiseSelector.select(item)
		return serilzer.serialize(@serialiseSelector)

class window.UML.Unpacker.DefaultUnpackStratagy
	constructor:()->


	unpack:(item, unpacker)->
		if window.UML.typeIsArray item
			unpacker.UnpackArray(item)
		else 
			unpacker.UnpackItem(item)	

class window.UML.Unpacker.NetworkUnpackStratagy
	constructor:()->

	unpack:(item, unpacker)->
		
		if item.hasOwnProperty("model")
			@unpackModelWrapedElement(unpacker, item)
		else
			@unpackElement(unpacker, item)
	
	unpackModelWrapedElement:(unpacker, modelItem)->
		if window.UML.typeIsArray modelItem.model
			return unpacker.UnpackArray(modelItem.model, modelItem.modelListID)
		else
			return unpacker.UnpackItem(modelItem.model, modelItem.modelItemID)

	unpackElement:(unpacker, modelItem)->
		if window.UML.typeIsArray modelItem
			return unpacker.UnpackArray(modelItem, -2)
		else
			return unpacker.UnpackItem(modelItem, -2)    	

class window.UML.Unpacker.Unpacker
	constructor:(@unpackingStratagy)->


	Unpack:(model)->
		deepModel = JSON.parse(model)
		
		classList = deepModel.classList;
		interfaceList = deepModel.interfaceList
		namespaceList = deepModel.namespaceList
		arrowList = deepModel.arrowList

		classList = @UnpackObject(classList)
		interfaceList = @UnpackObject(interfaceList)
		namespaceList = @UnpackObject(namespaceList)
		arrowList = @UnpackObject(arrowList)

		if deepModel.Name
			window.UML.globals.CommonData.filename = deepModel.Name

		if deepModel.Version
			window.UML.globals.CommonData.version = deepModel.Version
		
		for classItem in classList.list
			globals.Model.classList.pushNoLog(classItem)

		for interfaceItem in interfaceList.list
			globals.Model.interfaceList.pushNoLog(interfaceItem)

		for namespace in namespaceList.list
			globals.Model.namespaceList.pushNoLog(namespace)

		for arrowModel in arrowList.list
			globals.Model.arrowList.pushNoLog(arrowModel);

	UnpackObject:(obj)->
		@unpackingStratagy.unpack(obj,@)

	UnpackArray:(obj, IDOverride)->
		
		# HACK allert
		# this hack means that if we have an array of basic items then a basic array of items is returned not a model list
		if obj.length > 0 && not (IDOverride?) && not (IDOverride > -1)
			if not window.UML.typeIsObject(obj[0]) && not window.UML.typeIsArray obj[0]
				modelList = new Array();
				for item in obj
					modelList.push(item)
				return modelList

		# non hacky bit
		if(IDOverride?)
			modelList = new window.UML.MODEL.ModelList(IDOverride)
		else
			modelList = new window.UML.MODEL.ModelList()

		for item in obj
			modelList.pushNoLog(@UnpackObject(item))

		return modelList

	UnpackItem:(obj, IDOverride)->
		if(IDOverride?)
			model = new window.UML.MODEL.ModelItem(IDOverride)
		else
			model = new window.UML.MODEL.ModelItem()

		for item of obj # unpack a model object
			if window.UML.typeIsObject(obj[item]) # if a complex data item
				model.setNoLog(item, @UnpackObject(obj[item]))
			else
				model.setNoLog(item, obj[item])

		return model




window.UML.Utils.mousePositionFromEvent= (evt) ->
	pt = globals.document.createSVGPoint()
	pt.x = evt.clientX;
	pt.y = evt.clientY;
	point =  pt.matrixTransform(globals.document.getScreenCTM().inverse());
	return new Point(point.x, point.y)

window.UML.Utils.getScreenCoordForSVGElement= (element) ->
	matrix  = element.getScreenCTM();
	pt  = globals.document.createSVGPoint();

	pt.x = element.x.animVal.value;
	pt.y = element.y.animVal.value;
	
	screenCoords = pt.matrixTransform(matrix);
	return new Point(screenCoords.x,screenCoords.y)

window.UML.Utils.getScreenCoordForCircleSVGElement= (element) ->
	matrix  = element.getScreenCTM();
	pt  = globals.document.createSVGPoint();

	pt.x = element.getAttribute("cx");
	pt.y = element.getAttribute("cy");
	
	screenCoords = pt.matrixTransform(matrix);
	return new Point(screenCoords.x,screenCoords.y)

window.UML.Utils.getSVGCorrdforScreenPos= (point) ->
	matrix  = globals.document.getScreenCTM();
	pt  = globals.document.createSVGPoint();

	pt.x = point.x
	pt.y = point.y;
	
	svgCoords = pt.matrixTransform(matrix.inverse());
	return new Point(svgCoords.x,svgCoords.y)

window.UML.Utils.getSVGCoordForGroupedElement= (group) ->
	point = globals.document.createSVGPoint()
	# This is the top-left relative to the SVG element
	ctm = group.getCTM()
	svgCoords = point.matrixTransform(ctm)
	return new Point(svgCoords.x,svgCoords.y)

window.UML.Utils.fromSVGCoordForGroupedElement= (svgCoord, element) ->
	point = globals.document.createSVGPoint()
	
	point.x = svgCoord.x;
	point.y = svgCoord.y;

	ctm = element.getCTM()
	localCoords = point.matrixTransform(ctm.inverse())
	return new Point(localCoords.x,localCoords.y)

window.UML.Utils.ConvertFrameOfReffrence = (svgCoord, refrenceFrameFrom, refrenceFrameTo) ->
	point = globals.document.createSVGPoint()
	
	point.x = svgCoord.x;
	point.y = svgCoord.y;

	globalCoords = point.matrixTransform(refrenceFrameFrom)
	toCoords = globalCoords.matrixTransform(refrenceFrameTo.inverse())
	return new Point(toCoords.x,toCoords.y)

window.UML.Utils.CreateJSONForModel= ()->
	model = new Object()
	model["Name"] = globals.filename;
	model["Version"] = window.UML.globals.CommonData.version;
	classList = window.UML.Serialize.SerializeClasses();
	interfaceList = window.UML.Serialize.SerializeInterfaces();
	namespaceList = window.UML.Serialize.SerializeNamespaces();
	arrowList = window.UML.Serialize.SerializeArrows();

	
	model["classList"] = classList
	model["arrowList"] = arrowList
	model["interfaceList"] = interfaceList;
	model["namespaceList"] = namespaceList;
	modelText = JSON.stringify(model)
	return modelText
	


window.UML.Utils.SendPost= (data, url, onCompleatFunc)->
	$.ajax({
		  type: "POST",
		  url: url,
		  data: data,
		  success: onCompleatFunc,
		  dataType: "html"
		});
	return

window.UML.Utils.CreatePoint = (x,y) ->
	new Point(x,y)

window.UML.Utils.doSave = () ->
	window.Interface.StatusBar.setLoadingStatus("Saving")
	saveSerilzer = new window.UML.Serialize.SerializeModel(new window.UML.Serialize.NetworkSincSerlizationSelector());
	json = saveSerilzer.Serialize()
	Debug.write(json)

	window.Interface.File.uploadFile(json, '/File/UploadFile', {
			uploadComplete:()->
				window.UML.displayAjaxResponce(this.responseText,"Save");
				window.Interface.StatusBar.setNewStatus("OK","");
			uploadFailed:()-> 
				window.Interface.StatusBar.setNewStatus("Upload Failed","");
			uploadCanceled:()->
				window.Interface.StatusBar.setNewStatus("Upload Canceled","");
			uploadProgress:()->
		});


window.UML.Utils.doSaveAs = () ->
	#window.UML.Utils.displayChangeFilename( ()-> window.UML.Utils.SendPost(window.UML.Utils.CreateJSONForModel(), '/ClassDiagram/Save', window.UML.displayAjaxResponce);)

window.UML.Utils.doGenCode = (language) ->
	window.UML.displayAjaxResponce("<div style=\"width:100px;margin-left:auto; margin-right:auto;\"><object data=\"/content/img/cauldrin-large.svg\" type=\"image/svg+xml\" style=\"height:140px;width:100px\"></object></div>","Cooking...");
	Serilzer = new window.UML.Serialize.SerializeModel(new SaveModelSerilzationSelector());
	json = Serilzer.Serialize()
	window.UML.Utils.SendPost(json, '/ClassDiagram/DownloadCode?language='+language, window.UML.displayAjaxResponce);
	Debug.write(json)

window.UML.Utils.displayChangeFilename = () ->
	saveAsDialogText = "<h4>New Document</h4>
	<div>
		<p>Enter a name for your new UML document:</p>
		Document Name: <input id='newFilename' type='text' value='"+globals.CommonData.filename+"'/>
	</div>
	<h4>Kickstart your project</h4>
	<div>
		<p>Choose from one of these starter projects to kick start your project.</p>
		<form id='projectTemplateForm'>
			<input type=\"radio\" name=\"projectType\" value=\"Empty\" checked>Empty Project <br>
			<input type=\"radio\" name=\"projectType\" value=\"decorator\">Decorator Pattern<br>
			<input type=\"radio\" name=\"projectType\" value=\"observer\">Observer Pattern <br>
			<input type=\"radio\" name=\"projectType\" value=\"stratagy\">Strategy Pattern
		</form>
	</div>
	<button class='btn btn-primary' onClick='window.UML.Utils.processNewDocumentForm();'>GO!</button>
	"
	window.UML.displayAjaxResponce(saveAsDialogText,"Document Name")
	return

window.UML.Utils.processNewDocumentForm = () ->
	window.UML.Utils.applyNewFilename($("#newFilename").val());
	selectedType = $('input[name=projectType]:checked', '#projectTemplateForm').val();
	if(selectedType != "Empty")
		window.UML.Utils.initWithProjectTemplate(selectedType)
	else
		$("#modelWindow").modal("hide");


window.UML.Utils.initWithProjectTemplate = (template) ->
	window.UML.displayAjaxResponce("Setting up your project, one sec...","Project Initialisation");
	window.Interface.StatusBar.setLoadingStatus("Downloading File")
	window.UML.Utils.SendPost(null, '/ProjectTemplates/Download?templateName='+template,
	(data)->
		window.UML.Utils.InitialiseModelFromJSON(data)
		window.UML.displayAjaxResponce("All Done.","Project Initialisation"));

	
window.UML.Utils.InitialiseModelFromJSON = (data) ->
	window.Interface.StatusBar.setLoadingStatus("Processing File")
	unpacker = new window.UML.Unpacker.Unpacker(new window.UML.Unpacker.NetworkUnpackStratagy());
	data = data.trim();
	extractedStatus = window.UML.ExtractStatusBit(data)
	if (extractedStatus.status)
		model = unpacker.Unpack(extractedStatus.data);
		window.Interface.StatusBar.setReadyState();
	else
		window.UML.displayAjaxResponce(extractedStatus.data, "Error");

	initialiseDocument();

window.UML.Utils.applyNewFilename = (newFileName) ->
	globals.CommonData.filename = newFileName;

window.UML.displayAjaxResponce= (data, header) ->
	modelContent = $("#modelContent");
	modelContent.html(data);

	if(typeof header != "undefined" && header != null)
		modelHeader = $("#modelHeaderContent")
		modelHeader.html("<h3>"+header+"</h3>")

	if not $('#modelWindow').hasClass('in')
		$("#modelWindow").modal("show");

	return

window.UML.SetArrowHeadFollow= (ArrowId)->
	arrow = window.UML.globals.arrows.get(ArrowId)
	if arrow != null
		arrow.arrowHead.Follow()
	else
		Debug.write("Follow Arrow Error: Invalid ArrowID: "+ ArrowID)

window.UML.SetArrowTailFollow= (ArrowId)->
	arrow = window.UML.globals.arrows.get(ArrowId)
	if arrow != null
		arrow.arrowTail.Follow()
	else
		Debug.write("Follow Arrow Error: Invalid ArrowID: "+ ArrowID)

window.UML.typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

window.UML.typeIsObject= ( value ) -> ((typeof value == "object") && (value != null) ) && not jQuery.isFunction(value)

###################################################################
# 																  #
# When converting the extraction of files to be done genericaly   #
# a problem was discovered where every object in the model tree   #
# would be converted to a modelItem. This function is a utility   #
# provided to solve that problem by converting modelItem objects  #
# to point objects												  #
#																  #
###################################################################
window.UML.ModelItemToPoint= (item)->
	if item.hasOwnProperty("modelItemID")
		return new Point(item.get("x"), item.get("y"))
	else
		return item


window.UML.ExtractStatusBit= (data)->
	status = data[0] == '1'
	ret_value = new Object()
	ret_value.status = status
	ret_value.data = data.substring(1)

	return ret_value;

