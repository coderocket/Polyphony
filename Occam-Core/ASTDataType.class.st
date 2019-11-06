Class {
	#name : #ASTDataType,
	#superclass : #ASTDefinition,
	#instVars : [
		'name',
		'type',
		'periodToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTDataType >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitDataType: self
]

{ #category : #generated }
ASTDataType >> name [
	^ name
]

{ #category : #generated }
ASTDataType >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
ASTDataType >> nodeVariables [
	^ #(#type)
]

{ #category : #accessing }
ASTDataType >> parent: aSmaCCParseNode [
	parent := aSmaCCParseNode
]

{ #category : #generated }
ASTDataType >> periodToken [
	^ periodToken
]

{ #category : #generated }
ASTDataType >> periodToken: aSmaCCToken [
	periodToken := aSmaCCToken
]

{ #category : #streaming }
ASTDataType >> streamOn: aWriteStream [
	type streamOn: aWriteStream.
	aWriteStream put: ' '; put:name value; put:' :'
]

{ #category : #generated }
ASTDataType >> tokenVariables [
	^ #(#name #periodToken)
]

{ #category : #generated }
ASTDataType >> type [
	^ type
]

{ #category : #generated }
ASTDataType >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]
