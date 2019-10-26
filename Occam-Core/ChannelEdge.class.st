Class {
	#name : #ChannelEdge,
	#superclass : #Object,
	#instVars : [
		'from',
		'to',
		'channel'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #converting }
ChannelEdge >> asRoassalEdge [
	^RTArrowedLine new
		color: Color black;
		attachPoint: (RTBorderAttachPoint new);
		edgeFrom: from to: to; 
		model: channel
]

{ #category : #accessing }
ChannelEdge >> channel: anASTNode [
	channel := anASTNode

]

{ #category : #accessing }
ChannelEdge >> from: anASTProcess [
	from := anASTProcess 
]

{ #category : #accessing }
ChannelEdge >> to: anASTProcess [
	to := anASTProcess 
]
