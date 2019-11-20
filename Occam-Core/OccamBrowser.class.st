Class {
	#name : #OccamBrowser,
	#superclass : #Object,
	#instVars : [
		'browser'
	],
	#category : #'Occam-Core-Browser'
}

{ #category : #example }
OccamBrowser class >> example [ 

	| anAST aBrowser |
	
	anAST := OccamCoreParser parse:
'LIBRARY top IS
  LIBRARY sub IS
    PROC f()
      SKIP
    :
    PROC g()
      SKIP
    :
    INT FUNCTION h(VAL INT x)
      INT y :
      RESULT x+y
    :
  :
  PROC p(INT x, REAL32 y)
    INT z :
    CHAN OF INT c :
    BOOL b :
    PROC q(INT u, REAL32 v)
      SKIP 
    :
    SEQ
      z := 3
      x := y
      c?x
      x?x
      c?y
  :
:'.
	
	aBrowser := self new.
	
	aBrowser openOn: (OrderedCollection with: anAST).
]

{ #category : #example }
OccamBrowser class >> open [ 

	| anAST aBrowser |
	
	anAST := ASTLibrary new name: (SmaCCToken value:'.').
	
	aBrowser := self new.
	
	aBrowser openOn: (OrderedCollection with: anAST).
]

{ #category : #example }
OccamBrowser class >> openOn: aLibrary [

	self new openOn: (OrderedCollection with: aLibrary).
]

{ #category : #adding }
OccamBrowser >> addFunctionTo: aScope [

	| aString |		
		
	aString := UIManager default request: 'Enter the new function name:'.
	aString ifNotNil:[aScope addFunctionNamed: aString].

]

{ #category : #adding }
OccamBrowser >> addLibraryInto: aLibrary [

	| aString |		
		
	aString := UIManager default request: 'Enter the new library name:'.
	aString ifNotNil:[aLibrary addLibraryNamed: aString].

]

{ #category : #adding }
OccamBrowser >> addLocalAbbrevTo: anAbstraction [

	| aString |		
	aString := UIManager default request: 'Enter the new local abbreviation:'.
	aString ifNotNil:[anAbstraction parseLocalAbbrev: aString, ' :'] 


]

{ #category : #adding }
OccamBrowser >> addLocalVariableTo: anAbstraction [

	| aString |		
	aString := UIManager default request: 'Enter the new local variable definition:'.
	aString ifNotNil:[anAbstraction parseLocalVariable: aString, ' :']


]

{ #category : #adding }
OccamBrowser >> addParameterTo: aProc [

	| aString |		
		
	aString := UIManager default request: 'Enter the new parameter definition:'.
	aString ifNotNil:[aProc parseParameter: aString. browser update]

]

{ #category : #adding }
OccamBrowser >> addProcedureTo: aScope [

	|aString|
	
	aString := UIManager default request: 'Enter the new procedure''s name:'.
	aString ifNotNil:[aScope addProcedureNamed: aString]

]

{ #category : #building }
OccamBrowser >> buildBrowser [ 

	browser := GLMTabulator new.
	
	browser title:'Polyphony Occam Browser' translated.
	
	browser 
		row:[:r | r column: #libraries; column:#procs ; column: #imports; column:#params; column: #locals] ;
		row:#source ; 
		row:#violations.
	
	browser transmit to:#libraries; andShow:[ :a | self librariesIn: a ].
	
	browser transmit from:#libraries; to:#procs; andShow: [ :a | self proceduresIn: a ].

	browser transmit from:#libraries; to:#imports; andShow:[ :a | self importsIn: a ].
	
	browser transmit from:#procs; to:#params; andShow:[ :a | self parametersIn: a ].
	
	browser transmit from:#procs; to:#locals; andShow:[ :a | self localVariablesIn: a. self localAbbrevsIn: a. ].
	 
	browser transmit from:#procs; to:#source; andShow: [ :a | self sourceIn: a. self graphIn: a. self memoryMapIn: a. self docIn: a].
	
	browser transmit from:#procs; to:#violations; andShow:[:a | self violationsIn: a ].
	
	browser transmit from:#violations; to:#source port:#selectionInterval ; transformed:[:v | 
		v ifNotNil:[v range] ]
		
]

{ #category : #private }
OccamBrowser >> displayError: aString at: position notifying: aPresentation [

	| replacement newText |
	
	newText := aPresentation text string.
	
	replacement := Text string: aString , '->' attribute: TextEmphasis bold.
		
	UIManager default defer: [ 
		aPresentation announce: (GLMTextEditorRequest new 
			action: [ :anEditor | 
				"by the time we get to apply this block the system has already replaced the 
				text with the previous procedure's body) so we must set the editor's text to 
				the new text. "
				anEditor selectAll.
				anEditor replaceSelectionWith: newText.
				anEditor unselect.
				anEditor replaceTextFrom: position to: position with: replacement]) ]

]

{ #category : #panels }
OccamBrowser >> docIn: constructor [

constructor text
	display: [ :proc | proc documentation ] ; 
	format:[ :doc | doc ]; 
	addAction: 
			((GLMGenericAction new) 
				action: [:presentation :proc | proc documentation: presentation text string  ]; 
				condition: [ :presentation :proc | proc isLocked not ] ;
				shortcut: $s; 
				title: 'Accept' translated; 
				yourself) ;	
	title:'Documentation' translated
]

{ #category : #adding }
OccamBrowser >> duplicateAbstraction: anAbstraction [

	|aString|
	
	aString := UIManager default request: 'Enter the new abstraction''s name:'.
	aString ifNotNil:[anAbstraction duplicateWithName: aString]

]

{ #category : #ToDeprecate }
OccamBrowser >> fileInto: aLibrary [

	| aStream aFileReference |
	
	aFileReference := (UITheme builder chooseExistingFileReference: 'Select a Library' extensions: {'ocm'} path: '.').
	
	aStream := aFileReference readStream.
	[ aLibrary fileIn: aStream ] ensure:[ aStream close]

]

{ #category : #ToDeprecate }
OccamBrowser >> fileOut: aLibrary [

	| aStream aFileReference anIndentedPrinterStream |

	aFileReference := (UITheme builder chooseForSaveFileReference: 'Save as' extensions: {'ocm'} path: '.').
	
	aFileReference ifNil:[^self].
	
	anIndentedPrinterStream := IndentedPrinterStream new.
	aLibrary streamOn: anIndentedPrinterStream.

	aStream := aFileReference writeStream.
	
	[aStream nextPutAll: anIndentedPrinterStream contents ] ensure:[ aStream close]

]

{ #category : #panels }
OccamBrowser >> graphIn: constructor [

constructor roassal2 
	when:[ :proc | proc isKindOf: ASTProcedure ] ;
	initializeView: [ RTMondrian new ];
	painting: [ :builder :proc | 
		proc diagramIn: builder view. ] ; 
	title: 'Comm. Diagram' translated ;
	addAction: (GLMGenericAction new
		action: [ :presentation :proc | proc expandDiagramDepth. presentation update ];
			icon: GLMUIThemeExtraIcons glamorousUp;
			title: 'Expand');
	addAction: (GLMGenericAction new
		action: [ :presentation :proc | proc contractDiagramDepth. presentation update ];
			icon: GLMUIThemeExtraIcons glamorousDown;
			title: 'Contract').


]

{ #category : #panels }
OccamBrowser >> importsIn: constructor [

constructor fastList 
	title: 'Imports';
	display:[ :lib | lib usings ]; 
	format: [ :aUsing | aUsing names inject:'' into:[ :acc :each | acc, '/', each value] ] ;
	updateOn: GLMItemChanged from: [ :lib | lib announcer ] ;
	selectionAct:[:list :lib | lib removeDependency: list selection] entitled: 'Remove';
	allowDropOnItem: [:draggedObject :targetItem :list | draggedObject isKindOf: ASTLibrary ];
	dropOnItem: [:draggedObject :targetItem :list | 
		list entity addDependency: draggedObject asUsing. true ]

]

{ #category : #panels }
OccamBrowser >> librariesIn: constructor [

constructor tree 
	display:[:libraries | libraries ] ; 
	children:[ :root :library | root children select:[:each | each isKindOf: ASTLibrary ] ]; 
	format:[:library | library name value ] ;
	updateOn: GLMItemChanged from: [ :libraries | libraries first announcer ] ;
	selectionAct:[ :tree |
		self fileInto: tree selection ] entitled: 'File in...' ;
	selectionAct:[ :tree |
		self fileOut: tree selection ] entitled: 'File out...' ;
	selectionAct:[:tree | 
		self addLibraryInto: tree selection ] entitled: 'Add Library...' ;
	selectionAct:[:tree | 
		self addProcedureTo: tree selection ] entitled: 'Add Procedure...' ;
	selectionAct:[:tree | 
		self addFunctionTo: tree selection ] entitled: 'Add Function...' ;
	selectionAct:[:tree :root | 
		self removeScope: tree selectionPath. root first check. ] entitled: 'Remove';
	selectionAct:[:tree | 
		tree selection inspect ] entitled: 'Inspect' ;
	allowItemDrag: [:item :tree | true ];
	transformDraggedItem: [:item :tree | OrderedCollection with: item ] ;
	allowDropOnItem: [:draggedObject :targetItem :list | draggedObject isKindOf: ASTAbstraction ] ;
	dropOnItem: [:draggedObject :targetItem :list | 
		targetItem addExistingAbstraction: draggedObject ]





]

{ #category : #panels }
OccamBrowser >> localAbbrevsIn: constructor [

constructor fastTable 
	when:[ :proc | proc class canUnderstand: #localAbbrevs ] ;
	title: 'Abbreviations' ;
	display:[ :proc | proc localAbbrevs ]; 
	column: 'name' evaluated: [ :each | each name value ] width:80 ;	
	column: 'value' evaluated: [ :each | each expr asString ] modified: [ :newValue :item :presentation | item replaceExpression: newValue inContext: presentation entity ] ;
	updateOn: GLMItemChanged from: [ :proc | proc announcer ] ;
	act:[:table :proc | self addLocalAbbrevTo: proc ] entitled: 'Add' ;
	selectionAct:[:tab :proc | proc removeLocal: tab selection] entitled: 'Remove' 



]

{ #category : #panels }
OccamBrowser >> localVariablesIn: constructor [

constructor table 
	title: 'Variables';
	when:[ :proc | proc class canUnderstand: #localVariables ] ;
	display:[ :proc | proc localVariables ]; 
	column: 'type' evaluated: [ :each | each type asString ] width:80 ;	
	column: 'name' evaluated: [ :each | each name value ] ; 
	column: 'violations' evaluated: [ :each | each violationsAsString ] ;
	updateOn: GLMItemChanged from: [ :proc | proc announcer ] ;
	act:[:table :proc | self addLocalVariableTo: proc] entitled: 'Add' ;
	selectionAct:[:tab :proc | proc removeLocal: tab selection ] entitled: 'Remove'; 
	allowItemDrag: [:item :table | true ];
	transformDraggedItem: [:item :table | item ] ;
	allowDropOnItem: [:draggedObject :targetItem :table | true];
	dropOnItem: [:draggedObject :targetItem :table | 
		table entity moveLocal: draggedObject after: targetItem. true ]


]

{ #category : #panels }
OccamBrowser >> memoryMapIn: constructor [

constructor roassal2 
	when:[ :proc | proc isKindOf: ASTProcedure ] ;
	initializeView: [ RTGrapher new ];
	painting: [ :builder :proc | 
		proc memoryFootprintMapDiagramIn: builder ] ; 
	title: 'Memory Footprint' translated.

]

{ #category : #'instance creation' }
OccamBrowser >> openOn: anOrderedCollection [
	self buildBrowser.
	browser openOn: anOrderedCollection 
]

{ #category : #panels }
OccamBrowser >> parametersIn: constructor [

constructor fastTable 
	when:[ :proc | proc class canUnderstand: #params ] ;
	title: 'Parameters'; 
	display:[ :proc | proc params ]; 
	column: 'type' evaluated: [ :each | each type asString ] width:60; 
	column: 'name' evaluated: [ :each | each name value ] modified: [ :newValue :item :presentation | item renameTo: newValue. ] width:80; 
	column: 'direction' evaluated: [ : each | each direction ifNil:[''] ifNotNil:[ :x | x title ] ] modified: [ :newValue :item :presentation | item changeDirectionTo: newValue ] width:60 ;
	column: 'style' evaluated: [ :each | each style ] modified:[ :newValue :item | item changeStyleTo: newValue ] ;
	updateOn: GLMItemChanged from: [ :proc | proc announcer ] ;
	act:[:tab :proc | self addParameterTo: proc ] entitled: 'Add' ;
	selectionAct:[:tab :proc | proc removeParameter: tab selection ] entitled: 'Remove';
	allowItemDrag: [:item :table | true ];
	transformDraggedItem: [:item :table | item ] ;
	allowDropOnItem: [:draggedObject :targetItem :table | true];
	dropOnItem: [:draggedObject :targetItem :table | 
		table entity moveParam: draggedObject after: targetItem. true ]
	
	
]

{ #category : #panels }
OccamBrowser >> proceduresIn: constructor [

constructor tree 
	title:'Abstractions' ;
	display:[ :library | library allAbstractions ] ; 
	children:[ :root :proc | root children select:[:each | each isKindOf: ASTAbstraction ] ]; 
	format:[:proc | proc name value ] ;	
	tags: [ :proc | proc isValid ifTrue:[OrderedCollection empty] ifFalse:['E'] ] ;
	updateOn: GLMItemChanged from: [ :proc | proc announcer ] ;
	selectionAct:[:tree | 
		self addProcedureTo: tree selection] entitled: 'Add Procedure ...' ;
	selectionAct:[:tree | 
		self addFunctionTo: tree selection] entitled: 'Add Function ...' ;
	selectionAct:[:tree :path |
		self removeAbstraction: tree selection from: tree selection parent] entitled: 'Remove' ;
	selectionAct:[:tree |
		self renameAbstraction: tree selection] entitled: 'Rename ...' ;
	selectionAct:[:tree |
		self duplicateAbstraction: tree selection] entitled: 'Duplicate ...' ;
	selectionAct:[:tree |
		tree selection inspect ] entitled: 'Inspect' ;
	allowItemDrag: [:item :tree | true ] ;
	transformDraggedItem: [:item :tree | item ] ;
	allowDropOnItem: [:draggedObject :targetItem | (draggedObject class canUnderstand: #locals) ];
	dropOnItem: [:draggedObject :targetItem |  
		draggedObject parent moveLocal: draggedObject after: targetItem. true ].
	
constructor table 
   title: 'Abbreviations' ;
	display:[ :library | library allExternalAbbrevs ];
	updateOn: GLMItemChanged from: [ :library | library announcer ] ;
	column: 'type' evaluated: [ :each | each type asString ] width:80; 
	column: 'name' evaluated: [ :each | each name value ]  

]

{ #category : #removing }
OccamBrowser >> removeAbstraction: anAbstraction from: aScope [

	(aScope callsProcedureNamed: anAbstraction name value)
		ifTrue:[UIManager default alert:'Abstraction is in use']
		ifFalse:[	aScope removeAbstraction: anAbstraction]

					
]

{ #category : #adding }
OccamBrowser >> removeScope: anOrderedSequence [

	[anOrderedSequence size > 2] whileTrue:[anOrderedSequence removeFirst].

	(anOrderedSequence size < 2) ifTrue:[^self].
	
	anOrderedSequence first removeAbstraction: anOrderedSequence last.

]

{ #category : #'as yet unclassified' }
OccamBrowser >> renameAbstraction: anAbstraction [

	|aString|
	
	aString := UIManager default request: 'Enter the new procedure''s name:'.
	aString ifNotNil:[anAbstraction renameTo: aString] 


]

{ #category : #panels }
OccamBrowser >> sourceIn: constructor [

(constructor custom: GLMOccamPresentation new) 
	when:[ :proc | proc class canUnderstand: #body ] ;
	display:[ :proc | proc body ] ; 
	format:[ :ast | ast localSource ] ; 
	updateOn: GLMItemChanged from: [ :proc | proc announcer ] ;
	act: [:presentation :proc | 
		[ proc parseBody: presentation text string ]
		on: SmaCCParserError
		do: [ :ex |
			self displayError:ex messageText at:ex tag errorToken startPosition notifying: presentation ]	 ] on: $s entitled:'Accept' translated; 	title:'Source' translated.

]

{ #category : #panels }
OccamBrowser >> violationsIn: constructor [

constructor list 
	when:[ :proc | proc class canUnderstand: #body ] ;
	display: [ :proc | proc body violations ] ; 
	format:[:violation | violation reason ]; 
	updateOn: GLMItemChanged from: [ :proc | proc announcer ] ;
	title:'Violations' translated
]
