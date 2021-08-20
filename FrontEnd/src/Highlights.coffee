#I dont like this Idea seems like a hack, i wanna change it..
#this is such a shit class 

class Highlights
	constructor:()->
		@highlightedClass = null
		@highlightedTextElement = null
		@highlightedTextTextGroup = null
		@highlightedInterface = null
		@highlightedNamespace = null
		@highlightedArrow = null

	HighlightClass:(element)->
		if(@highlightedClass != null)
			@UnHighlightClass()
		if(@highlightedInterface != null)
			@UnHighlightInterface();
		if(@highlightedNamespace != null)
			@UnHighlightInterface();
		if(@highlightedArrow != null)
			@UnHighlightArrow();

		@highlightedClass = element
		@highlightedClass.Highlight()

	HighlightInterface:(element)->
		if(@highlightedInterface != null)
			@UnHighlightInterface();
		if(@highlightedClass != null)
			@UnHighlightClass();
		if(@highlightedNamespace != null)
			@UnHighlightInterface();
		if(@highlightedArrow != null)
			@UnHighlightArrow();

		@highlightedInterface = element;
		@highlightedInterface.Highlight();

	HighlightArrow:(element)->
		if(@highlightedInterface != null)
			@UnHighlightInterface();
		if(@highlightedClass != null)
			@UnHighlightClass();
		if(@highlightedNamespace != null)
			@UnHighlightInterface();
		if(@highlightedArrow != null)
			@UnHighlightArrow();

		@highlightedArrow = element;
		@highlightedArrow.Highlight();

	HighlightTextElement:(element)->
		if(@highlightedTextElement != null)
			@highlightedTextElement.Unhighlight()

		@highlightedTextElement = element
		@highlightedTextElement.Highlight()

	HighlightNamespace:(element)->
		if(@highlightedInterface != null)
			@UnHighlightInterface();
		if(@highlightedClass != null)
			@UnHighlightClass();
		if(@highlightedNamespace != null)
			@UnHighlightInterface();
		if(@highlightedArrow != null)
			@UnHighlightArrow();

		@highlightedNamespace = element
		@highlightedNamespace.Highlight();

	UnhighlightNamespace:()->
		if(@highlightedNamespace != null)
			@highlightedNamespace.Unhighlight();

		@highlightedNamespace = null;

	UnHighlightClass:()->
		if(@highlightedClass != null)
			@highlightedClass.Unhighlight();
		
		@highlightedClass = null
		@UnHighlightTextElement()

	UnHighlightInterface:()->
		if(@highlightedInterface != null)
			@highlightedInterface.Unhighlight();

		@highlightedInterface = null;
		@UnHighlightTextElement();

	UnHighlightArrow:()->
		if(@highlightedArrow != null)
			@highlightedArrow.Unhighlight();

		@highlightedArrow = null;

	UnHighlightTextElement:()->
		if(@highlightedTextElement != null)
			@highlightedTextElement.Unhighlight()

		@highlightedTextElement = null
