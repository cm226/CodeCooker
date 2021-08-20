window.UML.LayoutEngine = window.UML.LayoutEngine || {};

((namespace)->
	GridElementRegister = []
	GridElementID = 0;

	namespace.register = (gridElement)->
		GridElementRegister[GridElementID++] = gridElement;
		return gridElement;

	namespace.resolve = (gridID)->
		return GridElementRegister[gridID]


)(window.UML.LayoutEngine)
