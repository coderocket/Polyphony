Class {
	#name : #ASTGuardedCommand,
	#superclass : #ASTRoot,
	#instVars : [
		'guard',
		'process',
		'eNDToken',
		'bEGINToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTGuardedCommand >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitGuardedCommand: self
]

{ #category : #generated }
ASTGuardedCommand >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTGuardedCommand >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #scope }
ASTGuardedCommand >> callsProcedureNamed: aString [
	^process callsProcedureNamed: aString
]

{ #category : #generated }
ASTGuardedCommand >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTGuardedCommand >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #generated }
ASTGuardedCommand >> guard [
	^ guard
]

{ #category : #generated }
ASTGuardedCommand >> guard: anASTRoot [
	self guard notNil
		ifTrue: [ self guard parent: nil ].
	guard := anASTRoot.
	self guard notNil
		ifTrue: [ self guard parent: self ]
]

{ #category : #generated }
ASTGuardedCommand >> nodeVariables [
	^ #(#guard #process)
]

{ #category : #generated }
ASTGuardedCommand >> process [
	^ process
]

{ #category : #generated }
ASTGuardedCommand >> process: anASTProcess [
	self process notNil
		ifTrue: [ self process parent: nil ].
	process := anASTProcess.
	self process notNil
		ifTrue: [ self process parent: self ]
]

{ #category : #generated }
ASTGuardedCommand >> tokenVariables [
	^ #(#bEGINToken #eNDToken)
]
