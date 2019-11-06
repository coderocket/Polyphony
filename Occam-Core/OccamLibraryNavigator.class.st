Class {
	#name : #OccamLibraryNavigator,
	#superclass : #Object,
	#instVars : [
		'navigator',
		'showAbbreviations',
		'showOnlyUploadableProcedures'
	],
	#category : #'Occam-Core-Browser'
}

{ #category : #'instance creation' }
OccamLibraryNavigator class >> openOn: aLibrary [

	self new openOn: (OrderedCollection with: aLibrary).

]

{ #category : #'as yet unclassified' }
OccamLibraryNavigator >> abstractionsIn: aProcedure [

	showOnlyUploadableProcedures ifFalse: [^aProcedure allAbstractions].
	
	^aProcedure allAbstractions select:[:each | each isClosed ].
]

{ #category : #'as yet unclassified' }
OccamLibraryNavigator >> abstractionsInLibrary: aLibrary [

	showOnlyUploadableProcedures ifFalse: [^aLibrary allAbstractions].
	
	^aLibrary allAbstractions select:[:each | each isUploadable ].
]

{ #category : #'as yet unclassified' }
OccamLibraryNavigator >> abstractionsInProcedure: aProcedure [

	| aCollection |
	
	aCollection := aProcedure children select:[:each | each isKindOf: ASTAbstraction ].
	
	showOnlyUploadableProcedures ifFalse: [^ aCollection].
	
	^aCollection select:[:each | each isUploadable ].
]

{ #category : #'as yet unclassified' }
OccamLibraryNavigator >> buildNavigator [ 

	navigator := GLMTabulator new.
	
	navigator title:'Polyphony Library Navigator' translated.
	
	navigator column: #libraries; column:#procs.
	
	navigator transmit to:#libraries; andShow:[ :a | self librariesIn: a ].
	
	navigator transmit from:#libraries; to:#procs; andShow: [ :a | self proceduresIn: a ].

	navigator transmit from: #procs; toOutsidePort: #selectedProc.
	
	^navigator 
]

{ #category : #initialization }
OccamLibraryNavigator >> initialize [ 	

	showAbbreviations := true.
	
	showOnlyUploadableProcedures := false.
]

{ #category : #'as yet unclassified' }
OccamLibraryNavigator >> librariesIn: constructor [

constructor tree 
	display:[:libraries | libraries ] ; 
	children:[ :root :library | root children select:[:each | each isKindOf: ASTLibrary ] ]; 
	format:[:library | library name value ];
	updateOn: GLMItemChanged from: [ :libraries | libraries first announcer ] ;
	allowItemDrag: [:item :tree | true ];
	transformDraggedItem: [:item :tree | OrderedCollection with: item ] .




]

{ #category : #'instance creation' }
OccamLibraryNavigator >> openOn: anOrderedCollection [

	self buildNavigator.
	navigator openOn: anOrderedCollection 
]

{ #category : #'as yet unclassified' }
OccamLibraryNavigator >> proceduresIn: constructor [

constructor tree 
	title:'Abstractions' ;
	display:[ :lib | self abstractionsInLibrary: lib ] ; 
	children:[ :root :proc | self abstractionsInProcedure: root ]; 
	format:[:proc | proc name value ] ;	
	updateOn: GLMItemChanged from: [ :proc | proc announcer ] ;
	selectionAct:[:tree |
		tree selection inspect ] entitled: 'Inspect'.
	
constructor table 
   title: 'Abbreviations' ;
	when: [ :proc | showAbbreviations ] ;
	display:[ :proc | proc allExternalAbbrevs ];
	updateOn: GLMItemChanged from: [ :proc | proc announcer ] ;
	column: 'type' evaluated: [ :each | each type asString ] width:80; 
	column: 'name' evaluated: [ :each | each name value ]  

	

]

{ #category : #initialization }
OccamLibraryNavigator >> showAbbreviations: aBool [
	showAbbreviations := aBool
]

{ #category : #initialization }
OccamLibraryNavigator >> showOnlyUploadableProcedures: aBool [
	showOnlyUploadableProcedures := aBool
]
