QUnit.module("Model Serialisation");

QUnit.test("Arrow Searilisation", function() {
  
  globals.classes.List = new Array()
  var end = new Point(10,10)
  var start = new Point(10,10)
  globals.document = {}
  globals.document.appendChild = function(){}



  arrowModel = new window.UML.MODEL.Arrow()
  arrowModel.set("id",10)
  arrowModel.model.Tail.set("Position",end)
  arrowModel.model.Tail.set("LockedClass",1)
  arrowModel.model.Tail.set("LockedIndex",2)
  
  arrowModel.model.Head.set("Position",start)
  arrowModel.model.Head.set("LockedClass",3)
  arrowModel.model.Head.set("LockedIndex",4)


  saveSerilzer = new window.UML.Serialize.SerializeModel(new window.UML.Serialize.NetworkSincSerlizationSelector());
  serializedArrow = saveSerilzer.SerializeItem(arrowModel)

  equal(serializedArrow["model"]["id"],  arrowModel.get("id"),												"Arrow ID");
  equal(serializedArrow["model"]["Tail"]["model"]["LockedClass"], arrowModel.model.Tail.get("LockedClass"),			"Serialise tail class");
  equal(serializedArrow["model"]["Tail"]["model"]["LockedIndex"], arrowModel.model.Tail.get("LockedIndex"),			"Serialise tail Index");
  equal(serializedArrow["model"]["Head"]["model"]["LockedClass"], arrowModel.model.Head.get("LockedClass"),			"Serialise head Class");
  equal(serializedArrow["model"]["Head"]["model"]["LockedIndex"], arrowModel.model.Head.get("LockedIndex"),			"Serialise head Index");
  equal(serializedArrow["model"]["Head"]["model"]["Position"]["x"], arrowModel.model.Head.get("Position").x,	"Serialise head Position X");
  equal(serializedArrow["model"]["Head"]["model"]["Position"]["y"], arrowModel.model.Head.get("Position").y,	"Serialise head Possition Y");
  equal(serializedArrow["model"]["Tail"]["model"]["Position"]["x"], arrowModel.model.Tail.get("Position").x,	"Serialise tail position X");
  equal(serializedArrow["model"]["Tail"]["model"]["Position"]["y"], arrowModel.model.Tail.get("Position").y,	"Serialise Tail position Y");


});