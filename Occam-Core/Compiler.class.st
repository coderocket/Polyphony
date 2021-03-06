Class {
	#name : #Compiler,
	#superclass : #ASTRootVisitor,
	#classVars : [
		'CppOperators'
	],
	#category : #'Occam-Core-Compiler'
}

{ #category : #compiling }
Compiler class >> compile: anASTNode on: aWriteStream [

	| aCompiler aCppProc |

	aCompiler := Compiler new.
	
	aCppProc := aCompiler acceptNode: anASTNode.
	
	aCppProc streamOn: aWriteStream.

]

{ #category : #example }
Compiler class >> example [

| aCompiler anAST aCppClass aWriteStream |
aCompiler := Compiler new.

anAST := OccamCoreParser parse:'PROC p()  
  INT c : 
  INT d : 
  PROC q(CHAN OF INT x?, CHAN OF INT y!)  
    INT v : 
    SEQ
      ALT 
        bb & c?v 
          vv := 1+3
        d?u 
          v := 1
        b 
          qq?h
      x?v 
      y!v 
      IF 
        aa
          SEQ
            c?x
            c!5
        bb
          v[1][2][3] := 1
  : 
  PAR 
    q(c, d) 
    q(d, c) 
:'.

aCppClass := aCompiler acceptNode: anAST.

aWriteStream := IndentedPrinterStream new.

aCppClass streamOn: aWriteStream.

Transcript show: aWriteStream contents; cr.
]

{ #category : #'class initialization' }
Compiler class >> initialize [ 

	"self initialize"
	
	CppOperators := Dictionary new.

	CppOperators at:'+'  put: '+'.
	CppOperators at:'-'  put: '-'.
	CppOperators at:'*'  put: '*'.
	CppOperators at:'/'  put: '/'.
	CppOperators at:'\'  put: '%'.
	CppOperators at:'REM'  put: '%'.
	CppOperators at:'/\' put: '&'.
	CppOperators at:'\/' put: '|'.
	CppOperators at:'><' put: '^'.
	CppOperators at:'AND' put: '&&'.
	CppOperators at:'OR' put: '||'.
	CppOperators at:'=' put: '=='.
	CppOperators at:'<' put: '<'.
	CppOperators at:'>' put: '>'.
	CppOperators at:'<=' put: '<='.
	CppOperators at:'>=' put: '>='.
	CppOperators at:'<>' put: '!='.
	CppOperators at:'>>' put: '>>'.
	CppOperators at:'<<' put: '<<'.

	
]

{ #category : #generated }
Compiler >> visitAbbreviation: anAbbreviation [

	^CppConstant new definition: (CppDefinition new type: (self acceptNode: (anAbbreviation attributeNamed:#type)) ; name: (anAbbreviation name value copyReplaceAll:'.' with:'_'); addArgument: (self acceptNode: anAbbreviation expr))
]

{ #category : #generated }
Compiler >> visitAbstraction: anAbstraction [
	
	| aCppLambda aCppDefinition |
	
	aCppLambda := CppLambda new.
	
	anAbstraction params do:[:each | aCppLambda addParameter: (self acceptNode: each) ].
	
	(anAbstraction locals reject:[:each | each isKindOf: ASTAbstraction ])
		do:[:each | aCppLambda addLocal: (self acceptNode: each) ].

	(anAbstraction locals select:[:each | each isKindOf: ASTAbstraction ])
		do:[:each | aCppLambda addLocal: (self acceptNode: each) ].
	
	aCppLambda body: (self acceptNode: anAbstraction body) asSequence.
	
	aCppDefinition := CppDefinition new name: (anAbstraction name value copyReplaceAll:'.' with:'_').
	
	aCppDefinition type: (CppVariable new name:'auto').
	
	aCppDefinition addArgument: aCppLambda.

	^aCppDefinition
]

{ #category : #generated }
Compiler >> visitAlt: anAltNode [

	| cppGuardedCommands |
	
	cppGuardedCommands := anAltNode guardedCommands collect:[:each | self acceptNode: each ].
	
	^CppAlt new tests: (cppGuardedCommands collect:[:each | each test]) ; commands: (cppGuardedCommands collect:[:each | each command ])
]

{ #category : #generated }
Compiler >> visitArrayComponent: anArrayComponent [
	^ CppArrayComponent new array: (self acceptNode: anArrayComponent array) ; index: (self acceptNode: anArrayComponent expr)
]

{ #category : #generated }
Compiler >> visitArrayReferenceType: anArrayReferenceType [

		^CppArrayReferenceType new type: (self acceptNode: anArrayReferenceType type)
]

{ #category : #generated }
Compiler >> visitArraySegment: anArraySegment [
	^ CppMemberFunctionCall new name: 'segment' ; expr: (self acceptNode: anArraySegment array) ; addArgument: (self acceptNode: anArraySegment base) ; addArgument:(self acceptNode: anArraySegment count)
]

{ #category : #generated }
Compiler >> visitArrayType: anArrayType [

	^CppArrayType new size: (self acceptNode: anArrayType index) ; type: (self acceptNode: anArrayType type)
]

{ #category : #'visiting - processes' }
Compiler >> visitAssign: anAssign [

	| aCppAssignment |
		
	aCppAssignment := CppAssignment new.
	
	aCppAssignment lvalue: (self acceptNode: anAssign lvalue); rvalue: (self acceptNode: anAssign expr).
	
	^aCppAssignment
]

{ #category : #generated }
Compiler >> visitBasicType: aBasicTypeNode [

	^CppBasicType new name: (aBasicTypeNode name value copyReplaceAll:'.' with:'_')
]

{ #category : #generated }
Compiler >> visitBytesIn: aBytesInExpr [

	^CppCall new name:'sizeof' ; addArgument: (self acceptNode: aBytesInExpr type)
]

{ #category : #'visiting - expressions' }
Compiler >> visitCall: aCall [
	| aCppCall |
	
	aCppCall := CppCall new.
	
	aCppCall name: (aCall name value copyReplaceAll:'.' with:'_').
	
	aCall exprs do:[:each | aCppCall addArgument: (self acceptNode: each) ].
	
	^aCppCall
]

{ #category : #generated }
Compiler >> visitChannelType: aChannelTypeNode [

	^CppTemplateType new name: 'channel_t' ; type: (self acceptNode: aChannelTypeNode type)
]

{ #category : #'visiting - expressions' }
Compiler >> visitConversion: aConversionNode [

	^CppTypeCast new operand: (self acceptNode: aConversionNode operand) ; type: (self acceptNode: (ASTBasicType new name: (SmaCCToken value: (aConversionNode dataTypeName value copyReplaceAll:'.' with:'_'))))
	

]

{ #category : #generated }
Compiler >> visitDataType: aDataTypeNode [

	^CppDefinition new type: (self acceptNode: aDataTypeNode type) ; name: (aDataTypeNode name value copyReplaceAll:'.' with:'_')
]

{ #category : #'visiting - processes' }
Compiler >> visitDelayedInput: aDelayedInputNode [

	^CppDelayedInput new duration: (self acceptNode: aDelayedInputNode expr) ; timer: (self acceptNode: aDelayedInputNode timer)   
]

{ #category : #'visiting - expressions' }
Compiler >> visitDyadicExpression: aDyadicExpression [

	| left right |
	
	left := self acceptNode: aDyadicExpression left.
	
	right := self acceptNode: aDyadicExpression right.
	
	(aDyadicExpression operator value = 'AFTER') 
		ifTrue:[^CppCall new name:'after' ; addArgument: left ; addArgument: right].
		
	^CppBinaryExpression new left: left; operator: (CppOperators at:aDyadicExpression operator value); right: right
]

{ #category : #generated }
Compiler >> visitEventSignal: anEventSignal [

	^CppMemberFunctionCall new name: 'signal'; expr: (self acceptNode: anEventSignal event)
	
]

{ #category : #generated }
Compiler >> visitEventType: anEventTypeNode [

	^CppVariable new name: 'event_t'
]

{ #category : #generated }
Compiler >> visitEventWait: anEventWait [

	^CppEventWait new event: (self acceptNode: anEventWait event)
	
]

{ #category : #generated }
Compiler >> visitGuardedCommand: aGuardedCommand [

	^CppGuardedCommand new guard: (self acceptNode: aGuardedCommand guard) ; stmt: (self acceptNode: aGuardedCommand process)
]

{ #category : #'visiting - processes' }
Compiler >> visitIf: anIfNode [

	^CppIf new tests: (anIfNode processes collect:[:each | self acceptNode: each guard]) ; stmts: (anIfNode processes collect:[:each | (self acceptNode: each process) asSequence])
]

{ #category : #'visiting - processes' }
Compiler >> visitImmediateInput: anInputNode [

	^CppInput new lvalue: (self acceptNode: anInputNode lvalue) ; channel: (self acceptNode: anInputNode channel)   
]

{ #category : #generated }
Compiler >> visitInputGuard: anInputGuardNode [

	^CppInputGuard new test: (self acceptNode: anInputGuardNode test) ; input: (self acceptNode: anInputGuardNode input)    
]

{ #category : #'visiting - expressions' }
Compiler >> visitLiteralBoolean: aLiteralBoolean [
	^CppLiteral new value: aLiteralBoolean boolean value asLowercase 
]

{ #category : #'visiting - expressions' }
Compiler >> visitLiteralByte: aLiteralByte [
	^CppLiteral new value: aLiteralByte byte value
]

{ #category : #'visiting - expressions' }
Compiler >> visitLiteralHexInteger: aLiteralInteger [
	^CppLiteral new value: '0x', aLiteralInteger integer value allButFirst 
]

{ #category : #'visiting - expressions' }
Compiler >> visitLiteralInteger: aLiteralInteger [
	^CppLiteral new value: aLiteralInteger integer value
]

{ #category : #'visiting - expressions' }
Compiler >> visitLiteralReal64: aLiteralReal [
	^CppLiteral new value: aLiteralReal number value asLowercase 
]

{ #category : #'visiting - expressions' }
Compiler >> visitLiteralReal: aLiteralReal [
	^CppLiteral new value: aLiteralReal number value asLowercase 
]

{ #category : #'visiting - expressions' }
Compiler >> visitLiteralString: aStringLiteral [

	| aCppType aCppStmt aString |
	
	aCppType := self acceptNode: (aStringLiteral attributeNamed:#type).
	
	aCppStmt := CppCall new callee: aCppType.
	
	aString := aStringLiteral attributeNamed: #cookedString.
	
	1 to: aString size do:[ :i |
		aCppStmt := CppMemberFunctionCall new expr: aCppStmt; name:'atput'; addArgument: (CppLiteral new value:(i - 1) asString) ; addArgument: (CppLiteral new value: (aString at:i) asInteger asString).
	].

	^aCppStmt
]

{ #category : #'visiting - expressions' }
Compiler >> visitMonadicExpression: aMonadicExpression [

	| operand |
	
	operand := self acceptNode: aMonadicExpression operand.
	
	(aMonadicExpression operator value = '-') 
		ifTrue:[^CppUnaryExpression new operand: operand ; operator: '-']. 
		
	(aMonadicExpression operator value = '~') 
		ifTrue:[^CppUnaryExpression new operand: operand ; operator: '~']. 
	
	(aMonadicExpression operator value = 'NOT')
		ifTrue:[^CppUnaryExpression new operand: operand ; operator: '!']. 

	(aMonadicExpression operator value = 'SIZE') 
		ifTrue:[^CppMemberFunctionCall new name: 'size' ; expr: operand]. 

]

{ #category : #'visiting - expressions' }
Compiler >> visitOperand: aParenExpression [

	^self acceptNode: aParenExpression expression 
]

{ #category : #'visiting - processes' }
Compiler >> visitOutput: anOutputNode [

	^CppMemberFunctionCall new expr: (self acceptNode:anOutputNode channel) ; name: 'write' ; addArgument: (self acceptNode: anOutputNode expr)
]

{ #category : #'visiting - processes' }
Compiler >> visitPar: aPar [

	| aCppSequence processes |
	
	aCppSequence := CppSequence new.
	
	processes := aPar processes collectWithIndex:[:each :i | 
		CppDefinition new name: 'POLY_p', i asString ; type: (CppVariable new name:'auto') ; addArgument: (CppCall new name:'functor_process' ; addArgument:(CppLambda new body:(self acceptNode: each) asSequence)) ].
		
	processes do:[:each | aCppSequence add: each].

	processes do:[:each | aCppSequence add: (CppMemberFunctionCall new expr: (CppVariable new name: each name) ; name: 'start') ].

	processes do:[:each | aCppSequence add: (CppMemberFunctionCall new expr: (CppVariable new name: each name) ; name: 'join') ].
	
	^CppBlock new stmt: aCppSequence
]

{ #category : #'visiting - expressions' }
Compiler >> visitParenthesisExpression: aParenthesisExpression [

	^self acceptNode: aParenthesisExpression expression

]

{ #category : #generated }
Compiler >> visitReferenceParameter: aReferenceParameterNode [

	^CppReferenceParameter new type: (self acceptNode: aReferenceParameterNode type) ; name: (aReferenceParameterNode name value copyReplaceAll:'.' with:'_')
]

{ #category : #generated }
Compiler >> visitReplicatedGuardedCommand: aReplicatedGuardedCommand [

	^CppReplicatedStmt new index: aReplicatedGuardedCommand index value; base: (self acceptNode: aReplicatedGuardedCommand base) ; count: (self acceptNode: aReplicatedGuardedCommand count); body: (self acceptNode: aReplicatedGuardedCommand guardedCommand)
	
]

{ #category : #'visiting - processes' }
Compiler >> visitReplicatedPar: aReplicatedPar [
	^self error: 'I should never see a replicated par!'
	"^self acceptNode:aReplicatedPar unroll"

]

{ #category : #generated }
Compiler >> visitReplicatedProcess: aReplicatedProcess [

	^CppReplicatedStmt new index: aReplicatedProcess index value; base: (self acceptNode: aReplicatedProcess base); count: (self acceptNode: aReplicatedProcess count); body: (self acceptNode: aReplicatedProcess body)
	
]

{ #category : #'visiting - processes' }
Compiler >> visitReplicatedSeq: aReplicatedSeq [

	| aReplicatedProcess |
	
	aReplicatedProcess := aReplicatedSeq process.

	^CppForLoop new indexName: aReplicatedProcess index value ; indexType: (self acceptNode: (ASTBasicType new name:(SmaCCToken value:'INT'))) ; base: (self acceptNode: aReplicatedProcess base); count: (self acceptNode: aReplicatedProcess count) ; body: (self acceptNode: aReplicatedProcess body) asSequence 
]

{ #category : #'visiting - processes' }
Compiler >> visitResult: aResultNode [

	^CppReturn new result: (self acceptNode: aResultNode return)
]

{ #category : #'visiting - processes' }
Compiler >> visitSeq: aSeq [
	| aCppSequence |
	
	aCppSequence := CppSequence new.
	
	aSeq processes do:[:each | aCppSequence add: (self acceptNode: each) ].
	
	^aCppSequence
]

{ #category : #'visiting - processes' }
Compiler >> visitSkip: aSkip [
	^ CppSequence new
]

{ #category : #'visiting - processes' }
Compiler >> visitStop: aStop [
	^ CppWhile new test: (CppLiteral new value: 'true') ; body: CppSequence new
]

{ #category : #'visiting - expressions' }
Compiler >> visitTable: aTableNode [

	| aCppStmt aCppType |
	
	aCppType := self acceptNode: (aTableNode attributeNamed:#type).
	
	aCppStmt := CppCall new callee: aCppType.
	
	1 to: aTableNode exprs size do:[ :i |
		aCppStmt := CppMemberFunctionCall new expr: aCppStmt; name:'atput'; addArgument: (CppLiteral new value:(i - 1) asString) ; addArgument: (self accept: (aTableNode exprs at:i)).
	].

	^aCppStmt

]

{ #category : #generated }
Compiler >> visitTimerType: aTimerTypeNode [

	^CppBasicType new name: 'TIMER' 
]

{ #category : #generated }
Compiler >> visitValueParameter: aValueParameter [

	^CppValueParameter new type: (self acceptNode: aValueParameter type) ; name: (aValueParameter name value copyReplaceAll:'.' with:'_')
]

{ #category : #'visiting - expressions' }
Compiler >> visitVariable: aVariable [
	^ CppVariable new name: (aVariable name value copyReplaceAll:'.' with:'_')
]

{ #category : #'visiting - processes' }
Compiler >> visitWhile: aWhileNode [

	^CppWhile new test: (self acceptNode: aWhileNode test) ; body: (self acceptNode:aWhileNode body) asSequence.

]
