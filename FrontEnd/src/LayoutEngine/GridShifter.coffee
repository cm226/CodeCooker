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

		