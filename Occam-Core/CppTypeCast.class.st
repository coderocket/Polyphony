Class {
	#name : #CppTypeCast,
	#superclass : #CppExpression,
	#instVars : [
		'operand',
		'type'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppTypeCast >> operand: aCppExpression [

	operand := aCppExpression
	
]

{ #category : #streaming }
CppTypeCast >> streamOn: aWriteStream [

	aWriteStream put: '('.
	aWriteStream put: '('. 
	type streamOn: aWriteStream.
	aWriteStream put: ')'.
	operand streamOn: aWriteStream.
	aWriteStream put: ')'
]

{ #category : #accessing }
CppTypeCast >> type: aCppBasicType [

	type := aCppBasicType
	
]
