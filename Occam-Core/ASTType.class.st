Class {
	#name : #ASTType,
	#superclass : #ASTRoot,
	#category : #'Occam-Core-AST'
}

{ #category : #scope }
ASTType >> abstractionClosure [
	^Set new

]

{ #category : #generated }
ASTType >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitType: self
]

{ #category : #'as yet unclassified' }
ASTType >> ifConstant: aBlock [

	(self attributeNamed: #constant ifAbsent:[false])
		ifTrue:[^aBlock value]

]

{ #category : #testing }
ASTType >> isArrayType [
	^false
]

{ #category : #testing }
ASTType >> isBooleanType [
	^false
]

{ #category : #testing }
ASTType >> isInputSource [
	^false
]

{ #category : #testing }
ASTType >> isIntegerType [
	^false
]

{ #category : #testing }
ASTType >> isNumericType [
	^false
]

{ #category : #'as yet unclassified' }
ASTType >> representedType [
	^self

]

{ #category : #'as yet unclassified' }
ASTType >> subsumes: aType [

	^self = aType representedType


]
