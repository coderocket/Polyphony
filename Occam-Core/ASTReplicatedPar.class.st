Class {
	#name : #ASTReplicatedPar,
	#superclass : #ASTProcess,
	#instVars : [
		'pARToken',
		'process',
		'unrolled'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTReplicatedPar >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitReplicatedPar: self
]

{ #category : #generated }
ASTReplicatedPar >> nodeVariables [
	^ #(#process)
]

{ #category : #generated }
ASTReplicatedPar >> pARToken [
	^ pARToken
]

{ #category : #generated }
ASTReplicatedPar >> pARToken: aSmaCCToken [
	pARToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedPar >> process [
	^ process
]

{ #category : #generated }
ASTReplicatedPar >> process: anASTReplicatedProcess [
	self process notNil
		ifTrue: [ self process parent: nil ].
	process := anASTReplicatedProcess.
	self process notNil
		ifTrue: [ self process parent: self ]
]

{ #category : #generated }
ASTReplicatedPar >> tokenVariables [
	^ #(#pARToken)
]

{ #category : #'as yet unclassified' }
ASTReplicatedPar >> unroll [

		"PAR
		   INT index : 
		   SEQ
		     index := 0
		     body
		   INT index : 
		   SEQ
		     index := 1
		     body
		   ...
		   INT index : 
		   SEQ
		     index := staticSize - 1
		     body 
		"

	| aPar  anOrderedCollection begin end |
	
	aPar := ASTPar new parent: self parent.
	
	begin := self process attributeNamed:#base.
	
	end := begin + (self process attributeNamed:#count) - 1.
	
	anOrderedCollection := (begin to: end) collect:[ :i | | anAssign aDataType |

			aDataType := ASTDataType new name: self process index; type: (ASTBasicType new name:(SmaCCToken value:'INT')).
			
			aDataType attributeNamed: #hidden put: true.

			anAssign := ASTAssign new lvalue: (ASTVariable new name: self process index); expr: (ASTLiteralInteger fromInteger: i).
			
			anAssign attributeNamed: #hidden put: true.
			
			ASTSeq new sourceFrom: self process body ; processes: (OrderedCollection with: aDataType with:anAssign with: (self process body copyTree )).
		].
	
	aPar eNDToken:(SmaCCToken value:'') ; processes: anOrderedCollection.
	
	self attributeNamed: #localSource ifPresent:[ :value |
		anOrderedCollection do:[:each | each attributeNamed:#localSource put: value ] ].
	
	^aPar

]

{ #category : #generated }
ASTReplicatedPar >> unrolled [
	^ unrolled
]

{ #category : #generated }
ASTReplicatedPar >> unrolled: anObject [
	unrolled := anObject
]
