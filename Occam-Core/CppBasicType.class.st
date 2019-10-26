Class {
	#name : #CppBasicType,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#classVars : [
		'cppTypes'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #'class initialization' }
CppBasicType class >> initialize [

	"self initialize"
	
	cppTypes := Dictionary new.
	
	cppTypes 
	  at:'BOOL'		put: 'bool'
	; at:'BYTE' 		put: 'byte'
	; at:'INT' 		put: 'int'
	; at:'INT16' 	put: 'int16_t'
	; at:'INT32' 	put: 'int32_t'
	; at:'INT64' 	put: 'int64_t'	
	; at:'REAL32' 	put: 'float'
	; at:'REAL64' 	put: 'double'	
	; at:'TIMER'		put: 'timer_t'
	; at:'TIME'		put:'__time64_t'

]

{ #category : #accessing }
CppBasicType >> name: aString [
	name := aString
]

{ #category : #streaming }
CppBasicType >> streamOn: aWriteStream [

	aWriteStream put: (cppTypes at:name)
]
