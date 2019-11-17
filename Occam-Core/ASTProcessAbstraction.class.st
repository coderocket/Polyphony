Class {
	#name : #ASTProcessAbstraction,
	#superclass : #ASTScope,
	#instVars : [
		'leftParenToken',
		'params',
		'commaTokens',
		'rightParenToken',
		'uses',
		'bEGINToken',
		'locals',
		'body',
		'eNDToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #scope }
ASTProcessAbstraction >> abstractionClosure [

	"All the abstractions that are used by this abstraction. "
	
	^UsedAbstractionsCollector collect: self body inContext: self	

]

{ #category : #generated }
ASTProcessAbstraction >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitProcessAbstraction: self
]

{ #category : #'as yet unclassified' }
ASTProcessAbstraction >> activationMemoryFootprintIn: aPlatform [ 

	^(super activationMemoryFootprintIn: aPlatform) + (body memoryFootprintIn: aPlatform inContext: self).

]

{ #category : #converting }
ASTProcessAbstraction >> asString [ 
	^self name value
]

{ #category : #generated }
ASTProcessAbstraction >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTProcessAbstraction >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #generated }
ASTProcessAbstraction >> body [
	^ body
]

{ #category : #generated }
ASTProcessAbstraction >> body: anASTProcess [
	self body notNil
		ifTrue: [ self body parent: nil ].
	body := anASTProcess.
	self body notNil
		ifTrue: [ self body parent: self ]
]

{ #category : #scope }
ASTProcessAbstraction >> callsProcedureNamed: aString [
	^ (body callsProcedureNamed: aString) or:[(self locals select:[:each | each isKindOf: ASTAbstraction ]) anySatisfy: [ :p | p callsProcedureNamed: aString ] ]
]

{ #category : #checking }
ASTProcessAbstraction >> check [ 
	
	| p |

	TypeChecker check: self body inContext: self.

	p := self.
	
	[p isKindOf: ASTLibrary] whileFalse: [ 
		p announcer announce: GLMItemChanged. p := p parent.
	].

	p announcer announce: GLMItemChanged.

]

{ #category : #generated }
ASTProcessAbstraction >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
ASTProcessAbstraction >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
ASTProcessAbstraction >> compositeNodeVariables [
	^ #(#params #uses #locals)
]

{ #category : #generated }
ASTProcessAbstraction >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #generated }
ASTProcessAbstraction >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTProcessAbstraction >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
ASTProcessAbstraction >> initialize [
	super initialize.
	params := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
	uses := OrderedCollection new: 2.
	locals := OrderedCollection new: 2.
]

{ #category : #'source code' }
ASTProcessAbstraction >> internalizeSource [

	self body internalizeSource

]

{ #category : #testing }
ASTProcessAbstraction >> isCallable [
	^true
]

{ #category : #generated }
ASTProcessAbstraction >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
ASTProcessAbstraction >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #scope }
ASTProcessAbstraction >> localAbbrevs [ 

	^self locals select:[:each | each isKindOf: ASTAbbreviation  ]
]

{ #category : #scope }
ASTProcessAbstraction >> localVariables [

	^self locals select:[:each | each isKindOf: ASTDataType ]
]

{ #category : #generated }
ASTProcessAbstraction >> locals [
	^ locals
]

{ #category : #generated }
ASTProcessAbstraction >> locals: anOrderedCollection [
	self setParents: self locals to: nil.
	locals := anOrderedCollection.
	self setParents: self locals to: self
]

{ #category : #scope }
ASTProcessAbstraction >> lookupHere: aString ifFound: aBlock ifNone: exceptionBlock [
	^locals detect: [:each | each name value = aString] ifFound: aBlock ifNone:[
		params detect: [ :each | each name value = aString ] ifFound: aBlock ifNone:exceptionBlock ]
			
]

{ #category : #removing }
ASTProcessAbstraction >> moveParam: anASTNode after: existingNode [ 

	(anASTNode = existingNode) ifTrue:[^self].
		
	self params remove: anASTNode.
	self params add: anASTNode after: existingNode.
	
	self check.
	

	
]

{ #category : #generated }
ASTProcessAbstraction >> nodeVariables [
	^ #(#body #doc)
]

{ #category : #generated }
ASTProcessAbstraction >> params [
	^ params
]

{ #category : #generated }
ASTProcessAbstraction >> params: anOrderedCollection [
	self setParents: self params to: nil.
	params := anOrderedCollection.
	self setParents: self params to: self
]

{ #category : #parsing }
ASTProcessAbstraction >> parseBody: aString [

	| aParser anAST |

	aParser := OccamCoreParser on: (ReadStream on: aString trimRight, String cr).
	
	aParser setStartingState: OccamCoreParser startingStateForProcess.
		
	anAST := aParser parse.

	"once we have successfully parsed the string we replace the body with the resulting ast and
	set its localsource to the text."
	
	anAST attributeNamed: #localSource put: aString.
	 
	self body: anAST.
	self check.
]

{ #category : #parsing }
ASTProcessAbstraction >> parseLocalAbbrev: aString [

	| aParser anAST |

	aParser := OccamCoreParser on: (ReadStream on: aString).
	
	aParser setStartingState: OccamCoreParser startingStateForAbbreviation. 
	 
	anAST := aParser parse.
		
	TypeChecker check: anAST inContext: self.
	
	self locals add: anAST.
	anAST parent: self.
	
	self check
]

{ #category : #parsing }
ASTProcessAbstraction >> parseLocalVariable: aString [

	| aParser anAST |

	aParser := OccamCoreParser on: (ReadStream on: aString).
	
	aParser setStartingState: OccamCoreParser startingStateForDataType.
	 
	anAST := aParser parse.
		
	self locals add: anAST.
	anAST parent: self.
	
	self check.
]

{ #category : #removing }
ASTProcessAbstraction >> removeAbstraction: anASTProcedure [

	locals remove: anASTProcedure.
	
	self check
]

{ #category : #generated }
ASTProcessAbstraction >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
ASTProcessAbstraction >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #streaming }
ASTProcessAbstraction >> streamBodyOn: aWriteStream [

	aWriteStream newLine; putManyLines: self body localSource trimRight.
	aWriteStream close; put:':'.

]

{ #category : #generated }
ASTProcessAbstraction >> tokenVariables [
	^ #(#leftParenToken #rightParenToken #bEGINToken #eNDToken #name #periodToken)
]

{ #category : #generated }
ASTProcessAbstraction >> uses [
	^ uses
]

{ #category : #generated }
ASTProcessAbstraction >> uses: anOrderedCollection [
	self setParents: self uses to: nil.
	uses := anOrderedCollection.
	self setParents: self uses to: self
]
