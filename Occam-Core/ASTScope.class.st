Class {
	#name : #ASTScope,
	#superclass : #ASTRoot,
	#instVars : [
		'name',
		'doc',
		'periodToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTScope >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitScope: self
]

{ #category : #adding }
ASTScope >> addDependency: anASTLibrary [
	self imports add: anASTLibrary

]

{ #category : #scope }
ASTScope >> allAbstractions [
	^self subclassResponsibility 
]

{ #category : #scope }
ASTScope >> callsProcedureNamed: aString [
	^false

]

{ #category : #generated }
ASTScope >> doc [
	^ doc
]

{ #category : #generated }
ASTScope >> doc: anASTDoc [
	self doc notNil
		ifTrue: [ self doc parent: nil ].
	doc := anASTDoc.
	self doc notNil
		ifTrue: [ self doc parent: self ]
]

{ #category : #documentation }
ASTScope >> documentation [
	self doc ifNil:[
		self doc: (ASTDoc new text: (SmaCCToken value:'Nothing yet.'))
	].
	^self doc text value
]

{ #category : #documentation }
ASTScope >> documentation: aString [

	self doc ifNil:[
		self doc: (ASTDoc new text: (SmaCCToken value:'Nothing yet.'))
	].

	self doc text: (SmaCCToken value: aString)
 
]

{ #category : #scope }
ASTScope >> imports [
	^self attributeNamed:#imports ifAbsent:[OrderedCollection new]

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
		ifFound:[:aLibrary | aLibrary lookup: aString ] 
		ifNone:[
			parent 
				ifNil:[exceptionBlock value] 
				ifNotNil:[parent lookup: aString ifPresent:aBlock ifAbsent: exceptionBlock] ] ] 
]

{ #category : #scope }
ASTScope >> lookupHere: aString ifFound: aBlock ifNone: exceptionBlock [

	^self subclassResponsibility 
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
		
	anAST attributeNamed: #localSource put: code.
	 
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
		
	anAST attributeNamed: #localSource put: code.
	 
	^anAST.	
]

{ #category : #generated }
ASTScope >> name [
	^ name
]

{ #category : #generated }
ASTScope >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #scope }
ASTScope >> nestedImports [

	^self abstractionClosure inject: Set new into:[:acc :each | acc addAll: each key imports . acc addAll: each value imports. acc ]
]

{ #category : #generated }
ASTScope >> nodeVariables [
	^ #(#doc)
]

{ #category : #generated }
ASTScope >> periodToken [
	^ periodToken
]

{ #category : #generated }
ASTScope >> periodToken: aSmaCCToken [
	periodToken := aSmaCCToken
]

{ #category : #adding }
ASTScope >> removeDependency: anASTLibrary [
	self imports remove: anASTLibrary

]

{ #category : #scope }
ASTScope >> resolveImports [

	self attributeNamed:#imports put: (self uses collect:[:each | self resolveLibraryPath: (each names collect:[:token | token value]) ifAbsent:[each addViolation: 'Undefined library'] ])
	 
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

{ #category : #generated }
ASTScope >> tokenVariables [
	^ #(#name #periodToken)
]
