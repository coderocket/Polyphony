Class {
	#name : #CppLambda,
	#superclass : #CppExpression,
	#instVars : [
		'params',
		'body',
		'locals'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #adding }
CppLambda >> addLocal: aString [
	locals add: aString
]

{ #category : #adding }
CppLambda >> addParameter: aCppParameter [
	params add: aCppParameter
]

{ #category : #accessing }
CppLambda >> body: aCppStatement [
	body := aCppStatement
]

{ #category : #initialization }
CppLambda >> initialize [
	params := OrderedCollection new.
	locals := OrderedCollection new.

]

{ #category : #streaming }
CppLambda >> streamOn: aWriteStream [

	aWriteStream put:'[ & ] '; put:'('.
	params do:[:each | each streamOn: aWriteStream] separatedBy:[aWriteStream put:', '].
	aWriteStream put:') {'; open.
	locals do:[:each | each streamOn:aWriteStream ].
	aWriteStream newLine.
	body streamOn: aWriteStream.
	aWriteStream close; put: '}'.
]
