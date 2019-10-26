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

{ #category : #generated }
ASTLiteralBoolean >> tokenVariables [
	^ #(#boolean)
]
