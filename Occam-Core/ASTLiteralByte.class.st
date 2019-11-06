Class {
	#name : #ASTLiteralByte,
	#superclass : #ASTLiteral,
	#instVars : [
		'byte'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTLiteralByte >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLiteralByte: self
]

{ #category : #generated }
ASTLiteralByte >> byte [
	^ byte
]

{ #category : #generated }
ASTLiteralByte >> byte: aSmaCCToken [
	byte := aSmaCCToken
]

{ #category : #streaming }
ASTLiteralByte >> streamOn: aWriteStream [

	aWriteStream put: byte value.

]

{ #category : #generated }
ASTLiteralByte >> tokenVariables [
	^ #(#byte)
]
