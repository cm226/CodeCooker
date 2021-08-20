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