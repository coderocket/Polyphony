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

{ #category : #violations }
ASTRoot >> clearViolations [

	(self attributeNamed: #violations) ifNotNil:[ :a | a removeAll].

	self children do:[:each | each clearViolations ]

]

{ #category : #'source code' }
ASTRoot >> completeLocalSource [

	^self attributeNamed: #localSource ifAbsent:[parent 
																ifNil:[self source] 
																ifNotNil:[parent completeLocalSource]]
	
]

{ #category : #'source code' }
ASTRoot >> computeOffsetIn: aString [

	| index offset |
	
	offset := 0.
	index := self startPosition - 1.
	[ (index > 0) and:[(aString at:index) ~~ Character cr] ]
		whileTrue:[ 
			index := index - 1 . 
			offset := offset + 1 ].

	^offset
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

	^self completeLocalSource 
		ifNotNil:[ :value | | indentLevel s t |
			indentLevel := self computeOffsetIn: value.
			s := Character cr asString, (' ' repeat: indentLevel).
			t := (value copyFrom: (self startPosition max:1) to: (self stopPosition min: value size)) asString.
			t copyReplaceAll: s with: Character cr asString]
]

{ #category : #streaming }
ASTRoot >> streamOn: aWriteStream [
	^self subclassResponsibility 
	
]

{ #category : #'source code' }
ASTRoot >> title [

	self localSource ifNil:[^self class asString].
	
	^(self localSource copyWithoutAll: String cr) takeFirst:8

	
]

{ #category : #testing }
ASTRoot >> violations [ 

	| aSet |
	
	aSet := Set new.
	
	self children do:[:each | aSet addAll: each violations ].
	
	(aSet isEmpty)
		ifFalse:[^aSet].
		

	aSet addAll: (self attributeNamed: #violations ifAbsent:[Set new]).
	
	^aSet
]
