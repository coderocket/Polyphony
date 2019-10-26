Class {
	#name : #ASTResult,
	#superclass : #ASTProcess,
	#instVars : [
		'rESULTToken',
		'return'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTResult >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitResult: self
]

{ #category : #generated }
ASTResult >> nodeVariables [
	^ #(#return)
]

{ #category : #generated }
ASTResult >> rESULTToken [
	^ rESULTToken
]

{ #category : #generated }
ASTResult >> rESULTToken: aSmaCCToken [
	rESULTToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTResult >> resultIfAbsent: aBlock [
	^self
]

{ #category : #generated }
ASTResult >> return [
	^ return
]

{ #category : #generated }
ASTResult >> return: anASTRoot [
	self return notNil
		ifTrue: [ self return parent: nil ].
	return := anASTRoot.
	self return notNil
		ifTrue: [ self return parent: self ]
]

{ #category : #generated }
ASTResult >> tokenVariables [
	^ #(#rESULTToken)
]
