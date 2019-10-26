Class {
	#name : #ASTOutput,
	#superclass : #ASTProcess,
	#instVars : [
		'expr',
		'bangToken',
		'channel'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTOutput >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitOutput: self
]

{ #category : #generated }
ASTOutput >> bangToken [
	^ bangToken
]

{ #category : #generated }
ASTOutput >> bangToken: aSmaCCToken [
	bangToken := aSmaCCToken
]

{ #category : #generated }
ASTOutput >> channel [
	^ channel
]

{ #category : #generated }
ASTOutput >> channel: anASTLValue [
	self channel notNil
		ifTrue: [ self channel parent: nil ].
	channel := anASTLValue.
	self channel notNil
		ifTrue: [ self channel parent: self ]
]

{ #category : #generated }
ASTOutput >> expr [
	^ expr
]

{ #category : #generated }
ASTOutput >> expr: anASTRoot [
	self expr notNil
		ifTrue: [ self expr parent: nil ].
	expr := anASTRoot.
	self expr notNil
		ifTrue: [ self expr parent: self ]
]

{ #category : #generated }
ASTOutput >> nodeVariables [
	^ #(#channel #expr)
]

{ #category : #'process graph' }
ASTOutput >> outputs: aContext [

	^Set with: channel
]

{ #category : #streaming }
ASTOutput >> streamSelfOn: aWriteStream [

	aWriteStream put:'!'
]

{ #category : #generated }
ASTOutput >> tokenVariables [
	^ #(#bangToken)
]
