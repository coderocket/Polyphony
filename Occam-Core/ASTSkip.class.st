Class {
	#name : #ASTSkip,
	#superclass : #ASTProcess,
	#instVars : [
		'sKIPToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTSkip >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitSkip: self
]

{ #category : #generated }
ASTSkip >> sKIPToken [
	^ sKIPToken
]

{ #category : #generated }
ASTSkip >> sKIPToken: aSmaCCToken [
	sKIPToken := aSmaCCToken
]

{ #category : #generated }
ASTSkip >> tokenVariables [
	^ #(#sKIPToken)
]
