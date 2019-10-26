Class {
	#name : #ASTEventType,
	#superclass : #ASTType,
	#instVars : [
		'eVENTToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTEventType >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitEventType: self
]

{ #category : #generated }
ASTEventType >> eVENTToken [
	^ eVENTToken
]

{ #category : #generated }
ASTEventType >> eVENTToken: aSmaCCToken [
	eVENTToken := aSmaCCToken
]

{ #category : #generated }
ASTEventType >> tokenVariables [
	^ #(#eVENTToken)
]
