Class {
	#name : #ASTAbbreviation,
	#superclass : #ASTRoot,
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

{ #category : #generated }
ASTAbbreviation >> tokenVariables [
	^ #(#vALToken #name #iSToken #periodToken)
]

{ #category : #accessing }
ASTAbbreviation >> type [
	^self attributeNamed: #type
]

{ #category : #generated }
ASTAbbreviation >> vALToken [
	^ vALToken
]

{ #category : #generated }
ASTAbbreviation >> vALToken: aSmaCCToken [
	vALToken := aSmaCCToken
]
