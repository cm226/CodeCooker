class window.UML.Arrows.ArrowConnection
	constructor:(@arrow)->
		@currentConnection = null
		@connected = false


	ReconnectTo:(Class, index)->
		@Disconnect()		
		@currentConnection = globals.classes.get(Class).Arrows.To
		@currentIndex = index;
		@currentConnection.Attatch(index, @arrow)
		@connected = true;
		Debug.write("Arrow Head connected to Class: "+Class+" at index: "+index)

	ReconnectFrom:(Class, index)->
		@Disconnect()		
		@currentConnection = globals.classes.get(Class).Arrows.From
		@currentIndex = index;
		@currentConnection.Attatch(index, @arrow)
		@connected = true;
		Debug.write("Arrow Tail connected from Class: "+Class+" at index: "+index)


	Disconnect:()->
		if @connected
			@currentConnection.Detatch(@currentIndex, @arrow)
			@connected = false
			Debug.write("Arrow disconnected to at index: "+@currentIndex)