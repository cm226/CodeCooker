class window.UML.StringTree.StringTree 
	constructor:()->
		@rootNode = new window.UML.StringTree.Node()

	IsRoot:(node)-> node == @rootNode;

	Build:(string)->
		@rootNode.NewString(string,0)

	Remove:(string)->
		@rootNode.Remove(string,0)

	GetSelections:(string)->
		node = @FindRootNode(@rootNode, string)
		if(node == null)
			node = @rootNode

		return node

	FindRootNode:(node, string)->
		if string.length > 0
			child = node.children.get(string.toUpperCase().charCodeAt(0))
			if(child)
				@FindRootNode(child, string.substring(1))
			else
				return null;
		else
			return node;