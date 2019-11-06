Class {
	#name : #ASTLiteral,
	#superclass : #ASTOperand,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTLiteral >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLiteral: self
]
