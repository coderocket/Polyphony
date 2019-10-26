Class {
	#name : #ASTInputSourceType,
	#superclass : #ASTType,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTInputSourceType >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitInputSourceType: self
]

{ #category : #testing }
ASTInputSourceType >> isInputSource [
	^true
]

{ #category : #accessing }
ASTInputSourceType >> type [
	^self subclassResponsibility 
]
