QUnit.module("Interface Model Consistancy");
 
QUnit.test("View Update Name", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)
  interfaceObj = new Interface(point, model)

  globals.LayerManager.InsertClassLayer = function(some_Random_Data){};
  
  globals.document = {}
  globals.document.createSVGPoint = function(){return {matrixTransform: function(arg){return new Point(0,0); } }}

  interfaceObj.CreateGraphicsObject(0);

  interfaceObj.name.SetText("NewModelValue");

  equal(model.get("Name"), "NewModelValue", "Name update from view Pass");
  
});

QUnit.test("Model Update Name", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)
  interfaceObj = new Interface(point, model)

  globals.LayerManager.InsertClassLayer = function(some_Random_Data){};
  
  globals.document = {}
  globals.document.createSVGPoint = function(){return {matrixTransform: function(arg){return new Point(0,0); } }}

  interfaceObj.CreateGraphicsObject(0);

  model.set("Name","NewModelValue")
  
  equal(interfaceObj.name.text, "NewModelValue", "Name update from model Pass");
  
});


QUnit.test("View Update static", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)
  interfaceObj = new Interface(point, model,
    {popover: function () { return {popover : function(){}} },
    visibility : function () { return {val : function(){}} },
    static : function () { return {is : function () { return true;}} },
    comment : function () { return {val : function () { return "NewModelValue"; } }}
    })

  globals.LayerManager.InsertClassLayer = function(some_Random_Data){};
  
  globals.document = {}
  globals.document.createSVGPoint = function(){return {matrixTransform: function(arg){return new Point(0,0); } }}


  interfaceObj.CreateGraphicsObject(0);

  interfaceObj.ClassPropertyDropDown.deactivate();
  
  equal(model.get("st"), true, "Static update from view Pass");
  
});


QUnit.test("Model Update static", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)
  interfaceObj = new Interface(point, model,
     {popover: function () { return {popover : function(){ },
                                      css : function () {},
                                    attr : function (attribute, value) {
                                        if (attribute === "data-content")
                                            dataContent = value;
                                     }
                                    }},
    visibility : function () { return {val : function(){}} },
    static : function () { return {is : function () { return true;}} },
    comment : function () { return {val : function () { return "NewModelValue"; } }}
    })

  globals.LayerManager.InsertClassLayer = function(some_Random_Data){};
  
  globals.document = {}
  globals.document.createSVGPoint = function(){return {matrixTransform: function(arg){return new Point(0,0); } }}

  interfaceObj.CreateGraphicsObject(0);

  model.set("Static",true)
  interfaceObj.ClassPropertyDropDown.onMouseUp();
  
  var popover = interfaceObj.ClassPropertyDropDown.view.popover();
  equal(dataContent.indexOf("checked") > -1, true, "static update from model Pass");
  
});


QUnit.test("View Update Comment", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)
  interfaceObj = new Interface(point, model,
    {popover: function () { return {popover : function(){}} },
    visibility : function () { return {val : function(){}} },
    static : function () { return {is : function () { return false;}} },
    comment : function () { return {val : function () { return "NewModelValue"; } }}
    })

  globals.LayerManager.InsertClassLayer = function(some_Random_Data){};
  
  globals.document = {}
  globals.document.createSVGPoint = function(){return {matrixTransform: function(arg){return new Point(0,0); } }}

  interfaceObj.CreateGraphicsObject(0);
  interfaceObj.ClassPropertyDropDown.deactivate();
  
  equal(model.get("Comment"), "NewModelValue", "Name update from model Pass");
  
});


QUnit.test("Model Update comment", function() {
  
  model = new window.UML.MODEL.Class();
  model.setNoLog("id",0)
  point = new Point(0,0)

  var dataContent;
  interfaceObj = new Interface(point, model,
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

  
  interfaceObj.CreateGraphicsObject(0);

  model.set("Comment","NewModelValue")
  interfaceObj.ClassPropertyDropDown.onMouseUp();
  
  var popover = interfaceObj.ClassPropertyDropDown.view.popover();
  equal(dataContent.indexOf("NewModelValue") > -1, true, "Comment update from model Pass");
  
});