Class {
	#name : #ASTEventSignal,
	#superclass : #ASTProcess,
	#instVars : [
		'event',
		'bangeolToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTEventSignal >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitEventSignal: self
]

{ #category : #generated }
ASTEventSignal >> bangeolToken [
	^ bangeolToken
]

{ #category : #generated }
ASTEventSignal >> bangeolToken: aSmaCCToken [
	bangeolToken := aSmaCCToken
]

{ #category : #generated }
ASTEventSignal >> event [
	^ event
]

{ #category : #generated }
ASTEventSignal >> event: anASTLValue [
	self event notNil
		ifTrue: [ self event parent: nil ].
	event := anASTLValue.
	self event notNil
		ifTrue: [ self event parent: self ]
]

{ #category : #generated }
ASTEventSignal >> nodeVariables [
	^ #(#event)
]

{ #category : #generated }
ASTEventSignal >> tokenVariables [
	^ #(#bangeolToken)
]
