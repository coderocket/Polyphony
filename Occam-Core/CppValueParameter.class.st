Class {
	#name : #CppValueParameter,
	#superclass : #CppParameter,
	#category : #'Occam-Core-Cpp'
}

{ #category : #public }
CppValueParameter >> decoration [
	^ '& '
]

{ #category : #public }
CppValueParameter >> prologue [
	^'const '
]
