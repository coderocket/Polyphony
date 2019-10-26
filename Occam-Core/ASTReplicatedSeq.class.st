Class {
	#name : #ASTReplicatedSeq,
	#superclass : #ASTProcess,
	#instVars : [
		'sEQToken',
		'process'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTReplicatedSeq >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitReplicatedSeq: self
]

{ #category : #generated }
ASTReplicatedSeq >> nodeVariables [
	^ #(#process)
]

{ #category : #generated }
ASTReplicatedSeq >> process [
	^ process
]

{ #category : #generated }
ASTReplicatedSeq >> process: anASTReplicatedProcess [
	self process notNil
		ifTrue: [ self process parent: nil ].
	process := anASTReplicatedProcess.
	self process notNil
		ifTrue: [ self process parent: self ]
]

{ #category : #generated }
ASTReplicatedSeq >> sEQToken [
	^ sEQToken
]

{ #category : #generated }
ASTReplicatedSeq >> sEQToken: aSmaCCToken [
	sEQToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedSeq >> tokenVariables [
	^ #(#sEQToken)
]
