class InheritableObject extends MoveableObject

	constructor:(@position)->
		super(@position);

		@BottomDropZone = new DropZone(0)
		@TopDropZone = new DropZone(1)
		@LeftDropZone = new DropZone(2)
		@RightDropZone = new DropZone(3)
		@DropZones = [@BottomDropZone, @TopDropZone, @LeftDropZone, @RightDropZone]
		
		@Arrows = new ClassArrows()


	Move:(To)->
		super(To);
		GlobalCoords = window.UML.Utils.getSVGCoordForGroupedElement(@graphics.box)
		@Arrows.Move(GlobalCoords, @Size.y, @Size.x)

	Del:()->
		super()
		ref = @
		for arrowList in [@Arrows.BOTTOM .. @Arrows.RIGHT]
			do (arrowList, ref)->
				for arrow in ref.Arrows.From[arrowList]
					do (arrow)->
						arrow.del();

		for arrow in globals.arrows.List
			do(arrow, ref)->
				if(arrow.arrowHead.lockedClass == ref.myID)
					arrow.arrowHead.lockedClass = -1;
					arrow.arrowHead.locked = false;

	Resize:->
		super()
		@LeftDropZone.Move(new Point(0, @Size.y/2));
		@RightDropZone.Move( new Point(@Size.x,@Size.y/2));
		@BottomDropZone.Move( new Point(@Size.x/2, @Size.y));
		@TopDropZone.Move(new Point(@Size.x/2, 0));
		GlobalCoords = window.UML.Utils.getSVGCoordForGroupedElement(@graphics.box)
		@Arrows.Move(GlobalCoords, @Size.y,@Size.x)



	CreateGraphicsObject:()->
		super()

		@LeftDropZone.position = new Point(0, @Size.y/2);
		@RightDropZone.position = new Point(@Size.x,@Size.y/2);
		@BottomDropZone.position = new Point(@Size.x/2, @Size.y);
		@TopDropZone.position = new Point(@Size.x/2, 0);

		leftdropZoneGraphics = @LeftDropZone.CreateGraphics(@myID)
		rightdropZoneGraphics = @RightDropZone.CreateGraphics(@myID)
		topdropZoneGraphics = @TopDropZone.CreateGraphics(@myID)
		bottomdropZoneGraphics = @BottomDropZone.CreateGraphics(@myID)

		@graphics.group.appendChild(bottomdropZoneGraphics.arrowDrop);
		@graphics.group.insertBefore(topdropZoneGraphics.arrowDrop,@graphics.box);
		@graphics.group.appendChild(leftdropZoneGraphics.arrowDrop);
		@graphics.group.appendChild(rightdropZoneGraphics.arrowDrop);

		@graphics.group.insertBefore(topdropZoneGraphics.hiddenDropRange,@graphics.box);
		@graphics.group.appendChild(bottomdropZoneGraphics.hiddenDropRange);
		@graphics.group.appendChild(leftdropZoneGraphics.hiddenDropRange);
		@graphics.group.appendChild(rightdropZoneGraphics.hiddenDropRange);	

	Highlight:()->
		super()
		@LeftDropZone.Show();
		@RightDropZone.Show();
		@BottomDropZone.Show();
		@TopDropZone.Show()

	Unhighlight:()->
		super()
		@LeftDropZone.Hide();
		@RightDropZone.Hide();
		@BottomDropZone.Hide();
		@TopDropZone.Hide()
