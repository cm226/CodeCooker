class RouteResolver
	constructor:()->
		@routes = new Array()


	createRoute:(routeName, value)->
		@routes[routeName] = value;

	appendRoute:(value)->
		if value of @routes
			@routes[routeName]+= value;
		else
			console.log("Unknown Route requested: "+routeName)
	resolveRoute:(routeName)->
		if routeName of @routes
			return @routes[routeName]
		else
			console.log("Unknown Route requested: "+routeName)
			return "";
