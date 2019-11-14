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

{ #category : #menu }
ASTLibrary class >> fileIn [

	| anASTLibraryNode aStream aFileReference |
	
	aFileReference := (UITheme builder chooseExistingFileReference: 'Select a Library' extensions: {'ocm'} path: '.').
	
	aStream := aFileReference readStream.

	anASTLibraryNode := [ OccamCoreParser parse: aStream contents ] ensure:[aStream close].
	
	anASTLibraryNode source. "force the calculation of start and end positions"
	
	InternalizeSource new acceptNode: anASTLibraryNode.
	
	TypeChecker check: anASTLibraryNode inContext: anASTLibraryNode.
		
	^anASTLibraryNode 
]

{ #category : #generated }
ASTLibrary >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLibrary: self
]

{ #category : #adding }
ASTLibrary >> addExistingAbstraction: anASTAbstraction [

	self members add: anASTAbstraction.
	
	anASTAbstraction parent removeAbstraction: anASTAbstraction.
	
	anASTAbstraction parent: self.
	
	self check.
	
]

{ #category : #adding }
ASTLibrary >> addFunctionNamed: aString [

	| aFunction |
	
	aFunction := self makeFunctionNamed: aString.
	self members add: aFunction.
	
	aFunction parent: self.
	
	self check.
]

{ #category : #adding }
ASTLibrary >> addLibraryNamed: aString [

	| aLibrary |
	aLibrary := 	ASTLibrary new name: (SmaCCToken value: aString).
		
	self members add: aLibrary.
	
	aLibrary parent: self.
	
	self check.
	
]

{ #category : #adding }
ASTLibrary >> addProcedureNamed: aString [

	| aProcedure |
	
	aProcedure := self makeProcedureNamed: aString.
	
	self members add: aProcedure. 
	
	aProcedure parent: self.
	
	self check
]

{ #category : #scope }
ASTLibrary >> allAbstractions [

	^(self members select:[:each | each isAbstraction ])
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

{ #category : #'as yet unclassified' }
ASTLibrary >> callsProcedureNamed: aString [ 
	
	^members anySatisfy: [ :each | each callsProcedureNamed: aString ]
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
	
	InternalizeSource new acceptNode: anASTLibraryNode.
	
	members add: anASTLibraryNode.
	anASTLibraryNode parent: self.
	
	TypeChecker check: anASTLibraryNode inContext: self.
	
	self check

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

{ #category : #'as yet unclassified' }
ASTLibrary >> localAbbrevs [ 

	^self locals select:[:each | each isKindOf: ASTAbbreviation  ]
]

{ #category : #generated }
ASTLibrary >> locals [
	^members
	
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

	members remove: anASTAbstraction.
		
	self check
  
]

{ #category : #streaming }
ASTLibrary >> streamBodyOn: aWriteStream [

	aWriteStream close; put:':'; newLine.
]

{ #category : #streaming }
ASTLibrary >> streamNameOn: aWriteStream [

	aWriteStream put: 'LIBRARY ' ; put:name value 
]

{ #category : #generated }
ASTLibrary >> tokenVariables [
	^ #(#lIBRARYToken #iSToken #bEGINToken #eNDToken #name #periodToken)
]
