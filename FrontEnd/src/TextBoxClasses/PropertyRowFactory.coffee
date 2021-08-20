class PropertyRowFactory
	constructor:()->

	Create:(position,width,model)->

		newproptery = new PropertyRow(width,position,model)

		return newproptery