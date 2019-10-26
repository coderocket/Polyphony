Class {
	#name : #CppParameter,
	#superclass : #Object,
	#instVars : [
		'type',
		'name'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #public }
CppParameter >> decoration [
	^' '
]

{ #category : #accessing }
CppParameter >> name: aString [
	name := aString
]

{ #category : #public }
CppParameter >> prologue [
	^''
]

{ #category : #streaming }
CppParameter >> streamOn: aWriteStream [

	aWriteStream put: self prologue.
	
	type streamOn: aWriteStream.
	
	aWriteStream put: self decoration.
	
	aWriteStream put: name.
]

{ #category : #accessing }
CppParameter >> type: aCppType [
	type := aCppType
]
