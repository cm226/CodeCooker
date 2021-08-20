window.UML.AlternateKeys = {CTRL : 17, ALT : 18}

class KeyboardListener
	constructor: ()->
		@keyCodes = new Object();
		@keyCodes.Del = 46
		@KeysWithInterests = new Array();
		@KeyDownWithInterests = new Array();
		@KeyWithAlternate = {}
		@KeyWithAlternate[window.UML.AlternateKeys.CTRL] = new Array()
		@KeyWithAlternate[window.UML.AlternateKeys.ALT] = new Array()

		@currentAlternate = null;

		window.onkeyup = ((evt) ->@onkeyup(evt)).bind(@) 
		window.onkeydown = ((evt) ->@onkeydown(evt)).bind(@) 

	isAltKey:(key)->
		for own prop, value of window.UML.AlternateKeys
			if value == key
				return true
		return false

	onkeyup: (evt)->
		key = if evt.keyCode then evt.keyCode else evt.which;
		if(key == @keyCodes.Del)
			globals.selections.selectedGroup.del()

		if @isAltKey(key)
			@currentAlternate = null

		retVal = true
		kayInterests = @KeysWithInterests[key]
		if(@KeysWithInterests[key])
			for interestedHandler in @KeysWithInterests[key]
				do(interestedHandler)->
					if(!interestedHandler(evt))
						retVal = false

		return retVal;


	onkeydown: (evt)->
		key = if evt.keyCode then evt.keyCode else evt.which;
		if(key == @keyCodes.Del)
			globals.selections.selectedGroup.del()

		isAltKey = @isAltKey(key)
		if(isAltKey)
			@currentAlternate = key
		else # handlers with aluternates take priority
			if(@currentAlternate != null && @KeyWithAlternate[@currentAlternate][key])
				for interestedHandler in @KeyWithAlternate[@currentAlternate][key]
					do(interestedHandler)->
						if(!interestedHandler(evt))
							retVal = false
				return retVal

		retVal = true
		kayInterests = @KeyDownWithInterests[key]
		if(@KeyDownWithInterests[key])
			for interestedHandler in @KeyDownWithInterests[key]
				do(interestedHandler)->
					if(interestedHandler) # check the handerl is still valid as it make have been removed by a previous handler
						if(!interestedHandler(evt))
							retVal = false

		return retVal;


	RegisterKeyInterest:(key, handler)->
		if(!@KeysWithInterests[key])
			@KeysWithInterests[key] = new Array();

		@KeysWithInterests[key].push(handler);

	UnRegisterKeyInterest:(key, handler)->
		if(@KeysWithInterests[key])
			index = @KeysWithInterests[key].indexOf(handler) 
			@KeysWithInterests[key].splice(index, 1)


	RegisterDownKeyInterest:(key, handler)->
		if(!@KeyDownWithInterests[key])
			@KeyDownWithInterests[key] = new Array();

		@KeyDownWithInterests[key].push(handler);

	UnRegisterDownKeyInterest:(key, handler)->
		if(@KeyDownWithInterests[key])
			index = @KeyDownWithInterests[key].indexOf(handler) 
			@KeyDownWithInterests[key].splice(index, 1)

	RegisterKeyWithAlthernate:(alternateKey, key, handler)->
		if(@KeyWithAlternate[alternateKey])
			if(!@KeyWithAlternate[alternateKey][key])
				@KeyWithAlternate[alternateKey][key] = new Array()

			@KeyWithAlternate[alternateKey][key].push(handler)