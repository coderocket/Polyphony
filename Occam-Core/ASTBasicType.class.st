Class {
	#name : #ASTBasicType,
	#superclass : #ASTType,
	#instVars : [
		'name'
	],
	#classVars : [
		'integerTypeNames',
		'leastUpperBound',
		'numericTypeNames',
		'partialOrder'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #'as yet unclassified' }
ASTBasicType class >> computeLeastUpperBound [

	| basicTypeNames |
	
	basicTypeNames := { 'BYTE' . 'INT16' . 'INT' . 'INT32' . 'INT64' . 'TIME' . 'REAL32' . 'REAL64' . '-|-' }.
	
	leastUpperBound := Dictionary new.

	basicTypeNames do: [ :each | 
		basicTypeNames do: [:other | 
			leastUpperBound at: each -> other put: '-|-' 
		] 
	].
	
	basicTypeNames do: [ :each |
		basicTypeNames do: [ :other | 
			basicTypeNames do: [ :candidate | 
				((partialOrder includes: each -> candidate) and:[ (partialOrder includes: other -> candidate) and:[ partialOrder includes: candidate -> (leastUpperBound at: each -> other) ] ]) ifTrue:[ leastUpperBound at: each -> other put: candidate ]
				] ] ].
	
 
]

{ #category : #'error handling' }
ASTBasicType class >> errorType [

	^ASTBasicType new name: (SmaCCToken value:'ERROR')
]

{ #category : #'class initialization' }
ASTBasicType class >> initialize [ 

	"self initialize"
	
	integerTypeNames := Set new.
	
	integerTypeNames add: 'BYTE' ; add:'INT'; add:'INT16' ; add:'INT32'; add:'INT64'; add:'TIME'.
	
	numericTypeNames := Set new.
	
	numericTypeNames addAll: integerTypeNames.
	
	numericTypeNames add: 'REAL32'; add:'REAL64'.
	
	partialOrder := Set new.
	
	{ 'BYTE' . 'INT16' . 'INT' . 'INT32' . 'INT64' . 'TIME' . 'REAL32' . 'REAL64' . '-|-'  } 
	do:[:each | partialOrder add: 'BYTE' -> each ].
	
	{ 'INT16' . 'INT' . 'INT32' . 'INT64' . 'TIME' . 'REAL32' . 'REAL64' . '-|-'  } 
	do:[:each | partialOrder add: 'INT16' -> each ].

	{ 'INT' . 'INT32' . 'INT64' . 'TIME' . 'REAL32' . 'REAL64' . '-|-'  } 
	do:[:each | partialOrder add: 'INT' -> each ].

	{ 'INT32' . 'INT64' . 'TIME' . 'REAL32' . 'REAL64' . '-|-'  } 
	do:[:each | partialOrder add: 'INT32' -> each ].
			
	{ 'INT64' . 'TIME' . 'REAL64' . '-|-'  } 
	do:[:each | partialOrder add: 'INT64' -> each ].

	partialOrder add:'TIME' -> 'TIME' ; add: 'TIME' -> '-|-'.

	partialOrder add: 'REAL32' -> 'REAL32'; add: 'REAL32' -> 'REAL64'; add: 'REAL32' -> '-|-'.

	partialOrder add: 'REAL64' -> 'REAL64'; add: 'REAL64' -> '-|-'.
	
	partialOrder add: '-|-' -> '-|-'. "not a real Occam type but useful for computing the lub"
	
	self computeLeastUpperBound
]

{ #category : #generated }
ASTBasicType >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitBasicType: self
]

{ #category : #testing }
ASTBasicType >> isBigEnoughToHold: aType [

	^(aType isKindOf: self class) and:
	[partialOrder includes: aType name value -> name value]
	
]

{ #category : #testing }
ASTBasicType >> isBooleanType [
	^name value = 'BOOL'
]

{ #category : #testing }
ASTBasicType >> isIntegerType [
	^integerTypeNames includes: name value
]

{ #category : #testing }
ASTBasicType >> isNumericType [
	^numericTypeNames includes: name value
]

{ #category : #testing }
ASTBasicType >> isTop [ 
	^name value = '-|-'
]

{ #category : #testing }
ASTBasicType >> isValidGuardType [
	^self isBooleanType 
]

{ #category : #'as yet unclassified' }
ASTBasicType >> leastUpperBound: anASTBasicType [

	^ASTBasicType new name: (SmaCCToken value: (leastUpperBound at: name value -> anASTBasicType name value))
	
]

{ #category : #generated }
ASTBasicType >> name [
	^ name
]

{ #category : #generated }
ASTBasicType >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
ASTBasicType >> tokenVariables [
	^ #(#name)
]
