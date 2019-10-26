Class {
	#name : #CppAssignment,
	#superclass : #CppStatement,
	#instVars : [
		'lvalue',
		'rvalue'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #converting }
CppAssignment >> asSequence [ 
	
	^CppSequence new add:self
	
]

{ #category : #accessing }
CppAssignment >> lvalue: aCppLValue [
	lvalue := aCppLValue
]

{ #category : #accessing }
CppAssignment >> rvalue: aCppExpression [
	rvalue := aCppExpression
]

{ #category : #streaming }
CppAssignment >> streamOn: aWriteStream [

	lvalue streamOn: aWriteStream. aWriteStream put:' = '. rvalue streamOn: aWriteStream.
]
