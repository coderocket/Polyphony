Class {
	#name : #OccamTextMorph,
	#superclass : #RubScrolledTextMorph,
	#category : #'Occam-Core-Browser'
}

{ #category : #'initialize-release' }
OccamTextMorph >> textAreaClass [
	^ OccamEditingArea
]

{ #category : #'event handling' }
OccamTextMorph >> whenKeystrokeInTextArea: anAnnouncement [ 
	self announcer announce: (anAnnouncement copy morph: self)
]

{ #category : #'event handling' }
OccamTextMorph >> whenReturnEnteredInTextArea: anAnnouncement [
	anAnnouncement morph: self.
	self announcer announce: anAnnouncement
]
