QUnit.module("Method Model Consistancy");
 
QUnit.test("View Update Name", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  methodRow = new window.MethodRow(100,point , model);
  methodRow.CreateGraphics(0);

  methodRow.graphics.NameTexBox.SetText("NewModelValue");

  equal(model.get("Name"), "NewModelValue", "Name update from view Pass");
  
});

QUnit.test("View Update Return", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  methodRow = new window.MethodRow(100,point , model);
  methodRow.CreateGraphics(0);

  methodRow.graphics.ReturnTextBox.SetText("NewModelValue");

  equal(model.get("Return"), "NewModelValue", "return update from model Pass");
  
});

QUnit.test("View Update Args", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  methodRow = new window.MethodRow(100,point , model);
  methodRow.CreateGraphics(0);

  methodRow.graphics.ArgumentsTextBox.SetText("NewModelValue");

  equal(model.get("Args"), "NewModelValue", "args update from model Pass");
  
});

QUnit.test("Model Update Name", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  methodRow = new window.MethodRow(100,point , model);
  methodRow.CreateGraphics(0);

  model.set("Name","NewModelValue")

  equal(methodRow.graphics.NameTexBox.text, "NewModelValue", "Args update from model Pass");
  
});

QUnit.test("Model Update Return", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  methodRow = new window.MethodRow(100,point , model);
  methodRow.CreateGraphics(0);

  model.set("Return","NewModelValue")

  equal(methodRow.graphics.ReturnTextBox.text, "NewModelValue", "Args update from model Pass");
  
});

QUnit.test("Model Update Args", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  methodRow = new window.MethodRow(100,point , model);
  methodRow.CreateGraphics(0);

  model.set("Args","NewModelValue")

  equal(methodRow.graphics.ArgumentsTextBox.text, "NewModelValue", "Args update from model Pass");
  
});
