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