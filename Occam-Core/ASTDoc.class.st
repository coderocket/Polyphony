Class {
	#name : #ASTDoc,
	#superclass : #ASTRoot,
	#instVars : [
		'dOCToken',
		'text',
		'timesDivideToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTDoc >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitDoc: self
]

{ #category : #generated }
ASTDoc >> dOCToken [
	^ dOCToken
]

{ #category : #generated }
ASTDoc >> dOCToken: aSmaCCToken [
	dOCToken := aSmaCCToken
]

{ #category : #streaming }
ASTDoc >> streamOn: aWriteStream [

	aWriteStream put:'DOC '.
	aWriteStream put: text value.
	aWriteStream put: '*/'.
]

{ #category : #generated }
ASTDoc >> text [
	^ text
]

{ #category : #generated }
ASTDoc >> text: aSmaCCToken [
	text := aSmaCCToken
]

{ #category : #generated }
ASTDoc >> timesDivideToken [
	^ timesDivideToken
]

{ #category : #generated }
ASTDoc >> timesDivideToken: aSmaCCToken [
	timesDivideToken := aSmaCCToken
]

{ #category : #generated }
ASTDoc >> tokenVariables [
	^ #(#dOCToken #text #timesDivideToken)
]
