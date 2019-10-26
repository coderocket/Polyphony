Class {
	#name : #ASTValueParameter,
	#superclass : #ASTParameter,
	#instVars : [
		'vALToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTValueParameter >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitValueParameter: self
]

{ #category : #accessing }
ASTValueParameter >> direction [ 
	^ASTDirNone new

]

{ #category : #generated }
ASTValueParameter >> name [
	^ name
]

{ #category : #generated }
ASTValueParameter >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
ASTValueParameter >> nodeVariables [
	^ #(#type)
]

{ #category : #accessing }
ASTValueParameter >> style [
	^'VAL'
]

{ #category : #generated }
ASTValueParameter >> tokenVariables [
	^ #(#vALToken #name)
]

{ #category : #generated }
ASTValueParameter >> type [
	^ type
]

{ #category : #generated }
ASTValueParameter >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]

{ #category : #generated }
ASTValueParameter >> vALToken [
	^ vALToken
]

{ #category : #generated }
ASTValueParameter >> vALToken: aSmaCCToken [
	vALToken := aSmaCCToken
]
