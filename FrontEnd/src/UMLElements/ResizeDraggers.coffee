class ResizeDraggers
	constructor:(@context)->
		@onSizeChange = new Event();
		@onDragEnd = new Event();

		@Size = @context.Size;
		@BottomRightDragger = new ResizeDragger(new Point(@Size.x+5, @Size.y+5));
		@onBRResizeHandel = ((evt) ->@On_BR_dragger_resize(evt)).bind(@) 
		@BottomRightDragger.onSizeChange.add(@onBRResizeHandel)
		@BottomRightDragger.onDragEnd.add((()-> @OnDraggerDragEnd()).bind(@))

		@draggersShown = false;
		@MinSize = new Point(0,0)

	OnDraggerDragEnd:()->
		@onDragEnd.pulse();


	Resize:(@Size)->
		bottomRightResizerPos = new Point(0,0);
		if(@Size.x > @MinSize.x)
			bottomRightResizerPos.x = @Size.x
		else 
			bottomRightResizerPos.x = @MinSize.x

		if(@Size.y > @MinSize.y)
			bottomRightResizerPos.y = @Size.y
		else 
			bottomRightResizerPos.y = @MinSize.y

		@BottomRightDragger.Move(bottomRightResizerPos);

	UpdateMinimumSize:(@MinSize)->
		bottomRightResizerPos = new Point(0,0);
		if(@Size.x > @MinSize.x)
			bottomRightResizerPos.x = @Size.x
		else 
			bottomRightResizerPos.x = @MinSize.x

		if(@Size.y > @MinSize.y)
			bottomRightResizerPos.y = @Size.y
		else 
			bottomRightResizerPos.y = @MinSize.y

		@BottomRightDragger.Move(bottomRightResizerPos);
		@On_BR_dragger_resize();


	CreateGraphicsObject:()->

		BottomRightGraphics = @BottomRightDragger.CreateGraphicsObject();

		@BottomRightDragger.Rotate(180)

	showDraggers:()->
		@draggersShown = true;
		@BottomRightDragger.show(@context.graphics.group)


	hideDraggers:()->
		@draggersShown = false;
		@BottomRightDragger.hide(@context.graphics.group)

	On_BR_dragger_resize:(evt)->
		@Size.x = @MinSize.x
		@Size.y = @MinSize.y
		
		if(@BottomRightDragger.Position.x > @MinSize.x)
			@Size.x = @BottomRightDragger.Position.x 
		if(@BottomRightDragger.Position.y > @MinSize.y)
			@Size.y = @BottomRightDragger.Position.y 
			
		evt = new Object()
		evt.newSize = @Size;
		@onSizeChange.pulse(evt)

