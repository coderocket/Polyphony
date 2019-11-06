Class {
	#name : #ASTDirIn,
	#superclass : #ASTDirection,
	#instVars : [
		'questionMarkToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTDirIn >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitDirIn: self
]

{ #category : #'process graph' }
ASTDirIn >> addTo: aSet ifInput: anASTVariable [

	aSet add:anASTVariable 
]

{ #category : #generated }
ASTDirIn >> questionMarkToken [
	^ questionMarkToken
]

{ #category : #generated }
ASTDirIn >> questionMarkToken: aSmaCCToken [
	questionMarkToken := aSmaCCToken
]

{ #category : #streaming }
ASTDirIn >> streamOn: aWriteStream [

	aWriteStream put:'?'
]

{ #category : #accessing }
ASTDirIn >> title [ 
	^'?'
]

{ #category : #generated }
ASTDirIn >> tokenVariables [
	^ #(#questionMarkToken)
]
