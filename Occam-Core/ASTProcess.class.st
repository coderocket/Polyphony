Class {
	#name : #ASTProcess,
	#superclass : #ASTRoot,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTProcess >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitProcess: self
]

{ #category : #'as yet unclassified' }
ASTProcess >> callsProcedureNamed: aString [
	^false
]

{ #category : #'as yet unclassified' }
ASTProcess >> diagram: aView inContext: aContext withColor: aColor atDepth: anInteger [

	| elements layout ins outs aLabelBuilder |
	
	(anInteger > 0) ifFalse:[^OrderedCollection new].
	
	elements := RTEllipse new size:5 ; fillColor: Color white; borderColor: aColor; elementsOn: self parallelComponents.

	aView addAll: elements.

	aLabelBuilder := RTLabeled new.
	
	aLabelBuilder fontSize:5 ; color: aColor; text:[:each | each title].
	
	elements @ aLabelBuilder.
	
	"
	ins : Channel <-> Process 
	outs : Channel <-> Process 
	
	edges : set Edge
	
	Edge from: w to: r with: c in edges iff
	w != r
	c -> w in outs
	c -> r in ins
	
	"	
	ins := Set new.

	elements do:[ :each | 
		ins addAll:((each model inputs: aContext) collect: [ :input | input -> each ]) ].

	outs := Set new.

	elements	do: [ :each | 
		outs addAll:((each model outputs: aContext) collect: [ :output | output -> each ]) ].

	ins do: [ :anInput | 
		outs do: [ :anOutput | | arrow edge label |
			((anOutput key contains: anInput key) and:[anInput value ~= anOutput value])
				ifTrue:[
					arrow := RTArrowedLine new
						color: aColor;
						width: 0.5;
						attachPoint: (RTBorderAttachPoint new offset:15).

					arrow head size:5; baseSize: 5; width:0.5.	
					edge := arrow edgeFrom: anOutput value to: anInput value.
					edge model: anOutput key"; notUseInLayout".

"					anOutput value width: (anOutput value width + 15).
					anInput value width: (anInput value width + 15).
"										
					aView add: edge.
					
					label := RTLabel new height: 5; color: aColor; elementOn: anOutput key asString.
					
					aView add: label.
					
					RTAnchorConstraint new
						element: label;
						edge: edge;
						balance: 0.7;
						minDistance: 1;
						build.
					
					] ] ].

"	(anInteger > 1) 
		ifTrue:[
			elements do: [ :each | 
				RTNest new 
					on: each 
					nest: (each model simpleDiagram: aView inContext: aContext withColor: aColor muchWhiter atDepth: anInteger - 1) ] ].
"		
	layout := RTOptimizedForceBasedLayout new.
	layout charge: -500 - anInteger.
	layout nbIterations: 100.
	layout applyOn: elements.

	elements @ RTDraggable.
	
	^elements
	

]

{ #category : #'as yet unclassified' }
ASTProcess >> flattenParallels [
	^OrderedCollection with: self
]

{ #category : #'process graph' }
ASTProcess >> inputs: aContext [
	^self subProcesses inject: Set new into:[:acc :each | acc addAll: (each inputs:aContext). acc] 
]

{ #category : #'as yet unclassified' }
ASTProcess >> internalizeSource [

	| source gap indentation s |
				
	source := self completeSource.
	
	gap := self attributeNamed:#startPosition. 
	
	indentation := 0.
	
	[ (source at: gap - indentation) = Character cr ] 
		whileFalse:[ indentation := indentation + 1].

	s := Character cr asString, (' ' repeat: indentation - 1).	
	
	self attributeNamed:#localSource put: (self source copyReplaceAll: s with: Character cr asString).

]

{ #category : #'process graph' }
ASTProcess >> outputs: aContext [
	^self subProcesses inject: Set new into:[:acc :each | acc addAll: (each outputs: aContext). acc] 
]

{ #category : #'as yet unclassified' }
ASTProcess >> parallelComponents [

	^self attributeNamed: #hidden ifPresent:[OrderedCollection new] ifAbsent:[^OrderedCollection with:self]
	
]

{ #category : #'as yet unclassified' }
ASTProcess >> resultIfAbsent: aBlock [
	^[aBlock value]
]

{ #category : #'process graph' }
ASTProcess >> subProcesses [
	^self children select:[:each | each isKindOf: ASTProcess] 
]

{ #category : #'source code' }
ASTProcess >> title [
	^self class asString
]
