Class {
	#name : #ASTImmediateInput,
	#superclass : #ASTInput,
	#instVars : [
		'channel',
		'lvalue'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTImmediateInput >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitImmediateInput: self
]

{ #category : #generated }
ASTImmediateInput >> channel [
	^ channel
]

{ #category : #generated }
ASTImmediateInput >> channel: anASTLValue [
	self channel notNil
		ifTrue: [ self channel parent: nil ].
	channel := anASTLValue.
	self channel notNil
		ifTrue: [ self channel parent: self ]
]

{ #category : #accessing }
ASTImmediateInput >> input [ 
	^self

]

{ #category : #'process graph' }
ASTImmediateInput >> inputs: aContext [

	^Set with: channel 
]

{ #category : #generated }
ASTImmediateInput >> lvalue [
	^ lvalue
]

{ #category : #generated }
ASTImmediateInput >> lvalue: anASTLValue [
	self lvalue notNil
		ifTrue: [ self lvalue parent: nil ].
	lvalue := anASTLValue.
	self lvalue notNil
		ifTrue: [ self lvalue parent: self ]
]

{ #category : #generated }
ASTImmediateInput >> nodeVariables [
	^ #(#channel #lvalue)
]
