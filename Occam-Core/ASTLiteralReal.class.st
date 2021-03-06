Class {
	#name : #ASTLiteralReal,
	#superclass : #ASTLiteral,
	#instVars : [
		'number'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTLiteralReal >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLiteralReal: self
]

{ #category : #generated }
ASTLiteralReal >> number [
	^ number
]

{ #category : #generated }
ASTLiteralReal >> number: aSmaCCToken [
	number := aSmaCCToken
]

{ #category : #streaming }
ASTLiteralReal >> streamOn: aWriteStream [

	aWriteStream put: '#'; put: (number value)

]

{ #category : #generated }
ASTLiteralReal >> tokenVariables [
	^ #(#number)
]
