Class {
	#name : #ASTWhile,
	#superclass : #ASTProcess,
	#instVars : [
		'wHILEToken',
		'test',
		'bEGINToken',
		'body',
		'eNDToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTWhile >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitWhile: self
]

{ #category : #generated }
ASTWhile >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTWhile >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #generated }
ASTWhile >> body [
	^ body
]

{ #category : #generated }
ASTWhile >> body: anASTProcess [
	self body notNil
		ifTrue: [ self body parent: nil ].
	body := anASTProcess.
	self body notNil
		ifTrue: [ self body parent: self ]
]

{ #category : #'as yet unclassified' }
ASTWhile >> callsProcedureNamed: aString [
	^ body callsProcedureNamed: aString
]

{ #category : #generated }
ASTWhile >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTWhile >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #generated }
ASTWhile >> nodeVariables [
	^ #(#test #body)
]

{ #category : #accessing }
ASTWhile >> stopPosition [ 

	^eNDToken startPosition 
]

{ #category : #generated }
ASTWhile >> test [
	^ test
]

{ #category : #generated }
ASTWhile >> test: anASTRoot [
	self test notNil
		ifTrue: [ self test parent: nil ].
	test := anASTRoot.
	self test notNil
		ifTrue: [ self test parent: self ]
]

{ #category : #generated }
ASTWhile >> tokenVariables [
	^ #(#wHILEToken #bEGINToken #eNDToken)
]

{ #category : #generated }
ASTWhile >> wHILEToken [
	^ wHILEToken
]

{ #category : #generated }
ASTWhile >> wHILEToken: aSmaCCToken [
	wHILEToken := aSmaCCToken
]
