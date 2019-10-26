Class {
	#name : #CppArrayComponent,
	#superclass : #CppExpression,
	#instVars : [
		'index',
		'array'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #streaming }
CppArrayComponent >> array: aCppExpr [

	array := aCppExpr
]

{ #category : #streaming }
CppArrayComponent >> index: aCppExpr [

	index := aCppExpr
]

{ #category : #streaming }
CppArrayComponent >> streamOn: aWriteStream [

	array streamOn: aWriteStream.
	aWriteStream put:'.at('.
	index streamOn: aWriteStream. 
	aWriteStream put:')'.
]
