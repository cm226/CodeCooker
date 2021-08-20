class LayoutGridElement
	constructor:(@grid, @size, @position, @content, register)->
		@elementRegisterID = register.register(@);

	translate:(x, y)->

		@grid.free(@)
		
		@position.x = x
		@position.y = y

		@grid.occupy(@)
		@content.set("Position", new Point(x,y)
