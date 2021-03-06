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

{ #category : #initialization }
PartialEvaluator >> initialize [

	state := Dictionary new
]

{ #category : #generated }
PartialEvaluator >> visitAssign: anAssignmentNode [

	| result |

	result := self acceptNode: anAssignmentNode expr.

	anAssignmentNode expr: result.
	
	(anAssignmentNode lvalue isKindOf: ASTVariable)
		ifFalse:[^self]. 
	
	(result isKindOf: ASTLiteralInteger) 
		ifFalse:[^self].
			
	state at: anAssignmentNode lvalue name value put: result.
		

]

{ #category : #generated }
PartialEvaluator >> visitVariable: aVariable [

	state at: aVariable name value 
		ifPresent:[: value |	
				aVariable become: value copy]
		ifAbsent:[
				context lookup: aVariable name value 
					ifPresent:[ :concept | (concept isKindOf: ASTAbbreviation) 
						ifTrue:[ aVariable become: concept expr copy ] ]
					ifAbsent: [ aVariable ] ].

	^aVariable
]
