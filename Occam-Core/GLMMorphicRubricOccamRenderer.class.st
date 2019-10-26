Class {
	#name : #GLMMorphicRubricOccamRenderer,
	#superclass : #GLMMorphicRubricTextRenderer,
	#category : #'Occam-Core-Browser'
}

{ #category : #rendering }
GLMMorphicRubricOccamRenderer >> morph [
	^ OccamTextMorph new
		getSelectionSelector: #primarySelectionInterval;
		color: Smalltalk ui theme backgroundColor;
		textColor: Smalltalk ui theme textColor;
		textFont: StandardFonts codeFont;
		model: textModel;
		yourself.
]
