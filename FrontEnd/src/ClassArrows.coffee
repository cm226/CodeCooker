class ClassArrows
	constructor:() ->
		@To = new ClassArrowHead()
		@From = new ClassArrowTail()
		@position = new Point(0,0)
		return

	Move:(to, height, width)->
		half_width = width/2
		half_height = height/2
		
		@To.Move(to,height, width, half_height, half_width)
		@From.Move(to, height, width, half_height, half_width)