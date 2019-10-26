Class {
	#name : #CommGraph,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'edges'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #accessing }
CommGraph >> edges: anOrderedCollection [
	edges := anOrderedCollection 

]

{ #category : #accessing }
CommGraph >> vertices: aSet [
	vertices := aSet
	
]
