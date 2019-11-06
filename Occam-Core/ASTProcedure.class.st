Class {
	#name : #ASTProcedure,
	#superclass : #ASTProcedureLike,
	#instVars : [
		'bEGINToken',
		'locals',
		'body',
		'eNDToken',
		'uses',
		'diagramDepth'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #scope }
ASTProcedure >> abstractionClosure [

	"All the abstractions that are used by this abstraction. We remove the abstractions that are defined directly by this procedure because they will be generated in the proper place as part of the compilation of this procedure."
	
	^UsedAbstractionsCollector collect: self body inContext: self	

]

{ #category : #generated }
ASTProcedure >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitProcedure: self
]

{ #category : #adding }
ASTProcedure >> addFunctionNamed: aString [

	| aFunction |
	
	aFunction := self makeFunctionNamed: aString.
	self locals add: aFunction. 
	
	aFunction parent: self.
	
	self check
]

{ #category : #adding }
ASTProcedure >> addProcedureNamed: aString [

	| aProcedure |
	
	aProcedure := self makeProcedureNamed: aString.
	
	self locals add: aProcedure. 
	
	aProcedure parent: self.
	
	self check.
]

{ #category : #generated }
ASTProcedure >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTProcedure >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #generated }
ASTProcedure >> body [
	^ body
]

{ #category : #generated }
ASTProcedure >> body: anASTProcess [
	self body notNil
		ifTrue: [ self body parent: nil ].
	body := anASTProcess.
	self body notNil
		ifTrue: [ self body parent: self ]
]

{ #category : #scope }
ASTProcedure >> callsProcedureNamed: aString [
	^ (body callsProcedureNamed: aString) or:[(locals select:[:each | each isKindOf: ASTProcedure ]) anySatisfy: [ :p | p callsProcedureNamed: aString ] ]
]

{ #category : #checking }
ASTProcedure >> check [ 
	
	| p |

	TypeChecker check: self body inContext: self.

	p := self.
	
	[p isKindOf: ASTLibrary] whileFalse: [ 
		p announcer announce: GLMItemChanged. p := p parent.
	].

	p announcer announce: GLMItemChanged.

]

{ #category : #compiling }
ASTProcedure >> compileOn: aWriteStream [ 

	| abstractions |
	
	abstractions := ((self topologicSort: self abstractionClosure) 
							reject:[:each | each isExternal ])
									reject:[:each | self lookupHere: each name value ifFound:[true] ifNone:[false] ].
	
	abstractions do:[:each | Compiler compile:each on: aWriteStream ]
]

{ #category : #generated }
ASTProcedure >> compositeNodeVariables [
	^ #(#uses #locals #params)
]

{ #category : #accessing }
ASTProcedure >> contractDiagramDepth [

	diagramDepth ifNil:[ diagramDepth := 0].
	
	(diagramDepth >= 50)
		ifTrue:[ diagramDepth := diagramDepth - 50 ]
	
]

{ #category : #compiling }
ASTProcedure >> cppName [

	^self name value copyReplaceAll:'.' with:'_'
]

{ #category : #accessing }
ASTProcedure >> diagramDepth [

	diagramDepth ifNil:[
		diagramDepth := 0
	].

	^diagramDepth
]

{ #category : #generated }
ASTProcedure >> diagramDepth: anObject [
	diagramDepth := anObject
]

{ #category : #'process graph' }
ASTProcedure >> diagramIn: aView [

	self body simpleDiagram: aView inContext: self withColor: Color black atDepth: self diagramDepth.


]

{ #category : #generated }
ASTProcedure >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTProcedure >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #accessing }
ASTProcedure >> expandDiagramDepth [

	diagramDepth ifNil:[ diagramDepth := 0].
	
	diagramDepth := diagramDepth + 50.
	
]

{ #category : #compiling }
ASTProcedure >> generateCppCodeOn: anIndentedPrinterStream [ 

	anIndentedPrinterStream put:'namespace Polyphony {'; newLine.

	self compileOn: anIndentedPrinterStream.
	
	anIndentedPrinterStream put: 'auto program(functor_process('; put: self cppName ; put: '));'; newLine.

	anIndentedPrinterStream put:'}'; newLine.	
]

{ #category : #compiling }
ASTProcedure >> generateSketchNamed: aString InPath: anotherString [

	| aWriteStream sketchPath |

	(anotherString asFileReference / aString) ensureCreateDirectory.

	sketchPath := anotherString asFileReference / aString / (aString, '.ino').
	 
	aWriteStream := IndentedPrinterStream new.
		
	self writePolyphonyPrologueOn: aWriteStream.
	
	self generateCppCodeOn: aWriteStream.
	
	self writePolyphonyEpilogueOn: aWriteStream.
	
	sketchPath deleteIfAbsent:[].
	
	sketchPath writeStreamDo: [ :stream | stream nextPutAll: aWriteStream contents ]

]

{ #category : #'generated-initialize-release' }
ASTProcedure >> initialize [
	super initialize.
	uses := OrderedCollection new: 2.
	locals := OrderedCollection new: 2.
]

{ #category : #'process graph' }
ASTProcedure >> inputs [

	| aSet |

	parent ifNil:[^Set new].
	
	aSet := body inputs: self.
		
	^aSet select:[:each | self isFree: each principalName value ]
]

{ #category : #testing }
ASTProcedure >> isClosed [

	^self params isEmpty 
	
]

{ #category : #generated }
ASTProcedure >> locals [
	^ locals
]

{ #category : #generated }
ASTProcedure >> locals: anOrderedCollection [
	self setParents: self locals to: nil.
	locals := anOrderedCollection.
	self setParents: self locals to: self
]

{ #category : #scope }
ASTProcedure >> lookupHere: aString ifFound: aBlock ifNone: exceptionBlock [
	^locals detect: [:each | each name value = aString] ifFound: aBlock ifNone:[
		params detect: [ :each | each name value = aString ] ifFound: aBlock ifNone:exceptionBlock ]
			
]

{ #category : #generated }
ASTProcedure >> nodeVariables [
	^ #(#body #doc)
]

{ #category : #'process graph' }
ASTProcedure >> outputs [

	| aSet |

	parent ifNil:[^Set new].
	
	aSet := body outputs: self.
		
	^aSet select:[:each | self isFree: each principalName value ]
]

{ #category : #scope }
ASTProcedure >> removeAbstraction: anASTProcedure [

	locals remove: anASTProcedure.
	
	self check
]

{ #category : #streaming }
ASTProcedure >> streamOn: aWriteStream [

	aWriteStream put: 'PROC '.
	super streamOn: aWriteStream.
	aWriteStream open.
	self locals do: [ :each | each streamOn: aWriteStream. aWriteStream newLine].
	aWriteStream putManyLines: self body localSource trimRight.
	aWriteStream close; put:':'.
]

{ #category : #generated }
ASTProcedure >> tokenVariables [
	^ #(#bEGINToken #eNDToken #pROCToken #leftParenToken #rightParenToken #name #periodToken)
]

{ #category : #generated }
ASTProcedure >> uses [
	^ uses
]

{ #category : #generated }
ASTProcedure >> uses: anOrderedCollection [
	self setParents: self uses to: nil.
	uses := anOrderedCollection.
	self setParents: self uses to: self
]

{ #category : #writing }
ASTProcedure >> writePolyphonyEpilogueOn: aWriteStream [ 

	aWriteStream put: ('

void setup() {

	machine_setup();
	
	machine_schedule(&Polyphony::program);

	machine_start();
}

void loop() { }
')

]

{ #category : #writing }
ASTProcedure >> writePolyphonyPrologueOn: aWriteStream [

	aWriteStream put:'#include <Polyphony.h>' ; put: String cr.

	self nestedImports do:[:each |
		aWriteStream put: '#include <Polyphony.'; put: each name value ; put: '.h>' ; put: String cr ].
		

]
