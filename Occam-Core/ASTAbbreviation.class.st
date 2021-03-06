Class {
	#name : #ASTAbbreviation,
	#superclass : #ASTDefinition,
	#instVars : [
		'vALToken',
		'name',
		'iSToken',
		'expr',
		'periodToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTAbbreviation >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitAbbreviation: self
]

{ #category : #generated }
ASTAbbreviation >> expr [
	^ expr
]

{ #category : #generated }
ASTAbbreviation >> expr: anASTRoot [
	self expr notNil
		ifTrue: [ self expr parent: nil ].
	expr := anASTRoot.
	self expr notNil
		ifTrue: [ self expr parent: self ]
]

{ #category : #generated }
ASTAbbreviation >> iSToken [
	^ iSToken
]

{ #category : #generated }
ASTAbbreviation >> iSToken: aSmaCCToken [
	iSToken := aSmaCCToken
]

{ #category : #generated }
ASTAbbreviation >> name [
	^ name
]

{ #category : #generated }
ASTAbbreviation >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
ASTAbbreviation >> nodeVariables [
	^ #(#expr)
]

{ #category : #generated }
ASTAbbreviation >> periodToken [
	^ periodToken
]

{ #category : #generated }
ASTAbbreviation >> periodToken: aSmaCCToken [
	periodToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTAbbreviation >> replaceExpression: aString inContext: anAbstraction [

	| aParser anAST |
	
	aParser := OccamCoreParser on: (ReadStream on: aString).
	
	aParser setStartingState: OccamCoreParser startingStateForExpression. 
	 
	anAST := aParser parse.
	
	self expr: anAST.
	
	anAbstraction check.
]

{ #category : #streaming }
ASTAbbreviation >> streamOn: aWriteStream [
	aWriteStream put: 'VAL '; put: name value; put: ' IS '.
	expr streamOn: aWriteStream.
	aWriteStream put:':'
]

{ #category : #generated }
ASTAbbreviation >> tokenVariables [
	^ #(#vALToken #name #iSToken #periodToken)
]

{ #category : #accessing }
ASTAbbreviation >> type [
	
	| aType |
	
	aType := TypeChecker check: expr inContext: parent.
	
	aType attributeNamed: #constant put: true.
	
	^aType
	
]

{ #category : #generated }
ASTAbbreviation >> vALToken [
	^ vALToken
]

{ #category : #generated }
ASTAbbreviation >> vALToken: aSmaCCToken [
	vALToken := aSmaCCToken
]
