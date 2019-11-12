Class {
	#name : #ASTFunction,
	#superclass : #ASTProcessAbstraction,
	#instVars : [
		'type',
		'fUNCTIONToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTFunction >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitFunction: self
]

{ #category : #generated }
ASTFunction >> fUNCTIONToken [
	^ fUNCTIONToken
]

{ #category : #generated }
ASTFunction >> fUNCTIONToken: aSmaCCToken [
	fUNCTIONToken := aSmaCCToken
]

{ #category : #generated }
ASTFunction >> nodeVariables [
	^ #(#type #body #doc)
]

{ #category : #streaming }
ASTFunction >> streamNameOn: aWriteStream [

	type streamOn: aWriteStream.
	aWriteStream put: ' FUNCTION ' ; put: name value.

]

{ #category : #generated }
ASTFunction >> tokenVariables [
	^ #(#fUNCTIONToken #leftParenToken #rightParenToken #bEGINToken #eNDToken #name #periodToken)
]

{ #category : #generated }
ASTFunction >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]

{ #category : #'type checking' }
ASTFunction >> typeCheckCall: aCallNode with: aTypeChecker [

	super typeCheckCall: aCallNode with: aTypeChecker.
	^self type
]
