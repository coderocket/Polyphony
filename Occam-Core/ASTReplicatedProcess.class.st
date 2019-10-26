Class {
	#name : #ASTReplicatedProcess,
	#superclass : #ASTRoot,
	#instVars : [
		'index',
		'equalToken',
		'base',
		'fORToken',
		'count',
		'bEGINToken',
		'body',
		'eNDToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTReplicatedProcess >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitReplicatedProcess: self
]

{ #category : #generated }
ASTReplicatedProcess >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTReplicatedProcess >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedProcess >> base [
	^ base
]

{ #category : #generated }
ASTReplicatedProcess >> base: anASTRoot [
	self base notNil
		ifTrue: [ self base parent: nil ].
	base := anASTRoot.
	self base notNil
		ifTrue: [ self base parent: self ]
]

{ #category : #generated }
ASTReplicatedProcess >> body [
	^ body
]

{ #category : #generated }
ASTReplicatedProcess >> body: anASTProcess [
	self body notNil
		ifTrue: [ self body parent: nil ].
	body := anASTProcess.
	self body notNil
		ifTrue: [ self body parent: self ]
]

{ #category : #generated }
ASTReplicatedProcess >> count [
	^ count
]

{ #category : #generated }
ASTReplicatedProcess >> count: anASTRoot [
	self count notNil
		ifTrue: [ self count parent: nil ].
	count := anASTRoot.
	self count notNil
		ifTrue: [ self count parent: self ]
]

{ #category : #generated }
ASTReplicatedProcess >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTReplicatedProcess >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedProcess >> equalToken [
	^ equalToken
]

{ #category : #generated }
ASTReplicatedProcess >> equalToken: aSmaCCToken [
	equalToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedProcess >> fORToken [
	^ fORToken
]

{ #category : #generated }
ASTReplicatedProcess >> fORToken: aSmaCCToken [
	fORToken := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedProcess >> index [
	^ index
]

{ #category : #generated }
ASTReplicatedProcess >> index: aSmaCCToken [
	index := aSmaCCToken
]

{ #category : #generated }
ASTReplicatedProcess >> nodeVariables [
	^ #(#base #count #body)
]

{ #category : #generated }
ASTReplicatedProcess >> tokenVariables [
	^ #(#index #equalToken #fORToken #bEGINToken #eNDToken)
]
