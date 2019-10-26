Class {
	#name : #CppBreak,
	#superclass : #CppStatement,
	#category : #'Occam-Core-Cpp'
}

{ #category : #streaming }
CppBreak >> streamOn: aWriteStream [

	aWriteStream put:'break'

]
