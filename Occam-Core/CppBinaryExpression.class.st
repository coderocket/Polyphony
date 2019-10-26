Class {
	#name : #CppBinaryExpression,
	#superclass : #CppExpression,
	#instVars : [
		'left',
		'operator',
		'right'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppBinaryExpression >> left: aCppExpression [
	left := aCppExpression
	
]

{ #category : #accessing }
CppBinaryExpression >> operator: aString [
	operator := aString
]

{ #category : #accessing }
CppBinaryExpression >> right: aCppExpression [
	right := aCppExpression
	
]

{ #category : #streaming }
CppBinaryExpression >> streamOn: aWriteStream [

	aWriteStream put:'('. 
	left streamOn: aWriteStream. 
	aWriteStream put:' '; put: operator; put: ' '. 
	right streamOn: aWriteStream.
	aWriteStream put:')'.
]
