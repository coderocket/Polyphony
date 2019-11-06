Class {
	#name : #ASTArrayReferenceType,
	#superclass : #ASTType,
	#instVars : [
		'leftBracketToken',
		'rightBracketToken',
		'type'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTArrayReferenceType >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitArrayReferenceType: self
]

{ #category : #generated }
ASTArrayReferenceType >> ignoredTokenVariables [
	^ #(#leftBracketToken #rightBracketToken)
]

{ #category : #testing }
ASTArrayReferenceType >> isArrayType [
	^true
]

{ #category : #testing }
ASTArrayReferenceType >> isBigEnoughToHold: aType [

	^aType isArrayType and:[type isBigEnoughToHold: aType type] 
]

{ #category : #generated }
ASTArrayReferenceType >> leftBracketToken [
	^ leftBracketToken
]

{ #category : #generated }
ASTArrayReferenceType >> leftBracketToken: aSmaCCToken [
	leftBracketToken := aSmaCCToken
]

{ #category : #generated }
ASTArrayReferenceType >> nodeVariables [
	^ #(#type)
]

{ #category : #generated }
ASTArrayReferenceType >> rightBracketToken [
	^ rightBracketToken
]

{ #category : #generated }
ASTArrayReferenceType >> rightBracketToken: aSmaCCToken [
	rightBracketToken := aSmaCCToken
]

{ #category : #streaming }
ASTArrayReferenceType >> streamOn: aWriteStream [

	aWriteStream put:'[]'.
	type streamOn: aWriteStream.
	
]

{ #category : #'as yet unclassified' }
ASTArrayReferenceType >> subsumes: aType [

	^ aType isArrayType and:[aType type = self type]

]

{ #category : #generated }
ASTArrayReferenceType >> type [
	^ type
]

{ #category : #generated }
ASTArrayReferenceType >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]
