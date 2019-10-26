Class {
	#name : #ASTDirection,
	#superclass : #ASTRoot,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTDirection >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitDirection: self
]

{ #category : #'process graph' }
ASTDirection >> addTo: aSet ifInput: aString [

]

{ #category : #'process graph' }
ASTDirection >> addTo: aSet ifOutput: aString [

]

{ #category : #accessing }
ASTDirection >> title [ 
	^self subclassResponsibility 
]
