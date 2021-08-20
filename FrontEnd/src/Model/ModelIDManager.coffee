class window.UML.MODEL.ModelIDManager
	constructor:(@IDRequester)->
		@workingSet = new Array()
		@overridenIDs = new Array()
		@requestOutstanding = false;

	SetIdRequester:(@IDRequester)->

	ClearValidIds:()->
		@workingSet = [];
		@IDRequester.FlushIDs();

	ClearOverrideIDs:()->
		@overridenIDs = []

	AllocateID:()->
		if @workingSet.length <= 10 && !@requestOutstanding
			@RequestMoreIds()

		if @workingSet.length <= 1
			window.CodeCooker.HighLatency.setHighLatensy();

		return @workingSet.shift()

	AllocateOverrideID:(id)->
		if(id >= 0 && @overridenIDs.indexOf(id) != -1)
			# crash and burn TODO
			Debug.write("duplicate id overide requsted for id: "+id)

		@overridenIDs.push(id)
		if @workingSet.indexOf(id) != -1
			@workingSet.splice(@workingSet.indexOf(id),1)
			
		@IDRequester.allocateOverrideID(id);

	AddToWorkingSet:(start, end)->
		Debug.write("Receved more ids")
		window.CodeCooker.HighLatency.clearHighLatensy();
		@workingSet = @workingSet.concat([start..end]);
		@requestOutstanding = false

	RequestMoreIds:()->
		Debug.write("Requesting more Ids")
		@requestOutstanding = true;
		@IDRequester.Request();