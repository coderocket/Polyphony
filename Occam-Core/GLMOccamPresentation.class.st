Class {
	#name : #GLMOccamPresentation,
	#superclass : #GLMRubricTextPresentation,
	#category : #'Occam-Core-Browser'
}

{ #category : #rendering }
GLMOccamPresentation >> renderGlamorouslyOn: aRenderer [ 
	self registerAnnouncements.	
	^ GLMMorphicRubricOccamRenderer render: self from: aRenderer 
]
