Class {
	#name : #CppTemplateType,
	#superclass : #Object,
	#instVars : [
		'name',
		'type'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppTemplateType >> name: aString [
	name := aString
]

{ #category : #streaming }
CppTemplateType >> streamOn: aWriteStream [

	aWriteStream put: name; put:'< '.
	type streamOn: aWriteStream.
	aWriteStream put: ' >'
]

{ #category : #accessing }
CppTemplateType >> type: aCppType [

	type := aCppType
]
