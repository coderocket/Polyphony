Class {
	#name : #CppDefinition,
	#superclass : #Object,
	#instVars : [
		'type',
		'name',
		'args'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #'as yet unclassified' }
CppDefinition class >> processNamed: aString [

	| aVariable |
	
	aVariable := CppVariable new name: aString.
	
	^CppDefinition new 
		type: (CppTemplateType new 
					name:'process_t'; type: (CppCall new name: 'decltype'; addArgument: aVariable))
		; name: 'p_', aString 
		; addArgument: aVariable
]

{ #category : #accessing }
CppDefinition >> addArgument: aString [
	args add: aString
]

{ #category : #accessing }
CppDefinition >> initialize [
	args := OrderedCollection new
]

{ #category : #accessing }
CppDefinition >> name [
	^name
]

{ #category : #accessing }
CppDefinition >> name: aString [
	name := aString
]

{ #category : #streaming }
CppDefinition >> streamOn: aWriteStream [

	type streamOn: aWriteStream.
	
	aWriteStream put:' '; put: name.
	
	args ifNotEmpty: [  
		
		aWriteStream put:'('.
	
		args do:[:each | each streamOn: aWriteStream ] separatedBy: [ aWriteStream put:', ' ].
	
		aWriteStream put:')' ].
	
	aWriteStream put:';' ; newLine.
	
]

{ #category : #accessing }
CppDefinition >> type: aCppDatatype [

	type:= aCppDatatype 
]
