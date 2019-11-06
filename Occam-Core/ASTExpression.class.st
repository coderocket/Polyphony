Class {
	#name : #ASTExpression,
	#superclass : #ASTRoot,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTExpression >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitExpression: self
]

{ #category : #accessing }
ASTExpression >> input [ 
	^ASTSkip new 
]

{ #category : #testing }
ASTExpression >> isLValue [
	^false
]
