Class {
	#name : #ASTExternalFunction,
	#superclass : #ASTFunctionLike,
	#instVars : [
		'eXTERNALToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTExternalFunction >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitExternalFunction: self
]

{ #category : #generated }
ASTExternalFunction >> eXTERNALToken [
	^ eXTERNALToken
]

{ #category : #generated }
ASTExternalFunction >> eXTERNALToken: aSmaCCToken [
	eXTERNALToken := aSmaCCToken
]

{ #category : #testing }
ASTExternalFunction >> isExternal [ 	
	^true
]

{ #category : #testing }
ASTExternalFunction >> isLocked [ 
	^true
]

{ #category : #generated }
ASTExternalFunction >> tokenVariables [
	^ #(#eXTERNALToken #fUNCTIONToken #leftParenToken #rightParenToken #name #periodToken)
]
