Class {
	#name : #MemoryLayoutMorph,
	#superclass : #BorderedMorph,
	#instVars : [
		'model'
	],
	#category : #'Occam-Core-Browser'
}

{ #category : #drawing }
MemoryLayoutMorph >> drawOn: aCanvas [
	
	| tl acc |
	
	acc := 0.
	tl := self innerBounds topLeft.
	
	model cells do:[:each | | aRectangle |
		  
		aRectangle := tl extent: (each value * self innerBounds width @ self innerBounds height).
		aCanvas fillRectangle: aRectangle color: each key. 
		aCanvas frameRectangle: aRectangle width: 1 color: (Color gray:0.5).
		
		acc := acc + (each value * self innerBounds width).	
		tl := self innerBounds topLeft + (acc @ 0)
	]
]

{ #category : #accessing }
MemoryLayoutMorph >> model: anObject [

	model ifNotNil:[model removeDependent: self].
	
	model := anObject.
	
	model ifNotNil:[model addDependent: self].
]

{ #category : #updating }
MemoryLayoutMorph >> update: anObject [

	self changed.
]
