class SelectedGroup
	constructor: ()->
		@selectedItems = new Array()

	add: (item)->
		@selectedItems.push(item)
	clear: ()->
		@selectedItems.length = 0
	move: ()->
		#TODO
	del: ()->
		for item in @selectedItems
			do (item)->
				if item.hasOwnProperty("model")
					item.model.del();
				else
					item.del()

		@clear()

	deactivate: ()->
		for item in @selectedItems
			do (item)->
				item.deactivate()

		@clear()
	copy: ()->
		#TODO