Class {
	#name : #MemoryLayoutBrowser,
	#superclass : #Object,
	#instVars : [
		'browser'
	],
	#category : #'Occam-Core-Browser'
}

{ #category : #building }
MemoryLayoutBrowser >> build [
	
	browser := GLMTabulator new.
	
	browser row:#details; row:#diagram span:0.2.
	
	browser transmit to:#details; andShow:[ :a | 
		a magritte 
		title:'Memory Layout';
		description: [ :memoryLayout | memoryLayout magritteDescription ] ]. 

	browser transmit to:#diagram; andShow: [ :a | self diagramIn: a].
	
	browser transmit from:#details port:#entity ; toOutsidePort: #selected.

	^browser
]

{ #category : #'process graph' }
MemoryLayoutBrowser >> diagramIn: constructor [

constructor morph

	morph:[ :p :m | 
		
		MemoryLayoutMorph new model: p entity
	]
]

{ #category : #'instance creation' }
MemoryLayoutBrowser >> openOn: aMemoryLayout [

	self build.
	
	browser openOn: aMemoryLayout
	
]
