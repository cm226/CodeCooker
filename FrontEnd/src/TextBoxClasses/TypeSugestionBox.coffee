window.UML.Pulse.TypeSugestionClicked = new Event()

class window.UML.TextBoxes.TypeSugestionBox
	constructor:()->
		@NO_SELECTION = 0
		
		@onTypeSugestionMade = new Event()

		@SelectedIndex = @NO_SELECTION
		@displayed = false
		window.UML.Pulse.TypeSugestionClicked.add(((evt)-> @onTypeClicked(evt)).bind(@))

	Show:(@Position)->
		@UpdateStringPartial("")
		$("#typeSugestionList").css({display: "block",left: @Position.x,top: @Position.y});

		window.UML.globals.KeyboardListener.RegisterDownKeyInterest(40, @MoveSelectionDown.bind(@))
		window.UML.globals.KeyboardListener.RegisterDownKeyInterest(38, @MoveSelectionUp.bind(@))
		@displayed = true

	Hide:()->
		$("#typeSugestionList").css({display: "none"});

		window.UML.globals.KeyboardListener.UnRegisterDownKeyInterest(40, @MoveSelectionDown.bind(@))
		window.UML.globals.KeyboardListener.UnRegisterDownKeyInterest(38, @MoveSelectionUp.bind(@))
		@displayed = false

	UpdateStringPartial:(str)->
		selections = new Array();
		node = globals.CommonData.Types.GetSelections(str);
		node.ListChildren(selections);

		$("#typeSugestionList ul").html("")
		@SelectionLength = selections.length
		for selection in selections 
			do(selection)->
				$("#typeSugestionList ul").append("<li><a>"+selection+"</a></li>")

		$("#typeSugestionList ul li a").mousedown((evt)-> window.UML.Pulse.TypeSugestionClicked.pulse({selection : $(this)}))

		# if the root node is returned then no matches were found so select nothing
		if globals.CommonData.Types.IsRoot(node)
			@SelectedIndex = @NO_SELECTION
		else
			@SelectedIndex = 1

		@ActivateSelected()

	onTypeClicked:(evt)->
		if @displayed
			@onTypeSugestionMade.pulse(evt)

	MoveSelectionDown:(evt)->
		@DeActivateSelected()
		@SelectedIndex++;
		@SelectedIndex =  if @SelectedIndex > @SelectionLength then 0 else @SelectedIndex
		@ActivateSelected()

		evt.preventDefault();
		return false;

	MoveSelectionUp:(evt)->
		@DeActivateSelected()
		@SelectedIndex--;
		@SelectedIndex =  if @SelectedIndex <= 0 then @SelectionLength else @SelectedIndex
		@ActivateSelected()

		evt.preventDefault();
		return false

	DeActivateSelected:()->
		$("#typeSugestionList ul li:nth-child("+@SelectedIndex+")").removeClass("active");

	ActivateSelected:()->
		$("#typeSugestionList ul li:nth-child("+@SelectedIndex+")").addClass("active");

	GetSelectedText:()->
		if @SelectedIndex != @NO_SELECTION
			$("#typeSugestionList ul li:nth-child("+@SelectedIndex+") a").html()
		else
			null