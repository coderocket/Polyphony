Class {
	#name : #ASTRoot,
	#superclass : #SmaCCParseNode,
	#category : #'Occam-Core-AST'
}

{ #category : #generated }
ASTRoot >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitRoot: self
]

{ #category : #violations }
ASTRoot >> addViolation: aString [

	(self attributeNamed: #violations) add: (Violation new reason: aString; startPosition: self startPosition; stopPosition: self stopPosition) 
]

{ #category : #converting }
ASTRoot >> asString [ 	
	
	| anIndentedPrinterStream |
	
	anIndentedPrinterStream := IndentedPrinterStream new.
	
	self streamOn: anIndentedPrinterStream.
	
	^anIndentedPrinterStream contents
]

{ #category : #violations }
ASTRoot >> clearViolations [

	(self attributeNamed: #violations) ifNotNil:[ :a | a removeAll].

	self children do:[:each | each clearViolations ]

]

{ #category : #copying }
ASTRoot >> copyTree [

	| copy |
	
	copy := self class new.
	
	self tokenVariables
		do:
			[ :selector | 
			copy
				perform: (self convertToSetter: selector)
				with: ((self perform: selector) shallowCopy) ].
			
	self nodeVariables
		do:
			[ :selector | 
			copy
				perform: (self convertToSetter: selector)
				with: ((self perform: selector) ifNotNil:[:x | x copyTree]) ].
			
	self compositeTokenVariables
		do:
			[ :selector | 
			copy
				perform: (self convertToSetter: selector)
				with:
					((self perform: selector)
						collect: [ :each | each shallowCopy ]) ].

	self compositeNodeVariables
		do:
			[ :selector | 
			copy
				perform: (self convertToSetter: selector)
				with:
					((self perform: selector)
						collect: [ :each | each copyTree ]) ].
					
	self attributes associations
		do: [ :each | copy attributeNamed: each key put: each value ].
		
	^ copy	
]

{ #category : #initialization }
ASTRoot >> initialize [ 
	
	self attributeNamed: #violations put:OrderedCollection new
]

{ #category : #testing }
ASTRoot >> isInvalid [ 
	
	^(self attributeNamed: #violations) isNotEmpty 
]

{ #category : #testing }
ASTRoot >> isLocked [ 
	^ parent ifNil:[^false] ifNotNil:[parent isLocked]
	
]

{ #category : #'source code' }
ASTRoot >> localSource [

	^self attributeNamed: #localSource

]

{ #category : #'as yet unclassified' }
ASTRoot >> memoryFootprintIn: aPlatform inContext: aContext [

	^0
	
]

{ #category : #streaming }
ASTRoot >> streamOn: aWriteStream [
	^self subclassResponsibility 
	
]

{ #category : #violations }
ASTRoot >> violations [ 
 
	| aSet |
	
	aSet := Set new.
	
	self children do:[:each | aSet addAll: each violations ].
	
	(aSet isEmpty)
		ifFalse:[^aSet].
		

	aSet addAll: (self attributeNamed: #violations ifAbsent:[Set new]).
	
	^aSet
]

{ #category : #violations }
ASTRoot >> violationsAsString [ 
	
	| aWriteStream |
	
	aWriteStream := WriteStream on:''.
	
	self violations do:[:each | aWriteStream nextPutAll: each reason ] separatedBy:[ aWriteStream nextPutAll:', '].
	 
	^aWriteStream contents

]
