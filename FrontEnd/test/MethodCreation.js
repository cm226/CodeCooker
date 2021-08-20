QUnit.module("Method Creation");

QUnit.test("Create Method", function() 
{	

  model = new window.UML.MODEL.ModelItem();
  point = new Point(0,0)
  
  model.set("Name","Method")
  model.set("Return","Int")
  model.set("Vis","+")
  model.set("Args","arg1 : Int, arg2 : Float")
  model.set("Comment","")
  model.set("Static",false)
  model.set("Abstract",false)

  methodRow = new window.MethodRow(100,point , model);
  methodRow.CreateGraphics(0);


  hasClass = $(methodRow.graphics.NameTexBox.graphics.text).hasClass("AbstractMethod");
  equal(hasClass, false, "Abstract name");

  
});
