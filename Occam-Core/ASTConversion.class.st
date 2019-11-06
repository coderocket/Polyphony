Class {
	#name : #ASTConversion,
	#superclass : #ASTExpression,
	#instVars : [
		'dataTypeName',
		'operand'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTConversion >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitConversion: self
]

{ #category : #generated }
ASTConversion >> dataTypeName [
	^ dataTypeName
]

{ #category : #generated }
ASTConversion >> dataTypeName: aSmaCCToken [
	dataTypeName := aSmaCCToken
]

{ #category : #generated }
ASTConversion >> nodeVariables [
	^ #(#operand)
]

{ #category : #generated }
ASTConversion >> operand [
	^ operand
]

{ #category : #generated }
ASTConversion >> operand: anASTRoot [
	self operand notNil
		ifTrue: [ self operand parent: nil ].
	operand := anASTRoot.
	self operand notNil
		ifTrue: [ self operand parent: self ]
]

{ #category : #streaming }
ASTConversion >> streamOn: aWriteStream [
	aWriteStream put:'( '; put: dataTypeName value; put: ' '.
	operand streamOn: aWriteStream.
	aWriteStream put:' )'
]

{ #category : #generated }
ASTConversion >> tokenVariables [
	^ #(#dataTypeName)
]
