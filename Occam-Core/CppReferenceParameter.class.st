Class {
	#name : #CppReferenceParameter,
	#superclass : #CppParameter,
	#category : #'Occam-Core-Cpp'
}

{ #category : #'as yet unclassified' }
CppReferenceParameter >> decoration [
	^ '& '
]
