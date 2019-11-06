Class {
	#name : #ASTParenthesisExpression,
	#superclass : #ASTExpression,
	#instVars : [
		'leftParenToken',
		'expression',
		'rightParenToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTParenthesisExpression >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitParenthesisExpression: self
]

{ #category : #converting }
ASTParenthesisExpression >> asString [ 	
	^'(', self expression asString, ')'
]

{ #category : #generated }
ASTParenthesisExpression >> expression [
	^ expression
]

{ #category : #generated }
ASTParenthesisExpression >> expression: anASTRoot [
	self expression notNil
		ifTrue: [ self expression parent: nil ].
	expression := anASTRoot.
	self expression notNil
		ifTrue: [ self expression parent: self ]
]

{ #category : #generated }
ASTParenthesisExpression >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
ASTParenthesisExpression >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
ASTParenthesisExpression >> nodeVariables [
	^ #(#expression)
]

{ #category : #generated }
ASTParenthesisExpression >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
ASTParenthesisExpression >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #streaming }
ASTParenthesisExpression >> streamOn: aWriteStream [

	aWriteStream put: '('.
	expression streamOn: aWriteStream.
	aWriteStream put: ')'

]

{ #category : #generated }
ASTParenthesisExpression >> tokenVariables [
	^ #(#leftParenToken #rightParenToken)
]
