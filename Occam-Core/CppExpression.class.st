Class {
	#name : #CppExpression,
	#superclass : #Object,
	#category : #'Occam-Core-Cpp'
}

{ #category : #converting }
CppExpression >> asSequence [ 
	
	^CppSequence new add:self
	
]

{ #category : #tests }
CppExpression >> input [
	^CppSequence new
]

{ #category : #'as yet unclassified' }
CppExpression >> promoteToInputGuard [

	^CppInputGuard new test: self ; input: nil
]

{ #category : #tests }
CppExpression >> test [
	^self
	
]
