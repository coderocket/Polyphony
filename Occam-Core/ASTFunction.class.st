Class {
	#name : #ASTFunction,
	#superclass : #ASTFunctionLike,
	#instVars : [
		'bEGINToken',
		'locals',
		'body',
		'eNDToken',
		'uses'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #scope }
ASTFunction >> abstractionClosure [

	"All the abstractions that are used by this abstraction"
	
	^(UsedAbstractionsCollector collect: self body inContext: self)	
		reject:[:each | self lookupHere: each key name value ifFound:[true] ifNone:[false] ]
]

{ #category : #generated }
ASTFunction >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitFunction: self
]

{ #category : #adding }
ASTFunction >> addFunctionNamed: aString [

	| aFunction |
	
	aFunction := self makeFunctionNamed: aString.
	self locals add: aFunction. 
	
	aFunction parent: self
]

{ #category : #generated }
ASTFunction >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTFunction >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #generated }
ASTFunction >> body [
	^ body
]

{ #category : #generated }
ASTFunction >> body: anASTProcess [
	self body notNil
		ifTrue: [ self body parent: nil ].
	body := anASTProcess.
	self body notNil
		ifTrue: [ self body parent: self ]
]

{ #category : #checking }
ASTFunction >> check [

	TypeChecker check: self body inContext: self.
]

{ #category : #generated }
ASTFunction >> compositeNodeVariables [
	^ #(#uses #locals #params)
]

{ #category : #generated }
ASTFunction >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTFunction >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
ASTFunction >> initialize [
	super initialize.
	uses := OrderedCollection new: 2.
	locals := OrderedCollection new: 2.
]

{ #category : #generated }
ASTFunction >> locals [
	^ locals
]

{ #category : #generated }
ASTFunction >> locals: anOrderedCollection [
	self setParents: self locals to: nil.
	locals := anOrderedCollection.
	self setParents: self locals to: self
]

{ #category : #scope }
ASTFunction >> lookupHere: aString ifFound: aBlock ifNone: exceptionBlock [
	^locals detect: [:each | each name value = aString] ifFound: aBlock ifNone:[
		params detect: [ :each | each name value = aString ] ifFound: aBlock ifNone:exceptionBlock ]
			
]

{ #category : #generated }
ASTFunction >> nodeVariables [
	^ #(#body #type #doc)
]

{ #category : #removing }
ASTFunction >> removeAbstraction: anASTProcedure [

	locals remove: anASTProcedure
]

{ #category : #generated }
ASTFunction >> tokenVariables [
	^ #(#bEGINToken #eNDToken #fUNCTIONToken #leftParenToken #rightParenToken #name #periodToken)
]

{ #category : #generated }
ASTFunction >> uses [
	^ uses
]

{ #category : #generated }
ASTFunction >> uses: anOrderedCollection [
	self setParents: self uses to: nil.
	uses := anOrderedCollection.
	self setParents: self uses to: self
]
