Class {
	#name : #CppSequence,
	#superclass : #CppStatement,
	#instVars : [
		'statements'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #initialization }
CppSequence >> add: aStatement [
	statements add: aStatement
]

{ #category : #initialization }
CppSequence >> initialize [
	statements := OrderedCollection new
]

{ #category : #streaming }
CppSequence >> streamOn: aWriteStream [

	statements do:[:each | each streamOn: aWriteStream. aWriteStream put:';'] separatedBy:[ aWriteStream newLine].
]
