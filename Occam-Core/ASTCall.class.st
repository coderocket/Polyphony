Class {
	#name : #ASTCall,
	#superclass : #ASTProcess,
	#instVars : [
		'name',
		'exprs',
		'leftParenToken',
		'rightParenToken',
		'commaTokens'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTCall >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitCall: self
]

{ #category : #'as yet unclassified' }
ASTCall >> callsProcedureNamed: aString [
	^name value = aString
]

{ #category : #generated }
ASTCall >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
ASTCall >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
ASTCall >> compositeNodeVariables [
	^ #(#exprs)
]

{ #category : #generated }
ASTCall >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #generated }
ASTCall >> exprs [
	^ exprs
]

{ #category : #generated }
ASTCall >> exprs: anOrderedCollection [
	self setParents: self exprs to: nil.
	exprs := anOrderedCollection.
	self setParents: self exprs to: self
]

{ #category : #'generated-initialize-release' }
ASTCall >> initialize [
	super initialize.
	exprs := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #'process graph' }
ASTCall >> inputs: aContext [

	| aProcedure aSet |
	
	aProcedure := aContext lookup: name value.
	
	aProcedure ifNil:[^Set new].
	
	aSet := aProcedure inputs.
	
	exprs with: aProcedure params do:[:arg :param | 
		param direction addTo: aSet ifInput: arg ].
	 
	^aSet
]

{ #category : #generated }
ASTCall >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
ASTCall >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #generated }
ASTCall >> name [
	^ name
]

{ #category : #generated }
ASTCall >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #'process graph' }
ASTCall >> outputs: aContext [

	| aProcedure aSet |
	
	aProcedure := aContext lookup: name value.
	
	aProcedure ifNil:[^Set new].
	
	aSet := aProcedure outputs.
	
	exprs with: aProcedure params do:[:arg :param | 
		param direction addTo: aSet ifOutput: arg ].
	 
	^aSet
]

{ #category : #'as yet unclassified' }
ASTCall >> parentAbstraction [

	| aNode |
	
	aNode := self parent.
	
	[ aNode isKindOf: ASTAbstraction ]
		whileFalse:[
			aNode := aNode parent 
		].
	
	^aNode
]

{ #category : #generated }
ASTCall >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
ASTCall >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
ASTCall >> tokenVariables [
	^ #(#name #leftParenToken #rightParenToken)
]
