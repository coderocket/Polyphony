Class {
	#name : #ASTDirNone,
	#superclass : #ASTDirection,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTDirNone >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitDirNone: self
]

{ #category : #streaming }
ASTDirNone >> streamOn: aWriteStream [

	aWriteStream put:' '
]

{ #category : #accessing }
ASTDirNone >> title [ 
	^''
]
