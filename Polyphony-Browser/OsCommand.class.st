Class {
	#name : #OsCommand,
	#superclass : #Object,
	#category : #'Polyphony-Browser'
}

{ #category : #running }
OsCommand class >> execute: aString [

	| aHandle aByteArray numRead aWriteStream |
	
	aHandle := Win32CoProcess launchProcess: aString.

	aWriteStream := WriteStream on:ByteArray new.
	
	aByteArray := ByteArray new:10.

	numRead := 1.

	[ numRead = 0 ]
		whileFalse:[
			[ Win32CoProcess noBytesWaitingIn: aHandle ] whileTrue:[Processor yield].
	
			numRead := Win32CoProcess readProcessOutputFrom: aHandle intoBuffer: aByteArray.		
			aWriteStream nextPutAll: (aByteArray copyFrom:1 to: numRead).
		].
	
	Win32CoProcess closeOutputPipe: aHandle.
	
	^aWriteStream contents asString.
	
]

{ #category : #running }
OsCommand class >> execute: aString appendOutputTo: anEditor [

	| aHandle aByteArray numRead |
	
	
	aHandle := Win32CoProcess launchProcess: aString.
	
	aByteArray := ByteArray new:10.

	numRead := 1.

	[ numRead = 0 ]
		whileFalse:[
			[ Win32CoProcess noBytesWaitingIn: aHandle ] whileTrue:[Processor yield].
	
			numRead := Win32CoProcess readProcessOutputFrom: aHandle intoBuffer: aByteArray.		
			anEditor replaceTextFrom:(anEditor text size + 1) to: (anEditor text size + 1) with: (aByteArray copyFrom:1 to: numRead) asString.
			anEditor textArea scrollPane scrollToEndOfText.
		].
	
	Win32CoProcess closeOutputPipe: aHandle.
	
]
