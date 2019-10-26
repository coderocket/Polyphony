Class {
	#name : #ASTEventWait,
	#superclass : #ASTInput,
	#instVars : [
		'event',
		'questionMarkQuestionMarkToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTEventWait >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitEventWait: self
]

{ #category : #generated }
ASTEventWait >> event [
	^ event
]

{ #category : #generated }
ASTEventWait >> event: anASTLValue [
	self event notNil
		ifTrue: [ self event parent: nil ].
	event := anASTLValue.
	self event notNil
		ifTrue: [ self event parent: self ]
]

{ #category : #'as yet unclassified' }
ASTEventWait >> input [
	^self
	
]

{ #category : #'process graph' }
ASTEventWait >> inputs: aContext [

	^Set with: event 
]

{ #category : #generated }
ASTEventWait >> nodeVariables [
	^ #(#event)
]

{ #category : #generated }
ASTEventWait >> questionMarkQuestionMarkToken [
	^ questionMarkQuestionMarkToken
]

{ #category : #generated }
ASTEventWait >> questionMarkQuestionMarkToken: aSmaCCToken [
	questionMarkQuestionMarkToken := aSmaCCToken
]

{ #category : #generated }
ASTEventWait >> tokenVariables [
	^ #(#questionMarkQuestionMarkToken)
]
