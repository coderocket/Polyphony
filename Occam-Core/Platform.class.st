Class {
	#name : #Platform,
	#superclass : #Object,
	#instVars : [
		'memorySize'
	],
	#category : #'Occam-Core-Browser'
}

{ #category : #public }
Platform >> initialize [

	memorySize := Dictionary new.
	
	memorySize at:'BOOL' put: 1.
	memorySize at:'BYTE' put: 1.
	memorySize at:'WORD' put: 2.
	memorySize at:'INT16' put: 2.
	memorySize at:'INT' put: 2.
	memorySize at:'INT32' put: 4.
	memorySize at:'INT64' put: 8.
	memorySize at:'REAL32' put: 4.
	memorySize at:'REAL64' put: 8.
	memorySize at:'TIME' put: 8.
	memorySize at:'TIMER' put: 2.
	memorySize at:'EVENT' put: 2.
	memorySize at:'CHANNEL' put: 2.
	memorySize at:'PROCESS' put: 5.

]

{ #category : #public }
Platform >> sizeOf: aString [

	^memorySize at: aString
	

]

{ #category : #public }
Platform >> sizeOfContext [

	"space required to store all the cpu registers and the return address"
	^32+2
	

]

{ #category : #public }
Platform >> sizeOfPointer [

	^2
	

]
