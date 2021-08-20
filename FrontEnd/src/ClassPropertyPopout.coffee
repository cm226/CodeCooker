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