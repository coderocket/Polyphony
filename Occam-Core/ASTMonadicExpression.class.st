Class {
	#name : #ASTMonadicExpression,
	#superclass : #ASTExpression,
	#instVars : [
		'operator',
		'operand'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTMonadicExpression >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitMonadicExpression: self
]

{ #category : #generated }
ASTMonadicExpression >> nodeVariables [
	^ #(#operand)
]

{ #category : #generated }
ASTMonadicExpression >> operand [
	^ operand
]

{ #category : #generated }
ASTMonadicExpression >> operand: anASTRoot [
	self operand notNil
		ifTrue: [ self operand parent: nil ].
	operand := anASTRoot.
	self operand notNil
		ifTrue: [ self operand parent: self ]
]

{ #category : #generated }
ASTMonadicExpression >> operator [
	^ operator
]

{ #category : #generated }
ASTMonadicExpression >> operator: aSmaCCToken [
	operator := aSmaCCToken
]

{ #category : #streaming }
ASTMonadicExpression >> streamOn: aWriteStream [
	aWriteStream put: operator value; put: ' '.
	operand streamOn: aWriteStream.	
]

{ #category : #generated }
ASTMonadicExpression >> tokenVariables [
	^ #(#operator)
]
