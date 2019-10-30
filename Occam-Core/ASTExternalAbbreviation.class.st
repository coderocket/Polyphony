Class {
	#name : #ASTExternalAbbreviation,
	#superclass : #ASTType,
	#instVars : [
		'eXTERNALToken',
		'vALToken',
		'type',
		'name',
		'periodToken',
		'doc'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTExternalAbbreviation >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitExternalAbbreviation: self
]

{ #category : #generated }
ASTExternalAbbreviation >> doc [
	^ doc
]

{ #category : #generated }
ASTExternalAbbreviation >> doc: anASTDoc [
	self doc notNil
		ifTrue: [ self doc parent: nil ].
	doc := anASTDoc.
	self doc notNil
		ifTrue: [ self doc parent: self ]
]

{ #category : #documentation }
ASTExternalAbbreviation >> documentation [
	self doc ifNil:[
		self doc: (ASTDoc new text: (SmaCCToken value:'Nothing yet.'))
	].
	^self doc text value
]

{ #category : #documentation }
ASTExternalAbbreviation >> documentation: aString [

	self doc ifNil:[
		self doc: (ASTDoc new text: (SmaCCToken value:'Nothing yet.'))
	].

	self doc text: (SmaCCToken value: aString)
 
]

{ #category : #generated }
ASTExternalAbbreviation >> eXTERNALToken [
	^ eXTERNALToken
]

{ #category : #generated }
ASTExternalAbbreviation >> eXTERNALToken: aSmaCCToken [
	eXTERNALToken := aSmaCCToken
]

{ #category : #generated }
ASTExternalAbbreviation >> name [
	^ name
]

{ #category : #generated }
ASTExternalAbbreviation >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
ASTExternalAbbreviation >> nodeVariables [
	^ #(#type #doc)
]

{ #category : #generated }
ASTExternalAbbreviation >> periodToken [
	^ periodToken
]

{ #category : #generated }
ASTExternalAbbreviation >> periodToken: aSmaCCToken [
	periodToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTExternalAbbreviation >> representedType [
	^type

]

{ #category : #generated }
ASTExternalAbbreviation >> tokenVariables [
	^ #(#eXTERNALToken #vALToken #name #periodToken)
]

{ #category : #generated }
ASTExternalAbbreviation >> type [
	^ type
]

{ #category : #generated }
ASTExternalAbbreviation >> type: anASTType [
	self type notNil
		ifTrue: [ self type parent: nil ].
	type := anASTType.
	self type notNil
		ifTrue: [ self type parent: self ]
]

{ #category : #generated }
ASTExternalAbbreviation >> vALToken [
	^ vALToken
]

{ #category : #generated }
ASTExternalAbbreviation >> vALToken: aSmaCCToken [
	vALToken := aSmaCCToken
]
