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

