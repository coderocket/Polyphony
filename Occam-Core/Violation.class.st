Class {
	#name : #Violation,
	#superclass : #Object,
	#instVars : [
		'reason',
		'startPosition',
		'stopPosition'
	],
	#category : #'Occam-Core-Compiler'
}

{ #category : #accessing }
Violation >> range [

	^startPosition to: stopPosition
]

{ #category : #'as yet unclassified' }
Violation >> reason [
	^ reason
]

{ #category : #accessing }
Violation >> reason: aString [
	reason := aString
]

{ #category : #accessing }
Violation >> startPosition: aNumber [

	startPosition := aNumber
]

{ #category : #accessing }
Violation >> stopPosition: aNumber [

	stopPosition := aNumber
]
