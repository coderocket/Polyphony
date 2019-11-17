Class {
	#name : #InternalizeSource,
	#superclass : #ASTRootVisitor,
	#category : #'Occam-Core-Compiler'
}

{ #category : #generated }
InternalizeSource >> visitAbstraction: anAbstraction [

	anAbstraction isExternal ifTrue:[^self].

	anAbstraction locals do:[:each | self acceptNode: each].
			
	anAbstraction internalizeSource
]

{ #category : #generated }
InternalizeSource >> visitLibrary: aLibrary [

	aLibrary members do:[:each | self acceptNode: each].
			
	aLibrary internalizeSource
]
