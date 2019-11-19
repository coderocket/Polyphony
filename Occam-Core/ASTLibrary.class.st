Class {
	#name : #ASTLibrary,
	#superclass : #ASTScope,
	#instVars : [
		'lIBRARYToken',
		'iSToken',
		'usings'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #menu }
ASTLibrary class >> fileIn [

	| anASTLibraryNode aStream aFileReference |
	
	aFileReference := (UITheme builder chooseExistingFileReference: 'Select a Library' extensions: {'ocm'} path: '.').
	
	aStream := aFileReference readStream.

	anASTLibraryNode := [ OccamCoreParser parse: aStream contents ] ensure:[aStream close].
	
	InternalizeSource new acceptNode: anASTLibraryNode.
	
	TypeChecker check: anASTLibraryNode inContext: anASTLibraryNode.
		
	^anASTLibraryNode 
]

{ #category : #generated }
ASTLibrary >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLibrary: self
]

{ #category : #adding }
ASTLibrary >> addDependency: aUsing [
	usings add: aUsing.
	aUsing parent: self.
	self check.
]

{ #category : #adding }
ASTLibrary >> addExistingAbstraction: anASTAbstraction [

	self locals add: anASTAbstraction.
	
	anASTAbstraction parent removeAbstraction: anASTAbstraction.
	
	anASTAbstraction parent: self.
	
	self check.
	
]

{ #category : #adding }
ASTLibrary >> addFunctionNamed: aString [

	| aFunction |
	
	aFunction := self makeFunctionNamed: aString.
	self locals add: aFunction.
	
	aFunction parent: self.
	
	self check.
]

{ #category : #adding }
ASTLibrary >> addLibraryNamed: aString [

	| aLibrary |
	aLibrary := 	ASTLibrary new name: (SmaCCToken value: aString).
		
	self locals add: aLibrary.
	
	aLibrary parent: self.
	
	self check.
	
]

{ #category : #adding }
ASTLibrary >> addProcedureNamed: aString [

	| aProcedure |
	
	aProcedure := self makeProcedureNamed: aString.
	
	self locals add: aProcedure. 
	
	aProcedure parent: self.
	
	self check
]

{ #category : #scope }
ASTLibrary >> allAbstractions [

	^(self locals select:[:each | each isAbstraction ])
	 	inject:OrderedCollection new into:[:acc :each | acc addAll: each allAbstractions . acc ]
]

{ #category : #scope }
ASTLibrary >> allExternalAbbrevs [

	^(self locals select:[:each | each isKindOf:ASTLibrary ])
	 	inject:(self locals select:[:each | each isKindOf:ASTExternalAbbreviation ]) into:[:acc :each | acc addAll: each allExternalAbbrevs . acc ]
]

{ #category : #converting }
ASTLibrary >> asUsing [

	| names aLibrary |
	
	names := OrderedCollection new.
	
	aLibrary := self.
	
	[aLibrary parent isNil] 
		whileFalse:[
			names addFirst: aLibrary name.
			aLibrary := aLibrary parent. 
		].
	
	^ASTUsing new names: names
]

{ #category : #'as yet unclassified' }
ASTLibrary >> callsProcedureNamed: aString [ 
	
	^locals anySatisfy: [ :each | each callsProcedureNamed: aString ]
]

{ #category : #checking }
ASTLibrary >> check [ 

	locals do:[:each | each check].
	
	super check
]

{ #category : #generated }
ASTLibrary >> compositeNodeVariables [
	^ #(#usings #locals)
]

{ #category : #'file in/out' }
ASTLibrary >> fileIn: aStream [

	| anASTLibraryNode |
	
	anASTLibraryNode := OccamCoreParser parse: aStream contents.
	
	InternalizeSource new acceptNode: anASTLibraryNode.
	
	locals add: anASTLibraryNode.
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
	usings := OrderedCollection new: 2.
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

{ #category : #'as yet unclassified' }
ASTLibrary >> locals [
	^locals
	
]

{ #category : #scope }
ASTLibrary >> lookup: aString ifPresent: aBlock ifAbsent: exceptionBlock [
	^self lookupHere: aString ifFound: aBlock ifNone:[
		self usings detect:[:each | 
			(self root resolve:each) lookup: aString ifPresent:[true] ifAbsent:[false] ]
		ifFound:[:aPath | (self root resolve: aPath) lookup: aString ifPresent:aBlock ifAbsent:[] ] 
		ifNone:[
			parent 
				ifNil:[exceptionBlock value] 
				ifNotNil:[parent lookup: aString ifPresent:aBlock ifAbsent: exceptionBlock] ] ] 
]

{ #category : #printing }
ASTLibrary >> printOn: aStream [
		aStream nextPutAll: self name value 

]

{ #category : #removing }
ASTLibrary >> removeAbstraction: anASTAbstraction [

	locals remove: anASTAbstraction.
		
	self check
  
]

{ #category : #removing }
ASTLibrary >> removeDependency: aUsing [
	self usings remove: aUsing.
	self check.

]

{ #category : #scope }
ASTLibrary >> resolve: aUsing [ 

	| aLibrary aReadStream |
	
	aLibrary := self.
	aReadStream := ReadStream on: aUsing names.
	
	[ aReadStream atEnd ] whileFalse:[
		aLibrary := aLibrary lookup: aReadStream next value
	].
	
	^aLibrary
	
]

{ #category : #scope }
ASTLibrary >> root [ 
	| aLibrary |
	
	aLibrary := self.
	
	[ aLibrary parent isNil ] 
		whileFalse:[
			aLibrary := aLibrary parent
		].
	
	^aLibrary
]

{ #category : #streaming }
ASTLibrary >> streamBodyOn: aWriteStream [
	
	aWriteStream close; put:':'; newLine.
]

{ #category : #streaming }
ASTLibrary >> streamDocOn: aWriteStream [
]

{ #category : #streaming }
ASTLibrary >> streamNameOn: aWriteStream [

	aWriteStream put: 'LIBRARY ' ; put:name value ; put:' IS '
]

{ #category : #streaming }
ASTLibrary >> streamParametersOn: aWriteStream [
	
]

{ #category : #streaming }
ASTLibrary >> streamUsingOn: aWriteStream [

	aWriteStream open.
	usings do: [ :each | each streamOn: aWriteStream ] separatedBy: [  aWriteStream newLine ].
	aWriteStream close.
]

{ #category : #generated }
ASTLibrary >> tokenVariables [
	^ #(#lIBRARYToken #iSToken #bEGINToken #eNDToken #name #periodToken)
]

{ #category : #generated }
ASTLibrary >> usings [
	^ usings
]

{ #category : #generated }
ASTLibrary >> usings: anOrderedCollection [
	self setParents: self usings to: nil.
	usings := anOrderedCollection.
	self setParents: self usings to: self
]
