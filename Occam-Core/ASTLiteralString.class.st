Class {
	#name : #ASTLiteralString,
	#superclass : #ASTLiteral,
	#instVars : [
		'string'
	],
	#classVars : [
		'specialCharacters'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #'class initialization' }
ASTLiteralString class >> initialize [ 

	"self initialize"
	
	specialCharacters := Dictionary new.
	
	specialCharacters at:$c put: Character cr.
	specialCharacters at:$n put: Character linefeed.
	specialCharacters at:$t put: Character tab.
	specialCharacters at:$s put: Character space.
	specialCharacters at:$' asString put: $'.
	specialCharacters at:$" put: $".
	specialCharacters at:$* put: $*.
	
		

]

{ #category : #generated }
ASTLiteralString >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLiteralString: self
]

{ #category : #'as yet unclassified' }
ASTLiteralString >> cook [
	
	| aWriteStream i s |
	
	aWriteStream := WriteStream on:''.
	
	s := string value copyFrom:2 to: (string value size) - 1.
	
	i := 1.
	[i <= s size]
		whileTrue:[
			((s at:i) = $*)
				ifTrue:[
					i := i + 1.
					aWriteStream nextPut: (specialCharacters at:(s at:i))]
				ifFalse:[
					aWriteStream nextPut: (s at:i)].
			i := i + 1
		].

	^aWriteStream contents.
]

{ #category : #generated }
ASTLiteralString >> string [
	^ string
]

{ #category : #generated }
ASTLiteralString >> string: aSmaCCToken [
	string := aSmaCCToken
]

{ #category : #generated }
ASTLiteralString >> tokenVariables [
	^ #(#string)
]
