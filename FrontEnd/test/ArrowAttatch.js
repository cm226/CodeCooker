QUnit.module("Arrow Attatch");
 
QUnit.test("Arrow Attatch from index 0", function() {
  
  globals.classes.List = new Array()
  var end = new Point(10,10)
  var start = new Point(10,10)
  globals.document = {}
  globals.document.appendChild = function(){}

  var stubClass = new function(){
                                this.model = {};
                                this.model.modelItemID = 0;
                                this.Arrows = new function(){
                                                    this.From = new function()
                                                    {
                                                      this.Attatch = function(index, arrow)
                                                                    {
                                                                      this.index = index;
                                                                      this.arrow = arrow;
                                                                    };
                                                    };
                                                  };

                            };

  globals.classes.add(stubClass)


  arrowModel = new window.UML.MODEL.Arrow()
  arrowModel.model.Tail.set("Position",end)
  arrowModel.model.Head.set("Position",start)


  document.createElementNS = function(){
    
    return new function() {
            this.setAttributeNS = function(){}
            this.setAttribute = this.setAttributeNS
            this.addEventListener = this.setAttributeNS
          };

  }
  arrow = new window.UML.Arrows.Arrow(arrowModel)
  arrow.arrowTail.Connection.ReconnectFrom(0, 0)

  equal(stubClass.Arrows.From.index,0 , "index Match");
  equal(stubClass.Arrows.From.arrow,arrow , "object Match");
  
});


QUnit.test("Arrow Attatch from index 1", function() {
  
  globals.classes.List = new Array()
  var end = new Point(10,10)
  var start = new Point(10,10)
  globals.document = {}
  globals.document.appendChild = function(){}

  var stubClass = new function(){
                                this.model = {};
                                this.model.modelItemID = 0;
                                this.Arrows = new function(){
                                                    this.From = new function()
                                                    {
                                                      this.Attatch = function(index, arrow)
                                                                    {
                                                                      this.index = index;
                                                                      this.arrow = arrow;
                                                                    };
                                                    };
                                                  };

                            };

  globals.classes.add(stubClass)


  arrowModel = new window.UML.MODEL.Arrow()
  arrowModel.model.Tail.set("Position",end)
  arrowModel.model.Head.set("Position",start)


  document.createElementNS = function(){
    
    return new function() {
            this.setAttributeNS = function(){}
            this.setAttribute = this.setAttributeNS
            this.addEventListener = this.setAttributeNS
          };

  }
  arrow = new window.UML.Arrows.Arrow(arrowModel)
  arrow.arrowTail.Connection.ReconnectFrom(0, 1)

  equal(stubClass.Arrows.From.index,1 , "index Match");
  equal(stubClass.Arrows.From.arrow,arrow , "object Match");
  
});


QUnit.test("Arrow Attatch from index 2", function() {
  
  globals.classes.List = new Array()
  
  var end = new Point(10,10)
  var start = new Point(10,10)
  globals.document = {}
  globals.document.appendChild = function(){}

  var stubClass = new function(){
                                this.model = {};
                                this.model.modelItemID = 0;
                                this.Arrows = new function(){
                                                    this.From = new function()
                                                    {
                                                      this.Attatch = function(index, arrow)
                                                                    {
                                                                      this.index = index;
                                                                      this.arrow = arrow;
                                                                    };
                                                    };
                                                  };

                            };

  globals.classes.add(stubClass)


  arrowModel = new window.UML.MODEL.Arrow()
  arrowModel.model.Tail.set("Position",end)
  arrowModel.model.Head.set("Position",start)


  document.createElementNS = function(){
    
    return new function() {
            this.setAttributeNS = function(){}
            this.setAttribute = this.setAttributeNS
            this.addEventListener = this.setAttributeNS
          };

  }
  arrow = new window.UML.Arrows.Arrow(arrowModel)
  arrow.arrowTail.Connection.ReconnectFrom(0, 2)

  equal(stubClass.Arrows.From.index,2 , "index Match");
  equal(stubClass.Arrows.From.arrow,arrow , "object Match");
  
});

QUnit.test("Arrow Attatch from index 3", function() {
  
  globals.classes.List = new Array()
  var end = new Point(10,10)
  var start = new Point(10,10)
  globals.document = {}
  globals.document.appendChild = function(){}

  var stubClass = new function(){
                                this.model = {};
                                this.model.modelItemID = 0;
                                this.Arrows = new function(){
                                                    this.From = new function()
                                                    {
                                                      this.Attatch = function(index, arrow)
                                                                    {
                                                                      this.index = index;
                                                                      this.arrow = arrow;
                                                                    };
                                                    };
                                                  };

                            };

  globals.classes.add(stubClass)


  arrowModel = new window.UML.MODEL.Arrow()
  arrowModel.model.Tail.set("Position",end)
  arrowModel.model.Head.set("Position",start)


  document.createElementNS = function(){
    
    return new function() {
            this.setAttributeNS = function(){}
            this.setAttribute = this.setAttributeNS
            this.addEventListener = this.setAttributeNS
          };

  }
  arrow = new window.UML.Arrows.Arrow(arrowModel)
  arrow.arrowTail.Connection.ReconnectFrom(0, 3)

  equal(stubClass.Arrows.From.index,3 , "index Match");
  equal(stubClass.Arrows.From.arrow,arrow , "object Match");
  
});


QUnit.test("Arrow Attatch to index 0", function() {
  
  globals.classes.List = new Array()
  var end = new Point(10,10)
  var start = new Point(10,10)
  globals.document = {}
  globals.document.appendChild = function(){}

  var stubClass = new function(){
                                this.model = {};
                                this.model.modelItemID = 0;
                                this.Arrows = new function(){
                                                    this.To = new function()
                                                    {
                                                      this.Attatch = function(index, arrow)
                                                                    {
                                                                      this.index = index;
                                                                      this.arrow = arrow;
                                                                    };
                                                    };
                                                  };

                            };

  globals.classes.add(stubClass)


  arrowModel = new window.UML.MODEL.Arrow()
  arrowModel.model.Tail.set("Position",end)
  arrowModel.model.Head.set("Position",start)


  document.createElementNS = function(){
    
    return new function() {
            this.setAttributeNS = function(){}
            this.setAttribute = this.setAttributeNS
            this.addEventListener = this.setAttributeNS
          };

  }
  arrow = new window.UML.Arrows.Arrow(arrowModel)
  arrow.arrowTail.Connection.ReconnectTo(0, 0)

  equal(stubClass.Arrows.To.index,0 , "index Match");
  equal(stubClass.Arrows.To.arrow,arrow , "object Match");
  
});


QUnit.test("Arrow Attatch to index 1", function() {
  
  globals.classes.List = new Array()
  var end = new Point(10,10)
  var start = new Point(10,10)
  globals.document = {}
  globals.document.appendChild = function(){}

  var stubClass = new function(){
                                this.model = {};
                                this.model.modelItemID = 0;
                                this.Arrows = new function(){
                                                    this.To = new function()
                                                    {
                                                      this.Attatch = function(index, arrow)
                                                                    {
                                                                      this.index = index;
                                                                      this.arrow = arrow;
                                                                    };
                                                    };
                                                  };

                            };

  globals.classes.add(stubClass)


  arrowModel = new window.UML.MODEL.Arrow()
  arrowModel.model.Tail.set("Position",end)
  arrowModel.model.Head.set("Position",start)


  document.createElementNS = function(){
    
    return new function() {
            this.setAttributeNS = function(){}
            this.setAttribute = this.setAttributeNS
            this.addEventListener = this.setAttributeNS
          };

  }
  arrow = new window.UML.Arrows.Arrow(arrowModel)
  arrow.arrowTail.Connection.ReconnectTo(0, 1)

  equal(stubClass.Arrows.To.index,1 , "index Match");
  equal(stubClass.Arrows.To.arrow,arrow , "object Match");
  
});


QUnit.test("Arrow Attatch to index 2", function() {
  
  globals.classes.List = new Array()
  var end = new Point(10,10)
  var start = new Point(10,10)
  globals.document = {}
  globals.document.appendChild = function(){}

  var stubClass = new function(){
                                this.model = {};
                                this.model.modelItemID = 0;
                                this.Arrows = new function(){
                                                    this.To = new function()
                                                    {
                                                      this.Attatch = function(index, arrow)
                                                                    {
                                                                      this.index = index;
                                                                      this.arrow = arrow;
                                                                    };
                                                    };
                                                  };

                            };

  globals.classes.add(stubClass)


  arrowModel = new window.UML.MODEL.Arrow()
  arrowModel.model.Tail.set("Position",end)
  arrowModel.model.Head.set("Position",start)


  document.createElementNS = function(){
    
    return new function() {
            this.setAttributeNS = function(){}
            this.setAttribute = this.setAttributeNS
            this.addEventListener = this.setAttributeNS
          };

  }
  arrow = new window.UML.Arrows.Arrow(arrowModel)
  arrow.arrowTail.Connection.ReconnectTo(0, 2)

  equal(stubClass.Arrows.To.index,2 , "index Match");
  equal(stubClass.Arrows.To.arrow,arrow , "object Match");
  
});


QUnit.test("Arrow Attatch to index 3", function() {
  
  globals.classes.List = new Array()
  var end = new Point(10,10)
  var start = new Point(10,10)
  globals.document = {}
  globals.document.appendChild = function(){}

  var stubClass = new function(){
                                this.model = {};
                                this.model.modelItemID = 0;
                                this.Arrows = new function(){
                                                    this.To = new function()
                                                    {
                                                      this.Attatch = function(index, arrow)
                                                                    {
                                                                      this.index = index;
                                                                      this.arrow = arrow;
                                                                    };
                                                    };
                                                  };

                            };

  globals.classes.add(stubClass)


  arrowModel = new window.UML.MODEL.Arrow()
  arrowModel.model.Tail.set("Position",end)
  arrowModel.model.Head.set("Position",start)


  document.createElementNS = function(){
    
    return new function() {
            this.setAttributeNS = function(){}
            this.setAttribute = this.setAttributeNS
            this.addEventListener = this.setAttributeNS
          };

  }
  arrow = new window.UML.Arrows.Arrow(arrowModel)
  arrow.arrowTail.Connection.ReconnectTo(0, 3)

  equal(stubClass.Arrows.To.index,3 , "index Match");
  equal(stubClass.Arrows.To.arrow,arrow , "object Match");
  
});


//=============================================================================================//
//                    More than one connection
//=============================================================================================//

QUnit.test("Arrow Attatch to more than 1 index", function() {
  
  globals.classes.List = new Array()
  var end = new Point(10,10)
  var start = new Point(10,10)
  globals.document = {}
  globals.document.appendChild = function(){}

  var stubClass = new function(){
                                this.model = {};
                                this.model.modelItemID = 0;
                                this.Arrows = new function(){
                                                    this.To = new function()
                                                    {
                                                      this.Attatch = function(index, arrow)
                                                                    {
                                                                      this.index = index;
                                                                      this.arrow = arrow;
                                                                    };
                                                      this.Detatch = function(index, arrow)
                                                                    {
                                                                      this.index = index;
                                                                      this.arrow = arrow;
                                                                    };

                                                    };
                                                  };

                            };

  globals.classes.add(stubClass)


  arrowModel = new window.UML.MODEL.Arrow()
  arrowModel.model.Tail.set("Position",end)
  arrowModel.model.Head.set("Position",start)


  document.createElementNS = function(){
    
    return new function() {
            this.setAttributeNS = function(){}
            this.setAttribute = this.setAttributeNS
            this.addEventListener = this.setAttributeNS
          };

  }
  arrow = new window.UML.Arrows.Arrow(arrowModel)
  arrow.arrowTail.Connection.ReconnectTo(0, 3)
  arrow.arrowTail.Connection.ReconnectTo(0, 4)

  equal(stubClass.Arrows.To.index,4 , "index Match");
  equal(stubClass.Arrows.To.arrow,arrow , "object Match");
  
});