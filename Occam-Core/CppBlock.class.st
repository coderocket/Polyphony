Class {
	#name : #CppBlock,
	#superclass : #CppStatement,
	#instVars : [
		'stmt'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppBlock >> stmt: aCppStatement [
	stmt := aCppStatement
]

{ #category : #streaming }
CppBlock >> streamOn: aWriteStream [

	aWriteStream put: '{' ; open.
	
	stmt streamOn: aWriteStream.
	
	aWriteStream close; put: '}'.

]
