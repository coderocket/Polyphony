Class {
	#name : #CppDelayedInput,
	#superclass : #CppStatement,
	#instVars : [
		'timer',
		'duration'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #converting }
CppDelayedInput >> asSequence [ 
	
	^CppSequence new add:self

]

{ #category : #accessing }
CppDelayedInput >> duration: aCppExpr [
	duration := aCppExpr

]

{ #category : #'as yet unclassified' }
CppDelayedInput >> negate [

	^CppUnaryExpression new operator: '!' ; operand: (CppCall new name:'after'; addArgument: (CppCall new name: 'millis') ; addArgument: duration)
	
]

{ #category : #'as yet unclassified' }
CppDelayedInput >> promoteToInputGuard [

	^CppInputGuard new test: (CppCall new name:'after'; addArgument: (CppCall new name: 'millis') ; addArgument: duration) ; input: nil
	
]

{ #category : #accessing }
CppDelayedInput >> streamOn: aWriteStream [

	timer streamOn: aWriteStream.
	aWriteStream put:'.wait_until('.
	duration streamOn: aWriteStream.
	aWriteStream put:')'.
 
]

{ #category : #accessing }
CppDelayedInput >> timer: aCppExpr [
	timer := aCppExpr

]
