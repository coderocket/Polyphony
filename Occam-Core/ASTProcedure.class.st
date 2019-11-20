Class {
	#name : #ASTProcedure,
	#superclass : #ASTProcessAbstraction,
	#instVars : [
		'diagramDepth',
		'pROCToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTProcedure >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitProcedure: self
]

{ #category : #compiling }
ASTProcedure >> compileOn: aWriteStream [ 

	| abstractions |
		
	abstractions := ((self topologicSort: self abstractionClosure) 
							reject:[:each | each isExternal ])
									reject:[:each | self lookupHere: each name value ifFound:[true] ifNone:[false] ].
	
	abstractions do:[:each | Compiler compile:each on: aWriteStream ]
]

{ #category : #'process graph' }
ASTProcedure >> contractDiagramDepth [

	diagramDepth ifNil:[ diagramDepth := 0].
	
	(diagramDepth >= 50)
		ifTrue:[ diagramDepth := diagramDepth - 50 ]
	
]

{ #category : #compiling }
ASTProcedure >> cppName [

	^self name value copyReplaceAll:'.' with:'_'
]

{ #category : #'process graph' }
ASTProcedure >> diagramDepth [

	diagramDepth ifNil:[
		diagramDepth := 1
	].

	^diagramDepth
]

{ #category : #generated }
ASTProcedure >> diagramDepth: anObject [
	diagramDepth := anObject
]

{ #category : #'process graph' }
ASTProcedure >> diagramIn: aView [

	| aProcess |
	
	aProcess := self body copyTree.

	ReplicatedParUnroller new acceptNode: aProcess.
	
	ParFlattener new acceptNode: aProcess.

	PartialEvaluator new context: self ; acceptNode: aProcess.
	
	aProcess diagram: aView inContext: self withColor: Color black atDepth: self diagramDepth.


]

{ #category : #'process graph' }
ASTProcedure >> expandDiagramDepth [

	diagramDepth ifNil:[ diagramDepth := 0].
	
	diagramDepth := diagramDepth + 50.
	
]

{ #category : #compiling }
ASTProcedure >> generateCppCodeOn: anIndentedPrinterStream [ 

	anIndentedPrinterStream put:'namespace Polyphony {'; newLine.

	self unfold compileOn: anIndentedPrinterStream.
	
	anIndentedPrinterStream put: 'auto program(functor_process('; put: self cppName ; put: '));'; newLine.

	anIndentedPrinterStream put:'}'; newLine.	
]

{ #category : #compiling }
ASTProcedure >> generateSketchNamed: aString InPath: anotherString [

	| aWriteStream sketchPath |

	(anotherString asFileReference / aString) ensureCreateDirectory.

	sketchPath := anotherString asFileReference / aString / (aString, '.ino').
	 
	aWriteStream := IndentedPrinterStream new.
		
	self writePolyphonyPrologueOn: aWriteStream.
	
	self generateCppCodeOn: aWriteStream.
	
	self writePolyphonyEpilogueOn: aWriteStream.
	
	sketchPath deleteIfAbsent:[].
	
	sketchPath writeStreamDo: [ :stream | stream nextPutAll: aWriteStream contents ]

]

{ #category : #'process graph' }
ASTProcedure >> inputs [

	| aSet |

	parent ifNil:[^Set new].
	
	aSet := body inputs: self.
		
	^aSet select:[:each | self isFree: each principalName value ]
]

{ #category : #testing }
ASTProcedure >> isClosed [

	^self params isEmpty 
	
]

{ #category : #'as yet unclassified' }
ASTProcedure >> memoryFootprintMap [

	| aPlatform aProcedure aMemoryFootprintCalculator |

	aPlatform := Platform new.
		
	aProcedure := self unfold.

	aMemoryFootprintCalculator := MemoryFootprintCalculator new.

	aMemoryFootprintCalculator platform: aPlatform.

	aMemoryFootprintCalculator context: self.

	aMemoryFootprintCalculator acceptNode: aProcedure body.

	aMemoryFootprintCalculator processes addFirst: aPlatform sizeOfContext + (aProcedure body memoryFootprintIn: aPlatform inContext: self).

	^aMemoryFootprintCalculator processes 

]

{ #category : #'as yet unclassified' }
ASTProcedure >> memoryFootprintMapDiagramIn: aView [

| dataSet |
dataSet := RTData new.
"dataSet barShape width: 10."
dataSet barShape.
dataSet
	points: self memoryFootprintMap ;
	y: #yourself.
aView add: dataSet.
aView axisY.
aView axisX.
aView build

]

{ #category : #'as yet unclassified' }
ASTProcedure >> memoryFootprintMapIn: aPlatform [

	| aMemoryFootprintCalculator |
	
	aMemoryFootprintCalculator := MemoryFootprintCalculator acceptNode: self body inPlatform: aPlatform inContext: self. 
	
	^aMemoryFootprintCalculator processes
	

]

{ #category : #'process graph' }
ASTProcedure >> outputs [

	| aSet |

	parent ifNil:[^Set new].
	
	aSet := body outputs: self.
		
	^aSet select:[:each | self isFree: each principalName value ]
]

{ #category : #generated }
ASTProcedure >> pROCToken [
	^ pROCToken
]

{ #category : #generated }
ASTProcedure >> pROCToken: aSmaCCToken [
	pROCToken := aSmaCCToken
]

{ #category : #streaming }
ASTProcedure >> streamNameOn: aWriteStream [

	aWriteStream put: 'PROC ' ; put: name value.

]

{ #category : #generated }
ASTProcedure >> tokenVariables [
	^ #(#pROCToken #leftParenToken #rightParenToken #bEGINToken #eNDToken #name #periodToken)
]

{ #category : #compiling }
ASTProcedure >> unfold [

	| nodeCopy |
	
	nodeCopy := self copyTree.
		
	TableOptimizer new acceptNode: nodeCopy.

	ReplicatedParUnroller new acceptNode: nodeCopy.
	
	ParFlattener new acceptNode: nodeCopy.

	^nodeCopy
	
]

{ #category : #writing }
ASTProcedure >> writePolyphonyEpilogueOn: aWriteStream [ 

	aWriteStream put: ('

void setup() {

	machine_setup();
	
	machine_schedule(&Polyphony::program);

	machine_start();
}

void loop() { }
')

]

{ #category : #writing }
ASTProcedure >> writePolyphonyPrologueOn: aWriteStream [

	aWriteStream put:'#include <Polyphony.h>' ; put: String cr.

	self nestedImports do:[:each |
		aWriteStream put: '#include <Polyphony.'; put: each name value ; put: '.h>' ; put: String cr ].
		

]
