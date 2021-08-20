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
