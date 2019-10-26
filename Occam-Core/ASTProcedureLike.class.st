Class {
	#name : #ASTProcedureLike,
	#superclass : #ASTAbstraction,
	#instVars : [
		'pROCToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTProcedureLike >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitProcedureLike: self
]

{ #category : #generated }
ASTProcedureLike >> pROCToken [
	^ pROCToken
]

{ #category : #generated }
ASTProcedureLike >> pROCToken: aSmaCCToken [
	pROCToken := aSmaCCToken
]

{ #category : #generated }
ASTProcedureLike >> tokenVariables [
	^ #(#pROCToken #leftParenToken #rightParenToken #name #periodToken)
]
