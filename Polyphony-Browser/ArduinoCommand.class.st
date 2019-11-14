Class {
	#name : #ArduinoCommand,
	#superclass : #OsCommand,
	#classVars : [
		'arduinoCommandLine'
	],
	#category : #'Polyphony-Browser'
}

{ #category : #running }
ArduinoCommand class >> execute: aString [

	| result |
	
	result := super execute: arduinoCommandLine, ' ', aString.
 
	^NeoJSONReader fromString:result

]

{ #category : #running }
ArduinoCommand class >> execute: aString appendOutputTo: anEditor [

	super execute: arduinoCommandLine, ' ', aString appendOutputTo: anEditor
]

{ #category : #initialization }
ArduinoCommand class >> initialize [
	"self initialize"
	arduinoCommandLine := 'arduino-cli.exe'
]
