Class {
	#name : #ASTLValue,
	#superclass : #ASTOperand,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTLValue >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLValue: self
]

{ #category : #testing }
ASTLValue >> contains: anASTLValue [
	^self = anASTLValue

]

{ #category : #testing }
ASTLValue >> isLValue [
	^true
]
