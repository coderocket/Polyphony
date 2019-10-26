Class {
	#name : #ASTAssign,
	#superclass : #ASTProcess,
	#instVars : [
		'expr',
		'colonEqualToken',
		'lvalue'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTAssign >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitAssign: self
]

{ #category : #generated }
ASTAssign >> colonEqualToken [
	^ colonEqualToken
]

{ #category : #generated }
ASTAssign >> colonEqualToken: aSmaCCToken [
	colonEqualToken := aSmaCCToken
]

{ #category : #generated }
ASTAssign >> expr [
	^ expr
]

{ #category : #generated }
ASTAssign >> expr: anASTRoot [
	self expr notNil
		ifTrue: [ self expr parent: nil ].
	expr := anASTRoot.
	self expr notNil
		ifTrue: [ self expr parent: self ]
]

{ #category : #generated }
ASTAssign >> lvalue [
	^ lvalue
]

{ #category : #generated }
ASTAssign >> lvalue: anASTLValue [
	self lvalue notNil
		ifTrue: [ self lvalue parent: nil ].
	lvalue := anASTLValue.
	self lvalue notNil
		ifTrue: [ self lvalue parent: self ]
]

{ #category : #generated }
ASTAssign >> nodeVariables [
	^ #(#lvalue #expr)
]

{ #category : #generated }
ASTAssign >> tokenVariables [
	^ #(#colonEqualToken)
]
