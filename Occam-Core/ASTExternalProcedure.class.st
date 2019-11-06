Class {
	#name : #ASTExternalProcedure,
	#superclass : #ASTProcedureLike,
	#instVars : [
		'eXTERNALToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTExternalProcedure >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitExternalProcedure: self
]

{ #category : #generated }
ASTExternalProcedure >> eXTERNALToken [
	^ eXTERNALToken
]

{ #category : #generated }
ASTExternalProcedure >> eXTERNALToken: aSmaCCToken [
	eXTERNALToken := aSmaCCToken
]

{ #category : #testing }
ASTExternalProcedure >> isExternal [
	^true
]

{ #category : #testing }
ASTExternalProcedure >> isLocked [ 
	^true
]

{ #category : #generated }
ASTExternalProcedure >> locals [
	^OrderedCollection new
]

{ #category : #streaming }
ASTExternalProcedure >> streamOn: aWriteStream [

	aWriteStream put: 'EXTERNAL PROC '.
	super streamOn: aWriteStream.
	aWriteStream put:':'.
]

{ #category : #generated }
ASTExternalProcedure >> tokenVariables [
	^ #(#eXTERNALToken #pROCToken #leftParenToken #rightParenToken #name #periodToken)
]
