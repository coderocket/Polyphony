Class {
	#name : #MemoryFootprintCalculator,
	#superclass : #ASTRootVisitor,
	#instVars : [
		'processes',
		'platform',
		'context'
	],
	#category : #'Occam-Core-Compiler'
}

{ #category : #visiting }
MemoryFootprintCalculator class >> acceptNode: aProcess inPlatform: aPlatform inContext: aContext [

	| aMemoryFootprintCalculator |
	
	aMemoryFootprintCalculator := self new platform: aPlatform; context: aContext.
	
	aMemoryFootprintCalculator acceptNode: aProcess.
	
	^aMemoryFootprintCalculator
]

{ #category : #accessing }
MemoryFootprintCalculator >> context: aContext [
	context := aContext
]

{ #category : #initialization }
MemoryFootprintCalculator >> initialize [

	processes := OrderedCollection new
]

{ #category : #accessing }
MemoryFootprintCalculator >> platform: aPlatform [
	platform := aPlatform 
]

{ #category : #accessing }
MemoryFootprintCalculator >> processes [ 
	^processes
]

{ #category : #generated }
MemoryFootprintCalculator >> visitCall: aCall [
	
	context lookup: aCall name value ifPresent:[ :p |
		processes addAll: (p memoryFootprintMapIn: platform)] ifAbsent:[] 
]

{ #category : #generated }
MemoryFootprintCalculator >> visitPar: aPar [

	aPar subProcesses do:[:each | processes add: platform sizeOfContext + (each memoryFootprintIn: platform inContext: context)].
	
	super visitPar: aPar.

]
