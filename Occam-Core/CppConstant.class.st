Class {
	#name : #CppConstant,
	#superclass : #Object,
	#instVars : [
		'definition'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppConstant >> definition: aCppDefinition [
	definition := aCppDefinition 
]

{ #category : #accessing }
CppConstant >> streamOn: aWriteStream [

	aWriteStream put: 'const '.
	definition streamOn: aWriteStream.

]
