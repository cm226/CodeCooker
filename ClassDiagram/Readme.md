*Version 0.4*
*Functionality:*
	*implemented*
		detecting override methods.
		namespace support
		cleverer behaviour when generateing inheritance like crateding constructors for the base class  
*bugs*

*Version 0.4.1*
*Functionality*
	*implemented*
		feedback box
		writers namespace folder organisation		
		version in .coc file
		initialised document name to diagram01
		namespace box resize to fit contentc one move and prevent namespace boxes from getting snaller than there content
		
*Bugs*
	*Fixed*
		refactor of c++ writter (its a mess)
		temp fix for new void() in writers		
		unit tests for Code generator in webapp
		c++ auto gen constructors seem to be getting called "constructor" instead of the object name in the .cpp file.
		c++ includes start from root directory which won't be correct for classes nested in folders



*Version 0.4.2*

*Functionality*
	*Implemented*
		class level comments
		class visibility
		JSON language
		class modifiers [static,...]
		sample diagrams choice when first opening new project

*Bugs*
	*fixed*		
		c# usings can be repeated
		static and abstract methods not being reapplied when saved .coc files are opened
		C# methods could be marked as abstract and virtual
		need to vlidate namespace names ( c# namespaces can contain spaces)


*Version 0.5.0*
	*Features*
			*Implemented*
				bend arrow lines
				user accounts with settings
				Themes
				method level comments
				About page
				type Suggestion list
	*Bugs*
		*fixed*
			class dropdown arrow can overlap classes with small names


*Version 0.5.1*
	*Features*
			Added email return address to comment box
			Text for Edit boxes is selected on open for all but argument boxes.

*Version 0.5.2*
	*Features*
			Add Type sugestion to propertys / return values
			Intelligent Placement of method Edit

	*Bugs*
			Cant click type sugestions
			After editing user setting once, it was no longer posible to edit them again.

*Version 0.5.3*
	*Features*
		Ctrl-Z buffer
		Follow Google+ button
		Error message for invalid type string

	*Bugs*
		*Fixed*
			write a Java object to JSON function.
			investigate scroll x bar not showing in default theeme.
			Class propertys not marked as static in C# generated code.
			C# method override call contain first argument twice.


*Version 0.5.4*
	*Features*
		*Implemented*
			Tab next method details
			Increased Front end robustness
			CtrlZ much includes all objects now
			model improvements
			codecooker style updated
	*Bugs*



*Version 0.5.5*
	*Bugs*

	*implemented*
		c++ classes should have a virtual base class
		need to wrap all init code in try catch so the buttons still slide in if it crashes
		abstract methods arnt in ittallics when initialised from startup
		File version Table was never implemented
		arrow move connection from one dropzone to another broken
		arros can be attached to the same drop zone they came from
		type sugestion should deselect when no matches
		undo namespace position dosent work

*Version 0.6.0*	
	
	*implemented*

		Minor useability improvemnts to site
		method popup needs to move as method expands
		feedback on hover stretch out thing
		model not fully serialized from model objects
		might be a good idea to move the extraction of .coc files in the front end javascript instead of on the server.
		new status bar
		fixed JSON generator not wrapping class JSON in {} 
		websocket wrapper for chatt and real time shareing
		ctrlZ dosent handle moves between frames of reffrence properly
		notification for group stuff
		increased crt-z buffer size to 30

	*Fixed*
		commented out the theem selector coz its no working on the laptop in classDiagramContriller:open
		feedback comment style fucked
	

*Version 0.6.1*

		*Fixed*
			delete arrows dnt work over co-op
			group chatt window oply opened when you click the text(codecooker style only)
			some issue with co-op and networ latency (use decorator)

		*Implemented*
			drop zones fade on mouse leave
			collapseable methods and propertys
			methods and propertys add button in class
			new Improved look
			code cooker style buttons need styleing

	add to version table


**To Do**


*Later Versions:*

*bugs:*

decide what to do in the case of multiple inheritance
select an arrow then click and hold and move mouse off of arrow, this makes the arrow no longer selectable. start by looking at the selection logic
if you are editing an edit box then scroll the box dosnt move.
it seems the logic with the resize methods and events result in things being resized 3 or more times sometimes, so should really look at that at some point
c++ does not add a default return statement
using the <> symbols for generic types when they are releaded from a saved file asp.net os converting them to &lt; and &gt;
namespaces Ctrl-z requires 2 presses to get back one action
Id allocators need to be able to handle wrap arrounds (maybe, you would have to create ~60000 ids a day for 10 years to reach the max)
interface type sugestion dont work for tab or enter?

Unit tests are absolute pish check the model constsiancy ones

*Features:*

class create position mechanism needs to be drag on
first time tour?
add to chrome app store
change arrow direction(context menu)
add Git and bitbucket sign in. (and or link other acounts)
define langauges using a language template file (uploadable) with placeholders
update help menu
Multi select elements
Add a warnings list to the output (e.g methods when generating JSON files)
Rething the method of type sugestion popup in args, its too intrusive.
Java
namespace boxes react to children size change
full UML complience (add associations)
social buttons
make type susgestion open on alt + space
make diagram work on mobiles
implement converter for version 0.6.1, 0.6.0, 0.5.4
implement no diagnal arrows functionality( can use stratagy pattern for this)
add methods and propertys to add class UI
folder organisation for GDrive
implement openwith functionality for GDrive
XMI
use [] to create array
enter to select type (propertys only)
add expand all/collapse all buttons
layout engion
text interface for createing classes/interfaes etc




*On-going*
more languages
make everything pretty

need to implement tests for:

generic classes 

*Release Checklist*
remove debug from front end
increase Version number

