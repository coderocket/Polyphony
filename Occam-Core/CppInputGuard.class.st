Class {
	#name : #CppInputGuard,
	#superclass : #Object,
	#instVars : [
		'test',
		'input'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppInputGuard >> command [ 
	input ifNil:[^CppSequence new].
	
	^input
]

{ #category : #private }
CppInputGuard >> expr [

	input ifNil:[^test].
	
	test ifNil:[^CppMemberFunctionCall new name: 'is_data_ready' ; expr: input channel].
	
	^CppBinaryExpression new operator: '&&'; left: test ; right: 
			(CppMemberFunctionCall new name: 'is_data_ready' ; expr: input channel) 
]

{ #category : #accessing }
CppInputGuard >> input [
	^input

]

{ #category : #accessing }
CppInputGuard >> input: aCppInput [

	input := aCppInput
]

{ #category : #streaming }
CppInputGuard >> streamOn: aWriteStream [

	test ifNotNil:[test streamOn: aWriteStream].
	
	input ifNil:[^self].
	
	test ifNotNil:[aWriteStream put: ' && '].
	
	input channel streamOn: aWriteStream.
	
	aWriteStream put: '.is_data_ready()'
]

{ #category : #accessing }
CppInputGuard >> test [
	^CppBinaryExpression new left: test ; operator: ' && '; right: input test
	

]

{ #category : #accessing }
CppInputGuard >> test: aCppExpr [

	test := aCppExpr
]
