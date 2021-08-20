class Event
	constructor:()->
		@subscribers = new Array()

	add:(func) ->
		@subscribers.push(func)
	remove:(func) ->
		index = @subscribers.indexOf(func)
		if(index != -1)
			@subscribers.splice(index,1)
	pulse:(evt) ->
		subCount = 0
		while subCount < @subscribers.length # pulsing some subscribers might remove elements from the list!
			@subscribers[subCount](evt)	
			subCount++;	

window.UML.Pulse.Initialise = new Event()