Class {
	#name : #ASTLiteralBoolean,
	#superclass : #ASTLiteral,
	#instVars : [
		'boolean'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTLiteralBoolean >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLiteralBoolean: self
]

{ #category : #generated }
ASTLiteralBoolean >> boolean [
	^ boolean
]

{ #category : #generated }
ASTLiteralBoolean >> boolean: aSmaCCToken [
	boolean := aSmaCCToken
]

{ #category : #streaming }
ASTLiteralBoolean >> streamOn: aWriteStream [

	aWriteStream put: boolean value.

]

{ #category : #generated }
ASTLiteralBoolean >> tokenVariables [
	^ #(#boolean)
]
