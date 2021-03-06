Class {
	#name : #ASTReplicatedAltGuardedCommand,
	#superclass : #ASTReplicatedGuardedCommand,
	#instVars : [
		'aLTToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTReplicatedAltGuardedCommand >> aLTToken [
	^ aLTToken
]

{ #category : #generated }
ASTReplicatedAltGuardedCommand >> aLTToken: aSmaCCToken [
	aLTToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedAltGuardedCommand >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitReplicatedAltGuardedCommand: self
]

{ #category : #'as yet unclassified' }
ASTReplicatedAltGuardedCommand >> callsProcedureNamed: aString [ 
	^self process callsProcedureNamed: aString
]

{ #category : #generated }
ASTReplicatedAltGuardedCommand >> tokenVariables [
	^ #(#aLTToken #index #equalToken #fORToken #bEGINToken #eNDToken)
]
