Class {
	#name : #ArduinoUploader,
	#superclass : #Object,
	#instVars : [
		'boards',
		'ports',
		'memoryLayout',
		'sketchbookPath',
		'boardName',
		'portName'
	],
	#category : #'Occam-Core-Uploader'
}

{ #category : #'instance creation' }
ArduinoUploader class >> openOn: aLibrary [

	self new openOn: (OrderedCollection with: aLibrary).

]

{ #category : #accessing }
ArduinoUploader >> boardName: aString [
	boardName := aString
]

{ #category : #uploading }
ArduinoUploader >> compileSketchIn: aPath [

	| compileCommand anEditor |

	compileCommand := 'compile -b ', boardName, ' ', aPath.
	
	ArduinoCommand execute:compileCommand appendOutputTo: anEditor.

]

{ #category : #'as yet unclassified' }
ArduinoUploader >> detectBoards [

	((ArduinoCommand execute: 'board listall --format json') at:'boards') do:[:each | boards add:each] 

]

{ #category : #'as yet unclassified' }
ArduinoUploader >> detectPorts [
	
	| aDictionary |
	
	ports removeAll.
	
	aDictionary := ArduinoCommand execute: 'board list --format json'.
	aDictionary isEmpty ifFalse:[
		(aDictionary at: 'serialBoards') do: [ :arg1 | ports add: (arg1 at: 'port') ] 
	]

]

{ #category : #uploading }
ArduinoUploader >> generateMachineIn: aPath [
	
	| machineFile |
	
	memoryLayout writeFileInPath: aPath.
	
	machineFile := 	aPath asFileReference / 'machine.cpp'.
		
	machineFile exists ifTrue:[
		machineFile delete
	].
	
	FileSystem disk workingDirectory / 'machine.cpp.proto' copyTo: machineFile.

]

{ #category : #initialization }
ArduinoUploader >> initialize [

	sketchbookPath := 'C:\Users\davidf.MGMT\Documents\Arduino' "Hard coded for now until arduino-cli fix the wrong output from this command. (ArduinoCommand execute:'config dump --format json')".
	
	boards := GLMAnnouncingCollection new.
	
	ports := GLMAnnouncingCollection new.
	
]

{ #category : #accessing }
ArduinoUploader >> memoryLayout: aMemoryLayout [
	memoryLayout := aMemoryLayout 
]

{ #category : #accessing }
ArduinoUploader >> portName: aString [
	portName := aString
]

{ #category : #uploading }
ArduinoUploader >> upload: aProc [

	|  sketchPath |

	sketchPath := (sketchbookPath asFileReference / aProc cppName) pathString.

	aProc generateSketchNamed: aProc cppName InPath: sketchbookPath.

	self generateMachineIn: sketchPath.
	self compileSketchIn: sketchPath.
	self uploadSketchIn: sketchPath.

]

{ #category : #uploading }
ArduinoUploader >> uploadSketchIn: aPath [

	| uploadCommand anEditor |
	
	uploadCommand := 'upload -p ', portName, ' --fqbn ', boardName, ' ', aPath.
	
	portName ifNotNil:[ArduinoCommand execute:uploadCommand appendOutputTo: anEditor].

]
