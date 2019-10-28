Class {
	#name : #ASTDyadicExpression,
	#superclass : #ASTExpression,
	#instVars : [
		'left',
		'operator',
		'right'
	],
	#classVars : [
		'arithmeticOperators',
		'bitOperators',
		'booleanOperators',
		'relationalOperators'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #'class initialization' }
ASTDyadicExpression class >> initialize [ 
	"self initialize"
		
	arithmeticOperators := Set new.
 
	arithmeticOperators add: '+' ; add: '-' ; add:'*' ; add:'/'; add:'\'; add: 'REM'.
	
	bitOperators := Set new.
	
	bitOperators add:'/\'; add: '\/'; add: '><'; add: '<<'; add: '>>'.
	
	booleanOperators := Set new.
	
	booleanOperators add:'AND' ; add:'OR'.
	
	relationalOperators := Set new.
	
	relationalOperators add:'='; add: '<>'; add: '<'; add: '>'; add:'>=' ; add:'<=' ; add: 'AFTER' 

]

{ #category : #generated }
ASTDyadicExpression >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitDyadicExpression: self
]

{ #category : #converting }
ASTDyadicExpression >> asString [
	^ '(', self left asString, ' ', self operator value, ' ', self right asString, ')'
]

{ #category : #testing }
ASTDyadicExpression >> ifArithmeticOperator: aBlock [
	(arithmeticOperators includes: operator value)
		ifTrue: [ aBlock value ]
]

{ #category : #testing }
ASTDyadicExpression >> ifBitOperator: aBlock [
	(bitOperators includes: operator value)
		ifTrue: [ aBlock value ]
]

{ #category : #testing }
ASTDyadicExpression >> ifBooleanOperator: aBlock [
	(booleanOperators includes: operator value)
		ifTrue: [ aBlock value ]
]

{ #category : #testing }
ASTDyadicExpression >> ifRelationalOperator: aBlock [
	(relationalOperators includes: operator value)
		ifTrue: [ aBlock value ]
]

{ #category : #generated }
ASTDyadicExpression >> left [
	^ left
]

{ #category : #generated }
ASTDyadicExpression >> left: anASTRoot [
	self left notNil
		ifTrue: [ self left parent: nil ].
	left := anASTRoot.
	self left notNil
		ifTrue: [ self left parent: self ]
]

{ #category : #generated }
ASTDyadicExpression >> nodeVariables [
	^ #(#left #right)
]

{ #category : #generated }
ASTDyadicExpression >> operator [
	^ operator
]

{ #category : #generated }
ASTDyadicExpression >> operator: aSmaCCToken [
	operator := aSmaCCToken
]

{ #category : #generated }
ASTDyadicExpression >> right [
	^ right
]

{ #category : #generated }
ASTDyadicExpression >> right: anASTRoot [
	self right notNil
		ifTrue: [ self right parent: nil ].
	right := anASTRoot.
	self right notNil
		ifTrue: [ self right parent: self ]
]

{ #category : #generated }
ASTDyadicExpression >> tokenVariables [
	^ #(#operator)
]
