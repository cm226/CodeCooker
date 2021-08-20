class MethodRowFactory
	constructor:()->

	Create:(position,width, model)-> 

		methodRow = new MethodRow(width,position, model)
		
		return methodRow
