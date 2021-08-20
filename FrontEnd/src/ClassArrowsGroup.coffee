class ClassArrowsGroup
	constructor:()->
		@BOTTOM = 0
		@TOP = 1
		@LEFT = 2
		@RIGHT = 3
		@Content=  new Array(new Array(),new Array(),new Array(),new Array())

	Attatch:(index, arrow)->
		if(index >= 0 and index <= 3 and @Content[index].indexOf(arrow) == -1)
			@Content[index].push(arrow)

	Detatch:(index, arrow)->
		arrowIndex = @Content[index].indexOf(arrow)
		if(arrowIndex >= 0)
			@Content[index].splice(arrowIndex, 1);
			@content

class ClassArrowHead extends ClassArrowsGroup
	constructor:()->
		super()

	Move:(position, height, width, half_height, half_width)->
		
		for arrow in @Content[@BOTTOM]
			do (arrow)->(
				arrowHeadPosition = arrow.arrowHead.model.get("Position");
				arrowHeadPosition.x = position.x+half_width
				arrowHeadPosition.y = position.y+height
				arrow.redraw())

		for arrow in @Content[@TOP]
			do (arrow)->(
				arrowHeadPosition = arrow.arrowHead.model.get("Position");
				arrowHeadPosition.x = position.x+half_width
				arrowHeadPosition.y = position.y
				arrow.redraw())

		for arrow in @Content[@LEFT]
			do (arrow)->(
				arrowHeadPosition = arrow.arrowHead.model.get("Position");
				arrowHeadPosition.x = position.x
				arrowHeadPosition.y = position.y + half_height
				arrow.redraw()) 

		for arrow in @Content[@RIGHT]
			do (arrow)->(
				arrowHeadPosition = arrow.arrowHead.model.get("Position");
				arrowHeadPosition.x = position.x+ width
				arrowHeadPosition.y = position.y + half_height
				arrow.redraw())




class ClassArrowTail extends ClassArrowsGroup
	constructor:()->
		super()

	Move:(position, height, width, half_height, half_width)->
		for arrow in @Content[@BOTTOM]
			do (arrow)->(
				arrowTailPosition = arrow.arrowTail.model.get("Position");
				arrowTailPosition.x = position.x+half_width
				arrowTailPosition.y = position.y+height
				arrow.redraw())

		for arrow in @Content[@TOP]
			do (arrow)->(
				arrowTailPosition = arrow.arrowTail.model.get("Position");
				arrowTailPosition.x = position.x+half_width
				arrowTailPosition.y = position.y
				arrow.redraw())

		for arrow in @Content[@LEFT]
			do (arrow)->(
				arrowTailPosition = arrow.arrowTail.model.get("Position");
				arrowTailPosition.x = position.x
				arrowTailPosition.y = position.y + half_height
				arrow.redraw()) 

		for arrow in @Content[@RIGHT]
			do (arrow)->(
				arrowTailPosition = arrow.arrowTail.model.get("Position");
				arrowTailPosition.x = position.x + width
				arrowTailPosition.y = position.y + half_height
				arrow.redraw())