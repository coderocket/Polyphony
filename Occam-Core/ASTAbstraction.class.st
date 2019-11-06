Class {
	#name : #ASTAbstraction,
	#superclass : #ASTScope,
	#instVars : [
		'leftParenToken',
		'params',
		'commaTokens',
		'rightParenToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #scope }
ASTAbstraction >> abstractionClosure [

	^Set new

]

{ #category : #generated }
ASTAbstraction >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitAbstraction: self
]

{ #category : #scope }
ASTAbstraction >> allAbstractions [

	^OrderedCollection with: self
]

{ #category : #generated }
ASTAbstraction >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
ASTAbstraction >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
ASTAbstraction >> compositeNodeVariables [
	^ #(#params)
]

{ #category : #generated }
ASTAbstraction >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #'generated-initialize-release' }
ASTAbstraction >> initialize [
	super initialize.
	params := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #'process graph' }
ASTAbstraction >> inputs [
	^OrderedCollection new

]

{ #category : #testing }
ASTAbstraction >> isClosed [
	^false
]

{ #category : #testing }
ASTAbstraction >> isExternal [ 
	^false
]

{ #category : #testing }
ASTAbstraction >> isSiblingOf: anASTAbstraction [

	^self parent = anASTAbstraction parent
	
]

{ #category : #testing }
ASTAbstraction >> isUploadable [

	^(self isClosed) and:[self isValid]
]

{ #category : #testing }
ASTAbstraction >> isValid [ 

	^self violations isEmpty
]

{ #category : #generated }
ASTAbstraction >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
ASTAbstraction >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
ASTAbstraction >> localAbbrevs [ 

	^self locals select:[:each | each isKindOf: ASTAbbreviation  ]
]

{ #category : #'as yet unclassified' }
ASTAbstraction >> localVariables [

	^self locals select:[:each | each isKindOf: ASTDataType ]
]

{ #category : #generated }
ASTAbstraction >> locals [
	^self subclassResponsibility 
	
]

{ #category : #removing }
ASTAbstraction >> moveLocal: anASTNode after: existingNode [ 

	(anASTNode = existingNode) ifTrue:[^self].
		
	self locals remove: anASTNode.
	self locals add: anASTNode after: existingNode.
	
	self check.
	

	
]

{ #category : #removing }
ASTAbstraction >> moveParam: anASTNode after: existingNode [ 

	(anASTNode = existingNode) ifTrue:[^self].
		
	self params remove: anASTNode.
	self params add: anASTNode after: existingNode.
	
	self check.
	

	
]

{ #category : #'process graph' }
ASTAbstraction >> outputs [
	^OrderedCollection new

]

{ #category : #generated }
ASTAbstraction >> params [
	^ params
]

{ #category : #generated }
ASTAbstraction >> params: anOrderedCollection [
	self setParents: self params to: nil.
	params := anOrderedCollection.
	self setParents: self params to: self
]

{ #category : #parsing }
ASTAbstraction >> parseBody: aString [

	| aParser anAST |

	aParser := OccamCoreParser on: (ReadStream on: aString).
	
	aParser setStartingState: OccamCoreParser startingStateForProcess.
		
	anAST := aParser parse.

	"once we have successfully parsed the string we replace the body with the resulting ast and
	set its localsource to the text."
	
	anAST attributeNamed: #localSource put: aString.
	 
	self body: anAST.
	self check.
]

{ #category : #parsing }
ASTAbstraction >> parseLocalAbbrev: aString [

	| aParser anAST |

	aParser := OccamCoreParser on: (ReadStream on: aString).
	
	aParser setStartingState: OccamCoreParser startingStateForAbbreviation. 
	 
	anAST := aParser parse.
		
	anAST attributeNamed: #localSource put: aString.

	TypeChecker check: anAST inContext: self.
	
	self locals add: anAST.
	anAST parent: self.
	
	self check
]

{ #category : #parsing }
ASTAbstraction >> parseLocalVariable: aString [

	| aParser anAST |

	aParser := OccamCoreParser on: (ReadStream on: aString).
	
	aParser setStartingState: OccamCoreParser startingStateForDataType.
	 
	anAST := aParser parse.
		
	anAST attributeNamed: #localSource put: aString.
 
	self locals add: anAST.
	anAST parent: self.
	
	self check.
]

{ #category : #parsing }
ASTAbstraction >> parseParameter: aString [

	| aParser anAST |

	aParser := OccamCoreParser on: (ReadStream on: aString).
	
	aParser setStartingState: OccamCoreParser startingStateForParameter.
	
	anAST := aParser parse.
		
	anAST attributeNamed: #localSource put: aString.
	 
	self params add: anAST.
	
	self check.
]

{ #category : #removing }
ASTAbstraction >> removeLocal: anASTNode [
	self locals remove: anASTNode.
	
	self check.
	
]

{ #category : #removing }
ASTAbstraction >> removeParameter: anASTNode [

	self params remove: anASTNode.
	self check.	
]

{ #category : #operations }
ASTAbstraction >> renameTo: aString [

	self name: (SmaCCToken value: aString)

]

{ #category : #generated }
ASTAbstraction >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
ASTAbstraction >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #streaming }
ASTAbstraction >> streamOn: aWriteStream [

	aWriteStream put: name value ; put: '('.
	params do: [ :each | each streamOn: aWriteStream ] separatedBy: [ aWriteStream put:', ' ].
	aWriteStream put: ') '.
	self doc streamOn: aWriteStream.

]

{ #category : #generated }
ASTAbstraction >> tokenVariables [
	^ #(#leftParenToken #rightParenToken #name #periodToken)
]

{ #category : #api }
ASTAbstraction >> topologicSort: aRelation [

	"Topologically sort the used abstractions according to the dependencies in the usedRelation"
	
	| sorted independent current todo |

	sorted := OrderedCollection new.
	
	current := aRelation copy.

	todo := current inject:(Set with:self) into:[:acc :each | acc add:each key; add: each value. acc].

	"take all the abstractions that may have no dependencies and remove from them all those that do have dependencies. the result is a set of abstractions that have no dependencies in the relation. "
	independent := (current collect:[:each | each key]) 
		reject:[ :each | current detect:[:other | each = other value ] ifFound:[true] ifNone:[false] ].
		
	[independent isEmpty]
		whileFalse:[
			"add them to the sorted list."
			sorted addAll: independent.
			" remove the independent abstractions from the relation "
			todo removeAll: independent.
			current := current reject:[:each | independent includes: each key ].
			
			independent := (current collect:[:each | each key]) reject:[ :each | current detect:[:other | each = other value ] ifFound:[true] ifNone:[false] ].
		].
		
	current ifNotEmpty:[self error: 'Cyclic dependencies'].
	
	 "finally, add all the abstractions still left in the todo set"
	sorted addAll: todo.
	^sorted
]

{ #category : #'type checking' }
ASTAbstraction >> typeCheckCall: aCallNode with: aTypeChecker [

	aCallNode exprs with: self params do: [ :eachArg :eachParam |
		eachParam typecheck: eachArg with: aTypeChecker ].

	
]
