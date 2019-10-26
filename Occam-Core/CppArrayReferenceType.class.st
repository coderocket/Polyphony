Class {
	#name : #CppArrayReferenceType,
	#superclass : #Object,
	#instVars : [
		'type'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #streaming }
CppArrayReferenceType >> streamOn: aWriteStream [

	aWriteStream put: 'array_base_t< '.
	type streamOn: aWriteStream.
	aWriteStream put: ' > '.

	

]

{ #category : #accessing }
CppArrayReferenceType >> type: aCppType [
	type := aCppType

]
