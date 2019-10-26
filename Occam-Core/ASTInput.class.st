Class {
	#name : #ASTInput,
	#superclass : #ASTProcess,
	#instVars : [
		'questionMarkToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTInput >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitInput: self
]

{ #category : #testing }
ASTInput >> isValidGuardType [
	^true 
]

{ #category : #generated }
ASTInput >> questionMarkToken [
	^ questionMarkToken
]

{ #category : #generated }
ASTInput >> questionMarkToken: aSmaCCToken [
	questionMarkToken := aSmaCCToken
]

{ #category : #generated }
ASTInput >> tokenVariables [
	^ #(#questionMarkToken)
]
