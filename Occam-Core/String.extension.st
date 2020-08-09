Extension { #name : #String }

{ #category : #'*Occam-Core' }
String >> asOccamProcess [

	| aParser |
	aParser := OccamCoreParser on: (ReadStream on: self).
	
	aParser setStartingState: OccamCoreParser startingStateForProcess.

	^aParser parse
	

]
