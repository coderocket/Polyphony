Class {
	#name : #ASTDirOut,
	#superclass : #ASTDirection,
	#instVars : [
		'bangToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTDirOut >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitDirOut: self
]

{ #category : #'process graph' }
ASTDirOut >> addTo: aSet ifOutput: anASTVariable [

	aSet add:anASTVariable 

]

{ #category : #generated }
ASTDirOut >> bangToken [
	^ bangToken
]

{ #category : #generated }
ASTDirOut >> bangToken: aSmaCCToken [
	bangToken := aSmaCCToken
]

{ #category : #streaming }
ASTDirOut >> streamOn: aWriteStream [

	aWriteStream put:'!'
]

{ #category : #accessing }
ASTDirOut >> title [ 	
	^'!'
]

{ #category : #generated }
ASTDirOut >> tokenVariables [
	^ #(#bangToken)
]
