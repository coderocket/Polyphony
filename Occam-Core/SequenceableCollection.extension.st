Extension { #name : #SequenceableCollection }

{ #category : #'*Occam-Core' }
SequenceableCollection >> with: otherCollection do: twoArgBlock separatedBy: separatorBlock [

	otherCollection size = self size ifFalse: [self errorSizeMismatch].
	1 to: self size do:
		[:index |
		index = 1 ifFalse: [separatorBlock value].
		twoArgBlock value: (self at: index)
				value: (otherCollection at: index)]
]
