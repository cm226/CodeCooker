class Point
	@x = 0
	@y = 0
	
	constructor:(@x, @y) ->

	add:(p) ->
		new Point(@x+p.x, @y+p.y)
	sub:(p) ->
		new Point(@x-p.x, @y-p.y)


