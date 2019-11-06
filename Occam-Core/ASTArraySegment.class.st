Class {
	#name : #ASTArraySegment,
	#superclass : #ASTLValue,
	#instVars : [
		'leftBracketToken',
		'rightBracketToken',
		'fROMToken',
		'array',
		'base',
		'fORToken',
		'count'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTArraySegment >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitArraySegment: self
]

{ #category : #generated }
ASTArraySegment >> array [
	^ array
]

{ #category : #generated }
ASTArraySegment >> array: anASTLValue [
	self array notNil
		ifTrue: [ self array parent: nil ].
	array := anASTLValue.
	self array notNil
		ifTrue: [ self array parent: self ]
]

{ #category : #generated }
ASTArraySegment >> base [
	^ base
]

{ #category : #generated }
ASTArraySegment >> base: anASTRoot [
	self base notNil
		ifTrue: [ self base parent: nil ].
	base := anASTRoot.
	self base notNil
		ifTrue: [ self base parent: self ]
]

{ #category : #generated }
ASTArraySegment >> count [
	^ count
]

{ #category : #generated }
ASTArraySegment >> count: anASTRoot [
	self count notNil
		ifTrue: [ self count parent: nil ].
	count := anASTRoot.
	self count notNil
		ifTrue: [ self count parent: self ]
]

{ #category : #generated }
ASTArraySegment >> fORToken [
	^ fORToken
]

{ #category : #generated }
ASTArraySegment >> fORToken: aSmaCCToken [
	fORToken := aSmaCCToken
]

{ #category : #generated }
ASTArraySegment >> fROMToken [
	^ fROMToken
]

{ #category : #generated }
ASTArraySegment >> fROMToken: aSmaCCToken [
	fROMToken := aSmaCCToken
]

{ #category : #generated }
ASTArraySegment >> ignoredTokenVariables [
	^ #(#leftBracketToken #rightBracketToken)
]

{ #category : #generated }
ASTArraySegment >> leftBracketToken [
	^ leftBracketToken
]

{ #category : #generated }
ASTArraySegment >> leftBracketToken: aSmaCCToken [
	leftBracketToken := aSmaCCToken
]

{ #category : #generated }
ASTArraySegment >> nodeVariables [
	^ #(#array #base #count)
]

{ #category : #generated }
ASTArraySegment >> rightBracketToken [
	^ rightBracketToken
]

{ #category : #generated }
ASTArraySegment >> rightBracketToken: aSmaCCToken [
	rightBracketToken := aSmaCCToken
]

{ #category : #streaming }
ASTArraySegment >> streamOn: aWriteStream [

	array streamOn: aWriteStream.
	aWriteStream put:'[ '.
	base streamOn: aWriteStream.
	aWriteStream put: ' FOR '.
	count streamOn: aWriteStream.
	aWriteStream put:' ]'.

]

{ #category : #generated }
ASTArraySegment >> tokenVariables [
	^ #(#fROMToken #fORToken)
]
