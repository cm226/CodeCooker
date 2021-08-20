QUnit.module("Class Creation");

QUnit.test("Create Class", function() 
{
	var classLayerMarker

	var classObjUsed
	var layerUsed
	globals.document = new function()
						{
							this.getScreenCTM = function()
							{
								return new function(){this.inverse = function(){};}
							}
							this.createSVGPoint = function()
							{
								return new function(){
											this.matrixTransform = function() 
											{
												return new Point(0,0)
											}
										}
							}
							this.getElementById = function(id)
							{
								if(id === "classLayerMarker")
									return classLayerMarker
								else 
									return null
							}

							this.insertBefore = function(classObj, layer)
							{
								classObjUsed = classObj
								layerUsed = layer
							}
						}

	var changeEvent = null;
	var changeTimes = 0;
	window.UML.globals.Model.classList.onChange.add(function(evt){
		changeEvent = evt;
		changeTimes = changeTimes+ 1;
	});

	window.UML.CreateClass();

	notEqual(changeEvent, null);
	equal(changeTimes, 1);
	equal(changeEvent.changeType, "ADD");

	
	equal(changeEvent.item.get("Comment"),"", "Class name")
	equal(changeEvent.item.get("vis"),"Public", "Class name")	

	equal(changeEvent.item.get("Properties").get("Items").list.length,1, "Class name")
	equal(changeEvent.item.get("Properties").get("Items").list[0].get("Vis"),"+", "Class name")
	equal(changeEvent.item.get("Properties").get("Items").list[0].get("Name"),"name", "Class name")
	equal(changeEvent.item.get("Properties").get("Items").list[0].get("Type"),"Int", "Class name")
	equal(changeEvent.item.get("Properties").get("Items").list[0].get("Static"),false, "Class name")

	equal(changeEvent.item.get("Methods").get("Items").list.length,1, "Class name")
	equal(changeEvent.item.get("Methods").get("Items").list[0].get("Return"),"Int", "Class name")
	equal(changeEvent.item.get("Methods").get("Items").list[0].get("Vis"),"+", "Class name")
	equal(changeEvent.item.get("Methods").get("Items").list[0].get("Args"),"arg1 : Int, arg2 : Float", "Class name")
	equal(changeEvent.item.get("Methods").get("Items").list[0].get("Comment"),"", "Class name")
	equal(changeEvent.item.get("Methods").get("Items").list[0].get("Static"),false, "Class name")
	equal(changeEvent.item.get("Methods").get("Items").list[0].get("Absract"),false, "Class name")



});