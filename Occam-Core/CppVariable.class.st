Class {
	#name : #CppVariable,
	#superclass : #CppExpression,
	#instVars : [
		'name'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppVariable >> name: aString [
	name := aString
]

{ #category : #private }
CppVariable >> negate [ 

	^CppUnaryExpression new operator: '!' ; operand: self
]

{ #category : #streaming }
CppVariable >> streamOn: aWriteStream [

	aWriteStream put: name
]
