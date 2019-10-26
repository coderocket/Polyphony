Class {
	#name : #ASTLiteralReal64,
	#superclass : #ASTLiteral,
	#instVars : [
		'number'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTLiteralReal64 >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLiteralReal64: self
]

{ #category : #generated }
ASTLiteralReal64 >> number [
	^ number
]

{ #category : #generated }
ASTLiteralReal64 >> number: aSmaCCToken [
	number := aSmaCCToken
]

{ #category : #generated }
ASTLiteralReal64 >> tokenVariables [
	^ #(#number)
]
