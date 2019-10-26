Class {
	#name : #CppWhile,
	#superclass : #CppStatement,
	#instVars : [
		'test',
		'body'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppWhile >> body: aCppStatement [
	body := aCppStatement
]

{ #category : #streaming }
CppWhile >> streamOn: aWriteStream [

	aWriteStream put: 'while'.
	aWriteStream put: '('.
	test streamOn: aWriteStream.
	aWriteStream put: ')'.
	aWriteStream put:'{' ; open.
	body streamOn: aWriteStream.
	aWriteStream close ; put:'}'.

]

{ #category : #accessing }
CppWhile >> test: aCppExpression [
	test := aCppExpression
]
