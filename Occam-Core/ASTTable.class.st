Class {
	#name : #ASTTable,
	#superclass : #ASTExpression,
	#instVars : [
		'leftBracketToken',
		'exprs',
		'commaTokens',
		'rightBracketToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTTable >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitTable: self
]

{ #category : #generated }
ASTTable >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
ASTTable >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
ASTTable >> compositeNodeVariables [
	^ #(#exprs)
]

{ #category : #generated }
ASTTable >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #generated }
ASTTable >> exprs [
	^ exprs
]

{ #category : #generated }
ASTTable >> exprs: anOrderedCollection [
	self setParents: self exprs to: nil.
	exprs := anOrderedCollection.
	self setParents: self exprs to: self
]

{ #category : #generated }
ASTTable >> ignoredTokenVariables [
	^ #(#leftBracketToken #rightBracketToken)
]

{ #category : #'generated-initialize-release' }
ASTTable >> initialize [
	super initialize.
	exprs := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
ASTTable >> leftBracketToken [
	^ leftBracketToken
]

{ #category : #generated }
ASTTable >> leftBracketToken: aSmaCCToken [
	leftBracketToken := aSmaCCToken
]

{ #category : #generated }
ASTTable >> rightBracketToken [
	^ rightBracketToken
]

{ #category : #generated }
ASTTable >> rightBracketToken: aSmaCCToken [
	rightBracketToken := aSmaCCToken
]

{ #category : #streaming }
ASTTable >> streamOn: aWriteStream [

	aWriteStream put: '['.
	
	exprs do:[:each | each streamOn: aWriteStream] separatedBy: ', '.

	aWriteStream put: '['
]
