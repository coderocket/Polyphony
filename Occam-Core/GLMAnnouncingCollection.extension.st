Extension { #name : #GLMAnnouncingCollection }

{ #category : #'*Occam-Core' }
GLMAnnouncingCollection >> removeAll [
	collection removeAll.
	self announce: GLMItemRemoved

]
