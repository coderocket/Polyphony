Class {
	#name : #OccamCoreParser,
	#superclass : #SmaCCParser,
	#category : #'Occam-Core-AST'
}

{ #category : #'generated-accessing' }
OccamCoreParser class >> cacheId [
	^'2019-11-08T10:12:22.215394+02:00'
]

{ #category : #generated }
OccamCoreParser class >> definitionComment [
"%states doc;

<bool> : TRUE | FALSE;

<name> : [a-zA-Z] [a-zA-Z0-9_'.]* ;

<integer> : [0-9]+;

<hexinteger> : \#[0-9ABCDEF]+;

<number> : [0-9]+ (\. [0-9]*)  ;

<real32> : <number> E [+\-] [0-9][0-9] ;

<real64> : <real32> [0-9] ;

<string>: \""([^\*\""] | \*\* | \*\"" | \*c | \*n | \*t | \*')*\"" ;

<byte> : '\S';

<whitespace>: [ \f\t\v]+;

<comment>: --[^\n\r]* ;

<newline>:  [\n\r]<whitespace>?;

<period>:  \: ;

<queryeol>: \?<whitespace>?<newline>;

<bangeol>: !<whitespace>?<newline>;

doc <text> : ([^\*]+ | \*[^/])+;
 
%root Root;
%prefix AST;
%annotate_tokens;
%attributes ReplicatedPar (unrolled);
%attributes Scope (announcer);
%attributes Procedure (diagramDepth);
%hierarchy Parameter(ValueParameter ReferenceParameter);
%hierarchy ProcessAbstraction (Procedure Function);
%hierarchy Abstraction (ProcessAbstraction Library ExternalProcedure ExternalFunction);
%hierarchy Process (Skip Assign Seq Par Call Input Output Alt If While); 
%hierarchy Expression(DyadicExpression MonadicExpression Operand);
%hierarchy Operand(LValue Literal);
%hierarchy Direction(DirIn DirOut DirNone);
%hierarchy Type (BasicType ArrayType InputSourceType);
%hierarchy InputSourceType (ChannelType TimerType);
%hierarchy Input (ImmediateInput DelayedInput); 
%hierarchy ReplicatedGuardedCommand (ReplicatedIfGuardedCommand ReplicatedAltGuardedCommand);
%start Procedure Function Process Parameter DataType Abbreviation;

%ignore_variables leftBracketToken rightBracketToken;

Library 
	: ""LIBRARY"" <name> 'name' ""IS"" (Doc 'doc')? ""BEGIN"" (Definition 'member')* ""END"" <period> {{ }}
	;

Doc
	: StartDoc ""DOC""  <text> 'text' EndDoc ""*/"" {{ }}
	;
	
StartDoc
	: { self state: #doc. ^nil }
	;

EndDoc
	: { self state:#default. ^nil }
	;

ExternalAbbreviation
	: ""EXTERNAL"" ""VAL"" Type 'type' <name> 'name'  (Doc 'doc')?  <period> {{ }}
	;

ProcessAbstraction
	: Procedure
	| Function
	;
		
Abstraction
	: ProcessAbstraction
	| ExternalProcedure
	| ExternalFunction
	;

ExternalProcedure
	: ""EXTERNAL"" ""PROC"" <name> 'name' ""("" ParameterList "")"" (Doc 'doc')?  <period>  {{ }} 
	;

ExternalFunction
	:  ""EXTERNAL"" Type 'type' ""FUNCTION"" <name> 'name' ""("" ParameterList "")"" (Doc 'doc')? <period> {{ }} 
	;
	
Procedure
	: ""PROC"" <name> 'name' ""("" ParameterList "")"" (Use 'use')* (Doc 'doc')? ""BEGIN"" (Definition 'local')* Process  'body' ""END"" <period>  {{ }} 
	;

Function
	:  Type 'type' ""FUNCTION"" <name> 'name' ""("" ParameterList "")"" (Use 'use')* (Doc 'doc')? ""BEGIN""  (Definition 'local')*  (Process  'body')?  ""END"" <period> {{ }}
	;

ParameterList
	: (Parameter 'param' ("","" Parameter 'param')* )? 
	;
	
Parameter 
	: ReferenceParameter
	| ValueParameter 
	;

ReferenceParameter
	: Type 'type' <name> 'name' Direction 'direction' {{ }}
	;
	
ValueParameter
	: ""VAL"" Type 'type' <name> 'name' {{ }}
	;
	
Direction
	: DirIn 
	| DirOut
	| DirNone
	;

DirIn
	: ""?"" {{ }}
	;
	
DirOut
	: ""!"" {{ }}
	;

DirNone
	: {{ }}
	;

Use
	: ""USE"" NameList <period> {{ }}
	;

NameList
	: <name> 'name' ("","" <name> 'name')*
	;

Definition 
	: DataType 
	| Abstraction
	| Library
	| Abbreviation
	| ExternalAbbreviation
	;	
	
Abbreviation
	: ""VAL"" <name> 'name' ""IS"" Expression 'expr' <period> {{ }}
	;
	
DataType
	: Type 'type' <name> 'name' <period> {{ }}
	;

Type 
	:  BasicType
	| InputSourceType
	| ArrayType
	| ArrayReferenceType
	;

InputSourceType 
	: ChannelType
	| EventType
	| TimerType
	;

BasicType
	: <name> 'name' {{ }}
	;

ChannelType
	: ""CHAN"" ""OF"" Type 'type' {{ }}
	;

EventType
	: ""EVENT"" {{ }}
	;

TimerType
	: ""TIMER"" {{ }}
	;
			
ArrayType
	: ""["" Expression 'index' ""]"" Type 'type' {{ }}	
	;

ArrayReferenceType
	: ""["" ""]"" Type 'type' {{ }}	
	;

ProcessList 
	: (Process  'process')*
	;

Process
	: Skip  
	| Stop
	| Assign
	| Input
	| Output
	| EventSignal
	| Call
	| Seq
	| Par
	| Alt
	| If
	| While
	| ReplicatedPar 
	| ReplicatedSeq
	| Result
	;  

Result
	: ""RESULT"" NonConversionExpression 'return'  {{ }}
	;
	
ReplicatedPar
	: ""PAR"" ReplicatedProcess 'process' {{ }}
	;

ReplicatedSeq
	: ""SEQ"" ReplicatedProcess 'process' {{ }}
	;

ReplicatedProcess
	:  <name> 'index' ""="" Expression 'base' ""FOR"" Expression 'count' ""BEGIN"" Process 'body' ""END"" {{ }}
	;

Skip	
	: ""SKIP"" {{ }}
	;
	
Stop
	: ""STOP"" {{ }}
	;
		
Assign 
	: LValue 'lvalue' "":="" NonConversionExpression 'expr' {{ }}
	;
	
Seq 
	: ""SEQ""  ""BEGIN"" ProcessList  ""END"" {{ }}
	;

Par 
	: ""PAR""  ""BEGIN"" ProcessList ""END"" {{ }}
	;
	
Call
	: <name> 'name' ""("" ExpressionList "")"" {{ }}
	;

ExpressionList
	: (Expression 'expr' ("","" Expression 'expr')*)?
	;

Input 
	: ImmediateInput
	| EventWait
	| DelayedInput
	;
	
ImmediateInput
	: LValue 'channel' ""?"" LValue 'lvalue' {{ }}
	;

DelayedInput
	: LValue 'timer' ""?"" ""AFTER"" NonConversionExpression 'expr' {{ }}
	;

EventWait
	: LValue 'event' <queryeol> {{ }}
	;

EventSignal
	: LValue 'event' <bangeol> {{ }}
	;

Output
	: LValue 'channel' ""!"" NonConversionExpression 'expr' {{ }}
	;

Alt
	: ""ALT"" ""BEGIN"" AltGuardedCommand 'guardedCommand' + ""END"" {{ }}
	; 

GuardedCommand
	:  Guard 'guard' ""BEGIN"" Process 'process' ""END"" {{ }} 
	;

AltGuardedCommand
	: GuardedCommand
	| ReplicatedAltGuardedCommand
	;
	
ReplicatedAltGuardedCommand
	:  ""ALT"" ReplicatedGuardedCommand {{ }}
	;

ReplicatedIfGuardedCommand
	:  ""IF"" ReplicatedGuardedCommand {{ }}
	;

ReplicatedGuardedCommand
	:  <name> 'index' ""="" Expression 'base' ""FOR"" Expression 'count' ""BEGIN"" GuardedCommand 'guardedCommand' ""END"" 
	;

Guard
	: Expression 
	| Input
	| InputGuard
	;

InputGuard
	: Expression 'test' ""&"" Input 'input' {{ }}
	;

If 
	: ""IF"" ""BEGIN"" IfGuardedCommand 'process' + ""END"" {{ }}
	;

IfGuardedCommand
	: GuardedCommand
	| ReplicatedIfGuardedCommand
	;

While
	: ""WHILE"" Expression 'test' ""BEGIN"" Process 'body' ""END"" {{ }}
	;

NonConversionExpression
	: MonadicExpression 
	| DyadicExpression
	| Table
	| Operand
	| BytesIn
	;

BytesIn
	: ""BYTESIN"" Type 'type' {{ }}
	;
	
Expression
	: NonConversionExpression
	| Conversion
	;

Operand
	: SimpleOperand
	| ParenthesisExpression 
	;

ParenthesisExpression
	: ""(""Expression 'expression' "")"" {{ }}
	;

SimpleOperand
	: Literal
	| LValue
	| Call
	;
	
LValue
	: Variable
	| ArrayComponent
	| ArraySegment
	;
	
ArrayComponent
	: LValue 'array' ""["" Expression 'expr' ""]"" {{ }}
	;
	
ArraySegment
	:  LValue 'array' ""["" ""FROM"" Expression 'base' ""FOR"" Expression 'count'  ""]"" {{ }}
	;

Table 
	: ""["" ExpressionList ""]"" {{ }}
	;
	
Conversion
	: <name> 'dataTypeName' SimpleOperand 'operand' {{ }}
	;

Variable
	: <name> 'name' {{ }}
	;
	
MonadicExpression
	: MonadicOperator 'operator' Operand 'operand'  {{ }}
	;
	
DyadicExpression
	: Operand 'left' DyadicOperator 'operator' Operand 'right' {{ }}
	;

Literal
	: LiteralInteger 
	| LiteralHexInteger
	| LiteralBoolean
	| LiteralReal
	| LiteralReal64
	| LiteralByte
	| LiteralString
	;

LiteralInteger
	: <integer> 'integer' {{ }}
	;

LiteralHexInteger
	: <hexinteger> 'integer' {{ }}
	;

LiteralBoolean
	: <bool> 'boolean' {{ }}
	;

LiteralReal
	: <number> 'number' {{ }}
	| <real32> 'number' {{ }}
	;

LiteralReal64
	: <real64> 'number' {{ }}
	;

LiteralByte
	: <byte> 'byte' {{ }}
	;

LiteralString
	:  <string> 'string' {{ }}
	;
	
MonadicOperator 
	: ""-"" | ""~"" | ""NOT"" | ""SIZE"" 
	;
	 
DyadicOperator
	: ""+"" | ""-"" | ""*"" | ""/"" | ""\"" | ""/\"" | ""\/"" | ""><"" | ""REM"" | ""AND"" | ""OR"" | ""="" | ""<>"" | ""<"" | "">"" | "">="" | ""<="" | ""AFTER"" | ""<<"" | "">>""
	;"
]

{ #category : #'generated-accessing' }
OccamCoreParser class >> scannerClass [
	^OccamCoreScanner
]

{ #category : #generated }
OccamCoreParser class >> startingStateForAbbreviation [
	^ 7
]

{ #category : #generated }
OccamCoreParser class >> startingStateForDataType [
	^ 6
]

{ #category : #generated }
OccamCoreParser class >> startingStateForFunction [
	^ 3
]

{ #category : #generated }
OccamCoreParser class >> startingStateForLibrary [
	^ 1
]

{ #category : #generated }
OccamCoreParser class >> startingStateForParameter [
	^ 5
]

{ #category : #generated }
OccamCoreParser class >> startingStateForProcedure [
	^ 2
]

{ #category : #generated }
OccamCoreParser class >> startingStateForProcess [
	^ 4
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForAbbreviation1: nodes [
	| result |
	result := ASTAbbreviation new.
	result vALToken: (nodes at: 1).
	result name: (nodes at: 2).
	result iSToken: (nodes at: 3).
	result expr: (nodes at: 4).
	result periodToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForAlt1: nodes [
	| result |
	result := ASTAlt new.
	result aLTToken: (nodes at: 1).
	result bEGINToken: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result guardedCommands.
	result eNDToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForArrayComponent1: nodes [
	| result |
	result := ASTArrayComponent new.
	result array: (nodes at: 1).
	result leftBracketToken: (nodes at: 2).
	result expr: (nodes at: 3).
	result rightBracketToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForArrayReferenceType1: nodes [
	| result |
	result := ASTArrayReferenceType new.
	result leftBracketToken: (nodes at: 1).
	result rightBracketToken: (nodes at: 2).
	result type: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForArraySegment1: nodes [
	| result |
	result := ASTArraySegment new.
	result array: (nodes at: 1).
	result leftBracketToken: (nodes at: 2).
	result fROMToken: (nodes at: 3).
	result base: (nodes at: 4).
	result fORToken: (nodes at: 5).
	result count: (nodes at: 6).
	result rightBracketToken: (nodes at: 7).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForArrayType1: nodes [
	| result |
	result := ASTArrayType new.
	result leftBracketToken: (nodes at: 1).
	result index: (nodes at: 2).
	result rightBracketToken: (nodes at: 3).
	result type: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForAssign1: nodes [
	| result |
	result := ASTAssign new.
	result lvalue: (nodes at: 1).
	result colonEqualToken: (nodes at: 2).
	result expr: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForBasicType1: nodes [
	| result |
	result := ASTBasicType new.
	result name: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForBytesIn1: nodes [
	| result |
	result := ASTBytesIn new.
	result bYTESINToken: (nodes at: 1).
	result type: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForCall1: nodes [
	| result |
	result := ASTCall new.
	result name: (nodes at: 1).
	result leftParenToken: (nodes at: 2).
	result addNodes: ((nodes at: 3) at: 1) to: result exprs.
	result addTokens: ((nodes at: 3) at: 2) to: result commaTokens.
	result rightParenToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForChannelType1: nodes [
	| result |
	result := ASTChannelType new.
	result cHANToken: (nodes at: 1).
	result oFToken: (nodes at: 2).
	result type: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForConversion1: nodes [
	| result |
	result := ASTConversion new.
	result dataTypeName: (nodes at: 1).
	result operand: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForDataType1: nodes [
	| result |
	result := ASTDataType new.
	result type: (nodes at: 1).
	result name: (nodes at: 2).
	result periodToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForDelayedInput1: nodes [
	| result |
	result := ASTDelayedInput new.
	result timer: (nodes at: 1).
	result questionMarkToken: (nodes at: 2).
	result aFTERToken: (nodes at: 3).
	result expr: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForDirIn1: nodes [
	| result |
	result := ASTDirIn new.
	result questionMarkToken: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForDirNone1: nodes [
	| result |
	result := ASTDirNone new.
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForDirOut1: nodes [
	| result |
	result := ASTDirOut new.
	result bangToken: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForDoc1: nodes [
	| result |
	result := ASTDoc new.
	result dOCToken: (nodes at: 2).
	result text: (nodes at: 3).
	result timesDivideToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForDyadicExpression1: nodes [
	| result |
	result := ASTDyadicExpression new.
	result left: (nodes at: 1).
	result operator: (nodes at: 2).
	result right: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForEndDoc1: nodes [
	self state: #default.
	^ nil
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForEventSignal1: nodes [
	| result |
	result := ASTEventSignal new.
	result event: (nodes at: 1).
	result bangeolToken: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForEventType1: nodes [
	| result |
	result := ASTEventType new.
	result eVENTToken: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForEventWait1: nodes [
	| result |
	result := ASTEventWait new.
	result event: (nodes at: 1).
	result queryeolToken: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForExternalAbbreviation1: nodes [
	| result |
	result := ASTExternalAbbreviation new.
	result eXTERNALToken: (nodes at: 1).
	result vALToken: (nodes at: 2).
	result type: (nodes at: 3).
	result name: (nodes at: 4).
	result doc: (nodes at: 5).
	result periodToken: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForExternalFunction1: nodes [
	| result |
	result := ASTExternalFunction new.
	result eXTERNALToken: (nodes at: 1).
	result type: (nodes at: 2).
	result fUNCTIONToken: (nodes at: 3).
	result name: (nodes at: 4).
	result leftParenToken: (nodes at: 5).
	result addNodes: ((nodes at: 6) at: 1) to: result params.
	result addTokens: ((nodes at: 6) at: 2) to: result commaTokens.
	result rightParenToken: (nodes at: 7).
	result doc: (nodes at: 8).
	result periodToken: (nodes at: 9).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForExternalProcedure1: nodes [
	| result |
	result := ASTExternalProcedure new.
	result eXTERNALToken: (nodes at: 1).
	result pROCToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result addNodes: ((nodes at: 5) at: 1) to: result params.
	result addTokens: ((nodes at: 5) at: 2) to: result commaTokens.
	result rightParenToken: (nodes at: 6).
	result doc: (nodes at: 7).
	result periodToken: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForFunction1: nodes [
	| result |
	result := ASTFunction new.
	result type: (nodes at: 1).
	result fUNCTIONToken: (nodes at: 2).
	result name: (nodes at: 3).
	result leftParenToken: (nodes at: 4).
	result addNodes: ((nodes at: 5) at: 1) to: result params.
	result addTokens: ((nodes at: 5) at: 2) to: result commaTokens.
	result rightParenToken: (nodes at: 6).
	result addNodes: (nodes at: 7) to: result uses.
	result doc: (nodes at: 8).
	result bEGINToken: (nodes at: 9).
	result addNodes: (nodes at: 10) to: result locals.
	result body: (nodes at: 11).
	result eNDToken: (nodes at: 12).
	result periodToken: (nodes at: 13).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForGuardedCommand1: nodes [
	| result |
	result := ASTGuardedCommand new.
	result guard: (nodes at: 1).
	result bEGINToken: (nodes at: 2).
	result process: (nodes at: 3).
	result eNDToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForIf1: nodes [
	| result |
	result := ASTIf new.
	result iFToken: (nodes at: 1).
	result bEGINToken: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result processes.
	result eNDToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForIfGuardedCommand_1: nodes [
	| result |
	result := OrderedCollection new: 2.
	self add: (nodes at: 1) to: result.
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForImmediateInput1: nodes [
	| result |
	result := ASTImmediateInput new.
	result channel: (nodes at: 1).
	result questionMarkToken: (nodes at: 2).
	result lvalue: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForInputGuard1: nodes [
	| result |
	result := ASTInputGuard new.
	result test: (nodes at: 1).
	result andToken: (nodes at: 2).
	result input: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForLibrary1: nodes [
	| result |
	result := ASTLibrary new.
	result lIBRARYToken: (nodes at: 1).
	result name: (nodes at: 2).
	result iSToken: (nodes at: 3).
	result doc: (nodes at: 4).
	result bEGINToken: (nodes at: 5).
	result addNodes: (nodes at: 6) to: result members.
	result eNDToken: (nodes at: 7).
	result periodToken: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForLiteralBoolean1: nodes [
	| result |
	result := ASTLiteralBoolean new.
	result boolean: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForLiteralByte1: nodes [
	| result |
	result := ASTLiteralByte new.
	result byte: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForLiteralHexInteger1: nodes [
	| result |
	result := ASTLiteralHexInteger new.
	result integer: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForLiteralInteger1: nodes [
	| result |
	result := ASTLiteralInteger new.
	result integer: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForLiteralReal1: nodes [
	| result |
	result := ASTLiteralReal new.
	result number: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForLiteralReal641: nodes [
	| result |
	result := ASTLiteralReal64 new.
	result number: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForLiteralString1: nodes [
	| result |
	result := ASTLiteralString new.
	result string: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForMonadicExpression1: nodes [
	| result |
	result := ASTMonadicExpression new.
	result operator: (nodes at: 1).
	result operand: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForOutput1: nodes [
	| result |
	result := ASTOutput new.
	result channel: (nodes at: 1).
	result bangToken: (nodes at: 2).
	result expr: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForPar1: nodes [
	| result |
	result := ASTPar new.
	result pARToken: (nodes at: 1).
	result bEGINToken: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result processes.
	result eNDToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForParenthesisExpression1: nodes [
	| result |
	result := ASTParenthesisExpression new.
	result leftParenToken: (nodes at: 1).
	result expression: (nodes at: 2).
	result rightParenToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForProcedure1: nodes [
	| result |
	result := ASTProcedure new.
	result pROCToken: (nodes at: 1).
	result name: (nodes at: 2).
	result leftParenToken: (nodes at: 3).
	result addNodes: ((nodes at: 4) at: 1) to: result params.
	result addTokens: ((nodes at: 4) at: 2) to: result commaTokens.
	result rightParenToken: (nodes at: 5).
	result addNodes: (nodes at: 6) to: result uses.
	result doc: (nodes at: 7).
	result bEGINToken: (nodes at: 8).
	result addNodes: (nodes at: 9) to: result locals.
	result body: (nodes at: 10).
	result eNDToken: (nodes at: 11).
	result periodToken: (nodes at: 12).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForReferenceParameter1: nodes [
	| result |
	result := ASTReferenceParameter new.
	result type: (nodes at: 1).
	result name: (nodes at: 2).
	result direction: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForReplicatedAltGuardedCommand1: nodes [
	| result |
	result := ASTReplicatedAltGuardedCommand new.
	result aLTToken: (nodes at: 1).
	result index: ((nodes at: 2) at: 1).
	result equalToken: ((nodes at: 2) at: 2).
	result base: ((nodes at: 2) at: 3).
	result fORToken: ((nodes at: 2) at: 4).
	result count: ((nodes at: 2) at: 5).
	result bEGINToken: ((nodes at: 2) at: 6).
	result guardedCommand: ((nodes at: 2) at: 7).
	result eNDToken: ((nodes at: 2) at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForReplicatedGuardedCommand1: nodes [
	| result |
	result := Array new: 8.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	result at: 3 put: (nodes at: 3).
	result at: 4 put: (nodes at: 4).
	result at: 5 put: (nodes at: 5).
	result at: 6 put: (nodes at: 6).
	result at: 7 put: (nodes at: 7).
	result at: 8 put: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForReplicatedIfGuardedCommand1: nodes [
	| result |
	result := ASTReplicatedIfGuardedCommand new.
	result iFToken: (nodes at: 1).
	result index: ((nodes at: 2) at: 1).
	result equalToken: ((nodes at: 2) at: 2).
	result base: ((nodes at: 2) at: 3).
	result fORToken: ((nodes at: 2) at: 4).
	result count: ((nodes at: 2) at: 5).
	result bEGINToken: ((nodes at: 2) at: 6).
	result guardedCommand: ((nodes at: 2) at: 7).
	result eNDToken: ((nodes at: 2) at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForReplicatedPar1: nodes [
	| result |
	result := ASTReplicatedPar new.
	result pARToken: (nodes at: 1).
	result process: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForReplicatedProcess1: nodes [
	| result |
	result := ASTReplicatedProcess new.
	result index: (nodes at: 1).
	result equalToken: (nodes at: 2).
	result base: (nodes at: 3).
	result fORToken: (nodes at: 4).
	result count: (nodes at: 5).
	result bEGINToken: (nodes at: 6).
	result body: (nodes at: 7).
	result eNDToken: (nodes at: 8).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForReplicatedSeq1: nodes [
	| result |
	result := ASTReplicatedSeq new.
	result sEQToken: (nodes at: 1).
	result process: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForResult1: nodes [
	| result |
	result := ASTResult new.
	result rESULTToken: (nodes at: 1).
	result return: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForSeq1: nodes [
	| result |
	result := ASTSeq new.
	result sEQToken: (nodes at: 1).
	result bEGINToken: (nodes at: 2).
	result addNodes: (nodes at: 3) to: result processes.
	result eNDToken: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForSkip1: nodes [
	| result |
	result := ASTSkip new.
	result sKIPToken: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForStartDoc1: nodes [
	self state: #doc.
	^ nil
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForStop1: nodes [
	| result |
	result := ASTStop new.
	result sTOPToken: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForTable1: nodes [
	| result |
	result := ASTTable new.
	result leftBracketToken: (nodes at: 1).
	result addNodes: ((nodes at: 2) at: 1) to: result exprs.
	result addTokens: ((nodes at: 2) at: 2) to: result commaTokens.
	result rightBracketToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForTimerType1: nodes [
	| result |
	result := ASTTimerType new.
	result tIMERToken: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForType2: nodes [
	^ nodes at: 1
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForUse1: nodes [
	| result |
	result := ASTUse new.
	result uSEToken: (nodes at: 1).
	result addTokens: ((nodes at: 2) at: 1) to: result names.
	result addTokens: ((nodes at: 2) at: 2) to: result commaTokens.
	result periodToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForValueParameter1: nodes [
	| result |
	result := ASTValueParameter new.
	result vALToken: (nodes at: 1).
	result type: (nodes at: 2).
	result name: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForVariable1: nodes [
	| result |
	result := ASTVariable new.
	result name: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionForWhile1: nodes [
	| result |
	result := ASTWhile new.
	result wHILEToken: (nodes at: 1).
	result test: (nodes at: 2).
	result bEGINToken: (nodes at: 3).
	result body: (nodes at: 4).
	result eNDToken: (nodes at: 5).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionFor__Expression__expr________Expression__expr____1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	self add: (nodes at: 1) to: (result at: 1).
	self addAll: ((nodes at: 2) at: 1) to: (result at: 2).
	self addAll: ((nodes at: 2) at: 2) to: (result at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionFor__Expression__expr________Expression__expr_____1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionFor__Expression__expr________Expression__expr_____2: nodes [
	| result |
	result := nodes at: 1.
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionFor__Process__process___1: nodes [
	| result |
	result := OrderedCollection new: 2.
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionFor__Process__process___2: nodes [
	| result |
	result := nodes at: 1.
	self add: (nodes at: 2) to: result.
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionFor______Expression__expr__1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionFor______Expression__expr___2: nodes [
	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	^ result
]

{ #category : #generated }
OccamCoreParser >> reduceTable [
^#(
	#(112 1 #reduceActionForTimerType1:) 
	#(111 1 #reduceActionForEventType1:) 
	#(142 1 #reduceActionForBasicType1:) 
	#(78 1 #reduceActionForType2:) 
	#(107 1 #reduceActionForType2:) 
	#(116 1 #reduceActionForSkip1:) 
	#(117 1 #reduceActionForStop1:) 
	#(163 1 #reduceActionForVariable1:) 
	#(180 1 #reduceActionForType2:) 
	#(119 1 #reduceActionForType2:) 
	#(133 1 #reduceActionForType2:) 
	#(179 1 #reduceActionForType2:) 
	#(138 0 #reduceActionFor__Expression__expr________Expression__expr_____1:) 
	#(166 1 #reduceActionForType2:) 
	#(170 1 #reduceActionForLiteralBoolean1:) 
	#(168 1 #reduceActionForLiteralInteger1:) 
	#(169 1 #reduceActionForLiteralHexInteger1:) 
	#(171 1 #reduceActionForLiteralReal1:) 
	#(172 1 #reduceActionForLiteralReal641:) 
	#(174 1 #reduceActionForLiteralString1:) 
	#(173 1 #reduceActionForLiteralByte1:) 
	#(160 1 #reduceActionForType2:) 
	#(105 1 #reduceActionForType2:) 
	#(131 1 #reduceActionForType2:) 
	#(157 1 #reduceActionForType2:) 
	#(162 1 #reduceActionForType2:) 
	#(130 2 #reduceActionForResult1:) 
	#(114 0 #reduceActionFor__Process__process___1:) 
	#(128 2 #reduceActionForReplicatedPar1:) 
	#(129 2 #reduceActionForReplicatedSeq1:) 
	#(140 2 #reduceActionForEventWait1:) 
	#(121 2 #reduceActionForEventSignal1:) 
	#(101 0 #reduceActionForDirNone1:) 
	#(75 0 #reduceActionForStartDoc1:) 
	#(94 0 #nil) 
	#(95 0 #reduceActionFor__Expression__expr________Expression__expr_____1:) 
	#(136 0 #reduceActionFor__Expression__expr________Expression__expr_____1:) 
	#(138 1 #reduceActionFor__Expression__expr________Expression__expr_____2:) 
	#(134 1 #reduceActionFor__Expression__expr________Expression__expr_____2:) 
	#(109 3 #reduceActionForArrayReferenceType1:) 
	#(158 2 #reduceActionForBytesIn1:) 
	#(159 2 #reduceActionForConversion1:) 
	#(167 1 #reduceActionForType2:) 
	#(154 2 #reduceActionForMonadicExpression1:) 
	#(110 3 #reduceActionForChannelType1:) 
	#(115 1 #reduceActionFor__Expression__expr________Expression__expr_____2:) 
	#(146 1 #reduceActionForType2:) 
	#(152 1 #reduceActionForType2:) 
	#(153 1 #reduceActionForIfGuardedCommand_1:) 
	#(145 1 #reduceActionForIfGuardedCommand_1:) 
	#(144 1 #reduceActionForType2:) 
	#(139 3 #reduceActionForImmediateInput1:) 
	#(120 3 #reduceActionForOutput1:) 
	#(118 3 #reduceActionForAssign1:) 
	#(97 3 #reduceActionForValueParameter1:) 
	#(99 1 #reduceActionForDirIn1:) 
	#(100 1 #reduceActionForDirOut1:) 
	#(96 3 #reduceActionForReferenceParameter1:) 
	#(98 1 #reduceActionForType2:) 
	#(178 3 #reduceActionForDataType1:) 
	#(94 1 #reduceActionForType2:) 
	#(175 1 #reduceActionForType2:) 
	#(84 1 #reduceActionFor__Expression__expr________Expression__expr_____2:) 
	#(93 0 #reduceActionFor__Expression__expr________Expression__expr_____1:) 
	#(95 1 #reduceActionFor__Expression__expr________Expression__expr_____2:) 
	#(137 2 #reduceActionFor__Expression__expr________Expression__expr____1:) 
	#(156 3 #reduceActionForTable1:) 
	#(161 3 #reduceActionForParenthesisExpression1:) 
	#(108 4 #reduceActionForArrayType1:) 
	#(155 3 #reduceActionForDyadicExpression1:) 
	#(114 2 #reduceActionFor__Process__process___2:) 
	#(113 1 #reduceActionForType2:) 
	#(124 4 #reduceActionForPar1:) 
	#(123 4 #reduceActionForSeq1:) 
	#(150 2 #reduceActionForReplicatedIfGuardedCommand1:) 
	#(126 4 #reduceActionForIf1:) 
	#(153 2 #reduceActionFor__Process__process___2:) 
	#(148 2 #reduceActionForReplicatedAltGuardedCommand1:) 
	#(125 4 #reduceActionForAlt1:) 
	#(145 2 #reduceActionFor__Process__process___2:) 
	#(122 4 #reduceActionForCall1:) 
	#(164 4 #reduceActionForArrayComponent1:) 
	#(141 4 #reduceActionForDelayedInput1:) 
	#(143 0 #reduceActionFor__Process__process___1:) 
	#(87 0 #reduceActionFor__Process__process___1:) 
	#(187 2 #reduceActionFor__Expression__expr________Expression__expr____1:) 
	#(136 2 #reduceActionFor______Expression__expr___2:) 
	#(185 5 #reduceActionForWhile1:) 
	#(151 3 #reduceActionForInputGuard1:) 
	#(177 5 #reduceActionForAbbreviation1:) 
	#(77 0 #reduceActionForEndDoc1:) 
	#(93 2 #reduceActionFor______Expression__expr___2:) 
	#(135 2 #reduceActionFor______Expression__expr__1:) 
	#(147 4 #reduceActionForGuardedCommand1:) 
	#(186 1 #reduceActionForType2:) 
	#(83 1 #reduceActionForType2:) 
	#(143 2 #reduceActionFor__Process__process___2:) 
	#(80 1 #reduceActionForType2:) 
	#(127 1 #reduceActionForType2:) 
	#(86 1 #reduceActionForType2:) 
	#(87 2 #reduceActionFor__Process__process___2:) 
	#(92 2 #reduceActionFor______Expression__expr__1:) 
	#(165 7 #reduceActionForArraySegment1:) 
	#(176 5 #reduceActionForDoc1:) 
	#(106 8 #reduceActionForLibrary1:) 
	#(104 0 #reduceActionFor__Expression__expr________Expression__expr_____1:) 
	#(89 0 #reduceActionFor__Process__process___1:) 
	#(102 2 #reduceActionFor__Expression__expr________Expression__expr____1:) 
	#(85 3 #reduceActionForUse1:) 
	#(132 8 #reduceActionForReplicatedProcess1:) 
	#(104 2 #reduceActionFor______Expression__expr___2:) 
	#(89 2 #reduceActionFor__Process__process___2:) 
	#(88 1 #reduceActionForType2:) 
	#(91 0 #nil) 
	#(103 2 #reduceActionFor______Expression__expr__1:) 
	#(91 1 #reduceActionForType2:) 
	#(90 1 #reduceActionForType2:) 
	#(149 8 #reduceActionForReplicatedGuardedCommand1:) 
	#(79 6 #reduceActionForExternalAbbreviation1:) 
	#(182 12 #reduceActionForProcedure1:) 
	#(181 13 #reduceActionForFunction1:) 
	#(81 8 #reduceActionForExternalProcedure1:) 
	#(82 9 #reduceActionForExternalFunction1:)
	).
]

{ #category : #generated }
OccamCoreParser >> symbolNames [
	^ #('"TIMER"' '"EVENT"' '"OF"' '"["' '"USE"' '"]"' '"CHAN"' '"FOR"' '"="' '">>"' '"?"' '"RESULT"' '"!"' '"PAR"' '"SKIP"' '"DOC"' '"END"' '"BEGIN"' '"*/"' '"LIBRARY"' '"EXTERNAL"' '"IS"' '"FUNCTION"' '")"' '"("' '","' '"VAL"' '"SEQ"' '"PROC"' '"STOP"' '"AND"' '"REM"' '":="' '"OR"' '"/\"' '"<>"' '"\/"' '"<<"' '"<="' '">="' '"><"' '"<"' '"\"' '">"' '"/"' '"WHILE"' '"&"' '"IF"' '"BYTESIN"' '"AFTER"' '"ALT"' '"*"' '"+"' '"FROM"' '"SIZE"' '"NOT"' '"-"' '"~"' '<bool>' '<name>' '<integer>' '<hexinteger>' '<number>' '<real32>' '<real64>' '<string>' '<byte>' '<whitespace>' '<comment>' '<newline>' '<period>' '<queryeol>' '<bangeol>' '<text>' 'StartDoc' 'B e g i n' 'EndDoc' 'Type' 'ExternalAbbreviation' 'ProcessAbstraction' 'ExternalProcedure' 'ExternalFunction' 'Abstraction' 'ParameterList' 'Use' '( Use ''use'')' '( Use ''use'')*' '( Definition ''local'')' '( Definition ''local'')*' '( Process ''body'')' '( Process ''body'')?' '( "," Parameter ''param'')' '( "," Parameter ''param'')*' '( Doc ''doc'')?' '( Parameter ''param'' ( "," Parameter ''param'')*)?' 'ReferenceParameter' 'ValueParameter' 'Direction' 'DirIn' 'DirOut' 'DirNone' 'NameList' '( "," <name> ''name'')' '( "," <name> ''name'')*' 'Expression' 'Library' 'InputSourceType' 'ArrayType' 'ArrayReferenceType' 'ChannelType' 'EventType' 'TimerType' '( Process ''process'')' '( Process ''process'')*' 'ProcessList' 'Skip' 'Stop' 'Assign' 'Input' 'Output' 'EventSignal' 'Call' 'Seq' 'Par' 'Alt' 'If' '( Definition ''member'')' 'ReplicatedPar' 'ReplicatedSeq' 'Result' 'NonConversionExpression' 'ReplicatedProcess' 'LValue' 'ExpressionList' '( "," Expression ''expr'')' '( "," Expression ''expr'')*' '( Expression ''expr'' ( "," Expression ''expr'')*)' '( Expression ''expr'' ( "," Expression ''expr'')*)?' 'ImmediateInput' 'EventWait' 'DelayedInput' 'BasicType' '( Definition ''member'')*' 'AltGuardedCommand' 'AltGuardedCommand+' 'Guard' 'GuardedCommand' 'ReplicatedAltGuardedCommand' 'ReplicatedGuardedCommand' 'ReplicatedIfGuardedCommand' 'InputGuard' 'IfGuardedCommand' 'IfGuardedCommand+' 'MonadicExpression' 'DyadicExpression' 'Table' 'Operand' 'BytesIn' 'Conversion' 'SimpleOperand' 'ParenthesisExpression' 'Literal' 'Variable' 'ArrayComponent' 'ArraySegment' 'MonadicOperator' 'DyadicOperator' 'LiteralInteger' 'LiteralHexInteger' 'LiteralBoolean' 'LiteralReal' 'LiteralReal64' 'LiteralByte' 'LiteralString' '( Doc ''doc'')' 'Doc' 'Abbreviation' 'DataType' 'Parameter' 'Process' 'Function' 'Procedure' 'E O F' 'error' 'While' 'Definition' '( Parameter ''param'' ( "," Parameter ''param'')*)')
]

{ #category : #generated }
OccamCoreParser >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken nil #ASTLibrary nil #ASTType #ASTExternalAbbreviation #ASTProcessAbstraction #ASTExternalProcedure #ASTExternalFunction #ASTAbstraction #OrderedCollection #ASTUse #ASTUse #OrderedCollection #ASTDefinition #OrderedCollection #ASTProcess #ASTProcess #OrderedCollection #OrderedCollection #ASTDoc #OrderedCollection #ASTReferenceParameter #ASTValueParameter #ASTDirection #ASTDirIn #ASTDirOut #ASTDirNone #OrderedCollection #OrderedCollection #OrderedCollection #ASTRoot #ASTLibrary #ASTType #ASTArrayType #ASTArrayReferenceType #ASTChannelType #ASTEventType #ASTTimerType #ASTProcess #OrderedCollection #OrderedCollection #ASTSkip #ASTStop #ASTAssign #ASTInput #ASTOutput #ASTEventSignal #ASTCall #ASTSeq #ASTPar #ASTAlt #ASTIf #ASTDefinition #ASTReplicatedPar #ASTReplicatedSeq #ASTResult #ASTRoot #ASTReplicatedProcess #ASTLValue #OrderedCollection #OrderedCollection #OrderedCollection #OrderedCollection #OrderedCollection #ASTImmediateInput #ASTEventWait #ASTDelayedInput #ASTBasicType #OrderedCollection #ASTRoot #OrderedCollection #ASTRoot #ASTGuardedCommand #ASTReplicatedAltGuardedCommand #OrderedCollection #ASTReplicatedIfGuardedCommand #ASTInputGuard #ASTRoot #OrderedCollection #ASTMonadicExpression #ASTDyadicExpression #ASTTable #ASTRoot #ASTBytesIn #ASTConversion #ASTRoot #ASTParenthesisExpression #ASTLiteral #ASTVariable #ASTArrayComponent #ASTArraySegment #SmaCCToken #SmaCCToken #ASTLiteralInteger #ASTLiteralHexInteger #ASTLiteralBoolean #ASTLiteralReal #ASTLiteralReal64 #ASTLiteralByte #ASTLiteralString #ASTDoc #ASTDoc #ASTAbbreviation #ASTDataType #ASTParameter #ASTProcess #ASTFunction #ASTProcedure #SmaCCToken #SmaCCToken #ASTWhile #ASTDefinition #OrderedCollection)
]

{ #category : #generated }
OccamCoreParser >> transitionTable [
^#(
#[1 0 33 0 20 0 37 0 106] 
#[1 0 41 0 29 0 45 0 182] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 65 0 60 0 69 0 78 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142 0 101 0 181] 
#[1 0 105 0 12 0 109 0 14 0 113 0 15 0 117 0 28 0 121 0 30 0 125 0 46 0 129 0 48 0 133 0 51 0 137 0 60 0 141 0 116 0 145 0 117 0 149 0 118 0 153 0 119 0 157 0 120 0 161 0 121 0 165 0 122 0 169 0 123 0 173 0 124 0 177 0 125 0 181 0 126 0 185 0 128 0 189 0 129 0 193 0 130 0 197 0 133 0 201 0 139 0 205 0 140 0 209 0 141 0 213 0 163 0 217 0 164 0 221 0 165 0 225 0 180 0 229 0 185] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 233 0 27 0 65 0 60 0 237 0 78 0 241 0 96 0 245 0 97 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142 0 249 0 179] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 65 0 60 0 253 0 78 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142 1 1 0 178] 
#[1 1 5 0 27 1 9 0 177] 
#[0 1 13 0 60] 
#[0 0 0 0 183] 
#[0 1 17 0 60] 
#[0 0 0 0 183] 
#[0 0 6 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 10 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[1 1 21 0 4 1 25 0 6 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 1 89 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 1 173 0 3] 
#[0 0 14 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 1 177 0 23] 
#[0 0 18 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 18 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 18 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 22 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 22 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 22 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 18 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 0 0 183] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 0 137 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 1 93 0 122 1 181 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[1 1 185 0 18 1 189 0 60 1 193 0 132] 
#[0 0 26 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[1 1 197 0 18 1 189 0 60 1 201 0 132] 
#[0 0 30 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 1 205 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 1 209 0 18] 
#[0 1 213 0 18] 
#[1 0 34 0 4 0 34 0 6 0 34 0 8 0 34 0 9 0 34 0 10 0 34 0 11 0 34 0 12 0 34 0 13 0 34 0 14 0 34 0 15 0 34 0 17 0 34 0 18 0 34 0 24 1 217 0 25 0 34 0 26 0 34 0 28 0 34 0 30 0 34 0 31 0 34 0 32 0 34 0 33 0 34 0 34 0 34 0 35 0 34 0 36 0 34 0 37 0 34 0 38 0 34 0 39 0 34 0 40 0 34 0 41 0 34 0 42 0 34 0 43 0 34 0 44 0 34 0 45 0 34 0 46 0 34 0 47 0 34 0 48 0 34 0 50 0 34 0 51 0 34 0 52 0 34 0 53 0 34 0 57 0 34 0 60 0 34 0 71 0 34 0 72 0 34 0 73 0 34 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[1 1 221 0 4 1 225 0 11 1 229 0 13 1 233 0 33 1 237 0 72 1 241 0 73] 
#[0 0 42 0 12 0 14 0 15 0 17 0 18 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 42 0 12 0 14 0 15 0 17 0 18 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 42 0 12 0 14 0 15 0 17 0 18 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 46 0 4 0 6 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 72 0 73 0 183] 
#[0 0 46 0 4 0 6 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 72 0 73 0 183] 
#[0 0 46 0 4 0 6 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 72 0 73 0 183] 
#[0 0 0 0 183] 
#[0 0 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 65 0 60 1 245 0 78 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142] 
#[0 1 249 0 60] 
#[0 0 50 0 24 0 26 0 183] 
#[0 0 50 0 24 0 26 0 183] 
#[0 0 0 0 183] 
#[0 1 253 0 60] 
#[0 0 0 0 183] 
#[0 2 1 0 60] 
#[0 0 0 0 183] 
#[0 2 5 0 22] 
#[0 2 9 0 25] 
#[1 1 21 0 4 0 54 0 6 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 2 13 0 105 1 93 0 122 1 97 0 131 1 101 0 133 2 17 0 134 2 21 0 137 2 25 0 138 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 65 0 60 2 29 0 78 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 2 33 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 65 0 60 2 37 0 78 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142] 
#[0 0 58 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 58 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 58 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 58 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 62 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[1 0 34 0 4 0 34 0 6 0 34 0 8 0 34 0 9 0 34 0 10 0 34 0 11 0 34 0 18 0 34 0 24 1 217 0 25 0 34 0 26 0 34 0 31 0 34 0 32 0 34 0 34 0 34 0 35 0 34 0 36 0 34 0 37 0 34 0 38 0 34 0 39 0 34 0 40 0 34 0 41 0 34 0 42 0 34 0 43 0 34 0 44 0 34 0 45 0 34 0 47 0 34 0 50 0 34 0 52 0 34 0 53 0 34 0 57 1 53 0 59 0 137 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 0 34 0 71 0 34 0 72 1 93 0 122 1 101 0 133 2 41 0 160 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 0 66 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 70 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 74 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 74 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 78 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 82 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 86 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 2 45 0 6] 
#[0 0 90 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 94 0 6 0 8 0 18 0 24 0 26 0 47 0 71] 
#[1 1 221 0 4 0 90 0 6 0 90 0 8 0 90 0 9 0 90 0 10 0 90 0 12 0 90 0 14 0 90 0 15 0 90 0 17 0 90 0 18 0 90 0 24 0 90 0 26 0 90 0 28 0 90 0 30 0 90 0 31 0 90 0 32 0 90 0 34 0 90 0 35 0 90 0 36 0 90 0 37 0 90 0 38 0 90 0 39 0 90 0 40 0 90 0 41 0 90 0 42 0 90 0 43 0 90 0 44 0 90 0 45 0 90 0 46 0 90 0 47 0 90 0 48 0 90 0 50 0 90 0 51 0 90 0 52 0 90 0 53 0 90 0 57 0 90 0 60 0 90 0 71 0 90 0 183] 
#[0 0 98 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 98 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 98 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[1 0 98 0 6 0 98 0 8 2 49 0 9 2 53 0 10 0 98 0 12 0 98 0 14 0 98 0 15 0 98 0 17 0 98 0 18 0 98 0 24 0 98 0 26 0 98 0 28 0 98 0 30 2 57 0 31 2 61 0 32 2 65 0 34 2 69 0 35 2 73 0 36 2 77 0 37 2 81 0 38 2 85 0 39 2 89 0 40 2 93 0 41 2 97 0 42 2 101 0 43 2 105 0 44 2 109 0 45 0 98 0 46 0 98 0 47 0 98 0 48 2 113 0 50 0 98 0 51 2 117 0 52 2 121 0 53 2 125 0 57 0 98 0 60 0 98 0 71 2 129 0 167 0 98 0 183] 
#[0 0 98 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 94 0 6 0 8 0 18 0 24 0 26 0 47 0 71] 
#[0 0 102 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 102 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 90 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[1 1 29 0 25 1 53 0 59 0 137 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 1 93 0 122 1 101 0 133 2 133 0 157 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 0 106 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 106 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 106 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 106 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 106 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 106 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 0 106 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 65 0 60 2 137 0 78 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142] 
#[0 2 141 0 60] 
#[0 0 110 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[1 0 114 0 12 0 114 0 14 0 114 0 15 0 114 0 17 0 114 0 28 0 114 0 30 0 114 0 46 0 114 0 48 0 114 0 51 0 114 0 60 2 145 0 114 2 149 0 115] 
#[0 2 153 0 9] 
#[0 0 118 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[1 0 114 0 12 0 114 0 14 0 114 0 15 0 114 0 17 0 114 0 28 0 114 0 30 0 114 0 46 0 114 0 48 0 114 0 51 0 114 0 60 2 145 0 114 2 157 0 115] 
#[0 0 122 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 2 161 0 18] 
#[1 1 21 0 4 1 29 0 25 2 165 0 48 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 2 169 0 105 2 173 0 119 1 93 0 122 1 97 0 131 2 177 0 133 0 201 0 139 0 205 0 140 0 209 0 141 2 181 0 146 2 185 0 147 2 189 0 150 2 193 0 151 2 197 0 152 2 201 0 153 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 2 205 0 51 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 2 169 0 105 2 173 0 119 1 93 0 122 1 97 0 131 2 177 0 133 0 201 0 139 0 205 0 140 0 209 0 141 2 209 0 144 2 213 0 145 2 181 0 146 2 217 0 147 2 221 0 148 2 193 0 151 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[1 1 21 0 4 0 54 0 24 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 2 13 0 105 1 93 0 122 1 97 0 131 1 101 0 133 2 225 0 134 2 21 0 137 2 25 0 138 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 2 229 0 54 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 2 233 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[1 2 237 0 50 2 241 0 60 2 245 0 133 0 213 0 163 0 217 0 164 0 221 0 165] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 0 137 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 1 93 0 122 2 249 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 0 137 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 1 93 0 122 2 253 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 0 126 0 12 0 14 0 15 0 17 0 18 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 130 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 3 1 0 60] 
#[1 3 5 0 11 3 9 0 13 0 134 0 24 0 134 0 26 3 13 0 98 3 17 0 99 3 21 0 100 3 25 0 101 0 134 0 183] 
#[0 3 29 0 71] 
#[0 3 33 0 22] 
#[1 0 138 0 16 0 142 0 18 3 37 0 75 3 41 0 94 3 45 0 175 3 49 0 176] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 146 0 24 0 233 0 27 0 65 0 60 0 237 0 78 3 53 0 84 3 57 0 95 0 241 0 96 0 245 0 97 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142 3 61 0 179 3 65 0 187] 
#[1 0 150 0 6 0 150 0 24 0 150 0 26 3 69 0 136] 
#[0 3 73 0 6] 
#[0 0 154 0 6 0 24] 
#[0 0 158 0 6 0 24] 
#[0 0 162 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 3 77 0 24] 
#[0 0 166 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 170 0 6 0 8 0 18 0 24 0 26 0 47 0 71] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 65 0 60 3 81 0 78 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 174 0 25 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[1 1 29 0 25 1 53 0 59 0 137 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 1 93 0 122 1 101 0 133 3 85 0 157 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 0 178 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 0 182 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 3 89 0 25] 
#[1 0 105 0 12 0 109 0 14 0 113 0 15 0 186 0 17 0 117 0 28 0 121 0 30 0 125 0 46 0 129 0 48 0 133 0 51 0 137 0 60 3 93 0 113 0 141 0 116 0 145 0 117 0 149 0 118 0 153 0 119 0 157 0 120 0 161 0 121 0 165 0 122 0 169 0 123 0 173 0 124 0 177 0 125 0 181 0 126 0 185 0 128 0 189 0 129 0 193 0 130 0 197 0 133 0 201 0 139 0 205 0 140 0 209 0 141 0 213 0 163 0 217 0 164 0 221 0 165 3 97 0 180 0 229 0 185] 
#[0 3 101 0 17] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 3 105 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 3 109 0 17] 
#[1 0 105 0 12 0 109 0 14 0 113 0 15 0 117 0 28 0 121 0 30 0 125 0 46 0 129 0 48 0 133 0 51 0 137 0 60 0 141 0 116 0 145 0 117 0 149 0 118 0 153 0 119 0 157 0 120 0 161 0 121 0 165 0 122 0 169 0 123 0 173 0 124 0 177 0 125 0 181 0 126 0 185 0 128 0 189 0 129 0 193 0 130 0 197 0 133 0 201 0 139 0 205 0 140 0 209 0 141 0 213 0 163 0 217 0 164 0 221 0 165 3 113 0 180 0 229 0 185] 
#[1 3 117 0 60 3 121 0 149] 
#[1 0 190 0 18 3 125 0 47] 
#[0 0 190 0 18] 
#[1 1 221 0 4 0 90 0 9 0 90 0 10 1 225 0 11 0 90 0 18 0 90 0 31 0 90 0 32 0 90 0 34 0 90 0 35 0 90 0 36 0 90 0 37 0 90 0 38 0 90 0 39 0 90 0 40 0 90 0 41 0 90 0 42 0 90 0 43 0 90 0 44 0 90 0 45 0 90 0 47 0 90 0 50 0 90 0 52 0 90 0 53 0 90 0 57 1 237 0 72] 
#[0 3 129 0 18] 
#[0 0 194 0 4 0 17 0 25 0 48 0 49 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 194 0 4 0 17 0 25 0 48 0 49 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 190 0 18] 
#[0 0 198 0 4 0 17 0 25 0 48 0 49 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[1 1 21 0 4 3 133 0 17 1 29 0 25 2 165 0 48 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 2 169 0 105 2 173 0 119 1 93 0 122 1 97 0 131 2 177 0 133 0 201 0 139 0 205 0 140 0 209 0 141 2 181 0 146 2 185 0 147 2 189 0 150 2 193 0 151 3 137 0 152 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[1 3 117 0 60 3 141 0 149] 
#[0 0 202 0 4 0 17 0 25 0 49 0 51 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[1 1 21 0 4 3 145 0 17 1 29 0 25 1 33 0 49 2 205 0 51 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 2 169 0 105 2 173 0 119 1 93 0 122 1 97 0 131 2 177 0 133 0 201 0 139 0 205 0 140 0 209 0 141 3 149 0 144 2 181 0 146 2 217 0 147 2 221 0 148 2 193 0 151 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 0 206 0 4 0 17 0 25 0 49 0 51 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 0 206 0 4 0 17 0 25 0 49 0 51 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 3 153 0 24] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 3 157 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 3 161 0 6] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 0 137 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 1 93 0 122 3 165 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 0 34 0 4 0 11 0 12 0 14 0 15 0 17 0 18 0 28 0 30 0 46 0 48 0 51 0 60 0 72 0 183] 
#[1 1 221 0 4 0 210 0 12 0 210 0 14 0 210 0 15 0 210 0 17 0 210 0 18 0 210 0 28 0 210 0 30 0 210 0 46 0 210 0 48 0 210 0 51 0 210 0 60 0 210 0 183] 
#[0 0 214 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 218 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 0 222 0 24 0 26 0 183] 
#[0 0 226 0 24 0 26 0 183] 
#[0 0 230 0 24 0 26 0 183] 
#[0 0 234 0 24 0 26 0 183] 
#[0 0 238 0 24 0 26 0 183] 
#[0 0 238 0 24 0 26 0 183] 
#[0 0 238 0 24 0 26 0 183] 
#[0 0 242 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60 0 183] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 3 169 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 3 173 0 16] 
#[0 3 177 0 18] 
#[0 0 246 0 18 0 71] 
#[0 0 250 0 18 0 71] 
#[0 3 181 0 24] 
#[0 0 254 0 24] 
#[1 1 2 0 24 1 2 0 26 3 185 0 93] 
#[0 1 6 0 24] 
#[1 1 10 0 6 1 10 0 24 3 189 0 26 3 193 0 135] 
#[0 1 14 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 1 18 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 1 22 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 23 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[0 1 26 0 6 0 8 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 46 0 47 0 48 0 51 0 60 0 71 0 183] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 146 0 24 0 233 0 27 0 65 0 60 0 237 0 78 3 197 0 84 3 57 0 95 0 241 0 96 0 245 0 97 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142 3 61 0 179 3 65 0 187] 
#[0 1 30 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60] 
#[0 1 34 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60] 
#[0 1 38 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 3 201 0 8] 
#[0 1 42 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 3 205 0 17] 
#[0 3 209 0 9] 
#[0 1 46 0 4 0 17 0 25 0 48 0 49 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[1 2 241 0 60 3 213 0 119 3 217 0 133 0 201 0 139 0 205 0 140 0 209 0 141 0 213 0 163 0 217 0 164 0 221 0 165] 
#[1 0 105 0 12 0 109 0 14 0 113 0 15 0 117 0 28 0 121 0 30 0 125 0 46 0 129 0 48 0 133 0 51 0 137 0 60 0 141 0 116 0 145 0 117 0 149 0 118 0 153 0 119 0 157 0 120 0 161 0 121 0 165 0 122 0 169 0 123 0 173 0 124 0 177 0 125 0 181 0 126 0 185 0 128 0 189 0 129 0 193 0 130 0 197 0 133 0 201 0 139 0 205 0 140 0 209 0 141 0 213 0 163 0 217 0 164 0 221 0 165 3 221 0 180 0 229 0 185] 
#[0 1 50 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 1 54 0 4 0 17 0 25 0 48 0 49 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 1 58 0 4 0 17 0 25 0 49 0 51 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 1 62 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 1 66 0 4 0 17 0 25 0 49 0 51 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 1 70 0 6 0 8 0 9 0 10 0 12 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 183] 
#[0 3 225 0 8] 
#[0 1 74 0 4 0 6 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 72 0 73 0 183] 
#[0 1 78 0 12 0 14 0 15 0 17 0 18 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 3 229 0 71] 
#[0 3 233 0 74] 
#[1 1 82 0 1 1 82 0 2 1 82 0 4 1 82 0 7 1 82 0 17 1 82 0 20 1 82 0 21 1 82 0 27 1 82 0 29 1 82 0 60 3 237 0 143] 
#[1 1 86 0 5 1 86 0 16 1 86 0 18 3 241 0 87] 
#[1 1 90 0 24 3 245 0 26 3 249 0 92] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 3 253 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 1 94 0 6 0 24 0 26] 
#[0 4 1 0 24] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 4 5 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 1 98 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 4 9 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 1 102 0 18] 
#[1 1 221 0 4 1 225 0 11 1 237 0 72] 
#[0 4 13 0 17] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 4 17 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 1 106 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60 0 183] 
#[1 1 110 0 19 4 21 0 77] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 4 25 0 17 0 33 0 20 4 29 0 21 1 5 0 27 0 41 0 29 0 65 0 60 4 33 0 78 4 37 0 79 4 41 0 80 4 45 0 81 4 49 0 82 4 53 0 83 4 57 0 106 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 4 61 0 127 0 97 0 142 4 65 0 177 4 69 0 178 4 73 0 181 4 77 0 182 4 81 0 186] 
#[1 4 85 0 5 0 138 0 16 0 142 0 18 3 37 0 75 4 89 0 85 4 93 0 86 4 97 0 94 3 45 0 175 3 49 0 176] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 233 0 27 0 65 0 60 0 237 0 78 0 241 0 96 0 245 0 97 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142 4 101 0 179] 
#[0 1 114 0 24 0 26] 
#[0 1 118 0 6 0 24 0 26] 
#[1 1 86 0 5 1 86 0 16 1 86 0 18 4 105 0 87] 
#[0 4 109 0 18] 
#[0 4 113 0 8] 
#[0 1 122 0 4 0 17 0 25 0 48 0 49 0 51 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 4 117 0 6] 
#[0 4 121 0 19] 
#[0 4 125 0 71] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 4 129 0 27 4 133 0 29 0 65 0 60 4 137 0 78 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142] 
#[1 1 177 0 23 1 253 0 60] 
#[0 1 126 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 1 130 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 1 130 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 1 130 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 1 126 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 1 126 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 1 134 0 1 0 2 0 4 0 7 0 17 0 20 0 21 0 27 0 29 0 60] 
#[0 1 126 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 1 126 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 1 138 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 1 138 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 1 142 0 1 0 2 0 4 0 7 0 17 0 20 0 21 0 27 0 29 0 60] 
#[1 4 141 0 60 4 145 0 102] 
#[0 1 146 0 5 0 16 0 18] 
#[0 1 150 0 5 0 16 0 18] 
#[0 4 149 0 18] 
#[0 1 154 0 24 0 26] 
#[1 4 85 0 5 0 138 0 16 0 142 0 18 3 37 0 75 4 89 0 85 4 93 0 86 4 153 0 94 3 45 0 175 3 49 0 176] 
#[1 0 105 0 12 0 109 0 14 0 113 0 15 0 117 0 28 0 121 0 30 0 125 0 46 0 129 0 48 0 133 0 51 0 137 0 60 0 141 0 116 0 145 0 117 0 149 0 118 0 153 0 119 0 157 0 120 0 161 0 121 0 165 0 122 0 169 0 123 0 173 0 124 0 177 0 125 0 181 0 126 0 185 0 128 0 189 0 129 0 193 0 130 0 197 0 133 0 201 0 139 0 205 0 140 0 209 0 141 0 213 0 163 0 217 0 164 0 221 0 165 4 157 0 180 0 229 0 185] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 4 161 0 105 1 93 0 122 1 97 0 131 1 101 0 133 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[0 1 158 0 4 0 6 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 17 0 18 0 24 0 26 0 28 0 30 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 50 0 51 0 52 0 53 0 57 0 60 0 71 0 72 0 73 0 183] 
#[0 1 162 0 18 0 71] 
#[0 1 166 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60 0 183] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 65 0 60 4 165 0 78 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142] 
#[0 4 169 0 60] 
#[0 4 173 0 23] 
#[1 1 170 0 26 1 170 0 71 4 177 0 104] 
#[0 4 181 0 71] 
#[1 1 174 0 1 1 174 0 2 1 174 0 4 1 174 0 7 1 174 0 12 1 174 0 14 1 174 0 15 1 174 0 20 1 174 0 21 1 174 0 27 1 174 0 28 1 174 0 29 1 174 0 30 1 174 0 46 1 174 0 48 1 174 0 51 1 174 0 60 4 185 0 89] 
#[0 4 189 0 18] 
#[0 4 193 0 17] 
#[0 4 197 0 18] 
#[0 4 201 0 60] 
#[0 4 205 0 25] 
#[0 4 209 0 60] 
#[1 4 213 0 26 1 178 0 71 4 217 0 103] 
#[0 1 182 0 5 0 16 0 18] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 105 0 12 0 109 0 14 0 113 0 15 0 33 0 20 4 29 0 21 1 5 0 27 0 117 0 28 0 41 0 29 0 121 0 30 0 125 0 46 0 129 0 48 0 133 0 51 4 221 0 60 4 33 0 78 4 37 0 79 4 41 0 80 4 45 0 81 4 49 0 82 4 53 0 83 4 225 0 88 4 57 0 106 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 141 0 116 0 145 0 117 0 149 0 118 0 153 0 119 0 157 0 120 0 161 0 121 0 165 0 122 0 169 0 123 0 173 0 124 0 177 0 125 0 181 0 126 0 185 0 128 0 189 0 129 0 193 0 130 0 197 0 133 0 201 0 139 0 205 0 140 0 209 0 141 0 97 0 142 0 213 0 163 0 217 0 164 0 221 0 165 4 65 0 177 4 69 0 178 4 229 0 180 4 73 0 181 4 77 0 182 0 229 0 185 4 233 0 186] 
#[1 1 174 0 1 1 174 0 2 1 174 0 4 1 174 0 7 1 174 0 12 1 174 0 14 1 174 0 15 1 174 0 17 1 174 0 20 1 174 0 21 1 174 0 27 1 174 0 28 1 174 0 29 1 174 0 30 1 174 0 46 1 174 0 48 1 174 0 51 1 174 0 60 4 237 0 89] 
#[0 1 186 0 12 0 14 0 15 0 17 0 28 0 30 0 46 0 48 0 51 0 60 0 183] 
#[1 1 21 0 4 1 29 0 25 1 33 0 49 1 37 0 55 1 41 0 56 1 45 0 57 1 49 0 58 1 53 0 59 1 57 0 60 1 61 0 61 1 65 0 62 1 69 0 63 1 73 0 64 1 77 0 65 1 81 0 66 1 85 0 67 2 169 0 105 2 173 0 119 1 93 0 122 1 97 0 131 2 177 0 133 0 201 0 139 0 205 0 140 0 209 0 141 2 181 0 146 4 241 0 147 2 193 0 151 1 105 0 154 1 109 0 155 1 113 0 156 1 117 0 157 1 121 0 158 1 125 0 159 1 129 0 160 1 133 0 161 1 137 0 162 0 213 0 163 0 217 0 164 0 221 0 165 1 141 0 166 1 145 0 168 1 149 0 169 1 153 0 170 1 157 0 171 1 161 0 172 1 165 0 173 1 169 0 174] 
#[1 0 138 0 16 0 142 0 71 3 37 0 75 4 245 0 94 3 45 0 175 3 49 0 176] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 146 0 24 0 233 0 27 0 65 0 60 0 237 0 78 4 249 0 84 3 57 0 95 0 241 0 96 0 245 0 97 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142 3 61 0 179 3 65 0 187] 
#[0 4 253 0 25] 
#[0 5 1 0 60] 
#[0 1 190 0 26 0 71] 
#[1 0 34 0 4 0 34 0 11 0 34 0 13 0 14 0 23 1 217 0 25 0 34 0 33 0 14 0 60 0 34 0 72 0 34 0 73] 
#[0 1 194 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 5 5 0 17] 
#[0 1 198 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 105 0 12 0 109 0 14 0 113 0 15 1 202 0 17 0 33 0 20 4 29 0 21 1 5 0 27 0 117 0 28 0 41 0 29 0 121 0 30 0 125 0 46 0 129 0 48 0 133 0 51 4 221 0 60 4 33 0 78 4 37 0 79 4 41 0 80 4 45 0 81 4 49 0 82 4 53 0 83 4 225 0 88 5 9 0 90 5 13 0 91 4 57 0 106 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 141 0 116 0 145 0 117 0 149 0 118 0 153 0 119 0 157 0 120 0 161 0 121 0 165 0 122 0 169 0 123 0 173 0 124 0 177 0 125 0 181 0 126 0 185 0 128 0 189 0 129 0 193 0 130 0 197 0 133 0 201 0 139 0 205 0 140 0 209 0 141 0 97 0 142 0 213 0 163 0 217 0 164 0 221 0 165 4 65 0 177 4 69 0 178 5 17 0 180 4 73 0 181 4 77 0 182 0 229 0 185 4 233 0 186] 
#[0 5 21 0 17] 
#[0 5 25 0 71] 
#[0 5 29 0 24] 
#[1 0 49 0 1 0 53 0 2 0 57 0 4 0 61 0 7 0 146 0 24 0 233 0 27 0 65 0 60 0 237 0 78 5 33 0 84 3 57 0 95 0 241 0 96 0 245 0 97 0 73 0 107 0 77 0 108 0 81 0 109 0 85 0 110 0 89 0 111 0 93 0 112 0 97 0 142 3 61 0 179 3 65 0 187] 
#[0 1 206 0 26 0 71] 
#[0 5 37 0 71] 
#[0 1 210 0 17] 
#[0 5 41 0 17] 
#[0 1 214 0 17] 
#[0 1 218 0 4 0 17 0 25 0 48 0 49 0 51 0 55 0 56 0 57 0 58 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67] 
#[0 1 222 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[1 0 138 0 16 0 142 0 71 3 37 0 75 5 45 0 94 3 45 0 175 3 49 0 176] 
#[0 5 49 0 24] 
#[0 1 226 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 5 53 0 71] 
#[0 5 57 0 71] 
#[1 0 138 0 16 0 142 0 71 3 37 0 75 5 61 0 94 3 45 0 175 3 49 0 176] 
#[0 1 230 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60 0 183] 
#[0 1 234 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60] 
#[0 5 65 0 71] 
#[0 1 238 0 1 0 2 0 4 0 7 0 12 0 14 0 15 0 17 0 20 0 21 0 27 0 28 0 29 0 30 0 46 0 48 0 51 0 60]
	).
]
