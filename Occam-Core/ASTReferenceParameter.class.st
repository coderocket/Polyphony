Class {
	#name : #ASTReferenceParameter,
	#superclass : #ASTParameter,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTReferenceParameter >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitReferenceParameter: self
]

{ #category : #generated }
ASTReferenceParameter >> direction [
	^ direction
]

{ #category : #generated }
ASTReferenceParameter >> direction: anASTDirection [
	self direction notNil
		ifTrue: [ self direction parent: nil ].
	direction := anASTDirection.
	self direction notNil
		ifTrue: [ self direction parent: self ]
]

{ #category : #generated }
ASTReferenceParameter >> name [
	^ name
]

{ #category : #generated }
ASTReferenceParameter >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
ASTReferenceParameter >> nodeVariables [
	^ #(#type #direction)
]

{ #category : #accessing }
ASTReferenceParameter >> style [ 
	^''
	
]

{ #category : #generated }
ASTReferenceParameter >> tokenVariables [
	^ #(#name)
]

{ #category : #generated }
ASTReferenceParameter >> type [
	^ type
]

{ #category : #generated }
ASTReferenceParameter >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]

{ #category : #'as yet unclassified' }
ASTReferenceParameter >> typecheck: anASTExpression with: aTypeChecker [

	super typecheck: anASTExpression with: aTypeChecker.
	
	anASTExpression isLValue 
		ifFalse:[anASTExpression addViolation: 'Not an LValue'].
		 
]
