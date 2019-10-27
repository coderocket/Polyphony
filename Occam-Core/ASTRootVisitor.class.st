Class {
	#name : #ASTRootVisitor,
	#superclass : #SmaCCParseNodeVisitor,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTRootVisitor >> visitAbbreviation: anAbbreviation [
	^ self visitRoot: anAbbreviation
]

{ #category : #generated }
ASTRootVisitor >> visitAbstraction: anAbstraction [
	^ self visitScope: anAbstraction
]

{ #category : #generated }
ASTRootVisitor >> visitAlt: anAlt [
	^ self visitProcess: anAlt
]

{ #category : #generated }
ASTRootVisitor >> visitArrayComponent: anArrayComponent [
	^ self visitRoot: anArrayComponent
]

{ #category : #generated }
ASTRootVisitor >> visitArrayReferenceType: anArrayReferenceType [
	^ self visitRoot: anArrayReferenceType
]

{ #category : #generated }
ASTRootVisitor >> visitArraySegment: anArraySegment [
	^ self visitRoot: anArraySegment
]

{ #category : #generated }
ASTRootVisitor >> visitArrayType: anArrayType [
	^ self visitType: anArrayType
]

{ #category : #generated }
ASTRootVisitor >> visitAssign: anAssign [
	^ self visitProcess: anAssign
]

{ #category : #generated }
ASTRootVisitor >> visitBasicType: aBasicType [
	^ self visitType: aBasicType
]

{ #category : #generated }
ASTRootVisitor >> visitBytesIn: aBytesIn [
	^ self visitRoot: aBytesIn
]

{ #category : #generated }
ASTRootVisitor >> visitCall: aCall [
	^ self visitProcess: aCall
]

{ #category : #generated }
ASTRootVisitor >> visitChannelType: aChannelType [
	^ self visitInputSourceType: aChannelType
]

{ #category : #generated }
ASTRootVisitor >> visitConversion: aConversion [
	^ self visitRoot: aConversion
]

{ #category : #generated }
ASTRootVisitor >> visitDataType: aDataType [
	^ self visitRoot: aDataType
]

{ #category : #generated }
ASTRootVisitor >> visitDelayedInput: aDelayedInput [
	^ self visitInput: aDelayedInput
]

{ #category : #generated }
ASTRootVisitor >> visitDirIn: aDirIn [
	^ self visitDirection: aDirIn
]

{ #category : #generated }
ASTRootVisitor >> visitDirNone: aDirNone [
	^ self visitDirection: aDirNone
]

{ #category : #generated }
ASTRootVisitor >> visitDirOut: aDirOut [
	^ self visitDirection: aDirOut
]

{ #category : #generated }
ASTRootVisitor >> visitDirection: aDirection [
	^ self visitRoot: aDirection
]

{ #category : #generated }
ASTRootVisitor >> visitDoc: aDoc [
	^ self visitRoot: aDoc
]

{ #category : #generated }
ASTRootVisitor >> visitDyadicExpression: aDyadicExpression [
	^ self visitExpression: aDyadicExpression
]

{ #category : #generated }
ASTRootVisitor >> visitEventSignal: anEventSignal [
	^ self visitRoot: anEventSignal
]

{ #category : #generated }
ASTRootVisitor >> visitEventType: anEventType [
	^ self visitRoot: anEventType
]

{ #category : #generated }
ASTRootVisitor >> visitEventWait: anEventWait [
	^ self visitRoot: anEventWait
]

{ #category : #generated }
ASTRootVisitor >> visitExpression: anExpression [
	^ self visitRoot: anExpression
]

{ #category : #generated }
ASTRootVisitor >> visitExternalAbbreviation: anExternalAbbreviation [
	^ self visitRoot: anExternalAbbreviation
]

{ #category : #generated }
ASTRootVisitor >> visitExternalFunction: anExternalFunction [
	^ self visitFunctionLike: anExternalFunction
]

{ #category : #generated }
ASTRootVisitor >> visitExternalProcedure: anExternalProcedure [
	^ self visitProcedureLike: anExternalProcedure
]

{ #category : #generated }
ASTRootVisitor >> visitFunction: aFunction [
	^ self visitFunctionLike: aFunction
]

{ #category : #generated }
ASTRootVisitor >> visitFunctionLike: aFunctionLike [
	^ self visitAbstraction: aFunctionLike
]

{ #category : #generated }
ASTRootVisitor >> visitGuardedCommand: aGuardedCommand [
	^ self visitRoot: aGuardedCommand
]

{ #category : #generated }
ASTRootVisitor >> visitIf: anIf [
	^ self visitProcess: anIf
]

{ #category : #generated }
ASTRootVisitor >> visitImmediateInput: anImmediateInput [
	^ self visitInput: anImmediateInput
]

{ #category : #generated }
ASTRootVisitor >> visitInput: anInput [
	^ self visitProcess: anInput
]

{ #category : #generated }
ASTRootVisitor >> visitInputGuard: anInputGuard [
	^ self visitRoot: anInputGuard
]

{ #category : #generated }
ASTRootVisitor >> visitInputSourceType: anInputSourceType [
	^ self visitType: anInputSourceType
]

{ #category : #generated }
ASTRootVisitor >> visitLValue: aLValue [
	^ self visitOperand: aLValue
]

{ #category : #generated }
ASTRootVisitor >> visitLibrary: aLibrary [
	^ self visitScope: aLibrary
]

{ #category : #generated }
ASTRootVisitor >> visitLiteral: aLiteral [
	^ self visitOperand: aLiteral
]

{ #category : #generated }
ASTRootVisitor >> visitLiteralBoolean: aLiteralBoolean [
	^ self visitRoot: aLiteralBoolean
]

{ #category : #generated }
ASTRootVisitor >> visitLiteralByte: aLiteralByte [
	^ self visitRoot: aLiteralByte
]

{ #category : #generated }
ASTRootVisitor >> visitLiteralHexInteger: aLiteralHexInteger [
	^ self visitRoot: aLiteralHexInteger
]

{ #category : #generated }
ASTRootVisitor >> visitLiteralInteger: aLiteralInteger [
	^ self visitRoot: aLiteralInteger
]

{ #category : #generated }
ASTRootVisitor >> visitLiteralReal64: aLiteralReal64 [
	^ self visitRoot: aLiteralReal64
]

{ #category : #generated }
ASTRootVisitor >> visitLiteralReal: aLiteralReal [
	^ self visitRoot: aLiteralReal
]

{ #category : #generated }
ASTRootVisitor >> visitLiteralString: aLiteralString [
	^ self visitRoot: aLiteralString
]

{ #category : #generated }
ASTRootVisitor >> visitMonadicExpression: aMonadicExpression [
	^ self visitExpression: aMonadicExpression
]

{ #category : #generated }
ASTRootVisitor >> visitOperand: anOperand [
	^ self visitExpression: anOperand
]

{ #category : #generated }
ASTRootVisitor >> visitOutput: anOutput [
	^ self visitProcess: anOutput
]

{ #category : #generated }
ASTRootVisitor >> visitPar: aPar [
	^ self visitProcess: aPar
]

{ #category : #generated }
ASTRootVisitor >> visitParameter: aParameter [
	^ self visitRoot: aParameter
]

{ #category : #generated }
ASTRootVisitor >> visitParenthesisExpression: aParenthesisExpression [
	^ self visitRoot: aParenthesisExpression
]

{ #category : #generated }
ASTRootVisitor >> visitProcedure: aProcedure [
	^ self visitProcedureLike: aProcedure
]

{ #category : #generated }
ASTRootVisitor >> visitProcedureLike: aProcedureLike [
	^ self visitAbstraction: aProcedureLike
]

{ #category : #generated }
ASTRootVisitor >> visitProcess: aProcess [
	^ self visitRoot: aProcess
]

{ #category : #generated }
ASTRootVisitor >> visitReferenceParameter: aReferenceParameter [
	^ self visitParameter: aReferenceParameter
]

{ #category : #generated }
ASTRootVisitor >> visitReplicatedAltGuardedCommand: aReplicatedAltGuardedCommand [
	^ self visitReplicatedGuardedCommand: aReplicatedAltGuardedCommand
]

{ #category : #generated }
ASTRootVisitor >> visitReplicatedGuardedCommand: aReplicatedGuardedCommand [
	^ self visitRoot: aReplicatedGuardedCommand
]

{ #category : #generated }
ASTRootVisitor >> visitReplicatedIfGuardedCommand: aReplicatedIfGuardedCommand [
	^ self visitReplicatedGuardedCommand: aReplicatedIfGuardedCommand
]

{ #category : #generated }
ASTRootVisitor >> visitReplicatedPar: aReplicatedPar [
	^ self visitRoot: aReplicatedPar
]

{ #category : #generated }
ASTRootVisitor >> visitReplicatedProcess: aReplicatedProcess [
	^ self visitRoot: aReplicatedProcess
]

{ #category : #generated }
ASTRootVisitor >> visitReplicatedSeq: aReplicatedSeq [
	^ self visitRoot: aReplicatedSeq
]

{ #category : #generated }
ASTRootVisitor >> visitResult: aResult [
	^ self visitRoot: aResult
]

{ #category : #generated }
ASTRootVisitor >> visitRoot: aRoot [
	^ self visitSmaCCParseNode: aRoot
]

{ #category : #generated }
ASTRootVisitor >> visitScope: aScope [
	^ self visitRoot: aScope
]

{ #category : #generated }
ASTRootVisitor >> visitSeq: aSeq [
	^ self visitProcess: aSeq
]

{ #category : #generated }
ASTRootVisitor >> visitSkip: aSkip [
	^ self visitProcess: aSkip
]

{ #category : #generated }
ASTRootVisitor >> visitStop: aStop [
	^ self visitRoot: aStop
]

{ #category : #generated }
ASTRootVisitor >> visitTable: aTable [
	^ self visitRoot: aTable
]

{ #category : #generated }
ASTRootVisitor >> visitTimerType: aTimerType [
	^ self visitInputSourceType: aTimerType
]

{ #category : #generated }
ASTRootVisitor >> visitType: aType [
	^ self visitRoot: aType
]

{ #category : #generated }
ASTRootVisitor >> visitUse: anUse [
	^ self visitRoot: anUse
]

{ #category : #generated }
ASTRootVisitor >> visitValueParameter: aValueParameter [
	^ self visitParameter: aValueParameter
]

{ #category : #generated }
ASTRootVisitor >> visitVariable: aVariable [
	^ self visitRoot: aVariable
]

{ #category : #generated }
ASTRootVisitor >> visitWhile: aWhile [
	^ self visitProcess: aWhile
]
