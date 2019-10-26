Class {
	#name : #CppCall,
	#superclass : #CppExpression,
	#instVars : [
		'callee',
		'args'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #adding }
CppCall >> addArgument: aCppExpression [
	args add: aCppExpression
]

{ #category : #adding }
CppCall >> callee: aCppExpression [
	callee := aCppExpression
]

{ #category : #initialization }
CppCall >> initialize [
	args := OrderedCollection new
]

{ #category : #adding }
CppCall >> name: aString [
	callee := CppVariable new name: aString
]

{ #category : #streaming }
CppCall >> streamOn: aWriteStream [

	callee streamOn: aWriteStream.
	aWriteStream put: '('.
	args do:[:each | each streamOn: aWriteStream] separatedBy: [ aWriteStream put:', ' ].
	aWriteStream put: ')'.
]
