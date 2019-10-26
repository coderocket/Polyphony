Class {
	#name : #ASTDelayedInput,
	#superclass : #ASTInput,
	#instVars : [
		'aFTERToken',
		'expr',
		'timer'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTDelayedInput >> aFTERToken [
	^ aFTERToken
]

{ #category : #generated }
ASTDelayedInput >> aFTERToken: aSmaCCToken [
	aFTERToken := aSmaCCToken
]

{ #category : #generated }
ASTDelayedInput >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitDelayedInput: self
]

{ #category : #generated }
ASTDelayedInput >> expr [
	^ expr
]

{ #category : #generated }
ASTDelayedInput >> expr: anASTRoot [
	self expr notNil
		ifTrue: [ self expr parent: nil ].
	expr := anASTRoot.
	self expr notNil
		ifTrue: [ self expr parent: self ]
]

{ #category : #generated }
ASTDelayedInput >> nodeVariables [
	^ #(#timer #expr)
]

{ #category : #generated }
ASTDelayedInput >> timer [
	^ timer
]

{ #category : #generated }
ASTDelayedInput >> timer: anASTLValue [
	self timer notNil
		ifTrue: [ self timer parent: nil ].
	timer := anASTLValue.
	self timer notNil
		ifTrue: [ self timer parent: self ]
]

{ #category : #generated }
ASTDelayedInput >> tokenVariables [
	^ #(#aFTERToken #questionMarkToken)
]
