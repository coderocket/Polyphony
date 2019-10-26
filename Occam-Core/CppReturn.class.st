Class {
	#name : #CppReturn,
	#superclass : #CppStatement,
	#instVars : [
		'result'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppReturn >> result: aCppExpr [

	result := aCppExpr
	
]

{ #category : #accessing }
CppReturn >> streamOn: aWriteStream [

	aWriteStream put:'return '.
	result streamOn: aWriteStream.
	aWriteStream put: ';'; newLine.
]
