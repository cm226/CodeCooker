class GridShiftUtill.MoveDown
	constructor:()->

	increment_cell_in_move_direction:(cell)-> cell.y += 1
	translate:(gridElement, size)->	gridElement.translate(0, size)
	direction:(girdElement)-> return girdElement.y
	translate_non_direction_value:(element, value)-> element.x += value;

class GridShiftUtill.MoveUp
	constructor:()->

	increment_cell_in_move_direction:(cell)-> cell.y -= 1
	translate:(gridElement, size)->	gridElement.translate(0, -size)
	direction:(girdElement)-> return girdElement.y
	translate_non_direction_value:(element, value)->element.x -= value;

class GridShiftUtill.MoveLeft
	constructor:()->

	increment_cell_in_move_direction:(cell)-> cell.x -= 1
	translate:(gridElement, size)->	gridElement.translate(-size,0)
	direction:(girdElement)-> return girdElement.x
	translate_non_direction_value:(element, value)->element.y -= value;

class GridShiftUtill.MoveRight
	constructor:()->

	increment_cell_in_move_direction:(cell)-> cell.x += 1
	translate:(gridElement, size)->	gridElement.translate(size,0)
	direction:(girdElement)-> return girdElement.x
	translate_non_direction_value:(element, value)->element.y += value;