Class {
	#name : #ASTBasicType,
	#superclass : #ASTType,
	#instVars : [
		'name'
	],
	#classVars : [
		'integerTypeNames',
		'numericTypeNames'
	],
	#category : #'Occam-Core-AST'
}

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
	
	
]

{ #category : #generated }
ASTBasicType >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitBasicType: self
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
ASTBasicType >> isValidGuardType [
	^self isBooleanType 
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
