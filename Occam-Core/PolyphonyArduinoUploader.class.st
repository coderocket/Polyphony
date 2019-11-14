Class {
	#name : #PolyphonyArduinoUploader,
	#superclass : #Object,
	#instVars : [
		'uploader',
		'boards',
		'ports',
		'sketchbookPath'
	],
	#category : #'Occam-Core-Browser'
}

{ #category : #'instance creation' }
PolyphonyArduinoUploader class >> openOn: aLibrary [

	self new openOn: (OrderedCollection with: aLibrary).

]

{ #category : #'as yet unclassified' }
PolyphonyArduinoUploader >> build [

	uploader := GLMTabulator new.
	
	uploader title:'Polyphony Arduino Uploader' translated.
	
	uploader row:[ :r | r column: #boards; column: #memory ; column: #ports; column: #navigator] 
	; row:#diagnostics.
	
	uploader transmit to:#boards ; andShow:[ :a | a list display: boards ; format:[ :each | each at:'name' ] ; updateOn: GLMItemAdded from: boards ; title:'Board' ].

	uploader transmit from:#boards transformed:[:d | MemoryLayout forBoard: (d at:'name')]; to:#memory; andShow:[ :a | self memoryIn: a].
	
	uploader transmit to: #ports; andShow: [ :a | self portsIn: a ].

	uploader transmit to: #navigator; andShow:[ :a | self navigatorIn: a ].

	uploader transmit from: #boards ; from: #ports; from: #memory port:#selected ; from: #navigator port:#selectedProc ; to:#diagnostics ; andShow:[:a | self diagnosticsIn: a ].
		
	self detectBoards.
	
	self detectPorts.

]

{ #category : #compiling }
PolyphonyArduinoUploader >> compile: aProc upload: aBoard layout: aMemoryLayout through: aPort reportIn: aPresentation [

	| fqbn sketchCppName sketchPath compileCommand uploadCommand machineFile |
	
	fqbn := aBoard at:'fqbn'.
	
	sketchCppName := aProc cppName.
	
	aProc generateSketchNamed: sketchCppName InPath: sketchbookPath.
	 
	sketchPath := (sketchbookPath asFileReference / sketchCppName) pathString.
	
	aMemoryLayout writeFileInPath: sketchPath.
	
	machineFile := 	sketchPath asFileReference / 'machine.cpp'.
		
	machineFile exists ifTrue:[
		machineFile delete
	].
	
	FileSystem disk workingDirectory / 'machine.cpp.proto' copyTo: machineFile.

	compileCommand := 'compile -b ', fqbn, ' ', sketchPath.
	
	uploadCommand := 'upload -p ', aPort, ' --fqbn ', fqbn, ' ', sketchPath.

	UIManager default defer: [ 
		aPresentation announce: (GLMTextEditorRequest new 
			action: [ :anEditor | 
				anEditor textArea selectAll.
				anEditor replaceSelectionWith: compileCommand, String cr.
				anEditor unselect. 
				[ ArduinoCommand execute:compileCommand appendOutputTo: anEditor.
				  aPort ifNotNil:[ArduinoCommand execute:uploadCommand appendOutputTo: anEditor] ] fork ]) ].

]

{ #category : #'as yet unclassified' }
PolyphonyArduinoUploader >> detectBoards [

	[((ArduinoCommand execute: 'board listall --format json') at:'boards') do:[:each | boards add:each] ]fork

]

{ #category : #'as yet unclassified' }
PolyphonyArduinoUploader >> detectPorts [

	ports removeAll. uploader update.
	
	[ ((ArduinoCommand execute: 'board list --format json')
		at: 'serialBoards') do: [ :arg1 | ports add: (arg1 at: 'port') ] ]
		fork
]

{ #category : #'as yet unclassified' }
PolyphonyArduinoUploader >> diagnosticsIn: constructor [

	constructor text 
		display: [ :board :port :memory :proc | 'Ready to upload ', proc name value ] ;
		addAction: (GLMGenericAction new
			action: [ :presentation :board :port :memory :proc | self compile: proc upload: board layout: memory through: port reportIn: presentation  ];
			icon: GLMUIThemeExtraIcons glamorousGo;
			title: 'Upload').

]

{ #category : #initialization }
PolyphonyArduinoUploader >> initialize [

	sketchbookPath := 'C:\Users\davidf.MGMT\Documents\Arduino' "Hard coded for now until arduino-cli fix the wrong output from this command. (ArduinoCommand execute:'config dump --format json')".
	
	boards := GLMAnnouncingCollection new.
	
	ports := GLMAnnouncingCollection new.
]

{ #category : #'as yet unclassified' }
PolyphonyArduinoUploader >> memoryIn: constructor [

	| aMemoryLayoutBrowser |
	
	aMemoryLayoutBrowser := MemoryLayoutBrowser new.
	
	constructor custom:(aMemoryLayoutBrowser build) 
]

{ #category : #'as yet unclassified' }
PolyphonyArduinoUploader >> navigatorIn: constructor [

	| aNavigator |
	
	aNavigator := OccamLibraryNavigator new.
	aNavigator showAbbreviations: false.
	aNavigator showOnlyUploadableProcedures: true.
	
	constructor custom:(aNavigator buildNavigator)

]

{ #category : #'instance creation' }
PolyphonyArduinoUploader >> openOn: anOrderedCollection [

	self build.
	uploader openOn: anOrderedCollection 
]

{ #category : #'as yet unclassified' }
PolyphonyArduinoUploader >> portsIn: constructor [

	constructor list display: ports ; 
		updateOn: GLMItemAdded 
		from: ports ; 
		title:'Port' ; 
		addAction: (GLMGenericAction new action: 
			[self detectPorts] ; icon: GLMUIThemeExtraIcons glamorousRefresh ;title: 'Refresh' ; showTitle ).

]
