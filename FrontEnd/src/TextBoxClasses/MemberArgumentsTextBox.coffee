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