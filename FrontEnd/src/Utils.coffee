window.UML.Utils.mousePositionFromEvent= (evt) ->
	pt = globals.document.createSVGPoint()
	pt.x = evt.clientX;
	pt.y = evt.clientY;
	point =  pt.matrixTransform(globals.document.getScreenCTM().inverse());
	return new Point(point.x, point.y)

window.UML.Utils.getScreenCoordForSVGElement= (element) ->
	matrix  = element.getScreenCTM();
	pt  = globals.document.createSVGPoint();

	pt.x = element.x.animVal.value;
	pt.y = element.y.animVal.value;
	
	screenCoords = pt.matrixTransform(matrix);
	return new Point(screenCoords.x,screenCoords.y)

window.UML.Utils.getScreenCoordForCircleSVGElement= (element) ->
	matrix  = element.getScreenCTM();
	pt  = globals.document.createSVGPoint();

	pt.x = element.getAttribute("cx");
	pt.y = element.getAttribute("cy");
	
	screenCoords = pt.matrixTransform(matrix);
	return new Point(screenCoords.x,screenCoords.y)

window.UML.Utils.getSVGCorrdforScreenPos= (point) ->
	matrix  = globals.document.getScreenCTM();
	pt  = globals.document.createSVGPoint();

	pt.x = point.x
	pt.y = point.y;
	
	svgCoords = pt.matrixTransform(matrix.inverse());
	return new Point(svgCoords.x,svgCoords.y)

window.UML.Utils.getSVGCoordForGroupedElement= (group) ->
	point = globals.document.createSVGPoint()
	# This is the top-left relative to the SVG element
	ctm = group.getCTM()
	svgCoords = point.matrixTransform(ctm)
	return new Point(svgCoords.x,svgCoords.y)

window.UML.Utils.fromSVGCoordForGroupedElement= (svgCoord, element) ->
	point = globals.document.createSVGPoint()
	
	point.x = svgCoord.x;
	point.y = svgCoord.y;

	ctm = element.getCTM()
	localCoords = point.matrixTransform(ctm.inverse())
	return new Point(localCoords.x,localCoords.y)

window.UML.Utils.ConvertFrameOfReffrence = (svgCoord, refrenceFrameFrom, refrenceFrameTo) ->
	point = globals.document.createSVGPoint()
	
	point.x = svgCoord.x;
	point.y = svgCoord.y;

	globalCoords = point.matrixTransform(refrenceFrameFrom)
	toCoords = globalCoords.matrixTransform(refrenceFrameTo.inverse())
	return new Point(toCoords.x,toCoords.y)

window.UML.Utils.CreateJSONForModel= ()->
	model = new Object()
	model["Name"] = globals.filename;
	model["Version"] = window.UML.globals.CommonData.version;
	classList = window.UML.Serialize.SerializeClasses();
	interfaceList = window.UML.Serialize.SerializeInterfaces();
	namespaceList = window.UML.Serialize.SerializeNamespaces();
	arrowList = window.UML.Serialize.SerializeArrows();

	
	model["classList"] = classList
	model["arrowList"] = arrowList
	model["interfaceList"] = interfaceList;
	model["namespaceList"] = namespaceList;
	modelText = JSON.stringify(model)
	return modelText
	


window.UML.Utils.SendPost= (data, url, onCompleatFunc)->
	$.ajax({
		  type: "POST",
		  url: url,
		  data: data,
		  success: onCompleatFunc,
		  dataType: "html"
		});
	return

window.UML.Utils.CreatePoint = (x,y) ->
	new Point(x,y)

window.UML.Utils.doSave = () ->
	window.Interface.StatusBar.setLoadingStatus("Saving")
	saveSerilzer = new window.UML.Serialize.SerializeModel(new window.UML.Serialize.NetworkSincSerlizationSelector());
	json = saveSerilzer.Serialize()
	Debug.write(json)

	window.Interface.File.uploadFile(json, '/File/UploadFile', {
			uploadComplete:()->
				window.UML.displayAjaxResponce(this.responseText,"Save");
				window.Interface.StatusBar.setNewStatus("OK","");
			uploadFailed:()-> 
				window.Interface.StatusBar.setNewStatus("Upload Failed","");
			uploadCanceled:()->
				window.Interface.StatusBar.setNewStatus("Upload Canceled","");
			uploadProgress:()->
		});


window.UML.Utils.doSaveAs = () ->
	#window.UML.Utils.displayChangeFilename( ()-> window.UML.Utils.SendPost(window.UML.Utils.CreateJSONForModel(), '/ClassDiagram/Save', window.UML.displayAjaxResponce);)

window.UML.Utils.doGenCode = (language) ->
	window.UML.displayAjaxResponce("<div style=\"width:100px;margin-left:auto; margin-right:auto;\"><object data=\"/content/img/cauldrin-large.svg\" type=\"image/svg+xml\" style=\"height:140px;width:100px\"></object></div>","Cooking...");
	Serilzer = new window.UML.Serialize.SerializeModel(new SaveModelSerilzationSelector());
	json = Serilzer.Serialize()
	window.UML.Utils.SendPost(json, '/ClassDiagram/DownloadCode?language='+language, window.UML.displayAjaxResponce);
	Debug.write(json)

window.UML.Utils.displayChangeFilename = () ->
	saveAsDialogText = "<h4>New Document</h4>
	<div>
		<p>Enter a name for your new UML document:</p>
		Document Name: <input id='newFilename' type='text' value='"+globals.CommonData.filename+"'/>
	</div>
	<h4>Kickstart your project</h4>
	<div>
		<p>Choose from one of these starter projects to kick start your project.</p>
		<form id='projectTemplateForm'>
			<input type=\"radio\" name=\"projectType\" value=\"Empty\" checked>Empty Project <br>
			<input type=\"radio\" name=\"projectType\" value=\"decorator\">Decorator Pattern<br>
			<input type=\"radio\" name=\"projectType\" value=\"observer\">Observer Pattern <br>
			<input type=\"radio\" name=\"projectType\" value=\"stratagy\">Strategy Pattern
		</form>
	</div>
	<button class='btn btn-primary' onClick='window.UML.Utils.processNewDocumentForm();'>GO!</button>
	"
	window.UML.displayAjaxResponce(saveAsDialogText,"Document Name")
	return

window.UML.Utils.processNewDocumentForm = () ->
	window.UML.Utils.applyNewFilename($("#newFilename").val());
	selectedType = $('input[name=projectType]:checked', '#projectTemplateForm').val();
	if(selectedType != "Empty")
		window.UML.Utils.initWithProjectTemplate(selectedType)
	else
		$("#modelWindow").modal("hide");


window.UML.Utils.initWithProjectTemplate = (template) ->
	window.UML.displayAjaxResponce("Setting up your project, one sec...","Project Initialisation");
	window.Interface.StatusBar.setLoadingStatus("Downloading File")
	window.UML.Utils.SendPost(null, '/ProjectTemplates/Download?templateName='+template,
	(data)->
		window.UML.Utils.InitialiseModelFromJSON(data)
		window.UML.displayAjaxResponce("All Done.","Project Initialisation"));

	
window.UML.Utils.InitialiseModelFromJSON = (data) ->
	window.Interface.StatusBar.setLoadingStatus("Processing File")
	unpacker = new window.UML.Unpacker.Unpacker(new window.UML.Unpacker.NetworkUnpackStratagy());
	data = data.trim();
	extractedStatus = window.UML.ExtractStatusBit(data)
	if (extractedStatus.status)
		model = unpacker.Unpack(extractedStatus.data);
		window.Interface.StatusBar.setReadyState();
	else
		window.UML.displayAjaxResponce(extractedStatus.data, "Error");

	initialiseDocument();

window.UML.Utils.applyNewFilename = (newFileName) ->
	globals.CommonData.filename = newFileName;

window.UML.displayAjaxResponce= (data, header) ->
	modelContent = $("#modelContent");
	modelContent.html(data);

	if(typeof header != "undefined" && header != null)
		modelHeader = $("#modelHeaderContent")
		modelHeader.html("<h3>"+header+"</h3>")

	if not $('#modelWindow').hasClass('in')
		$("#modelWindow").modal("show");

	return

window.UML.SetArrowHeadFollow= (ArrowId)->
	arrow = window.UML.globals.arrows.get(ArrowId)
	if arrow != null
		arrow.arrowHead.Follow()
	else
		Debug.write("Follow Arrow Error: Invalid ArrowID: "+ ArrowID)

window.UML.SetArrowTailFollow= (ArrowId)->
	arrow = window.UML.globals.arrows.get(ArrowId)
	if arrow != null
		arrow.arrowTail.Follow()
	else
		Debug.write("Follow Arrow Error: Invalid ArrowID: "+ ArrowID)

window.UML.typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

window.UML.typeIsObject= ( value ) -> ((typeof value == "object") && (value != null) ) && not jQuery.isFunction(value)

###################################################################
# 																  #
# When converting the extraction of files to be done genericaly   #
# a problem was discovered where every object in the model tree   #
# would be converted to a modelItem. This function is a utility   #
# provided to solve that problem by converting modelItem objects  #
# to point objects												  #
#																  #
###################################################################
window.UML.ModelItemToPoint= (item)->
	if item.hasOwnProperty("modelItemID")
		return new Point(item.get("x"), item.get("y"))
	else
		return item


window.UML.ExtractStatusBit= (data)->
	status = data[0] == '1'
	ret_value = new Object()
	ret_value.status = status
	ret_value.data = data.substring(1)

	return ret_value;

