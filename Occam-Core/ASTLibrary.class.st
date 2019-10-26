Class {
	#name : #ASTLibrary,
	#superclass : #ASTScope,
	#instVars : [
		'lIBRARYToken',
		'members',
		'iSToken',
		'bEGINToken',
		'eNDToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTLibrary >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLibrary: self
]

{ #category : #adding }
ASTLibrary >> addExistingAbstraction: anASTAbstraction [

	self members add: anASTAbstraction.
	
	anASTAbstraction parent removeAbstraction: anASTAbstraction.
	
	anASTAbstraction parent: self.
	
]

{ #category : #adding }
ASTLibrary >> addFunctionNamed: aString [

	| aFunction |
	
	aFunction := self makeFunctionNamed: aString.
	self members add: aFunction.
	
	aFunction parent: self
]

{ #category : #adding }
ASTLibrary >> addLibraryNamed: aString [

	| aLibrary |
	aLibrary := 	ASTLibrary new name: (SmaCCToken value: aString).
		
	self members add: aLibrary.
	
	aLibrary parent: self.
]

{ #category : #adding }
ASTLibrary >> addProcedureNamed: aString [

	| aProcedure |
	
	aProcedure := self makeProcedureNamed: aString.
	
	self members add: aProcedure. 
	
	aProcedure parent: self.
]

{ #category : #scope }
ASTLibrary >> allAbstractions [

	^(self members select:[:each | each isKindOf:ASTScope ])
	 	inject:OrderedCollection new into:[:acc :each | acc addAll: each allAbstractions . acc ]
]

{ #category : #scope }
ASTLibrary >> allExternalAbbrevs [

	^(self members select:[:each | each isKindOf:ASTLibrary ])
	 	inject:(self members select:[:each | each isKindOf:ASTExternalAbbreviation ]) into:[:acc :each | acc addAll: each allExternalAbbrevs . acc ]
]

{ #category : #generated }
ASTLibrary >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTLibrary >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #generated }
ASTLibrary >> compositeNodeVariables [
	^ #(#members)
]

{ #category : #generated }
ASTLibrary >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTLibrary >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #'file in/out' }
ASTLibrary >> fileIn: aStream [

	| anASTLibraryNode |
	
	anASTLibraryNode := OccamCoreParser parse: aStream contents.
	TypeChecker check: anASTLibraryNode inContext: nil.
	members add: anASTLibraryNode.

]

{ #category : #generated }
ASTLibrary >> iSToken [
	^ iSToken
]

{ #category : #generated }
ASTLibrary >> iSToken: aSmaCCToken [
	iSToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
ASTLibrary >> initialize [
	super initialize.
	members := OrderedCollection new: 2.
]

{ #category : #testing }
ASTLibrary >> isLibrary [
	^true
]

{ #category : #generated }
ASTLibrary >> lIBRARYToken [
	^ lIBRARYToken
]

{ #category : #generated }
ASTLibrary >> lIBRARYToken: aSmaCCToken [
	lIBRARYToken := aSmaCCToken
]

{ #category : #scope }
ASTLibrary >> lookupHere: aString ifFound: aBlock ifNone: exceptionBlock [

	^members detect: [:each | each name value = aString] ifFound: aBlock ifNone: exceptionBlock

]

{ #category : #generated }
ASTLibrary >> members [
	^ members
]

{ #category : #generated }
ASTLibrary >> members: anOrderedCollection [
	self setParents: self members to: nil.
	members := anOrderedCollection.
	self setParents: self members to: self
]

{ #category : #printing }
ASTLibrary >> printOn: aStream [
		aStream nextPutAll: self name value 

]

{ #category : #removing }
ASTLibrary >> removeAbstraction: anASTAbstraction [

	members remove: anASTAbstraction
  
]

{ #category : #generated }
ASTLibrary >> tokenVariables [
	^ #(#lIBRARYToken #iSToken #bEGINToken #eNDToken #name #periodToken)
]
