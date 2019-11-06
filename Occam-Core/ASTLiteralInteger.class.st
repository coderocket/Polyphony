Class {
	#name : #ASTLiteralInteger,
	#superclass : #ASTLiteral,
	#instVars : [
		'integer'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #'instance creation' }
ASTLiteralInteger class >> fromInteger: anInteger [

	^self new integer: (SmaCCToken value: anInteger asString)
]

{ #category : #generated }
ASTLiteralInteger >> acceptVisitor: aRootVisitor [
	^ aRootVisitor visitLiteralInteger: self
]

{ #category : #generated }
ASTLiteralInteger >> integer [
	^ integer
]

{ #category : #generated }
ASTLiteralInteger >> integer: aSmaCCToken [
	integer := aSmaCCToken
]

{ #category : #streaming }
ASTLiteralInteger >> streamOn: aWriteStream [

	aWriteStream put: integer value

]

{ #category : #generated }
ASTLiteralInteger >> tokenVariables [
	^ #(#integer)
]
