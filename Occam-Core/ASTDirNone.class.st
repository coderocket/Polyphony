Class {
	#name : #ASTDirNone,
	#superclass : #ASTDirection,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTDirNone >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitDirNone: self
]

{ #category : #accessing }
ASTDirNone >> title [ 
	^''
]
