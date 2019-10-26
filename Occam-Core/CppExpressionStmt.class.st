Class {
	#name : #CppExpressionStmt,
	#superclass : #CppStatement,
	#instVars : [
		'expr'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppExpressionStmt >> expr: aCppExpression [

	expr := aCppExpression
]

{ #category : #accessing }
CppExpressionStmt >> streamOn: aWriteStream [

	expr streamOn: aWriteStream.
	
	aWriteStream put:';'; newLine
]
