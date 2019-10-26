Class {
	#name : #ASTInputGuard,
	#superclass : #ASTRoot,
	#instVars : [
		'test',
		'andToken',
		'input'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTInputGuard >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitInputGuard: self
]

{ #category : #generated }
ASTInputGuard >> andToken [
	^ andToken
]

{ #category : #generated }
ASTInputGuard >> andToken: aSmaCCToken [
	andToken := aSmaCCToken
]

{ #category : #generated }
ASTInputGuard >> input [
	^ input
]

{ #category : #generated }
ASTInputGuard >> input: anASTProcess [
	self input notNil
		ifTrue: [ self input parent: nil ].
	input := anASTProcess.
	self input notNil
		ifTrue: [ self input parent: self ]
]

{ #category : #testing }
ASTInputGuard >> isValidGuardType [
	^true
]

{ #category : #generated }
ASTInputGuard >> nodeVariables [
	^ #(#test #input)
]

{ #category : #generated }
ASTInputGuard >> test [
	^ test
]

{ #category : #generated }
ASTInputGuard >> test: anASTRoot [
	self test notNil
		ifTrue: [ self test parent: nil ].
	test := anASTRoot.
	self test notNil
		ifTrue: [ self test parent: self ]
]

{ #category : #generated }
ASTInputGuard >> tokenVariables [
	^ #(#andToken)
]
