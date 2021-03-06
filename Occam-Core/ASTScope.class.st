Class {
	#name : #ASTScope,
	#superclass : #ASTAbstraction,
	#instVars : [
		'announcer',
		'bEGINToken',
		'locals',
		'eNDToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTScope >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitScope: self
]

{ #category : #adding }
ASTScope >> addFunctionNamed: aString [

	| aFunction |
	
	aFunction := self makeFunctionNamed: aString.
	self locals add: aFunction. 
	
	aFunction parent: self.
	
	self check
]

{ #category : #adding }
ASTScope >> addProcedureNamed: aString [

	| aProcedure |
	
	aProcedure := self makeProcedureNamed: aString.
	
	self locals add: aProcedure. 
	
	aProcedure parent: self.
	
	self check.
]

{ #category : #generated }
ASTScope >> announcer [
	^ announcer
]

{ #category : #generated }
ASTScope >> announcer: anObject [
	announcer := anObject
]

{ #category : #generated }
ASTScope >> bEGINToken [
	^ bEGINToken
]

{ #category : #generated }
ASTScope >> bEGINToken: aSmaCCToken [
	bEGINToken := aSmaCCToken
]

{ #category : #checking }
ASTScope >> check [

 | p |

	p := self.
	
	[p] whileNotNil: [ 
		p announcer announce: GLMItemChanged. p := p parent 
	]


]

{ #category : #generated }
ASTScope >> compositeNodeVariables [
	^ #(#locals)
]

{ #category : #copying }
ASTScope >> duplicateWithName: aString [

	| aScope |
	
	aScope := self copyTree.
	
	aScope name: (SmaCCToken value: aString).
	
	self parent locals add: aScope.

	aScope parent: self parent.
	
	aScope check
	
]

{ #category : #generated }
ASTScope >> eNDToken [
	^ eNDToken
]

{ #category : #generated }
ASTScope >> eNDToken: aSmaCCToken [
	eNDToken := aSmaCCToken
]

{ #category : #scope }
ASTScope >> imports [
	^self attributeNamed:#imports ifAbsent:[OrderedCollection new]

]

{ #category : #'generated-initialize-release' }
ASTScope >> initialize [
	super initialize.
	locals := OrderedCollection new: 2.
	announcer := GLMAnnouncer new.
]

{ #category : #scope }
ASTScope >> isFree: aString [

	self lookupHere: aString ifNone:[^(parent lookup: aString) isNotNil].
	
	^false
]

{ #category : #testing }
ASTScope >> isLibrary [
	^false
]

{ #category : #testing }
ASTScope >> isScope [ 
	^true
]

{ #category : #generated }
ASTScope >> locals [
	^ locals
]

{ #category : #generated }
ASTScope >> locals: anOrderedCollection [
	self setParents: self locals to: nil.
	locals := anOrderedCollection.
	self setParents: self locals to: self
]

{ #category : #scope }
ASTScope >> lookup: aString [
	^self lookup: aString ifAbsent:[nil]
]

{ #category : #scope }
ASTScope >> lookup: aString ifAbsent: aBlock [

	^self lookup: aString ifPresent:[:value | value] ifAbsent:aBlock

]

{ #category : #scope }
ASTScope >> lookup: aString ifPresent: aBlock ifAbsent: exceptionBlock [
	^self lookupHere: aString ifFound: aBlock ifNone:[
		self imports reverse detect:[:each | 
			each lookup: aString ifPresent:[true] ifAbsent:[false] ]
		ifFound:[:aLibrary | aLibrary lookup: aString ifPresent:aBlock ifAbsent:[] ] 
		ifNone:[
			parent 
				ifNil:[exceptionBlock value] 
				ifNotNil:[parent lookup: aString ifPresent:aBlock ifAbsent: exceptionBlock] ] ] 
]

{ #category : #scope }
ASTScope >> lookupHere: aString ifFound: aBlock ifNone: exceptionBlock [

	^locals detect: [:each | each name value = aString] ifFound: aBlock ifNone: exceptionBlock

]

{ #category : #scope }
ASTScope >> lookupHere: aString ifNone: aBlock [
	^self lookupHere: aString ifFound:[:x | x] ifNone: aBlock 
			
]

{ #category : #adding }
ASTScope >> makeFunctionNamed: aString [

	| aParser anAST code |

	code := 
'INT FUNCTION ', aString, '()
  RESULT 0
:'.

	aParser := OccamCoreParser on: (ReadStream on: code).
	
	aParser setStartingState: OccamCoreParser startingStateForFunction.
	 
	anAST := aParser parse.
		
	anAST internalizeSource.
	 
	^anAST.	
]

{ #category : #parsing }
ASTScope >> makeProcedureNamed: aString [

	| aParser anAST code |

	code := 
'PROC ', aString, '()
  SKIP
:'.

	aParser := OccamCoreParser on: (ReadStream on: code).
	
	aParser setStartingState: OccamCoreParser startingStateForProcedure.
	 
	anAST := aParser parse.
	
	anAST attributeNamed:#source put: code.
	
	anAST source. "force the calculation of start and end positions"
	
	anAST internalizeSource.
	 
	^anAST.
]

{ #category : #removing }
ASTScope >> moveLocal: anASTNode after: existingNode [ 

	(anASTNode = existingNode) ifTrue:[^self].
		
	anASTNode parent locals remove: anASTNode.
	self locals add: anASTNode after: existingNode.
	
	self check.
	

	
]

{ #category : #scope }
ASTScope >> nestedImports [

	^self abstractionClosure inject: Set new into:[:acc :each | acc addAll: each key imports . acc addAll: each value imports. acc ]
]

{ #category : #scope }
ASTScope >> resolveLibraryPath: anOrderedCollection ifAbsent: aBlock [

	| aScope aStream notFound |
	
	aScope := self.
	notFound := false.
	aStream := ReadStream on: anOrderedCollection.
	
	[ notFound or:[ aStream atEnd ] ]
		whileFalse:[
			aScope simpleLookup: aStream next ifPresent:[ :each | aScope := each ] ifAbsent:[ notFound := true ] 	
		].

	notFound ifTrue:[^aBlock value].
	
	^aScope

]

{ #category : #scope }
ASTScope >> simpleLookup: aString ifPresent: aBlock ifAbsent: exceptionBlock [
	^self lookupHere: aString ifFound: aBlock ifNone:[		
		parent 
			ifNil:[exceptionBlock value] 
			ifNotNil:[parent lookup: aString ifPresent:aBlock ifAbsent: exceptionBlock] ] 

]

{ #category : #streaming }
ASTScope >> streamLocalsOn: aWriteStream [

	aWriteStream open.
	self locals do: [ :each | each streamOn: aWriteStream ] separatedBy:[aWriteStream newLine].

]

{ #category : #generated }
ASTScope >> tokenVariables [
	^ #(#bEGINToken #eNDToken #name #periodToken)
]
