Class {
	#name : #ASTIf,
	#superclass : #ASTProcess,
	#instVars : [
		'iFToken',
		'bEGINToken',
		'eNDToken',
		'processes'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTIf >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitIf: self
]

{ #category : #generated }
ASTIf >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTIf >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTIf >> callsProcedureNamed: aString [
	^ processes anySatisfy: [ :p | p callsProcedureNamed: aString ]
]

{ #category : #generated }
ASTIf >> compositeNodeVariables [
	^ #(#processes)
]

{ #category : #generated }
ASTIf >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTIf >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #generated }
ASTIf >> iFToken [
	^ iFToken
]

{ #category : #generated }
ASTIf >> iFToken: aSmaCCToken [
	iFToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
ASTIf >> initialize [
	super initialize.
	processes := OrderedCollection new: 2.
]

{ #category : #generated }
ASTIf >> processes [
	^ processes
]

{ #category : #generated }
ASTIf >> processes: anOrderedCollection [
	self setParents: self processes to: nil.
	processes := anOrderedCollection.
	self setParents: self processes to: self
]

{ #category : #accessing }
ASTIf >> stopPosition [ 

	^eNDToken startPosition 
]

{ #category : #generated }
ASTIf >> tokenVariables [
	^ #(#iFToken #bEGINToken #eNDToken)
]
