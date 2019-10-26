Class {
	#name : #CppAlt,
	#superclass : #CppStatement,
	#instVars : [
		'tests',
		'commands'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppAlt >> commands: anOrderedCollection [
	commands := anOrderedCollection
	
]

{ #category : #streaming }
CppAlt >> streamOn: aWriteStream [

	aWriteStream put: 'bool data_ready = false;'; newLine.
	
	aWriteStream put: 'while (!data_ready) {'; open; newLine.
	aWriteStream put:'machine_yield();' ; newLine.
	
	tests do:[:each | 
		each streamOn: aWriteStream. aWriteStream put:';'; newLine ]. 
	aWriteStream close; put:'}' ; newLine.

	aWriteStream put: 'bool data_taken = false;'; newLine.
	
	commands do:[:each | each streamOn: aWriteStream ].

]

{ #category : #accessing }
CppAlt >> tests: anOrderedCollection [
	tests := anOrderedCollection
	
]
