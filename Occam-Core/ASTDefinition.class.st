Class {
	#name : #ASTDefinition,
	#superclass : #ASTRoot,
	#category : #'Occam-Core-AST'
}

{ #category : #testing }
ASTDefinition >> isAbstraction [
	^false
]

{ #category : #testing }
ASTDefinition >> isCallable [
	^false
]

{ #category : #testing }
ASTDefinition >> isScope [
	^false
]

{ #category : #accessing }
ASTDefinition >> type [
	^self subclassResponsibility 
]
