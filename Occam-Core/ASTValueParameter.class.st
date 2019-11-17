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

{ #category : #'as yet unclassified' }
ASTValueParameter >> changeStyleTo: aString [
	
	| aReferenceParameter |
	
	(aString = '') ifFalse:[^self].
	
	aReferenceParameter := ASTReferenceParameter new.
	aReferenceParameter name: self name.
	aReferenceParameter type: self type.
	aReferenceParameter attributes addAll: self attributes.
	self become: aReferenceParameter.
	
]

{ #category : #accessing }
ASTValueParameter >> direction [ 
	^ASTDirNone new

]

{ #category : #'as yet unclassified' }
ASTValueParameter >> memoryFootprintIn: aPlatform inContext: aContext [

	^type memoryFootprintIn: aPlatform inContext: aContext
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
