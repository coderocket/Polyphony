Class {
	#name : #ASTPar,
	#superclass : #ASTProcess,
	#instVars : [
		'pARToken',
		'processes',
		'eNDToken',
		'bEGINToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTPar >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitPar: self
]

{ #category : #generated }
ASTPar >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTPar >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTPar >> callsProcedureNamed: aString [
	^ processes anySatisfy: [ :p | p callsProcedureNamed: aString ]
]

{ #category : #generated }
ASTPar >> compositeNodeVariables [
	^ #(#processes)
]

{ #category : #generated }
ASTPar >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTPar >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTPar >> flattenParallels [
	^self subProcesses 
]

{ #category : #'generated-initialize-release' }
ASTPar >> initialize [
	super initialize.
	processes := OrderedCollection new: 2.
]

{ #category : #'as yet unclassified' }
ASTPar >> memoryFootprintIn: aPlatform inContext: aContext [

	" this is wrong because it does not calculate the space required for keeping free variables. "
	
	^self subProcesses inject: (aPlatform sizeOf: 'PROCESS') into:[:acc :each | acc + (aPlatform sizeOf: 'PROCESS') ].

]

{ #category : #generated }
ASTPar >> pARToken [
	^ pARToken
]

{ #category : #generated }
ASTPar >> pARToken: aSmaCCToken [
	pARToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTPar >> parallelComponents [ 

	^ self processes inject: OrderedCollection new into: [ :acc :each | acc addAll: each parallelComponents . acc ]
	
]

{ #category : #generated }
ASTPar >> processes [
	^ processes
]

{ #category : #generated }
ASTPar >> processes: anOrderedCollection [
	self setParents: self processes to: nil.
	processes := anOrderedCollection.
	self setParents: self processes to: self
]

{ #category : #accessing }
ASTPar >> stopPosition [ 

	^eNDToken startPosition 
]

{ #category : #generated }
ASTPar >> tokenVariables [
	^ #(#pARToken #bEGINToken #eNDToken)
]
