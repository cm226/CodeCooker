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
