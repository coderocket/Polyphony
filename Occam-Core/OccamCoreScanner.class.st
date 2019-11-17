Class {
	#name : #OccamCoreScanner,
	#superclass : #SmaCCScanner,
	#instVars : [
		'indentLevel',
		'patchedTokens'
	],
	#classVars : [
		'bangeolIndex',
		'beginIndex',
		'endIndex',
		'queryeolIndex'
	],
	#category : #'Occam-Core-AST'
}

{ #category : #'class initialization' }
OccamCoreScanner class >> initialize [ 

	"self initialize"
	
	| symbolNames |
	
	(OccamCoreParser canUnderstand: #symbolNames) ifFalse: [ ^ self ].
	
	symbolNames := OccamCoreParser new symbolNames.
	
	beginIndex := symbolNames indexOf: '"BEGIN"'.
	endIndex := symbolNames indexOf: '"END"'.
	queryeolIndex := symbolNames indexOf: '<queryeol>'.
	bangeolIndex := symbolNames indexOf: '<bangeol>'.
	
]

{ #category : #generated }
OccamCoreScanner class >> states [
	^ #(#default #doc)
]

{ #category : #accessing }
OccamCoreScanner >> bangeol [ 
	self closeLine.
	^ SmaCCToken value:'!' start: start ids: (Array with:bangeolIndex)

]

{ #category : #'as yet unclassified' }
OccamCoreScanner >> closeLine [

	| numSpaces prevLevel danglingIndents s |

	s := outputStream contents.
	
	numSpaces := (s size) - (s indexOf: Character cr).
	
	((numSpaces rem:2) = 1) ifTrue:[self scannerError].
	
	prevLevel := indentLevel.
	
	indentLevel := numSpaces / 2.
		
	(indentLevel > (prevLevel + 1)) ifTrue:[self scannerError].

	(indentLevel = (prevLevel + 1)) ifTrue:[
		patchedTokens addFirst:(SmaCCToken value:'BEGIN' start: start ids: (Array with:beginIndex))].
	
	danglingIndents := prevLevel - indentLevel.
	
	danglingIndents timesRepeat:[patchedTokens addFirst:(SmaCCToken value:'END' start: start ids: (Array with:endIndex))].

]

{ #category : #generated }
OccamCoreScanner >> emptySymbolTokenId [
	^ 189
]

{ #category : #generated }
OccamCoreScanner >> errorTokenId [
	^ 190
]

{ #category : #'initialize-release' }
OccamCoreScanner >> initialize [

	super initialize.
	
	indentLevel := 0.
	patchedTokens := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
OccamCoreScanner >> newline [

	self closeLine.
	patchedTokens ifNotEmpty:[^patchedTokens removeFirst].
		
	self resetScanner.
	^ self scanForToken
]

{ #category : #accessing }
OccamCoreScanner >> next [

	patchedTokens ifNotEmpty:[^patchedTokens removeFirst].

	^super next 
]

{ #category : #accessing }
OccamCoreScanner >> queryeol [ 

	self closeLine.
	^ SmaCCToken value:'?' start: start ids: (Array with:queryeolIndex)

]

{ #category : #generated }
OccamCoreScanner >> scan1 [
	self step.
	currentCharacter == $!
		ifTrue:
			[ ^ self scan1X14 ].
	^ self scan1X29
]

{ #category : #generated }
OccamCoreScanner >> scan10 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $I
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $B
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $R
						ifTrue: [ self recordMatch: #(61).
							self step.
							currentCharacter == $A
								ifTrue: [ self recordMatch: #(61).
									self step.
									currentCharacter == $R
										ifTrue: [ self recordMatch: #(61).
											self step.
											currentCharacter == $Y
												ifTrue: [ self recordMatch: #(20 61).
													self step.
													(('''.' includes: currentCharacter)
														or: [ (currentCharacter between: $0 and: $9)
																or: [ (currentCharacter between: $A and: $Z)
																		or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
														ifTrue: [ [ self recordMatch: #(61).
															self step.
															('''.' includes: currentCharacter)
																or: [ (currentCharacter between: $0 and: $9)
																		or: [ (currentCharacter between: $A and: $Z)
																				or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
																whileTrue ].
													^ self reportLastMatch ].
											(('''.' includes: currentCharacter)
												or: [ (currentCharacter between: $0 and: $9)
														or: [ (currentCharacter between: $A and: $X)
																or: [ ('Z_' includes: currentCharacter)
																		or: [ currentCharacter between: $a and: $z ] ] ] ])
												ifTrue: [ [ self recordMatch: #(61).
													self step.
													('''.' includes: currentCharacter)
														or: [ (currentCharacter between: $0 and: $9)
																or: [ (currentCharacter between: $A and: $Z)
																		or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
														whileTrue ].
											^ self reportLastMatch ].
									(('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Q)
														or: [ (currentCharacter between: $S and: $Z)
																or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
										ifTrue: [ [ self recordMatch: #(61).
											self step.
											('''.' includes: currentCharacter)
												or: [ (currentCharacter between: $0 and: $9)
														or: [ (currentCharacter between: $A and: $Z)
																or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
												whileTrue ].
									^ self reportLastMatch ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $B and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Q)
										or: [ (currentCharacter between: $S and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ currentCharacter == $A
								or: [ (currentCharacter between: $C and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $H)
						or: [ (currentCharacter between: $J and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan11 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $E
		ifTrue:
			[ ^ self scan11X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan11X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $M
		ifTrue: [ self recordMatch: #(31 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	currentCharacter == $S
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $U
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $L
						ifTrue: [ self recordMatch: #(61).
							self step.
							currentCharacter == $T
								ifTrue: [ self recordMatch: #(23 61).
									self step.
									(('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
										ifTrue: [ [ self recordMatch: #(61).
											self step.
											('''.' includes: currentCharacter)
												or: [ (currentCharacter between: $0 and: $9)
														or: [ (currentCharacter between: $A and: $Z)
																or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
												whileTrue ].
									^ self reportLastMatch ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $S)
												or: [ (currentCharacter between: $U and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $K)
										or: [ (currentCharacter between: $M and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $T)
								or: [ (currentCharacter between: $V and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $L)
						or: [ (currentCharacter between: $N and: $R)
								or: [ (currentCharacter between: $T and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan12 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $E
		ifTrue:
			[ ^ self scan12X4 ].
	^ self scan12X6
]

{ #category : #generated }
OccamCoreScanner >> scan12X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $I
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $P
				ifTrue: [ self recordMatch: #(32 61).
					self step.
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $O)
								or: [ (currentCharacter between: $Q and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $H)
						or: [ (currentCharacter between: $J and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan12X2 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $O
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $P
				ifTrue: [ self recordMatch: #(50 61).
					self step.
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $O)
								or: [ (currentCharacter between: $Q and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $N)
						or: [ (currentCharacter between: $P and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan12X3 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $Z
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $E
				ifTrue: [ self recordMatch: #(54 61).
					self step.
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $D)
								or: [ (currentCharacter between: $F and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Y)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan12X4 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $Q
		ifTrue: [ self recordMatch: #(10 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $P)
						or: [ (currentCharacter between: $R and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan12X5 [
	[ self recordMatch: #(61).
	self step.
	('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
		whileTrue
]

{ #category : #generated }
OccamCoreScanner >> scan12X6 [
	currentCharacter == $I
		ifTrue:
			[ ^ self scan12X3 ].
	currentCharacter == $K
		ifTrue:
			[ ^ self scan12X1 ].
	currentCharacter == $T
		ifTrue:
			[ ^ self scan12X2 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $H)
								or: [ currentCharacter == $J
										or: [ (currentCharacter between: $L and: $S)
												or: [ (currentCharacter between: $U and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ] ] ])
		ifTrue:
			[ self scan12X5 ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan13 [
	self step.
	currentCharacter == $!
		ifTrue: [ ^ self scan13X11 ].
	currentCharacter == $"
		ifTrue: [ ^ self scan17 ].
	currentCharacter == $#
		ifTrue: [ ^ self scan13X10 ].
	currentCharacter == $&
		ifTrue: [ ^ self scan13X29 ].
	currentCharacter == $'
		ifTrue: [ ^ self scan13X8 ].
	currentCharacter == $(
		ifTrue: [ ^ self scan13X28 ].
	currentCharacter == $)
		ifTrue: [ ^ self scan13X27 ].
	currentCharacter == $*
		ifTrue: [ ^ self scan13X20 ].
	currentCharacter == $+
		ifTrue: [ ^ self scan13X26 ].
	currentCharacter == $,
		ifTrue: [ ^ self scan13X25 ].
	^ self scan13X32
]

{ #category : #generated }
OccamCoreScanner >> scan13X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $H
		ifTrue: [ ^ self scan13X1X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $G)
						or: [ (currentCharacter between: $I and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X10 [
	self recordMatch: #(75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	((currentCharacter between: $0 and: $9)
		or: [ currentCharacter between: $A and: $F ])
		ifTrue: [ [ self recordMatch: #(63 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(currentCharacter between: $0 and: $9)
				or: [ currentCharacter between: $A and: $F ] ] whileTrue ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X11 [
	self recordMatch: #(7 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	(currentCharacter == Character lf
		or: [ currentCharacter == Character cr ])
		ifTrue: [ ^ self scan16 ].
	(currentCharacter isSeparator
		or: [ currentCharacter == Character pageUp ])
		ifTrue: [ [ self recordMatch: #(75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(currentCharacter == Character lf
				or: [ currentCharacter == Character cr ])
				ifTrue: [ ^ self scan16 ].
			currentCharacter isSeparator
				or: [ currentCharacter == Character pageUp ] ] whileTrue ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X12 [
	[ self recordMatch: #(69 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == Character tab
		or: [ (currentCharacter between: Character pageUp and: Character newPage)
				or: [ currentCharacter == Character space ] ] ] whileTrue.
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X13 [
	[ self recordMatch: #(71 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == Character tab
		or: [ (currentCharacter between: Character pageUp and: Character newPage)
				or: [ currentCharacter == Character space ] ] ] whileTrue.
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X14 [
	self recordMatch: #(45 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $<
		ifTrue: [ self recordMatch: #(42 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			^ self scan14 ].
	currentCharacter == $=
		ifTrue: [ self recordMatch: #(41 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			^ self scan14 ].
	currentCharacter == $>
		ifTrue: [ self recordMatch: #(15 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ] ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X15 [
	self recordMatch: #(43 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $<
		ifTrue: [ self recordMatch: #(39 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			^ self scan14 ].
	currentCharacter == $=
		ifTrue: [ self recordMatch: #(40 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			^ self scan14 ].
	currentCharacter == $>
		ifTrue: [ self recordMatch: #(44 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ] ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X16 [
	self recordMatch: #(35 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $/
		ifTrue: [ self recordMatch: #(33 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ] ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X17 [
	self recordMatch: #(72 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $=
		ifTrue: [ self recordMatch: #(52 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ] ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X18 [
	self recordMatch: #(19 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $\
		ifTrue: [ self recordMatch: #(37 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ] ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X19 [
	self recordMatch: #(59 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $-
		ifTrue: [ ^ self scan19 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X1X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $I
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $L
				ifTrue: [ self recordMatch: #(61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					currentCharacter == $E
						ifTrue: [ self recordMatch: #(53 61 75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ ^ self scan23 ].
							^ self scan14 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $D)
										or: [ (currentCharacter between: $F and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $K)
								or: [ (currentCharacter between: $M and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $H)
						or: [ (currentCharacter between: $J and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X2 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $F
		ifTrue: [ self recordMatch: #(1 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	currentCharacter == $R
		ifTrue: [ self recordMatch: #(36 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $E)
						or: [ (currentCharacter between: $G and: $Q)
								or: [ (currentCharacter between: $S and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X20 [
	self recordMatch: #(38).
	self step.
	currentCharacter == $/
		ifTrue: [ ^ self recordAndReportMatch: #(29) ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X21 [
	self recordMatch: #(56 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X22 [
	self recordMatch: #(13 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X23 [
	self recordMatch: #(14 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X24 [
	self recordMatch: #(9 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X25 [
	self recordMatch: #(8 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X26 [
	self recordMatch: #(48 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X27 [
	self recordMatch: #(24 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X28 [
	self recordMatch: #(25 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X29 [
	self recordMatch: #(49 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X3 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $F
		ifTrue: [ self recordMatch: #(46 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	currentCharacter == $S
		ifTrue: [ self recordMatch: #(22 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $E)
						or: [ (currentCharacter between: $G and: $R)
								or: [ (currentCharacter between: $T and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X30 [
	currentCharacter == $]
		ifTrue: [ ^ self scan13X22 ].
	currentCharacter == $~
		ifTrue: [ ^ self scan13X21 ].
	(currentCharacter between: $0 and: $9)
		ifTrue: [ ^ self scan20 ].
	(currentCharacter == Character lf
		or: [ currentCharacter == Character cr ])
		ifTrue: [ ^ self scan13X13 ].
	(currentCharacter isSeparator
		or: [ currentCharacter == Character pageUp ])
		ifTrue: [ ^ self scan13X12 ].
	((currentCharacter between: $G and: $H)
		or: [ (currentCharacter between: $J and: $K)
				or: [ ('MQ' includes: currentCharacter)
						or: [ (currentCharacter between: $X and: $Z)
								or: [ currentCharacter between: $a and: $z ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X31 [
	currentCharacter == $I
		ifTrue: [ ^ self scan13X3 ].
	currentCharacter == $L
		ifTrue: [ ^ self scan33 ].
	currentCharacter == $N
		ifTrue: [ ^ self scan13X5 ].
	currentCharacter == $O
		ifTrue: [ ^ self scan13X2 ].
	currentCharacter == $P
		ifTrue: [ ^ self scan35 ].
	currentCharacter == $R
		ifTrue: [ ^ self scan36 ].
	currentCharacter == $S
		ifTrue: [ ^ self scan38 ].
	currentCharacter == $T
		ifTrue: [ ^ self scan39 ].
	currentCharacter == $U
		ifTrue: [ ^ self scan40 ].
	currentCharacter == $V
		ifTrue: [ ^ self scan13X7 ].
	currentCharacter == $W
		ifTrue: [ ^ self scan13X1 ].
	currentCharacter == $[
		ifTrue: [ ^ self scan13X23 ].
	currentCharacter == $\
		ifTrue: [ ^ self scan13X16 ].
	^ self scan13X30
]

{ #category : #generated }
OccamCoreScanner >> scan13X32 [
	currentCharacter == $-
		ifTrue: [ ^ self scan13X19 ].
	currentCharacter == $/
		ifTrue: [ ^ self scan13X18 ].
	currentCharacter == $:
		ifTrue: [ ^ self scan13X17 ].
	currentCharacter == $<
		ifTrue: [ ^ self scan13X15 ].
	currentCharacter == $=
		ifTrue: [ ^ self scan13X24 ].
	currentCharacter == $>
		ifTrue: [ ^ self scan13X14 ].
	currentCharacter == $?
		ifTrue: [ ^ self scan13X9 ].
	currentCharacter == $A
		ifTrue: [ ^ self scan22 ].
	currentCharacter == $B
		ifTrue: [ ^ self scan24 ].
	currentCharacter == $C
		ifTrue: [ ^ self scan13X4 ].
	currentCharacter == $D
		ifTrue: [ ^ self scan13X6 ].
	currentCharacter == $E
		ifTrue: [ ^ self scan26 ].
	currentCharacter == $F
		ifTrue: [ ^ self scan29 ].
	^ self scan13X31
]

{ #category : #generated }
OccamCoreScanner >> scan13X4 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $H
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $A
				ifTrue: [ self recordMatch: #(61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					currentCharacter == $N
						ifTrue: [ self recordMatch: #(2 61 75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ ^ self scan23 ].
							^ self scan14 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $M)
										or: [ (currentCharacter between: $O and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $B and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $G)
						or: [ (currentCharacter between: $I and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X5 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $O
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $T
				ifTrue: [ self recordMatch: #(55 61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $S)
								or: [ (currentCharacter between: $U and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $N)
						or: [ (currentCharacter between: $P and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X6 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $O
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $C
				ifTrue: [ self recordMatch: #(21 61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $B)
								or: [ (currentCharacter between: $D and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $N)
						or: [ (currentCharacter between: $P and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X7 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $A
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $L
				ifTrue: [ self recordMatch: #(30 61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $K)
								or: [ (currentCharacter between: $M and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $B and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X8 [
	self recordMatch: #(75).
	self step.
	currentCharacter == $*
		ifTrue: [ self step.
			currentCharacter == $'
				ifTrue: [ ^ self scan18 ].
			(currentCharacter <= $&
				or: [ (currentCharacter between: $( and: $.)
						or: [ currentCharacter >= $0 ] ])
				ifTrue: [ ^ self scan14 ].
			^ self reportLastMatch ].
	(currentCharacter isSeparator
		or: [ currentCharacter == Character pageUp ])
		ifTrue: [ ^ self scan14 ].
	self recordMatch: #(75).
	self step.
	currentCharacter == $'
		ifTrue: [ ^ self scan18 ].
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan13X9 [
	self recordMatch: #(5 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	(currentCharacter == Character lf
		or: [ currentCharacter == Character cr ])
		ifTrue: [ ^ self scan21 ].
	(currentCharacter isSeparator
		or: [ currentCharacter == Character pageUp ])
		ifTrue: [ [ self recordMatch: #(75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(currentCharacter == Character lf
				or: [ currentCharacter == Character cr ])
				ifTrue: [ ^ self scan21 ].
			currentCharacter isSeparator
				or: [ currentCharacter == Character pageUp ] ] whileTrue ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan14 [
	[ self recordMatch: #(75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	true ] whileTrue
]

{ #category : #generated }
OccamCoreScanner >> scan15 [
	self step.
	currentCharacter ~~ $/
		ifTrue: [ ^ self scan14 ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan16 [
	[ self recordMatch: #(74 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == Character tab
		or: [ (currentCharacter between: Character pageUp and: Character newPage)
				or: [ currentCharacter == Character space ] ] ] whileTrue.
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan17 [
	[ self recordMatch: #(75).
	self step.
	currentCharacter == $"
		ifTrue: [ self recordMatch: #(67 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			^ self scan14 ].
	currentCharacter == $*
		ifTrue: [ ^ self scan17X1 ].
	true ] whileTrue
]

{ #category : #generated }
OccamCoreScanner >> scan17X1 [
	self step.
	('"''*cnt' includes: currentCharacter)
		ifTrue: [ ^ self scan17 ].
	(currentCharacter <= $!
		or: [ (currentCharacter between: $# and: $&)
				or: [ (currentCharacter between: $( and: $))
						or: [ (currentCharacter between: $+ and: $.)
								or: [ (currentCharacter between: $0 and: $b)
										or: [ (currentCharacter between: $d and: $m)
												or: [ (currentCharacter between: $o and: $s)
														or: [ currentCharacter >= $u ] ] ] ] ] ] ])
		ifTrue: [ ^ self scan14 ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan18 [
	self recordMatch: #(68 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan19 [
	[ self recordMatch: #(70 75).
	self step.
	currentCharacter == $*
		ifTrue: [ self recordMatch: #(70).
			self step.
			currentCharacter == $/
				ifTrue: [ [ self recordMatch: #(70).
					self step.
					currentCharacter <= Character tab
						or: [ (currentCharacter between: Character pageUp and: Character newPage)
								or: [ currentCharacter >= (Character value: 14) ] ] ]
						whileTrue.
					^ self reportLastMatch ].
			(currentCharacter == Character lf
				or: [ currentCharacter == Character cr ])
				ifTrue: [ ^ self scan14 ].
			^ self scan19 ].
	(currentCharacter == Character lf
		or: [ currentCharacter == Character cr ])
		ifTrue: [ ^ self scan14 ].
	true ] whileTrue
]

{ #category : #generated }
OccamCoreScanner >> scan1X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $I
		ifTrue:
			[ ^ self scan1X1X1 ].
	currentCharacter == $R
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $U
				ifTrue: [ ^ self scan8 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $T)
								or: [ (currentCharacter between: $V and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $H)
						or: [ (currentCharacter between: $J and: $Q)
								or: [ (currentCharacter between: $S and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X10 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $A
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $L
				ifTrue: [ self recordMatch: #(30 61).
					self step.
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $K)
								or: [ (currentCharacter between: $M and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $B and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X11 [
	[ self recordMatch: #(62).
	self step.
	currentCharacter == $.
		ifTrue: [ [ self recordMatch: #(64).
			self step.
			currentCharacter == $E
				ifTrue: [ self step.
					('+-' includes: currentCharacter)
						ifTrue: [ self step.
							(currentCharacter between: $0 and: $9)
								ifTrue: [ self step.
									(currentCharacter between: $0 and: $9)
										ifTrue: [ self recordMatch: #(65).
											self step.
											(currentCharacter between: $0 and: $9)
												ifTrue: [ ^ self recordAndReportMatch: #(66) ] ] ] ].
					^ self reportLastMatch ].
			currentCharacter between: $0 and: $9 ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X12 [
	self recordMatch: #(59).
	self step.
	currentCharacter == $-
		ifTrue: [ [ self recordMatch: #(70).
			self step.
			currentCharacter <= Character tab
				or: [ (currentCharacter between: Character pageUp and: Character newPage)
						or: [ currentCharacter >= (Character value: 14) ] ] ] whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X13 [
	self recordMatch: #(5).
	self step.
	(currentCharacter == Character lf
		or: [ currentCharacter == Character cr ])
		ifTrue: [ [ self recordMatch: #(73).
			self step.
			currentCharacter == Character tab
				or: [ (currentCharacter between: Character pageUp and: Character newPage)
						or: [ currentCharacter == Character space ] ] ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isSeparator
		or: [ currentCharacter == Character pageUp ])
		ifTrue: [ [ self step.
			(currentCharacter == Character lf
				or: [ currentCharacter == Character cr ])
				ifTrue: [ [ self recordMatch: #(73).
					self step.
					currentCharacter == Character tab
						or: [ (currentCharacter between: Character pageUp and: Character newPage)
								or: [ currentCharacter == Character space ] ] ] whileTrue.
					^ self reportLastMatch ].
			currentCharacter isSeparator
				or: [ currentCharacter == Character pageUp ] ] whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X14 [
	self recordMatch: #(7).
	self step.
	(currentCharacter == Character lf
		or: [ currentCharacter == Character cr ])
		ifTrue: [ [ self recordMatch: #(74).
			self step.
			currentCharacter == Character tab
				or: [ (currentCharacter between: Character pageUp and: Character newPage)
						or: [ currentCharacter == Character space ] ] ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isSeparator
		or: [ currentCharacter == Character pageUp ])
		ifTrue: [ [ self step.
			(currentCharacter == Character lf
				or: [ currentCharacter == Character cr ])
				ifTrue: [ [ self recordMatch: #(74).
					self step.
					currentCharacter == Character tab
						or: [ (currentCharacter between: Character pageUp and: Character newPage)
								or: [ currentCharacter == Character space ] ] ] whileTrue.
					^ self reportLastMatch ].
			currentCharacter isSeparator
				or: [ currentCharacter == Character pageUp ] ] whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X15 [
	[ self recordMatch: #(61).
	self step.
	('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
		whileTrue
]

{ #category : #generated }
OccamCoreScanner >> scan1X16 [
	self step.
	(currentCharacter <= Character backspace
		or: [ (currentCharacter
				between: (Character value: 14)
				and: Character arrowDown) or: [ currentCharacter >= $! ] ])
		ifTrue: [ self step.
			currentCharacter == $'
				ifTrue: [ ^ self recordAndReportMatch: #(68) ] ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X17 [
	self recordMatch: #(45).
	self step.
	currentCharacter == $<
		ifTrue: [ ^ self recordAndReportMatch: #(42) ].
	currentCharacter == $=
		ifTrue: [ ^ self recordAndReportMatch: #(41) ].
	currentCharacter == $>
		ifTrue: [ ^ self recordAndReportMatch: #(15) ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X18 [
	self recordMatch: #(43).
	self step.
	currentCharacter == $<
		ifTrue: [ ^ self recordAndReportMatch: #(39) ].
	currentCharacter == $=
		ifTrue: [ ^ self recordAndReportMatch: #(40) ].
	currentCharacter == $>
		ifTrue: [ ^ self recordAndReportMatch: #(44) ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X19 [
	[ self recordMatch: #(69).
	self step.
	currentCharacter == Character tab
		or: [ (currentCharacter between: Character pageUp and: Character newPage)
				or: [ currentCharacter == Character space ] ] ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X1X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $M
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $E
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $R
						ifTrue: [ self recordMatch: #(6 61).
							self step.
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Q)
										or: [ (currentCharacter between: $S and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $D)
								or: [ (currentCharacter between: $F and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $L)
						or: [ (currentCharacter between: $N and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X2 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $S
		ifTrue:
			[ ^ self scan1X2X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $R)
						or: [ (currentCharacter between: $T and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X20 [
	[ self recordMatch: #(71).
	self step.
	currentCharacter == Character tab
		or: [ (currentCharacter between: Character pageUp and: Character newPage)
				or: [ currentCharacter == Character space ] ] ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X21 [
	self step.
	((currentCharacter between: $0 and: $9)
		or: [ currentCharacter between: $A and: $F ])
		ifTrue: [ [ self recordMatch: #(63).
			self step.
			(currentCharacter between: $0 and: $9)
				or: [ currentCharacter between: $A and: $F ] ] whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X22 [
	self recordMatch: #(35).
	self step.
	currentCharacter == $/
		ifTrue: [ ^ self recordAndReportMatch: #(33) ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X23 [
	self recordMatch: #(72).
	self step.
	currentCharacter == $=
		ifTrue: [ ^ self recordAndReportMatch: #(52) ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X24 [
	self recordMatch: #(19).
	self step.
	currentCharacter == $\
		ifTrue: [ ^ self recordAndReportMatch: #(37) ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X25 [
	self recordMatch: #(38).
	self step.
	currentCharacter == $/
		ifTrue: [ ^ self recordAndReportMatch: #(29) ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X26 [
	currentCharacter == $~
		ifTrue: [ ^ self recordAndReportMatch: #(56) ].
	(currentCharacter between: $0 and: $9)
		ifTrue:
			[ ^ self scan1X11 ].
	(currentCharacter == Character lf
		or: [ currentCharacter == Character cr ])
		ifTrue:
			[ ^ self scan1X20 ].
	(currentCharacter isSeparator
		or: [ currentCharacter == Character pageUp ])
		ifTrue:
			[ ^ self scan1X19 ].
	((currentCharacter between: $G and: $H)
		or: [ (currentCharacter between: $J and: $K)
				or: [ ('MQ' includes: currentCharacter)
						or: [ (currentCharacter between: $X and: $Z)
								or: [ currentCharacter between: $a and: $z ] ] ] ])
		ifTrue:
			[ self scan1X15 ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X27 [
	currentCharacter == $N
		ifTrue:
			[ ^ self scan1X8 ].
	currentCharacter == $O
		ifTrue:
			[ ^ self scan1X5 ].
	currentCharacter == $P
		ifTrue:
			[ ^ self scan1X4 ].
	currentCharacter == $R
		ifTrue: [ ^ self scan11 ].
	currentCharacter == $S
		ifTrue: [ ^ self scan12 ].
	currentCharacter == $T
		ifTrue:
			[ ^ self scan1X1 ].
	currentCharacter == $U
		ifTrue:
			[ ^ self scan1X2 ].
	currentCharacter == $V
		ifTrue:
			[ ^ self scan1X10 ].
	currentCharacter == $W
		ifTrue:
			[ ^ self scan1X3 ].
	currentCharacter == $[
		ifTrue: [ ^ self recordAndReportMatch: #(14) ].
	currentCharacter == $\
		ifTrue:
			[ ^ self scan1X22 ].
	currentCharacter == $]
		ifTrue: [ ^ self recordAndReportMatch: #(13) ].
	^ self scan1X26
]

{ #category : #generated }
OccamCoreScanner >> scan1X28 [
	currentCharacter == $<
		ifTrue:
			[ ^ self scan1X18 ].
	currentCharacter == $=
		ifTrue: [ ^ self recordAndReportMatch: #(9) ].
	currentCharacter == $>
		ifTrue:
			[ ^ self scan1X17 ].
	currentCharacter == $?
		ifTrue:
			[ ^ self scan1X13 ].
	currentCharacter == $A
		ifTrue: [ ^ self scan3 ].
	currentCharacter == $B
		ifTrue: [ ^ self scan4 ].
	currentCharacter == $C
		ifTrue:
			[ ^ self scan1X7 ].
	currentCharacter == $D
		ifTrue:
			[ ^ self scan1X9 ].
	currentCharacter == $E
		ifTrue: [ ^ self scan5 ].
	currentCharacter == $F
		ifTrue: [ ^ self scan7 ].
	currentCharacter == $I
		ifTrue:
			[ ^ self scan1X6 ].
	currentCharacter == $L
		ifTrue: [ ^ self scan10 ].
	^ self scan1X27
]

{ #category : #generated }
OccamCoreScanner >> scan1X29 [
	currentCharacter == $"
		ifTrue: [ ^ self scan2 ].
	currentCharacter == $#
		ifTrue:
			[ ^ self scan1X21 ].
	currentCharacter == $&
		ifTrue: [ ^ self recordAndReportMatch: #(49) ].
	currentCharacter == $'
		ifTrue:
			[ ^ self scan1X16 ].
	currentCharacter == $(
		ifTrue: [ ^ self recordAndReportMatch: #(25) ].
	currentCharacter == $)
		ifTrue: [ ^ self recordAndReportMatch: #(24) ].
	currentCharacter == $*
		ifTrue:
			[ ^ self scan1X25 ].
	currentCharacter == $+
		ifTrue: [ ^ self recordAndReportMatch: #(48) ].
	currentCharacter == $,
		ifTrue: [ ^ self recordAndReportMatch: #(8) ].
	currentCharacter == $-
		ifTrue:
			[ ^ self scan1X12 ].
	currentCharacter == $/
		ifTrue:
			[ ^ self scan1X24 ].
	currentCharacter == $:
		ifTrue:
			[ ^ self scan1X23 ].
	^ self scan1X28
]

{ #category : #generated }
OccamCoreScanner >> scan1X2X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $E
		ifTrue: [ self recordMatch: #(3 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	currentCharacter == $I
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $N
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $G
						ifTrue: [ self recordMatch: #(16 61).
							self step.
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $F)
										or: [ (currentCharacter between: $H and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $M)
								or: [ (currentCharacter between: $O and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $H)
								or: [ (currentCharacter between: $J and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X3 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $H
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $I
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $L
						ifTrue: [ self recordMatch: #(61).
							self step.
							currentCharacter == $E
								ifTrue: [ self recordMatch: #(53 61).
									self step.
									(('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
										ifTrue: [ [ self recordMatch: #(61).
											self step.
											('''.' includes: currentCharacter)
												or: [ (currentCharacter between: $0 and: $9)
														or: [ (currentCharacter between: $A and: $Z)
																or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
												whileTrue ].
									^ self reportLastMatch ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $D)
												or: [ (currentCharacter between: $F and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $K)
										or: [ (currentCharacter between: $M and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $H)
								or: [ (currentCharacter between: $J and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $G)
						or: [ (currentCharacter between: $I and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X4 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $A
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $R
				ifTrue: [ self recordMatch: #(11 61).
					self step.
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Q)
								or: [ (currentCharacter between: $S and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	currentCharacter == $R
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $O
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $C
						ifTrue: [ self recordMatch: #(26 61).
							self step.
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $B)
										or: [ (currentCharacter between: $D and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $N)
								or: [ (currentCharacter between: $P and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $B and: $Q)
						or: [ (currentCharacter between: $S and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X5 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $F
		ifTrue: [ self recordMatch: #(1 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	currentCharacter == $R
		ifTrue: [ self recordMatch: #(36 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $E)
						or: [ (currentCharacter between: $G and: $Q)
								or: [ (currentCharacter between: $S and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X6 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $F
		ifTrue: [ self recordMatch: #(46 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	currentCharacter == $S
		ifTrue: [ self recordMatch: #(22 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $E)
						or: [ (currentCharacter between: $G and: $R)
								or: [ (currentCharacter between: $T and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X7 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $H
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $A
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $N
						ifTrue: [ self recordMatch: #(2 61).
							self step.
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $M)
										or: [ (currentCharacter between: $O and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $B and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $G)
						or: [ (currentCharacter between: $I and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X8 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $O
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $T
				ifTrue: [ self recordMatch: #(55 61).
					self step.
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $S)
								or: [ (currentCharacter between: $U and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $N)
						or: [ (currentCharacter between: $P and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan1X9 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $O
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $C
				ifTrue: [ self recordMatch: #(21 61).
					self step.
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $B)
								or: [ (currentCharacter between: $D and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $N)
						or: [ (currentCharacter between: $P and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan2 [
	[ self step.
	currentCharacter == $"
		ifTrue: [ ^ self recordAndReportMatch: #(67) ].
	currentCharacter == $*
		ifTrue: [ self step.
			('"''*cnt' includes: currentCharacter)
				ifTrue: [ ^ self scan2 ].
			^ self reportLastMatch ].
	true ] whileTrue
]

{ #category : #generated }
OccamCoreScanner >> scan20 [
	[ self recordMatch: #(62 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $.
		ifTrue: [ [ self recordMatch: #(64 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $E
				ifTrue: [ self recordMatch: #(75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					('+-' includes: currentCharacter)
						ifTrue: [ self recordMatch: #(75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							(currentCharacter between: $0 and: $9)
								ifTrue: [ self recordMatch: #(75).
									self step.
									currentCharacter == $*
										ifTrue: [ ^ self scan15 ].
									(currentCharacter between: $0 and: $9)
										ifTrue: [ self recordMatch: #(65 75).
											self step.
											currentCharacter == $*
												ifTrue: [ ^ self scan15 ].
											(currentCharacter between: $0 and: $9)
												ifTrue: [ self recordMatch: #(66 75).
													self step.
													currentCharacter == $*
														ifTrue: [ ^ self scan15 ] ] ] ] ].
					^ self scan14 ].
			currentCharacter between: $0 and: $9 ] whileTrue.
			^ self scan14 ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan21 [
	[ self recordMatch: #(73 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == Character tab
		or: [ (currentCharacter between: Character pageUp and: Character newPage)
				or: [ currentCharacter == Character space ] ] ] whileTrue.
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan22 [
	self recordMatch: #(61 75).
	^ self scan22X4
]

{ #category : #generated }
OccamCoreScanner >> scan22X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $T
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $E
				ifTrue: [ self recordMatch: #(61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					currentCharacter == $R
						ifTrue: [ self recordMatch: #(51 61 75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ ^ self scan23 ].
							^ self scan14 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Q)
										or: [ (currentCharacter between: $S and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $D)
								or: [ (currentCharacter between: $F and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $S)
						or: [ (currentCharacter between: $U and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan22X2 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $D
		ifTrue: [ self recordMatch: #(34 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $C)
						or: [ (currentCharacter between: $E and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan22X3 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $T
		ifTrue: [ self recordMatch: #(47 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $S)
						or: [ (currentCharacter between: $U and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan22X4 [
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $F
		ifTrue: [ ^ self scan22X1 ].
	currentCharacter == $L
		ifTrue: [ ^ self scan22X3 ].
	currentCharacter == $N
		ifTrue: [ ^ self scan22X2 ].
	(currentCharacter <= $&
		or: [ (currentCharacter between: $( and: $))
				or: [ (currentCharacter between: $+ and: $-)
						or: [ currentCharacter == $/
								or: [ (currentCharacter between: $: and: $@)
										or: [ (currentCharacter between: $[ and: $^)
												or: [ currentCharacter == $` or: [ currentCharacter >= ${ ] ] ] ] ] ] ])
		ifTrue: [ ^ self scan14 ].
	^ self scan23
]

{ #category : #generated }
OccamCoreScanner >> scan23 [
	[ self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
		whileTrue.
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan24 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $E
		ifTrue: [ ^ self scan24X1 ].
	currentCharacter == $Y
		ifTrue: [ ^ self scan25 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $X)
								or: [ ('Z_' includes: currentCharacter)
										or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan24X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $G
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $I
				ifTrue: [ self recordMatch: #(61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					currentCharacter == $N
						ifTrue: [ self recordMatch: #(18 61 75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ ^ self scan23 ].
							^ self scan14 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $M)
										or: [ (currentCharacter between: $O and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $H)
								or: [ (currentCharacter between: $J and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $F)
						or: [ (currentCharacter between: $H and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan25 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $T
		ifTrue: [ ^ self scan25X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $S)
						or: [ (currentCharacter between: $U and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan25X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $E
		ifTrue: [ ^ self scan25X1X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan25X1X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $S
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $I
				ifTrue: [ self recordMatch: #(61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					currentCharacter == $N
						ifTrue: [ self recordMatch: #(57 61 75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ ^ self scan23 ].
							^ self scan14 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $M)
										or: [ (currentCharacter between: $O and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $H)
								or: [ (currentCharacter between: $J and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $R)
						or: [ (currentCharacter between: $T and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan26 [
	self recordMatch: #(61 75).
	^ self scan26X3
]

{ #category : #generated }
OccamCoreScanner >> scan26X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $E
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $N
				ifTrue: [ self recordMatch: #(61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					currentCharacter == $T
						ifTrue: [ self recordMatch: #(4 61 75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ ^ self scan23 ].
							^ self scan14 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $S)
										or: [ (currentCharacter between: $U and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $M)
								or: [ (currentCharacter between: $O and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan26X2 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $D
		ifTrue: [ self recordMatch: #(17 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $C)
						or: [ (currentCharacter between: $E and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan26X3 [
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $N
		ifTrue: [ ^ self scan26X2 ].
	currentCharacter == $V
		ifTrue: [ ^ self scan26X1 ].
	currentCharacter == $X
		ifTrue: [ ^ self scan27 ].
	(currentCharacter <= $&
		or: [ (currentCharacter between: $( and: $))
				or: [ (currentCharacter between: $+ and: $-)
						or: [ currentCharacter == $/
								or: [ (currentCharacter between: $: and: $@)
										or: [ (currentCharacter between: $[ and: $^)
												or: [ currentCharacter == $` or: [ currentCharacter >= ${ ] ] ] ] ] ] ])
		ifTrue: [ ^ self scan14 ].
	^ self scan23
]

{ #category : #generated }
OccamCoreScanner >> scan27 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $T
		ifTrue: [ ^ self scan28 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $S)
						or: [ (currentCharacter between: $U and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan28 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $E
		ifTrue: [ ^ self scan28X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan28X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $R
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $N
				ifTrue: [ self recordMatch: #(61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					currentCharacter == $A
						ifTrue: [ self recordMatch: #(61 75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							currentCharacter == $L
								ifTrue: [ self recordMatch: #(28 61 75).
									self step.
									currentCharacter == $*
										ifTrue: [ ^ self scan15 ].
									(('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
										ifTrue: [ ^ self scan23 ].
									^ self scan14 ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $K)
												or: [ (currentCharacter between: $M and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
								ifTrue: [ ^ self scan23 ].
							^ self scan14 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $B and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $M)
								or: [ (currentCharacter between: $O and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Q)
						or: [ (currentCharacter between: $S and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan29 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan29X4
]

{ #category : #generated }
OccamCoreScanner >> scan29X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $L
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $S
				ifTrue: [ ^ self scan30 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $R)
								or: [ (currentCharacter between: $T and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $K)
						or: [ (currentCharacter between: $M and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan29X2 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $O
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $M
				ifTrue: [ self recordMatch: #(58 61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $L)
								or: [ (currentCharacter between: $N and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $N)
						or: [ (currentCharacter between: $P and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan29X3 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $R
		ifTrue: [ self recordMatch: #(27 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Q)
						or: [ (currentCharacter between: $S and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan29X4 [
	currentCharacter == $A
		ifTrue: [ ^ self scan29X1 ].
	currentCharacter == $O
		ifTrue: [ ^ self scan29X3 ].
	currentCharacter == $R
		ifTrue: [ ^ self scan29X2 ].
	currentCharacter == $U
		ifTrue: [ ^ self scan31 ].
	(currentCharacter <= $&
		or: [ (currentCharacter between: $( and: $))
				or: [ (currentCharacter between: $+ and: $-)
						or: [ currentCharacter == $/
								or: [ (currentCharacter between: $: and: $@)
										or: [ (currentCharacter between: $[ and: $^)
												or: [ currentCharacter == $` or: [ currentCharacter >= ${ ] ] ] ] ] ] ])
		ifTrue: [ ^ self scan14 ].
	^ self scan23
]

{ #category : #generated }
OccamCoreScanner >> scan3 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $F
		ifTrue:
			[ ^ self scan3X1 ].
	currentCharacter == $L
		ifTrue:
			[ ^ self scan3X3 ].
	currentCharacter == $N
		ifTrue:
			[ ^ self scan3X2 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $E)
						or: [ (currentCharacter between: $G and: $K)
								or: [ currentCharacter == $M
										or: [ (currentCharacter between: $O and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan30 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $E
		ifTrue: [ self recordMatch: #(60 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan31 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $N
		ifTrue: [ ^ self scan32 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $M)
						or: [ (currentCharacter between: $O and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan32 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $C
		ifTrue: [ ^ self scan32X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $B)
						or: [ (currentCharacter between: $D and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan32X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $T
		ifTrue: [ ^ self scan32X1X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $S)
						or: [ (currentCharacter between: $U and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan32X1X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $I
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $O
				ifTrue: [ self recordMatch: #(61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					currentCharacter == $N
						ifTrue: [ self recordMatch: #(12 61 75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ ^ self scan23 ].
							^ self scan14 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $M)
										or: [ (currentCharacter between: $O and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $N)
								or: [ (currentCharacter between: $P and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $H)
						or: [ (currentCharacter between: $J and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan33 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $I
		ifTrue: [ ^ self scan34 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $H)
						or: [ (currentCharacter between: $J and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan34 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $B
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $R
				ifTrue: [ self recordMatch: #(61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					currentCharacter == $A
						ifTrue: [ self recordMatch: #(61 75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							currentCharacter == $R
								ifTrue: [ self recordMatch: #(61 75).
									self step.
									currentCharacter == $*
										ifTrue: [ ^ self scan15 ].
									currentCharacter == $Y
										ifTrue: [ self recordMatch: #(20 61 75).
											self step.
											currentCharacter == $*
												ifTrue: [ ^ self scan15 ].
											(('''.' includes: currentCharacter)
												or: [ (currentCharacter between: $0 and: $9)
														or: [ (currentCharacter between: $A and: $Z)
																or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
												ifTrue: [ ^ self scan23 ].
											^ self scan14 ].
									(('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $X)
														or: [ ('Z_' includes: currentCharacter)
																or: [ currentCharacter between: $a and: $z ] ] ] ])
										ifTrue: [ ^ self scan23 ].
									^ self scan14 ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Q)
												or: [ (currentCharacter between: $S and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
								ifTrue: [ ^ self scan23 ].
							^ self scan14 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $B and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Q)
								or: [ (currentCharacter between: $S and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ currentCharacter == $A
						or: [ (currentCharacter between: $C and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan35 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $A
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $R
				ifTrue: [ self recordMatch: #(11 61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Q)
								or: [ (currentCharacter between: $S and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	currentCharacter == $R
		ifTrue: [ ^ self scan35X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $B and: $Q)
						or: [ (currentCharacter between: $S and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan35X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $O
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $C
				ifTrue: [ self recordMatch: #(26 61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $B)
								or: [ (currentCharacter between: $D and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $N)
						or: [ (currentCharacter between: $P and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan36 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $E
		ifTrue: [ ^ self scan37 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan37 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $M
		ifTrue: [ self recordMatch: #(31 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	currentCharacter == $S
		ifTrue: [ ^ self scan37X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $L)
						or: [ (currentCharacter between: $N and: $R)
								or: [ (currentCharacter between: $T and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan37X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $U
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $L
				ifTrue: [ self recordMatch: #(61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					currentCharacter == $T
						ifTrue: [ self recordMatch: #(23 61 75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ ^ self scan23 ].
							^ self scan14 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $S)
										or: [ (currentCharacter between: $U and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $K)
								or: [ (currentCharacter between: $M and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $T)
						or: [ (currentCharacter between: $V and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan38 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	^ self scan38X5
]

{ #category : #generated }
OccamCoreScanner >> scan38X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $I
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $P
				ifTrue: [ self recordMatch: #(32 61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $O)
								or: [ (currentCharacter between: $Q and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $H)
						or: [ (currentCharacter between: $J and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan38X2 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $O
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $P
				ifTrue: [ self recordMatch: #(50 61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $O)
								or: [ (currentCharacter between: $Q and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $N)
						or: [ (currentCharacter between: $P and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan38X3 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $Z
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $E
				ifTrue: [ self recordMatch: #(54 61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $D)
								or: [ (currentCharacter between: $F and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Y)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan38X4 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $Q
		ifTrue: [ self recordMatch: #(10 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $P)
						or: [ (currentCharacter between: $R and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan38X5 [
	currentCharacter == $E
		ifTrue: [ ^ self scan38X4 ].
	currentCharacter == $I
		ifTrue: [ ^ self scan38X3 ].
	currentCharacter == $K
		ifTrue: [ ^ self scan38X1 ].
	currentCharacter == $T
		ifTrue: [ ^ self scan38X2 ].
	(currentCharacter <= $&
		or: [ (currentCharacter between: $( and: $))
				or: [ (currentCharacter between: $+ and: $-)
						or: [ currentCharacter == $/
								or: [ (currentCharacter between: $: and: $@)
										or: [ (currentCharacter between: $[ and: $^)
												or: [ currentCharacter == $` or: [ currentCharacter >= ${ ] ] ] ] ] ] ])
		ifTrue: [ ^ self scan14 ].
	^ self scan23
]

{ #category : #generated }
OccamCoreScanner >> scan39 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $I
		ifTrue: [ ^ self scan39X1 ].
	currentCharacter == $R
		ifTrue: [ ^ self scan39X2 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $H)
						or: [ (currentCharacter between: $J and: $Q)
								or: [ (currentCharacter between: $S and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan39X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $M
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $E
				ifTrue: [ self recordMatch: #(61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					currentCharacter == $R
						ifTrue: [ self recordMatch: #(6 61 75).
							self step.
							currentCharacter == $*
								ifTrue: [ ^ self scan15 ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ ^ self scan23 ].
							^ self scan14 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Q)
										or: [ (currentCharacter between: $S and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $D)
								or: [ (currentCharacter between: $F and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $L)
						or: [ (currentCharacter between: $N and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan39X2 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $U
		ifTrue: [ ^ self scan30 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $T)
						or: [ (currentCharacter between: $V and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan3X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $T
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $E
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $R
						ifTrue: [ self recordMatch: #(51 61).
							self step.
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Q)
										or: [ (currentCharacter between: $S and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $D)
								or: [ (currentCharacter between: $F and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $S)
						or: [ (currentCharacter between: $U and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan3X2 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $D
		ifTrue: [ self recordMatch: #(34 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $C)
						or: [ (currentCharacter between: $E and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan3X3 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $T
		ifTrue: [ self recordMatch: #(47 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $S)
						or: [ (currentCharacter between: $U and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan4 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $E
		ifTrue:
			[ ^ self scan4X2 ].
	currentCharacter == $Y
		ifTrue:
			[ ^ self scan4X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $X)
								or: [ ('Z_' includes: currentCharacter)
										or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan40 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $S
		ifTrue: [ ^ self scan40X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $R)
						or: [ (currentCharacter between: $T and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan40X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $E
		ifTrue: [ self recordMatch: #(3 61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	currentCharacter == $I
		ifTrue: [ ^ self scan40X1X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $H)
								or: [ (currentCharacter between: $J and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan40X1X1 [
	self recordMatch: #(61 75).
	self step.
	currentCharacter == $*
		ifTrue: [ ^ self scan15 ].
	currentCharacter == $N
		ifTrue: [ self recordMatch: #(61 75).
			self step.
			currentCharacter == $*
				ifTrue: [ ^ self scan15 ].
			currentCharacter == $G
				ifTrue: [ self recordMatch: #(16 61 75).
					self step.
					currentCharacter == $*
						ifTrue: [ ^ self scan15 ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ ^ self scan23 ].
					^ self scan14 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $F)
								or: [ (currentCharacter between: $H and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ ^ self scan23 ].
			^ self scan14 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $M)
						or: [ (currentCharacter between: $O and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan23 ].
	^ self scan14
]

{ #category : #generated }
OccamCoreScanner >> scan4X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $T
		ifTrue:
			[ ^ self scan4X1X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $S)
						or: [ (currentCharacter between: $U and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan4X1X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $E
		ifTrue:
			[ ^ self scan4X1X1X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan4X1X1X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $S
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $I
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $N
						ifTrue: [ self recordMatch: #(57 61).
							self step.
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $M)
										or: [ (currentCharacter between: $O and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $H)
								or: [ (currentCharacter between: $J and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $R)
						or: [ (currentCharacter between: $T and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan4X2 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $G
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $I
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $N
						ifTrue: [ self recordMatch: #(18 61).
							self step.
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $M)
										or: [ (currentCharacter between: $O and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $H)
								or: [ (currentCharacter between: $J and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $F)
						or: [ (currentCharacter between: $H and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan5 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $N
		ifTrue:
			[ ^ self scan5X2 ].
	currentCharacter == $V
		ifTrue:
			[ ^ self scan5X1 ].
	currentCharacter == $X
		ifTrue: [ ^ self scan6 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $M)
						or: [ (currentCharacter between: $O and: $U)
								or: [ currentCharacter == $W
										or: [ (currentCharacter between: $Y and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan5X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $E
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $N
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $T
						ifTrue: [ self recordMatch: #(4 61).
							self step.
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $S)
										or: [ (currentCharacter between: $U and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $M)
								or: [ (currentCharacter between: $O and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan5X2 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $D
		ifTrue: [ self recordMatch: #(17 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $C)
						or: [ (currentCharacter between: $E and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan6 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $T
		ifTrue:
			[ ^ self scan6X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $S)
						or: [ (currentCharacter between: $U and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan6X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $E
		ifTrue:
			[ ^ self scan6X1X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan6X1X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $R
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $N
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $A
						ifTrue: [ self recordMatch: #(61).
							self step.
							currentCharacter == $L
								ifTrue: [ self recordMatch: #(28 61).
									self step.
									(('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
										ifTrue: [ [ self recordMatch: #(61).
											self step.
											('''.' includes: currentCharacter)
												or: [ (currentCharacter between: $0 and: $9)
														or: [ (currentCharacter between: $A and: $Z)
																or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
												whileTrue ].
									^ self reportLastMatch ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $K)
												or: [ (currentCharacter between: $M and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $B and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $M)
								or: [ (currentCharacter between: $O and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Q)
						or: [ (currentCharacter between: $S and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan7 [
	self recordMatch: #(61).
	self step.
	^ self scan7X5
]

{ #category : #generated }
OccamCoreScanner >> scan7X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $L
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $S
				ifTrue: [ ^ self scan8 ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $R)
								or: [ (currentCharacter between: $T and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $K)
						or: [ (currentCharacter between: $M and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan7X2 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $O
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $M
				ifTrue: [ self recordMatch: #(58 61).
					self step.
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $L)
								or: [ (currentCharacter between: $N and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $N)
						or: [ (currentCharacter between: $P and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan7X3 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $R
		ifTrue: [ self recordMatch: #(27 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Q)
						or: [ (currentCharacter between: $S and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan7X4 [
	[ self recordMatch: #(61).
	self step.
	('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $Z)
						or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
		whileTrue
]

{ #category : #generated }
OccamCoreScanner >> scan7X5 [
	currentCharacter == $A
		ifTrue:
			[ ^ self scan7X1 ].
	currentCharacter == $O
		ifTrue:
			[ ^ self scan7X3 ].
	currentCharacter == $R
		ifTrue:
			[ ^ self scan7X2 ].
	currentCharacter == $U
		ifTrue: [ ^ self scan9 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $B and: $N)
						or: [ (currentCharacter between: $P and: $Q)
								or: [ (currentCharacter between: $S and: $T)
										or: [ (currentCharacter between: $V and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ] ])
		ifTrue:
			[ self scan7X4 ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan8 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $E
		ifTrue: [ self recordMatch: #(60 61).
			self step.
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $D)
						or: [ (currentCharacter between: $F and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan9 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $N
		ifTrue:
			[ ^ self scan9X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $M)
						or: [ (currentCharacter between: $O and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan9X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $C
		ifTrue:
			[ ^ self scan9X1X1 ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $B)
						or: [ (currentCharacter between: $D and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scan9X1X1 [
	self recordMatch: #(61).
	self step.
	currentCharacter == $T
		ifTrue: [ self recordMatch: #(61).
			self step.
			currentCharacter == $I
				ifTrue: [ self recordMatch: #(61).
					self step.
					currentCharacter == $O
						ifTrue: [ self recordMatch: #(61).
							self step.
							currentCharacter == $N
								ifTrue: [ self recordMatch: #(12 61).
									self step.
									(('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ])
										ifTrue: [ [ self recordMatch: #(61).
											self step.
											('''.' includes: currentCharacter)
												or: [ (currentCharacter between: $0 and: $9)
														or: [ (currentCharacter between: $A and: $Z)
																or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
												whileTrue ].
									^ self reportLastMatch ].
							(('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $M)
												or: [ (currentCharacter between: $O and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
								ifTrue: [ [ self recordMatch: #(61).
									self step.
									('''.' includes: currentCharacter)
										or: [ (currentCharacter between: $0 and: $9)
												or: [ (currentCharacter between: $A and: $Z)
														or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
										whileTrue ].
							^ self reportLastMatch ].
					(('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $N)
										or: [ (currentCharacter between: $P and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
						ifTrue: [ [ self recordMatch: #(61).
							self step.
							('''.' includes: currentCharacter)
								or: [ (currentCharacter between: $0 and: $9)
										or: [ (currentCharacter between: $A and: $Z)
												or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
								whileTrue ].
					^ self reportLastMatch ].
			(('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $H)
								or: [ (currentCharacter between: $J and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
				ifTrue: [ [ self recordMatch: #(61).
					self step.
					('''.' includes: currentCharacter)
						or: [ (currentCharacter between: $0 and: $9)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
						whileTrue ].
			^ self reportLastMatch ].
	(('''.' includes: currentCharacter)
		or: [ (currentCharacter between: $0 and: $9)
				or: [ (currentCharacter between: $A and: $S)
						or: [ (currentCharacter between: $U and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ [ self recordMatch: #(61).
			self step.
			('''.' includes: currentCharacter)
				or: [ (currentCharacter between: $0 and: $9)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ]
				whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> scanForToken [
	state == #doc
		ifTrue: [ ^ self scan13 ].
	state == #default
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
OccamCoreScanner >> tokenActions [
	^ #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #whitespace #comment #newline nil #queryeol #bangeol)
]
