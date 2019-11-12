Class {
	#name : #ASTExternalFunction,
	#superclass : #ASTAbstraction,
	#instVars : [
		'eXTERNALToken',
		'type',
		'fUNCTIONToken',
		'leftParenToken',
		'params',
		'commaTokens',
		'rightParenToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTExternalFunction >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitExternalFunction: self
]

{ #category : #generated }
ASTExternalFunction >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
ASTExternalFunction >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
ASTExternalFunction >> compositeNodeVariables [
	^ #(#params)
]

{ #category : #generated }
ASTExternalFunction >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #generated }
ASTExternalFunction >> eXTERNALToken [
	^ eXTERNALToken
]

{ #category : #generated }
ASTExternalFunction >> eXTERNALToken: aSmaCCToken [
	eXTERNALToken := aSmaCCToken
]

{ #category : #generated }
ASTExternalFunction >> fUNCTIONToken [
	^ fUNCTIONToken
]

{ #category : #generated }
ASTExternalFunction >> fUNCTIONToken: aSmaCCToken [
	fUNCTIONToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
ASTExternalFunction >> initialize [
	super initialize.
	params := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #testing }
ASTExternalFunction >> isCallable [
	^true
]

{ #category : #testing }
ASTExternalFunction >> isExternal [ 	
	^true
]

{ #category : #testing }
ASTExternalFunction >> isLocked [ 
	^true
]

{ #category : #generated }
ASTExternalFunction >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
ASTExternalFunction >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTExternalFunction >> localAbbrevs [ 

	^self locals select:[:each | each isKindOf: ASTAbbreviation  ]
]

{ #category : #'as yet unclassified' }
ASTExternalFunction >> localVariables [

	^self locals select:[:each | each isKindOf: ASTDataType ]
]

{ #category : #generated }
ASTExternalFunction >> nodeVariables [
	^ #(#type #doc)
]

{ #category : #generated }
ASTExternalFunction >> params [
	^ params
]

{ #category : #generated }
ASTExternalFunction >> params: anOrderedCollection [
	self setParents: self params to: nil.
	params := anOrderedCollection.
	self setParents: self params to: self
]

{ #category : #generated }
ASTExternalFunction >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
ASTExternalFunction >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #streaming }
ASTExternalFunction >> streamOn: aWriteStream [

	aWriteStream put: 'EXTERNAL '.
	type streamOn: aWriteStream.
	aWriteStream put: ' FUNCTION '.
	super streamOn: aWriteStream.
	aWriteStream put:':'.
]

{ #category : #generated }
ASTExternalFunction >> tokenVariables [
	^ #(#eXTERNALToken #fUNCTIONToken #leftParenToken #rightParenToken #name #periodToken)
]

{ #category : #generated }
ASTExternalFunction >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]

{ #category : #'type checking' }
ASTExternalFunction >> typeCheckCall: aCallNode with: aTypeChecker [

	super typeCheckCall: aCallNode with: aTypeChecker.
	^self type
]
