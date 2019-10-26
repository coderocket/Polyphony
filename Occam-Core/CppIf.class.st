Class {
	#name : #CppIf,
	#superclass : #CppStatement,
	#instVars : [
		'tests',
		'stmts'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppIf >> stmt: aCppStmt [

	stmts := OrderedCollection with: aCppStmt
]

{ #category : #accessing }
CppIf >> stmts: anOrderedCollection [

	stmts := anOrderedCollection 
]

{ #category : #streaming }
CppIf >> streamOn: aWriteStream [

	tests with: stmts do:[:test :stmt | 
		aWriteStream put: 'if' ; put:'('. test streamOn: aWriteStream. aWriteStream put:')'; put:'{'; open. 
			stmt streamOn: aWriteStream. 
		aWriteStream close ; put: '}' ] separatedBy: [ aWriteStream put:' else ' ].
]

{ #category : #accessing }
CppIf >> test: aCppExpr [

	tests := OrderedCollection with: aCppExpr
]

{ #category : #accessing }
CppIf >> tests: anOrderedCollection [

	tests := anOrderedCollection 
]
