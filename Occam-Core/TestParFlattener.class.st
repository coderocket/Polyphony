Class {
	#name : #TestParFlattener,
	#superclass : #TestCase,
	#category : #'Occam-Core-Tests'
}

{ #category : #tests }
TestParFlattener >> testDeepParPar [

| aParPar aPar |

aParPar := 
'PAR
  PAR
    SKIP
    PAR
      PAR
        SKIP
      SKIP
      SKIP
' asOccamProcess.

aPar := 
'PAR
  SKIP
  SKIP
  SKIP
  SKIP
' asOccamProcess.

ParFlattener new acceptNode: aParPar.

self assert: aPar equals: aParPar
]

{ #category : #tests }
TestParFlattener >> testParPar [

| aParPar aPar |

aParPar := 
'PAR
  PAR
    SKIP
    SKIP
' asOccamProcess.

aPar := 
'PAR
  SKIP
  SKIP
' asOccamProcess.

ParFlattener new acceptNode: aParPar.

self assert: aPar equals: aParPar
]
