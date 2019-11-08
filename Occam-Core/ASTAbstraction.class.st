Class {
	#name : #ASTAbstraction,
	#superclass : #ASTDefinition,
	#instVars : [
		'name',
		'doc',
		'periodToken'
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
ASTAbstraction >> doc [
	^ doc
]

{ #category : #generated }
ASTAbstraction >> doc: anASTDoc [
	self doc notNil
		ifTrue: [ self doc parent: nil ].
	doc := anASTDoc.
	self doc notNil
		ifTrue: [ self doc parent: self ]
]

{ #category : #accessing }
ASTAbstraction >> imports [
	^OrderedCollection new
]

{ #category : #'process graph' }
ASTAbstraction >> inputs [
	^OrderedCollection new

]

{ #category : #'source code' }
ASTAbstraction >> internalizeSource [

]

{ #category : #testing }
ASTAbstraction >> isAbstraction [
	^true
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
ASTAbstraction >> name [
	^ name
]

{ #category : #generated }
ASTAbstraction >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
ASTAbstraction >> nodeVariables [
	^ #(#doc)
]

{ #category : #'process graph' }
ASTAbstraction >> outputs [
	^OrderedCollection new

]

{ #category : #parsing }
ASTAbstraction >> parseParameter: aString [

	| aParser anAST |

	aParser := OccamCoreParser on: (ReadStream on: aString).
	
	aParser setStartingState: OccamCoreParser startingStateForParameter.
	
	anAST := aParser parse.
		
	self params add: anAST.
	
	self check.
]

{ #category : #generated }
ASTAbstraction >> periodToken [
	^ periodToken
]

{ #category : #generated }
ASTAbstraction >> periodToken: aSmaCCToken [
	periodToken := aSmaCCToken
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

{ #category : #streaming }
ASTAbstraction >> streamBodyOn: aWriteStream [

]

{ #category : #streaming }
ASTAbstraction >> streamDocOn: aWriteStream [

	self doc streamOn: aWriteStream.

]

{ #category : #streaming }
ASTAbstraction >> streamLocalsOn: aWriteStream [

]

{ #category : #streaming }
ASTAbstraction >> streamNameOn: aWriteStream [

	aWriteStream put: name value.

]

{ #category : #streaming }
ASTAbstraction >> streamOn: aWriteStream [

	self streamNameOn: aWriteStream.
	self streamParametersOn: aWriteStream.
	self streamDocOn: aWriteStream.
	self streamLocalsOn: aWriteStream.
	self streamBodyOn: aWriteStream.

]

{ #category : #streaming }
ASTAbstraction >> streamParametersOn: aWriteStream [

	aWriteStream put: '('.
	self params do: [ :each | each streamOn: aWriteStream ] separatedBy: [ aWriteStream put:', ' ].
	aWriteStream put: ') '.

]

{ #category : #generated }
ASTAbstraction >> tokenVariables [
	^ #(#name #periodToken)
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
