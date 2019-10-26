Class {
	#name : #CppForLoop,
	#superclass : #CppStatement,
	#instVars : [
		'indexName',
		'indexType',
		'base',
		'count',
		'body'
	],
	#category : #'Occam-Core-Cpp'
}

{ #category : #accessing }
CppForLoop >> base: aCppExpr [
	base := aCppExpr

]

{ #category : #accessing }
CppForLoop >> body: aCppStmt [
	body := aCppStmt

]

{ #category : #accessing }
CppForLoop >> count: aCppExpr [
	count := aCppExpr

]

{ #category : #accessing }
CppForLoop >> indexName: aString [
	indexName := aString

]

{ #category : #accessing }
CppForLoop >> indexType: aCppType [ 
	indexType := aCppType

]

{ #category : #streaming }
CppForLoop >> streamOn: aWriteStream [

	aWriteStream put:'for ('.
	indexType streamOn: aWriteStream.
	aWriteStream put: ' ' ; put: indexName; put: ' = '.
	base streamOn: aWriteStream.
	aWriteStream put: '; '.

	aWriteStream put: indexName; put: ' != '.
	base streamOn: aWriteStream.
	aWriteStream put: ' + '.
	count streamOn: aWriteStream.
	aWriteStream put: '; '.
	
	aWriteStream put:'++'; put:indexName ; put:')'; newLine.
	
	aWriteStream put:'{'; open.
	body streamOn: aWriteStream.
	aWriteStream close; put:'}'.


]
