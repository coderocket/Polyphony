Class {
	#name : #ASTFunctionLike,
	#superclass : #ASTAbstraction,
	#instVars : [
		'fUNCTIONToken',
		'type'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTFunctionLike >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitFunctionLike: self
]

{ #category : #generated }
ASTFunctionLike >> fUNCTIONToken [
	^ fUNCTIONToken
]

{ #category : #generated }
ASTFunctionLike >> fUNCTIONToken: aSmaCCToken [
	fUNCTIONToken := aSmaCCToken
]

{ #category : #generated }
ASTFunctionLike >> nodeVariables [
	^ #(#type #doc)
]

{ #category : #generated }
ASTFunctionLike >> tokenVariables [
	^ #(#fUNCTIONToken #leftParenToken #rightParenToken #name #periodToken)
]

{ #category : #generated }
ASTFunctionLike >> type [
	^ type
]

{ #category : #generated }
ASTFunctionLike >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]

{ #category : #'type checking' }
ASTFunctionLike >> typeCheckCall: aCallNode with: aTypeChecker [

	super typeCheckCall: aCallNode with: aTypeChecker.
	
	^self type.

]
