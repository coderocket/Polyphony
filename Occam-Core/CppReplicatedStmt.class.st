Class {
	#name : #CppReplicatedStmt,
	#superclass : #CppStatement,
	#instVars : [
		'index',
		'base',
		'count',
		'body'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppReplicatedStmt >> base: aCppExpr [
	base := aCppExpr
	
]

{ #category : #accessing }
CppReplicatedStmt >> body [
	^body
	
]

{ #category : #accessing }
CppReplicatedStmt >> body: aCppStmt [
	body := aCppStmt

]

{ #category : #tests }
CppReplicatedStmt >> command [ 
	| aReplicatedStatement |
	
	aReplicatedStatement := self copy.
	
	aReplicatedStatement body: aReplicatedStatement body command.

	^aReplicatedStatement 	

]

{ #category : #accessing }
CppReplicatedStmt >> count: aCppExpr [
	count := aCppExpr

]

{ #category : #accessing }
CppReplicatedStmt >> index: aString [
	index := aString

]

{ #category : #streaming }
CppReplicatedStmt >> streamOn: aWriteStream [

	aWriteStream put:'for( int '; put: index; put: ' = '.
	base streamOn: aWriteStream.
	aWriteStream put:'; '; put:index; put: ' != '.
	base streamOn: aWriteStream.
	aWriteStream put: ' + '.
	count streamOn: aWriteStream.
	aWriteStream put:'; ++'; put: index; put:') '.
	aWriteStream put:'{'; open.
	body streamOn: aWriteStream.
	aWriteStream close; put:'}'.

]

{ #category : #tests }
CppReplicatedStmt >> test [ 
	| aReplicatedStatement |
	
	aReplicatedStatement := self copy.
	
	aReplicatedStatement body: aReplicatedStatement body test.

	^aReplicatedStatement 	

]
