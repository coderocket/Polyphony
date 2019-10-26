Class {
	#name : #ASTBytesIn,
	#superclass : #ASTExpression,
	#instVars : [
		'bYTESINToken',
		'type'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTBytesIn >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitBytesIn: self
]

{ #category : #converting }
ASTBytesIn >> asString [ 

	^'BYTESIN ', type localSource
	
]

{ #category : #generated }
ASTBytesIn >> bYTESINToken [
	^ bYTESINToken
]

{ #category : #generated }
ASTBytesIn >> bYTESINToken: aSmaCCToken [
	bYTESINToken := aSmaCCToken
]

{ #category : #generated }
ASTBytesIn >> nodeVariables [
	^ #(#type)
]

{ #category : #generated }
ASTBytesIn >> tokenVariables [
	^ #(#bYTESINToken)
]

{ #category : #generated }
ASTBytesIn >> type [
	^ type
]

{ #category : #generated }
ASTBytesIn >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]
