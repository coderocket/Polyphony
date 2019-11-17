Class {
	#name : #OccamCoreParser,
	#superclass : #SmaCCParser,
	#category : #'Occam-Core-AST'
}

{ #category : #'generated-accessing' }
OccamCoreParser class >> cacheId [
	^'2019-11-17T21:25:00.423689+02:00'
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
%start Procedure Function Process Parameter DataType Abbreviation Expression;

%ignore_variables leftBracketToken rightBracketToken;

Library 
	: ""LIBRARY"" <name> 'name' ""IS"" (Doc 'doc')? ""BEGIN"" (Using 'using')* (Definition 'member')* ""END"" <period> {{ }}
	;

Using 
	:  ""USING"" (""/"" <name> 'name')+ <period> {{ }}
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
OccamCoreParser class >> startingStateForExpression [
	^ 8
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
	result addNodes: (nodes at: 6) to: result usings.
	result addNodes: (nodes at: 7) to: result members.
	result eNDToken: (nodes at: 8).
	result periodToken: (nodes at: 9).
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
OccamCoreParser >> reduceActionForType1: nodes [
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
OccamCoreParser >> reduceActionForUsing1: nodes [
	| result |
	result := ASTUsing new.
	result uSINGToken: (nodes at: 1).
	result addTokens: ((nodes at: 2) at: 1) to: result divideTokens.
	result addTokens: ((nodes at: 2) at: 2) to: result names.
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

{ #category : #'generated-reduction actions' }
OccamCoreParser >> reduceActionFor_______name___name___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	self add: ((nodes at: 1) at: 1) to: (result at: 1).
	self add: ((nodes at: 1) at: 2) to: (result at: 2).
	^ result
]

{ #category : #generated }
OccamCoreParser >> reduceTable [
^#(
	#(117 1 #reduceActionForEventType1:) 
	#(118 1 #reduceActionForTimerType1:) 
	#(112 1 #reduceActionForBasicType1:) 
	#(85 1 #reduceActionForType1:) 
	#(113 1 #reduceActionForType1:) 
	#(122 1 #reduceActionForSkip1:) 
	#(123 1 #reduceActionForStop1:) 
	#(169 1 #reduceActionForVariable1:) 
	#(186 1 #reduceActionForType1:) 
	#(125 1 #reduceActionForType1:) 
	#(139 1 #reduceActionForType1:) 
	#(185 1 #reduceActionForType1:) 
	#(144 0 #reduceActionFor__Expression__expr________Expression__expr_____1:) 
	#(172 1 #reduceActionForType1:) 
	#(176 1 #reduceActionForLiteralBoolean1:) 
	#(174 1 #reduceActionForLiteralInteger1:) 
	#(175 1 #reduceActionForLiteralHexInteger1:) 
	#(177 1 #reduceActionForLiteralReal1:) 
	#(178 1 #reduceActionForLiteralReal641:) 
	#(180 1 #reduceActionForLiteralString1:) 
	#(179 1 #reduceActionForLiteralByte1:) 
	#(166 1 #reduceActionForType1:) 
	#(182 1 #reduceActionForType1:) 
	#(137 1 #reduceActionForType1:) 
	#(163 1 #reduceActionForType1:) 
	#(168 1 #reduceActionForType1:) 
	#(120 0 #reduceActionFor__Process__process___1:) 
	#(135 2 #reduceActionForReplicatedSeq1:) 
	#(134 2 #reduceActionForReplicatedPar1:) 
	#(136 2 #reduceActionForResult1:) 
	#(146 2 #reduceActionForEventWait1:) 
	#(127 2 #reduceActionForEventSignal1:) 
	#(108 0 #reduceActionForDirNone1:) 
	#(144 1 #reduceActionFor__Expression__expr________Expression__expr_____2:) 
	#(140 1 #reduceActionFor__Expression__expr________Expression__expr_____2:) 
	#(142 0 #reduceActionFor__Expression__expr________Expression__expr_____1:) 
	#(164 2 #reduceActionForBytesIn1:) 
	#(165 2 #reduceActionForConversion1:) 
	#(173 1 #reduceActionForType1:) 
	#(160 2 #reduceActionForMonadicExpression1:) 
	#(192 0 #nil) 
	#(82 0 #reduceActionForStartDoc1:) 
	#(102 0 #reduceActionFor__Expression__expr________Expression__expr_____1:) 
	#(116 3 #reduceActionForChannelType1:) 
	#(115 3 #reduceActionForArrayReferenceType1:) 
	#(121 1 #reduceActionFor__Expression__expr________Expression__expr_____2:) 
	#(152 1 #reduceActionForType1:) 
	#(158 1 #reduceActionForType1:) 
	#(159 1 #reduceActionForIfGuardedCommand_1:) 
	#(151 1 #reduceActionForIfGuardedCommand_1:) 
	#(150 1 #reduceActionForType1:) 
	#(145 3 #reduceActionForImmediateInput1:) 
	#(126 3 #reduceActionForOutput1:) 
	#(124 3 #reduceActionForAssign1:) 
	#(104 3 #reduceActionForValueParameter1:) 
	#(106 1 #reduceActionForDirIn1:) 
	#(107 1 #reduceActionForDirOut1:) 
	#(103 3 #reduceActionForReferenceParameter1:) 
	#(105 1 #reduceActionForType1:) 
	#(184 3 #reduceActionForDataType1:) 
	#(162 3 #reduceActionForTable1:) 
	#(143 2 #reduceActionFor__Expression__expr________Expression__expr____1:) 
	#(167 3 #reduceActionForParenthesisExpression1:) 
	#(161 3 #reduceActionForDyadicExpression1:) 
	#(192 1 #reduceActionForType1:) 
	#(97 1 #reduceActionForType1:) 
	#(102 1 #reduceActionFor__Expression__expr________Expression__expr_____2:) 
	#(91 1 #reduceActionFor__Expression__expr________Expression__expr_____2:) 
	#(100 0 #reduceActionFor__Expression__expr________Expression__expr_____1:) 
	#(114 4 #reduceActionForArrayType1:) 
	#(120 2 #reduceActionFor__Process__process___2:) 
	#(119 1 #reduceActionForType1:) 
	#(129 4 #reduceActionForSeq1:) 
	#(191 4 #reduceActionForPar1:) 
	#(156 2 #reduceActionForReplicatedIfGuardedCommand1:) 
	#(132 4 #reduceActionForIf1:) 
	#(159 2 #reduceActionFor__Process__process___2:) 
	#(154 2 #reduceActionForReplicatedAltGuardedCommand1:) 
	#(131 4 #reduceActionForAlt1:) 
	#(151 2 #reduceActionFor__Process__process___2:) 
	#(128 4 #reduceActionForCall1:) 
	#(147 4 #reduceActionForDelayedInput1:) 
	#(170 4 #reduceActionForArrayComponent1:) 
	#(142 2 #reduceActionFor______Expression__expr___2:) 
	#(110 0 #reduceActionFor__Process__process___1:) 
	#(94 0 #reduceActionFor__Process__process___1:) 
	#(101 2 #reduceActionFor__Expression__expr________Expression__expr____1:) 
	#(157 3 #reduceActionForInputGuard1:) 
	#(133 5 #reduceActionForWhile1:) 
	#(183 5 #reduceActionForAbbreviation1:) 
	#(141 2 #reduceActionFor______Expression__expr__1:) 
	#(84 0 #reduceActionForEndDoc1:) 
	#(76 0 #reduceActionFor__Process__process___1:) 
	#(100 2 #reduceActionFor______Expression__expr___2:) 
	#(153 4 #reduceActionForGuardedCommand1:) 
	#(149 1 #reduceActionForType1:) 
	#(110 2 #reduceActionFor__Process__process___2:) 
	#(93 1 #reduceActionForType1:) 
	#(94 2 #reduceActionFor__Process__process___2:) 
	#(99 2 #reduceActionFor______Expression__expr__1:) 
	#(171 7 #reduceActionForArraySegment1:) 
	#(181 5 #reduceActionForDoc1:) 
	#(81 1 #reduceActionFor_______name___name___1:) 
	#(83 1 #reduceActionForType1:) 
	#(77 1 #reduceActionForType1:) 
	#(76 2 #reduceActionFor__Process__process___2:) 
	#(90 1 #reduceActionForType1:) 
	#(87 1 #reduceActionForType1:) 
	#(111 0 #reduceActionFor__Expression__expr________Expression__expr_____1:) 
	#(96 0 #reduceActionFor__Process__process___1:) 
	#(80 2 #reduceActionFor______Expression__expr__1:) 
	#(130 3 #reduceActionForUsing1:) 
	#(81 2 #reduceActionFor______Expression__expr___2:) 
	#(78 9 #reduceActionForLibrary1:) 
	#(109 2 #reduceActionFor__Expression__expr________Expression__expr____1:) 
	#(92 3 #reduceActionForUse1:) 
	#(138 8 #reduceActionForReplicatedProcess1:) 
	#(111 2 #reduceActionFor______Expression__expr___2:) 
	#(95 1 #reduceActionForType1:) 
	#(96 2 #reduceActionFor__Process__process___2:) 
	#(98 0 #nil) 
	#(148 2 #reduceActionFor______Expression__expr__1:) 
	#(193 1 #reduceActionForType1:) 
	#(98 1 #reduceActionForType1:) 
	#(155 8 #reduceActionForReplicatedGuardedCommand1:) 
	#(188 12 #reduceActionForProcedure1:) 
	#(86 6 #reduceActionForExternalAbbreviation1:) 
	#(187 13 #reduceActionForFunction1:) 
	#(88 8 #reduceActionForExternalProcedure1:) 
	#(89 9 #reduceActionForExternalFunction1:)
	).
]

{ #category : #generated }
OccamCoreParser >> symbolNames [
	^ #('"OF"' '"CHAN"' '"USE"' '"EVENT"' '"?"' '"TIMER"' '"!"' '","' '"="' '"SEQ"' '"PAR"' '"FUNCTION"' '"]"' '"["' '">>"' '"USING"' '"END"' '"BEGIN"' '"/"' '"LIBRARY"' '"DOC"' '"IS"' '"RESULT"' '")"' '"("' '"PROC"' '"FOR"' '"EXTERNAL"' '"*/"' '"VAL"' '"REM"' '"SKIP"' '"\/"' '"AND"' '"\"' '"OR"' '"/\"' '"*"' '"<<"' '"<="' '">="' '"><"' '"<"' '"<>"' '">"' '"IF"' '"ALT"' '"+"' '"&"' '"STOP"' '"AFTER"' '":="' '"WHILE"' '"SIZE"' '"NOT"' '"~"' '"BYTESIN"' '"FROM"' '"-"' '<bool>' '<name>' '<integer>' '<hexinteger>' '<number>' '<real32>' '<real64>' '<string>' '<byte>' '<whitespace>' '<comment>' '<newline>' '<period>' '<queryeol>' '<bangeol>' '<text>' '( Definition ''member'')*' 'Definition' 'Library' 'B e g i n' '( "/" <name> ''name'')' '( "/" <name> ''name'')+' 'StartDoc' '( Definition ''member'')' 'EndDoc' 'Type' 'ExternalAbbreviation' 'ProcessAbstraction' 'ExternalProcedure' 'ExternalFunction' 'Abstraction' 'ParameterList' 'Use' '( Use ''use'')' '( Use ''use'')*' '( Definition ''local'')' '( Definition ''local'')*' '( Doc ''doc'')' '( Process ''body'')?' '( "," Parameter ''param'')' '( "," Parameter ''param'')*' '( Parameter ''param'' ( "," Parameter ''param'')*)' '( Parameter ''param'' ( "," Parameter ''param'')*)?' 'ReferenceParameter' 'ValueParameter' 'Direction' 'DirIn' 'DirOut' 'DirNone' 'NameList' '( Using ''using'')*' '( "," <name> ''name'')*' 'BasicType' 'InputSourceType' 'ArrayType' 'ArrayReferenceType' 'ChannelType' 'EventType' 'TimerType' '( Process ''process'')' '( Process ''process'')*' 'ProcessList' 'Skip' 'Stop' 'Assign' 'Input' 'Output' 'EventSignal' 'Call' 'Seq' 'Using' 'Alt' 'If' 'While' 'ReplicatedPar' 'ReplicatedSeq' 'Result' 'NonConversionExpression' 'ReplicatedProcess' 'LValue' 'ExpressionList' '( "," Expression ''expr'')' '( "," Expression ''expr'')*' '( Expression ''expr'' ( "," Expression ''expr'')*)' '( Expression ''expr'' ( "," Expression ''expr'')*)?' 'ImmediateInput' 'EventWait' 'DelayedInput' '( "," <name> ''name'')' '( Using ''using'')' 'AltGuardedCommand' 'AltGuardedCommand+' 'Guard' 'GuardedCommand' 'ReplicatedAltGuardedCommand' 'ReplicatedGuardedCommand' 'ReplicatedIfGuardedCommand' 'InputGuard' 'IfGuardedCommand' 'IfGuardedCommand+' 'MonadicExpression' 'DyadicExpression' 'Table' 'Operand' 'BytesIn' 'Conversion' 'SimpleOperand' 'ParenthesisExpression' 'Literal' 'Variable' 'ArrayComponent' 'ArraySegment' 'MonadicOperator' 'DyadicOperator' 'LiteralInteger' 'LiteralHexInteger' 'LiteralBoolean' 'LiteralReal' 'LiteralReal64' 'LiteralByte' 'LiteralString' 'Doc' 'Expression' 'Abbreviation' 'DataType' 'Parameter' 'Process' 'Function' 'Procedure' 'E O F' 'error' 'Par' '( Doc ''doc'')?' '( Process ''body'')')
]

{ #category : #generated }
OccamCoreParser >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #OrderedCollection #ASTDefinition #ASTLibrary #ASTLibrary #OrderedCollection #OrderedCollection nil #ASTDefinition nil #ASTType #ASTExternalAbbreviation #ASTProcessAbstraction #ASTExternalProcedure #ASTExternalFunction #ASTAbstraction #OrderedCollection #ASTUse #ASTUse #OrderedCollection #ASTDefinition #OrderedCollection #ASTDoc #ASTProcess #OrderedCollection #OrderedCollection #OrderedCollection #OrderedCollection #ASTReferenceParameter #ASTValueParameter #ASTDirection #ASTDirIn #ASTDirOut #ASTDirNone #OrderedCollection #OrderedCollection #OrderedCollection #ASTBasicType #ASTType #ASTArrayType #ASTArrayReferenceType #ASTChannelType #ASTEventType #ASTTimerType #ASTProcess #OrderedCollection #OrderedCollection #ASTSkip #ASTStop #ASTAssign #ASTInput #ASTOutput #ASTEventSignal #ASTCall #ASTSeq #ASTUsing #ASTAlt #ASTIf #ASTWhile #ASTReplicatedPar #ASTReplicatedSeq #ASTResult #ASTRoot #ASTReplicatedProcess #ASTLValue #OrderedCollection #OrderedCollection #OrderedCollection #OrderedCollection #OrderedCollection #ASTImmediateInput #ASTEventWait #ASTDelayedInput #OrderedCollection #ASTUsing #ASTRoot #OrderedCollection #ASTRoot #ASTGuardedCommand #ASTReplicatedAltGuardedCommand #OrderedCollection #ASTReplicatedIfGuardedCommand #ASTInputGuard #ASTRoot #OrderedCollection #ASTMonadicExpression #ASTDyadicExpression #ASTTable #ASTRoot #ASTBytesIn #ASTConversion #ASTRoot #ASTParenthesisExpression #ASTLiteral #ASTVariable #ASTArrayComponent #ASTArraySegment #SmaCCToken #SmaCCToken #ASTLiteralInteger #ASTLiteralHexInteger #ASTLiteralBoolean #ASTLiteralReal #ASTLiteralReal64 #ASTLiteralByte #ASTLiteralString #ASTDoc #ASTRoot #ASTAbbreviation #ASTDataType #ASTParameter #ASTProcess #ASTFunction #ASTProcedure #SmaCCToken #SmaCCToken #ASTPar #ASTDoc #ASTProcess)
]

{ #category : #generated }
OccamCoreParser >> transitionTable [
^#(
#[1 0 37 0 20 0 41 0 78] 
#[1 0 45 0 26 0 49 0 188] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 69 0 61 0 73 0 85 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118 0 105 0 187] 
#[1 0 109 0 10 0 113 0 11 0 117 0 23 0 121 0 32 0 125 0 46 0 129 0 47 0 133 0 50 0 137 0 53 0 141 0 61 0 145 0 122 0 149 0 123 0 153 0 124 0 157 0 125 0 161 0 126 0 165 0 127 0 169 0 128 0 173 0 129 0 177 0 131 0 181 0 132 0 185 0 133 0 189 0 134 0 193 0 135 0 197 0 136 0 201 0 139 0 205 0 145 0 209 0 146 0 213 0 147 0 217 0 169 0 221 0 170 0 225 0 171 0 229 0 186 0 233 0 191] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 237 0 30 0 69 0 61 0 241 0 85 0 245 0 103 0 249 0 104 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118 0 253 0 185] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 69 0 61 1 1 0 85 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118 1 5 0 184] 
#[1 1 9 0 30 1 13 0 183] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 1 161 0 182] 
#[0 1 165 0 61] 
#[0 0 0 0 189] 
#[0 1 169 0 61] 
#[0 0 0 0 189] 
#[0 1 173 0 1] 
#[0 0 6 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 10 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[1 1 177 0 13 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 1 181 0 182] 
#[0 0 14 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 1 185 0 12] 
#[0 0 18 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 18 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 18 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 18 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 22 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 22 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 22 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 0 0 189] 
#[1 1 189 0 18 1 193 0 61 1 197 0 138] 
#[1 1 201 0 18 1 193 0 61 1 205 0 138] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 0 141 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 209 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180] 
#[0 0 26 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 1 213 0 18] 
#[0 1 217 0 18] 
#[0 0 30 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 1 221 0 182] 
#[1 0 34 0 5 0 34 0 7 0 34 0 8 0 34 0 9 0 34 0 10 0 34 0 11 0 34 0 13 0 34 0 14 0 34 0 15 0 34 0 17 0 34 0 18 0 34 0 19 0 34 0 23 0 34 0 24 1 225 0 25 0 34 0 27 0 34 0 31 0 34 0 32 0 34 0 33 0 34 0 34 0 34 0 35 0 34 0 36 0 34 0 37 0 34 0 38 0 34 0 39 0 34 0 40 0 34 0 41 0 34 0 42 0 34 0 43 0 34 0 44 0 34 0 45 0 34 0 46 0 34 0 47 0 34 0 48 0 34 0 49 0 34 0 50 0 34 0 51 0 34 0 52 0 34 0 53 0 34 0 59 0 34 0 61 0 34 0 72 0 34 0 73 0 34 0 74 0 34 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[1 1 229 0 5 1 233 0 7 1 237 0 14 1 241 0 52 1 245 0 73 1 249 0 74] 
#[0 0 42 0 10 0 11 0 17 0 18 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 42 0 10 0 11 0 17 0 18 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 42 0 10 0 11 0 17 0 18 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 46 0 5 0 7 0 8 0 9 0 10 0 11 0 13 0 14 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 59 0 61 0 72 0 73 0 74 0 189] 
#[0 0 46 0 5 0 7 0 8 0 9 0 10 0 11 0 13 0 14 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 59 0 61 0 72 0 73 0 74 0 189] 
#[0 0 46 0 5 0 7 0 8 0 9 0 10 0 11 0 13 0 14 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 59 0 61 0 72 0 73 0 74 0 189] 
#[0 0 0 0 189] 
#[0 0 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 69 0 61 1 253 0 85 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118] 
#[0 2 1 0 61] 
#[0 0 50 0 8 0 24 0 189] 
#[0 0 50 0 8 0 24 0 189] 
#[0 0 0 0 189] 
#[0 2 5 0 61] 
#[0 0 0 0 189] 
#[0 2 9 0 61] 
#[0 0 0 0 189] 
#[1 0 54 0 13 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 2 13 0 140 2 17 0 143 2 21 0 144 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 2 25 0 182] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 2 29 0 182] 
#[0 0 58 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 58 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 58 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 69 0 61 2 33 0 85 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118] 
#[0 0 58 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 62 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[1 0 34 0 5 0 34 0 8 0 34 0 9 0 34 0 13 0 34 0 14 0 34 0 15 0 34 0 18 0 34 0 19 0 34 0 24 1 225 0 25 0 34 0 27 0 34 0 31 0 34 0 33 0 34 0 34 0 34 0 35 0 34 0 36 0 34 0 37 0 34 0 38 0 34 0 39 0 34 0 40 0 34 0 41 0 34 0 42 0 34 0 43 0 34 0 44 0 34 0 45 0 34 0 48 0 34 0 49 0 34 0 51 0 34 0 59 1 45 0 60 0 141 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 0 34 0 72 0 34 0 73 1 81 0 128 1 89 0 139 2 37 0 166 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 0 34 0 189] 
#[0 0 66 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 70 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 74 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 74 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 78 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 82 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 86 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 90 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 94 0 8 0 13 0 18 0 24 0 27 0 49 0 72 0 189] 
#[1 0 90 0 8 0 90 0 9 0 90 0 10 0 90 0 11 0 90 0 13 1 237 0 14 0 90 0 15 0 90 0 17 0 90 0 18 0 90 0 19 0 90 0 23 0 90 0 24 0 90 0 27 0 90 0 31 0 90 0 32 0 90 0 33 0 90 0 34 0 90 0 35 0 90 0 36 0 90 0 37 0 90 0 38 0 90 0 39 0 90 0 40 0 90 0 41 0 90 0 42 0 90 0 43 0 90 0 44 0 90 0 45 0 90 0 46 0 90 0 47 0 90 0 48 0 90 0 49 0 90 0 50 0 90 0 51 0 90 0 53 0 90 0 59 0 90 0 61 0 90 0 72 0 90 0 189] 
#[0 0 98 0 8 0 10 0 11 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 98 0 8 0 10 0 11 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 98 0 8 0 10 0 11 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[1 0 98 0 8 2 41 0 9 0 98 0 10 0 98 0 11 0 98 0 13 2 45 0 15 0 98 0 17 0 98 0 18 2 49 0 19 0 98 0 23 0 98 0 24 0 98 0 27 2 53 0 31 0 98 0 32 2 57 0 33 2 61 0 34 2 65 0 35 2 69 0 36 2 73 0 37 2 77 0 38 2 81 0 39 2 85 0 40 2 89 0 41 2 93 0 42 2 97 0 43 2 101 0 44 2 105 0 45 0 98 0 46 0 98 0 47 2 109 0 48 0 98 0 49 0 98 0 50 2 113 0 51 0 98 0 53 2 117 0 59 0 98 0 61 0 98 0 72 2 121 0 173 0 98 0 189] 
#[0 0 98 0 8 0 10 0 11 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 94 0 8 0 13 0 18 0 24 0 27 0 49 0 72 0 189] 
#[0 0 102 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 102 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 90 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[1 1 21 0 25 1 45 0 60 0 141 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 89 0 139 2 125 0 163 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180] 
#[0 0 106 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 106 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 106 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 106 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 106 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 106 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 106 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 0 0 0 189] 
#[0 2 129 0 22] 
#[0 2 133 0 25] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 69 0 61 2 137 0 85 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 69 0 61 2 141 0 85 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118] 
#[0 2 145 0 13] 
#[0 2 149 0 61] 
#[1 0 110 0 10 0 110 0 11 0 110 0 17 0 110 0 23 0 110 0 32 0 110 0 46 0 110 0 47 0 110 0 50 0 110 0 53 0 110 0 61 2 153 0 120 2 157 0 121] 
#[0 2 161 0 9] 
#[0 0 114 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[1 0 110 0 10 0 110 0 11 0 110 0 17 0 110 0 23 0 110 0 32 0 110 0 46 0 110 0 47 0 110 0 50 0 110 0 53 0 110 0 61 2 153 0 120 2 165 0 121] 
#[0 0 118 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 122 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[1 1 17 0 14 1 21 0 25 2 169 0 46 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 2 173 0 125 1 81 0 128 1 85 0 137 2 177 0 139 0 205 0 145 0 209 0 146 0 213 0 147 2 181 0 152 2 185 0 153 2 189 0 156 2 193 0 157 2 197 0 158 2 201 0 159 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 2 205 0 182] 
#[1 1 17 0 14 1 21 0 25 2 209 0 47 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 2 173 0 125 1 81 0 128 1 85 0 137 2 177 0 139 0 205 0 145 0 209 0 146 0 213 0 147 2 213 0 150 2 217 0 151 2 181 0 152 2 221 0 153 2 225 0 154 2 193 0 157 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 2 205 0 182] 
#[0 2 229 0 18] 
#[1 1 17 0 14 0 54 0 24 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 2 233 0 140 2 17 0 143 2 21 0 144 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 2 25 0 182] 
#[1 2 237 0 51 2 241 0 61 2 245 0 139 0 217 0 169 0 221 0 170 0 225 0 171] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 0 141 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 2 249 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 2 253 0 58 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 3 1 0 182] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 0 141 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 3 5 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180] 
#[0 0 126 0 10 0 11 0 17 0 18 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 130 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 3 9 0 61] 
#[1 3 13 0 5 3 17 0 7 0 134 0 8 0 134 0 24 3 21 0 105 3 25 0 106 3 29 0 107 3 33 0 108 0 134 0 189] 
#[0 3 37 0 72] 
#[0 3 41 0 22] 
#[0 3 45 0 13] 
#[0 0 138 0 13 0 24] 
#[0 0 142 0 13 0 24] 
#[1 0 146 0 8 0 146 0 13 0 146 0 24 3 49 0 142] 
#[0 3 53 0 24] 
#[0 0 150 0 8 0 10 0 11 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 154 0 8 0 13 0 18 0 24 0 27 0 49 0 72 0 189] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 158 0 25 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[1 1 21 0 25 1 45 0 60 0 141 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 89 0 139 3 57 0 163 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180] 
#[0 0 162 0 8 0 10 0 11 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[1 0 166 0 18 0 170 0 21 3 61 0 82 3 65 0 97 3 69 0 181 3 73 0 192] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 174 0 24 0 237 0 30 0 69 0 61 0 241 0 85 3 77 0 91 3 81 0 101 3 85 0 102 0 245 0 103 0 249 0 104 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118 3 89 0 185] 
#[0 0 178 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 0 182 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 69 0 61 3 93 0 85 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118] 
#[0 3 97 0 25] 
#[1 0 109 0 10 0 113 0 11 0 186 0 17 0 117 0 23 0 121 0 32 0 125 0 46 0 129 0 47 0 133 0 50 0 137 0 53 0 141 0 61 3 101 0 119 0 145 0 122 0 149 0 123 0 153 0 124 0 157 0 125 0 161 0 126 0 165 0 127 0 169 0 128 0 173 0 129 0 177 0 131 0 181 0 132 0 185 0 133 0 189 0 134 0 193 0 135 0 197 0 136 0 201 0 139 0 205 0 145 0 209 0 146 0 213 0 147 0 217 0 169 0 221 0 170 0 225 0 171 3 105 0 186 0 233 0 191] 
#[0 3 109 0 17] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 3 113 0 182] 
#[0 3 117 0 17] 
#[1 3 121 0 61 3 125 0 155] 
#[0 0 190 0 18] 
#[1 1 229 0 5 0 90 0 9 1 237 0 14 0 90 0 15 0 90 0 18 0 90 0 19 0 90 0 31 0 90 0 33 0 90 0 34 0 90 0 35 0 90 0 36 0 90 0 37 0 90 0 38 0 90 0 39 0 90 0 40 0 90 0 41 0 90 0 42 0 90 0 43 0 90 0 44 0 90 0 45 0 90 0 48 0 90 0 49 0 90 0 51 0 90 0 59 1 245 0 73] 
#[0 3 129 0 18] 
#[0 0 194 0 14 0 17 0 25 0 46 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 194 0 14 0 17 0 25 0 46 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 190 0 18] 
#[0 0 198 0 14 0 17 0 25 0 46 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[1 1 17 0 14 3 133 0 17 1 21 0 25 2 169 0 46 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 2 173 0 125 1 81 0 128 1 85 0 137 2 177 0 139 0 205 0 145 0 209 0 146 0 213 0 147 2 181 0 152 2 185 0 153 2 189 0 156 2 193 0 157 3 137 0 158 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 2 205 0 182] 
#[1 0 190 0 18 3 141 0 49] 
#[1 3 121 0 61 3 145 0 155] 
#[0 0 202 0 14 0 17 0 25 0 47 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[1 1 17 0 14 3 149 0 17 1 21 0 25 2 209 0 47 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 2 173 0 125 1 81 0 128 1 85 0 137 2 177 0 139 0 205 0 145 0 209 0 146 0 213 0 147 3 153 0 150 2 181 0 152 2 221 0 153 2 225 0 154 2 193 0 157 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 2 205 0 182] 
#[0 0 206 0 14 0 17 0 25 0 47 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 0 206 0 14 0 17 0 25 0 47 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[1 0 109 0 10 0 113 0 11 0 117 0 23 0 121 0 32 0 125 0 46 0 129 0 47 0 133 0 50 0 137 0 53 0 141 0 61 0 145 0 122 0 149 0 123 0 153 0 124 0 157 0 125 0 161 0 126 0 165 0 127 0 169 0 128 0 173 0 129 0 177 0 131 0 181 0 132 0 185 0 133 0 189 0 134 0 193 0 135 0 197 0 136 0 201 0 139 0 205 0 145 0 209 0 146 0 213 0 147 0 217 0 169 0 221 0 170 0 225 0 171 3 157 0 186 0 233 0 191] 
#[0 3 161 0 24] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 0 141 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 3 165 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180] 
#[0 0 34 0 5 0 10 0 11 0 14 0 17 0 18 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 73 0 189] 
#[1 0 210 0 10 0 210 0 11 1 237 0 14 0 210 0 17 0 210 0 18 0 210 0 23 0 210 0 32 0 210 0 46 0 210 0 47 0 210 0 50 0 210 0 53 0 210 0 61 0 210 0 189] 
#[0 0 214 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 3 169 0 182] 
#[0 3 173 0 13] 
#[0 0 218 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 0 222 0 8 0 24 0 189] 
#[0 0 226 0 8 0 24 0 189] 
#[0 0 230 0 8 0 24 0 189] 
#[0 0 234 0 8 0 24 0 189] 
#[0 0 238 0 8 0 24 0 189] 
#[0 0 238 0 8 0 24 0 189] 
#[0 0 238 0 8 0 24 0 189] 
#[0 0 242 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 3 177 0 182] 
#[0 0 246 0 8 0 10 0 11 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[1 3 181 0 8 0 250 0 13 0 250 0 24 3 185 0 141] 
#[0 0 254 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 1 2 0 8 0 10 0 11 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[0 3 189 0 21] 
#[0 1 6 0 18 0 72] 
#[0 1 10 0 18 0 72] 
#[0 3 193 0 18] 
#[0 3 197 0 24] 
#[0 1 14 0 24] 
#[0 1 18 0 24] 
#[1 1 22 0 8 1 22 0 24 3 201 0 100] 
#[0 1 26 0 8 0 10 0 11 0 12 0 13 0 17 0 18 0 23 0 24 0 27 0 32 0 46 0 47 0 49 0 50 0 53 0 61 0 72 0 189] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 174 0 24 0 237 0 30 0 69 0 61 0 241 0 85 3 205 0 91 3 81 0 101 3 85 0 102 0 245 0 103 0 249 0 104 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118 3 89 0 185] 
#[0 1 30 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 34 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 38 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 3 209 0 27] 
#[0 1 42 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 3 213 0 9] 
#[0 1 46 0 14 0 17 0 25 0 46 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[1 0 109 0 10 0 113 0 11 0 117 0 23 0 121 0 32 0 125 0 46 0 129 0 47 0 133 0 50 0 137 0 53 0 141 0 61 0 145 0 122 0 149 0 123 0 153 0 124 0 157 0 125 0 161 0 126 0 165 0 127 0 169 0 128 0 173 0 129 0 177 0 131 0 181 0 132 0 185 0 133 0 189 0 134 0 193 0 135 0 197 0 136 0 201 0 139 0 205 0 145 0 209 0 146 0 213 0 147 0 217 0 169 0 221 0 170 0 225 0 171 3 217 0 186 0 233 0 191] 
#[0 1 50 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 1 54 0 14 0 17 0 25 0 46 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[1 2 241 0 61 3 221 0 125 3 225 0 139 0 205 0 145 0 209 0 146 0 213 0 147 0 217 0 169 0 221 0 170 0 225 0 171] 
#[0 1 58 0 14 0 17 0 25 0 47 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 1 62 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 1 66 0 14 0 17 0 25 0 47 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 3 229 0 17] 
#[0 1 70 0 8 0 9 0 10 0 11 0 13 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 53 0 59 0 61 0 72 0 189] 
#[0 1 74 0 10 0 11 0 17 0 18 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 3 233 0 27] 
#[0 1 78 0 5 0 7 0 8 0 9 0 10 0 11 0 13 0 14 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 59 0 61 0 72 0 73 0 74 0 189] 
#[0 3 237 0 72] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 3 241 0 182] 
#[0 1 82 0 8 0 13 0 24] 
#[0 3 245 0 75] 
#[1 1 86 0 2 1 86 0 4 1 86 0 6 1 86 0 14 1 86 0 16 1 86 0 17 1 86 0 20 1 86 0 26 1 86 0 28 1 86 0 30 1 86 0 61 3 249 0 110] 
#[1 1 90 0 3 1 90 0 18 1 90 0 21 3 253 0 94] 
#[1 4 1 0 8 1 94 0 24 4 5 0 99] 
#[0 4 9 0 24] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 4 13 0 182] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 4 17 0 182] 
#[0 4 21 0 17] 
#[0 1 98 0 18] 
#[1 1 229 0 5 1 237 0 14 1 245 0 73] 
#[0 1 102 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 4 25 0 182] 
#[0 1 106 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 1 110 0 8 0 13 0 24] 
#[1 1 114 0 29 4 29 0 84] 
#[1 1 118 0 2 1 118 0 4 1 118 0 6 1 118 0 14 4 33 0 16 1 118 0 17 1 118 0 20 1 118 0 26 1 118 0 28 1 118 0 30 1 118 0 61 4 37 0 76 4 41 0 130 4 45 0 149] 
#[1 4 49 0 3 0 166 0 18 0 170 0 21 3 61 0 82 4 53 0 92 4 57 0 93 3 65 0 97 3 69 0 181 4 61 0 192] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 237 0 30 0 69 0 61 0 241 0 85 0 245 0 103 0 249 0 104 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118 4 65 0 185] 
#[0 1 122 0 8 0 24] 
#[1 1 90 0 3 1 90 0 18 1 90 0 21 4 69 0 94] 
#[0 4 73 0 18] 
#[0 4 77 0 27] 
#[0 1 126 0 14 0 17 0 25 0 46 0 47 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 4 81 0 13] 
#[0 4 85 0 29] 
#[1 4 89 0 19 4 93 0 80 4 97 0 81] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 4 101 0 17 0 37 0 20 0 45 0 26 4 105 0 28 1 9 0 30 0 69 0 61 4 109 0 77 4 113 0 78 4 117 0 83 4 121 0 85 4 125 0 86 4 129 0 87 4 133 0 88 4 137 0 89 4 141 0 90 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118 4 145 0 183 4 149 0 184 4 153 0 187 4 157 0 188] 
#[0 1 130 0 2 0 4 0 6 0 14 0 16 0 17 0 20 0 26 0 28 0 30 0 61] 
#[0 1 134 0 2 0 4 0 6 0 14 0 16 0 17 0 20 0 26 0 28 0 30 0 61] 
#[1 4 161 0 61 4 165 0 109] 
#[0 1 138 0 3 0 18 0 21] 
#[0 1 142 0 3 0 18 0 21] 
#[0 4 169 0 18] 
#[0 1 146 0 8 0 24] 
#[1 4 49 0 3 0 166 0 18 0 170 0 21 3 61 0 82 4 53 0 92 4 57 0 93 3 65 0 97 3 69 0 181 4 173 0 192] 
#[1 0 109 0 10 0 113 0 11 0 117 0 23 0 121 0 32 0 125 0 46 0 129 0 47 0 133 0 50 0 137 0 53 0 141 0 61 0 145 0 122 0 149 0 123 0 153 0 124 0 157 0 125 0 161 0 126 0 165 0 127 0 169 0 128 0 173 0 129 0 177 0 131 0 181 0 132 0 185 0 133 0 189 0 134 0 193 0 135 0 197 0 136 0 201 0 139 0 205 0 145 0 209 0 146 0 213 0 147 0 217 0 169 0 221 0 170 0 225 0 171 4 177 0 186 0 233 0 191] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 1 81 0 128 1 85 0 137 1 89 0 139 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 4 181 0 182] 
#[0 1 150 0 5 0 7 0 8 0 9 0 10 0 11 0 13 0 14 0 15 0 17 0 18 0 19 0 23 0 24 0 27 0 31 0 32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 0 41 0 42 0 43 0 44 0 45 0 46 0 47 0 48 0 49 0 50 0 51 0 52 0 53 0 59 0 61 0 72 0 73 0 74 0 189] 
#[0 1 154 0 18 0 72] 
#[0 4 185 0 61] 
#[0 1 158 0 19 0 72] 
#[1 4 89 0 19 4 189 0 72 4 193 0 80] 
#[0 4 197 0 72] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 4 201 0 26 4 205 0 30 0 69 0 61 4 209 0 85 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118] 
#[0 1 162 0 2 0 4 0 6 0 14 0 17 0 20 0 26 0 28 0 30 0 61] 
#[0 1 166 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 170 0 2 0 4 0 6 0 14 0 17 0 20 0 26 0 28 0 30 0 61] 
#[1 1 185 0 12 2 5 0 61] 
#[0 1 166 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 174 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 174 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 174 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 166 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 166 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 166 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 178 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 178 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[1 1 182 0 8 1 182 0 72 4 213 0 111] 
#[0 4 217 0 72] 
#[1 1 186 0 2 1 186 0 4 1 186 0 6 1 186 0 10 1 186 0 11 1 186 0 14 1 186 0 20 1 186 0 23 1 186 0 26 1 186 0 28 1 186 0 30 1 186 0 32 1 186 0 46 1 186 0 47 1 186 0 50 1 186 0 53 1 186 0 61 4 221 0 96] 
#[0 4 225 0 18] 
#[0 4 229 0 17] 
#[0 4 233 0 18] 
#[0 1 190 0 19 0 72] 
#[0 1 194 0 2 0 4 0 6 0 14 0 16 0 17 0 20 0 26 0 28 0 30 0 61] 
#[0 1 198 0 19 0 72] 
#[0 1 202 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 4 237 0 61] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 69 0 61 4 241 0 85 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118] 
#[0 4 245 0 12] 
#[1 4 249 0 8 1 206 0 72 4 253 0 148] 
#[0 1 210 0 3 0 18 0 21] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 109 0 10 0 113 0 11 0 65 0 14 0 37 0 20 0 117 0 23 0 45 0 26 4 105 0 28 1 9 0 30 0 121 0 32 0 125 0 46 0 129 0 47 0 133 0 50 0 137 0 53 5 1 0 61 5 5 0 77 4 113 0 78 4 121 0 85 4 125 0 86 4 129 0 87 4 133 0 88 4 137 0 89 4 141 0 90 5 9 0 95 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118 0 145 0 122 0 149 0 123 0 153 0 124 0 157 0 125 0 161 0 126 0 165 0 127 0 169 0 128 0 173 0 129 0 177 0 131 0 181 0 132 0 185 0 133 0 189 0 134 0 193 0 135 0 197 0 136 0 201 0 139 0 205 0 145 0 209 0 146 0 213 0 147 0 217 0 169 0 221 0 170 0 225 0 171 4 145 0 183 4 149 0 184 5 13 0 186 4 153 0 187 4 157 0 188 0 233 0 191] 
#[1 1 186 0 2 1 186 0 4 1 186 0 6 1 186 0 10 1 186 0 11 1 186 0 14 1 186 0 17 1 186 0 20 1 186 0 23 1 186 0 26 1 186 0 28 1 186 0 30 1 186 0 32 1 186 0 46 1 186 0 47 1 186 0 50 1 186 0 53 1 186 0 61 5 17 0 96] 
#[0 1 214 0 10 0 11 0 17 0 23 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[1 1 17 0 14 1 21 0 25 1 25 0 54 1 29 0 55 1 33 0 56 1 37 0 57 1 41 0 59 1 45 0 60 1 49 0 61 1 53 0 62 1 57 0 63 1 61 0 64 1 65 0 65 1 69 0 66 1 73 0 67 1 77 0 68 2 173 0 125 1 81 0 128 1 85 0 137 2 177 0 139 0 205 0 145 0 209 0 146 0 213 0 147 2 181 0 152 5 21 0 153 2 193 0 157 1 93 0 160 1 97 0 161 1 101 0 162 1 105 0 163 1 109 0 164 1 113 0 165 1 117 0 166 1 121 0 167 1 125 0 168 0 217 0 169 0 221 0 170 0 225 0 171 1 129 0 172 1 133 0 174 1 137 0 175 1 141 0 176 1 145 0 177 1 149 0 178 1 153 0 179 1 157 0 180 2 205 0 182] 
#[0 5 25 0 25] 
#[0 5 29 0 61] 
#[0 5 33 0 61] 
#[0 5 37 0 61] 
#[0 1 218 0 8 0 72] 
#[1 0 34 0 5 0 34 0 7 0 14 0 12 0 34 0 14 1 225 0 25 0 34 0 52 0 14 0 61 0 34 0 73 0 34 0 74] 
#[0 1 222 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 1 226 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 5 41 0 17] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 109 0 10 0 113 0 11 0 65 0 14 1 230 0 17 0 37 0 20 0 117 0 23 0 45 0 26 4 105 0 28 1 9 0 30 0 121 0 32 0 125 0 46 0 129 0 47 0 133 0 50 0 137 0 53 5 1 0 61 5 5 0 77 4 113 0 78 4 121 0 85 4 125 0 86 4 129 0 87 4 133 0 88 4 137 0 89 4 141 0 90 5 9 0 95 5 45 0 98 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118 0 145 0 122 0 149 0 123 0 153 0 124 0 157 0 125 0 161 0 126 0 165 0 127 0 169 0 128 0 173 0 129 0 177 0 131 0 181 0 132 0 185 0 133 0 189 0 134 0 193 0 135 0 197 0 136 0 201 0 139 0 205 0 145 0 209 0 146 0 213 0 147 0 217 0 169 0 221 0 170 0 225 0 171 4 145 0 183 4 149 0 184 5 49 0 186 4 153 0 187 4 157 0 188 0 233 0 191 5 53 0 193] 
#[0 5 57 0 17] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 174 0 24 0 237 0 30 0 69 0 61 0 241 0 85 5 61 0 91 3 81 0 101 3 85 0 102 0 245 0 103 0 249 0 104 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118 3 89 0 185] 
#[1 0 170 0 21 0 166 0 72 3 61 0 82 3 65 0 97 3 69 0 181 5 65 0 192] 
#[0 5 69 0 25] 
#[0 1 234 0 8 0 72] 
#[0 5 73 0 72] 
#[0 5 77 0 17] 
#[0 1 238 0 17] 
#[0 1 242 0 17] 
#[0 1 246 0 14 0 17 0 25 0 46 0 47 0 54 0 55 0 56 0 57 0 59 0 60 0 61 0 62 0 63 0 64 0 65 0 66 0 67 0 68] 
#[0 5 81 0 24] 
#[0 5 85 0 72] 
#[1 0 53 0 2 0 57 0 4 0 61 0 6 0 65 0 14 0 174 0 24 0 237 0 30 0 69 0 61 0 241 0 85 5 89 0 91 3 81 0 101 3 85 0 102 0 245 0 103 0 249 0 104 0 77 0 112 0 81 0 113 0 85 0 114 0 89 0 115 0 93 0 116 0 97 0 117 0 101 0 118 3 89 0 185] 
#[0 1 250 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 5 93 0 72] 
#[1 0 170 0 21 0 166 0 72 3 61 0 82 3 65 0 97 3 69 0 181 5 97 0 192] 
#[0 1 254 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 5 101 0 24] 
#[0 2 2 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61 0 189] 
#[0 5 105 0 72] 
#[1 0 170 0 21 0 166 0 72 3 61 0 82 3 65 0 97 3 69 0 181 5 109 0 192] 
#[0 2 6 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61] 
#[0 5 113 0 72] 
#[0 2 10 0 2 0 4 0 6 0 10 0 11 0 14 0 17 0 20 0 23 0 26 0 28 0 30 0 32 0 46 0 47 0 50 0 53 0 61]
	).
]
