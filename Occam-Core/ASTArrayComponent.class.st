Class {
	#name : #ASTArrayComponent,
	#superclass : #ASTLValue,
	#instVars : [
		'array',
		'leftBracketToken',
		'expr',
		'rightBracketToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTArrayComponent >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitArrayComponent: self
]

{ #category : #generated }
ASTArrayComponent >> array [
	^ array
]

{ #category : #generated }
ASTArrayComponent >> array: anASTLValue [
	self array notNil
		ifTrue: [ self array parent: nil ].
	array := anASTLValue.
	self array notNil
		ifTrue: [ self array parent: self ]
]

{ #category : #converting }
ASTArrayComponent >> asString [
	^self array asString, '[', self expr asString, ']'
]

{ #category : #testing }
ASTArrayComponent >> contains: anASTLValue [

	^(self = anASTLValue) or:[array contains: anASTLValue]

]

{ #category : #generated }
ASTArrayComponent >> expr [
	^ expr
]

{ #category : #generated }
ASTArrayComponent >> expr: anASTRoot [
	self expr notNil
		ifTrue: [ self expr parent: nil ].
	expr := anASTRoot.
	self expr notNil
		ifTrue: [ self expr parent: self ]
]

{ #category : #generated }
ASTArrayComponent >> ignoredTokenVariables [
	^ #(#leftBracketToken #rightBracketToken)
]

{ #category : #generated }
ASTArrayComponent >> leftBracketToken [
	^ leftBracketToken
]

{ #category : #generated }
ASTArrayComponent >> leftBracketToken: aSmaCCToken [
	leftBracketToken := aSmaCCToken
]

{ #category : #generated }
ASTArrayComponent >> nodeVariables [
	^ #(#array #expr)
]

{ #category : #'as yet unclassified' }
ASTArrayComponent >> principalName [
	^array principalName
]

{ #category : #generated }
ASTArrayComponent >> rightBracketToken [
	^ rightBracketToken
]

{ #category : #generated }
ASTArrayComponent >> rightBracketToken: aSmaCCToken [
	rightBracketToken := aSmaCCToken
]
