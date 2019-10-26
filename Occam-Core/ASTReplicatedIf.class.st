Class {
	#name : #ASTReplicatedIf,
	#superclass : #ASTProcess,
	#instVars : [
		'iFToken',
		'process'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTReplicatedIf >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitReplicatedIf: self
]

{ #category : #generated }
ASTReplicatedIf >> iFToken [
	^ iFToken
]

{ #category : #generated }
ASTReplicatedIf >> iFToken: aSmaCCToken [
	iFToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedIf >> nodeVariables [
	^ #(#process)
]

{ #category : #generated }
ASTReplicatedIf >> process [
	^ process
]

{ #category : #generated }
ASTReplicatedIf >> process: anASTReplicatedProcess [
	self process notNil
		ifTrue: [ self process parent: nil ].
	process := anASTReplicatedProcess.
	self process notNil
		ifTrue: [ self process parent: self ]
]

{ #category : #generated }
ASTReplicatedIf >> tokenVariables [
	^ #(#iFToken)
]
