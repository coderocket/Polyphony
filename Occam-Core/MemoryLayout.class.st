Class {
	#name : #MemoryLayout,
	#superclass : #Object,
	#instVars : [
		'totalMemorySize',
		'numProcessors',
		'processorStackSize',
		'schedulerStackSize',
		'minimumStackSize',
		'debugSupport'
	],
	#classVars : [
		'memoryLayoutForBoard',
		'sramForBoard'
	],
	#category : #'Occam-Core-Browser'
}

{ #category : #'as yet unclassified' }
MemoryLayout class >> forBoard: aString [

	^memoryLayoutForBoard at: aString ifAbsentPut:[
		
		| aMemoryLayout |
		
		aMemoryLayout := MemoryLayout new.
		aMemoryLayout totalMemorySize: (self sramForBoard: aString).
		
		aMemoryLayout
	]

]

{ #category : #'class initialization' }
MemoryLayout class >> initialize [ 

	"self initialize"
	
	memoryLayoutForBoard := Dictionary new.
	
	sramForBoard := Dictionary new.
	
	sramForBoard 
		at: 'Arduino Uno WiFi Rev2' put: 6144;	
		at: 'Arduino YÃºn' put: 2560;
		at: 'Arduino Leonardo' put: 2560;
		at: 'Arduino Leonardo ETH' put: 2560;
		at: 'Arduino Esplora' put: 2560;
		at: 'Arduino Gemma' put:512;
		at: 'Arduino Mega ADK' put:8192;
		at: 'Arduino/Genuino Mega or Mega 2560' put:8192;
		at: 'Arduino/Genuino Micro' put: 2560;
		at: 'Arduino Robot Control' put:2560;
		at: 'Arduino Robot Motor' put:2560;
		at: 'LilyPad Arduino USB' put: 2560
	
]

{ #category : #'as yet unclassified' }
MemoryLayout class >> sramForBoard: aString [

	^sramForBoard at: aString ifAbsent:[2048].
]

{ #category : #accessing }
MemoryLayout >> cells [

	| memoryLayout |
	
	memoryLayout := OrderedCollection new.

	memoryLayout add: Color paleRed -> (self machineSize * 1.0 / totalMemorySize). 
	
	memoryLayout add: Color paleYellow -> (schedulerStackSize * 1.0 / totalMemorySize). 
	
	memoryLayout addAll: ((Interval from: 1 to: numProcessors) collect:[:each | Color paleGreen -> (processorStackSize * 1.0 / totalMemorySize) ]).
	
	memoryLayout add: (Color gray:0.6) -> ((totalMemorySize - self machineSize - schedulerStackSize - (numProcessors * processorStackSize) ) * 1.0 / totalMemorySize). 
	
	^memoryLayout 
	 
]

{ #category : #accessing }
MemoryLayout >> debugSupport [
	^debugSupport 
]

{ #category : #accessing }
MemoryLayout >> debugSupport: aBoolean [
	debugSupport := aBoolean
]

{ #category : #'acessing-magritte' }
MemoryLayout >> descriptionDebugSupport [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #debugSupport;
		label: 'Debug LED';
		priority: 5 ;
		yourself
]

{ #category : #'acessing-magritte' }
MemoryLayout >> descriptionNumProcessors [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #numProcessors;
		label: 'Processors';
		yourself
]

{ #category : #'acessing-magritte' }
MemoryLayout >> descriptionProcessorStackSize [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #processorStackSize;
		label: 'Processor Stack';
		yourself
]

{ #category : #'acessing-magritte' }
MemoryLayout >> descriptionSchedulerStackSize [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #schedulerStackSize;
		label: 'Scheduler Stack';
		yourself
]

{ #category : #'acessing-magritte' }
MemoryLayout >> descriptionTotalMemorySize [
	<magritteDescription>
	^ MANumberDescription new
		accessor: #totalMemorySize;
		label: 'Memory Size';
		yourself
]

{ #category : #testing }
MemoryLayout >> ifNotValid: aBlock [
	self isValid ifFalse:[aBlock value]
	
]

{ #category : #initialization }
MemoryLayout >> initialize [ 

	minimumStackSize := 32.

	numProcessors := 1.
	
	processorStackSize := 128.
	
	schedulerStackSize := 48.
	
	totalMemorySize := 2048.
	
	debugSupport := true.
	
	
]

{ #category : #testing }
MemoryLayout >> isValid [ 
	
	^	(numProcessors > 0) and:[ 
		(schedulerStackSize >= minimumStackSize) and:[
		(processorStackSize >= minimumStackSize) and:[
		(self machineSize) + schedulerStackSize + (numProcessors * processorStackSize) <= totalMemorySize ] ] ]. 
	
]

{ #category : #'as yet unclassified' }
MemoryLayout >> machineSize [

	^((numProcessors + 1) * 7) + 7 + 2 + 9 + 4 "(n+1) * sizeof(processor_t) + sizeof(scheduler_t) + sizeof(machine_stackp) + arduino timers + polyphony interrupts"

]

{ #category : #accessing }
MemoryLayout >> numProcessors [ 
	^numProcessors
	
]

{ #category : #accessing }
MemoryLayout >> numProcessors: anInteger [

	| oldNumProcessors |
	
	oldNumProcessors := numProcessors.
	
	numProcessors := anInteger.
	
	self ifNotValid:[
		numProcessors := oldNumProcessors].
	
	self changed 
]

{ #category : #accessing }
MemoryLayout >> processorStackSize [
	^processorStackSize 
]

{ #category : #accessing }
MemoryLayout >> processorStackSize: anInteger [

	| oldProcessorStackSize |
	
	oldProcessorStackSize := processorStackSize.
	
	processorStackSize := anInteger.
	
	self ifNotValid:[processorStackSize := oldProcessorStackSize].
	
	self changed.
]

{ #category : #accessing }
MemoryLayout >> schedulerStackSize [ 
	^schedulerStackSize 
]

{ #category : #accessing }
MemoryLayout >> schedulerStackSize: anInteger [

	| oldSchedulerStackSize |
	
	oldSchedulerStackSize := schedulerStackSize.
	
	schedulerStackSize := anInteger.
	
	self ifNotValid: [ schedulerStackSize := oldSchedulerStackSize].
	
	self changed
]

{ #category : #'stream out' }
MemoryLayout >> streamOn: aWriteStream [

	aWriteStream put:
('#define NUM_PROCESSORS {n}
#define PROCESSOR_STACK_SIZE {ps}
#define OCCAM_SCHEDULER_STACK_SIZE {ss}
' format: (Dictionary with: #n -> (numProcessors + 1) with: #ps -> processorStackSize with: #ss -> schedulerStackSize)).

	debugSupport ifTrue:[
		aWriteStream put:'#define POLYPHONY_DEBUG' ; put: String cr.
	]


]

{ #category : #accessing }
MemoryLayout >> totalMemorySize [
	^totalMemorySize
]

{ #category : #accessing }
MemoryLayout >> totalMemorySize: anInteger [

	| oldTotalMemorySize |
	
	oldTotalMemorySize := totalMemorySize.
	
	totalMemorySize := anInteger.
	
	self ifNotValid:[ 
		totalMemorySize := oldTotalMemorySize].
	
	self changed.
]

{ #category : #writing }
MemoryLayout >> writeFileInPath: aString [

	| aWriteStream filePath |

	filePath := aString asFileReference / 'memory_layout.h'.

	filePath deleteIfAbsent:[].
		 
	aWriteStream := IndentedPrinterStream new.
	
	self streamOn: aWriteStream.

	filePath writeStreamDo: [ :stream | stream nextPutAll: aWriteStream contents ]

]
