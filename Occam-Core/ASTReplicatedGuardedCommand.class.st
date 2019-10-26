Class {
	#name : #ASTReplicatedGuardedCommand,
	#superclass : #ASTRoot,
	#instVars : [
		'index',
		'equalToken',
		'base',
		'fORToken',
		'count',
		'bEGINToken',
		'eNDToken',
		'guardedCommand'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTReplicatedGuardedCommand >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitReplicatedGuardedCommand: self
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> base [
	^ base
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> base: anASTRoot [
	self base notNil
		ifTrue: [ self base parent: nil ].
	base := anASTRoot.
	self base notNil
		ifTrue: [ self base parent: self ]
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> count [
	^ count
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> count: anASTRoot [
	self count notNil
		ifTrue: [ self count parent: nil ].
	count := anASTRoot.
	self count notNil
		ifTrue: [ self count parent: self ]
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> equalToken [
	^ equalToken
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> equalToken: aSmaCCToken [
	equalToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> fORToken [
	^ fORToken
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> fORToken: aSmaCCToken [
	fORToken := aSmaCCToken
]

{ #category : #accessing }
ASTReplicatedGuardedCommand >> guard [

	^ASTReplicatedProcess new index: index; base: base; count: count; body: self guardedCommand guard; parent: self 

]

{ #category : #generated }
ASTReplicatedGuardedCommand >> guardedCommand [
	^ guardedCommand
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> guardedCommand: anASTGuardedCommand [
	self guardedCommand notNil
		ifTrue: [ self guardedCommand parent: nil ].
	guardedCommand := anASTGuardedCommand.
	self guardedCommand notNil
		ifTrue: [ self guardedCommand parent: self ]
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> index [
	^ index
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> index: aSmaCCToken [
	index := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedGuardedCommand >> nodeVariables [
	^ #(#base #count #guardedCommand)
]

{ #category : #accessing }
ASTReplicatedGuardedCommand >> process [ 

	^ASTReplicatedProcess new index: index; base: base; count: count; body: self guardedCommand process; parent: self 

]

{ #category : #generated }
ASTReplicatedGuardedCommand >> tokenVariables [
	^ #(#index #equalToken #fORToken #bEGINToken #eNDToken)
]
