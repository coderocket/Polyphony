Class {
	#name : #TypeChecker,
	#superclass : #ASTRootVisitor,
	#instVars : [
		'context'
	],
	#category : #'Occam-Core-Compiler'
}

{ #category : #'as yet unclassified' }
TypeChecker class >> check: anASTNode inContext: aContext [

	anASTNode clearViolations.
	
	^TypeChecker new context: aContext; acceptNode: anASTNode
]

{ #category : #accessing }
TypeChecker >> context: aContext [
	
	context := aContext
]

{ #category : #'visiting expressions' }
TypeChecker >> visitArrayComponent: anArrayComponent [

	| arrayType indexType |
	
	arrayType := self acceptNode: anArrayComponent array.
	
	(arrayType isArrayType)
		ifFalse:[anArrayComponent array addViolation: 'Not an array'. ^arrayType].
		
	indexType := self acceptNode: anArrayComponent expr.
	
	(indexType isIntegerType)
		ifFalse:[anArrayComponent expr addViolation: 'Not an integer'].
		
	 ^arrayType type
]

{ #category : #'visiting expressions' }
TypeChecker >> visitArraySegment: anArraySegment [

	| arrayType startIndexType sizeType |
	
	arrayType := self acceptNode: anArraySegment array.
	
	(arrayType isArrayType)
		ifFalse:[anArraySegment array addViolation: 'Not an array'. ^arrayType].
		
	startIndexType := self acceptNode: anArraySegment base.
	
	(startIndexType isIntegerType)
		ifFalse:[anArraySegment start addViolation: 'Not an integer'].

	sizeType := self acceptNode: anArraySegment count.
	
	(sizeType isIntegerType)
		ifFalse:[anArraySegment count addViolation: 'Not an integer'].
		
	 ^arrayType 
]

{ #category : #'visiting processes' }
TypeChecker >> visitAssign: anAssignNode [

	| anLValueType anExprType |
		
	anLValueType := self acceptNode: anAssignNode lvalue.
	
	anLValueType ifConstant:[
		anAssignNode lvalue addViolation: 'Cannot assign to an abbreviation'].
	
	anExprType := self acceptNode: anAssignNode expr.
		
	(anLValueType isBigEnoughToHold: anExprType)
		ifFalse:[anAssignNode addViolation:'Type mismatch']
]

{ #category : #'visiting expressions' }
TypeChecker >> visitBytesIn: aBytesInExpr [

	self acceptNode: aBytesInExpr type.
	
	^ASTBasicType new name: (SmaCCToken value: 'INT')
]

{ #category : #'visiting processes' }
TypeChecker >> visitCall: aCallNode [

	| anAbstraction |
	
	anAbstraction := context lookup: aCallNode name value.
	
	anAbstraction ifNil:[aCallNode addViolation:'Undefined abstraction'. ^ASTBasicType errorType].
	
	(anAbstraction params size = aCallNode exprs size)
		ifFalse:[aCallNode addViolation: 'Invalid number of arguments'. ^ASTBasicType errorType].
	
	^anAbstraction typeCheckCall: aCallNode with: self.

]

{ #category : #'visiting expressions' }
TypeChecker >> visitConversion: aConversionNode [

	| operandType convertedType | 

	convertedType := ASTBasicType new name: (SmaCCToken value: aConversionNode dataTypeName value).
	
	(convertedType isNumericType)
		ifFalse:[aConversionNode addViolation: 'Data type is not a number'].
		
	operandType := self acceptNode: aConversionNode operand.
	
	(operandType isNumericType)
		ifFalse:[aConversionNode addViolation:'Operand is not a number'. ].
	
	^convertedType

]

{ #category : #'visiting expressions' }
TypeChecker >> visitDyadicExpression: aDyadicExpression [

	| leftType rightType leastUpperBound |
	
	leftType := self acceptNode: aDyadicExpression left.
	
	rightType := self acceptNode: aDyadicExpression right.
		
	aDyadicExpression ifArithmeticOperator:[
		
		leftType isNumericType ifFalse:[^ASTBasicType errorType].
		rightType isNumericType ifFalse:[^ASTBasicType errorType].
		
		leastUpperBound := leftType leastUpperBound: rightType.

		leastUpperBound isTop ifTrue:[^ASTBasicType errorType].
		
		^leastUpperBound		
	].

	aDyadicExpression ifRelationalOperator:[
		
		leftType isNumericType ifFalse:[^ASTBasicType errorType].
		rightType isNumericType ifFalse:[^ASTBasicType errorType].
		
		leastUpperBound := leftType leastUpperBound: rightType.

		leastUpperBound isTop ifTrue:[^ASTBasicType errorType].
		
		^ASTBasicType new name:(SmaCCToken value:'BOOL')		
	].

	aDyadicExpression ifBitOperator:[

		leftType isIntegerType ifFalse:[^ASTBasicType errorType].
		rightType isIntegerType ifFalse:[^ASTBasicType errorType].

		leastUpperBound := leftType leastUpperBound: rightType.
		leastUpperBound isTop ifTrue:[^ASTBasicType errorType].
		
		^leastUpperBound		
	].

	(leftType = rightType)
		ifFalse:[aDyadicExpression addViolation: 'Type mismatch'].
	
	aDyadicExpression ifBooleanOperator:[^ASTBasicType new name:(SmaCCToken value:'BOOL')].
	
	^ASTBasicType errorType
]

{ #category : #'visiting abstractions' }
TypeChecker >> visitFunction: aFunction [

	| aResult |
	
	aFunction params do:[:each | (each isKindOf: ASTReferenceParameter) ifTrue:[each addViolation: 'Not a value parameter'] ].
	  
	aFunction locals do:[:each | TypeChecker check: each inContext: aFunction ].
	
	aResult := aFunction body resultIfAbsent:[
		aFunction body addViolation:'Does not end with a result'. nil].

	((TypeChecker check: aResult return inContext: aFunction) = aFunction type) 
		ifFalse:[aFunction type addViolation: 'Type mismatch'].
				
	^TypeChecker check: aFunction body inContext: aFunction.

]

{ #category : #'visiting processes' }
TypeChecker >> visitGuardedCommand: aGuardedCommand [

	self acceptNode: aGuardedCommand process.
	
	(self acceptNode: aGuardedCommand guard) isValidGuardType 
		ifFalse:[aGuardedCommand guard addViolation:'Invalid guard']


]

{ #category : #'visiting processes' }
TypeChecker >> visitIf: anIfNode [

	anIfNode processes do:[:each | self acceptNode: each process ].
	
	anIfNode processes do:[:each | ((self acceptNode: each guard) isBooleanType) ifFalse:[each guard addViolation: 'Not a boolean'] ].
	

]

{ #category : #'visiting processes' }
TypeChecker >> visitImmediateInput: anInputNode [

	| aChannelType anLValType |
	
	aChannelType := self acceptNode: anInputNode channel.
	
	anLValType := self acceptNode: anInputNode lvalue.
		
	(aChannelType isInputSource)
		ifFalse:[anInputNode addViolation: 'Not an input source']
		ifTrue:[
			(aChannelType type = anLValType)
				ifFalse:[anInputNode addViolation: 'Type mismatch'] ].

	^anInputNode 
]

{ #category : #'visiting processes' }
TypeChecker >> visitInputGuard: anInputGuardNode [

	self acceptNode: anInputGuardNode input.
	
	((self acceptNode: anInputGuardNode test) isBooleanType)
		ifFalse:[anInputGuardNode test addViolation: 'Not a boolean'].
		
	^anInputGuardNode  
	
]

{ #category : #'visiting abstractions' }
TypeChecker >> visitLibrary: aLibraryNode [

	aLibraryNode locals do:[:each | TypeChecker check: each inContext: aLibraryNode].
]

{ #category : #'visiting expressions' }
TypeChecker >> visitLiteralBoolean: aLiteralBooleanNode [

	^ASTBasicType new name: (SmaCCToken value: 'BOOL').
]

{ #category : #'visiting expressions' }
TypeChecker >> visitLiteralByte: aLiteralByteNode [

	^ASTBasicType new name: (SmaCCToken value: 'BYTE').
]

{ #category : #'visiting expressions' }
TypeChecker >> visitLiteralHexInteger: aLiteralIntegerNode [

	| aNumber |
	
	aNumber := Integer readFrom: aLiteralIntegerNode integer value allButFirst base:16.
	
	(aNumber between: 0 and: 255) 
		ifTrue: [^ASTBasicType new name: (SmaCCToken value: 'BYTE')].
			
	(aNumber between:0 and:65536) 
		ifTrue: [^ASTBasicType new name: (SmaCCToken value: 'WORD')].
	
	^ASTBasicType new name: (SmaCCToken value: 'INT32').
]

{ #category : #'visiting expressions' }
TypeChecker >> visitLiteralInteger: aLiteralIntegerNode [

	| aNumber |
	
	aNumber := aLiteralIntegerNode integer value asInteger.
	
	(aNumber between: 0 and: 255) 
		ifTrue: [^ASTBasicType new name: (SmaCCToken value: 'BYTE')].
			
	(aNumber between:-32768 and:32767) 
		ifTrue: [^ASTBasicType new name: (SmaCCToken value: 'INT16')].
	
	^ASTBasicType new name: (SmaCCToken value: 'INT32').

]

{ #category : #'visiting expressions' }
TypeChecker >> visitLiteralReal64: aLiteralRealNode [

	^ASTBasicType new name: (SmaCCToken value: 'REAL64').
]

{ #category : #'visiting expressions' }
TypeChecker >> visitLiteralReal: aLiteralRealNode [

	^ASTBasicType new name: (SmaCCToken value: 'REAL32').
]

{ #category : #'visiting expressions' }
TypeChecker >> visitLiteralString: aStringLiteral [

	| stringType aString |
	
	aString := aStringLiteral cook.
	
	stringType := ASTArrayType new index: (ASTLiteralInteger new integer: (SmaCCToken value: (aString size) asString)) ; type: (ASTBasicType new name: (SmaCCToken value:'BYTE')).
	
	aStringLiteral attributeNamed: #type put: stringType.

	aStringLiteral attributeNamed: #cookedString put: aString.
	
	^stringType
	
]

{ #category : #'visiting expressions' }
TypeChecker >> visitMonadicExpression: aMonadicExpression [

	| operandType |
	
	operandType := self acceptNode: aMonadicExpression operand.
	
	((aMonadicExpression operator value = '-') and:[operandType isNumericType not])
		ifTrue:[aMonadicExpression addViolation: 'Not a number']. 
		
	((aMonadicExpression operator value = '~') and:[operandType isIntegerType not])
		ifTrue:[aMonadicExpression addViolation: 'Not an integer']. 
	
	((aMonadicExpression operator value = 'NOT') and:[operandType isBooleanType not])
		ifTrue:[aMonadicExpression addViolation: 'Not a boolean']. 

	((aMonadicExpression operator value = 'SIZE') and:[operandType isArrayType not])
		ifTrue:[aMonadicExpression addViolation: 'Not an array'].
		
	(aMonadicExpression operator value = 'SIZE')
		ifTrue:[^ASTBasicType new name:(SmaCCToken value:'INT')].

	^operandType

]

{ #category : #'visiting processes' }
TypeChecker >> visitOutput: anOutputNode [

	| aChannelType anExprType |
	
	aChannelType := self acceptNode: anOutputNode channel.
	
	anExprType := self acceptNode: anOutputNode expr.
	
	(aChannelType isKindOf: ASTChannelType)
		ifFalse:[anOutputNode addViolation: 'Not a channel']
		ifTrue:[(aChannelType type isBigEnoughToHold: anExprType)
			ifFalse:[anOutputNode addViolation: 'Type mismatch'] ]

]

{ #category : #'visiting expressions' }
TypeChecker >> visitParenthesisExpression: aParenthesisExpression [

	^self acceptNode: aParenthesisExpression expression
	
]

{ #category : #'visiting abstractions' }
TypeChecker >> visitProcedure: aProcedure [

	aProcedure locals do:[:each | TypeChecker check: each inContext: aProcedure ].
	
	^TypeChecker check: aProcedure body inContext: aProcedure.

]

{ #category : #'visiting processes' }
TypeChecker >> visitReplicatedGuardedCommand: aReplicatedGuardedCommand [

	| baseType countType |
	baseType := self acceptNode: aReplicatedGuardedCommand base.
	
	(baseType isIntegerType)
		ifFalse:[aReplicatedGuardedCommand base addViolation: 'Type mismatch'].
			
	countType := self acceptNode: aReplicatedGuardedCommand count.
	
	(countType isIntegerType)
		ifFalse:[aReplicatedGuardedCommand count addViolation: 'Type mismatch'].
		
	^TypeChecker check: aReplicatedGuardedCommand guardedCommand inContext: 
		(ASTProcedure new parent: context; locals: (OrderedCollection with: (ASTDataType new name: aReplicatedGuardedCommand index ; type: (ASTBasicType new name: (SmaCCToken value:'INT')))))

]

{ #category : #'visiting processes' }
TypeChecker >> visitReplicatedPar: aReplicatedPar [

	| base count |
	
	self acceptNode: aReplicatedPar process.

	base := StaticEvaluator evaluate: aReplicatedPar process base inContext: context.
	(base isKindOf: ASTLiteralInteger)
		ifFalse:[
			aReplicatedPar process count addViolation: 'Not a constant expression'.
			base := ASTLiteralInteger fromInteger:0.
		].
	
	count := StaticEvaluator evaluate: aReplicatedPar process count inContext: context.
	(count isKindOf: ASTLiteralInteger)
		ifFalse:[
			aReplicatedPar process count addViolation: 'Not a constant expression'.
			count := ASTLiteralInteger fromInteger:0.
		].
		
	aReplicatedPar process attributeNamed: #base put: base integer value asInteger.

	aReplicatedPar process attributeNamed: #count put: count integer value asInteger.

]

{ #category : #'visiting processes' }
TypeChecker >> visitReplicatedProcess: aReplicatedProcess [

	| baseType countType |
	
	baseType := self acceptNode: aReplicatedProcess base.
	
	(baseType isIntegerType)
		ifFalse:[aReplicatedProcess base addViolation: 'Type mismatch'].
			
	countType := self acceptNode: aReplicatedProcess count.
	
	(countType isIntegerType)
		ifFalse:[aReplicatedProcess count addViolation: 'Type mismatch'].
		
	^TypeChecker check: aReplicatedProcess body inContext: 
		(ASTProcedure new parent: context; locals: (OrderedCollection with: (ASTDataType new name: aReplicatedProcess index ; type: (ASTBasicType new name: (SmaCCToken value:'INT')))))

]

{ #category : #'visiting expressions' }
TypeChecker >> visitTable: aTableNode [

	| elementType tableType |
	
	elementType := self acceptNode: aTableNode exprs first.
	
	elementType := aTableNode exprs allButFirst inject: elementType into:[:lub :each | lub leastUpperBound: (self acceptNode: each) ].
	
	(elementType isTop) ifTrue:[aTableNode addViolation: 'Type mismatch']. 

	tableType := ASTArrayType new index: (ASTLiteralInteger new integer: (SmaCCToken value: aTableNode exprs size asString)) ; type: elementType.
	
	aTableNode attributeNamed: #type put: tableType.
	
	^tableType

	
		
]

{ #category : #'visiting expressions' }
TypeChecker >> visitVariable: aVariableNode [

	^context lookup: aVariableNode name value 
		ifPresent:[:x | x type ]
		ifAbsent:[aVariableNode addViolation:'Undefined variable'. ASTBasicType errorType]
]

{ #category : #'visiting processes' }
TypeChecker >> visitWhile: aWhileNode [

	self acceptNode:aWhileNode body.
	
	((self acceptNode: aWhileNode test) isBooleanType) 
		ifFalse:[aWhileNode test addViolation: 'Not a boolean'].


]
