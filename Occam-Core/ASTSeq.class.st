Class {
	#name : #ASTSeq,
	#superclass : #ASTProcess,
	#instVars : [
		'sEQToken',
		'processes',
		'eNDToken',
		'bEGINToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTSeq >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitSeq: self
]

{ #category : #generated }
ASTSeq >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTSeq >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTSeq >> callsProcedureNamed: aString [
	^ processes anySatisfy: [ :p | p callsProcedureNamed: aString ]
]

{ #category : #generated }
ASTSeq >> compositeNodeVariables [
	^ #(#processes)
]

{ #category : #generated }
ASTSeq >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTSeq >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
ASTSeq >> initialize [
	super initialize.
	processes := OrderedCollection new: 2.
]

{ #category : #generated }
ASTSeq >> processes [
	^ processes
]

{ #category : #generated }
ASTSeq >> processes: anOrderedCollection [
	self setParents: self processes to: nil.
	processes := anOrderedCollection.
	self setParents: self processes to: self
]

{ #category : #'as yet unclassified' }
ASTSeq >> resultIfAbsent: aBlock [
	
	processes ifEmpty:[^aBlock value].
	
	^processes last resultIfAbsent: aBlock
]

{ #category : #generated }
ASTSeq >> sEQToken [
	^ sEQToken
]

{ #category : #generated }
ASTSeq >> sEQToken: aSmaCCToken [
	sEQToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTSeq >> sourceFrom: anASTNode [

	self attributeNamed: #startPosition put: anASTNode startPosition.
	self attributeNamed: #stopPosition put: anASTNode stopPosition.

]

{ #category : #accessing }
ASTSeq >> stopPosition [ 

	^ self
		attributeNamed: #stopPosition
		ifAbsentPut: [eNDToken startPosition] 
]

{ #category : #generated }
ASTSeq >> tokenVariables [
	^ #(#sEQToken #bEGINToken #eNDToken)
]
