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

{ #category : #streaming }
ASTValueParameter >> streamOn: aWriteStream [
	aWriteStream put:'VAL '.
	type streamOn: aWriteStream.
	aWriteStream put: ' '; put: name value.

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
ASTValueParameter >> vALToken [
	^ vALToken
]

{ #category : #generated }
ASTValueParameter >> vALToken: aSmaCCToken [
	vALToken := aSmaCCToken
]
