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

{ #category : #'as yet unclassified' }
ASTReferenceParameter >> changeStyleTo: aString [
	
	| aValueParameter |
	
	(aString = 'VAL') ifFalse:[^self].
	
	aValueParameter := ASTValueParameter new.
	aValueParameter name: self name.
	aValueParameter type: self type.
	aValueParameter attributes addAll: self attributes.
	self become: aValueParameter.
	
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

{ #category : #streaming }
ASTReferenceParameter >> streamOn: aWriteStream [
	type streamOn: aWriteStream.
	aWriteStream put: ' '; put: name value.
	direction ifNotNil:[direction streamOn: aWriteStream].

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
