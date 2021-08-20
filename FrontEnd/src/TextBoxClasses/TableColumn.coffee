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
