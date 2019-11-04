Class {
	#name : #ASTParameter,
	#superclass : #ASTRoot,
	#instVars : [
		'name',
		'type'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTParameter >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitParameter: self
]

{ #category : #'as yet unclassified' }
ASTParameter >> changeStyleTo: aString [ 
	self subclassResponsibility 
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
	^ #(#type)
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
ASTParameter >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]

{ #category : #'as yet unclassified' }
ASTParameter >> typecheck: anASTExpression with: aTypeChecker [

(self type subsumes:(aTypeChecker acceptNode: anASTExpression))
	ifFalse:[anASTExpression addViolation: 'Type mismatch'].
]
