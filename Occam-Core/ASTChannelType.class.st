Class {
	#name : #ASTChannelType,
	#superclass : #ASTInputSourceType,
	#instVars : [
		'cHANToken',
		'oFToken',
		'type'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTChannelType >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitChannelType: self
]

{ #category : #generated }
ASTChannelType >> cHANToken [
	^ cHANToken
]

{ #category : #generated }
ASTChannelType >> cHANToken: aSmaCCToken [
	cHANToken := aSmaCCToken
]

{ #category : #generated }
ASTChannelType >> nodeVariables [
	^ #(#type)
]

{ #category : #generated }
ASTChannelType >> oFToken [
	^ oFToken
]

{ #category : #generated }
ASTChannelType >> oFToken: aSmaCCToken [
	oFToken := aSmaCCToken
]

{ #category : #generated }
ASTChannelType >> tokenVariables [
	^ #(#cHANToken #oFToken)
]

{ #category : #accessing }
ASTChannelType >> type [
	^type
]

{ #category : #generated }
ASTChannelType >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]
