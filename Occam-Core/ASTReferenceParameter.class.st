Class {
	#name : #ASTReferenceParameter,
	#superclass : #ASTParameter,
	#instVars : [
		'direction'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTReferenceParameter >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitReferenceParameter: self
]

{ #category : #'as yet unclassified' }
ASTReferenceParameter >> changeDirectionTo: aString [

	self direction: ASTDirNone new.
	
	(aString = '?') ifTrue:[
		self direction: ASTDirIn new ].
	
	(aString = '!') ifTrue:[
		self direction: ASTDirOut new ].

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
ASTReferenceParameter >> nodeVariables [
	^ #(#direction #type)
]

{ #category : #accessing }
ASTReferenceParameter >> style [ 
	^''
	
]

{ #category : #'as yet unclassified' }
ASTReferenceParameter >> typecheck: anASTExpression with: aTypeChecker [

	super typecheck: anASTExpression with: aTypeChecker.
	
	anASTExpression isLValue 
		ifFalse:[anASTExpression addViolation: 'Not an LValue'].
		 
]
