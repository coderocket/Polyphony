Class {
	#name : #OccamEditingArea,
	#superclass : #RubEditingArea,
	#category : #'Occam-Core-Browser'
}

{ #category : #accessing }
OccamEditingArea >> editorClass [
	"Answer the class used to create the receiver's editor"

	^ OccamTextEditor
]
