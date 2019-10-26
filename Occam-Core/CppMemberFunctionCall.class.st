Class {
	#name : #CppMemberFunctionCall,
	#superclass : #CppCall,
	#instVars : [
		'expr'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppMemberFunctionCall >> expr: aCppExpr [
	expr := aCppExpr
]

{ #category : #streaming }
CppMemberFunctionCall >> streamOn: aWriteStream [

	expr streamOn: aWriteStream.
	aWriteStream put:'.'. 
	super streamOn: aWriteStream.
]
