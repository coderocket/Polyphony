Class {
	#name : #CppArrayType,
	#superclass : #Object,
	#instVars : [
		'size',
		'type'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppArrayType >> size: aCppExpression [
	size := aCppExpression
]

{ #category : #streaming }
CppArrayType >> streamOn: aWriteStream [

	aWriteStream put: 'array_t< '.
	type streamOn: aWriteStream.
	aWriteStream put: ', '.
	size streamOn: aWriteStream.
	aWriteStream put: ' > '.
	
	

]

{ #category : #accessing }
CppArrayType >> type: aCppType [

	type := aCppType
	
]
