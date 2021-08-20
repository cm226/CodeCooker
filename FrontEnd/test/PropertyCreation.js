QUnit.module("Property Creation");

QUnit.test("Create Property", function() 
{
	model = new window.UML.MODEL.ModelItem();
	model.set("Name","propName")
	model.set("Type","propType")
	model.set("Vis","+")
	model.set("Static",false)

  	point = new Point(0,0)
  	propRow = new window.PropertyRow(100,point , model);
  	propRow.CreateGraphics(0);

  	equal(propRow.graphics.TypeTextBox.graphics.text.textContent , "propType", "Model type text");
  	equal(propRow.graphics.NameTexBox.graphics.text.textContent , "propName", "Model name text");
  	equal(propRow.graphics.VisibiityDropDown.graphics.text.textContent , "+", "Model vis text");
  
});