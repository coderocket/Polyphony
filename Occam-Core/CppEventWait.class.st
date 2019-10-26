Class {
	#name : #CppEventWait,
	#superclass : #CppStatement,
	#instVars : [
		'event'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #streaming }
CppEventWait >> event: aCppExpr [
	event := aCppExpr
]

{ #category : #'as yet unclassified' }
CppEventWait >> input [
	^CppSequence new
]

{ #category : #streaming }
CppEventWait >> streamOn: aWriteStream. [

	event streamOn: aWriteStream.
	
	aWriteStream put: '.wait()'
]

{ #category : #tests }
CppEventWait >> test [
	^CppMemberFunctionCall new name:'is_data_ready' ; expr: event

]
