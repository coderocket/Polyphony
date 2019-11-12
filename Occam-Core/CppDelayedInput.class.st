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
CppDelayedInput >> input [
	^CppSequence new
]

{ #category : #accessing }
CppDelayedInput >> streamOn: aWriteStream [

	timer streamOn: aWriteStream.
	aWriteStream put:'.wait_until('.
	duration streamOn: aWriteStream.
	aWriteStream put:')'.
 
]

{ #category : #'as yet unclassified' }
CppDelayedInput >> test [
	^CppMemberFunctionCall new name:'is_after' ; expr: timer ; addArgument: duration.

]

{ #category : #accessing }
CppDelayedInput >> timer: aCppExpr [
	timer := aCppExpr

]
