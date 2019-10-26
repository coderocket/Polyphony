Class {
	#name : #CppUnaryExpression,
	#superclass : #CppExpression,
	#instVars : [
		'operand',
		'operator'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppUnaryExpression >> operand: aCppExpression [
	operand := aCppExpression 
]

{ #category : #accessing }
CppUnaryExpression >> operator: aString [
	operator := aString
]

{ #category : #streaming }
CppUnaryExpression >> streamOn: aWriteStream [

	aWriteStream put: operator. 
	operand streamOn: aWriteStream. 

]
