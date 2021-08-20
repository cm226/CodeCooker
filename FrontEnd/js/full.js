(function() {
  var ArrowMenu, BaseObjectSerlizer, Class, ClassArrowHead, ClassArrowTail, ClassArrows, ClassArrowsGroup, ClassMenu, ClassPropertyPopout, ClassText, ComplexObjectSerlizer, ContextMenu, Debug, DefaultRow, DefaultRowFactory, DropZone, EdiableDropDown, EdiableTextBox, EditableTextBoxTable, Event, ExpandButton, Globals, HighlightableTextBox, Highlights, IDIndexedList, InheritableObject, Interface, InterfaceMenu, KeyboardListener, LayerManager, MemberArgument, MemberArgumentsTextBox, MethodRow, MethodRowFactory, ModelItemSerilzer, ModelListSerlizer, MoveableObject, Namespace, NamespaceMenu, Namespaces, NetworkModelIdWrapperSerlizer, NetworkModelListIdWrapperSerlizer, Point, PropertyRow, PropertyRowFactory, ResizeDragger, ResizeDraggers, ReturnValueTextBox, RouteResolver, SVGButton, SaveModelSerilzationSelector, SelectedGroup, Selections, TableColumn, classCreatePos, classes, globals, leftMouse, rightMouse,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.UML = {};

  window.UML.Pulse = {};

  window.UML.Utils = {};

  window.UML.Arrows = {};

  window.UML.CollaberationSyncBuffer = {};

  window.UML.Ctrlz = {};

  window.UML.Interaction = {};

  window.UML.MODEL = {};

  window.UML.MODEL.ModelGlobalUtils = {};

  window.UML.Serialize = {};

  window.UML.StringTree = {};

  window.UML.TextBoxes = {};

  window.UML.TextBoxes.IntelligentPopoutPositioning = {};

  window.UML.Unpacker = {};

  IDIndexedList = (function() {
    function IDIndexedList(IDResolver) {
      this.List = new Array();
      this.resolver = IDResolver;
    }

    IDIndexedList.prototype.get = function(id) {
      var item;
      item = (function() {
        var _i, _len, _ref, _results;
        _ref = this.List;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (this.resolver(item) === id) {
            _results.push(item);
          }
        }
        return _results;
      }).call(this);
      if (item.length > 0) {
        return item[0];
      } else {
        return null;
      }
    };

    IDIndexedList.prototype.add = function(item) {
      this.List.push(item);
    };

    IDIndexedList.prototype.remove = function(id) {
      var item;
      item = (function() {
        var _i, _len, _ref, _results;
        _ref = this.List;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (this.resolver(item) === id) {
            _results.push(item);
          }
        }
        return _results;
      }).call(this);
      if (item.length > 0) {
        this.List.splice(this.List.indexOf(item[0]), 1);
      } else {
        Debug.write("Invalid Id removed from list: " + id);
      }
      return item[0];
    };

    IDIndexedList.prototype.contains = function(item) {
      return this.List.indexOf(item) !== -1;
    };

    IDIndexedList.prototype.clear = function() {
      return this.List = [];
    };

    return IDIndexedList;

  })();

  Point = (function() {
    Point.x = 0;

    Point.y = 0;

    function Point(x, y) {
      this.x = x;
      this.y = y;
    }

    Point.prototype.add = function(p) {
      return new Point(this.x + p.x, this.y + p.y);
    };

    Point.prototype.sub = function(p) {
      return new Point(this.x - p.x, this.y - p.y);
    };

    return Point;

  })();

  Event = (function() {
    function Event() {
      this.subscribers = new Array();
    }

    Event.prototype.add = function(func) {
      return this.subscribers.push(func);
    };

    Event.prototype.remove = function(func) {
      var index;
      index = this.subscribers.indexOf(func);
      if (index !== -1) {
        return this.subscribers.splice(index, 1);
      }
    };

    Event.prototype.pulse = function(evt) {
      var subCount, _results;
      subCount = 0;
      _results = [];
      while (subCount < this.subscribers.length) {
        this.subscribers[subCount](evt);
        _results.push(subCount++);
      }
      return _results;
    };

    return Event;

  })();

  window.UML.Pulse.Initialise = new Event();

  HighlightableTextBox = (function() {
    function HighlightableTextBox(relPosition, context) {
      this.relPosition = relPosition;
      this.context = context;
      this.passive = false;
      this.OnMouseOver = new Event();
      this.OnMouseUp = new Event();
      this.OnMouseExit = new Event();
      this.borderMarginHeight = 2;
      this.borderMarginWidth = 5;
      this.mouseUpHandle = (function(evt) {
        return this.onMouseUp(evt);
      }).bind(this);
      this.mouseOverHandle = (function(evt) {
        return this.onMouseOver(evt);
      }).bind(this);
      this.mouseOutHandle = (function(evt) {
        return this.onMouseOut(evt);
      }).bind(this);
    }

    HighlightableTextBox.prototype.SetPassive = function() {
      return this.passive = true;
    };

    HighlightableTextBox.prototype.SetActive = function() {
      return this.passive = false;
    };

    HighlightableTextBox.prototype.CreateGraphics = function(graphics) {
      graphics.border = document.createElementNS("http://www.w3.org/2000/svg", 'rect');
      graphics.border.setAttribute("stroke", "none");
      graphics.border.setAttribute("x", 1);
      graphics.border.setAttribute("y", 5);
      graphics.border.setAttribute("height", this.context.Size.y + this.borderMarginHeight);
      graphics.border.setAttribute("width", this.context.Size.x + this.borderMarginWidth);
      graphics.border.setAttribute("fill-opacity", 0);
      graphics.border.addEventListener("mouseout", this.mouseOutHandle);
      graphics.border.addEventListener("mouseover", this.mouseOverHandle);
      return graphics.border.addEventListener("mouseup", this.mouseUpHandle);
    };

    HighlightableTextBox.prototype.Resize = function() {
      this.context.graphics.border.setAttribute("height", this.context.Size.y + this.borderMarginHeight);
      return this.context.graphics.border.setAttribute("width", this.context.Size.x + this.borderMarginWidth);
    };

    HighlightableTextBox.prototype.onMouseOver = function() {
      if (!this.passive) {
        return this.context.DoHighlight();
      } else {
        return this.OnMouseOver.pulse(null);
      }
    };

    HighlightableTextBox.prototype.onMouseOut = function() {
      if (!this.passive) {
        return this.context.DoUnhighlight();
      } else {
        return this.OnMouseExit.pulse(null);
      }
    };

    HighlightableTextBox.prototype.onMouseUp = function() {
      if (!this.passive) {
        return this.context.OnSelect();
      } else {
        return this.OnMouseUp.pulse(null);
      }
    };

    HighlightableTextBox.prototype.Highlight = function() {
      return this.context.graphics.border.setAttribute("stroke", "#3385D6");
    };

    HighlightableTextBox.prototype.Unhighlight = function() {
      return this.context.graphics.border.setAttribute("stroke", "none");
    };

    return HighlightableTextBox;

  })();

  window.UML.Pulse.TextBoxSelected = new Event();

  window.UML.EditableTextBoxID = 0;

  window.UML.NextTextBoxID = function() {
    window.UML.EditableTextBoxID += 1;
    return window.UML.EditableTextBoxID;
  };

  EdiableTextBox = (function() {
    function EdiableTextBox(relPosition, text) {
      this.relPosition = relPosition;
      this.text = text;
      this.myID = window.UML.NextTextBoxID();
      globals.textBoxes.add(this);
      this.onTextChange = new Event();
      this.onSizeChange = new Event();
      this.onBecomeEmpty = new Event();
      this.onTabPressedHandler = null;
      this.currentEditBox = null;
      this.highlightBox = new HighlightableTextBox(new Point(0, 0), this);
      this.minWidth = 0;
      this.minHeight = 20;
      this.minEditBoxWidth = 30;
      this.Size = new Point(this.minWidth, this.minHeight);
      this.passive = false;
      this.selectTextOnShow = false;
    }

    EdiableTextBox.prototype.Move = function(to) {
      this.relPosition = to;
      return this.graphics.group.setAttribute("transform", "translate(" + this.relPosition.x + " " + this.relPosition.y + ")");
    };

    EdiableTextBox.prototype.CreateGraphics = function(textClass) {
      this.graphics = new Object();
      this.graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.graphics.text = document.createElementNS("http://www.w3.org/2000/svg", 'text');
      this.editBoxBlur = (function(evt) {
        return this.onEditBoxBlur(evt);
      }).bind(this);
      this.graphics.text.setAttribute("x", 5);
      this.graphics.text.setAttribute("y", 20);
      this.graphics.text.setAttribute("height", this.Size.y);
      this.graphics.text.setAttribute("width", this.Size.x);
      this.graphics.text.setAttribute("class", textClass);
      this.graphics.text.textContent = this.text;
      this.graphics.text.addEventListener("mouseover", this.highlightBox.mouseOverHandle, false);
      this.graphics.text.addEventListener("mouseup", this.highlightBox.mouseUpHandle, false);
      this.graphics.group.setAttribute("transform", "translate(" + this.relPosition.x + " " + this.relPosition.y + ")");
      this.graphics.group.setAttribute("class", "EditBox");
      this.graphics.group.addEventListener("mouseover", this.mouseOverHandle, false);
      this.highlightBox.CreateGraphics(this.graphics);
      this.graphics.group.appendChild(this.graphics.border);
      this.graphics.group.appendChild(this.graphics.text);
      return this.graphics.group;
    };

    EdiableTextBox.prototype.getGraphics = function() {
      return this.graphics;
    };

    EdiableTextBox.prototype.resize = function() {
      var newSize;
      if (this.text === "") {
        this.setDefaultSize();
      } else {
        this.recalculateSize();
      }
      newSize = new Object();
      newSize.width = this.Size.x;
      newSize.height = this.Size.y;
      this.onSizeChange.pulse(newSize);
      this.graphics.text.setAttribute("height", this.Size.y);
      this.graphics.text.setAttribute("width", this.Size.x);
      return this.highlightBox.Resize();
    };

    EdiableTextBox.prototype.setDefaultSize = function() {
      this.Size.x = this.minWidth;
      return this.Size.y = this.minHeight;
    };

    EdiableTextBox.prototype.recalculateSize = function() {
      this.Size.x = this.graphics.text.getBBox().width;
      return this.Size.y = this.graphics.text.getBBox().height;
    };

    EdiableTextBox.prototype.calculateWidth = function(newWidth) {
      var sizeToUse;
      sizeToUse = this.Size.x;
      if (newWidth > this.Size.x - 20) {
        sizeToUse = newWidth + 40;
      } else if (newWidth < this.Size.x - 50) {
        sizeToUse = newWidth + 40;
      }
      return Math.max(this.minWidth, sizeToUse);
    };

    EdiableTextBox.prototype.calculateHeight = function(newHeight) {
      return Math.max(newHeight, this.minHeight);
    };

    EdiableTextBox.prototype.onMouseOver = function() {
      if (!this.passive) {
        return window.UML.globals.highlights.HighlightTextElement(this);
      }
    };

    EdiableTextBox.prototype.onMouseOut = function() {
      if (!this.passive) {
        return window.UML.globals.highlights.UnHighlightTextElement(this);
      }
    };

    EdiableTextBox.prototype.onMouseUp = function() {
      if (!this.passive) {
        return this.showEditBox();
      }
    };

    EdiableTextBox.prototype.onEditBoxBlur = function(evt) {
      this.repopulateTextFromEditBox();
      return this.hideEditBox();
    };

    EdiableTextBox.prototype.OnSelect = function() {
      return this.showEditBox();
    };

    EdiableTextBox.prototype.SelectAllText = function() {
      return this.currentEditBox.select();
    };

    EdiableTextBox.prototype.Highlight = function() {
      return this.highlightBox.Highlight();
    };

    EdiableTextBox.prototype.Unhighlight = function() {
      return this.highlightBox.Unhighlight();
    };

    EdiableTextBox.prototype.DoHighlight = function() {
      return window.UML.globals.highlights.HighlightTextElement(this);
    };

    EdiableTextBox.prototype.DoUnhighlight = function() {
      return window.UML.globals.highlights.UnHighlightTextElement(this);
    };

    EdiableTextBox.prototype.SetText = function(text) {
      this.text = text;
      this.onTextChange.pulse({
        prevText: this.graphics.text.textContent,
        newText: this.text
      });
      this.UpdateText(this.text);
    };

    EdiableTextBox.prototype.UpdateText = function(text) {
      this.text = text;
      this.graphics.text.textContent = this.text;
      if (this.currentEditBox !== null) {
        this.currentEditBox.value = this.text;
      }
      return this.resize();
    };

    EdiableTextBox.prototype.repopulateTextFromEditBox = function() {
      var evt, prevText;
      prevText = this.text;
      if (this.currentEditBox !== null) {
        this.SetText(this.currentEditBox.value);
      }
      this.resize();
      if (this.text === "") {
        evt = new Object();
        evt.trigger = this;
        return this.onBecomeEmpty.pulse(evt);
      }
    };

    EdiableTextBox.prototype.showEditBox = function() {
      var windowCoord;
      this.currentEditBox = document.createElement("input");
      this.currentEditBox.setAttribute("type", "text");
      this.currentEditBox.setAttribute("id", "CurrentlyActiveEditBox");
      this.currentEditBox.value = this.text;
      windowCoord = window.UML.Utils.getScreenCoordForSVGElement(this.graphics.border);
      this.BindEditBoxEvents();
      this.currentEditBox.setAttribute("style", "position: fixed;height: " + this.Size.y + "px;width: " + this.SelectEditWidthSize() + "px;top: " + windowCoord.y + "px; left: " + windowCoord.x + "px;");
      this.currentEditBox.addEventListener("blur", this.editBoxBlur);
      document.getElementById('WorkArea').appendChild(this.currentEditBox);
      if (this.selectTextOnShow) {
        this.SelectAllText();
      }
      this.currentEditBox.focus();
      return window.UML.Pulse.TextBoxSelected.pulse(null);
    };

    EdiableTextBox.prototype.BindEditBoxEvents = function() {
      if (this.onTabPressedHandler !== null) {
        return globals.KeyboardListener.RegisterDownKeyInterest(9, this.onTabPressedHandler);
      }
    };

    EdiableTextBox.prototype.UnBindEditBoxEvents = function() {
      if (this.onTabPressedHandler !== null) {
        return globals.KeyboardListener.UnRegisterDownKeyInterest(9, this.onTabPressedHandler);
      }
    };

    EdiableTextBox.prototype.SelectEditWidthSize = function() {
      if (this.Size.x < this.minEditBoxWidth) {
        return this.minEditBoxWidth;
      }
      return this.Size.x;
    };

    EdiableTextBox.prototype.hideEditBox = function() {
      this.currentEditBox.removeEventListener("blur", this.editBoxBlur);
      this.UnBindEditBoxEvents();
      document.getElementById('WorkArea').removeChild(this.currentEditBox);
      return this.currentEditBox = null;
    };

    return EdiableTextBox;

  })();

  window.UML.TextBoxes.IntelligentPopoutPositioning.Position = function(positionElements, popoutSize, targetPosition, targetSize) {
    var targetPosition_Right, windowWidth;
    windowWidth = window.innerWidth;
    targetPosition_Right = targetPosition.x + targetSize.x;
    if (targetPosition_Right + popoutSize.x > windowWidth) {
      return {
        element: positionElements.left,
        position: new Point(targetPosition.x, targetPosition.y + targetSize.y / 2)
      };
    } else {
      return {
        element: positionElements.right,
        position: new Point(targetPosition.x + targetSize.x, targetPosition.y + targetSize.y / 2)
      };
    }
  };

  DefaultRow = (function() {
    function DefaultRow(width, position) {
      this.position = position;
      this.Size = new Point(width, 20);
      this.onSizeChange = new Event();
      this.highlightBox = new HighlightableTextBox(new Point(0, 0), this);
      this.routeResolver = void 0;
    }

    DefaultRow.prototype.CreateGraphics = function(RowNumber) {
      this.RowNumber = RowNumber;
      this.graphics = new Object();
      return this.graphics;
    };

    DefaultRow.prototype.Move = function(position) {
      this.position = position;
      return this.graphics.group.setAttribute("transform", "translate(" + this.position.x + " " + this.position.y + ")");
    };

    DefaultRow.prototype.Highlight = function() {
      return this.highlightBox.Highlight();
    };

    DefaultRow.prototype.Unhighlight = function() {
      return this.highlightBox.Unhighlight();
    };

    DefaultRow.prototype.DoHighlight = function() {
      return window.UML.globals.highlights.HighlightTextElement(this);
    };

    DefaultRow.prototype.DoUnhighlight = function() {
      return window.UML.globals.highlights.UnHighlightTextElement(this);
    };

    DefaultRow.prototype.Resize = function() {
      return this.highlightBox.Resize();
    };

    DefaultRow.prototype.OnTextElemetChangeSizeHandler = function(evt) {
      this.ReCalculateSize();
      this.highlightBox.Resize();
      evt = new Object();
      evt.width = this.Size.x;
      return this.onSizeChange.pulse(evt);
    };

    return DefaultRow;

  })();

  DefaultRowFactory = (function() {
    function DefaultRowFactory() {}

    DefaultRowFactory.prototype.Create = function(position, width) {
      return new DefaultRow(width, position);
    };

    return DefaultRowFactory;

  })();

  window.UML.Pulse.TextBoxSelected = new Event();

  EdiableDropDown = (function(_super) {
    __extends(EdiableDropDown, _super);

    function EdiableDropDown(relPosition, text, choices) {
      this.relPosition = relPosition;
      this.text = text;
      this.choices = choices;
      EdiableDropDown.__super__.constructor.call(this, this.relPosition, this.text);
    }

    EdiableDropDown.prototype.repopulateTextFromEditBox = function() {
      var evt;
      this.SetText(this.currentDropdown.value);
      this.resize();
      if (this.text === "") {
        evt = new Object();
        evt.trigger = this;
        return this.onBecomeEmpty.pulse(evt);
      }
    };

    EdiableDropDown.prototype.showEditBox = function() {
      var choice, currentDropdown, dropdwnHeight, dropdwnWidth, windowCoord, _fn, _i, _len, _ref;
      this.currentDropdown = document.createElement("select");
      currentDropdown = this.currentDropdown;
      _ref = this.choices;
      _fn = function(choice, currentDropdown) {
        var option;
        option = document.createElement("option");
        option.setAttribute("value", choice);
        option.text = choice;
        return currentDropdown.appendChild(option);
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        choice = _ref[_i];
        _fn(choice, currentDropdown);
      }
      this.BindEditBoxEvents();
      windowCoord = window.UML.Utils.getScreenCoordForSVGElement(this.graphics.border);
      dropdwnWidth = this.Size.x + 50;
      dropdwnHeight = this.Size.y + 10;
      this.currentDropdown.setAttribute("style", "position: fixed;height: " + dropdwnHeight + "px;width: " + dropdwnWidth + "px;top: " + windowCoord.y + "px; left: " + windowCoord.x + "px;");
      this.currentDropdown.addEventListener("blur", this.editBoxBlur);
      document.getElementById('WorkArea').appendChild(this.currentDropdown);
      this.currentDropdown.focus();
      return window.UML.Pulse.TextBoxSelected.pulse(null);
    };

    EdiableDropDown.prototype.hideEditBox = function() {
      this.UnBindEditBoxEvents();
      this.currentDropdown.removeEventListener("blur", this.editBoxBlur);
      return document.getElementById('WorkArea').removeChild(this.currentDropdown);
    };

    return EdiableDropDown;

  })(EdiableTextBox);

  EditableTextBoxTable = (function() {
    function EditableTextBoxTable(position, model) {
      this.position = position;
      this.model = model;
      this.NextRowID = 0;
      this.height = 0;
      this.width = 50;
      this.onSizeChange = new Event();
      this.onChildSizeChangeHandle = (function(evt) {
        return this.onChildResize(evt);
      }).bind(this);
      this.rows = new IDIndexedList(function(RowItem) {
        return RowItem.RowNumber;
      });
      this.rowFactory = new DefaultRowFactory();
      this.routeResolver = new RouteResolver();
      this.expanded = true;
      this.model.onChange.add(this.onModelChange.bind(this));
      this.model.get("Items").onChange.add(this.onModelListChange.bind(this));
    }

    EditableTextBoxTable.prototype.Move = function(position) {
      this.position = position;
      return this.graphics.group.setAttribute("transform", "translate(" + this.position.x + " " + this.position.y + ")");
    };

    EditableTextBoxTable.prototype.onChildResize = function(evt) {
      this.UpdateWidth(evt.width);
      return this.onSizeChange.pulse(null);
    };

    EditableTextBoxTable.prototype.UpdateWidth = function(newWidth) {
      var maxWidth, row, _fn, _i, _len, _ref;
      if (this.width < newWidth) {
        return this.width = newWidth;
      } else {
        maxWidth = new Object();
        maxWidth.value = 0;
        _ref = this.rows.List;
        _fn = function(row, maxWidth) {
          if (row.Size.x > maxWidth.value) {
            return maxWidth.value = row.Size.x;
          }
        };
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          row = _ref[_i];
          _fn(row, maxWidth);
        }
        return this.width = maxWidth.value;
      }
    };

    EditableTextBoxTable.prototype.CreateGraphics = function() {
      this.graphics = new Object();
      this.graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.graphics.group.setAttribute("transform", "translate(" + this.position.x + " " + this.position.y + ")");
      return this.graphics.group;
    };

    EditableTextBoxTable.prototype.InitView = function() {
      var model, _i, _len, _ref, _results;
      _ref = this.model.get("Items").list;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        model = _ref[_i];
        _results.push(this.addRow(model));
      }
      return _results;
    };

    EditableTextBoxTable.prototype.addRow = function(model) {
      var newRow, row, yPos;
      this.model.set("expanded", true);
      yPos = this.height - 20;
      row = this.rowFactory.Create(new Point(0, yPos), this.width, model);
      row.onSizeChange.add(this.onChildSizeChangeHandle);
      row.routeResolver = new RouteResolver();
      row.routeResolver.routes = this.routeResolver.routes;
      row.routeResolver.createRoute("Row", row.routeResolver.resolveRoute("Table") + ".rows.get(" + this.NextRowID + ")");
      this.rows.add(row);
      newRow = row.CreateGraphics(this.NextRowID);
      this.graphics.group.appendChild(newRow.group);
      row.Resize();
      this.UpdateWidth(row.Size.x);
      this.NextRowID += 1;
      this.onSizeChange.pulse(null);
      return row;
    };

    EditableTextBoxTable.prototype.deleteRow = function(rowModel) {
      var row, rowit, ypos, _fn, _i, _j, _len, _len1, _ref, _ref1;
      row = null;
      _ref = this.rows.List;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        rowit = _ref[_i];
        if (rowit.model === rowModel) {
          row = rowit;
          break;
        }
      }
      if (row === null) {
        return;
      }
      row = this.rows.remove(row.RowNumber);
      row.deactivate();
      row.onDelete();
      this.graphics.group.removeChild(row.graphics.group);
      ypos = new Point(0, 0);
      _ref1 = this.rows.List;
      _fn = function(row, ypos) {
        ypos.x = row.position.x;
        row.Move(new Point(ypos.x, ypos.y));
        return ypos.y += 20;
      };
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        row = _ref1[_j];
        _fn(row, ypos);
      }
      return this.onSizeChange.pulse(null);
    };

    EditableTextBoxTable.prototype.Resize = function() {
      var row, _i, _len, _ref, _results;
      if (!this.expanded) {
        this.height = 5;
        return;
      }
      this.height = (this.rows.List.length * 20) + 20;
      _ref = this.rows;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        row = _ref[_i];
        _results.push(row.Resize());
      }
      return _results;
    };

    EditableTextBoxTable.prototype.Collapse = function() {
      var row, _i, _len, _ref;
      if (this.expanded) {
        this.expanded = false;
        _ref = this.rows.List;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          row = _ref[_i];
          this.graphics.group.removeChild(row.graphics.group);
        }
        return this.onSizeChange.pulse(null);
      }
    };

    EditableTextBoxTable.prototype.Expand = function() {
      var row, _i, _len, _ref;
      if (!this.expanded) {
        this.expanded = true;
        _ref = this.rows.List;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          row = _ref[_i];
          this.graphics.group.appendChild(row.graphics.group);
        }
        return this.onSizeChange.pulse(null);
      }
    };

    EditableTextBoxTable.prototype.onModelListChange = function(evt) {
      if (evt.changeType === "ADD") {
        return this.addRow(evt.item);
      } else if (evt.changeType === "DEL") {
        return this.deleteRow(evt.item);
      }
    };

    EditableTextBoxTable.prototype.onModelChange = function(evt) {
      if (evt.name === "expanded") {
        if (evt.new_value) {
          return this.Expand();
        } else {
          return this.Collapse();
        }
      }
    };

    return EditableTextBoxTable;

  })();

  ExpandButton = (function() {
    function ExpandButton(context, posX, posY, model) {
      this.context = context;
      this.posX = posX;
      this.posY = posY;
      this.model = model;
      this.model.onChange.add(this.OnModelChange.bind(this));
    }

    ExpandButton.prototype.CreateGraphics = function() {
      this.graphics = new Object();
      this.graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.graphics.Symbol = document.createElementNS("http://www.w3.org/2000/svg", 'text');
      this.graphics.group.setAttribute("transform", "translate(" + this.posX + "," + this.posY + ")");
      this.graphics.group.setAttribute("class", "expandButton");
      this.graphics.group.addEventListener("mouseup", this.onClick.bind(this));
      this.graphics.Symbol.setAttribute("x", 6);
      this.graphics.Symbol.setAttribute("y", 6);
      this.graphics.Symbol.setAttribute("height", 12);
      this.graphics.Symbol.setAttribute("width", 12);
      this.graphics.Symbol.setAttribute("class", "ClassSectionHeader");
      if (this.model.get("extanded")) {
        this.SetExpanded();
      } else {
        this.SetCollapsed();
      }
      this.graphics.group.appendChild(this.graphics.Symbol);
      return this.graphics.group;
    };

    ExpandButton.prototype.onClick = function() {
      if (this.model.get("expanded")) {
        return this.model.set("expanded", false);
      } else {
        return this.model.set("expanded", true);
      }
    };

    ExpandButton.prototype.SetExpanded = function() {
      return this.graphics.Symbol.textContent = "[+]";
    };

    ExpandButton.prototype.SetCollapsed = function() {
      return this.graphics.Symbol.textContent = "[-]";
    };

    ExpandButton.prototype.MoveDown = function(posY) {
      this.posY = posY;
      if (this.graphics) {
        return this.graphics.group.setAttribute("transform", "translate(" + this.posX + "," + this.posY + ")");
      }
    };

    ExpandButton.prototype.OnModelChange = function(evt) {
      if (evt.name === "expanded") {
        if (evt.new_value) {
          return this.SetExpanded();
        } else {
          return this.SetCollapsed();
        }
      }
    };

    return ExpandButton;

  })();

  MemberArgument = (function() {
    function MemberArgument() {
      this.importantKeyHndl = this.onImportantKey.bind(this);
      this.nameComplete = false;
      this.TypeSugestionBox = new window.UML.TextBoxes.TypeSugestionBox();
      this.TypeSugestionBox.onTypeSugestionMade.add(this.TypeSugestionClicked.bind(this));
      this.KeyPressHandl = (function(evt) {
        return this.UpdateTypeSugestionBox(evt);
      }).bind(this);
      this.tabPressHandl = (function(evt) {
        return this.onTabPress(evt);
      }).bind(this);
    }

    MemberArgument.prototype.activate = function(textElemenet, refeshTxtBox) {
      this.textElemenet = textElemenet;
      this.refeshTxtBox = refeshTxtBox;
      window.UML.globals.KeyboardListener.RegisterKeyInterest(' '.charCodeAt(0), this.importantKeyHndl);
      window.UML.globals.KeyboardListener.RegisterKeyInterest(','.charCodeAt(0), this.importantKeyHndl);
      window.UML.globals.KeyboardListener.RegisterDownKeyInterest('\t'.charCodeAt(0), this.tabPressHandl);
      window.UML.globals.KeyboardListener.RegisterDownKeyInterest(13, this.tabPressHandl);
      return this.textElemenet.keyup(this.KeyPressHandl);
    };

    MemberArgument.prototype.deactivate = function() {
      window.UML.globals.KeyboardListener.UnRegisterKeyInterest(' '.charCodeAt(0), this.importantKeyHndl);
      window.UML.globals.KeyboardListener.UnRegisterKeyInterest(','.charCodeAt(0), this.importantKeyHndl);
      window.UML.globals.KeyboardListener.UnRegisterDownKeyInterest('\t'.charCodeAt(0), this.tabPressHandl);
      window.UML.globals.KeyboardListener.UnRegisterDownKeyInterest(13, this.tabPressHandl);
      this.textElemenet.unbind("keyup", this.KeyPressHandl);
      return this.TypeSugestionBox.Hide();
    };

    MemberArgument.prototype.onImportantKey = function() {
      this.parse(this.ExtractCurrentArgString());
      if (this.nameComplete) {
        return this.ComepleteType();
      } else {
        return this.CompleteName();
      }
    };

    MemberArgument.prototype.removeLastChar = function(str) {
      var lastChar;
      lastChar = str[str.length - 1];
      if (lastChar === " " || lastChar === ",") {
        str = str.substring(0, str.length - 1);
      }
      return str;
    };

    MemberArgument.prototype.CheckForValidName = function() {
      var argString;
      argString = this.ExtractCurrentArgString();
      argString = argString.trim();
      return argString.length > 0;
    };

    MemberArgument.prototype.CompleteName = function() {
      var cursorPos, point, textAfterCursor, textboxText, trimedText;
      if (!this.CheckForValidName()) {
        return;
      }
      textboxText = this.textElemenet.val();
      cursorPos = this.textElemenet[0].selectionStart;
      if (cursorPos === 0) {
        cursorPos = textboxText.length;
      }
      textAfterCursor = textboxText.substring(cursorPos);
      trimedText = this.removeLastChar(textboxText.substring(0, cursorPos));
      trimedText = trimedText + " : ";
      this.textElemenet.val(trimedText + textAfterCursor);
      cursorPos = trimedText.length;
      this.refeshTxtBox();
      this.textElemenet[0].setSelectionRange(cursorPos, cursorPos);
      this.UpdateTypeSugestionBox({
        keyCode: 48
      });
      point = new Point(this.textElemenet.css("left"), parseInt(this.textElemenet.css("top")) + parseInt(this.textElemenet.css("height")) + 5);
      return this.TypeSugestionBox.Show(point);
    };

    MemberArgument.prototype.UpdateTypeSugestionBox = function(evt) {
      var key;
      key = evt.keyCode ? evt.keyCode : evt.which;
      if (key >= 48 || key === 8) {
        this.parse(this.ExtractCurrentArgString());
        if (this.TypeString !== null && this.nameComplete) {
          return this.TypeSugestionBox.UpdateStringPartial(this.TypeString);
        }
      }
    };

    MemberArgument.prototype.ComepleteType = function() {
      var cursorPos, postTypeText, textboxText;
      cursorPos = this.GetCursorPosition();
      textboxText = this.textElemenet.val();
      postTypeText = textboxText.substring(cursorPos);
      textboxText = this.removeLastChar(textboxText.substring(0, cursorPos));
      textboxText += ", ";
      this.textElemenet.val(textboxText + postTypeText);
      this.refeshTxtBox();
      return this.TypeSugestionBox.Hide();
    };

    MemberArgument.prototype.ExtractCurrentArgString = function() {
      var currentArgEnd, currentArgStart, element, textVal;
      element = this.textElemenet[0];
      textVal = this.textElemenet.val();
      currentArgStart = textVal.lastIndexOf(',', element.selectionStart);
      if (currentArgStart < 0) {
        currentArgStart = 0;
      } else {
        currentArgStart++;
      }
      currentArgEnd = textVal.indexOf(',', element.selectionStart);
      if (currentArgEnd < 0) {
        currentArgEnd = textVal.length;
      }
      return textVal.substring(currentArgStart, currentArgEnd);
    };

    MemberArgument.prototype.parse = function(argsString) {
      this.nameComplete = argsString.indexOf(':') !== -1;
      if (this.nameComplete) {
        return this.TypeString = argsString.substring(argsString.indexOf(':') + 1).trim();
      } else {
        return this.TypeString = "";
      }
    };

    MemberArgument.prototype.onTabPress = function(evt) {
      var selectedText;
      if (this.TypeSugestionBox.displayed) {
        selectedText = this.TypeSugestionBox.GetSelectedText();
        this.SetCurrentType(selectedText);
      }
      return false;
    };

    MemberArgument.prototype.TypeSugestionClicked = function(evt) {
      if (this.TypeSugestionBox.displayed) {
        return this.SetCurrentType(evt.selection[0].innerHTML);
      }
    };

    MemberArgument.prototype.SetCurrentType = function(typeString) {
      var element, postType, preType, textVal, typeStartIndex, typeStopIndex;
      element = this.textElemenet[0];
      textVal = this.textElemenet.val();
      typeStartIndex = this.textElemenet.val().substring(0, this.GetCursorPosition()).lastIndexOf(' ') + 1;
      preType = textVal.substring(0, typeStartIndex);
      typeStopIndex = textVal.indexOf(',', typeStartIndex);
      if (typeStopIndex === -1) {
        typeStopIndex = textVal.length;
      }
      postType = textVal.substring(typeStopIndex).trim();
      this.textElemenet.val(preType + typeString + postType);
      this.refeshTxtBox();
    };

    MemberArgument.prototype.GetCursorPosition = function() {
      var element;
      element = this.textElemenet[0];
      if (element.selectionStart === 0) {
        return this.textElemenet.val().length;
      } else {
        return element.selectionStart;
      }
    };

    return MemberArgument;

  })();

  MemberArgumentsTextBox = (function(_super) {
    __extends(MemberArgumentsTextBox, _super);

    function MemberArgumentsTextBox(relPos, text) {
      MemberArgumentsTextBox.__super__.constructor.call(this, relPos, text);
      this["arguments"] = new Array();
      this.currentMemberArg = new MemberArgument();
      this["arguments"].push(this.currentMemberArg);
    }

    MemberArgumentsTextBox.prototype.CreateGraphics = function(textClass) {
      var xpos, ypos;
      MemberArgumentsTextBox.__super__.CreateGraphics.call(this, textClass);
      this.MemberGraphics = new Object();
      this.MemberGraphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.MemberGraphics.text1 = document.createElementNS("http://www.w3.org/2000/svg", 'text');
      this.MemberGraphics.text2 = document.createElementNS("http://www.w3.org/2000/svg", 'text');
      this.MemberGraphics.text1.setAttribute("class", textClass);
      this.MemberGraphics.text2.setAttribute("class", textClass);
      this.MemberGraphics.text1.textContent = "(";
      this.MemberGraphics.text2.textContent = ")";
      ypos = this.relPosition.y + 20;
      xpos = this.relPosition.x + this.Size.x;
      this.MemberGraphics.text1.setAttribute("transform", "translate(" + this.relPosition.x + " " + ypos + ")");
      this.MemberGraphics.text2.setAttribute("transform", "translate(" + xpos + " " + ypos + ")");
      this.MemberGraphics.group.appendChild(this.MemberGraphics.text1);
      this.MemberGraphics.group.appendChild(this.graphics.group);
      this.MemberGraphics.group.appendChild(this.MemberGraphics.text2);
      return this.MemberGraphics.group;
    };

    MemberArgumentsTextBox.prototype.getGraphics = function() {
      return this.MemberGraphics;
    };

    MemberArgumentsTextBox.prototype.resize = function() {
      var xpos, ypos;
      MemberArgumentsTextBox.__super__.resize.call(this);
      ypos = this.relPosition.y + 20;
      xpos = this.relPosition.x + this.Size.x + 5;
      this.MemberGraphics.text1.setAttribute("transform", "translate(" + this.relPosition.x + " " + ypos + ")");
      return this.MemberGraphics.text2.setAttribute("transform", "translate(" + xpos + " " + ypos + ")");
    };

    MemberArgumentsTextBox.prototype.Move = function(position) {
      this.position = position;
      this.relPosition = this.position;
      return this.graphics.group.setAttribute("transform", "translate(" + this.position.x + " " + this.position.y + ")");
    };

    MemberArgumentsTextBox.prototype.showEditBox = function() {
      MemberArgumentsTextBox.__super__.showEditBox.call(this);
      return this.currentMemberArg.activate($("#CurrentlyActiveEditBox"), this.RefreshArgBox.bind(this));
    };

    MemberArgumentsTextBox.prototype.hideEditBox = function() {
      MemberArgumentsTextBox.__super__.hideEditBox.call(this);
      return this.currentMemberArg.deactivate();
    };

    MemberArgumentsTextBox.prototype.RefreshArgBox = function() {
      var cursorIndex, element;
      element = $("#CurrentlyActiveEditBox")[0];
      cursorIndex = element.selectionStart;
      this.onEditBoxBlur();
      this.showEditBox();
      element = $("#CurrentlyActiveEditBox")[0];
      element.focus();
      return element.setSelectionRange(cursorIndex, cursorIndex);
    };

    return MemberArgumentsTextBox;

  })(EdiableTextBox);

  MethodRow = (function(_super) {
    __extends(MethodRow, _super);

    function MethodRow(width, position, model) {
      this.position = position;
      this.model = model;
      MethodRow.__super__.constructor.call(this, width, this.position);
      this.OnVisibilitySizeChange = (function(evt) {
        return this.OnVisibilityChangeSizeHandler(evt);
      }).bind(this);
      this.OnArgumentsSizeChange = (function(evt) {
        return this.OnArgumentsChangeSizeHandler(evt);
      }).bind(this);
      this.OnNameTxtBxSizeChange = (function(evt) {
        return this.OnNameChangeSizeHandler(evt);
      }).bind(this);
      this.OnReturnTxtBxSizeChange = (function(evt) {
        return this.OnReturnChangeSizeHandler(evt);
      }).bind(this);
      this.OnNameChange = (function(evt) {
        return this.OnNameChangeHandler(evt);
      }).bind(this);
      this.OnReturnChange = (function(evt) {
        return this.OnReturnChangeHandler(evt);
      }).bind(this);
      this.OnArgsChange = (function(evt) {
        return this.OnArgsChangeHandler(evt);
      }).bind(this);
      this.OnVisChange = (function(evt) {
        return this.OnVisChangeHandler(evt);
      }).bind(this);
      this.model.onChange.add((function(evt) {
        return this.OnModelChange(evt);
      }).bind(this));
      this.popoutDisplayed = false;
    }

    MethodRow.prototype.CreateGraphics = function(RowNumber) {
      this.RowNumber = RowNumber;
      this.graphics = new Object();
      this.graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.graphics.VisibiityDropDown = new EdiableDropDown(new Point(0, 0), this.model.get("Vis"), ["+", "-", "#"]);
      this.graphics.VisibiityDropDown.onTabPressedHandler = (function(evt) {
        this.graphics.VisibiityDropDown.onEditBoxBlur();
        this.graphics.NameTexBox.OnSelect();
        return false;
      }).bind(this);
      this.graphics.NameTexBox = new EdiableTextBox(new Point(30, 0), this.model.get("Name"));
      this.graphics.NameTexBox.onTabPressedHandler = (function(evt) {
        this.graphics.NameTexBox.onEditBoxBlur();
        this.graphics.ArgumentsTextBox.OnSelect();
        return false;
      }).bind(this);
      this.graphics.NameTexBox.selectTextOnShow = true;
      this.graphics.ArgumentsTextBox = new MemberArgumentsTextBox(new Point(30, 0), this.model.get("Args"));
      this.graphics.ArgumentsTextBox.onTabPressedHandler = (function(evt) {
        if (!this.graphics.ArgumentsTextBox.currentMemberArg.TypeSugestionBox.displayed) {
          this.graphics.ArgumentsTextBox.onEditBoxBlur();
          this.graphics.ReturnTextBox.OnSelect();
          return false;
        }
      }).bind(this);
      this.graphics.ReturnTextBox = new ReturnValueTextBox(new Point(30, 0), this.model.get("Return"));
      this.graphics.ReturnTextBox.selectTextOnShow = true;
      this.graphics.ReturnTextBox.onTabPressedHandler = (function(evt) {
        this.graphics.ReturnTextBox.onTabPress();
        this.graphics.ReturnTextBox.onEditBoxBlur();
        this.graphics.VisibiityDropDown.OnSelect();
        return false;
      }).bind(this);
      this.graphics.NameTexBox.onTextChange.add(this.OnNameChange);
      this.graphics.ReturnTextBox.onTextChange.add(this.OnReturnChange);
      this.graphics.ArgumentsTextBox.onTextChange.add(this.OnArgsChange);
      this.graphics.VisibiityDropDown.onTextChange.add(this.OnVisChange);
      this.graphics.VisibiityDropDown.highlightBox.passive = true;
      this.graphics.ReturnTextBox.highlightBox.passive = true;
      this.graphics.ArgumentsTextBox.highlightBox.passive = true;
      this.graphics.NameTexBox.highlightBox.passive = true;
      this.graphics.VisibiityDropDown.highlightBox.OnMouseOver.add(this.highlightBox.mouseOverHandle);
      this.graphics.VisibiityDropDown.highlightBox.OnMouseUp.add(this.highlightBox.mouseUpHandle);
      this.graphics.VisibiityDropDown.highlightBox.OnMouseExit.add(this.highlightBox.mouseOutHandle);
      this.graphics.ReturnTextBox.highlightBox.OnMouseOver.add(this.highlightBox.mouseOverHandle);
      this.graphics.ReturnTextBox.highlightBox.OnMouseUp.add(this.highlightBox.mouseUpHandle);
      this.graphics.ReturnTextBox.highlightBox.OnMouseExit.add(this.highlightBox.mouseOutHandle);
      this.graphics.ArgumentsTextBox.highlightBox.OnMouseOver.add(this.highlightBox.mouseOverHandle);
      this.graphics.ArgumentsTextBox.highlightBox.OnMouseUp.add(this.highlightBox.mouseUpHandle);
      this.graphics.ArgumentsTextBox.highlightBox.OnMouseExit.add(this.highlightBox.mouseOutHandle);
      this.graphics.NameTexBox.highlightBox.OnMouseOver.add(this.highlightBox.mouseOverHandle);
      this.graphics.NameTexBox.highlightBox.OnMouseUp.add(this.highlightBox.mouseUpHandle);
      this.graphics.NameTexBox.highlightBox.OnMouseExit.add(this.highlightBox.mouseOutHandle);
      this.graphics.VisibiityDropDown.onSizeChange.add(this.OnVisibilitySizeChange);
      this.graphics.ArgumentsTextBox.onSizeChange.add(this.OnArgumentsSizeChange);
      this.graphics.NameTexBox.onSizeChange.add(this.OnNameTxtBxSizeChange);
      this.graphics.ReturnTextBox.onSizeChange.add(this.OnReturnTxtBxSizeChange);
      this.highlightBox.CreateGraphics(this.graphics);
      this.graphics.group.appendChild(this.graphics.border);
      this.graphics.group.appendChild(this.graphics.VisibiityDropDown.CreateGraphics("TextElement"));
      this.graphics.group.appendChild(this.graphics.ArgumentsTextBox.CreateGraphics("TextElement"));
      this.graphics.group.appendChild(this.graphics.NameTexBox.CreateGraphics("TextElement"));
      this.graphics.group.appendChild(this.graphics.ReturnTextBox.CreateGraphics("TextElement"));
      this.graphics.group.setAttribute("class", "EditBoxRow");
      this.graphics.group.setAttribute("transform", "translate(" + this.position.x + " " + this.position.y + ")");
      if (this.model.get("Abstract")) {
        this.SetAbstractGraphics();
      }
      return this.graphics;
    };

    MethodRow.prototype.Resize = function() {
      this.graphics.VisibiityDropDown.resize();
      this.graphics.NameTexBox.resize();
      this.graphics.ArgumentsTextBox.resize();
      this.graphics.ReturnTextBox.resize();
      this.ReCalculateSize();
      return MethodRow.__super__.Resize.call(this);
    };

    MethodRow.prototype.ReCalculateSize = function() {
      var spaceing;
      spaceing = 10;
      this.Size.x = this.graphics.VisibiityDropDown.Size.x + spaceing;
      this.graphics.NameTexBox.Move(new Point(this.Size.x, 0));
      this.Size.x += this.graphics.NameTexBox.Size.x + spaceing;
      this.graphics.ArgumentsTextBox.Move(new Point(this.Size.x, 0));
      this.Size.x += this.graphics.ArgumentsTextBox.Size.x + spaceing;
      this.graphics.ReturnTextBox.Move(new Point(this.Size.x, 0));
      this.Size.x += this.graphics.ReturnTextBox.Size.x + spaceing;
      if (this.popoutDisplayed) {
        return this.MovePopout();
      }
    };

    MethodRow.prototype.MovePopout = function() {
      var popoutPosition, positionValues, windowCoord;
      windowCoord = window.UML.Utils.getScreenCoordForSVGElement(this.graphics.border);
      positionValues = window.UML.TextBoxes.IntelligentPopoutPositioning.Position({
        right: $('#popoverLinkMethR'),
        left: $('#popoverLinkMethL')
      }, new Point(280, 0), windowCoord, this.Size);
      if (positionValues.element[0] !== this.popoverLink[0]) {
        this.popoverLink.popover('hide');
        this.popoverLink = positionValues.element;
        this.InitialisePopover();
      }
      popoutPosition = positionValues.position;
      this.popoverLink.css("top", popoutPosition.y);
      this.popoverLink.css("left", popoutPosition.x);
      return this.popoverLink.popover('show');
    };

    MethodRow.prototype.OnVisibilityChangeSizeHandler = function(evt) {
      this.graphics.NameTexBox.resize();
      this.graphics.ArgumentsTextBox.resize();
      this.graphics.ReturnTextBox.resize();
      this.ReCalculateSize();
      this.highlightBox.Resize();
      evt = new Object();
      evt.width = this.Size.x;
      return this.onSizeChange.pulse(evt);
    };

    MethodRow.prototype.OnNameChangeSizeHandler = function(evt) {
      this.graphics.ArgumentsTextBox.resize();
      this.graphics.ReturnTextBox.resize();
      this.ReCalculateSize();
      this.highlightBox.Resize();
      evt = new Object();
      evt.width = this.Size.x;
      return this.onSizeChange.pulse(evt);
    };

    MethodRow.prototype.OnArgumentsChangeSizeHandler = function(evt) {
      this.graphics.ReturnTextBox.resize();
      this.ReCalculateSize();
      this.highlightBox.Resize();
      evt = new Object();
      evt.width = this.Size.x;
      return this.onSizeChange.pulse(evt);
    };

    MethodRow.prototype.OnReturnChangeSizeHandler = function(evt) {
      this.ReCalculateSize();
      this.highlightBox.Resize();
      evt = new Object();
      evt.width = this.Size.x;
      return this.onSizeChange.pulse(evt);
    };

    MethodRow.prototype.SetAbstractGraphics = function() {
      $(this.graphics.VisibiityDropDown.graphics.text).addClass("AbstractMethod");
      $(this.graphics.NameTexBox.graphics.text).addClass("AbstractMethod");
      $(this.graphics.ArgumentsTextBox.graphics.text).addClass("AbstractMethod");
      return $(this.graphics.ReturnTextBox.graphics.text).addClass("AbstractMethod");
    };

    MethodRow.prototype.UnsetAbstractGraphics = function() {
      $(this.graphics.VisibiityDropDown.graphics.text).removeClass("AbstractMethod");
      $(this.graphics.NameTexBox.graphics.text).removeClass("AbstractMethod");
      $(this.graphics.ArgumentsTextBox.graphics.text).removeClass("AbstractMethod");
      return $(this.graphics.ReturnTextBox.graphics.text).removeClass("AbstractMethod");
    };

    MethodRow.prototype.SetAbstract = function() {
      this.model.set("Abstract", true);
      return this.SetAbstractGraphics();
    };

    MethodRow.prototype.UnsetAbstract = function() {
      this.model.set("Abstract", false);
      return this.UnsetAbstractGraphics();
    };

    MethodRow.prototype.InitialisePopover = function() {
      var AbstractString, StaticString;
      this.popoverLink.attr("data-original-title", "Method Edit");
      if (this.model.get("Abstract")) {
        AbstractString = "<input type=\"checkbox\" checked id=\"Abstract\">Abstract";
      } else {
        AbstractString = "<input type=\"checkbox\" id=\"Abstract\">Abstract";
      }
      if (this.model.get("Static")) {
        StaticString = "<input type=\"checkbox\" checked id=\"Static\">Static";
      } else {
        StaticString = "<input type=\"checkbox\" id=\"Static\">Static";
      }
      StaticString += "<div><span>Method Comment:</span><textarea id=\"classPropertyDescription\">";
      StaticString += this.model.get("Comment");
      StaticString += "</textarea></div>";
      StaticString += "<br/><br/><button type=\"button\" class=\"btn btn-danger\" onClick=\"" + this.routeResolver.resolveRoute("Table") + ".rows.get(" + this.RowNumber + ").model.del();\" >Delete</button>";
      return this.popoverLink.attr("data-content", AbstractString + "<br>" + StaticString);
    };

    MethodRow.prototype.OnSelect = function() {
      var evt, popoutPosition, positionValues, windowCoord;
      evt = new Object();
      evt.textBoxGroup = this;
      window.UML.Pulse.TextBoxGroupSelected.pulse(evt);
      $(this.graphics.border).addClass("selectedRow");
      windowCoord = window.UML.Utils.getScreenCoordForSVGElement(this.graphics.border);
      positionValues = window.UML.TextBoxes.IntelligentPopoutPositioning.Position({
        right: $('#popoverLinkMethR'),
        left: $('#popoverLinkMethL')
      }, new Point(280, 0), windowCoord, this.Size);
      this.popoverLink = positionValues.element;
      popoutPosition = positionValues.position;
      this.popoverLink.css("top", popoutPosition.y);
      this.popoverLink.css("left", popoutPosition.x);
      this.popoverLink.popover('hide');
      this.InitialisePopover();
      this.popoverLink.popover('show');
      this.popoutDisplayed = true;
      this.graphics.VisibiityDropDown.highlightBox.passive = false;
      this.graphics.ReturnTextBox.highlightBox.passive = false;
      this.graphics.NameTexBox.highlightBox.passive = false;
      return this.graphics.ArgumentsTextBox.highlightBox.passive = false;
    };

    MethodRow.prototype.deactivate = function() {
      $(this.graphics.border).removeClass("selectedRow");
      this.model.set("Static", $('#Static').is(':checked'));
      if (!this.model.get("Abstract") && $('#Abstract').is(':checked')) {
        this.SetAbstract();
      } else if (this.model.get("Abstract") && !$('#Abstract').is(':checked')) {
        this.UnsetAbstract();
      }
      this.model.set("Comment", $("#classPropertyDescription").val());
      if (this.popoverLink) {
        this.popoverLink.popover('destroy');
      }
      this.popoutDisplayed = false;
      this.graphics.VisibiityDropDown.highlightBox.passive = true;
      this.graphics.ReturnTextBox.highlightBox.passive = true;
      this.graphics.NameTexBox.highlightBox.passive = true;
      return this.graphics.ArgumentsTextBox.highlightBox.passive = true;
    };

    MethodRow.prototype.onDelete = function() {};

    MethodRow.prototype.OnNameChangeHandler = function(evt) {
      return this.model.set("Name", evt.newText);
    };

    MethodRow.prototype.OnReturnChangeHandler = function(evt) {
      return this.model.set("Return", evt.newText);
    };

    MethodRow.prototype.OnArgsChangeHandler = function(evt) {
      return this.model.set("Args", evt.newText);
    };

    MethodRow.prototype.OnVisChangeHandler = function(evt) {
      return this.model.set("Vis", evt.newText);
    };

    MethodRow.prototype.OnModelChange = function(evt) {
      if (evt.name === "Name") {
        return this.graphics.NameTexBox.UpdateText(evt.new_value);
      } else if (evt.name === "Return") {
        return this.graphics.ReturnTextBox.UpdateText(evt.new_value);
      } else if (evt.name === "Vis") {
        return this.graphics.VisibiityDropDown.UpdateText(evt.new_value);
      } else if (evt.name === "Args") {
        return this.graphics.ArgumentsTextBox.UpdateText(evt.new_value);
      } else if (evt.name === "Abstract") {
        if (evt.new_value) {
          return this.SetAbstractGraphics();
        } else {
          return this.UnsetAbstractGraphics();
        }
      }
    };

    return MethodRow;

  })(DefaultRow);

  MethodRowFactory = (function() {
    function MethodRowFactory() {}

    MethodRowFactory.prototype.Create = function(position, width, model) {
      var methodRow;
      methodRow = new MethodRow(width, position, model);
      return methodRow;
    };

    return MethodRowFactory;

  })();

  window.UML.Pulse.TextBoxGroupSelected = new Event();

  PropertyRow = (function(_super) {
    __extends(PropertyRow, _super);

    function PropertyRow(width, position, model) {
      this.position = position;
      this.model = model;
      PropertyRow.__super__.constructor.call(this, width, this.position);
      this.OnVisibilitySizeChange = (function(evt) {
        return this.OnVisibilityChangeSizeHandler(evt);
      }).bind(this);
      this.OnNameSizeChange = (function(evt) {
        return this.OnNameChangeSizeHandler(evt);
      }).bind(this);
      this.OnNameChange = (function(evt) {
        return this.OnNameChangeHandler(evt);
      }).bind(this);
      this.OnTypeChange = (function(evt) {
        return this.OnTypeChangeHandler(evt);
      }).bind(this);
      this.OnVisChange = (function(evt) {
        return this.OnVisChangeHandler(evt);
      }).bind(this);
      this.model.onChange.add((function(evt) {
        return this.OnModelChange(evt);
      }).bind(this));
    }

    PropertyRow.prototype.CreateGraphics = function(RowNumber) {
      this.RowNumber = RowNumber;
      this.graphics = new Object();
      this.graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.graphics.VisibiityDropDown = new EdiableDropDown(new Point(0, 0), this.model.model.Vis, ["+", "-", "#"]);
      this.graphics.VisibiityDropDown.onTabPressedHandler = (function(evt) {
        this.graphics.VisibiityDropDown.onEditBoxBlur();
        this.graphics.NameTexBox.OnSelect();
        return false;
      }).bind(this);
      this.graphics.TypeTextBox = new ReturnValueTextBox(new Point(10, 0), this.model.get("Type"));
      this.graphics.TypeTextBox.selectTextOnShow = true;
      this.graphics.TypeTextBox.onTabPressedHandler = (function(evt) {
        this.graphics.TypeTextBox.onTabPress();
        this.graphics.TypeTextBox.hideEditBox();
        this.graphics.VisibiityDropDown.OnSelect();
        return false;
      }).bind(this);
      this.graphics.NameTexBox = new EdiableTextBox(new Point(30, 0), this.model.model.Name);
      this.graphics.NameTexBox.selectTextOnShow = true;
      this.graphics.NameTexBox.onTabPressedHandler = (function(evt) {
        this.graphics.NameTexBox.onEditBoxBlur();
        this.graphics.TypeTextBox.OnSelect();
        return false;
      }).bind(this);
      this.graphics.VisibiityDropDown.highlightBox.passive = true;
      this.graphics.TypeTextBox.highlightBox.passive = true;
      this.graphics.NameTexBox.highlightBox.passive = true;
      this.graphics.NameTexBox.onTextChange.add(this.OnNameChange);
      this.graphics.TypeTextBox.onTextChange.add(this.OnTypeChange);
      this.graphics.VisibiityDropDown.onTextChange.add(this.OnVisChange);
      this.graphics.VisibiityDropDown.highlightBox.OnMouseOver.add(this.highlightBox.mouseOverHandle);
      this.graphics.VisibiityDropDown.highlightBox.OnMouseUp.add(this.highlightBox.mouseUpHandle);
      this.graphics.VisibiityDropDown.highlightBox.OnMouseExit.add(this.highlightBox.mouseOutHandle);
      this.graphics.TypeTextBox.highlightBox.OnMouseOver.add(this.highlightBox.mouseOverHandle);
      this.graphics.TypeTextBox.highlightBox.OnMouseUp.add(this.highlightBox.mouseUpHandle);
      this.graphics.TypeTextBox.highlightBox.OnMouseExit.add(this.highlightBox.mouseOutHandle);
      this.graphics.NameTexBox.highlightBox.OnMouseOver.add(this.highlightBox.mouseOverHandle);
      this.graphics.NameTexBox.highlightBox.OnMouseUp.add(this.highlightBox.mouseUpHandle);
      this.graphics.NameTexBox.highlightBox.OnMouseExit.add(this.highlightBox.mouseOutHandle);
      this.graphics.VisibiityDropDown.onSizeChange.add(this.OnTextElemetChangeSizeHandler.bind(this));
      this.graphics.TypeTextBox.onSizeChange.add(this.OnTextElemetChangeSizeHandler.bind(this));
      this.graphics.NameTexBox.onSizeChange.add(this.OnTextElemetChangeSizeHandler.bind(this));
      this.highlightBox.CreateGraphics(this.graphics);
      this.graphics.group.appendChild(this.graphics.border);
      this.graphics.group.appendChild(this.graphics.VisibiityDropDown.CreateGraphics("TextElement"));
      this.graphics.group.appendChild(this.graphics.TypeTextBox.CreateGraphics("TextElement"));
      this.graphics.group.appendChild(this.graphics.NameTexBox.CreateGraphics("TextElement"));
      this.graphics.group.setAttribute("class", "EditBoxRow");
      this.graphics.group.setAttribute("transform", "translate(" + this.position.x + " " + this.position.y + ")");
      return this.graphics;
    };

    PropertyRow.prototype.OnTextElemetChangeSizeHandler = function(evt) {
      this.ReCalculateSize();
      this.highlightBox.Resize();
      evt = new Object();
      evt.width = this.Size.x;
      return this.onSizeChange.pulse(evt);
    };

    PropertyRow.prototype.Resize = function() {
      this.graphics.TypeTextBox.resize();
      this.graphics.VisibiityDropDown.resize();
      this.graphics.NameTexBox.resize();
      this.ReCalculateSize();
      this.highlightBox.Resize();
      return PropertyRow.__super__.Resize.call(this);
    };

    PropertyRow.prototype.ReCalculateSize = function() {
      var spaceing;
      spaceing = 10;
      this.Size.x = this.graphics.VisibiityDropDown.Size.x + spaceing;
      this.graphics.NameTexBox.Move(new Point(this.Size.x, 0));
      this.Size.x += this.graphics.NameTexBox.Size.x + spaceing;
      this.graphics.TypeTextBox.Move(new Point(this.Size.x, 0));
      return this.Size.x += this.graphics.TypeTextBox.Size.x + spaceing;
    };

    PropertyRow.prototype.OnSelect = function() {
      var StaticString, evt, popoutPosition, positionValues, windowCoord;
      evt = new Object();
      evt.textBoxGroup = this;
      window.UML.Pulse.TextBoxGroupSelected.pulse(evt);
      $(this.graphics.border).addClass("selectedRow");
      windowCoord = window.UML.Utils.getScreenCoordForSVGElement(this.graphics.border);
      positionValues = window.UML.TextBoxes.IntelligentPopoutPositioning.Position({
        right: $('#popoverLinkPropR'),
        left: $('#popoverLinkPropL')
      }, new Point(107, 0), windowCoord, this.Size);
      this.popoverLink = positionValues.element;
      popoutPosition = positionValues.position;
      this.popoverLink.css("top", popoutPosition.y);
      this.popoverLink.css("left", popoutPosition.x);
      this.popoverLink.attr("data-original-title", "Property Edit");
      if (this.model.get("Static")) {
        StaticString = "<input type=\"checkbox\" checked id=\"Static\">Static";
      } else {
        StaticString = "<input type=\"checkbox\" id=\"Static\">Static";
      }
      StaticString += "<br/><br/><button type=\"button\" class=\"btn btn-danger\" onClick=\"" + this.routeResolver.resolveRoute("Table") + ".rows.get(" + this.RowNumber + ").model.del();\">Delete</button>";
      this.popoverLink.popover('hide');
      this.popoverLink.attr("data-content", StaticString);
      this.popoverLink.popover('show');
      this.graphics.VisibiityDropDown.highlightBox.passive = false;
      this.graphics.TypeTextBox.highlightBox.passive = false;
      return this.graphics.NameTexBox.highlightBox.passive = false;
    };

    PropertyRow.prototype.deactivate = function() {
      $(this.graphics.border).removeClass("selectedRow");
      this.model.set("Static", $('#Static').is(':checked'));
      if (this.popoverLink) {
        this.popoverLink.popover('destroy');
      }
      this.graphics.VisibiityDropDown.highlightBox.passive = true;
      this.graphics.TypeTextBox.highlightBox.passive = true;
      return this.graphics.NameTexBox.highlightBox.passive = true;
    };

    PropertyRow.prototype.OnVisibilityChangeSizeHandler = function(evt) {
      this.graphics.TypeTextBox.resize();
      this.graphics.NameTexBox.resize();
      this.ReCalculateSize();
      this.highlightBox.Resize();
      evt = new Object();
      evt.width = this.Size.x;
      return this.onSizeChange.pulse(evt);
    };

    PropertyRow.prototype.OnNameChangeSizeHandler = function(evt) {
      this.graphics.TypeTextBox.resize();
      this.ReCalculateSize();
      this.highlightBox.Resize();
      evt = new Object();
      evt.width = this.Size.x;
      return this.onSizeChange.pulse(evt);
    };

    PropertyRow.prototype.onDelete = function() {};

    PropertyRow.prototype.OnNameChangeHandler = function(evt) {
      return this.model.set("Name", evt.newText);
    };

    PropertyRow.prototype.OnTypeChangeHandler = function(evt) {
      return this.model.set("Type", evt.newText);
    };

    PropertyRow.prototype.OnVisChangeHandler = function(evt) {
      return this.model.set("Vis", evt.newText);
    };

    PropertyRow.prototype.OnModelChange = function(evt) {
      if (evt.name === "Name") {
        return this.graphics.NameTexBox.UpdateText(evt.new_value);
      } else if (evt.name === "Type") {
        return this.graphics.TypeTextBox.UpdateText(evt.new_value);
      } else if (evt.name === "Vis") {
        return this.graphics.VisibiityDropDown.UpdateText(evt.new_value);
      }
    };

    return PropertyRow;

  })(DefaultRow);

  PropertyRowFactory = (function() {
    function PropertyRowFactory() {}

    PropertyRowFactory.prototype.Create = function(position, width, model) {
      var newproptery;
      newproptery = new PropertyRow(width, position, model);
      return newproptery;
    };

    return PropertyRowFactory;

  })();

  ReturnValueTextBox = (function(_super) {
    __extends(ReturnValueTextBox, _super);

    function ReturnValueTextBox(relPos, text) {
      ReturnValueTextBox.__super__.constructor.call(this, relPos, text);
      this.TypeSugestionBox = new window.UML.TextBoxes.TypeSugestionBox();
      this.TypeSugestionBox.onTypeSugestionMade.add(this.TypeSugestionClicked.bind(this));
      this.tabPressHandl = (function(evt) {
        return this.onTabPress(evt);
      }).bind(this);
      this.KeyPressHandl = (function(evt) {
        return this.UpdateTypeSugestionBox(evt);
      }).bind(this);
    }

    ReturnValueTextBox.prototype.CreateGraphics = function(classNames) {
      var ypos;
      ReturnValueTextBox.__super__.CreateGraphics.call(this, classNames);
      this.MemberGraphics = new Object();
      this.MemberGraphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.MemberGraphics.text = document.createElementNS("http://www.w3.org/2000/svg", 'text');
      this.MemberGraphics.text.setAttribute("class", classNames);
      this.MemberGraphics.text.textContent = ":";
      ypos = this.relPosition.y + 20;
      this.MemberGraphics.text.setAttribute("transform", "translate(" + this.relPosition.x + " " + ypos + ")");
      this.MemberGraphics.group.appendChild(this.MemberGraphics.text);
      this.MemberGraphics.group.appendChild(this.graphics.group);
      return this.MemberGraphics.group;
    };

    ReturnValueTextBox.prototype.getGraphics = function() {
      return this.MemberGraphics;
    };

    ReturnValueTextBox.prototype.resize = function() {
      var ypos;
      ReturnValueTextBox.__super__.resize.call(this);
      ypos = this.relPosition.y + 20;
      return this.MemberGraphics.text.setAttribute("transform", "translate(" + this.relPosition.x + " " + ypos + ")");
    };

    ReturnValueTextBox.prototype.Move = function(position) {
      var ypos;
      this.position = position;
      ReturnValueTextBox.__super__.Move.call(this, this.position);
      ypos = this.relPosition.y + 20;
      return this.MemberGraphics.text.setAttribute("transform", "translate(" + this.relPosition.x + " " + ypos + ")");
    };

    ReturnValueTextBox.prototype.showEditBox = function() {
      var editBox, point;
      ReturnValueTextBox.__super__.showEditBox.call(this);
      editBox = $(this.currentEditBox);
      point = new Point(editBox.css("left"), parseInt(editBox.css("top")) + parseInt(editBox.css("height")) + 5);
      editBox.keyup(this.KeyPressHandl);
      return this.TypeSugestionBox.Show(point);
    };

    ReturnValueTextBox.prototype.hideEditBox = function() {
      var editBox;
      ReturnValueTextBox.__super__.hideEditBox.call(this);
      this.TypeSugestionBox.Hide();
      editBox = $(this.currentEditBox);
      return editBox.unbind("keyup", this.KeyPressHandl);
    };

    ReturnValueTextBox.prototype.SetReturnValue = function(value) {
      return this.SetText(value);
    };

    ReturnValueTextBox.prototype.onTabPress = function(evt) {
      var selectedText;
      if (this.TypeSugestionBox.displayed) {
        selectedText = this.TypeSugestionBox.GetSelectedText();
        if (selectedText !== null) {
          this.SetReturnValue(selectedText);
        }
      }
      return true;
    };

    ReturnValueTextBox.prototype.UpdateTypeSugestionBox = function(evt) {
      var key;
      key = evt.keyCode ? evt.keyCode : evt.which;
      if (key >= 48 || key === 8) {
        return this.TypeSugestionBox.UpdateStringPartial(this.currentEditBox.value);
      }
    };

    ReturnValueTextBox.prototype.TypeSugestionClicked = function(evt) {
      return this.SetReturnValue(evt.selection[0].innerHTML);
    };

    return ReturnValueTextBox;

  })(EdiableTextBox);

  SVGButton = (function() {
    function SVGButton(bttnText, position) {
      this.bttnText = bttnText;
      this.position = position;
      this.onClickEvt = new Event();
    }

    SVGButton.prototype.AddOnClick = function(handler) {
      return this.onClickEvt.add(handler);
    };

    SVGButton.prototype.MoveDown = function(ypos) {
      this.position.y = ypos;
      return this.graphics.group.setAttribute("transform", "translate(" + this.position.x + "," + this.position.y + ")");
    };

    SVGButton.prototype.CreateGraphics = function() {
      this.graphics = new Object();
      this.graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.graphics.bttn = document.createElementNS("http://www.w3.org/2000/svg", 'rect');
      this.graphics.txt = document.createElementNS("http://www.w3.org/2000/svg", 'text');
      this.graphics.group.setAttribute("transform", "translate(" + this.position.x + "," + this.position.y + ")");
      this.graphics.group.setAttribute("class", "SVGButton");
      this.graphics.group.setAttribute("fill-opacity", 0);
      this.graphics.group.setAttribute("stroke-opacity", 0);
      this.graphics.group.addEventListener("mouseup", this.onClick.bind(this));
      this.graphics.bttn.setAttribute("x", 0);
      this.graphics.bttn.setAttribute("y", 0);
      this.graphics.bttn.setAttribute("rx", 4);
      this.graphics.bttn.setAttribute("ry", 4);
      this.graphics.bttn.setAttribute("height", 14);
      this.graphics.bttn.setAttribute("width", 25);
      this.graphics.bttn.setAttribute("class", "SVGBttnBorder");
      this.graphics.txt.setAttribute("x", 2);
      this.graphics.txt.setAttribute("y", 11);
      this.graphics.txt.setAttribute("class", "SVGBttnText");
      this.graphics.txt.textContent = this.bttnText;
      this.graphics.group.appendChild(this.graphics.bttn);
      this.graphics.group.appendChild(this.graphics.txt);
      return this.graphics.group;
    };

    SVGButton.prototype.onClick = function(evt) {
      return this.onClickEvt.pulse(null);
    };

    SVGButton.prototype.SetButtonText = function(bttnText) {
      this.bttnText = bttnText;
      return this.graphics.txt.textContent = this.bttnText;
    };

    SVGButton.prototype.Hide = function() {
      this.graphics.group.setAttribute("fill-opacity", 0);
      return this.graphics.group.setAttribute("stroke-opacity", 0);
    };

    SVGButton.prototype.Show = function() {
      this.graphics.group.setAttribute("fill-opacity", 1);
      return this.graphics.group.setAttribute("stroke-opacity", 1);
    };

    return SVGButton;

  })();

  TableColumn = (function() {
    function TableColumn(width, position) {
      this.width = width;
      this.position = position;
      this.onWidthChange = new Event();
      this.onHeightChange = new Event();
      this.onCellBecomesEmpty = new Event();
      this.rows = new Array();
      this.height = 0;
      this.defaultValue = "";
      this.onWidthChangeHandle = (function(evt) {
        return this.onItemWidthChange(evt);
      }).bind(this);
      this.onCellEmptyHandl = (function(evt) {
        return this.onCellBecameEmpty(evt);
      }).bind(this);
    }

    TableColumn.prototype.Move = function(position) {
      this.position = position;
      return this.graphics.group.setAttribute("transform", "translate(" + this.position.x + " " + this.position.y + ")");
    };

    TableColumn.prototype.CreateGraphics = function() {
      this.graphics = new Object();
      this.graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.graphics.group.setAttribute("transform", "translate(" + this.position.x + " " + this.position.y + ")");
      return this.graphics.group;
    };

    TableColumn.prototype.Resize = function() {
      var row, _i, _len, _ref, _results;
      _ref = this.rows;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        row = _ref[_i];
        _results.push((function(row) {
          return row.resize();
        })(row));
      }
      return _results;
    };

    TableColumn.prototype.addRow = function(value) {
      var txtBx;
      if (typeof value === "undefined" || value === null) {
        value = this.defaultValue;
      }
      txtBx = new EdiableTextBox(new Point(0, this.height), value);
      txtBx.onBecomeEmpty.add(this.onCellEmptyHandl);
      this.height += txtBx.height + 5;
      txtBx.onSizeChange.add(this.onWidthChangeHandle);
      this.rows.push(txtBx);
      this.graphics.group.appendChild(txtBx.CreateGraphics());
      return this.onHeightChange.pulse(null);
    };

    TableColumn.prototype.deleteRow = function(index) {
      var ref, row, txtBx, yDelta, _i, _ref, _results;
      txtBx = this.rows[index];
      this.height -= txtBx.height + 5;
      txtBx.onSizeChange.remove(this.onWidthChangeHandle);
      this.graphics.group.removeChild(txtBx.getGraphics().group);
      this.rows.splice(index, 1);
      this.onHeightChange.pulse(null);
      ref = this;
      yDelta = txtBx.height + 5;
      if (this.rows.length > 0) {
        _results = [];
        for (row = _i = index, _ref = this.rows.length - 1; index <= _ref ? _i <= _ref : _i >= _ref; row = index <= _ref ? ++_i : --_i) {
          _results.push((function(row, ref, yDelta) {
            var txtBox;
            txtBox = ref.rows[row];
            return txtBox.Move(new Point(txtBox.relPosition.x, txtBox.relPosition.y - yDelta));
          })(row, ref, yDelta));
        }
        return _results;
      }
    };

    TableColumn.prototype.onItemWidthChange = function(evt) {
      var prevWidth, ref, row, _fn, _i, _len, _ref;
      ref = this;
      prevWidth = this.width;
      this.width = 0;
      _ref = this.rows;
      _fn = function(row, ref) {
        if (row.width > ref.width) {
          return ref.width = row.width;
        }
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        row = _ref[_i];
        _fn(row, ref);
      }
      if (this.width !== prevWidth) {
        this.onWidthChange.pulse(null);
      }
    };

    TableColumn.prototype.onCellBecameEmpty = function(evt) {
      var evtArg;
      evtArg = new Object();
      evtArg.EmptyRow = this.rows.indexOf(evt.trigger);
      return this.onCellBecomesEmpty.pulse(evtArg);
    };

    return TableColumn;

  })();

  window.UML.Pulse.TypeSugestionClicked = new Event();

  window.UML.TextBoxes.TypeSugestionBox = (function() {
    function TypeSugestionBox() {
      this.NO_SELECTION = 0;
      this.onTypeSugestionMade = new Event();
      this.SelectedIndex = this.NO_SELECTION;
      this.displayed = false;
      window.UML.Pulse.TypeSugestionClicked.add((function(evt) {
        return this.onTypeClicked(evt);
      }).bind(this));
    }

    TypeSugestionBox.prototype.Show = function(Position) {
      this.Position = Position;
      this.UpdateStringPartial("");
      $("#typeSugestionList").css({
        display: "block",
        left: this.Position.x,
        top: this.Position.y
      });
      window.UML.globals.KeyboardListener.RegisterDownKeyInterest(40, this.MoveSelectionDown.bind(this));
      window.UML.globals.KeyboardListener.RegisterDownKeyInterest(38, this.MoveSelectionUp.bind(this));
      return this.displayed = true;
    };

    TypeSugestionBox.prototype.Hide = function() {
      $("#typeSugestionList").css({
        display: "none"
      });
      window.UML.globals.KeyboardListener.UnRegisterDownKeyInterest(40, this.MoveSelectionDown.bind(this));
      window.UML.globals.KeyboardListener.UnRegisterDownKeyInterest(38, this.MoveSelectionUp.bind(this));
      return this.displayed = false;
    };

    TypeSugestionBox.prototype.UpdateStringPartial = function(str) {
      var node, selection, selections, _fn, _i, _len;
      selections = new Array();
      node = globals.CommonData.Types.GetSelections(str);
      node.ListChildren(selections);
      $("#typeSugestionList ul").html("");
      this.SelectionLength = selections.length;
      _fn = function(selection) {
        return $("#typeSugestionList ul").append("<li><a>" + selection + "</a></li>");
      };
      for (_i = 0, _len = selections.length; _i < _len; _i++) {
        selection = selections[_i];
        _fn(selection);
      }
      $("#typeSugestionList ul li a").mousedown(function(evt) {
        return window.UML.Pulse.TypeSugestionClicked.pulse({
          selection: $(this)
        });
      });
      if (globals.CommonData.Types.IsRoot(node)) {
        this.SelectedIndex = this.NO_SELECTION;
      } else {
        this.SelectedIndex = 1;
      }
      return this.ActivateSelected();
    };

    TypeSugestionBox.prototype.onTypeClicked = function(evt) {
      if (this.displayed) {
        return this.onTypeSugestionMade.pulse(evt);
      }
    };

    TypeSugestionBox.prototype.MoveSelectionDown = function(evt) {
      this.DeActivateSelected();
      this.SelectedIndex++;
      this.SelectedIndex = this.SelectedIndex > this.SelectionLength ? 0 : this.SelectedIndex;
      this.ActivateSelected();
      evt.preventDefault();
      return false;
    };

    TypeSugestionBox.prototype.MoveSelectionUp = function(evt) {
      this.DeActivateSelected();
      this.SelectedIndex--;
      this.SelectedIndex = this.SelectedIndex <= 0 ? this.SelectionLength : this.SelectedIndex;
      this.ActivateSelected();
      evt.preventDefault();
      return false;
    };

    TypeSugestionBox.prototype.DeActivateSelected = function() {
      return $("#typeSugestionList ul li:nth-child(" + this.SelectedIndex + ")").removeClass("active");
    };

    TypeSugestionBox.prototype.ActivateSelected = function() {
      return $("#typeSugestionList ul li:nth-child(" + this.SelectedIndex + ")").addClass("active");
    };

    TypeSugestionBox.prototype.GetSelectedText = function() {
      if (this.SelectedIndex !== this.NO_SELECTION) {
        return $("#typeSugestionList ul li:nth-child(" + this.SelectedIndex + ") a").html();
      } else {
        return null;
      }
    };

    return TypeSugestionBox;

  })();

  window.UML.Arrows.ArrowEndPoint = (function() {
    function ArrowEndPoint(context, model) {
      this.context = context;
      this.model = model;
      this.displayed = false;
      this.inArrowFollow = false;
      this.endPoint = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
      this.endPoint.setAttribute("r", "5");
      this.endPoint.setAttribute("fill", "#3385D6");
      this.endPoint.setAttribute("class", "arrowDrag");
      this.preliminaryLockedData = {};
      this.preliminaryLockedData.Position = this.model.get("Position");
      this.latestPositionForDraw = this.model.get("Position");
      this.Followed = new Event();
      this.UnFollowed = new Event();
      this.position = this.model.get("Position");
      this.Connection = new window.UML.Arrows.ArrowConnection(this.arrow);
    }

    ArrowEndPoint.prototype.getLastestPosition = function() {
      if (this.inArrowFollow) {
        return this.preliminaryLockedData.Position;
      } else {
        return this.model.get("Position");
      }
    };

    ArrowEndPoint.prototype.del = function() {
      if (this.displayed) {
        return globals.document.removeChild(this.endPoint);
      }
    };

    ArrowEndPoint.prototype.Show = function() {
      this.displayed = true;
      return globals.document.appendChild(this.endPoint);
    };

    ArrowEndPoint.prototype.Hide = function() {
      this.displayed = false;
      return globals.document.removeChild(this.endPoint);
    };

    ArrowEndPoint.prototype.Redraw = function() {
      var pos;
      pos = this.getLastestPosition();
      if (this.arrowEndPoint) {
        this.arrowEndPoint.Move(pos);
      }
      this.endPoint.setAttribute("cx", pos.x);
      return this.endPoint.setAttribute("cy", pos.y);
    };

    ArrowEndPoint.prototype.ResetEndpoint1 = function(arrowEndPoint) {
      this.arrowEndPoint = arrowEndPoint;
    };

    ArrowEndPoint.prototype.ResetEndpoint2 = function(arrowEndPoint) {
      this.arrowEndPoint = arrowEndPoint;
    };

    ArrowEndPoint.prototype.OnMouseMove = function(evt) {
      var loc;
      if (this.preliminaryLockedData.Locked) {
        return;
      }
      loc = window.UML.Utils.mousePositionFromEvent(evt);
      this.preliminaryLockedData.Position = loc;
      this.context.redraw();
    };

    ArrowEndPoint.prototype.OnDropZoneActive = function(evt) {
      this.preliminaryLockedData.Locked = true;
      this.preliminaryLockedData.LockedClass = evt.classID;
      this.preliminaryLockedData.LockedIndex = evt.index;
      this.preliminaryLockedData.Position = evt.position;
      this.position = evt.position;
      this.context.redraw();
    };

    ArrowEndPoint.prototype.OnDropZoneLeave = function(evt) {
      this.preliminaryLockedData.Locked = false;
      this.preliminaryLockedData.LockedClass = -1;
      this.preliminaryLockedData.LockedIndex = 0;
    };

    ArrowEndPoint.prototype.Follow = function() {
      this.inArrowFollow = true;
      this.Followed.pulse();
      this.endPoint.setAttribute("pointer-events", "none");
      this.mouseMoveHandle = (function(evt) {
        return this.OnMouseMove(evt);
      }).bind(this);
      this.dropZoneLeave = (function(evt) {
        return this.OnDropZoneLeave(evt);
      }).bind(this);
      this.dropZoneActive = (function(evt) {
        return this.OnDropZoneActive(evt);
      }).bind(this);
      document.addEventListener("mousemove", this.mouseMoveHandle, false);
      window.UML.Pulse.DropZoneEnter.add(this.dropZoneActive);
      return window.UML.Pulse.DropZoneLeave.add(this.dropZoneLeave);
    };

    ArrowEndPoint.prototype.UnFollow = function() {
      this.inArrowFollow = false;
      document.removeEventListener("mousemove", this.mouseMoveHandle, false);
      window.UML.Pulse.DropZoneEnter.remove(this.dropZoneActive);
      window.UML.Pulse.DropZoneLeave.remove(this.dropZoneLeave);
      this.mouseMoveHandle = 0;
      this.dropZoneLeave = 0;
      this.dropZoneActive = 0;
      this.UnFollowed.pulse();
      return this.endPoint.setAttribute("pointer-events", "all");
    };

    ArrowEndPoint.prototype.ApplyPrelimineryLockData = function() {
      return this.model.setGroup([
        {
          name: "Position",
          value: this.preliminaryLockedData.Position
        }, {
          name: "Locked",
          value: this.preliminaryLockedData.Locked
        }, {
          name: "LockedIndex",
          value: this.preliminaryLockedData.LockedIndex
        }, {
          name: "LockedClass",
          value: this.preliminaryLockedData.LockedClass
        }
      ]);
    };

    ArrowEndPoint.prototype.ResetPreliminery = function() {
      this.preliminaryLockedData.Position = this.model.get("Position");
      this.preliminaryLockedData.Locked = this.model.get("Locked");
      this.preliminaryLockedData.LockedIndex = this.model.get("LockedIndex");
      return this.preliminaryLockedData.LockedClass = this.model.get("LockedClass");
    };

    return ArrowEndPoint;

  })();

  window.UML.Arrows.Arrow_On_Follow = new Event();

  window.UML.Arrows.Arrow_Un_Follow = new Event();

  window.UML.Arrows.Arrow = (function() {
    function Arrow(model) {
      var end, start;
      this.model = model;
      this.model.set("id", this.model.modelItemID);
      this.ARROW_HEAD_LENGTH = 10;
      this.segments = new Array();
      this.bendPoints = new Array();
      this.hoveredLineSegment = null;
      this.arrow = document.createElementNS("http://www.w3.org/2000/svg", 'use');
      this.arrow.setAttributeNS('http://www.w3.org/1999/xlink', 'xlink:href', '#arrowHeadU');
      this.arrow.setAttribute("class", "ArrowHead");
      this.On_Follow_Handel = (function(evt) {
        return this.On_Follow(evt);
      }).bind(this);
      this.On_UnFollow_Handel = (function(evt) {
        return this.On_UnFollow(evt);
      }).bind(this);
      this.On_Mouse_down_handel = (function(evt) {
        return this.OnMouseDown(evt);
      }).bind(this);
      this.On_Mouse_hover_handel = (function(evt) {
        return this.OnMouseOver(evt);
      }).bind(this);
      this.On_Mouse_leave_handel = (function(evt) {
        return this.OnMouseLeave(evt);
      }).bind(this);
      start = this.model.get("Head").get("Position");
      end = this.model.get("Tail").get("Position");
      this.firstSegment = new window.UML.Arrows.LineSegment(new Point(start.x, start.y), new Point(end.x, end.y));
      this.arrowHead = new window.UML.Arrows.ArrowHeadPoint(this, this.model.get("Head"));
      this.arrowHead.Followed.add(this.On_Follow_Handel);
      this.arrowHead.UnFollowed.add(this.On_UnFollow_Handel);
      this.arrowTail = new window.UML.Arrows.ArrowTailPoint(this, this.model.get("Tail"));
      this.arrowTail.Followed.add(this.On_Follow_Handel);
      this.arrowTail.UnFollowed.add(this.On_UnFollow_Handel);
      this.firstSegment.Connect(this.arrowTail, this.arrowHead);
      this.firstSegment.Clicked.add(this.On_Mouse_down_handel);
      this.firstSegment.MouseHover.add(this.On_Mouse_hover_handel);
      this.firstSegment.MouseLeave.add(this.On_Mouse_leave_handel);
      this.firstSegment.CreateGraphicsObject();
      this.segments.push(this.firstSegment);
      this.model.onChange.add((function(evt) {
        return this.On_Model_Change(evt);
      }).bind(this));
      this.CheckForArrowTypeChange();
      this.redraw();
      globals.document.appendChild(this.arrow);
      return;
    }

    Arrow.prototype.Bend = function(at) {
      var newBendPoint, newSegment;
      newSegment = new window.UML.Arrows.LineSegment(at, new Point(this.hoveredLineSegment.position2.x, this.hoveredLineSegment.position2.y));
      newSegment.Clicked.add(this.On_Mouse_down_handel);
      newSegment.MouseHover.add(this.On_Mouse_hover_handel);
      newSegment.MouseLeave.add(this.On_Mouse_leave_handel);
      this.segments.push(newSegment);
      newBendPoint = new window.UML.Arrows.BendPoint(at, this);
      this.bendPoints.push(newBendPoint);
      newBendPoint.CreateGraphicsObject();
      newSegment.CreateGraphicsObject();
      newSegment.Connect(newBendPoint, this.hoveredLineSegment.Connection2);
      this.hoveredLineSegment.Connect(this.hoveredLineSegment.Connection1, newBendPoint);
      newBendPoint.Move(at);
      return this.CheckForArrowTypeChange();
    };

    Arrow.prototype.del = function() {
      var bendPoint, segment, _fn, _fn1, _i, _j, _len, _len1, _ref, _ref1;
      globals.document.removeChild(this.arrow);
      _ref = this.segments;
      _fn = function(segment) {
        return segment.del();
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        segment = _ref[_i];
        _fn(segment);
      }
      _ref1 = this.bendPoints;
      _fn1 = function(bendPoint) {
        return bendPoint.del();
      };
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        bendPoint = _ref1[_j];
        _fn1(bendPoint);
      }
      this.arrowTail.del();
      this.arrowHead.del();
      return globals.arrows.remove(this.model.get("id"));
    };

    Arrow.prototype.recalculateHeadAngle = function(end) {
      var deg, lastSegmentPos, rad;
      if (this.arrowHead.arrowEndPoint) {
        lastSegmentPos = this.arrowHead.arrowEndPoint.ref.position1;
        rad = Math.atan2(end.y - lastSegmentPos.y, end.x - lastSegmentPos.x);
        deg = rad * (180 / Math.PI);
        return deg + 90;
      } else {
        return 0;
      }
    };

    Arrow.prototype.redraw = function() {
      var arrowHeadAng, arrowHeadAngRad, end, segment, start, xLineOffset, yLineOffset, _fn, _i, _len, _ref;
      end = this.arrowHead.getLastestPosition();
      start = this.arrowTail.getLastestPosition();
      this.arrowHead.Redraw();
      this.arrowTail.Redraw();
      _ref = this.segments;
      _fn = function(segment) {
        return segment.Redraw();
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        segment = _ref[_i];
        _fn(segment);
      }
      arrowHeadAng = this.recalculateHeadAngle(end);
      arrowHeadAngRad = arrowHeadAng * (Math.PI / 180);
      xLineOffset = Math.sin(arrowHeadAngRad) * this.ARROW_HEAD_LENGTH;
      yLineOffset = Math.cos(arrowHeadAngRad) * this.ARROW_HEAD_LENGTH;
      this.arrow.setAttribute("x", end.x);
      this.arrow.setAttribute("y", end.y);
      this.arrow.setAttribute("transform", "rotate(" + arrowHeadAng.toString() + " " + end.x + " " + end.y + ")");
    };

    Arrow.prototype.setDashedArrow = function() {
      var segment, _i, _len, _ref, _results;
      _ref = this.segments;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        segment = _ref[_i];
        _results.push((function(segment) {
          return segment.SetDashedArrow();
        })(segment));
      }
      return _results;
    };

    Arrow.prototype.setNormalArrow = function() {
      var segment, _i, _len, _ref, _results;
      _ref = this.segments;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        segment = _ref[_i];
        _results.push((function(segment) {
          return segment.SetNormalArrow();
        })(segment));
      }
      return _results;
    };

    Arrow.prototype.deactivate = function() {
      var bendpoint, _fn, _i, _len, _ref;
      if (this.active) {
        this.active = false;
        this.arrowHead.Hide();
        this.arrowTail.Hide();
        _ref = this.bendPoints;
        _fn = function(bendpoint) {
          return bendpoint.Hide();
        };
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          bendpoint = _ref[_i];
          _fn(bendpoint);
        }
        this.OnMouseLeave();
      }
    };

    Arrow.prototype.OnMouseDown = function(evt) {
      var bendpoint, _fn, _i, _len, _ref;
      this.active = true;
      this.arrowHead.Show();
      this.arrowTail.Show();
      _ref = this.bendPoints;
      _fn = function(bendpoint) {
        return bendpoint.Show();
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        bendpoint = _ref[_i];
        _fn(bendpoint);
      }
      evt.arrow = this;
      return window.UML.Pulse.SingleArrowActivated.pulse(evt);
    };

    Arrow.prototype.OnMouseOver = function(evt) {
      this.hoveredLineSegment = evt.lineSegment;
      return globals.highlights.HighlightArrow(this);
    };

    Arrow.prototype.OnMouseLeave = function(evt) {
      return globals.highlights.UnHighlightArrow();
    };

    Arrow.prototype.Unhighlight = function() {
      var segment, _fn, _i, _len, _ref;
      if (!this.active) {
        _ref = this.segments;
        _fn = function(segment) {
          return segment.ArrowUnHover();
        };
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          segment = _ref[_i];
          _fn(segment);
        }
      }
      return $(this.arrow).removeClass("ArrowHeadHover");
    };

    Arrow.prototype.Highlight = function() {
      var segment, _fn, _i, _len, _ref;
      _ref = this.segments;
      _fn = function(segment) {
        return segment.ArrowHover();
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        segment = _ref[_i];
        _fn(segment);
      }
      return $(this.arrow).addClass("ArrowHeadHover");
    };

    Arrow.prototype.DisablePointerEvents = function() {
      var segment, _fn, _i, _len, _ref;
      this.arrow.setAttribute("pointer-events", "none");
      _ref = this.segments;
      _fn = function(segment) {
        return segment.DisablePointerEvents();
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        segment = _ref[_i];
        _fn(segment);
      }
    };

    Arrow.prototype.CheckForArrowTypeChange = function() {
      var headClass;
      this.setNormalArrow();
      if (this.model.get("Head").get("Locked") && this.model.get("Tail").get("Locked")) {
        headClass = globals.classes.get(this.model.get("Head").get("LockedClass"));
        if (headClass.IsInterface) {
          return this.setDashedArrow();
        }
      }
    };

    Arrow.prototype.EnablePointerEvents = function() {
      var segment, _fn, _i, _len, _ref;
      this.arrow.setAttribute("pointer-events", "all");
      _ref = this.segments;
      _fn = function(segment) {
        return segment.EnablePointerEvents();
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        segment = _ref[_i];
        _fn(segment);
      }
    };

    Arrow.prototype.On_Follow = function() {
      this.DisablePointerEvents();
      return window.UML.Arrows.Arrow_On_Follow.pulse();
    };

    Arrow.prototype.On_UnFollow = function() {
      this.EnablePointerEvents();
      return window.UML.Arrows.Arrow_Un_Follow.pulse();
    };

    Arrow.prototype.On_Model_Change = function(evt) {};

    return Arrow;

  })();

  window.UML.Arrows.ArrowConnection = (function() {
    function ArrowConnection(arrow) {
      this.arrow = arrow;
      this.currentConnection = null;
      this.connected = false;
    }

    ArrowConnection.prototype.ReconnectTo = function(Class, index) {
      this.Disconnect();
      this.currentConnection = globals.classes.get(Class).Arrows.To;
      this.currentIndex = index;
      this.currentConnection.Attatch(index, this.arrow);
      this.connected = true;
      return Debug.write("Arrow Head connected to Class: " + Class + " at index: " + index);
    };

    ArrowConnection.prototype.ReconnectFrom = function(Class, index) {
      this.Disconnect();
      this.currentConnection = globals.classes.get(Class).Arrows.From;
      this.currentIndex = index;
      this.currentConnection.Attatch(index, this.arrow);
      this.connected = true;
      return Debug.write("Arrow Tail connected from Class: " + Class + " at index: " + index);
    };

    ArrowConnection.prototype.Disconnect = function() {
      if (this.connected) {
        this.currentConnection.Detatch(this.currentIndex, this.arrow);
        this.connected = false;
        return Debug.write("Arrow disconnected to at index: " + this.currentIndex);
      }
    };

    return ArrowConnection;

  })();

  window.UML.Arrows.ArrowHeadPoint = (function(_super) {
    __extends(ArrowHeadPoint, _super);

    function ArrowHeadPoint(arrow, model) {
      this.arrow = arrow;
      this.model = model;
      ArrowHeadPoint.__super__.constructor.call(this, this.arrow, this.model);
      this.endPoint.setAttribute("onmousedown", "window.UML.SetArrowHeadFollow(" + this.arrow.model.get("id") + ")");
      this.model.onChange.add((function(evt) {
        return this.OnModelChange(evt);
      }).bind(this));
      if (this.model.get("Locked") && this.model.get("LockedClass") !== -1 && this.model.get("LockedIndex") !== -1) {
        this.Connection.ReconnectTo(this.model.get("LockedClass"), this.model.get("LockedIndex"));
      }
    }

    ArrowHeadPoint.prototype.OnMouseUp = function(evt) {
      return this.UnFollow();
    };

    ArrowHeadPoint.prototype.Follow = function() {
      ArrowHeadPoint.__super__.Follow.apply(this, arguments);
      this.mouseUpHandle = (function(evt) {
        return this.OnMouseUp(evt);
      }).bind(this);
      document.addEventListener("mouseup", this.mouseUpHandle, false);
      return this.Connection.Disconnect();
    };

    ArrowHeadPoint.prototype.UnFollow = function() {
      if (this.preliminaryLockedData.LockedClass !== this.arrow.model.get("Tail").get("LockedClass") || this.preliminaryLockedData.LockedClass === -1) {
        this.ApplyPrelimineryLockData();
      } else {
        Debug.write("Arrow ConnectionVetoed (same class)");
      }
      this.ResetPreliminery();
      document.removeEventListener("mouseup", this.mouseUpHandle, false);
      this.mouseUpHandle = 0;
      return ArrowHeadPoint.__super__.UnFollow.apply(this, arguments);
    };

    ArrowHeadPoint.prototype.OnModelChange = function(evt) {
      if (evt.name === "Position") {
        this.position.x = evt.new_value.x;
        this.position.y = evt.new_value.y;
      } else if (evt.name === "Locked") {
        this.CheckForConnectionChange();
      } else if (evt.name === "LockedIndex") {
        this.CheckForConnectionChange();
      } else if (evt.name === "LockedClass") {
        this.CheckForConnectionChange();
      }
      return this.arrow.redraw();
    };

    ArrowHeadPoint.prototype.CheckForConnectionChange = function() {
      if (this.model.get("Locked") && this.model.get("LockedClass") !== -1 && this.model.get("LockedIndex") !== -1) {
        this.Connection.ReconnectTo(this.model.get("LockedClass"), this.model.get("LockedIndex"));
        return this.arrow.CheckForArrowTypeChange();
      } else {
        return this.Connection.Disconnect();
      }
    };

    ArrowHeadPoint.prototype.del = function() {
      ArrowHeadPoint.__super__.del.apply(this, arguments);
      return this.Connection.Disconnect();
    };

    return ArrowHeadPoint;

  })(window.UML.Arrows.ArrowEndPoint);

  window.UML.Arrows.ArrowTailPoint = (function(_super) {
    __extends(ArrowTailPoint, _super);

    function ArrowTailPoint(arrow, model) {
      var connectTest;
      this.arrow = arrow;
      this.model = model;
      ArrowTailPoint.__super__.constructor.call(this, this.arrow, this.model);
      this.model.set("Locked", true);
      this.endPoint.setAttribute("onmousedown", "window.UML.SetArrowTailFollow(" + this.arrow.model.get("id") + ")");
      this.model.onChange.add((function(evt) {
        return this.OnModelChange(evt);
      }).bind(this));
      connectTest = this.model.get("Locked");
      connectTest = connectTest && this.model.get("LockedClass") && this.model.get("LockedClass") !== -1;
      connectTest = connectTest && this.model.get("LockedIndex") && this.model.get("LockedIndex") !== -1;
      if (connectTest) {
        this.Connection.ReconnectFrom(this.model.get("LockedClass"), this.model.get("LockedIndex"));
      }
    }

    ArrowTailPoint.prototype.OnMouseUp = function(evt) {
      return this.UnFollow();
    };

    ArrowTailPoint.prototype.Follow = function() {
      ArrowTailPoint.__super__.Follow.apply(this, arguments);
      this.mouseUpHandle = (function(evt) {
        return this.OnMouseUp(evt);
      }).bind(this);
      document.addEventListener("mouseup", this.mouseUpHandle, false);
      return this.Connection.Disconnect();
    };

    ArrowTailPoint.prototype.OnModelChange = function(evt) {
      if (evt.name === "Position") {
        this.position.x = evt.new_value.x;
        this.position.y = evt.new_value.y;
      } else if (evt.name === "Locked") {
        if (!evt.new_value) {
          this.Connection.Disconnect();
        }
      } else if (evt.name === "LockedClass") {
        if (this.model.get("Locked") && this.model.get("LockedClass") !== -1 && this.model.get("LockedIndex") !== -1) {
          this.Connection.ReconnectFrom(this.model.get("LockedClass"), this.model.get("LockedIndex"));
          this.arrow.CheckForArrowTypeChange();
        }
      } else if (evt.name === "LockedIndex") {
        this.lockedIndex = evt.new_value;
      }
      return this.arrow.redraw();
    };

    ArrowTailPoint.prototype.UnFollow = function() {
      if (this.preliminaryLockedData.LockedClass !== this.arrow.model.get("Head").get("LockedClass") || this.preliminaryLockedData.LockedClass === -1) {
        this.ApplyPrelimineryLockData();
      } else {
        Debug.write("Arrow Connection Vetoed (same class)");
      }
      this.ResetPreliminery();
      document.removeEventListener("mouseup", this.mouseUpHandle, false);
      this.mouseUpHandle = 0;
      this.model.set("Position", this.position);
      return ArrowTailPoint.__super__.UnFollow.apply(this, arguments);
    };

    ArrowTailPoint.prototype.del = function() {
      ArrowTailPoint.__super__.del.apply(this, arguments);
      return this.Connection.Disconnect();
    };

    return ArrowTailPoint;

  })(window.UML.Arrows.ArrowEndPoint);

  window.UML.Arrows.Arrows = (function(_super) {
    __extends(Arrows, _super);

    function Arrows(IDResolver) {
      Arrows.__super__.constructor.call(this, IDResolver);
    }

    Arrows.prototype.Create = function(start, end, ownderID, index) {
      var arrowModel;
      arrowModel = new window.UML.MODEL.Arrow();
      arrowModel.model.Tail.setNoLog("Position", start);
      arrowModel.model.Tail.setNoLog("LockedClass", ownderID);
      arrowModel.model.Tail.setNoLog("LockedIndex", index);
      arrowModel.model.Head.setNoLog("Position", end);
      arrowModel.model.Head.setNoLog("LockedClass", -1);
      arrowModel.model.Head.setNoLog("LockedIndex", -1);
      Debug.write("Arrow created with ID: " + arrowModel.modelItemID);
      globals.Model.arrowList.push(arrowModel);
      return globals.arrows.get(arrowModel.modelItemID);
    };

    Arrows.prototype.Listen = function() {
      globals.Model.arrowList.onChange.add((function(evt) {
        return this.OnModelChange(evt);
      }).bind(this));
      return this.Listen = function() {};
    };

    Arrows.prototype.OnModelChange = function(evt) {
      var arrow, _i, _len, _ref, _results;
      if (evt.changeType === "ADD") {
        evt.item.get("Head").setNoLog("Position", window.UML.ModelItemToPoint(evt.item.get("Head").get("Position")));
        evt.item.get("Tail").setNoLog("Position", window.UML.ModelItemToPoint(evt.item.get("Tail").get("Position")));
        arrow = new window.UML.Arrows.Arrow(evt.item);
        globals.arrows.add(arrow);
        return arrow.arrowTail.Connection.ReconnectFrom(evt.item.get("Tail").get("LockedClass"), evt.item.get("Tail").get("LockedIndex"));
      } else if (evt.changeType === "DEL") {
        _ref = globals.arrows.List;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          arrow = _ref[_i];
          if (arrow.model === evt.item) {
            arrow.del();
            break;
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }
    };

    return Arrows;

  })(IDIndexedList);

  window.UML.Arrows.BendPoint = (function() {
    function BendPoint(position, context) {
      this.position = position;
      this.context = context;
      this.displayed = false;
    }

    BendPoint.prototype.GetPosition = function() {
      return this.position;
    };

    BendPoint.prototype.CreateGraphicsObject = function() {
      this.endPoint = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
      this.endPoint.setAttribute("r", "5");
      this.endPoint.setAttribute("cx", this.position.x);
      this.endPoint.setAttribute("cy", this.position.y);
      this.endPoint.setAttribute("class", "ArrowBend");
      this.Draggable = new window.UML.Interaction.Draggable(this.On_Drag_Start.bind(this), this.On_Drag.bind(this), this.On_Drag_End.bind(this), this.endPoint, this.GetPosition.bind(this));
      this.displayed = true;
      return window.UML.globals.document.appendChild(this.endPoint);
    };

    BendPoint.prototype.del = function() {
      this.Hide();
      this.Draggable.detatch_for_GC(this.endPoint);
      this.endpoint = null;
      return this.position = null;
    };

    BendPoint.prototype.Move = function(to) {
      this.position = to;
      this.endPoint.setAttribute("cx", this.position.x);
      this.endPoint.setAttribute("cy", this.position.y);
      this.segment1.Move(to);
      this.segment2.Move(to);
      return this.context.redraw();
    };

    BendPoint.prototype.ResetEndpoint1 = function(segment1) {
      this.segment1 = segment1;
      return this.position = this.segment1.GetPosition();
    };

    BendPoint.prototype.ResetEndpoint2 = function(segment2) {
      this.segment2 = segment2;
      return this.position = this.segment2.GetPosition();
    };

    BendPoint.prototype.On_Drag_Start = function() {};

    BendPoint.prototype.On_Drag = function(to) {
      return this.Move(to);
    };

    BendPoint.prototype.On_Drag_End = function() {};

    BendPoint.prototype.Show = function() {
      this.displayed = true;
      return globals.document.appendChild(this.endPoint);
    };

    BendPoint.prototype.Hide = function() {
      this.displayed = false;
      return globals.document.removeChild(this.endPoint);
    };

    return BendPoint;

  })();

  window.UML.Arrows.EndpointConnector1 = (function() {
    function EndpointConnector1(ref) {
      this.ref = ref;
    }

    EndpointConnector1.prototype.Move = function(to) {
      return this.ref.MoveEnd1(to);
    };

    EndpointConnector1.prototype.GetPosition = function() {
      return this.ref.position1;
    };

    return EndpointConnector1;

  })();

  window.UML.Arrows.EndpointConnector2 = (function() {
    function EndpointConnector2(ref) {
      this.ref = ref;
    }

    EndpointConnector2.prototype.Move = function(to) {
      return this.ref.MoveEnd2(to);
    };

    EndpointConnector2.prototype.GetPosition = function() {
      return this.ref.position2;
    };

    return EndpointConnector2;

  })();

  window.UML.Arrows.LineSegment = (function() {
    function LineSegment(position1, position2) {
      this.position1 = position1;
      this.position2 = position2;
      this.OnClickHandel = (function(evt) {
        return this.On_Click(evt);
      }).bind(this);
      this.OnHoverHandel = (function(evt) {
        return this.On_Hover(evt);
      }).bind(this);
      this.OnLeaveHandel = (function(evt) {
        return this.On_Leave(evt);
      }).bind(this);
      this.Clicked = new Event();
      this.MouseHover = new Event();
      this.MouseLeave = new Event();
      this.endpoint1 = new window.UML.Arrows.EndpointConnector1(this);
      this.endpoint2 = new window.UML.Arrows.EndpointConnector2(this);
    }

    LineSegment.prototype.Connect = function(Connection1, Connection2) {
      this.Connection1 = Connection1;
      this.Connection2 = Connection2;
      this.Connection1.ResetEndpoint1(this.Endpoint1());
      return this.Connection2.ResetEndpoint2(this.Endpoint2());
    };

    LineSegment.prototype.Endpoint1 = function() {
      return this.endpoint1;
    };

    LineSegment.prototype.Endpoint2 = function() {
      return this.endpoint2;
    };

    LineSegment.prototype.MoveEnd1 = function(to) {
      this.position1 = to;
      this.line.setAttribute("x1", this.position1.x);
      this.line.setAttribute("y1", this.position1.y);
      this.hitbox.setAttribute("x1", this.position1.x);
      return this.hitbox.setAttribute("y1", this.position1.y);
    };

    LineSegment.prototype.MoveEnd2 = function(to) {
      this.position2 = to;
      this.line.setAttribute("x2", this.position2.x);
      this.line.setAttribute("y2", this.position2.y);
      this.hitbox.setAttribute("x2", this.position2.x);
      return this.hitbox.setAttribute("y2", this.position2.y);
    };

    LineSegment.prototype.Redraw = function() {
      this.line.setAttribute("x1", this.position1.x);
      this.line.setAttribute("y1", this.position1.y);
      this.hitbox.setAttribute("x1", this.position1.x);
      this.hitbox.setAttribute("y1", this.position1.y);
      this.line.setAttribute("x2", this.position2.x);
      this.line.setAttribute("y2", this.position2.y);
      this.hitbox.setAttribute("x2", this.position2.x);
      return this.hitbox.setAttribute("y2", this.position2.y);
    };

    LineSegment.prototype.del = function() {
      globals.document.removeChild(this.line);
      return globals.document.removeChild(this.hitbox);
    };

    LineSegment.prototype.CreateGraphicsObject = function() {
      this.line = document.createElementNS("http://www.w3.org/2000/svg", 'line');
      this.line.setAttribute("x1", this.position1.x);
      this.line.setAttribute("y1", this.position1.y);
      this.line.setAttribute("x2", this.position2.x);
      this.line.setAttribute("y2", this.position2.y);
      this.line.setAttribute("class", "ArrowLine");
      this.hitbox = document.createElementNS("http://www.w3.org/2000/svg", 'line');
      this.hitbox.setAttribute("style", "fill-opacity:1.0;stroke-width:20");
      this.hitbox.setAttribute("pointer-events", "all");
      this.hitbox.addEventListener("mousedown", this.OnClickHandel, false);
      this.hitbox.addEventListener("mouseover", this.OnHoverHandel, false);
      this.hitbox.addEventListener("mouseleave", this.OnLeaveHandel, false);
      this.hitbox.setAttribute("x1", this.position1.x);
      this.hitbox.setAttribute("y1", this.position1.y);
      this.hitbox.setAttribute("x2", this.position2.x);
      this.hitbox.setAttribute("y2", this.position2.y);
      window.UML.globals.document.appendChild(this.line);
      return window.UML.globals.document.appendChild(this.hitbox);
    };

    LineSegment.prototype.EnablePointerEvents = function() {
      this.line.setAttribute("pointer-events", "all");
      return this.hitbox.setAttribute("pointer-events", "all");
    };

    LineSegment.prototype.DisablePointerEvents = function() {
      this.line.setAttribute("pointer-events", "none");
      return this.hitbox.setAttribute("pointer-events", "none");
    };

    LineSegment.prototype.SetNormalArrow = function() {
      return this.line.setAttribute("stroke-dasharray", "0");
    };

    LineSegment.prototype.SetDashedArrow = function() {
      return this.line.setAttribute("stroke-dasharray", "5, 5");
    };

    LineSegment.prototype.ArrowHover = function() {
      return $(this.line).addClass("ArrowOutlineHover");
    };

    LineSegment.prototype.ArrowUnHover = function() {
      return $(this.line).removeClass("ArrowOutlineHover");
    };

    LineSegment.prototype.On_Click = function(evt) {
      return this.Clicked.pulse(evt);
    };

    LineSegment.prototype.On_Hover = function(evt) {
      evt.lineSegment = this;
      return this.MouseHover.pulse(evt);
    };

    LineSegment.prototype.On_Leave = function(evt) {
      return this.MouseLeave.pulse();
    };

    return LineSegment;

  })();

  leftMouse = 0;

  rightMouse = 2;

  MoveableObject = (function() {
    function MoveableObject(position) {
      this.position = position;
      this.NameChangeHndl = (function(evt) {
        return this.OnNameChange(evt);
      }).bind(this);
      this.myID = this.model.modelItemID;
      if (!this.model.get("Name")) {
        this.model.setNoLog("Name", "Item" + this.myID.toString());
      }
      this.name = new EdiableTextBox(new Point(10, 6), this.model.get("Name"));
      this.name.onSizeChange.add(this.OnTextElemetChangeSizeHandler.bind(this));
      this.name.selectTextOnShow = true;
      this.routeResolver = new RouteResolver();
      this.Size = new Point(150, 200);
      this.Owner = globals.document;
      this.onDelete = new Event();
      this.moveStart = null;
      this.model.set("Position", this.position);
      this.name.onTextChange.add(this.NameChangeHndl);
    }

    MoveableObject.prototype.SetNewOwner = function(Owner) {
      this.Owner = Owner;
    };

    MoveableObject.prototype.GetOwnerFrameOfReffrence = function() {
      return this.Owner.getCTM();
    };

    MoveableObject.prototype.GetPosition = function() {
      return this.position;
    };

    MoveableObject.prototype.Move = function(To) {
      this.position = To;
      return this.Redraw();
    };

    MoveableObject.prototype.OnNameChange = function(evt) {
      return this.model.set("Name", evt.newText);
    };

    MoveableObject.prototype.Del = function() {
      var evt;
      this.Owner.removeChild(this.graphics.group);
      evt = new Object();
      evt.ID = this.myID;
      return this.onDelete.pulse(evt);
    };

    MoveableObject.prototype.Resize = function() {
      var namePosition;
      this.graphics.box.setAttribute("width", this.Size.x);
      this.graphics.box.setAttribute("height", this.Size.y);
      this.graphics.BoxHeader.setAttribute("width", this.Size.x);
      namePosition = new Point((this.Size.x / 2) - this.name.Size.x / 2, this.name.relPosition.y);
      if (namePosition.x < 20) {
        namePosition.x = 20;
      }
      return this.name.Move(namePosition);
    };

    MoveableObject.prototype.Redraw = function() {
      this.graphics.group.setAttribute('transform', "translate(" + this.position.x + "," + this.position.y + ")");
    };

    MoveableObject.prototype.OnTextElemetChangeSizeHandler = function(evt) {
      return this.Resize();
    };

    MoveableObject.prototype.CreateGraphicsObject = function(baseClass) {
      var classes, graphics;
      graphics = new Object();
      graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      graphics.box = document.createElementNS("http://www.w3.org/2000/svg", 'rect');
      graphics.BoxHeader = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.Dragger = new window.UML.Interaction.Draggable(this.ActivateMove.bind(this), this.On_mouse_move.bind(this), this.On_mouse_up.bind(this), graphics.box, this.GetPosition.bind(this));
      graphics.group.setAttribute("class", "classObj");
      classes = "classBox";
      if (typeof baseClass !== 'undefined' && baseClass !== null) {
        classes = classes + " " + baseClass;
      }
      graphics.box.setAttribute("class", classes);
      graphics.box.setAttribute("x", "0");
      graphics.box.setAttribute("y", "0");
      graphics.box.setAttribute("rx", "3");
      graphics.box.setAttribute("ry", "3");
      graphics.box.setAttribute("width", this.Size.x);
      graphics.box.setAttribute("height", "200");
      graphics.box.setAttribute("onmouseover", this.routeResolver.resolveRoute("GlobalObject") + "(" + this.myID + ").OnMouseOverHeader(evt);");
      graphics.box.setAttribute("onmouseout", this.routeResolver.resolveRoute("GlobalObject") + "(" + this.myID + ").OnMouseExitHeader(evt);");
      graphics.BoxHeader.setAttribute("class", "ClassHeaderBar");
      graphics.BoxHeader.setAttribute("x", "0");
      graphics.BoxHeader.setAttribute("y", "0");
      graphics.BoxHeader.setAttribute("width", this.Size.x);
      graphics.BoxHeader.setAttribute("height", "30");
      graphics.BoxHeader.setAttribute("onmouseover", this.routeResolver.resolveRoute("GlobalObject") + "(" + this.myID + ").OnMouseOverHeader(evt);");
      graphics.BoxHeader.setAttribute("onmouseout", this.routeResolver.resolveRoute("GlobalObject") + "(" + this.myID + ").OnMouseExitHeader(evt);");
      graphics.group.appendChild(graphics.box);
      graphics.group.appendChild(graphics.BoxHeader);
      graphics.group.appendChild(this.name.CreateGraphics("ClassName ClassTextAttribute"));
      this.name.Move(new Point((this.Size.x / 2) - this.name.Size.x, this.name.relPosition.y));
      graphics.group.setAttribute('transform', "translate(" + this.position.x + "," + this.position.y + ")");
      this.graphics = graphics;
    };

    MoveableObject.prototype.OnMouseOverHeader = function(evt) {
      return window.UML.globals.highlights.HighlightClass(this);
    };

    MoveableObject.prototype.OnMouseExitHeader = function(evt) {
      return window.UML.globals.highlights.UnHighlightClass(this);
    };

    MoveableObject.prototype.Highlight = function() {
      $(this.graphics.BoxHeader).addClass('ClassHeaderBarHover');
      $(this.graphics.cornerHack).addClass("ClassHeaderBarHover");
      return $(this.graphics.box).addClass("ClassOutlineHover");
    };

    MoveableObject.prototype.Unhighlight = function() {
      $(this.graphics.BoxHeader).removeClass("ClassHeaderBarHover");
      $(this.graphics.cornerHack).removeClass("ClassHeaderBarHover");
      return $(this.graphics.box).removeClass("ClassOutlineHover");
    };

    MoveableObject.prototype.Select = function() {};

    MoveableObject.prototype.deactivate = function() {};

    MoveableObject.prototype.ActivateMove = function(evt) {
      this.graphics.group.setAttribute("pointer-events", "none");
      evt = new Object();
      evt.moveableObject = this;
      this.moveStart = this.position;
      this.prevOwner = this.Owner;
      window.UML.Pulse.MoveableObjectActivated.pulse(evt);
      return this.Select();
    };

    MoveableObject.prototype.On_mouse_move = function(to) {
      return this.Move(to);
    };

    MoveableObject.prototype.On_mouse_up = function(evt) {
      this.graphics.group.setAttribute("pointer-events", "all");
      window.UML.Pulse.MoveableObjectDeActivated.pulse();
      return this.model.set("Position", this.position);
    };

    MoveableObject.prototype.OnModelChange = function(evt) {
      if (evt.name === "Position") {
        return this.Move(evt.new_value);
      }
    };

    return MoveableObject;

  })();

  InheritableObject = (function(_super) {
    __extends(InheritableObject, _super);

    function InheritableObject(position) {
      this.position = position;
      InheritableObject.__super__.constructor.call(this, this.position);
      this.BottomDropZone = new DropZone(0);
      this.TopDropZone = new DropZone(1);
      this.LeftDropZone = new DropZone(2);
      this.RightDropZone = new DropZone(3);
      this.DropZones = [this.BottomDropZone, this.TopDropZone, this.LeftDropZone, this.RightDropZone];
      this.Arrows = new ClassArrows();
    }

    InheritableObject.prototype.Move = function(To) {
      var GlobalCoords;
      InheritableObject.__super__.Move.call(this, To);
      GlobalCoords = window.UML.Utils.getSVGCoordForGroupedElement(this.graphics.box);
      return this.Arrows.Move(GlobalCoords, this.Size.y, this.Size.x);
    };

    InheritableObject.prototype.Del = function() {
      var arrow, arrowList, ref, _fn, _i, _j, _len, _ref, _ref1, _ref2, _results;
      InheritableObject.__super__.Del.call(this);
      ref = this;
      _fn = function(arrowList, ref) {
        var arrow, _j, _len, _ref2, _results;
        _ref2 = ref.Arrows.From[arrowList];
        _results = [];
        for (_j = 0, _len = _ref2.length; _j < _len; _j++) {
          arrow = _ref2[_j];
          _results.push((function(arrow) {
            return arrow.del();
          })(arrow));
        }
        return _results;
      };
      for (arrowList = _i = _ref = this.Arrows.BOTTOM, _ref1 = this.Arrows.RIGHT; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; arrowList = _ref <= _ref1 ? ++_i : --_i) {
        _fn(arrowList, ref);
      }
      _ref2 = globals.arrows.List;
      _results = [];
      for (_j = 0, _len = _ref2.length; _j < _len; _j++) {
        arrow = _ref2[_j];
        _results.push((function(arrow, ref) {
          if (arrow.arrowHead.lockedClass === ref.myID) {
            arrow.arrowHead.lockedClass = -1;
            return arrow.arrowHead.locked = false;
          }
        })(arrow, ref));
      }
      return _results;
    };

    InheritableObject.prototype.Resize = function() {
      var GlobalCoords;
      InheritableObject.__super__.Resize.call(this);
      this.LeftDropZone.Move(new Point(0, this.Size.y / 2));
      this.RightDropZone.Move(new Point(this.Size.x, this.Size.y / 2));
      this.BottomDropZone.Move(new Point(this.Size.x / 2, this.Size.y));
      this.TopDropZone.Move(new Point(this.Size.x / 2, 0));
      GlobalCoords = window.UML.Utils.getSVGCoordForGroupedElement(this.graphics.box);
      return this.Arrows.Move(GlobalCoords, this.Size.y, this.Size.x);
    };

    InheritableObject.prototype.CreateGraphicsObject = function() {
      var bottomdropZoneGraphics, leftdropZoneGraphics, rightdropZoneGraphics, topdropZoneGraphics;
      InheritableObject.__super__.CreateGraphicsObject.call(this);
      this.LeftDropZone.position = new Point(0, this.Size.y / 2);
      this.RightDropZone.position = new Point(this.Size.x, this.Size.y / 2);
      this.BottomDropZone.position = new Point(this.Size.x / 2, this.Size.y);
      this.TopDropZone.position = new Point(this.Size.x / 2, 0);
      leftdropZoneGraphics = this.LeftDropZone.CreateGraphics(this.myID);
      rightdropZoneGraphics = this.RightDropZone.CreateGraphics(this.myID);
      topdropZoneGraphics = this.TopDropZone.CreateGraphics(this.myID);
      bottomdropZoneGraphics = this.BottomDropZone.CreateGraphics(this.myID);
      this.graphics.group.appendChild(bottomdropZoneGraphics.arrowDrop);
      this.graphics.group.insertBefore(topdropZoneGraphics.arrowDrop, this.graphics.box);
      this.graphics.group.appendChild(leftdropZoneGraphics.arrowDrop);
      this.graphics.group.appendChild(rightdropZoneGraphics.arrowDrop);
      this.graphics.group.insertBefore(topdropZoneGraphics.hiddenDropRange, this.graphics.box);
      this.graphics.group.appendChild(bottomdropZoneGraphics.hiddenDropRange);
      this.graphics.group.appendChild(leftdropZoneGraphics.hiddenDropRange);
      return this.graphics.group.appendChild(rightdropZoneGraphics.hiddenDropRange);
    };

    InheritableObject.prototype.Highlight = function() {
      InheritableObject.__super__.Highlight.call(this);
      this.LeftDropZone.Show();
      this.RightDropZone.Show();
      this.BottomDropZone.Show();
      return this.TopDropZone.Show();
    };

    InheritableObject.prototype.Unhighlight = function() {
      InheritableObject.__super__.Unhighlight.call(this);
      this.LeftDropZone.Hide();
      this.RightDropZone.Hide();
      this.BottomDropZone.Hide();
      return this.TopDropZone.Hide();
    };

    return InheritableObject;

  })(MoveableObject);

  Class = (function(_super) {
    __extends(Class, _super);

    function Class(position, model, popoutView) {
      this.position = position;
      this.model = model;
      Class.__super__.constructor.call(this, this.position);
      this.model.onChange.add((function(evt) {
        return this.OnModelChange(evt);
      }).bind(this));
      this.Properties = new EditableTextBoxTable(new Point(15, 35), this.model.get("Properties"));
      this.Properties.onSizeChange.add(this.OnTextElemetChangeSizeHandler.bind(this));
      this.Properties.rowFactory = new PropertyRowFactory();
      this.Properties.routeResolver.createRoute("Class", "window.UML.globals.classes.get(" + this.myID + ")");
      this.Properties.routeResolver.createRoute("Table", "window.UML.globals.classes.get(" + this.myID + ").Properties");
      this.Methods = new EditableTextBoxTable(new Point(15, 105), this.model.get("Methods"));
      this.Methods.rowFactory = new MethodRowFactory(this.model.get("Methods"));
      this.Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get(" + this.myID + ")");
      this.Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get(" + this.myID + ").Methods");
      this.Methods.onSizeChange.add(this.OnTextElemetChangeSizeHandler.bind(this));
      this.Methods.minHeight = 85;
      this.Methods.height = 85;
      this.routeResolver.createRoute("GlobalObject", "window.UML.globals.classes.get");
      this.Attributes = [this.Properties, this.Methods];
      this.ClassPropertyDropDown = new ClassPropertyPopout(new Point(10, 10), popoutView, this.model);
      window.UML.Pulse.TypeNameChanged.pulse({
        prevText: "",
        newText: this.model.get("Name")
      });
    }

    Class.prototype.SetID = function(myID) {
      this.myID = myID;
      this.Properties.routeResolver.createRoute("Class", "window.UML.globals.classes.get(" + this.myID + ")");
      this.Properties.routeResolver.createRoute("Table", "window.UML.globals.classes.get(" + this.myID + ").Properties");
      this.Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get(" + this.myID + ")");
      return this.Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get(" + this.myID + ").Methods");
    };

    Class.prototype.Del = function() {
      Class.__super__.Del.call(this);
      window.UML.Pulse.TypeDeleted.pulse({
        typeText: this.name.text
      });
      return this.name.onTextChange.remove(this.NameChangeHndl);
    };

    Class.prototype.Resize = function() {
      var methodHeight;
      Class.__super__.Resize.call(this);
      this.graphics.propertySeperator.setAttribute("x2", this.Size.x);
      this.graphics.methodSeperator.setAttribute("x2", this.Size.x);
      methodHeight = this.Properties.height + 40;
      this.graphics.methodSeperator.setAttribute("y1", methodHeight);
      this.graphics.methodSeperator.setAttribute("y2", methodHeight);
      this.graphics.methodSeperator2.setAttribute("y1", methodHeight);
      this.graphics.methodSeperator2.setAttribute("y2", methodHeight);
      this.graphics.methodHeader.setAttribute("y", methodHeight + 6);
      this.methodsExpand.MoveDown(methodHeight);
      this.addMethodBttn.MoveDown(methodHeight - 3);
      return this.Methods.Move(new Point(this.Methods.position.x, methodHeight));
    };

    Class.prototype.OnNameChange = function(evt) {
      Class.__super__.OnNameChange.call(this, evt);
      return window.UML.Pulse.TypeNameChanged.pulse(evt);
    };

    Class.prototype.OnTextElemetChangeSizeHandler = function(evt) {
      this.Methods.Resize();
      this.Properties.Resize();
      this.Size.x = (Math.max(this.Properties.width + this.Properties.position.x, this.Methods.width + this.Methods.position.x, this.name.Size.x + 20)) + 7;
      this.Size.y = this.Properties.height + this.Methods.height + 30 + 20;
      return Class.__super__.OnTextElemetChangeSizeHandler.call(this);
    };

    Class.prototype.Highlight = function() {
      Class.__super__.Highlight.call(this);
      this.addPropertyBttn.Show();
      return this.addMethodBttn.Show();
    };

    Class.prototype.Unhighlight = function() {
      Class.__super__.Unhighlight.call(this);
      this.addPropertyBttn.Hide();
      return this.addMethodBttn.Hide();
    };

    Class.prototype.CreateGraphicsObject = function() {
      var headerEndY, propertyHeight;
      Class.__super__.CreateGraphicsObject.call(this);
      this.graphics.propertyHeader = document.createElementNS("http://www.w3.org/2000/svg", 'text');
      this.graphics.methodHeader = document.createElementNS("http://www.w3.org/2000/svg", 'text');
      this.graphics.propertySeperator = document.createElementNS("http://www.w3.org/2000/svg", 'line');
      this.graphics.propertySeperator2 = document.createElementNS("http://www.w3.org/2000/svg", 'line');
      this.graphics.methodSeperator = document.createElementNS("http://www.w3.org/2000/svg", 'line');
      this.graphics.methodSeperator2 = document.createElementNS("http://www.w3.org/2000/svg", 'line');
      headerEndY = parseInt(this.graphics.BoxHeader.getAttribute("x")) + parseInt(this.graphics.BoxHeader.getAttribute("height"));
      propertyHeight = 70;
      this.propertysExpand = new ExpandButton(this.Properties, 3, headerEndY, this.model.get("Properties"));
      this.methodsExpand = new ExpandButton(this.Methods, 3, propertyHeight + headerEndY, this.model.get("Methods"));
      this.addPropertyBttn = new SVGButton("Add", new Point(90, headerEndY - 2));
      this.addMethodBttn = new SVGButton("Add", new Point(80, propertyHeight + headerEndY - 2));
      this.addPropertyBttn.AddOnClick((function() {
        var rowModel;
        rowModel = new window.UML.MODEL.ModelItem();
        rowModel.setNoLog("Name", "name");
        rowModel.setNoLog("Vis", "+");
        rowModel.setNoLog("Type", "type");
        rowModel.setNoLog("Static", false);
        return this.model.get("Properties").get("Items").push(rowModel);
      }).bind(this));
      this.addMethodBttn.AddOnClick((function() {
        var rowModel;
        rowModel = new window.UML.MODEL.ModelItem();
        rowModel.setNoLog("Name", "Method");
        rowModel.setNoLog("Return", "Int");
        rowModel.setNoLog("Vis", "+");
        rowModel.setNoLog("Args", "arg1 : Int, arg2 : Float");
        rowModel.setNoLog("Comment", "");
        rowModel.setNoLog("Static", false);
        rowModel.setNoLog("Absract", false);
        return this.model.get("Methods").get("Items").push(rowModel);
      }).bind(this));
      this.graphics.propertyHeader.setAttribute("x", 25);
      this.graphics.propertyHeader.setAttribute("y", headerEndY + 6);
      this.graphics.propertyHeader.setAttribute("height", 12);
      this.graphics.propertyHeader.setAttribute("width", 40);
      this.graphics.propertyHeader.setAttribute("class", "ClassSectionHeader");
      this.graphics.propertyHeader.textContent = "Properties";
      this.graphics.methodHeader.setAttribute("x", 25);
      this.graphics.methodHeader.setAttribute("y", propertyHeight + headerEndY);
      this.graphics.methodHeader.setAttribute("height", 12);
      this.graphics.methodHeader.setAttribute("width", 40);
      this.graphics.methodHeader.setAttribute("class", "ClassSectionHeader");
      this.graphics.methodHeader.textContent = "Methods";
      this.graphics.propertySeperator.setAttribute("class", "ClassBarSeperator");
      this.graphics.propertySeperator.setAttribute("x1", "90");
      this.graphics.propertySeperator.setAttribute("y1", headerEndY);
      this.graphics.propertySeperator.setAttribute("x2", this.Size.x);
      this.graphics.propertySeperator.setAttribute("y2", headerEndY);
      this.graphics.propertySeperator.setAttribute("height", propertyHeight);
      this.graphics.propertySeperator.setAttribute("stroke", "black");
      this.graphics.propertySeperator2.setAttribute("class", "ClassBarSeperator");
      this.graphics.propertySeperator2.setAttribute("x1", "0");
      this.graphics.propertySeperator2.setAttribute("y1", headerEndY);
      this.graphics.propertySeperator2.setAttribute("x2", 6);
      this.graphics.propertySeperator2.setAttribute("y2", headerEndY);
      this.graphics.propertySeperator2.setAttribute("height", propertyHeight);
      this.graphics.propertySeperator2.setAttribute("stroke", "black");
      this.graphics.methodSeperator.setAttribute("class", "ClassBarSeperator");
      this.graphics.methodSeperator.setAttribute("x1", "80");
      this.graphics.methodSeperator.setAttribute("y1", propertyHeight + headerEndY);
      this.graphics.methodSeperator.setAttribute("x2", this.Size.x);
      this.graphics.methodSeperator.setAttribute("y2", propertyHeight + headerEndY);
      this.graphics.methodSeperator2.setAttribute("class", "ClassBarSeperator");
      this.graphics.methodSeperator2.setAttribute("x1", "0");
      this.graphics.methodSeperator2.setAttribute("y1", propertyHeight + headerEndY);
      this.graphics.methodSeperator2.setAttribute("x2", 6);
      this.graphics.methodSeperator2.setAttribute("y2", propertyHeight + headerEndY);
      this.graphics.group.appendChild(this.Methods.CreateGraphics());
      this.graphics.group.appendChild(this.methodsExpand.CreateGraphics());
      this.graphics.group.appendChild(this.Properties.CreateGraphics());
      this.graphics.group.appendChild(this.propertysExpand.CreateGraphics());
      this.graphics.group.appendChild(this.graphics.propertySeperator);
      this.graphics.group.appendChild(this.graphics.propertySeperator2);
      this.graphics.group.appendChild(this.graphics.methodSeperator);
      this.graphics.group.appendChild(this.graphics.propertyHeader);
      this.graphics.group.appendChild(this.graphics.methodHeader);
      this.graphics.group.appendChild(this.graphics.methodSeperator2);
      this.graphics.group.appendChild(this.addPropertyBttn.CreateGraphics());
      this.graphics.group.appendChild(this.addMethodBttn.CreateGraphics());
      this.graphics.group.appendChild(this.ClassPropertyDropDown.CreateGraphicsObject());
      globals.LayerManager.InsertClassLayer(this.graphics.group);
      this.name.resize();
      this.Properties.Resize();
      this.Methods.Resize();
      this.Resize();
      this.Methods.InitView();
      this.Properties.InitView();
    };

    Class.prototype.OnModelChange = function(evt) {
      if (evt.name === "Name") {
        return this.name.UpdateText(evt.new_value);
      } else {
        return Class.__super__.OnModelChange.call(this, evt);
      }
    };

    return Class;

  })(InheritableObject);

  Interface = (function(_super) {
    __extends(Interface, _super);

    function Interface(position, model, popoutView) {
      this.position = position;
      this.model = model;
      Interface.__super__.constructor.call(this, this.position);
      this.NameChangeHndl = (function(evt) {
        return this.OnNameChange(evt);
      }).bind(this);
      this.model.onChange.add((function(evt) {
        return this.OnModelChange(evt);
      }).bind(this));
      this.IsInterface = true;
      this.Methods = new EditableTextBoxTable(new Point(15, 105), this.model.get("Methods"));
      this.Methods.rowFactory = new MethodRowFactory();
      this.Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get(" + this.myID + ")");
      this.Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get(" + this.myID + ").Methods");
      this.Methods.onSizeChange.add(this.OnTextElemetChangeSizeHandler.bind(this));
      this.Methods.minHeight = 85;
      this.Methods.height = 85;
      this.routeResolver.createRoute("GlobalObject", "window.UML.globals.classes.get");
      this.ClassPropertyDropDown = new ClassPropertyPopout(new Point(15, 15), popoutView, this.model);
      window.UML.Pulse.TypeNameChanged.pulse({
        prevText: "",
        newText: this.model.get("Name")
      });
      this.name.onTextChange.add(this.NameChangeHndl);
      this.minwidth = 150;
    }

    Interface.prototype.SetID = function(myID) {
      this.myID = myID;
      this.Methods.routeResolver.createRoute("Class", "window.UML.globals.classes.get(" + this.myID + ")");
      return this.Methods.routeResolver.createRoute("Table", "window.UML.globals.classes.get(" + this.myID + ").Methods");
    };

    Interface.prototype.Del = function() {
      Interface.__super__.Del.call(this);
      return window.UML.Pulse.TypeDeleted.pulse({
        typeText: this.name.text
      });
    };

    Interface.prototype.OnNameChange = function(evt) {
      this.model.set("Name", evt.newText);
      return window.UML.Pulse.TypeNameChanged.pulse(evt);
    };

    Interface.prototype.Resize = function() {
      Interface.__super__.Resize.call(this);
      this.graphics.methodSeperator.setAttribute("x2", this.Size.x);
      this.graphics.interfaceText.setAttribute("x", (this.Size.x / 2) - this.graphics.interfaceText.getBBox().width / 2);
      return this.Methods.Resize();
    };

    Interface.prototype.OnTextElemetChangeSizeHandler = function(evt) {
      this.Methods.Resize();
      this.Size.x = (Math.max(this.Methods.width + this.Methods.position.x, this.name.Size.x + 20, this.minwidth)) + 7;
      this.Size.y = this.Methods.height + 30 + 20;
      return Interface.__super__.OnTextElemetChangeSizeHandler.call(this);
    };

    Interface.prototype.Highlight = function() {
      Interface.__super__.Highlight.call(this);
      return this.addMethodBttn.Show();
    };

    Interface.prototype.Unhighlight = function() {
      Interface.__super__.Unhighlight.call(this);
      return this.addMethodBttn.Hide();
    };

    Interface.prototype.CreateGraphicsObject = function() {
      var headerEndY, headerHeight;
      Interface.__super__.CreateGraphicsObject.call(this);
      this.graphics.group.setAttribute("class", this.graphics.group.getAttribute("class") + " interfaceObj");
      this.graphics.interfaceText = document.createElementNS("http://www.w3.org/2000/svg", 'text');
      this.graphics.methodSeperator = document.createElementNS("http://www.w3.org/2000/svg", 'line');
      this.graphics.methodHeader = document.createElementNS("http://www.w3.org/2000/svg", 'text');
      this.graphics.methodSeperator2 = document.createElementNS("http://www.w3.org/2000/svg", 'line');
      this.graphics.interfaceText.setAttribute("class", "greyText ClassTextAttribute");
      this.graphics.interfaceText.textContent = "<<Interface>>";
      this.graphics.interfaceText.setAttribute("y", "17");
      this.graphics.BoxHeader.appendChild(this.graphics.interfaceText);
      this.name.Move(new Point(5, 18));
      globals.LayerManager.InsertClassLayer(this.graphics.group);
      headerHeight = this.name.Size.y + this.name.relPosition.y;
      headerEndY = parseInt(this.graphics.BoxHeader.getAttribute("y")) + parseInt(headerHeight) + 10;
      this.methodsExpand = new ExpandButton(this.Methods, 3, headerEndY, this.model.get("Methods"));
      this.addMethodBttn = new SVGButton("Add", new Point(80, headerEndY - 2));
      this.addMethodBttn.AddOnClick((function() {
        var rowModel;
        rowModel = new window.UML.MODEL.ModelItem();
        rowModel.setNoLog("Name", "Method");
        rowModel.setNoLog("Return", "Int");
        rowModel.setNoLog("Vis", "+");
        rowModel.setNoLog("Args", "arg1 : Int, arg2 : Float");
        rowModel.setNoLog("Comment", "");
        rowModel.setNoLog("Static", false);
        rowModel.setNoLog("Absract", false);
        return this.model.get("Methods").get("Items").push(rowModel);
      }).bind(this));
      this.graphics.methodSeperator.setAttribute("class", "ClassBarSeperator");
      this.graphics.methodSeperator.setAttribute("x1", "80");
      this.graphics.methodSeperator.setAttribute("y1", headerEndY);
      this.graphics.methodSeperator.setAttribute("x2", this.Size.x);
      this.graphics.methodSeperator.setAttribute("y2", headerEndY);
      this.graphics.methodSeperator2.setAttribute("class", "ClassBarSeperator");
      this.graphics.methodSeperator2.setAttribute("x1", "0");
      this.graphics.methodSeperator2.setAttribute("y1", headerEndY);
      this.graphics.methodSeperator2.setAttribute("x2", 6);
      this.graphics.methodSeperator2.setAttribute("y2", headerEndY);
      this.graphics.methodHeader.setAttribute("x", 25);
      this.graphics.methodHeader.setAttribute("y", headerEndY + 6);
      this.graphics.methodHeader.setAttribute("height", 12);
      this.graphics.methodHeader.setAttribute("width", 40);
      this.graphics.methodHeader.setAttribute("class", "ClassSectionHeader");
      this.graphics.methodHeader.textContent = "Methods";
      this.graphics.group.appendChild(this.Methods.CreateGraphics({
        0: "+",
        1: "retType",
        2: "name",
        3: "int arg1, float arg2"
      }));
      this.graphics.group.appendChild(this.graphics.methodSeperator);
      this.graphics.group.appendChild(this.graphics.methodSeperator2);
      this.Methods.Move(new Point(15, headerEndY));
      this.graphics.group.appendChild(this.ClassPropertyDropDown.CreateGraphicsObject());
      this.graphics.group.appendChild(this.methodsExpand.CreateGraphics());
      this.graphics.group.appendChild(this.graphics.methodHeader);
      this.graphics.group.appendChild(this.addMethodBttn.CreateGraphics());
      this.name.resize();
      this.Methods.Resize();
      this.Resize();
      this.Methods.InitView();
    };

    Interface.prototype.OnMouseOverHeader = function(evt) {
      return window.UML.globals.highlights.HighlightInterface(this);
    };

    Interface.prototype.OnMouseExitHeader = function(evt) {
      return window.UML.globals.highlights.UnHighlightInterface(this);
    };

    Interface.prototype.OnModelChange = function(evt) {
      if (evt.name === "Name") {
        return this.name.UpdateText(evt.new_value);
      } else {
        return Interface.__super__.OnModelChange.call(this, evt);
      }
    };

    return Interface;

  })(InheritableObject);

  Namespace = (function(_super) {
    __extends(Namespace, _super);

    function Namespace(position, model) {
      var onChangeHandler;
      this.position = position;
      this.model = model;
      Namespace.__super__.constructor.call(this, this.position);
      onChangeHandler = (function(evt) {
        return this.OnModelChange(evt);
      }).bind(this);
      this.model.onChange.add(onChangeHandler);
      this.model.get("classes").onChange.add(onChangeHandler);
      this.Size = this.model.get("Size");
      this.routeResolver.createRoute("GlobalObject", "window.UML.globals.namespaces.get");
      this.resizers = new ResizeDraggers(this);
      this.resizers.onSizeChange.add((function(evt) {
        return this.onDraggerResize(evt);
      }).bind(this));
      this.resizers.onDragEnd.add((function() {
        return this.onDragEnd();
      }).bind(this));
      this.resizers.MinSize = new Point(this.Size.x, this.Size.y);
      this.onMouseOverHandel = (function(evt) {
        return this.onMouseOverWithMoveable(evt);
      }).bind(this);
      this.onMouseExitHandel = (function(evt) {
        return this.onMouseExitWithMoveable(evt);
      }).bind(this);
      this.onChildDeletedHandel = (function(evt) {
        return this.onChildDeleted(evt);
      }).bind(this);
      window.UML.Pulse.MoveableObjectActivated.add((function(evt) {
        return this.onMoveableActivated(evt);
      }).bind(this));
      window.UML.Pulse.MoveableObjectDeActivated.add((function(evt) {
        return this.onMoveableDeactivated(evt);
      }).bind(this));
      this.potentialNewChild = null;
      this.potentialNewChildIsOverMe = false;
      this.contents = new Array();
      this.isNamespace = true;
    }

    Namespace.prototype.Del = function() {
      var child, _i, _len, _ref, _results;
      Namespace.__super__.Del.call(this);
      globals.namespaces.remove(this.myID);
      _ref = this.contents;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(child.model.del());
      }
      return _results;
    };

    Namespace.prototype.Resize = function() {
      Namespace.__super__.Resize.call(this);
      return this.resizers.Resize(this.Size);
    };

    Namespace.prototype.CreateGraphicsObject = function() {
      var childID, _i, _len, _ref;
      Namespace.__super__.CreateGraphicsObject.call(this, "Namespace");
      this.resizers.CreateGraphicsObject();
      globals.LayerManager.InsertNamespaceLayer(this.graphics.group);
      _ref = this.model.get("classes").list;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        childID = _ref[_i];
        this.AddChild(childID.get("classID"));
      }
      this.name.resize();
      return this.Resize();
    };

    Namespace.prototype.onDragEnd = function() {
      return this.model.set("Size", new Point(this.Size.x, this.Size.y));
    };

    Namespace.prototype.onDraggerResize = function(evt) {
      this.Size = evt.newSize;
      return this.Resize();
    };

    Namespace.prototype.onMoveableActivated = function(evt) {
      if (evt.moveableObject !== this) {
        this.graphics.box.addEventListener("mouseover", this.onMouseOverHandel, false);
        return this.graphics.box.addEventListener("mouseout", this.onMouseExitHandel, false);
      }
    };

    Namespace.prototype.onMoveableDeactivated = function(evt) {
      var childIDItem, childItemId, potentialNewChildIsAMemberOfMe, _i, _len, _ref;
      this.graphics.box.removeEventListener("mouseover", this.onMouseOverHandel, false);
      this.graphics.box.removeEventListener("mouselout", this.onMouseExitHandel, false);
      potentialNewChildIsAMemberOfMe = this.contents.indexOf(this.potentialNewChild) !== -1;
      if (this.potentialNewChild !== null && this.potentialNewChildIsOverMe && !potentialNewChildIsAMemberOfMe) {
        childIDItem = new window.UML.MODEL.ModelItem();
        childIDItem.setNoLog("classID", this.potentialNewChild.myID);
        this.model.get("classes").push(childIDItem);
      } else if (this.potentialNewChild !== null && !this.potentialNewChildIsOverMe && potentialNewChildIsAMemberOfMe) {
        _ref = this.model.get("classes").list;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          childItemId = _ref[_i];
          if (childItemId.get("classID") === this.potentialNewChild.myID) {
            this.model.get("classes").remove(childItemId);
          }
        }
      } else if (this.potentialNewChild !== null && this.potentialNewChildIsOverMe && potentialNewChildIsAMemberOfMe) {
        this.recalculateMinimumSize();
      }
      this.potentialNewChildIsOverMe = false;
      this.potentialNewChild = null;
    };

    Namespace.prototype.AddChild = function(newChildID) {
      var childPositionLocal, newChild;
      newChild = window.UML.globals.classes.get(newChildID);
      this.graphics.group.appendChild(newChild.graphics.group);
      childPositionLocal = window.UML.Utils.ConvertFrameOfReffrence(newChild.position, newChild.GetOwnerFrameOfReffrence(), this.graphics.group.getCTM());
      if (childPositionLocal.x < 0) {
        childPositionLocal.x = 10;
      }
      if (childPositionLocal.y < 0) {
        childPositionLocal.y = 50;
      }
      newChild.Move(childPositionLocal);
      newChild.SetNewOwner(this.graphics.group);
      this.contents.push(newChild);
      newChild.onDelete.add(this.onChildDeletedHandel);
      this.resizeForNewChild(newChild);
      return this.recalculateMinimumSize();
    };

    Namespace.prototype.resizeForNewChild = function(newChild) {
      var padding, requiredSize;
      padding = new Point(10, 10);
      requiredSize = newChild.position.add(newChild.Size).add(padding);
      if (this.Size.x < requiredSize.x) {
        this.Size.x = requiredSize.x;
      }
      if (this.Size.y < requiredSize.y) {
        this.Size.y = requiredSize.y;
      }
      return this.Resize();
    };

    Namespace.prototype.onChildDeleted = function(evt) {
      var index;
      index = this.contents.indexOf(evt.ID);
      if (index > -1) {
        this.contents.splice(index, 1);
        return this.model.get("classes").removeAt(index);
      }
    };

    Namespace.prototype.onMouseOverWithMoveable = function(evt) {
      $(this.graphics.box).addClass("namespaceMoveableOver");
      this.potentialNewChild = globals.selections.selectedGroup.selectedItems[0];
      return this.potentialNewChildIsOverMe = true;
    };

    Namespace.prototype.onMouseExitWithMoveable = function(evt) {
      $(this.graphics.box).removeClass("namespaceMoveableOver");
      return this.potentialNewChildIsOverMe = false;
    };

    Namespace.prototype.recalculateMinimumSize = function() {
      var item, minSize, _fn, _i, _len, _ref;
      minSize = new Point(0, 0);
      _ref = this.contents;
      _fn = function(minSize, item) {
        var itemBottemLeft;
        itemBottemLeft = item.position.add(item.Size);
        if (itemBottemLeft.x > minSize.x) {
          minSize.x = itemBottemLeft.x;
        }
        if (itemBottemLeft.y > minSize.y) {
          return minSize.y = itemBottemLeft.y;
        }
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        _fn(minSize, item);
      }
      minSize = minSize.add(new Point(10, 10));
      return this.resizers.UpdateMinimumSize(minSize);
    };

    Namespace.prototype.Move = function(To) {
      var classItem, ref, _i, _len, _ref, _results;
      Namespace.__super__.Move.call(this, To);
      ref = this;
      _ref = this.contents;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        classItem = _ref[_i];
        _results.push((function(classItem, ref) {
          return classItem.Move(classItem.model.get("Position"));
        })(classItem, ref));
      }
      return _results;
    };

    Namespace.prototype.Select = function() {
      return this.resizers.showDraggers(globals.document);
    };

    Namespace.prototype.deactivate = function() {
      return this.resizers.hideDraggers(globals.document);
    };

    Namespace.prototype.OnMouseOverHeader = function(evt) {
      return window.UML.globals.highlights.HighlightNamespace(this);
    };

    Namespace.prototype.OnMouseExitHeader = function(evt) {
      return window.UML.globals.highlights.UnhighlightNamespace(this);
    };

    Namespace.prototype.OnModelChange = function(evt) {
      var classItem, index;
      if (evt.name === "Name") {
        return this.name.UpdateText(evt.new_value);
      } else if (evt.name === "Size") {
        this.Size = evt.new_value;
        return this.Resize();
      } else if (evt.changeType === "ADD") {
        return this.AddChild(evt.item.get("classID"));
      } else if (evt.changeType === "DEL") {
        classItem = window.UML.globals.classes.get(evt.item.get("classID"));
        if (classItem !== null) {
          index = this.contents.indexOf(classItem);
          this.contents.splice(index, 1);
          globals.document.appendChild(classItem.graphics.group);
          return classItem.SetNewOwner(globals.document);
        }
      } else {
        return Namespace.__super__.OnModelChange.call(this, evt);
      }
    };

    return Namespace;

  })(MoveableObject);

  ResizeDragger = (function() {
    function ResizeDragger(Position) {
      this.onSizeChange = new Event();
      this.onDragEnd = new Event();
      this.Position = Position;
      this.rotation = 0;
      this.mousemoveHandle = null;
      this.mousemoveUp = null;
      this.mousedownHandle = (function(evt) {
        return this.On_mouse_down(evt);
      }).bind(this);
    }

    ResizeDragger.prototype.Rotate = function(angle) {
      this.rotation = angle;
      return this.graphics.group.setAttribute("transform", "translate(" + this.Position.x + "," + this.Position.y + ") rotate(" + this.rotation + ")");
    };

    ResizeDragger.prototype.Move = function(To) {
      this.Position = To;
      return this.graphics.group.setAttribute("transform", "translate(" + this.Position.x + "," + this.Position.y + ") rotate(" + this.rotation + ")");
    };

    ResizeDragger.prototype.CreateGraphicsObject = function() {
      this.graphics = new Object();
      this.graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.graphics.leftLine = document.createElementNS("http://www.w3.org/2000/svg", 'line');
      this.graphics.rightLine = document.createElementNS("http://www.w3.org/2000/svg", 'line');
      this.graphics.leftLine.setAttribute("x1", "0");
      this.graphics.leftLine.setAttribute("y1", "0");
      this.graphics.leftLine.setAttribute("x2", "10");
      this.graphics.leftLine.setAttribute("y2", "0");
      this.graphics.rightLine.setAttribute("x1", "0");
      this.graphics.rightLine.setAttribute("y1", "0");
      this.graphics.rightLine.setAttribute("x2", "0");
      this.graphics.rightLine.setAttribute("y2", "10");
      this.graphics.leftLine.setAttribute("class", "Resizer");
      this.graphics.rightLine.setAttribute("class", "Resizer");
      this.graphics.group.setAttribute("transform", "translate(" + this.Position.x + "," + this.Position.y + ") rotate(" + this.rotation + ")");
      this.graphics.group.addEventListener("mousedown", this.mousedownHandle);
      this.graphics.group.appendChild(this.graphics.leftLine);
      this.graphics.group.appendChild(this.graphics.rightLine);
      return this.graphics;
    };

    ResizeDragger.prototype.show = function(docRoot) {
      this.docRoot = docRoot;
      return docRoot.appendChild(this.graphics.group);
    };

    ResizeDragger.prototype.hide = function(docRoot) {
      this.docRoot = docRoot;
      return docRoot.removeChild(this.graphics.group);
    };

    ResizeDragger.prototype.On_mouse_down = function(evt) {
      if (this.mousemoveHandle === null && this.mousemoveUp === null) {
        this.mousemoveHandle = (function(evt) {
          return this.On_mouse_move(evt);
        }).bind(this);
        this.mousemoveUp = (function(evt) {
          return this.On_mouse_up(evt);
        }).bind(this);
        globals.document.addEventListener("mousemove", this.mousemoveHandle, false);
        return globals.document.addEventListener("mouseup", this.mousemoveUp, false);
      }
    };

    ResizeDragger.prototype.On_mouse_move = function(evt) {
      var loc;
      loc = window.UML.Utils.mousePositionFromEvent(evt);
      this.Position = window.UML.Utils.fromSVGCoordForGroupedElement(loc, this.docRoot);
      return this.onSizeChange.pulse(evt);
    };

    ResizeDragger.prototype.On_mouse_up = function(evt) {
      globals.document.removeEventListener("mousemove", this.mousemoveHandle, false);
      globals.document.removeEventListener("mouseup", this.mousemoveUp, false);
      this.mousemoveHandle = null;
      this.mousemoveUp = null;
      return this.onDragEnd.pulse();
    };

    return ResizeDragger;

  })();

  ResizeDraggers = (function() {
    function ResizeDraggers(context) {
      this.context = context;
      this.onSizeChange = new Event();
      this.onDragEnd = new Event();
      this.Size = this.context.Size;
      this.BottomRightDragger = new ResizeDragger(new Point(this.Size.x + 5, this.Size.y + 5));
      this.onBRResizeHandel = (function(evt) {
        return this.On_BR_dragger_resize(evt);
      }).bind(this);
      this.BottomRightDragger.onSizeChange.add(this.onBRResizeHandel);
      this.BottomRightDragger.onDragEnd.add((function() {
        return this.OnDraggerDragEnd();
      }).bind(this));
      this.draggersShown = false;
      this.MinSize = new Point(0, 0);
    }

    ResizeDraggers.prototype.OnDraggerDragEnd = function() {
      return this.onDragEnd.pulse();
    };

    ResizeDraggers.prototype.Resize = function(Size) {
      var bottomRightResizerPos;
      this.Size = Size;
      bottomRightResizerPos = new Point(0, 0);
      if (this.Size.x > this.MinSize.x) {
        bottomRightResizerPos.x = this.Size.x;
      } else {
        bottomRightResizerPos.x = this.MinSize.x;
      }
      if (this.Size.y > this.MinSize.y) {
        bottomRightResizerPos.y = this.Size.y;
      } else {
        bottomRightResizerPos.y = this.MinSize.y;
      }
      return this.BottomRightDragger.Move(bottomRightResizerPos);
    };

    ResizeDraggers.prototype.UpdateMinimumSize = function(MinSize) {
      var bottomRightResizerPos;
      this.MinSize = MinSize;
      bottomRightResizerPos = new Point(0, 0);
      if (this.Size.x > this.MinSize.x) {
        bottomRightResizerPos.x = this.Size.x;
      } else {
        bottomRightResizerPos.x = this.MinSize.x;
      }
      if (this.Size.y > this.MinSize.y) {
        bottomRightResizerPos.y = this.Size.y;
      } else {
        bottomRightResizerPos.y = this.MinSize.y;
      }
      this.BottomRightDragger.Move(bottomRightResizerPos);
      return this.On_BR_dragger_resize();
    };

    ResizeDraggers.prototype.CreateGraphicsObject = function() {
      var BottomRightGraphics;
      BottomRightGraphics = this.BottomRightDragger.CreateGraphicsObject();
      return this.BottomRightDragger.Rotate(180);
    };

    ResizeDraggers.prototype.showDraggers = function() {
      this.draggersShown = true;
      return this.BottomRightDragger.show(this.context.graphics.group);
    };

    ResizeDraggers.prototype.hideDraggers = function() {
      this.draggersShown = false;
      return this.BottomRightDragger.hide(this.context.graphics.group);
    };

    ResizeDraggers.prototype.On_BR_dragger_resize = function(evt) {
      this.Size.x = this.MinSize.x;
      this.Size.y = this.MinSize.y;
      if (this.BottomRightDragger.Position.x > this.MinSize.x) {
        this.Size.x = this.BottomRightDragger.Position.x;
      }
      if (this.BottomRightDragger.Position.y > this.MinSize.y) {
        this.Size.y = this.BottomRightDragger.Position.y;
      }
      evt = new Object();
      evt.newSize = this.Size;
      return this.onSizeChange.pulse(evt);
    };

    return ResizeDraggers;

  })();

  ContextMenu = (function() {
    function ContextMenu() {
      this.initHandle = (function(evt) {
        return this.onInitialise(evt);
      }).bind(this);
      this.backgroundClick = (function(evt) {
        return this.onBackgroundClick(evt);
      }).bind(this);
      this.showContextMenuAddEvtHndl = (function(evt) {
        return this.showContextMenuAddEvt(evt);
      }).bind(this);
      this.showContextMenuAttatchEvtHndl = (function(evt) {
        return this.showContextMenuAttatchEvt(evt);
      }).bind(this);
      this.hideContextMenuHndl = (function(evt) {
        return this.hideContextMenu(evt);
      }).bind(this);
      window.UML.Pulse.Initialise.add(this.initHandle);
      window.UML.Pulse.BackgroundClick.add(this.backgroundClick);
      this.contextMenuOnShow = false;
    }

    ContextMenu.prototype.onBackgroundClick = function(e) {
      if (this.contextMenuOnShow) {
        this.ContextMenuEl.css({
          display: "none"
        });
      }
      return this.contextMenuOnShow = false;
    };

    ContextMenu.prototype.bindContextMenu = function() {
      if (document.addEventListener) {
        document.addEventListener('contextmenu', this.showContextMenuAddEvtHndl, false);
      } else {
        document.attachEvent('oncontextmenu', this.showContextMenuAttatchEvtHndl);
      }
      return this.ContextMenuEl.on("click", "a", this.hideContextMenuHndl);
    };

    ContextMenu.prototype.onInitialise = function() {
      return this.bindContextMenu();
    };

    ContextMenu.prototype.hideContextMenu = function(e) {
      return this.ContextMenuEl.hide();
    };

    ContextMenu.prototype.showContextMenuAddEvt = function(e) {};

    ContextMenu.prototype.showContextMenuAttatchEvt = function() {
      alert("You've tried to open context menu");
      return window.event.returnValue = false;
    };

    return ContextMenu;

  })();

  ArrowMenu = (function(_super) {
    __extends(ArrowMenu, _super);

    function ArrowMenu() {
      ArrowMenu.__super__.constructor.call(this);
    }

    ArrowMenu.prototype.showContextMenuAddEvt = function(e) {
      this.contextMenuOnShow = true;
      if (window.UML.globals.highlights.highlightedArrow !== null) {
        this.Arrow = window.UML.globals.selections.activeArrow;
        this.ContextMenuEl.css({
          display: "block",
          left: e.pageX,
          top: e.pageY
        });
        this.position = window.UML.Utils.mousePositionFromEvent(e);
        return e.preventDefault();
      }
    };

    ArrowMenu.prototype.onInitialise = function() {
      this.ContextMenuEl = $("#ArrowContextMenu");
      return ArrowMenu.__super__.onInitialise.call(this);
    };

    ArrowMenu.prototype.Bend = function() {
      return this.Arrow.Bend(this.position);
    };

    return ArrowMenu;

  })(ContextMenu);

  ClassMenu = (function(_super) {
    __extends(ClassMenu, _super);

    function ClassMenu() {
      ClassMenu.__super__.constructor.call(this);
    }

    ClassMenu.prototype.showContextMenuAddEvt = function(e) {
      this.contextMenuOnShow = true;
      if (window.UML.globals.highlights.highlightedClass !== null) {
        this["class"] = window.UML.globals.highlights.highlightedClass;
        this.ContextMenuEl.css({
          display: "block",
          left: e.pageX,
          top: e.pageY
        });
        return e.preventDefault();
      }
    };

    ClassMenu.prototype.onInitialise = function() {
      this.ContextMenuEl = $("#contextMenu");
      return ClassMenu.__super__.onInitialise.call(this);
    };

    ClassMenu.prototype.AddProperty = function() {
      var rowModel;
      rowModel = new window.UML.MODEL.ModelItem();
      rowModel.setNoLog("Name", "name");
      rowModel.setNoLog("Vis", "+");
      rowModel.setNoLog("Type", "type");
      rowModel.setNoLog("Static", false);
      return this["class"].Properties.model.get("Items").push(rowModel);
    };

    ClassMenu.prototype.AddMethod = function() {
      var rowModel;
      rowModel = new window.UML.MODEL.ModelItem();
      rowModel.setNoLog("Name", "Method");
      rowModel.setNoLog("Return", "Int");
      rowModel.setNoLog("Vis", "+");
      rowModel.setNoLog("Args", "arg1 : Int, arg2 : Float");
      rowModel.setNoLog("Comment", "");
      rowModel.setNoLog("Static", false);
      rowModel.setNoLog("Absract", false);
      return this["class"].Methods.model.get("Items").push(rowModel);
    };

    ClassMenu.prototype.Delete = function() {
      return this["class"].model.del();
    };

    return ClassMenu;

  })(ContextMenu);

  InterfaceMenu = (function(_super) {
    __extends(InterfaceMenu, _super);

    function InterfaceMenu() {
      InterfaceMenu.__super__.constructor.call(this);
    }

    InterfaceMenu.prototype.showContextMenuAddEvt = function(e) {
      this.contextMenuOnShow = true;
      if (window.UML.globals.highlights.highlightedInterface !== null) {
        this.Interface = window.UML.globals.highlights.highlightedInterface;
        this.ContextMenuEl.css({
          display: "block",
          left: e.pageX,
          top: e.pageY
        });
        return e.preventDefault();
      }
    };

    InterfaceMenu.prototype.onInitialise = function() {
      this.ContextMenuEl = $("#interfaceContextMenu");
      return InterfaceMenu.__super__.onInitialise.call(this);
    };

    InterfaceMenu.prototype.AddMethod = function() {
      var rowModel;
      rowModel = new window.UML.MODEL.ModelItem();
      rowModel.setNoLog("Name", "Method");
      rowModel.setNoLog("Return", "Int");
      rowModel.setNoLog("Vis", "+");
      rowModel.setNoLog("Args", "arg1 : Int, arg2 : Float");
      rowModel.setNoLog("Comment", "");
      rowModel.setNoLog("Static", false);
      rowModel.setNoLog("Absract", false);
      return this.Interface.Methods.model.get("Items").push(rowModel);
    };

    InterfaceMenu.prototype.Delete = function() {
      return this.Interface.model.del();
    };

    return InterfaceMenu;

  })(ContextMenu);

  NamespaceMenu = (function(_super) {
    __extends(NamespaceMenu, _super);

    function NamespaceMenu() {
      NamespaceMenu.__super__.constructor.call(this);
    }

    NamespaceMenu.prototype.showContextMenuAddEvt = function(e) {
      this.contextMenuOnShow = true;
      if (window.UML.globals.highlights.highlightedNamespace !== null) {
        this.Namespace = window.UML.globals.highlights.highlightedNamespace;
        this.ContextMenuEl.css({
          display: "block",
          left: e.pageX,
          top: e.pageY
        });
        return e.preventDefault();
      }
    };

    NamespaceMenu.prototype.onInitialise = function() {
      this.ContextMenuEl = $("#namespaceContextMenu");
      return NamespaceMenu.__super__.onInitialise.call(this);
    };

    NamespaceMenu.prototype.Delete = function() {
      return this.Namespace.Del();
    };

    return NamespaceMenu;

  })(ContextMenu);

  SelectedGroup = (function() {
    function SelectedGroup() {
      this.selectedItems = new Array();
    }

    SelectedGroup.prototype.add = function(item) {
      return this.selectedItems.push(item);
    };

    SelectedGroup.prototype.clear = function() {
      return this.selectedItems.length = 0;
    };

    SelectedGroup.prototype.move = function() {};

    SelectedGroup.prototype.del = function() {
      var item, _fn, _i, _len, _ref;
      _ref = this.selectedItems;
      _fn = function(item) {
        if (item.hasOwnProperty("model")) {
          return item.model.del();
        } else {
          return item.del();
        }
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        _fn(item);
      }
      return this.clear();
    };

    SelectedGroup.prototype.deactivate = function() {
      var item, _fn, _i, _len, _ref;
      _ref = this.selectedItems;
      _fn = function(item) {
        return item.deactivate();
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        _fn(item);
      }
      return this.clear();
    };

    SelectedGroup.prototype.copy = function() {};

    return SelectedGroup;

  })();

  window.UML.Pulse.SingleArrowActivated = new Event();

  window.UML.Pulse.BackgroundClick = new Event();

  window.UML.Pulse.MoveableObjectActivated = new Event();

  window.UML.Pulse.MoveableObjectDeActivated = new Event();

  Selections = (function() {
    function Selections() {
      this.selectedGroup = new SelectedGroup();
      this.activeClass = -1;
      this.activeArrow = -1;
      this.moveableObjectActive = false;
      this.singleArrowSelectedHandel = (function(evt) {
        return this.onSingleArrowSelected(evt);
      }).bind(this);
      this.backgroundClickHandel = (function(evt) {
        return this.onBackgroundClick(evt);
      }).bind(this);
      this.textboxSelectedHandle = (function(evt) {
        return this.onTextBoxSelected(evt);
      }).bind(this);
      this.textboxGroupSelectedHandle = (function(evt) {
        return this.onTextBoxGroupSelected(evt);
      }).bind(this);
      this.onMoveableObjectSelectHandle = (function(evt) {
        return this.onMoveableObjectSelect(evt);
      }).bind(this);
      this.onMoveableObjectDeSelectHandle = (function(evt) {
        return this.onMoveableObjectDeSelect(evt);
      }).bind(this);
      window.UML.Pulse.SingleArrowActivated.add(this.singleArrowSelectedHandel);
      window.UML.Pulse.BackgroundClick.add(this.backgroundClickHandel);
      window.UML.Pulse.TextBoxSelected.add(this.textboxSelectedHandle);
      window.UML.Pulse.TextBoxGroupSelected.add(this.textboxGroupSelectedHandle);
      window.UML.Pulse.MoveableObjectActivated.add(this.onMoveableObjectSelectHandle);
      window.UML.Pulse.MoveableObjectDeActivated.add(this.onMoveableObjectDeSelectHandle);
    }

    Selections.prototype.onBackgroundClick = function(evt) {
      this.selectedGroup.deactivate();
      this.activeArrow = -1;
      this.selectedGroup.clear();
    };

    Selections.prototype.onSingleArrowSelected = function(evt) {
      this.selectedGroup.deactivate();
      this.activeArrow = evt.arrow;
      this.selectedGroup.clear();
      this.selectedGroup.add(this.activeArrow);
    };

    Selections.prototype.onMoveableObjectSelect = function(evt) {
      this.selectedGroup.deactivate();
      this.selectedGroup.clear();
      this.selectedGroup.add(evt.moveableObject);
      this.moveableObjectActive = true;
    };

    Selections.prototype.onMoveableObjectDeSelect = function(evt) {
      this.moveableObjectActive = false;
    };

    Selections.prototype.onTextBoxGroupSelected = function(evt) {
      this.selectedGroup.deactivate();
      return this.selectedGroup.add(evt.textBoxGroup);
    };

    Selections.prototype.onTextBoxSelected = function(evt) {};

    return Selections;

  })();

  window.UML.StringTree.Node = (function() {
    function Node(myChar) {
      this.myChar = myChar;
      this.children = new IDIndexedList(function(item) {
        return item.myChar;
      });
      this.leafValue = null;
    }

    Node.prototype.NewString = function(string, index) {
      var code;
      if (index === string.length - 1) {
        return this.leafValue = string;
      } else {
        code = string.toUpperCase().charCodeAt(index);
        if (this.children.get(code) === null) {
          this.children.add(new window.UML.StringTree.Node(code));
        }
        return this.children.get(code).NewString(string, index + 1);
      }
    };

    Node.prototype.Remove = function(string, index) {
      var child, childDeleted, code;
      if (index === string.length - 1) {
        this.leafValue = null;
      } else {
        code = string.toUpperCase().charCodeAt(index);
        child = this.children.get(code);
        if (child !== null) {
          childDeleted = child.Remove(string, index + 1);
          if (childDeleted) {
            this.children.remove(child.myChar);
          }
        }
      }
      if (this.children.List.length === 0) {
        return true;
      }
      return false;
    };

    Node.prototype.ListChildren = function(list) {
      var child, _i, _len, _ref, _results;
      if (this.leafValue !== null) {
        list.push(this.leafValue);
      }
      _ref = this.children.List;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push((function(child) {
          return child.ListChildren(list);
        })(child));
      }
      return _results;
    };

    return Node;

  })();

  window.UML.StringTree.StringTree = (function() {
    function StringTree() {
      this.rootNode = new window.UML.StringTree.Node();
    }

    StringTree.prototype.IsRoot = function(node) {
      return node === this.rootNode;
    };

    StringTree.prototype.Build = function(string) {
      return this.rootNode.NewString(string, 0);
    };

    StringTree.prototype.Remove = function(string) {
      return this.rootNode.Remove(string, 0);
    };

    StringTree.prototype.GetSelections = function(string) {
      var node;
      node = this.FindRootNode(this.rootNode, string);
      if (node === null) {
        node = this.rootNode;
      }
      return node;
    };

    StringTree.prototype.FindRootNode = function(node, string) {
      var child;
      if (string.length > 0) {
        child = node.children.get(string.toUpperCase().charCodeAt(0));
        if (child) {
          return this.FindRootNode(child, string.substring(1));
        } else {
          return null;
        }
      } else {
        return node;
      }
    };

    return StringTree;

  })();

  window.UML.MODEL.ModelItems = new IDIndexedList(function(modelItem) {
    return modelItem.modelItemID;
  });

  window.UML.MODEL.ModelItem = (function() {
    function ModelItem(IDOverride) {
      if (IDOverride == null) {
        IDOverride = -1;
      }
      if (IDOverride !== -1) {
        this.modelItemID = IDOverride;
        window.UML.MODEL.ModelGlobalUtils.ItemIDManager.AllocateOverrideID(IDOverride);
      } else {
        this.modelItemID = window.UML.MODEL.ModelGlobalUtils.ItemIDManager.AllocateID();
      }
      window.UML.MODEL.ModelItems.add(this);
      this.model = new Object();
      this.onChange = new Event();
      this.onChangeInternal = new Event();
      this.onDelete = new Event();
      this.modelValid = true;
      window.UML.MODEL.ModelGlobalUtils.listener.ListenToNewMode(this);
    }

    ModelItem.prototype.flagAsInvalid = function() {
      return this.modelValid = false;
    };

    ModelItem.prototype.flagAsValid = function() {
      return this.modelValid = true;
    };

    ModelItem.prototype.setNoLog = function(name, value, pulseAnyway) {
      if (pulseAnyway == null) {
        pulseAnyway = false;
      }
      if (this.modelValid && (pulseAnyway || this.model[name] !== value)) {
        this.model[name] = value;
        this.onChange.pulse({
          modelID: this.modelItemID,
          name: name,
          new_value: value,
          prev_value: this.model[name]
        });
        return this.onChangeInternal.pulse({
          modelID: this.modelItemID,
          name: name,
          new_value: value,
          prev_value: this.model[name]
        });
      }
    };

    ModelItem.prototype.set = function(name, value) {
      var evt;
      if (this.modelValid && this.model[name] !== value) {
        evt = {
          modelID: this.modelItemID,
          name: name,
          prev_value: this.model[name],
          value: value
        };
        globals.CtrlZBuffer.Push(evt);
        return this.setNoLog(name, value);
      }
    };

    ModelItem.prototype.setFromNetwork = function(name, value, pulseAnyway) {
      if (pulseAnyway == null) {
        pulseAnyway = false;
      }
      if (this.modelValid && (pulseAnyway || this.model[name] !== value)) {
        this.model[name] = value;
        return this.onChange.pulse({
          modelID: this.modelItemID,
          name: name,
          new_value: value,
          prev_value: this.model[name]
        });
      }
    };

    ModelItem.prototype.setGroup = function(keyValues) {
      var evt, keyValue, names, newValues, previousValues, ref, _fn, _i, _len;
      if (this.modelValid) {
        ref = this;
        names = [];
        previousValues = [];
        newValues = [];
        _fn = function(ref, keyValue) {
          names.push(keyValue.name);
          previousValues.push(ref.model[keyValue.name]);
          newValues.push(keyValue.value);
          return ref.setNoLog(keyValue.name, keyValue.value, true);
        };
        for (_i = 0, _len = keyValues.length; _i < _len; _i++) {
          keyValue = keyValues[_i];
          _fn(ref, keyValue);
        }
        evt = {
          modelID: this.modelItemID,
          names: names,
          prev_values: previousValues,
          newValues: newValues
        };
        return globals.CtrlZBuffer.Push(evt);
      }
    };

    ModelItem.prototype.get = function(name) {
      return this.model[name];
    };

    ModelItem.prototype.del = function() {
      var item, value, _ref;
      _ref = this.model;
      for (item in _ref) {
        value = _ref[item];
        if (value && (value.hasOwnProperty("modelItemID") || value.hasOwnProperty("modelListID"))) {
          value.del();
        }
      }
      window.UML.MODEL.ModelItems.remove(this.modelItemID);
      return this.onDelete.pulse({
        item: this
      });
    };

    return ModelItem;

  })();

  window.UML.MODEL.Arrow = (function(_super) {
    __extends(Arrow, _super);

    function Arrow() {
      Arrow.__super__.constructor.call(this);
      this.setNoLog("Head", new window.UML.MODEL.ModelItem());
      this.setNoLog("Tail", new window.UML.MODEL.ModelItem());
    }

    return Arrow;

  })(window.UML.MODEL.ModelItem);

  window.UML.MODEL.Class = (function(_super) {
    __extends(Class, _super);

    function Class() {
      Class.__super__.constructor.call(this);
      this.setNoLog("Properties", new window.UML.MODEL.ModelItem());
      this.setNoLog("Methods", new window.UML.MODEL.ModelItem());
      this.get("Properties").setNoLog("Items", new window.UML.MODEL.ModelList());
      this.get("Methods").setNoLog("Items", new window.UML.MODEL.ModelList());
    }

    return Class;

  })(window.UML.MODEL.ModelItem);

  window.UML.MODEL.Interface = (function(_super) {
    __extends(Interface, _super);

    function Interface() {
      Interface.__super__.constructor.call(this);
      this.setNoLog("Methods", new window.UML.MODEL.ModelItem());
      this.get("Methods").setNoLog("Items", new window.UML.MODEL.ModelList);
    }

    return Interface;

  })(window.UML.MODEL.ModelItem);

  window.UML.MODEL.MODEL = (function() {
    function MODEL() {
      this.classList = new window.UML.MODEL.ModelList();
      this.interfaceList = new window.UML.MODEL.ModelList();
      this.namespaceList = new window.UML.MODEL.ModelList();
      this.arrowList = new window.UML.MODEL.ModelList();
    }

    MODEL.prototype.clearModel = function() {
      this.classList.clear();
      this.interfaceList.clear();
      this.namespaceList.clear();
      return this.arrowList.clear();
    };

    return MODEL;

  })();

  window.UML.MODEL.ModelIDManager = (function() {
    function ModelIDManager(IDRequester) {
      this.IDRequester = IDRequester;
      this.workingSet = new Array();
      this.overridenIDs = new Array();
      this.requestOutstanding = false;
    }

    ModelIDManager.prototype.SetIdRequester = function(IDRequester) {
      this.IDRequester = IDRequester;
    };

    ModelIDManager.prototype.ClearValidIds = function() {
      this.workingSet = [];
      return this.IDRequester.FlushIDs();
    };

    ModelIDManager.prototype.ClearOverrideIDs = function() {
      return this.overridenIDs = [];
    };

    ModelIDManager.prototype.AllocateID = function() {
      if (this.workingSet.length <= 10 && !this.requestOutstanding) {
        this.RequestMoreIds();
      }
      if (this.workingSet.length <= 1) {
        window.CodeCooker.HighLatency.setHighLatensy();
      }
      return this.workingSet.shift();
    };

    ModelIDManager.prototype.AllocateOverrideID = function(id) {
      if (id >= 0 && this.overridenIDs.indexOf(id) !== -1) {
        Debug.write("duplicate id overide requsted for id: " + id);
      }
      this.overridenIDs.push(id);
      if (this.workingSet.indexOf(id) !== -1) {
        this.workingSet.splice(this.workingSet.indexOf(id), 1);
      }
      return this.IDRequester.allocateOverrideID(id);
    };

    ModelIDManager.prototype.AddToWorkingSet = function(start, end) {
      var _i, _results;
      Debug.write("Receved more ids");
      window.CodeCooker.HighLatency.clearHighLatensy();
      this.workingSet = this.workingSet.concat((function() {
        _results = [];
        for (var _i = start; start <= end ? _i <= end : _i >= end; start <= end ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this));
      return this.requestOutstanding = false;
    };

    ModelIDManager.prototype.RequestMoreIds = function() {
      Debug.write("Requesting more Ids");
      this.requestOutstanding = true;
      return this.IDRequester.Request();
    };

    return ModelIDManager;

  })();

  window.UML.MODEL.ModelLists = new IDIndexedList(function(modelList) {
    return modelList.modelListID;
  });

  window.UML.MODEL.ModelList = (function() {
    function ModelList(IDOverride) {
      if (IDOverride == null) {
        IDOverride = -1;
      }
      if (IDOverride !== -1) {
        this.modelListID = IDOverride;
        window.UML.MODEL.ModelGlobalUtils.ListIDManager.AllocateOverrideID(IDOverride);
      } else {
        this.modelListID = window.UML.MODEL.ModelGlobalUtils.ListIDManager.AllocateID();
      }
      window.UML.MODEL.ModelLists.add(this);
      this.list = new Array();
      this.onChange = new Event();
      this.onChangeInternal = new Event();
      this.onDelete = new Event();
      this.onDeleteHandler = (function(evt) {
        return this.onChildDelete(evt);
      }).bind(this);
      window.UML.MODEL.ModelGlobalUtils.listener.ListenToNewMode(this);
    }

    ModelList.prototype.pushNoLog = function(item) {
      var evt;
      this.list.push(item);
      item.onDelete.add(this.onDeleteHandler);
      evt = {
        modelListID: this.modelListID,
        changeType: "ADD",
        item: item
      };
      this.onChange.pulse(evt);
      this.onChangeInternal.pulse(evt);
      return evt;
    };

    ModelList.prototype.pushFromNetwork = function(item) {
      var evt;
      this.list.push(item);
      item.onDelete.add(this.onDeleteHandler);
      evt = {
        modelListID: this.modelListID,
        changeType: "ADD",
        item: item
      };
      this.onChange.pulse(evt);
      return evt;
    };

    ModelList.prototype.push = function(item) {
      var evt;
      evt = this.pushNoLog(item);
      return globals.CtrlZBuffer.Push(evt);
    };

    ModelList.prototype.removeAtNoLog = function(index) {
      var evt, removed;
      removed = this.list.splice(index, 1);
      if (removed.length > 0) {
        removed[0].flagAsInvalid();
        evt = {
          modelListID: this.modelListID,
          changeType: "DEL",
          item: removed[0]
        };
        this.onChange.pulse(evt);
        this.onChangeInternal.pulse(evt);
        removed[0].onDelete.remove(this.onDeleteHandler);
        removed[0].onDelete.pulse(evt);
        return evt;
      }
      return false;
    };

    ModelList.prototype.removeAt = function(index) {
      var evt;
      evt = this.removeAtNoLog(index);
      if (evt) {
        return globals.CtrlZBuffer.Push(evt);
      }
    };

    ModelList.prototype.remove = function(item) {
      var itemIndex;
      itemIndex = this.list.indexOf(item);
      if (itemIndex > -1) {
        return this.removeAt(itemIndex);
      }
    };

    ModelList.prototype.removeFromNetwork = function(item) {
      var evt, itemIndex, removed;
      itemIndex = this.list.indexOf(item);
      if (itemIndex > -1) {
        removed = this.list.splice(itemIndex, 1);
        if (removed.length > 0) {
          removed[0].flagAsInvalid();
          evt = {
            modelListID: this.modelListID,
            changeType: "DEL",
            item: removed[0]
          };
          this.onChange.pulse(evt);
          removed[0].onDelete.remove(this.onDeleteHandler);
          removed[0].onDelete.pulse(evt);
          return evt;
        }
        return false;
      }
    };

    ModelList.prototype.removeNoLog = function(item) {
      var itemIndex;
      itemIndex = this.list.indexOf(item);
      if (itemIndex > -1) {
        return this.removeAtNoLog(itemIndex);
      }
    };

    ModelList.prototype.onChildDelete = function(evt) {
      return this.remove(evt.item);
    };

    ModelList.prototype.clear = function() {
      while (this.list.length > 0) {
        this.list[0].del();
      }
      return this.list = [];
    };

    ModelList.prototype.del = function() {
      this.clear();
      this.onDelete.pulse({
        item: this
      });
      return window.UML.MODEL.ModelLists.remove(this.modelListID);
    };

    return ModelList;

  })();

  window.UML.MODEL.ModelListener = (function() {
    function ModelListener(modelLists, modelItems) {
      var item, list, _i, _j, _len, _len1;
      this.onModelChange = new Event();
      for (_i = 0, _len = modelLists.length; _i < _len; _i++) {
        list = modelLists[_i];
        this.ListenToNewMode(list);
      }
      for (_j = 0, _len1 = modelItems.length; _j < _len1; _j++) {
        item = modelItems[_j];
        this.ListenToNewMode(item);
      }
      this.PulseModelChangeFunc = function(evt) {
        return this.onModelChange.pulse(evt);
      };
    }

    ModelListener.prototype.ListenToNewMode = function(model) {
      return model.onChangeInternal.add(this.PulseModelChange.bind(this));
    };

    ModelListener.prototype.StopListening = function() {
      return this.PulseModelChangeFunc = function(evt) {};
    };

    ModelListener.prototype.PulseModelChange = function(evt) {
      return this.PulseModelChangeFunc(evt);
    };

    return ModelListener;

  })();

  window.UML.MODEL.Namespace = (function(_super) {
    __extends(Namespace, _super);

    function Namespace() {
      Namespace.__super__.constructor.call(this);
      this.Children = new window.UML.MODEL.ModelList();
    }

    return Namespace;

  })(window.UML.MODEL.ModelItem);

  window.UML.CollaberationSyncBuffer.SyncBuffer = (function() {
    function SyncBuffer() {
      this.modelBufferedItems = new IDIndexedList(function(item) {
        return item.modelItemID;
      });
    }

    SyncBuffer.prototype.addItem = function(item) {
      if (item.hasOwnProperty("modelID")) {
        return this.addItemUpdate(item);
      } else if (item.hasOwnProperty("modelListID")) {
        return this.addListUpdate(item);
      } else {
        return Debug.write("invalid Model object supplied for network update: " + item);
      }
    };

    SyncBuffer.prototype.addItemUpdate = function(item) {
      var modelItem;
      modelItem = window.UML.MODEL.ModelItems.get(item.modelID);
      if (modelItem !== null) {
        return this.assignNewValue(item, modelItem);
      } else {
        return this.createNewItem(item);
      }
    };

    SyncBuffer.prototype.createNewItem = function(item) {
      var modelItem;
      modelItem = new window.UML.MODEL.ModelItem(item.modelID);
      return this.assignNewValue(item, modelItem);
    };

    SyncBuffer.prototype.assignNewValue = function(update, modelItem) {
      var key, modelList, newmodelItem, value, _ref;
      if (update.new_value.hasOwnProperty("modelListID")) {
        modelList = new window.UML.MODEL.ModelList(update.new_value.modelListID);
        return modelItem.setFromNetwork(update.name, modelList);
      } else if (update.new_value.hasOwnProperty("modelItemID")) {
        newmodelItem = window.UML.MODEL.ModelItems.get(update.new_value.modelItemID);
        if (newmodelItem === null) {
          newmodelItem = new window.UML.MODEL.ModelItem(update.new_value.modelItemID);
        }
        return modelItem.setFromNetwork(update.name, newmodelItem);
      } else {
        if (window.UML.typeIsObject(update.new_value)) {
          if (modelItem.get(update.name)) {
            _ref = update.new_value;
            for (key in _ref) {
              value = _ref[key];
              modelItem.get(update.name)[key] = value;
            }
            return modelItem.setFromNetwork(update.name, modelItem.get(update.name), true);
          } else {
            return modelItem.setFromNetwork(update.name, this.inferType(update.new_value));
          }
        } else {
          return modelItem.setFromNetwork(update.name, update.new_value);
        }
      }
    };

    SyncBuffer.prototype.inferType = function(value) {
      if (value.hasOwnProperty("x") && value.hasOwnProperty("y")) {
        return new Point(value.x, value.y);
      }
    };

    SyncBuffer.prototype.addListUpdate = function(list) {
      var listItem, listModelItem, listModellist, modelItem;
      listItem = window.UML.MODEL.ModelLists.get(list.modelListID);
      if (listItem !== null) {
        if (list.changeType === "ADD") {
          if (list.item.hasOwnProperty("modelItemID")) {
            listModelItem = list.item;
            modelItem = window.UML.MODEL.ModelItems.get(listModelItem.modelItemID);
            if (modelItem === null) {
              this.createNewItem(listModelItem);
              modelItem = window.UML.MODEL.ModelItems.get(listModelItem.modelItemID);
            }
            return listItem.pushFromNetwork(modelItem);
          } else if (list.item.hasOwnProperty("modelListID")) {
            return Debug.write("Adding list to list Unimplemented ERROR: ");
          } else {
            return Debug.write("invalid model item requested to append to list: " + list.item);
          }
        } else if (list.changeType === "DEL") {
          if (list.item.hasOwnProperty("modelItemID")) {
            listModelItem = list.item;
            modelItem = window.UML.MODEL.ModelItems.get(listModelItem.modelItemID);
            if (modelItem === null) {
              Debug.write("invalid model item requested to append to list: " + list.item);
            }
            return listItem.removeFromNetwork(modelItem);
          } else if (list.item.hasOwnProperty("modelListID")) {
            listModellist = list.item;
            listModellist = window.UML.MODEL.ModelLists.get(list.modelListID);
            if (listModellist === null) {
              Debug.write("invalid model list requested to append to list: " + list.item);
            }
            return listItem.removeFromNetwork(listModellist);
          }
        }
      }
    };

    return SyncBuffer;

  })();

  Namespaces = (function(_super) {
    __extends(Namespaces, _super);

    function Namespaces(IDResolver) {
      Namespaces.__super__.constructor.call(this, IDResolver);
    }

    Namespaces.prototype.Create = function() {
      var namespaceModel, pos;
      pos = window.UML.findEmptySpaceOnScreen();
      namespaceModel = new window.UML.MODEL.Namespace();
      namespaceModel.setNoLog("Size", new Point(150, 200));
      namespaceModel.setNoLog("Position", pos);
      namespaceModel.setNoLog("classes", new window.UML.MODEL.ModelList());
      globals.Model.namespaceList.push(namespaceModel);
      return this.get(namespaceModel.get("id"));
    };

    Namespaces.prototype.Listen = function() {
      globals.Model.namespaceList.onChange.add((function(evt) {
        return this.OnModelChange(evt);
      }).bind(this));
      return this.Listen = function() {};
    };

    Namespaces.prototype.OnModelChange = function(evt) {
      var namespaceItem, newNamespace, _i, _len, _ref, _results;
      if (evt.changeType === "ADD") {
        evt.item.flagAsValid();
        evt.item.setNoLog("Position", window.UML.ModelItemToPoint(evt.item.get("Position")));
        evt.item.setNoLog("Size", window.UML.ModelItemToPoint(evt.item.get("Size")));
        newNamespace = new Namespace(evt.item.get("Position"), evt.item);
        newNamespace.CreateGraphicsObject();
        newNamespace.Move(evt.item.get("Position"));
        return this.add(newNamespace);
      } else if (evt.changeType === "DEL") {
        _ref = globals.namespaces.List;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          namespaceItem = _ref[_i];
          if (namespaceItem.model === evt.item) {
            namespaceItem.Del();
            this.remove(namespaceItem.myID);
            break;
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }
    };

    return Namespaces;

  })(IDIndexedList);

  ClassArrows = (function() {
    function ClassArrows() {
      this.To = new ClassArrowHead();
      this.From = new ClassArrowTail();
      this.position = new Point(0, 0);
      return;
    }

    ClassArrows.prototype.Move = function(to, height, width) {
      var half_height, half_width;
      half_width = width / 2;
      half_height = height / 2;
      this.To.Move(to, height, width, half_height, half_width);
      return this.From.Move(to, height, width, half_height, half_width);
    };

    return ClassArrows;

  })();

  ClassArrowsGroup = (function() {
    function ClassArrowsGroup() {
      this.BOTTOM = 0;
      this.TOP = 1;
      this.LEFT = 2;
      this.RIGHT = 3;
      this.Content = new Array(new Array(), new Array(), new Array(), new Array());
    }

    ClassArrowsGroup.prototype.Attatch = function(index, arrow) {
      if (index >= 0 && index <= 3 && this.Content[index].indexOf(arrow) === -1) {
        return this.Content[index].push(arrow);
      }
    };

    ClassArrowsGroup.prototype.Detatch = function(index, arrow) {
      var arrowIndex;
      arrowIndex = this.Content[index].indexOf(arrow);
      if (arrowIndex >= 0) {
        this.Content[index].splice(arrowIndex, 1);
        return this.content;
      }
    };

    return ClassArrowsGroup;

  })();

  ClassArrowHead = (function(_super) {
    __extends(ClassArrowHead, _super);

    function ClassArrowHead() {
      ClassArrowHead.__super__.constructor.call(this);
    }

    ClassArrowHead.prototype.Move = function(position, height, width, half_height, half_width) {
      var arrow, _fn, _fn1, _fn2, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _ref2, _ref3, _results;
      _ref = this.Content[this.BOTTOM];
      _fn = function(arrow) {
        var arrowHeadPosition;
        arrowHeadPosition = arrow.arrowHead.model.get("Position");
        arrowHeadPosition.x = position.x + half_width;
        arrowHeadPosition.y = position.y + height;
        return arrow.redraw();
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        arrow = _ref[_i];
        _fn(arrow);
      }
      _ref1 = this.Content[this.TOP];
      _fn1 = function(arrow) {
        var arrowHeadPosition;
        arrowHeadPosition = arrow.arrowHead.model.get("Position");
        arrowHeadPosition.x = position.x + half_width;
        arrowHeadPosition.y = position.y;
        return arrow.redraw();
      };
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        arrow = _ref1[_j];
        _fn1(arrow);
      }
      _ref2 = this.Content[this.LEFT];
      _fn2 = function(arrow) {
        var arrowHeadPosition;
        arrowHeadPosition = arrow.arrowHead.model.get("Position");
        arrowHeadPosition.x = position.x;
        arrowHeadPosition.y = position.y + half_height;
        return arrow.redraw();
      };
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        arrow = _ref2[_k];
        _fn2(arrow);
      }
      _ref3 = this.Content[this.RIGHT];
      _results = [];
      for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
        arrow = _ref3[_l];
        _results.push((function(arrow) {
          var arrowHeadPosition;
          arrowHeadPosition = arrow.arrowHead.model.get("Position");
          arrowHeadPosition.x = position.x + width;
          arrowHeadPosition.y = position.y + half_height;
          return arrow.redraw();
        })(arrow));
      }
      return _results;
    };

    return ClassArrowHead;

  })(ClassArrowsGroup);

  ClassArrowTail = (function(_super) {
    __extends(ClassArrowTail, _super);

    function ClassArrowTail() {
      ClassArrowTail.__super__.constructor.call(this);
    }

    ClassArrowTail.prototype.Move = function(position, height, width, half_height, half_width) {
      var arrow, _fn, _fn1, _fn2, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _ref2, _ref3, _results;
      _ref = this.Content[this.BOTTOM];
      _fn = function(arrow) {
        var arrowTailPosition;
        arrowTailPosition = arrow.arrowTail.model.get("Position");
        arrowTailPosition.x = position.x + half_width;
        arrowTailPosition.y = position.y + height;
        return arrow.redraw();
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        arrow = _ref[_i];
        _fn(arrow);
      }
      _ref1 = this.Content[this.TOP];
      _fn1 = function(arrow) {
        var arrowTailPosition;
        arrowTailPosition = arrow.arrowTail.model.get("Position");
        arrowTailPosition.x = position.x + half_width;
        arrowTailPosition.y = position.y;
        return arrow.redraw();
      };
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        arrow = _ref1[_j];
        _fn1(arrow);
      }
      _ref2 = this.Content[this.LEFT];
      _fn2 = function(arrow) {
        var arrowTailPosition;
        arrowTailPosition = arrow.arrowTail.model.get("Position");
        arrowTailPosition.x = position.x;
        arrowTailPosition.y = position.y + half_height;
        return arrow.redraw();
      };
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        arrow = _ref2[_k];
        _fn2(arrow);
      }
      _ref3 = this.Content[this.RIGHT];
      _results = [];
      for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
        arrow = _ref3[_l];
        _results.push((function(arrow) {
          var arrowTailPosition;
          arrowTailPosition = arrow.arrowTail.model.get("Position");
          arrowTailPosition.x = position.x + width;
          arrowTailPosition.y = position.y + half_height;
          return arrow.redraw();
        })(arrow));
      }
      return _results;
    };

    return ClassArrowTail;

  })(ClassArrowsGroup);

  ClassPropertyPopout = (function() {
    function ClassPropertyPopout(Position, view, model) {
      this.Position = Position;
      this.view = view;
      this.model = model;
      this.mouseUpHandle = (function(evt) {
        return this.onMouseUp(evt);
      }).bind(this);
    }

    ClassPropertyPopout.prototype.CreateGraphicsObject = function() {
      this.graphics = new Object();
      this.graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.graphics.buttonCircle = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
      this.graphics.arrowOne = document.createElementNS("http://www.w3.org/2000/svg", 'polyline');
      this.graphics.arrowTwo = document.createElementNS("http://www.w3.org/2000/svg", 'polyline');
      this.graphics.group.setAttribute("transform", "translate(" + this.Position.x + "," + this.Position.y + ")");
      this.graphics.buttonCircle.setAttribute("class", "classPropertyDropdown");
      this.graphics.buttonCircle.setAttribute("cx", "0");
      this.graphics.buttonCircle.setAttribute("cy", "0");
      this.graphics.buttonCircle.setAttribute("r", "7");
      this.graphics.buttonCircle.addEventListener("mouseup", this.mouseUpHandle);
      this.graphics.arrowOne.setAttribute("points", "-5,-3 0,0 5,-3");
      this.graphics.arrowOne.setAttribute("class", "classPropertyArrow");
      this.graphics.arrowOne.setAttribute("pointer-events", "none");
      this.graphics.arrowTwo.setAttribute("points", "-5,0 0,3 5,0");
      this.graphics.arrowTwo.setAttribute("class", "classPropertyArrow");
      this.graphics.arrowTwo.setAttribute("pointer-events", "none");
      this.graphics.group.appendChild(this.graphics.buttonCircle);
      this.graphics.group.appendChild(this.graphics.arrowOne);
      this.graphics.group.appendChild(this.graphics.arrowTwo);
      return this.graphics.group;
    };

    ClassPropertyPopout.prototype.onMouseUp = function() {
      var StaticString, VisibilityString, evt, popoverLink, textBoxString, windowCoord;
      evt = new Object();
      evt.textBoxGroup = this;
      window.UML.Pulse.TextBoxGroupSelected.pulse(evt);
      windowCoord = window.UML.Utils.getScreenCoordForCircleSVGElement(this.graphics.group);
      popoverLink = this.view.popover();
      popoverLink.css("top", windowCoord.y + 7);
      popoverLink.css("left", windowCoord.x);
      popoverLink.attr("data-original-title", "Class Properties");
      VisibilityString = "<div class=\"popoverRow\"> <span class=\"popOverItem\">Visibility: </span><select id=\"classVisibiltySelect\" class=\"popOverItem popoverSelect\"><option value=\"Public\" ";
      if (this.model.get("vis") === "Public") {
        VisibilityString += " selected ";
      }
      VisibilityString += ">Public</option><option value=\"Protected\"";
      if (this.model.get("vis") === "Protected") {
        VisibilityString += " selected ";
      }
      VisibilityString += ">Protected</option><option value=\"Private\" ";
      if (this.model.get("vis") === "Private") {
        VisibilityString += " selected ";
      }
      VisibilityString += ">Private</option></select></div>";
      if (this.model.get("Static")) {
        StaticString = "<div class=\"popoverRow\"><input type=\"checkbox\" checked id=\"Static\">Static</div>";
      } else {
        StaticString = "<div class=\"popoverRow\"><input type=\"checkbox\" id=\"Static\">Static</div>";
      }
      textBoxString = "<div><span>Class Description:</span><textarea id=\"classPropertyDescription\">";
      textBoxString += this.model.get("Comment");
      textBoxString += "</textarea></div>";
      popoverLink.attr("data-content", VisibilityString + "<br>" + StaticString + textBoxString + "<h5><small>Right click on classes to add methods and members</small></h5>");
      return popoverLink.popover('show');
    };

    ClassPropertyPopout.prototype.deactivate = function() {
      var popoverLink, visibilitySelect;
      popoverLink = this.view.popover();
      visibilitySelect = this.view.visibility();
      this.model.set("vis", visibilitySelect.val());
      this.model.set("st", this.view["static"]().is(':checked'));
      this.model.set("Comment", this.view.comment().val());
      return popoverLink.popover('destroy');
    };

    return ClassPropertyPopout;

  })();

  ClassText = (function() {
    function ClassText(relPosition, classID, AttributeIndex) {
      this.relPosition = relPosition;
      this.classID = classID;
      this.AttributeIndex = AttributeIndex;
      this.onSizeChange = new Event();
      this.height = 65;
      this.width = 142;
      this.minWidth = 142;
      this.minHeight = 65;
    }

    ClassText.prototype.Move = function(to) {
      this.to = to;
      this.relPosition = this.to;
      return this.graphics.group.setAttribute("transform", "translate(" + this.relPosition.x + " " + this.relPosition.y + ")");
    };

    ClassText.prototype.Resize = function() {
      this.graphics.border.setAttribute("height", this.height);
      return this.graphics.border.setAttribute("width", this.width);
    };

    ClassText.prototype.CreateGraphics = function(text) {
      this.text = text;
      this.graphics = new Object();
      this.graphics.group = document.createElementNS("http://www.w3.org/2000/svg", 'g');
      this.graphics.text = document.createElementNS("http://www.w3.org/2000/svg", 'text');
      this.graphics.tspan = document.createElementNS("http://www.w3.org/2000/svg", 'tspan');
      this.graphics.border = document.createElementNS("http://www.w3.org/2000/svg", 'rect');
      this.graphics.text.setAttribute("x", 1);
      this.graphics.text.setAttribute("y", 5);
      this.graphics.text.setAttribute("class", "classAttribute");
      this.graphics.text.setAttribute("onmouseover", "window.UML.globals.classes[" + this.classID + "].Attributes[" + this.AttributeIndex + "].onMouseOver(evt);");
      this.graphics.text.setAttribute("onclick", "window.UML.globals.classes[" + this.classID + "].Attributes[" + this.AttributeIndex + "].onClick(evt);");
      this.graphics.tspan.setAttribute("x", 10);
      this.graphics.tspan.setAttribute("dy", "1.2em");
      this.graphics.tspan.textContent = this.text;
      this.graphics.text.appendChild(this.graphics.tspan);
      this.graphics.border.setAttribute("stroke", "none");
      this.graphics.border.setAttribute("x", 1);
      this.graphics.border.setAttribute("y", 1);
      this.graphics.border.setAttribute("height", this.height);
      this.graphics.border.setAttribute("width", this.width);
      this.graphics.border.setAttribute("fill", "white");
      this.graphics.border.setAttribute("onmouseout", "window.UML.globals.classes[" + this.classID + "].Attributes[" + this.AttributeIndex + "].onMouseExit(evt);");
      this.graphics.border.setAttribute("onmouseover", "window.UML.globals.classes[" + this.classID + "].Attributes[" + this.AttributeIndex + "].onMouseOver(evt);");
      this.graphics.border.setAttribute("onclick", "window.UML.globals.classes[" + this.classID + "].Attributes[" + this.AttributeIndex + "].onClick(evt);");
      this.graphics.group.setAttribute("transform", "translate(" + this.relPosition.x + " " + this.relPosition.y + ")");
      this.graphics.group.appendChild(this.graphics.border);
      this.graphics.group.appendChild(this.graphics.text);
      return this.graphics;
    };

    ClassText.prototype.onClick = function(evt) {
      this.currentEditBox = document.createElement("textArea");
      this.currentBackground = document.createElement("div");
      this.currentEditBox.value = this.text;
      this.currentEditBox.setAttribute("type", "text");
      this.currentEditBox.setAttribute("style", "position: absolute;height: 200px;width: 400px;margin: -100px 0 0 -200px;top: 50%; left: 50%;");
      this.currentBackground.setAttribute("style", "background-color: rgba(0,0,0,0.4); height:100%; width:100%; position:fixed; top:0px; left:0px; right:0px; bottom:0px");
      this.currentEditBox.setAttribute("onBlur", "window.UML.globals.classes[" + this.classID + "].Attributes[" + this.AttributeIndex + "].onBlur();");
      this.currentBackground.appendChild(this.currentEditBox);
      document.getElementById('WorkArea').appendChild(this.currentBackground);
      return this.currentEditBox.focus();
    };

    ClassText.prototype.onBlur = function() {
      this.text = this.currentEditBox.value;
      this.repopulateText(this.text);
      return this.currentBackground.parentNode.removeChild(this.currentBackground);
    };

    ClassText.prototype.repopulateText = function(text) {
      var properties, property, ref, _fn, _i, _len;
      properties = text.split("\n");
      this.graphics.text.textContent = "";
      ref = this;
      _fn = function(property, ref) {
        var newSpan;
        newSpan = document.createElementNS("http://www.w3.org/2000/svg", 'tspan');
        newSpan.setAttribute("x", 10);
        newSpan.setAttribute("dy", "1.2em");
        newSpan.textContent = property;
        ref.graphics.text.appendChild(newSpan);
      };
      for (_i = 0, _len = properties.length; _i < _len; _i++) {
        property = properties[_i];
        _fn(property, ref);
      }
      this.recalculateSize();
      this.graphics.border.setAttribute("height", this.height);
      this.graphics.border.setAttribute("width", this.width);
      return this.onSizeChange.pulse(null);
    };

    ClassText.prototype.onMouseOver = function(evt) {
      return this.graphics.border.setAttribute("stroke", "#3385D6");
    };

    ClassText.prototype.onMouseExit = function(evt) {
      return this.graphics.border.setAttribute("stroke", "none");
    };

    ClassText.prototype.recalculateSize = function() {
      var newHeight, newWidth;
      newWidth = this.graphics.text.getBBox().width;
      newHeight = this.graphics.text.getBBox().height;
      this.width = this.calculateWidth(newWidth);
      return this.height = this.calculateHeight(newHeight);
    };

    ClassText.prototype.calculateWidth = function(newWidth) {
      var sizeToUse;
      sizeToUse = this.width;
      if (newWidth > this.width - 20) {
        sizeToUse = newWidth + 40;
      } else if (newWidth < this.width - 50) {
        sizeToUse = newWidth + 40;
      }
      return Math.max(this.minWidth, sizeToUse);
    };

    ClassText.prototype.calculateHeight = function(newHeight) {
      return Math.max(newHeight, this.minHeight);
    };

    return ClassText;

  })();

  classes = (function(_super) {
    __extends(classes, _super);

    function classes(IDResolver) {
      classes.__super__.constructor.call(this, IDResolver);
    }

    classes.prototype.Create = function() {
      var classModel, classPos, methodModel, propertyModel;
      classPos = window.UML.findEmptySpaceOnScreen();
      classModel = new window.UML.MODEL.Class();
      classModel.setNoLog("id", classModel.modelItemID);
      classModel.setNoLog("Comment", "");
      classModel.setNoLog("Position", classPos);
      classModel.setNoLog("vis", "Public");
      propertyModel = new window.UML.MODEL.ModelItem();
      propertyModel.setNoLog("Name", "name");
      propertyModel.setNoLog("Vis", "+");
      propertyModel.setNoLog("Type", "Int");
      propertyModel.setNoLog("Static", false);
      classModel.get("Properties").get("Items").pushNoLog(propertyModel);
      methodModel = new window.UML.MODEL.ModelItem();
      methodModel.setNoLog("Name", "Method");
      methodModel.setNoLog("Return", "Int");
      methodModel.setNoLog("Vis", "+");
      methodModel.setNoLog("Args", "arg1 : Int, arg2 : Float");
      methodModel.setNoLog("Comment", "");
      methodModel.setNoLog("Static", false);
      methodModel.setNoLog("Absract", false);
      classModel.get("Methods").get("Items").pushNoLog(methodModel);
      globals.Model.classList.push(classModel);
      return this.get(classModel.modelItemID);
    };

    classes.prototype.CreateInterface = function() {
      var classPos, interfaceModel, interfacePos, methodModel;
      classPos = window.UML.findEmptySpaceOnScreen();
      interfacePos = window.UML.findEmptySpaceOnScreen();
      interfaceModel = new window.UML.MODEL.Interface();
      interfaceModel.setNoLog("id", interfaceModel.modelItemID);
      interfaceModel.setNoLog("Comment", "");
      interfaceModel.setNoLog("Position", classPos);
      interfaceModel.setNoLog("vis", "Public");
      methodModel = new window.UML.MODEL.ModelItem();
      methodModel.setNoLog("Name", "Method");
      methodModel.setNoLog("Return", "Int");
      methodModel.setNoLog("Vis", "+");
      methodModel.setNoLog("Args", "arg1 : Int, arg2 : Float");
      methodModel.setNoLog("Comment", "");
      methodModel.setNoLog("Static", false);
      methodModel.setNoLog("Absract", false);
      interfaceModel.get("Methods").get("Items").pushNoLog(methodModel);
      globals.Model.interfaceList.push(interfaceModel);
      return this.get(interfaceModel.modelItemID);
    };

    classes.prototype.Listen = function() {
      globals.Model.classList.onChange.add((function(evt) {
        return this.OnModelChange(evt);
      }).bind(this));
      globals.Model.interfaceList.onChange.add((function(evt) {
        return this.OnInterfaceModelChange(evt);
      }).bind(this));
      return this.Listen = function() {};
    };

    classes.prototype.OnModelChange = function(evt) {
      var classItem, newClass, _i, _len, _ref, _results;
      if (evt.changeType === "ADD") {
        evt.item.flagAsValid();
        evt.item.setNoLog("Position", window.UML.ModelItemToPoint(evt.item.get("Position")));
        newClass = new Class(evt.item.get("Position"), evt.item, {
          popover: function() {
            return $('#popoverLink');
          },
          visibility: function() {
            return $('#classVisibiltySelect');
          },
          "static": function() {
            return $('#Static');
          },
          comment: function() {
            return $("#classPropertyDescription");
          }
        });
        newClass.CreateGraphicsObject();
        return this.add(newClass);
      } else if (evt.changeType === "DEL") {
        _ref = globals.classes.List;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          classItem = _ref[_i];
          if (classItem.model === evt.item) {
            classItem.Del();
            this.remove(classItem.myID);
            break;
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }
    };

    classes.prototype.OnInterfaceModelChange = function(evt) {
      var classItem, newClass, _i, _len, _ref, _results;
      if (evt.changeType === "ADD") {
        evt.item.setNoLog("Position", window.UML.ModelItemToPoint(evt.item.get("Position")));
        newClass = new Interface(evt.item.get("Position"), evt.item, {
          popover: function() {
            return $('#popoverLink');
          },
          visibility: function() {
            return $('#classVisibiltySelect');
          },
          "static": function() {
            return $('#Static');
          },
          comment: function() {
            return $("#classPropertyDescription");
          }
        });
        newClass.CreateGraphicsObject();
        return this.add(newClass);
      } else if (evt.changeType === "DEL") {
        _ref = globals.classes.List;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          classItem = _ref[_i];
          if (classItem.model === evt.item) {
            classItem.Del();
            this.remove(classItem.myID);
            break;
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }
    };

    return classes;

  })(IDIndexedList);

  classCreatePos = new Point(50, 50);

  window.UML.findEmptySpaceOnScreen = function() {
    classCreatePos.x += 10;
    if (classCreatePos.x > 500) {
      classCreatePos.y += 100;
      classCreatePos.x = 50;
    }
    return window.UML.Utils.getSVGCorrdforScreenPos(classCreatePos);
  };

  window.UML.CreateClass = function() {
    var newClass;
    newClass = globals.classes.Create();
    return newClass;
  };

  window.UML.CreateClassForDocInit = function(id) {
    var classModel, classPos, newClass;
    classModel = new window.UML.MODEL.Class();
    classPos = window.UML.findEmptySpaceOnScreen();
    classModel.setNoLog("Position", classPos);
    classModel.setNoLog("id", id);
    globals.Model.classList.push(classModel);
    newClass = globals.classes.get(id);
    return newClass;
  };

  window.UML.CreateInterface = function() {
    var newInterface;
    newInterface = globals.classes.CreateInterface();
    return newInterface;
  };

  window.UML.CreateInterfaceForDocInit = function(id) {
    var interfaceModel, interfacePos, newInterface;
    interfaceModel = new window.UML.MODEL.Interface();
    interfacePos = window.UML.findEmptySpaceOnScreen();
    interfaceModel.setNoLog("Position", interfacePos);
    interfaceModel.setNoLog("id", id);
    globals.Model.interfaceList.push(interfaceModel);
    newInterface = globals.classes.get(id);
    return newInterface;
  };

  window.UML.CreateNamespace = function() {
    var newNamespace;
    newNamespace = globals.namespaces.Create();
    return newNamespace;
  };

  window.UML.CreateNamespaceForDocInit = function(id) {
    var namespaceModel, newNamespace, pos;
    pos = window.UML.findEmptySpaceOnScreen();
    namespaceModel = new window.UML.MODEL.Namespace();
    namespaceModel.setNoLog("Size", new Point(150, 200));
    namespaceModel.setNoLog("id", id);
    namespaceModel.setNoLog("Position", pos);
    newNamespace = new Namespace(pos, namespaceModel);
    newNamespace.CreateGraphicsObject();
    newNamespace.Move(pos);
    globals.namespaces.add(newNamespace);
    globals.Model.namespaceList.push(namespaceModel);
    return newNamespace;
  };

  window.UML.Ctrlz.CtrlzBuffer = (function() {
    function CtrlzBuffer() {
      this.ZBufferStack = new Array();
      this.UndoHandl = this.Undo.bind(this);
      this.RedoHandl = this.Redo.bind(this);
      this.bufferSize = 30;
      this.bufferIndex = -1;
      this.started = false;
    }

    CtrlzBuffer.prototype.Start = function() {
      window.UML.globals.KeyboardListener.RegisterKeyWithAlthernate(window.UML.AlternateKeys.CTRL, 'Z'.charCodeAt(0), this.UndoHandl);
      window.UML.globals.KeyboardListener.RegisterKeyWithAlthernate(window.UML.AlternateKeys.CTRL, 'Y'.charCodeAt(0), this.RedoHandl);
      return this.started = true;
    };

    CtrlzBuffer.prototype.flushBuffer = function() {
      this.ZBufferStack = [];
      return this.bufferIndex = -1;
    };

    CtrlzBuffer.prototype.Push = function(action) {
      if (this.started) {
        if (this.ZBufferStack.length > this.bufferSize) {
          this.ZBufferStack.shift();
          this.bufferIndex--;
        }
        this.bufferIndex++;
        this.ZBufferStack[this.bufferIndex] = action;
        return this.ZBufferStack.splice(this.bufferIndex + 1, this.bufferSize - this.bufferIndex);
      }
    };

    CtrlzBuffer.prototype.Redo = function() {
      var redoAction;
      redoAction = this.ZBufferStack[this.bufferIndex + 1];
      if (redoAction) {
        this.bufferIndex++;
        Debug.write("Redo Action: " + Debug.unpack(redoAction));
        return this.SendAction(redoAction);
      }
    };

    CtrlzBuffer.prototype.clone = function(obj) {
      var attr, copy;
      if (null === obj || "object" !== typeof obj) {
        return obj;
      }
      copy = obj.constructor();
      for (attr in obj) {
        if (obj.hasOwnProperty(attr)) {
          copy[attr] = obj[attr];
        }
      }
      return copy;
    };

    CtrlzBuffer.prototype.Undo = function() {
      var undoAction;
      undoAction = this.ZBufferStack[this.bufferIndex];
      if (undoAction) {
        this.bufferIndex--;
        undoAction = this.InvertAction(this.clone(undoAction));
        Debug.write("Undo Action: " + Debug.unpack(undoAction));
        return this.SendAction(undoAction);
      }
    };

    CtrlzBuffer.prototype.InvertAction = function(action) {
      var prevValue, prevValues;
      if (action.hasOwnProperty("modelListID")) {
        if (action.changeType === "DEL") {
          action.changeType = "ADD";
        } else {
          action.changeType = "DEL";
        }
      } else if (action.hasOwnProperty("modelID")) {
        if (action.hasOwnProperty("names")) {
          prevValues = action.prev_values;
          action.prev_values = action.values;
          action.values = prevValues;
        } else {
          prevValue = action.prev_value;
          action.prev_value = action.values;
          action.value = prevValue;
        }
      }
      return action;
    };

    CtrlzBuffer.prototype.SendAction = function(action) {
      var i, modelItem, modelList, _i, _ref, _results;
      if (action) {
        if (action.hasOwnProperty("modelListID")) {
          modelList = window.UML.MODEL.ModelLists.get(action.modelListID);
          if (action.changeType === "DEL") {
            return modelList.removeNoLog(action.item);
          } else if (action.changeType === "ADD") {
            return modelList.pushNoLog(action.item);
          }
        } else if (action.hasOwnProperty("modelID")) {
          if (action.hasOwnProperty("names")) {
            _results = [];
            for (i = _i = 0, _ref = action.names.length; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
              _results.push((function(i) {
                var modelItem;
                modelItem = window.UML.MODEL.ModelItems.get(action.modelID);
                return modelItem.setNoLog(action.names[i], action.values[i]);
              })(i));
            }
            return _results;
          } else {
            modelItem = window.UML.MODEL.ModelItems.get(action.modelID);
            return modelItem.setNoLog(action.name, action.value);
          }
        }
      }
    };

    return CtrlzBuffer;

  })();

  Debug = {};

  Debug.IsDebug = false;

  Debug.Startup = function() {
    if (!Debug.IsDebug) {
      Debug.write = function(msg) {};
      return Debug.unpack = function(obj) {
        return "";
      };
    }
  };

  Debug.write = function(msg) {
    return console.log("CODE COOKER DEBUG MESSAGE: " + msg);
  };

  Debug.unpack = function(obj) {
    return JSON.stringify(obj);
  };

  window.CodeCooker = window.CodeCooker || {};

  window.CodeCooker.Debug = Debug;

  window.UML.Pulse.DropZoneEnter = new Event();

  window.UML.Pulse.DropZoneLeave = new Event();

  DropZone = (function() {
    function DropZone(index) {
      this.index = index;
      window.UML.Arrows.Arrow_On_Follow.add(this.Show.bind(this));
      window.UML.Arrows.Arrow_Un_Follow.add(this.Hide.bind(this));
    }

    DropZone.prototype.Move = function(To) {
      this.position = To;
      return this.Redraw();
    };

    DropZone.prototype.CreateGraphics = function(classID) {
      this.classID = classID;
      this.graphics = new Object();
      this.graphics.arrowDrop = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
      this.graphics.arrowDrop.setAttribute("cx", this.position.x);
      this.graphics.arrowDrop.setAttribute("cy", this.position.y);
      this.graphics.arrowDrop.setAttribute("r", "3");
      this.graphics.arrowDrop.setAttribute("style", "fill:none");
      this.graphics.hiddenDropRange = document.createElementNS("http://www.w3.org/2000/svg", 'circle');
      this.graphics.hiddenDropRange.setAttribute("onmousedown", "window.UML.globals.classes.get(" + this.classID + ").DropZones[" + this.index + "].OnMouseDown(evt);");
      this.graphics.hiddenDropRange.setAttribute("class", "dropZone");
      this.graphics.hiddenDropRange.setAttribute("cx", this.position.x);
      this.graphics.hiddenDropRange.setAttribute("cy", this.position.y);
      this.graphics.hiddenDropRange.setAttribute("r", "20");
      this.graphics.hiddenDropRange.setAttribute("style", "fill-opacity:0.0");
      this.graphics.hiddenDropRange.setAttribute("onmouseover", "window.UML.globals.classes.get(" + this.classID + ").DropZones[" + this.index + "].OnMouseOver(evt);");
      this.graphics.hiddenDropRange.setAttribute("onmouseout", "window.UML.globals.classes.get(" + this.classID + ").DropZones[" + this.index + "].OnMouseOut(evt)");
      return this.graphics;
    };

    DropZone.prototype.Redraw = function() {
      this.graphics.arrowDrop.setAttribute("cx", this.position.x);
      this.graphics.arrowDrop.setAttribute("cy", this.position.y);
      this.graphics.hiddenDropRange.setAttribute("cx", this.position.x);
      return this.graphics.hiddenDropRange.setAttribute("cy", this.position.y);
    };

    DropZone.prototype.Hide = function() {
      return this.graphics.arrowDrop.setAttribute("style", "fill:none");
    };

    DropZone.prototype.Show = function() {
      return this.graphics.arrowDrop.setAttribute("style", "fill:black");
    };

    DropZone.prototype.OnMouseOver = function(evt) {
      $(this.graphics.hiddenDropRange).animate({
        'fill-opacity': 0.15
      }, 100);
      evt.position = this.GetSnapPosition();
      evt.classID = this.classID;
      evt.index = this.index;
      return window.UML.Pulse.DropZoneEnter.pulse(evt);
    };

    DropZone.prototype.OnMouseOut = function(evt) {
      $(this.graphics.hiddenDropRange).stop();
      this.graphics.hiddenDropRange.setAttribute("style", "fill-opacity:0.0");
      return window.UML.Pulse.DropZoneLeave.pulse(evt);
    };

    DropZone.prototype.OnMouseDown = function(evt) {
      var arrow;
      arrow = globals.arrows.Create(this.GetSnapPosition(), window.UML.Utils.mousePositionFromEvent(evt), this.classID, this.index);
      return arrow.arrowHead.Follow();
    };

    DropZone.prototype.GetSnapPosition = function() {
      return window.UML.Utils.getSVGCoordForGroupedElement(this.graphics.arrowDrop).add(this.position);
    };

    return DropZone;

  })();

  window.UML.Pulse.TypeNameChanged = new Event();

  window.UML.Pulse.TypeDeleted = new Event();

  Globals = (function() {
    function Globals() {
      this.document = null;
      this.classes = new classes(function(Item) {
        return Item.model.modelItemID;
      });
      this.arrows = new window.UML.Arrows.Arrows(function(ArrowItem) {
        return ArrowItem.model.get("id");
      });
      this.namespaces = new Namespaces(function(NamespaceItem) {
        return NamespaceItem.myID;
      });
      this.textBoxes = new IDIndexedList(function(TextBoxItem) {
        return TextBoxItem.myID;
      });
      this.selections = new Selections();
      this.highlights = new Highlights();
      this.LayerManager = new LayerManager();
      this.CtrlZBuffer = new window.UML.Ctrlz.CtrlzBuffer();
      this.Model = new window.UML.MODEL.MODEL();
      this.CommonData = {
        version: "0.0.0",
        filename: "Diagram01",
        Types: new window.UML.StringTree.StringTree()
      };
      this.CommonData.Types.Build("Int");
      this.CommonData.Types.Build("Float");
      this.CommonData.Types.Build("String");
      this.CommonData.Types.Build("Boolean");
      this.CommonData.Types.Build("Time");
      this.CommonData.Types.Build("Date");
      this.CommonData.Types.Build("DateTime");
      window.UML.Pulse.TypeNameChanged.add(function(evt) {
        window.UML.globals.CommonData.Types.Remove(evt.prevText);
        return window.UML.globals.CommonData.Types.Build(evt.newText);
      });
      window.UML.Pulse.TypeDeleted.add(function(evt) {
        return window.UML.globals.CommonData.Types.Remove(evt.typeText);
      });
    }

    return Globals;

  })();

  Highlights = (function() {
    function Highlights() {
      this.highlightedClass = null;
      this.highlightedTextElement = null;
      this.highlightedTextTextGroup = null;
      this.highlightedInterface = null;
      this.highlightedNamespace = null;
      this.highlightedArrow = null;
    }

    Highlights.prototype.HighlightClass = function(element) {
      if (this.highlightedClass !== null) {
        this.UnHighlightClass();
      }
      if (this.highlightedInterface !== null) {
        this.UnHighlightInterface();
      }
      if (this.highlightedNamespace !== null) {
        this.UnHighlightInterface();
      }
      if (this.highlightedArrow !== null) {
        this.UnHighlightArrow();
      }
      this.highlightedClass = element;
      return this.highlightedClass.Highlight();
    };

    Highlights.prototype.HighlightInterface = function(element) {
      if (this.highlightedInterface !== null) {
        this.UnHighlightInterface();
      }
      if (this.highlightedClass !== null) {
        this.UnHighlightClass();
      }
      if (this.highlightedNamespace !== null) {
        this.UnHighlightInterface();
      }
      if (this.highlightedArrow !== null) {
        this.UnHighlightArrow();
      }
      this.highlightedInterface = element;
      return this.highlightedInterface.Highlight();
    };

    Highlights.prototype.HighlightArrow = function(element) {
      if (this.highlightedInterface !== null) {
        this.UnHighlightInterface();
      }
      if (this.highlightedClass !== null) {
        this.UnHighlightClass();
      }
      if (this.highlightedNamespace !== null) {
        this.UnHighlightInterface();
      }
      if (this.highlightedArrow !== null) {
        this.UnHighlightArrow();
      }
      this.highlightedArrow = element;
      return this.highlightedArrow.Highlight();
    };

    Highlights.prototype.HighlightTextElement = function(element) {
      if (this.highlightedTextElement !== null) {
        this.highlightedTextElement.Unhighlight();
      }
      this.highlightedTextElement = element;
      return this.highlightedTextElement.Highlight();
    };

    Highlights.prototype.HighlightNamespace = function(element) {
      if (this.highlightedInterface !== null) {
        this.UnHighlightInterface();
      }
      if (this.highlightedClass !== null) {
        this.UnHighlightClass();
      }
      if (this.highlightedNamespace !== null) {
        this.UnHighlightInterface();
      }
      if (this.highlightedArrow !== null) {
        this.UnHighlightArrow();
      }
      this.highlightedNamespace = element;
      return this.highlightedNamespace.Highlight();
    };

    Highlights.prototype.UnhighlightNamespace = function() {
      if (this.highlightedNamespace !== null) {
        this.highlightedNamespace.Unhighlight();
      }
      return this.highlightedNamespace = null;
    };

    Highlights.prototype.UnHighlightClass = function() {
      if (this.highlightedClass !== null) {
        this.highlightedClass.Unhighlight();
      }
      this.highlightedClass = null;
      return this.UnHighlightTextElement();
    };

    Highlights.prototype.UnHighlightInterface = function() {
      if (this.highlightedInterface !== null) {
        this.highlightedInterface.Unhighlight();
      }
      this.highlightedInterface = null;
      return this.UnHighlightTextElement();
    };

    Highlights.prototype.UnHighlightArrow = function() {
      if (this.highlightedArrow !== null) {
        this.highlightedArrow.Unhighlight();
      }
      return this.highlightedArrow = null;
    };

    Highlights.prototype.UnHighlightTextElement = function() {
      if (this.highlightedTextElement !== null) {
        this.highlightedTextElement.Unhighlight();
      }
      return this.highlightedTextElement = null;
    };

    return Highlights;

  })();

  window.UML.Interaction.Draggable = (function() {
    function Draggable(on_drag_start, on_drag, on_drag_end, object, getPosition) {
      this.on_drag_start = on_drag_start;
      this.on_drag = on_drag;
      this.on_drag_end = on_drag_end;
      this.getPosition = getPosition;
      this.mouse_down_Handel = (function(evt) {
        return this.on_mouse_down(evt);
      }).bind(this);
      this.mouse_move_Handle = null;
      this.mouse_move_Up_Handle = null;
      object.addEventListener("mousedown", this.mouse_down_Handel, false);
    }

    Draggable.prototype.detatch_for_GC = function(object) {
      object.removeEventListener("mousedown", this.mouse_down_Handel, false);
      return this.mouse_down_Handel = null;
    };

    Draggable.prototype.on_mouse_down = function(evt) {
      if (this.mouse_move_Handle === null && this.mouse_move_Up_Handle === null && evt.button !== rightMouse) {
        this.mouse_move_Handle = (function(evt) {
          return this.on_mouse_move(evt);
        }).bind(this);
        this.mouse_move_Up_Handle = (function(evt) {
          return this.on_mouse_up(evt);
        }).bind(this);
        this.cursorDelta = new Point(0, 0);
        this.cursorDelta = this.cursorDelta.add(window.UML.Utils.mousePositionFromEvent(evt));
        this.cursorDelta = this.cursorDelta.sub(this.getPosition());
        globals.document.addEventListener("mousemove", this.mouse_move_Handle, false);
        globals.document.addEventListener("mouseup", this.mouse_move_Up_Handle, false);
        return this.on_drag_start();
      }
    };

    Draggable.prototype.on_mouse_up = function(evt) {
      globals.document.removeEventListener("mousemove", this.mouse_move_Handle, false);
      globals.document.removeEventListener("mouseup", this.mouse_move_Up_Handle, false);
      this.mouse_move_Handle = null;
      this.mouse_move_Up_Handle = null;
      this.cursorDelta = null;
      return this.on_drag_end();
    };

    Draggable.prototype.on_mouse_move = function(evt) {
      var loc, moveTo;
      loc = window.UML.Utils.mousePositionFromEvent(evt);
      moveTo = new Point(loc.x, loc.y);
      return this.on_drag(moveTo.sub(this.cursorDelta));
    };

    return Draggable;

  })();

  window.UML.AlternateKeys = {
    CTRL: 17,
    ALT: 18
  };

  KeyboardListener = (function() {
    function KeyboardListener() {
      this.keyCodes = new Object();
      this.keyCodes.Del = 46;
      this.KeysWithInterests = new Array();
      this.KeyDownWithInterests = new Array();
      this.KeyWithAlternate = {};
      this.KeyWithAlternate[window.UML.AlternateKeys.CTRL] = new Array();
      this.KeyWithAlternate[window.UML.AlternateKeys.ALT] = new Array();
      this.currentAlternate = null;
      window.onkeyup = (function(evt) {
        return this.onkeyup(evt);
      }).bind(this);
      window.onkeydown = (function(evt) {
        return this.onkeydown(evt);
      }).bind(this);
    }

    KeyboardListener.prototype.isAltKey = function(key) {
      var prop, value, _ref;
      _ref = window.UML.AlternateKeys;
      for (prop in _ref) {
        if (!__hasProp.call(_ref, prop)) continue;
        value = _ref[prop];
        if (value === key) {
          return true;
        }
      }
      return false;
    };

    KeyboardListener.prototype.onkeyup = function(evt) {
      var interestedHandler, kayInterests, key, retVal, _fn, _i, _len, _ref;
      key = evt.keyCode ? evt.keyCode : evt.which;
      if (key === this.keyCodes.Del) {
        globals.selections.selectedGroup.del();
      }
      if (this.isAltKey(key)) {
        this.currentAlternate = null;
      }
      retVal = true;
      kayInterests = this.KeysWithInterests[key];
      if (this.KeysWithInterests[key]) {
        _ref = this.KeysWithInterests[key];
        _fn = function(interestedHandler) {
          if (!interestedHandler(evt)) {
            return retVal = false;
          }
        };
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          interestedHandler = _ref[_i];
          _fn(interestedHandler);
        }
      }
      return retVal;
    };

    KeyboardListener.prototype.onkeydown = function(evt) {
      var interestedHandler, isAltKey, kayInterests, key, retVal, _fn, _fn1, _i, _j, _len, _len1, _ref, _ref1;
      key = evt.keyCode ? evt.keyCode : evt.which;
      if (key === this.keyCodes.Del) {
        globals.selections.selectedGroup.del();
      }
      isAltKey = this.isAltKey(key);
      if (isAltKey) {
        this.currentAlternate = key;
      } else {
        if (this.currentAlternate !== null && this.KeyWithAlternate[this.currentAlternate][key]) {
          _ref = this.KeyWithAlternate[this.currentAlternate][key];
          _fn = function(interestedHandler) {
            var retVal;
            if (!interestedHandler(evt)) {
              return retVal = false;
            }
          };
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            interestedHandler = _ref[_i];
            _fn(interestedHandler);
          }
          return retVal;
        }
      }
      retVal = true;
      kayInterests = this.KeyDownWithInterests[key];
      if (this.KeyDownWithInterests[key]) {
        _ref1 = this.KeyDownWithInterests[key];
        _fn1 = function(interestedHandler) {
          if (interestedHandler) {
            if (!interestedHandler(evt)) {
              return retVal = false;
            }
          }
        };
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          interestedHandler = _ref1[_j];
          _fn1(interestedHandler);
        }
      }
      return retVal;
    };

    KeyboardListener.prototype.RegisterKeyInterest = function(key, handler) {
      if (!this.KeysWithInterests[key]) {
        this.KeysWithInterests[key] = new Array();
      }
      return this.KeysWithInterests[key].push(handler);
    };

    KeyboardListener.prototype.UnRegisterKeyInterest = function(key, handler) {
      var index;
      if (this.KeysWithInterests[key]) {
        index = this.KeysWithInterests[key].indexOf(handler);
        return this.KeysWithInterests[key].splice(index, 1);
      }
    };

    KeyboardListener.prototype.RegisterDownKeyInterest = function(key, handler) {
      if (!this.KeyDownWithInterests[key]) {
        this.KeyDownWithInterests[key] = new Array();
      }
      return this.KeyDownWithInterests[key].push(handler);
    };

    KeyboardListener.prototype.UnRegisterDownKeyInterest = function(key, handler) {
      var index;
      if (this.KeyDownWithInterests[key]) {
        index = this.KeyDownWithInterests[key].indexOf(handler);
        return this.KeyDownWithInterests[key].splice(index, 1);
      }
    };

    KeyboardListener.prototype.RegisterKeyWithAlthernate = function(alternateKey, key, handler) {
      if (this.KeyWithAlternate[alternateKey]) {
        if (!this.KeyWithAlternate[alternateKey][key]) {
          this.KeyWithAlternate[alternateKey][key] = new Array();
        }
        return this.KeyWithAlternate[alternateKey][key].push(handler);
      }
    };

    return KeyboardListener;

  })();

  LayerManager = (function() {
    function LayerManager() {}

    LayerManager.prototype.InsertArrowLayer = function(element) {};

    LayerManager.prototype.InsertNamespaceLayer = function(element) {
      var namespaceLayer;
      namespaceLayer = globals.document.getElementById("namespaceLayerMarker");
      return globals.document.insertBefore(element, namespaceLayer);
    };

    LayerManager.prototype.InsertClassLayer = function(element) {
      var classLayer;
      classLayer = globals.document.getElementById("classLayerMarker");
      return globals.document.insertBefore(element, classLayer);
    };

    return LayerManager;

  })();

  window.UML.MODEL.ModelGlobalUtils.listener = {
    ListenToNewMode: function(model) {},
    StopListening: function() {}
  };

  window.UML.CollaberationSyncBuffer.ModelBuffer = new window.UML.CollaberationSyncBuffer.SyncBuffer();

  window.UML.MODEL.ModelGlobalUtils.ItemIDManager = new window.UML.MODEL.ModelIDManager({
    currentID: 0,
    maxOverrideAllocated: 0,
    Request: function() {
      var ItemIDManager;
      ItemIDManager = window.UML.MODEL.ModelGlobalUtils.ItemIDManager;
      ItemIDManager.AddToWorkingSet(this.currentID, this.currentID + 50);
      return this.currentID = this.currentID + 50;
    },
    FlushIDs: function() {
      return this.currentID = 0;
    },
    allocateOverrideID: function(id) {
      if (id > this.maxOverrideAllocated) {
        this.maxOverrideAllocated = id;
      }
      return this.currentID = this.maxOverrideAllocated + 1;
    }
  });

  window.UML.MODEL.ModelGlobalUtils.ListIDManager = new window.UML.MODEL.ModelIDManager({
    currentID: 0,
    maxOverrideAllocated: 0,
    Request: function() {
      var ListIDManager;
      ListIDManager = window.UML.MODEL.ModelGlobalUtils.ListIDManager;
      ListIDManager.AddToWorkingSet(this.currentID, this.currentID + 50);
      return this.currentID = this.currentID + 50;
    },
    FlushIDs: function() {
      return this.currentID = 0;
    },
    allocateOverrideID: function(id) {
      if (id > this.maxOverrideAllocated) {
        this.maxOverrideAllocated = id;
      }
      return this.currentID = this.maxOverrideAllocated + 1;
    }
  });

  globals = new Globals();

  window.UML.globals = globals;

  globals.contextMenu = new ClassMenu();

  globals.InterfaceMenu = new InterfaceMenu();

  globals.NamespaceMenu = new NamespaceMenu();

  globals.ArrowMenu = new ArrowMenu();

  globals.KeyboardListener = new KeyboardListener();

  window.UML.backgroundMouseUp = function(evt) {
    var item, _i, _len, _ref, _results;
    if (globals.selections.moveableObjectActive) {
      _ref = globals.selections.selectedGroup.selectedItems;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (!item.isNamespace) {
          _results.push(window.UML.SetItemOwnedByBackground(item));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    }
  };

  window.UML.SetItemOwnedByBackground = function(item) {
    var childPositionLocal;
    globals.LayerManager.InsertClassLayer(item.graphics.group);
    childPositionLocal = window.UML.Utils.ConvertFrameOfReffrence(item.position, item.GetOwnerFrameOfReffrence(), globals.document.getCTM());
    item.Move(childPositionLocal);
    return item.SetNewOwner(globals.document);
  };

  $(document).ready(function() {
    globals.document = document.getElementsByTagName('svg')[0];
    globals.classes.Listen();
    globals.arrows.Listen();
    globals.namespaces.Listen();
    window.UML.MODEL.ModelGlobalUtils.ItemIDManager.RequestMoreIds();
    window.UML.MODEL.ModelGlobalUtils.ItemIDManager.RequestMoreIds();
    window.UML.Pulse.Initialise.pulse();
    window.UML.globals.CtrlZBuffer.Start();
    return Debug.Startup();
  });

  window.UML.setDebug = function() {
    return Debug.IsDebug = true;
  };

  window.UML.hideOverlay = function() {
    $("#windowOverlay").removeClass("overlayVisabal");
    $("#windowOverlay").addClass("overlayHidden");
    $("#overlayBackground").removeClass("overlayVisabal");
    $("#overlayBackground").addClass("overlayHidden");
  };

  RouteResolver = (function() {
    function RouteResolver() {
      this.routes = new Array();
    }

    RouteResolver.prototype.createRoute = function(routeName, value) {
      return this.routes[routeName] = value;
    };

    RouteResolver.prototype.appendRoute = function(value) {
      if (value in this.routes) {
        return this.routes[routeName] += value;
      } else {
        return console.log("Unknown Route requested: " + routeName);
      }
    };

    RouteResolver.prototype.resolveRoute = function(routeName) {
      if (routeName in this.routes) {
        return this.routes[routeName];
      } else {
        console.log("Unknown Route requested: " + routeName);
        return "";
      }
    };

    return RouteResolver;

  })();

  window.UML.Serialize.SerializeArrows = function(serilizer) {
    var arrow, arrows, _i, _len, _ref;
    arrows = new Array();
    _ref = globals.arrows.List;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      arrow = _ref[_i];
      arrows.push(serilizer.SerializeItem(arrow.model));
    }
    return arrows;
  };

  BaseObjectSerlizer = (function() {
    function BaseObjectSerlizer(obj) {
      this.obj = obj;
    }

    BaseObjectSerlizer.prototype.serialize = function(serialiseSelector) {
      return this.obj;
    };

    return BaseObjectSerlizer;

  })();

  window.UML.Serialize.SerializeClasses = function(serilizer) {
    var classItem, _i, _len, _ref;
    classes = new Array();
    _ref = globals.classes.List;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      classItem = _ref[_i];
      if (!classItem.IsInterface) {
        classes.push(serilizer.SerializeItem(classItem.model));
      }
    }
    return classes;
  };

  window.UML.Serialize.SerializeInterfaces = function(serilizer) {
    var interfaceItem, interfaces, _i, _len, _ref;
    interfaces = new Array();
    _ref = globals.classes.List;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      interfaceItem = _ref[_i];
      if (interfaceItem.IsInterface) {
        interfaces.push(serilizer.SerializeItem(interfaceItem.model));
      }
    }
    return interfaces;
  };

  ComplexObjectSerlizer = (function() {
    function ComplexObjectSerlizer(obj) {
      this.obj = obj;
    }

    ComplexObjectSerlizer.prototype.serialize = function(serialiseSelector) {
      return this.obj;
    };

    return ComplexObjectSerlizer;

  })();

  ModelItemSerilzer = (function() {
    function ModelItemSerilzer(obj) {
      this.obj = obj;
    }

    ModelItemSerilzer.prototype.serialize = function(serialiseSelector) {
      var ref, serilizedObject, subObj, _fn;
      ref = this;
      serilizedObject = {};
      _fn = function(ref, serilizedObject) {
        var serializer;
        serializer = serialiseSelector.select(ref.obj[subObj]);
        return serilizedObject[subObj] = serializer.serialize(serialiseSelector);
      };
      for (subObj in this.obj) {
        _fn(ref, serilizedObject);
      }
      return serilizedObject;
    };

    return ModelItemSerilzer;

  })();

  ModelListSerlizer = (function() {
    function ModelListSerlizer(obj) {
      this.obj = obj;
    }

    ModelListSerlizer.prototype.serialize = function(serialiseSelector) {
      var ref, serilizedList, subObj, _fn, _i, _len, _ref;
      ref = this;
      serilizedList = [];
      _ref = this.obj;
      _fn = function(ref, serilizedList) {
        var serializer;
        serializer = serialiseSelector.select(subObj);
        return serilizedList[ref.obj.indexOf(subObj)] = serializer.serialize(serialiseSelector);
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        subObj = _ref[_i];
        _fn(ref, serilizedList);
      }
      return serilizedList;
    };

    return ModelListSerlizer;

  })();

  window.UML.Serialize.SerializeNamespaces = function(serilizer) {
    var namespaces, ns, _i, _len, _ref;
    namespaces = new Array();
    _ref = globals.namespaces.List;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      ns = _ref[_i];
      namespaces.push(serilizer.SerializeItem(ns.model));
    }
    return namespaces;
  };

  NetworkModelIdWrapperSerlizer = (function() {
    function NetworkModelIdWrapperSerlizer(modelItemID, modelItem) {
      this.modelItemID = modelItemID;
      this.modelItem = modelItem;
    }

    NetworkModelIdWrapperSerlizer.prototype.serialize = function(serialiseSelector) {
      var serilizedObject;
      serilizedObject = {};
      serilizedObject.modelItemID = this.modelItemID;
      serilizedObject.model = this.modelItem.serialize(serialiseSelector);
      return serilizedObject;
    };

    return NetworkModelIdWrapperSerlizer;

  })();

  NetworkModelListIdWrapperSerlizer = (function() {
    function NetworkModelListIdWrapperSerlizer(modelItemID, modelItem) {
      this.modelItemID = modelItemID;
      this.modelItem = modelItem;
    }

    NetworkModelListIdWrapperSerlizer.prototype.serialize = function(serialiseSelector) {
      var serilizedObject;
      serilizedObject = {};
      serilizedObject.modelListID = this.modelItemID;
      serilizedObject.model = this.modelItem.serialize(serialiseSelector);
      return serilizedObject;
    };

    return NetworkModelListIdWrapperSerlizer;

  })();

  window.UML.Serialize.NetworkSincSerlizationSelector = (function() {
    function NetworkSincSerlizationSelector() {}

    NetworkSincSerlizationSelector.prototype.select = function(modelObject) {
      var itemListModel, subItem, _i, _len, _ref;
      if (modelObject.hasOwnProperty("modelItemID")) {
        return new NetworkModelIdWrapperSerlizer(modelObject.modelItemID, new ModelItemSerilzer(modelObject.model));
      } else if (modelObject.hasOwnProperty("modelListID")) {
        itemListModel = new Array();
        _ref = modelObject.list;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          subItem = _ref[_i];
          itemListModel.push(subItem);
        }
        return new NetworkModelListIdWrapperSerlizer(modelObject.modelListID, new ModelListSerlizer(itemListModel));
      } else if (((typeof classItem === "object") && (classItem !== null)) && !jQuery.isFunction(classItem)) {
        return new ComplexObjectSerlizer(modelObject);
      } else {
        return new BaseObjectSerlizer(modelObject);
      }
    };

    return NetworkSincSerlizationSelector;

  })();

  SaveModelSerilzationSelector = (function() {
    function SaveModelSerilzationSelector() {}

    SaveModelSerilzationSelector.prototype.select = function(modelObject) {
      var itemListModel, subItem, _i, _len, _ref;
      if (modelObject.hasOwnProperty("modelItemID")) {
        return new ModelItemSerilzer(modelObject.model);
      } else if (modelObject.hasOwnProperty("modelListID")) {
        itemListModel = new Array();
        _ref = modelObject.list;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          subItem = _ref[_i];
          itemListModel.push(subItem);
        }
        return new ModelListSerlizer(itemListModel);
      } else if (((typeof classItem === "object") && (classItem !== null)) && !jQuery.isFunction(classItem)) {
        return new ComplexObjectSerlizer(modelObject);
      } else {
        return new BaseObjectSerlizer(modelObject);
      }
    };

    return SaveModelSerilzationSelector;

  })();

  window.UML.Serialize.SerializeModel = (function() {
    function SerializeModel(serialiseSelector) {
      this.serialiseSelector = serialiseSelector;
    }

    SerializeModel.prototype.Serialize = function() {
      var arrowList, classList, interfaceList, model, modelText, namespaceList;
      model = new Object();
      model["Name"] = window.UML.globals.CommonData.filename;
      model["Version"] = window.UML.globals.CommonData.version;
      classList = window.UML.Serialize.SerializeClasses(this);
      interfaceList = window.UML.Serialize.SerializeInterfaces(this);
      namespaceList = window.UML.Serialize.SerializeNamespaces(this);
      arrowList = window.UML.Serialize.SerializeArrows(this);
      model["classList"] = classList;
      model["arrowList"] = arrowList;
      model["interfaceList"] = interfaceList;
      model["namespaceList"] = namespaceList;
      if (Debug.IsDebug) {
        modelText = JSON.stringify(model, null, '\t');
      } else {
        modelText = JSON.stringify(model);
      }
      return modelText;
    };

    SerializeModel.prototype.SerializeItem = function(item) {
      var serilzer;
      serilzer = this.serialiseSelector.select(item);
      return serilzer.serialize(this.serialiseSelector);
    };

    return SerializeModel;

  })();

  window.UML.Unpacker.DefaultUnpackStratagy = (function() {
    function DefaultUnpackStratagy() {}

    DefaultUnpackStratagy.prototype.unpack = function(item, unpacker) {
      if (window.UML.typeIsArray(item)) {
        return unpacker.UnpackArray(item);
      } else {
        return unpacker.UnpackItem(item);
      }
    };

    return DefaultUnpackStratagy;

  })();

  window.UML.Unpacker.NetworkUnpackStratagy = (function() {
    function NetworkUnpackStratagy() {}

    NetworkUnpackStratagy.prototype.unpack = function(item, unpacker) {
      if (item.hasOwnProperty("model")) {
        return this.unpackModelWrapedElement(unpacker, item);
      } else {
        return this.unpackElement(unpacker, item);
      }
    };

    NetworkUnpackStratagy.prototype.unpackModelWrapedElement = function(unpacker, modelItem) {
      if (window.UML.typeIsArray(modelItem.model)) {
        return unpacker.UnpackArray(modelItem.model, modelItem.modelListID);
      } else {
        return unpacker.UnpackItem(modelItem.model, modelItem.modelItemID);
      }
    };

    NetworkUnpackStratagy.prototype.unpackElement = function(unpacker, modelItem) {
      if (window.UML.typeIsArray(modelItem)) {
        return unpacker.UnpackArray(modelItem, -2);
      } else {
        return unpacker.UnpackItem(modelItem, -2);
      }
    };

    return NetworkUnpackStratagy;

  })();

  window.UML.Unpacker.Unpacker = (function() {
    function Unpacker(unpackingStratagy) {
      this.unpackingStratagy = unpackingStratagy;
    }

    Unpacker.prototype.Unpack = function(model) {
      var arrowList, arrowModel, classItem, classList, deepModel, interfaceItem, interfaceList, namespace, namespaceList, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _ref2, _ref3, _results;
      deepModel = JSON.parse(model);
      classList = deepModel.classList;
      interfaceList = deepModel.interfaceList;
      namespaceList = deepModel.namespaceList;
      arrowList = deepModel.arrowList;
      classList = this.UnpackObject(classList);
      interfaceList = this.UnpackObject(interfaceList);
      namespaceList = this.UnpackObject(namespaceList);
      arrowList = this.UnpackObject(arrowList);
      if (deepModel.Name) {
        window.UML.globals.CommonData.filename = deepModel.Name;
      }
      if (deepModel.Version) {
        window.UML.globals.CommonData.version = deepModel.Version;
      }
      _ref = classList.list;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        classItem = _ref[_i];
        globals.Model.classList.pushNoLog(classItem);
      }
      _ref1 = interfaceList.list;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        interfaceItem = _ref1[_j];
        globals.Model.interfaceList.pushNoLog(interfaceItem);
      }
      _ref2 = namespaceList.list;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        namespace = _ref2[_k];
        globals.Model.namespaceList.pushNoLog(namespace);
      }
      _ref3 = arrowList.list;
      _results = [];
      for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
        arrowModel = _ref3[_l];
        _results.push(globals.Model.arrowList.pushNoLog(arrowModel));
      }
      return _results;
    };

    Unpacker.prototype.UnpackObject = function(obj) {
      return this.unpackingStratagy.unpack(obj, this);
    };

    Unpacker.prototype.UnpackArray = function(obj, IDOverride) {
      var item, modelList, _i, _j, _len, _len1;
      if (obj.length > 0 && !(IDOverride != null) && !(IDOverride > -1)) {
        if (!window.UML.typeIsObject(obj[0]) && !window.UML.typeIsArray(obj[0])) {
          modelList = new Array();
          for (_i = 0, _len = obj.length; _i < _len; _i++) {
            item = obj[_i];
            modelList.push(item);
          }
          return modelList;
        }
      }
      if ((IDOverride != null)) {
        modelList = new window.UML.MODEL.ModelList(IDOverride);
      } else {
        modelList = new window.UML.MODEL.ModelList();
      }
      for (_j = 0, _len1 = obj.length; _j < _len1; _j++) {
        item = obj[_j];
        modelList.pushNoLog(this.UnpackObject(item));
      }
      return modelList;
    };

    Unpacker.prototype.UnpackItem = function(obj, IDOverride) {
      var item, model;
      if ((IDOverride != null)) {
        model = new window.UML.MODEL.ModelItem(IDOverride);
      } else {
        model = new window.UML.MODEL.ModelItem();
      }
      for (item in obj) {
        if (window.UML.typeIsObject(obj[item])) {
          model.setNoLog(item, this.UnpackObject(obj[item]));
        } else {
          model.setNoLog(item, obj[item]);
        }
      }
      return model;
    };

    return Unpacker;

  })();

  window.UML.Utils.mousePositionFromEvent = function(evt) {
    var point, pt;
    pt = globals.document.createSVGPoint();
    pt.x = evt.clientX;
    pt.y = evt.clientY;
    point = pt.matrixTransform(globals.document.getScreenCTM().inverse());
    return new Point(point.x, point.y);
  };

  window.UML.Utils.getScreenCoordForSVGElement = function(element) {
    var matrix, pt, screenCoords;
    matrix = element.getScreenCTM();
    pt = globals.document.createSVGPoint();
    pt.x = element.x.animVal.value;
    pt.y = element.y.animVal.value;
    screenCoords = pt.matrixTransform(matrix);
    return new Point(screenCoords.x, screenCoords.y);
  };

  window.UML.Utils.getScreenCoordForCircleSVGElement = function(element) {
    var matrix, pt, screenCoords;
    matrix = element.getScreenCTM();
    pt = globals.document.createSVGPoint();
    pt.x = element.getAttribute("cx");
    pt.y = element.getAttribute("cy");
    screenCoords = pt.matrixTransform(matrix);
    return new Point(screenCoords.x, screenCoords.y);
  };

  window.UML.Utils.getSVGCorrdforScreenPos = function(point) {
    var matrix, pt, svgCoords;
    matrix = globals.document.getScreenCTM();
    pt = globals.document.createSVGPoint();
    pt.x = point.x;
    pt.y = point.y;
    svgCoords = pt.matrixTransform(matrix.inverse());
    return new Point(svgCoords.x, svgCoords.y);
  };

  window.UML.Utils.getSVGCoordForGroupedElement = function(group) {
    var ctm, point, svgCoords;
    point = globals.document.createSVGPoint();
    ctm = group.getCTM();
    svgCoords = point.matrixTransform(ctm);
    return new Point(svgCoords.x, svgCoords.y);
  };

  window.UML.Utils.fromSVGCoordForGroupedElement = function(svgCoord, element) {
    var ctm, localCoords, point;
    point = globals.document.createSVGPoint();
    point.x = svgCoord.x;
    point.y = svgCoord.y;
    ctm = element.getCTM();
    localCoords = point.matrixTransform(ctm.inverse());
    return new Point(localCoords.x, localCoords.y);
  };

  window.UML.Utils.ConvertFrameOfReffrence = function(svgCoord, refrenceFrameFrom, refrenceFrameTo) {
    var globalCoords, point, toCoords;
    point = globals.document.createSVGPoint();
    point.x = svgCoord.x;
    point.y = svgCoord.y;
    globalCoords = point.matrixTransform(refrenceFrameFrom);
    toCoords = globalCoords.matrixTransform(refrenceFrameTo.inverse());
    return new Point(toCoords.x, toCoords.y);
  };

  window.UML.Utils.CreateJSONForModel = function() {
    var arrowList, classList, interfaceList, model, modelText, namespaceList;
    model = new Object();
    model["Name"] = globals.filename;
    model["Version"] = window.UML.globals.CommonData.version;
    classList = window.UML.Serialize.SerializeClasses();
    interfaceList = window.UML.Serialize.SerializeInterfaces();
    namespaceList = window.UML.Serialize.SerializeNamespaces();
    arrowList = window.UML.Serialize.SerializeArrows();
    model["classList"] = classList;
    model["arrowList"] = arrowList;
    model["interfaceList"] = interfaceList;
    model["namespaceList"] = namespaceList;
    modelText = JSON.stringify(model);
    return modelText;
  };

  window.UML.Utils.SendPost = function(data, url, onCompleatFunc) {
    $.ajax({
      type: "POST",
      url: url,
      data: data,
      success: onCompleatFunc,
      dataType: "html"
    });
  };

  window.UML.Utils.CreatePoint = function(x, y) {
    return new Point(x, y);
  };

  window.UML.Utils.doSave = function() {
    var json, saveSerilzer;
    window.Interface.StatusBar.setLoadingStatus("Saving");
    saveSerilzer = new window.UML.Serialize.SerializeModel(new window.UML.Serialize.NetworkSincSerlizationSelector());
    json = saveSerilzer.Serialize();
    Debug.write(json);
    return window.Interface.File.uploadFile(json, '/File/UploadFile', {
      uploadComplete: function() {
        window.UML.displayAjaxResponce(this.responseText, "Save");
        return window.Interface.StatusBar.setNewStatus("OK", "");
      },
      uploadFailed: function() {
        return window.Interface.StatusBar.setNewStatus("Upload Failed", "");
      },
      uploadCanceled: function() {
        return window.Interface.StatusBar.setNewStatus("Upload Canceled", "");
      },
      uploadProgress: function() {}
    });
  };

  window.UML.Utils.doSaveAs = function() {};

  window.UML.Utils.doGenCode = function(language) {
    var Serilzer, json;
    window.UML.displayAjaxResponce("<div style=\"width:100px;margin-left:auto; margin-right:auto;\"><object data=\"/content/img/cauldrin-large.svg\" type=\"image/svg+xml\" style=\"height:140px;width:100px\"></object></div>", "Cooking...");
    Serilzer = new window.UML.Serialize.SerializeModel(new SaveModelSerilzationSelector());
    json = Serilzer.Serialize();
    window.UML.Utils.SendPost(json, '/ClassDiagram/DownloadCode?language=' + language, window.UML.displayAjaxResponce);
    return Debug.write(json);
  };

  window.UML.Utils.displayChangeFilename = function() {
    var saveAsDialogText;
    saveAsDialogText = "<h4>New Document</h4> <div> <p>Enter a name for your new UML document:</p> Document Name: <input id='newFilename' type='text' value='" + globals.CommonData.filename + "'/> </div> <h4>Kickstart your project</h4> <div> <p>Choose from one of these starter projects to kick start your project.</p> <form id='projectTemplateForm'> <input type=\"radio\" name=\"projectType\" value=\"Empty\" checked>Empty Project <br> <input type=\"radio\" name=\"projectType\" value=\"decorator\">Decorator Pattern<br> <input type=\"radio\" name=\"projectType\" value=\"observer\">Observer Pattern <br> <input type=\"radio\" name=\"projectType\" value=\"stratagy\">Strategy Pattern </form> </div> <button class='btn btn-primary' onClick='window.UML.Utils.processNewDocumentForm();'>GO!</button>";
    window.UML.displayAjaxResponce(saveAsDialogText, "Document Name");
  };

  window.UML.Utils.processNewDocumentForm = function() {
    var selectedType;
    window.UML.Utils.applyNewFilename($("#newFilename").val());
    selectedType = $('input[name=projectType]:checked', '#projectTemplateForm').val();
    if (selectedType !== "Empty") {
      return window.UML.Utils.initWithProjectTemplate(selectedType);
    } else {
      return $("#modelWindow").modal("hide");
    }
  };

  window.UML.Utils.initWithProjectTemplate = function(template) {
    window.UML.displayAjaxResponce("Setting up your project, one sec...", "Project Initialisation");
    window.Interface.StatusBar.setLoadingStatus("Downloading File");
    return window.UML.Utils.SendPost(null, '/ProjectTemplates/Download?templateName=' + template, function(data) {
      window.UML.Utils.InitialiseModelFromJSON(data);
      return window.UML.displayAjaxResponce("All Done.", "Project Initialisation");
    });
  };

  window.UML.Utils.InitialiseModelFromJSON = function(data) {
    var extractedStatus, model, unpacker;
    window.Interface.StatusBar.setLoadingStatus("Processing File");
    unpacker = new window.UML.Unpacker.Unpacker(new window.UML.Unpacker.NetworkUnpackStratagy());
    data = data.trim();
    extractedStatus = window.UML.ExtractStatusBit(data);
    if (extractedStatus.status) {
      model = unpacker.Unpack(extractedStatus.data);
      window.Interface.StatusBar.setReadyState();
    } else {
      window.UML.displayAjaxResponce(extractedStatus.data, "Error");
    }
    return initialiseDocument();
  };

  window.UML.Utils.applyNewFilename = function(newFileName) {
    return globals.CommonData.filename = newFileName;
  };

  window.UML.displayAjaxResponce = function(data, header) {
    var modelContent, modelHeader;
    modelContent = $("#modelContent");
    modelContent.html(data);
    if (typeof header !== "undefined" && header !== null) {
      modelHeader = $("#modelHeaderContent");
      modelHeader.html("<h3>" + header + "</h3>");
    }
    if (!$('#modelWindow').hasClass('in')) {
      $("#modelWindow").modal("show");
    }
  };

  window.UML.SetArrowHeadFollow = function(ArrowId) {
    var arrow;
    arrow = window.UML.globals.arrows.get(ArrowId);
    if (arrow !== null) {
      return arrow.arrowHead.Follow();
    } else {
      return Debug.write("Follow Arrow Error: Invalid ArrowID: " + ArrowID);
    }
  };

  window.UML.SetArrowTailFollow = function(ArrowId) {
    var arrow;
    arrow = window.UML.globals.arrows.get(ArrowId);
    if (arrow !== null) {
      return arrow.arrowTail.Follow();
    } else {
      return Debug.write("Follow Arrow Error: Invalid ArrowID: " + ArrowID);
    }
  };

  window.UML.typeIsArray = Array.isArray || function(value) {
    return {}.toString.call(value) === '[object Array]';
  };

  window.UML.typeIsObject = function(value) {
    return ((typeof value === "object") && (value !== null)) && !jQuery.isFunction(value);
  };

  window.UML.ModelItemToPoint = function(item) {
    if (item.hasOwnProperty("modelItemID")) {
      return new Point(item.get("x"), item.get("y"));
    } else {
      return item;
    }
  };

  window.UML.ExtractStatusBit = function(data) {
    var ret_value, status;
    status = data[0] === '1';
    ret_value = new Object();
    ret_value.status = status;
    ret_value.data = data.substring(1);
    return ret_value;
  };

}).call(this);
