Class {
	#name : #UsedAbstractionsCollector,
	#superclass : #ASTRootVisitor,
	#instVars : [
		'context',
		'usedRelation'
	],
	#category : #'Occam-Core-Compiler'
}

{ #category : #'as yet unclassified' }
UsedAbstractionsCollector class >> collect: anASTNode inContext: aScope [

	| aUsedAbstractionCollector |
	
	aUsedAbstractionCollector := UsedAbstractionsCollector new.
	
	aUsedAbstractionCollector context: aScope.
	
	aUsedAbstractionCollector acceptNode: anASTNode.
	
	^aUsedAbstractionCollector usedRelation


]

{ #category : #accessing }
UsedAbstractionsCollector >> context: aScope [

	context := aScope
	
]

{ #category : #initialization }
UsedAbstractionsCollector >> initialize [ 
	
	usedRelation := Set new.

]

{ #category : #accessing }
UsedAbstractionsCollector >> usedRelation [
	^usedRelation

]

{ #category : #generated }
UsedAbstractionsCollector >> visitCall: aCallNode [ 

	| anAbstraction |

	anAbstraction := context lookup: aCallNode name value.
	
	usedRelation add: anAbstraction -> aCallNode parentAbstraction.
	
	usedRelation addAll: anAbstraction abstractionClosure.
		
	aCallNode exprs do:[:each | self acceptNode: each].
	
	
]
