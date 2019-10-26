Class {
	#name : #ASTParameter,
	#superclass : #ASTRoot,
	#instVars : [
		'name',
		'direction',
		'type'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTParameter >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitParameter: self
]

{ #category : #generated }
ASTParameter >> direction [
	^ direction
]

{ #category : #generated }
ASTParameter >> direction: anASTDirection [
	self direction notNil
		ifTrue: [ self direction parent: nil ].
	direction := anASTDirection.
	self direction notNil
		ifTrue: [ self direction parent: self ]
]

{ #category : #generated }
ASTParameter >> name [
	^ name
]

{ #category : #generated }
ASTParameter >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
ASTParameter >> nodeVariables [
	^ #(#type #direction)
]

{ #category : #operations }
ASTParameter >> renameTo: aString [
	self name: (SmaCCToken value: aString)
]

{ #category : #accessing }
ASTParameter >> style [
	^self subclassResponsibility 
]

{ #category : #generated }
ASTParameter >> tokenVariables [
	^ #(#name)
]

{ #category : #generated }
ASTParameter >> type [
	^ type
]

{ #category : #generated }
ASTParameter >> type: anASTRoot [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTRoot.
	self type notNil
		ifTrue: [ self type parent: self ]
]

{ #category : #'as yet unclassified' }
ASTParameter >> typecheck: anASTExpression with: aTypeChecker [

(self type subsumes:(aTypeChecker acceptNode: anASTExpression))
	ifFalse:[anASTExpression addViolation: 'Type mismatch'].
]
