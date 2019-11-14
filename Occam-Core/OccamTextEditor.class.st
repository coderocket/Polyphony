Class {
	#name : #OccamTextEditor,
	#superclass : #RubTextEditor,
	#instVars : [
		'indentation'
	],
	#category : #'Occam-Core-Browser'
}

{ #category : #'typing/selecting keys' }
OccamTextEditor >> backspace: aKeyboardEvent [

	| result startIndex |
	result := aKeyboardEvent shiftPressed
		ifTrue: [ self backWord: aKeyboardEvent keyCharacter ]
		ifFalse: [ 
			self hasSelection
				ifTrue: [ 
					self replaceSelectionWith: self nullText. 
					textArea changed]
				ifFalse: [
					startIndex := self markIndex
						+
							(self hasCursor
								ifTrue: [ 0 ]
								ifFalse: [ 1 ]).
					((startIndex > 2) and:[((self string at:startIndex - 1) = Character space) and:[(self string at:startIndex - 2) = Character space]]) 
						ifTrue:[
							startIndex := 1 max: startIndex - 2
						]
						ifFalse:[
							startIndex := 1 max: startIndex - 1
						].
					self backTo: startIndex.
					 ]. 
			false ].
	self closeTypeIn.
	^ result
]

{ #category : #'typing/selecting keys' }
OccamTextEditor >> crWithIndent: aKeyboardEvent [

	"Replace the current text selection with CR followed by as many spaces
	as on the current line."
	
	 "Now inject CR with spaceCount spaces"
	self addString: (String streamContents: [ :strm | strm cr; space: self indentLevel ]).

	^false
]

{ #category : #keymapping }
OccamTextEditor >> defaultCommandKeymapping [
	| cmdMap |
		
	cmdMap := super defaultCommandKeymapping.
	
	cmdMap at:Character tab asciiValue + 1 put:#occamIncreaseIndent:.
	
	^cmdMap.
]

{ #category : #keymapping }
OccamTextEditor >> defaultShiftCommandKeymapping [

	| cmdMap |
	
	cmdMap := super defaultShiftCommandKeymapping.

	cmdMap at:Character tab asciiValue + 1 put:#occamDecreaseIndent:.
	
	^cmdMap.	
]

{ #category : #accessing }
OccamTextEditor >> indentLevel [ 

	| cr spaceCount s i |
	
	cr := Character cr.
	
	s := self string.
	i := self startIndex - 1.
	
	spaceCount := 0.
	
	"find the beginning of the line"
	[i > 0 and:[(s at:i) ~= cr]]
		whileTrue:[i := i - 1].
	
	i := i + 1. "skip cr"
	
	"count number of spaces until first non space"
	[ (i <= s size) and:[(s at:i) = Character space] ]
		whileTrue:[
			i := i + 1.
			spaceCount := spaceCount + 1
			].
		
	^ spaceCount 

]

{ #category : #initialization }
OccamTextEditor >> initialize [
	indentation := 0
]

{ #category : #'as yet unclassified' }
OccamTextEditor >> occamDecreaseIndent: aKeyboardEvent [

	| s |
	
	^(self selectionInterval extent > 0)
		ifTrue:[ 
			s := self selection asString copyWithRegex: '^  ' matchesReplacedWith:''. 
			self replaceSelectionWith: s.
			true ]
		ifFalse: [ 
			(self startIndex > 2)
				ifTrue:[ self backTo: self startIndex - 2 ]. false ]

]

{ #category : #'as yet unclassified' }
OccamTextEditor >> occamIncreaseIndent: aKeyboardEvent [

	| anIndentedPrinterStream start |
		
	anIndentedPrinterStream := IndentedPrinterStream new.
	
	anIndentedPrinterStream incrementIndentation ; indent.
	
	anIndentedPrinterStream putManyLines: self selection asString.
	
	^(self selectionInterval extent > 0)
		ifTrue:[
			anIndentedPrinterStream put: String cr.
	
			start := self selectionInterval first.
	
			self replaceSelectionWith: anIndentedPrinterStream contents.
		
			self selectInterval: (start to: start + anIndentedPrinterStream contents size - 1). true]
		ifFalse:[
			self addString: '  '. false.
		]

]

{ #category : #'typing support' }
OccamTextEditor >> specialShiftCmdKeys [

"Private - return array of key codes that represent single keys acting
as if shift-command were also being pressed"

^#(
	1	"home"
	3	"enter"
	4	"end"
	8	"backspace"
	9 	"tab"
	11	"page up"
	12	"page down"
	27	"escape"
	28	"left arrow"
	29	"right arrow"
	30	"up arrow"
	31	"down arrow"
	127	"delete"
	)
]
