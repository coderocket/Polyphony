Class {
	#name : #ASTUse,
	#superclass : #ASTRoot,
	#instVars : [
		'uSEToken',
		'names',
		'commaTokens',
		'periodToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTUse >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitUse: self
]

{ #category : #generated }
ASTUse >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
ASTUse >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
ASTUse >> compositeTokenVariables [
	^ #(#names #commaTokens)
]

{ #category : #'generated-initialize-release' }
ASTUse >> initialize [
	super initialize.
	names := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
ASTUse >> names [
	^ names
]

{ #category : #generated }
ASTUse >> names: anOrderedCollection [
	names := anOrderedCollection
]

{ #category : #generated }
ASTUse >> periodToken [
	^ periodToken
]

{ #category : #generated }
ASTUse >> periodToken: aSmaCCToken [
	periodToken := aSmaCCToken
]

{ #category : #generated }
ASTUse >> tokenVariables [
	^ #(#uSEToken #periodToken)
]

{ #category : #generated }
ASTUse >> uSEToken [
	^ uSEToken
]

{ #category : #generated }
ASTUse >> uSEToken: aSmaCCToken [
	uSEToken := aSmaCCToken
]
