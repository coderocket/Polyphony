Class {
	#name : #ASTUsing,
	#superclass : #ASTRoot,
	#instVars : [
		'uSINGToken',
		'divideTokens',
		'names',
		'periodToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTUsing >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitUsing: self
]

{ #category : #generated }
ASTUsing >> compositeTokenVariables [
	^ #(#divideTokens #names)
]

{ #category : #generated }
ASTUsing >> divideTokens [
	^ divideTokens
]

{ #category : #generated }
ASTUsing >> divideTokens: anOrderedCollection [
	divideTokens := anOrderedCollection
]

{ #category : #'generated-initialize-release' }
ASTUsing >> initialize [
	super initialize.
	divideTokens := OrderedCollection new: 2.
	names := OrderedCollection new: 2.
]

{ #category : #generated }
ASTUsing >> names [
	^ names
]

{ #category : #generated }
ASTUsing >> names: anOrderedCollection [
	names := anOrderedCollection
]

{ #category : #generated }
ASTUsing >> periodToken [
	^ periodToken
]

{ #category : #generated }
ASTUsing >> periodToken: aSmaCCToken [
	periodToken := aSmaCCToken
]

{ #category : #generated }
ASTUsing >> tokenVariables [
	^ #(#uSINGToken #periodToken)
]

{ #category : #generated }
ASTUsing >> uSINGToken [
	^ uSINGToken
]

{ #category : #generated }
ASTUsing >> uSINGToken: aSmaCCToken [
	uSINGToken := aSmaCCToken
]
