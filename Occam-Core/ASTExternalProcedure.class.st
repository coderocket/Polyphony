Class {
	#name : #ASTExternalProcedure,
	#superclass : #ASTAbstraction,
	#instVars : [
		'eXTERNALToken',
		'pROCToken',
		'leftParenToken',
		'params',
		'commaTokens',
		'rightParenToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTExternalProcedure >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitExternalProcedure: self
]

{ #category : #generated }
ASTExternalProcedure >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
ASTExternalProcedure >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
ASTExternalProcedure >> compositeNodeVariables [
	^ #(#params)
]

{ #category : #generated }
ASTExternalProcedure >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #generated }
ASTExternalProcedure >> eXTERNALToken [
	^ eXTERNALToken
]

{ #category : #generated }
ASTExternalProcedure >> eXTERNALToken: aSmaCCToken [
	eXTERNALToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
ASTExternalProcedure >> initialize [
	super initialize.
	params := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #testing }
ASTExternalProcedure >> isCallable [
	^true
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
ASTExternalProcedure >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
ASTExternalProcedure >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
ASTExternalProcedure >> pROCToken [
	^ pROCToken
]

{ #category : #generated }
ASTExternalProcedure >> pROCToken: aSmaCCToken [
	pROCToken := aSmaCCToken
]

{ #category : #generated }
ASTExternalProcedure >> params [
	^ params
]

{ #category : #generated }
ASTExternalProcedure >> params: anOrderedCollection [
	self setParents: self params to: nil.
	params := anOrderedCollection.
	self setParents: self params to: self
]

{ #category : #generated }
ASTExternalProcedure >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
ASTExternalProcedure >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
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
