window.UML.TextBoxes.IntelligentPopoutPositioning.Position = (positionElements, popoutSize, targetPosition, targetSize)->
	windowWidth = window.innerWidth;

	targetPosition_Right = targetPosition.x + targetSize.x
	if targetPosition_Right + popoutSize.x > windowWidth
		return {element : positionElements.left, position : new Point(targetPosition.x, targetPosition.y + targetSize.y/2)}
	else 
		return {element : positionElements.right, position : new Point(targetPosition.x + targetSize.x, targetPosition.y+targetSize.y/2)}

