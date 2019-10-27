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
