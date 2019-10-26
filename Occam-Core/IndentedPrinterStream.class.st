Class {
	#name : #IndentedPrinterStream,
	#superclass : #Object,
	#instVars : [
		'indentation',
		'stream',
		'isClosed'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #writing }
IndentedPrinterStream >> close [
	indentation := indentation - 2.
	isClosed := true
]

{ #category : #writing }
IndentedPrinterStream >> closeIfNecessary [

	isClosed ifFalse:[^self].
	
	self newLine. 
	isClosed := false.

]

{ #category : #accessing }
IndentedPrinterStream >> contents [
	^stream contents
]

{ #category : #initialization }
IndentedPrinterStream >> initialize [
	indentation := 0.
	isClosed := false.
	stream := WriteStream on:''.
]

{ #category : #writing }
IndentedPrinterStream >> newLine [
	stream nextPut: Character cr.
	indentation timesRepeat:[ stream nextPut:Character space]
]

{ #category : #writing }
IndentedPrinterStream >> open [
	isClosed := false.
	indentation := indentation + 2.
	self newLine.
]

{ #category : #writing }
IndentedPrinterStream >> put: aString [
	self closeIfNecessary.
	stream nextPutAll: aString
]
