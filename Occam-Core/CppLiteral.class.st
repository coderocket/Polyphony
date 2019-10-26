Class {
	#name : #CppLiteral,
	#superclass : #CppExpression,
	#instVars : [
		'value'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppLiteral >> input [
	^CppSequence new
]

{ #category : #streaming }
CppLiteral >> streamOn: aWriteStream [

	aWriteStream put: value asString
]

{ #category : #accessing }
CppLiteral >> test [
	^self

]

{ #category : #accessing }
CppLiteral >> value: aString [
	value := aString
]
