QUnit.module("Property Model Consistancy");
 
QUnit.test("View Update Name", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  propRow = new window.PropertyRow(100,point , model);
  propRow.CreateGraphics(0);

  propRow.graphics.NameTexBox.SetText("NewModelValue");

  equal(model.get("Name"), "NewModelValue", "Name update from view Pass");
  
});

QUnit.test("Model Update Name", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  propRow = new window.PropertyRow(100,point , model);
  propRow.CreateGraphics(0);

  model.set("Name","NewModelValue")

  equal(propRow.graphics.NameTexBox.text, "NewModelValue", "Model update Name Pass");
  
});

QUnit.test("View Update Type", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  propRow = new window.PropertyRow(100,point , model);
  propRow.CreateGraphics(0);
  
  propRow.graphics.TypeTextBox.SetText("NewModelValue");

  equal(model.get("Type"), "NewModelValue", "Type update from view Pass");
  
});

QUnit.test("Model Update Type", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  propRow = new window.PropertyRow(100,point , model);
  propRow.CreateGraphics(0);

  model.set("Type","NewModelValue")

  equal(propRow.graphics.TypeTextBox.text, "NewModelValue", "Model update Type");
  
});

QUnit.test("View Update Visibility", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  propRow = new window.PropertyRow(100,point , model);
  propRow.CreateGraphics(0);
  
  propRow.graphics.VisibiityDropDown.SetText("+");

  equal(model.get("Vis"), "+", "Visibility update from view Pass");
  
});

QUnit.test("Model Update Visibility", function() {
  
  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  propRow = new window.PropertyRow(100,point , model);
  propRow.CreateGraphics(0);

  model.set("Vis","+")

  equal(propRow.graphics.VisibiityDropDown.text, "+", "Model update Type");
  
});
