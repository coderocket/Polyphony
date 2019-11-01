Class {
	#name : #PartialEvaluator,
	#superclass : #StaticEvaluator,
	#instVars : [
		'state',
		'frame'
	],
	#category : #'Occam-Core-Compiler'
}

{ #category : #'as yet unclassified' }
PartialEvaluator class >> evaluate: aProcess expanding: aVariableName inContext: aContext [

	| aPartialEvaluator |
	
	aPartialEvaluator := self new.
	
	aPartialEvaluator context: aContext; frame: (Set with: aVariableName).
	
	aPartialEvaluator acceptNode: aProcess.
	
]

{ #category : #accessing }
PartialEvaluator >> frame: aSet [
	frame := aSet
]

{ #category : #initialization }
PartialEvaluator >> initialize [

	state := Dictionary new
]

{ #category : #generated }
PartialEvaluator >> visitAssign: anAssignmentNode [

	| result |

	result := self acceptNode: anAssignmentNode expr.

	(anAssignmentNode lvalue isKindOf: ASTVariable)
		ifFalse:[^self]. 
	
	(frame includes: anAssignmentNode lvalue name value)
		ifFalse:[^self].

	(result isKindOf: ASTLiteralInteger) 
		ifFalse:[^self].
			
	state at: anAssignmentNode lvalue name value put: result.
		

]

{ #category : #generated }
PartialEvaluator >> visitDyadicExpression: aDyadicExpression [

	| result |
	
	result := super visitDyadicExpression: aDyadicExpression.
	
	(result isKindOf: ASTLiteralInteger)
		ifTrue:[aDyadicExpression become: result].

	^result.
]

{ #category : #generated }
PartialEvaluator >> visitVariable: aVariable [

	state at: aVariable name value 
		ifPresent:[: value |	
				aVariable become: value copy].
				
	^aVariable

]
