Class {
	#name : #ASTReplicatedIfGuardedCommand,
	#superclass : #ASTReplicatedGuardedCommand,
	#instVars : [
		'iFToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTReplicatedIfGuardedCommand >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitReplicatedIfGuardedCommand: self
]

{ #category : #generated }
ASTReplicatedIfGuardedCommand >> iFToken [
	^ iFToken
]

{ #category : #generated }
ASTReplicatedIfGuardedCommand >> iFToken: aSmaCCToken [
	iFToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedIfGuardedCommand >> tokenVariables [
	^ #(#iFToken #index #equalToken #fORToken #bEGINToken #eNDToken)
]
