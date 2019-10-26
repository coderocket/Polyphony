Class {
	#name : #ASTTimerType,
	#superclass : #ASTInputSourceType,
	#instVars : [
		'tIMERToken'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTTimerType >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitTimerType: self
]

{ #category : #generated }
ASTTimerType >> tIMERToken [
	^ tIMERToken
]

{ #category : #generated }
ASTTimerType >> tIMERToken: aSmaCCToken [
	tIMERToken := aSmaCCToken
]

{ #category : #generated }
ASTTimerType >> tokenVariables [
	^ #(#tIMERToken)
]

{ #category : #accessing }
ASTTimerType >> type [
	^ASTBasicType new name:(SmaCCToken value:'TIME')

]
