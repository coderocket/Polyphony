Class {
	#name : #StaticEvaluator,
	#superclass : #ASTRootVisitor,
	#instVars : [
		'context'
	],
	#category : #'Occam-Core-Compiler'
}

{ #category : #'as yet unclassified' }
StaticEvaluator class >> evaluate: anASTNode inContext: aScope [

	| aStaticEvaluator |
	
	aStaticEvaluator := StaticEvaluator new.
	
	aStaticEvaluator context: aScope.
	
	^aStaticEvaluator acceptNode: anASTNode

]

{ #category : #accessing }
StaticEvaluator >> context: aScope [
	context := aScope

]

{ #category : #generated }
StaticEvaluator >> visitAbbreviation: anAbbrev [

	^ self acceptNode: anAbbrev expr
	

]

{ #category : #generated }
StaticEvaluator >> visitArrayComponent: anArrayComponent [

	anArrayComponent array: (self acceptNode: anArrayComponent array).
	
	anArrayComponent expr: (self acceptNode: anArrayComponent expr).
	
	^anArrayComponent 
]

{ #category : #generated }
StaticEvaluator >> visitDyadicExpression: aDyadicExpression [

	| left right operator x y |
	
	left := self acceptNode: aDyadicExpression left.
	
	(left isKindOf: ASTLiteralInteger)
		ifFalse:[^ aDyadicExpression ].
		
	right := self acceptNode: aDyadicExpression right.

	(right isKindOf: ASTLiteralInteger)
		ifFalse:[^ aDyadicExpression ].
	
	operator := aDyadicExpression operator value.
	
	x := left integer value asInteger.
	
	y := right integer value asInteger.
	
	(operator = '+')
		ifTrue:[^ASTLiteralInteger fromInteger: x + y].
	(operator = '-')
		ifTrue:[^ASTLiteralInteger fromInteger: x * y].
	(operator = '*')
		ifTrue:[^ASTLiteralInteger fromInteger: x * y].
	(operator = '/')
		ifTrue:[^ASTLiteralInteger fromInteger: x / y].
	(operator = '\')
		ifTrue:[^ASTLiteralInteger fromInteger: (x rem: y)].
	(operator = 'REM')
		ifTrue:[^ASTLiteralInteger fromInteger: (x rem: y)].
	 
	^aDyadicExpression

]

{ #category : #generated }
StaticEvaluator >> visitMonadicExpression: aMonadicExpression [

	| expr operator |
	
	expr := self acceptNode: aMonadicExpression expr.
	
	operator := aMonadicExpression operator value.
	
	(operator = '-')
		ifTrue:[^ expr negate].
	
	^aMonadicExpression

]

{ #category : #generated }
StaticEvaluator >> visitParenthesisExpression: aParenthesisExpression [

	^self acceptNode: aParenthesisExpression expression
]

{ #category : #generated }
StaticEvaluator >> visitVariable: aVariable [

	^self acceptNode: (context lookup: aVariable name value).


]
