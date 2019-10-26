Class {
	#name : #CppGuardedCommand,
	#superclass : #Object,
	#instVars : [
		'guard',
		'stmt'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #tests }
CppGuardedCommand >> command [ 
	^CppIf new test: (CppBinaryExpression new left: guard test; operator: ' && '; right: (CppUnaryExpression new operator: '!' ; operand: (CppVariable new name:'data_taken') )); stmt: (CppSequence new add: guard input ; add: stmt ; add: (CppAssignment new lvalue:(CppVariable new name:'data_taken'); rvalue: (CppLiteral new value:'true')))
]

{ #category : #accessing }
CppGuardedCommand >> guard: aCppExpr [
	guard := aCppExpr
	
]

{ #category : #accessing }
CppGuardedCommand >> stmt: aCppStmt [
	stmt := aCppStmt

]

{ #category : #tests }
CppGuardedCommand >> test [
	^CppAssignment new lvalue: (CppVariable new name:'data_ready') ; rvalue: 
		(CppBinaryExpression new left: (CppVariable new name:'data_ready') ; operator: '||'; right: guard test )
]
