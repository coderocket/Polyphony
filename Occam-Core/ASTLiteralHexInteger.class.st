Class {
	#name : #ASTLiteralHexInteger,
	#superclass : #ASTLiteral,
	#instVars : [
		'integer'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTLiteralHexInteger >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLiteralHexInteger: self
]

{ #category : #generated }
ASTLiteralHexInteger >> integer [
	^ integer
]

{ #category : #generated }
ASTLiteralHexInteger >> integer: aSmaCCToken [
	integer := aSmaCCToken
]

{ #category : #generated }
ASTLiteralHexInteger >> tokenVariables [
	^ #(#integer)
]
