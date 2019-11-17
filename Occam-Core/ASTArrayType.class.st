Class {
	#name : #ASTArrayType,
	#superclass : #ASTType,
	#instVars : [
		'leftBracketToken',
		'index',
		'rightBracketToken',
		'type'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTArrayType >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitArrayType: self
]

{ #category : #generated }
ASTArrayType >> ignoredTokenVariables [
	^ #(#leftBracketToken #rightBracketToken)
]

{ #category : #generated }
ASTArrayType >> index [
	^ index
]

{ #category : #generated }
ASTArrayType >> index: anASTRoot [
	self index notNil
		ifTrue: [ self index parent: nil ].
	index := anASTRoot.
	self index notNil
		ifTrue: [ self index parent: self ]
]

{ #category : #testing }
ASTArrayType >> isArrayType [
	^true
]

{ #category : #testing }
ASTArrayType >> isBigEnoughToHold: aType [

	^aType isArrayType and:[ (index = aType index) and:[type isBigEnoughToHold: aType type] ]
]

{ #category : #'as yet unclassified' }
ASTArrayType >> isTop [
	^type isTop
]

{ #category : #'as yet unclassified' }
ASTArrayType >> leastUpperBound: aType [

	| elementLUB |
	
	(aType isArrayType) ifFalse:[^ASTBasicType topType].
	(aType index = index) ifFalse:[^ASTBasicType topType].
	
	elementLUB := type leastUpperBound: aType type.
	
	^ASTArrayType new type: elementLUB; index: index.
	 
]

{ #category : #generated }
ASTArrayType >> leftBracketToken [
	^ leftBracketToken
]

{ #category : #generated }
ASTArrayType >> leftBracketToken: aSmaCCToken [
	leftBracketToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTArrayType >> memoryFootprintIn: aPlatform inContext: aContext [
	^index asInteger * (type memoryFootprintIn: aPlatform inContext: aContext) 

]

{ #category : #generated }
ASTArrayType >> nodeVariables [
	^ #(#index #type)
]

{ #category : #generated }
ASTArrayType >> rightBracketToken [
	^ rightBracketToken
]

{ #category : #generated }
ASTArrayType >> rightBracketToken: aSmaCCToken [
	rightBracketToken := aSmaCCToken
]

{ #category : #streaming }
ASTArrayType >> streamOn: aWriteStream [

	aWriteStream put:'['.
	index streamOn: aWriteStream.
	aWriteStream put:'] '.
	type streamOn: aWriteStream.
	
]

{ #category : #generated }
ASTArrayType >> type [
	^ type
]

{ #category : #generated }
ASTArrayType >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]
