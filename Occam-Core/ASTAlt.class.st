Class {
	#name : #ASTAlt,
	#superclass : #ASTProcess,
	#instVars : [
		'aLTToken',
		'eNDToken',
		'bEGINToken',
		'guardedCommands'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTAlt >> aLTToken [
	^ aLTToken
]

{ #category : #generated }
ASTAlt >> aLTToken: aSmaCCToken [
	aLTToken := aSmaCCToken
]

{ #category : #generated }
ASTAlt >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitAlt: self
]

{ #category : #generated }
ASTAlt >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTAlt >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTAlt >> callsProcedureNamed: aString [
	^ guardedCommands anySatisfy: [ :p | p callsProcedureNamed: aString ]
]

{ #category : #generated }
ASTAlt >> compositeNodeVariables [
	^ #(#guardedCommands)
]

{ #category : #generated }
ASTAlt >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTAlt >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #generated }
ASTAlt >> guardedCommands [
	^ guardedCommands
]

{ #category : #generated }
ASTAlt >> guardedCommands: anOrderedCollection [
	self setParents: self guardedCommands to: nil.
	guardedCommands := anOrderedCollection.
	self setParents: self guardedCommands to: self
]

{ #category : #'generated-initialize-release' }
ASTAlt >> initialize [
	super initialize.
	guardedCommands := OrderedCollection new: 2.
]

{ #category : #accessing }
ASTAlt >> stopPosition [ 

	^eNDToken startPosition 
]

{ #category : #'process graph' }
ASTAlt >> subProcesses [

	^self guardedCommands inject: Set new into:[ :acc :each | acc add:each process. acc add: each guard input. acc ]
	
]

{ #category : #generated }
ASTAlt >> tokenVariables [
	^ #(#aLTToken #bEGINToken #eNDToken)
]
