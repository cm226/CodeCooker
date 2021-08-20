class window.UML.StringTree.Node

	constructor:(@myChar)->
		@children = new IDIndexedList((item)-> item.myChar);
		@leafValue = null;

	NewString:(string, index)->
		if(index == string.length-1)
			@leafValue = string;
		else
			code = string.toUpperCase().charCodeAt(index)
			if(@children.get(code)==null)
				@children.add(new window.UML.StringTree.Node(code))

			@children.get(code).NewString(string,index+1);	

	Remove:(string, index)->
		if(index == string.length-1)
			@leafValue = null
		else
			code = string.toUpperCase().charCodeAt(index)
			child = @children.get(code)
			if(child !=null)
				childDeleted = child.Remove(string, index+1)
				if(childDeleted)
					@children.remove(child.myChar)

		if @children.List.length == 0
				return true
		
		return false

	ListChildren:(list)->
		if(@leafValue != null)
			list.push(@leafValue)

		for child in @children.List
			do(child)->
				child.ListChildren(list)



