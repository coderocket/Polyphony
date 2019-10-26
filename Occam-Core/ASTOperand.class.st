Class {
	#name : #ASTOperand,
	#superclass : #ASTExpression,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTOperand >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitOperand: self
]
