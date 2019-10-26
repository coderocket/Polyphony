Class {
	#name : #ASTVariable,
	#superclass : #ASTLValue,
	#instVars : [
		'name'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTVariable >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitVariable: self
]

{ #category : #converting }
ASTVariable >> asString [ 

	^self name value
	
]

{ #category : #generated }
ASTVariable >> name [
	^ name
]

{ #category : #generated }
ASTVariable >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTVariable >> principalName [
	^name
]

{ #category : #generated }
ASTVariable >> tokenVariables [
	^ #(#name)
]
