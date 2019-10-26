Class {
	#name : #CppInput,
	#superclass : #CppStatement,
	#instVars : [
		'channel',
		'lvalue'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #converting }
CppInput >> asSequence [ 
	
	^CppSequence new add:self
	
]

{ #category : #accessing }
CppInput >> channel [
	^channel
]

{ #category : #accessing }
CppInput >> channel: aCppExpr [

	channel := aCppExpr
]

{ #category : #accessing }
CppInput >> input [
	^self

]

{ #category : #accessing }
CppInput >> lvalue: aCppLvalue [

	lvalue := aCppLvalue
]

{ #category : #streaming }
CppInput >> streamOn: aWriteStream [

	lvalue streamOn: aWriteStream.
	
	aWriteStream put: ' = '.
	
	channel streamOn: aWriteStream.
	
	aWriteStream put: '.read()'
]

{ #category : #tests }
CppInput >> test [
	^CppMemberFunctionCall new name:'is_data_ready' ; expr: channel
	
]
