Class {
	#name : #ASTStop,
	#superclass : #ASTProcess,
	#instVars : [
		'sTOPToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTStop >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitStop: self
]

{ #category : #generated }
ASTStop >> sTOPToken [
	^ sTOPToken
]

{ #category : #generated }
ASTStop >> sTOPToken: aSmaCCToken [
	sTOPToken := aSmaCCToken
]

{ #category : #generated }
ASTStop >> tokenVariables [
	^ #(#sTOPToken)
]
