class IDIndexedList
	constructor:(IDResolver) ->
		@List = new Array()
		@resolver = IDResolver

	get:(id) ->
		item = (item for item in @List when @resolver(item) == id)
		if(item.length > 0)
			return item[0]
		else
			return null
	add:(item) ->
		@List.push(item)
		return

	remove: (id)->
		item = (item for item in @List when @resolver(item) == id)
		if(item.length > 0)
			@List.splice(@List.indexOf(item[0]),1)
		else
			Debug.write("Invalid Id removed from list: "+id)

		item[0]

	contains:(item)->
		return @List.indexOf(item) != -1;

	clear:()->
		@List = [];