QUnit.module("Class Model Consistancy");
 
QUnit.test("View Update Name", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)
  classObj = new Class(point, model)

  globals.LayerManager.InsertClassLayer = function(some_Random_Data){};
  
  globals.document = {}
  globals.document.createSVGPoint = function(){return {matrixTransform: function(arg){return new Point(0,0); } }}

  classObj.CreateGraphicsObject(0);

  classObj.name.SetText("NewModelValue");

  equal(model.get("Name"), "NewModelValue", "Name update from view Pass");
  
});

QUnit.test("Model Update Name", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)
  classObj = new Class(point, model)

  globals.LayerManager.InsertClassLayer = function(some_Random_Data){};
  
  globals.document = {}
  globals.document.createSVGPoint = function(){return {matrixTransform: function(arg){return new Point(0,0); } }}

  classObj.CreateGraphicsObject(0);

  model.set("Name","NewModelValue")
  
  equal(classObj.name.text, "NewModelValue", "Name update from model Pass");
  
});


QUnit.test("View Update Comment", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)


  classObj = new Class(point, model,{popover: function () { return {popover : function(){}} },
    visibility : function () { return {val : function(){}} },
    static : function () { return {is : function () { return false;}} },
    comment : function () { return {val : function () { return "NewModelValue"; } }}
    })

  globals.LayerManager.InsertClassLayer = function(some_Random_Data){};
  
  globals.document = {}
  globals.document.createSVGPoint = function(){return {matrixTransform: function(arg){return new Point(0,0); } }}

  classObj.CreateGraphicsObject(0);
  classObj.ClassPropertyDropDown.deactivate();
  
  equal(model.get("Comment"), "NewModelValue", "Name update from model Pass");
  
});

QUnit.test("Model Update comment", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)

  var dataContent;
  classObj = new Class(point, model,
  	    {popover: function () { return {popover : function(){},
                                    css : function () {},
                                    attr : function (attribute, value) {
                                        if (attribute === "data-content")
                                            dataContent = value;
                                     }} },
    visibility : function () { return {val : function(){}} },
    static : function () { return {is : function () { return true;}} },
    comment : function () { return {val : function () { return "NewModelValue"; } }}
    })

  globals.LayerManager.InsertClassLayer = function(some_Random_Data){};
  
  globals.document = {}
  globals.document.createSVGPoint = function(){return {matrixTransform: function(arg){return new Point(0,0); } }}


  classObj.CreateGraphicsObject(0);

  model.set("Comment","NewModelValue")
  classObj.ClassPropertyDropDown.onMouseUp();
  
  var popover = classObj.ClassPropertyDropDown.view.popover();
  equal(dataContent.indexOf("NewModelValue") > -1, true, "Comment update from model Pass");
  
});


QUnit.test("View Update Static", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)
  classObj = new Class(point, model,
  	{popover: function () { return {popover : function(){}} },
    visibility : function () { return {val : function(){}} },
    static : function () { return {is : function () { return true;}} },
    comment : function () { return {val : function () { return "NewModelValue"; } }}
    })

  globals.LayerManager.InsertClassLayer = function(some_Random_Data){};
  
  globals.document = {}
  globals.document.createSVGPoint = function(){return {matrixTransform: function(arg){return new Point(0,0); } }}

  classObj.CreateGraphicsObject(0);
  classObj.ClassPropertyDropDown.deactivate();
  
  equal(model.get("st"), true, "Name update from model Pass");
  
});


QUnit.test("Model Update static", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)

  var dataContent;
  classObj = new Class(point, model,
  	 {popover: function () { return {popover : function(){},
                                    css : function () {},
                                    attr : function (attribute, value) {
                                        if (attribute === "data-content")
                                            dataContent = value;
                                     }} },
    visibility : function () { return {val : function(){}} },
    static : function () { return {is : function () { return true;}} },
    comment : function () { return {val : function () { return "NewModelValue"; } }}
    })

  globals.LayerManager.InsertClassLayer = function(some_Random_Data){};
  
  globals.document = {}
  globals.document.createSVGPoint = function(){return {matrixTransform: function(arg){return new Point(0,0); } }}

  

  classObj.CreateGraphicsObject(0);

  model.set("Static",true)
  classObj.ClassPropertyDropDown.onMouseUp();
  
  var popover = classObj.ClassPropertyDropDown.view.popover();
  equal(dataContent.indexOf("checked") > -1, true, "static update from model Pass");
  
});
