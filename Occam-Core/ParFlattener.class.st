"
I reduce the number of parallel processes by flattening nested PARs 

PAR
  ...
  PAR
    P1
    ...
    Pn
  ...

becomes

PAR
  ...
  P1
  ...
  Pn

PAR
  P1
  PAR
    P2
    P3
  P4

(PAR children) flatten = children inject: OrderedCollection new into:[:acc :each | acc addAll: each flatten. acc ]

any other kind of anASTNode flatten = OrderedCollection with: anASTNode

"
Class {
	#name : #ParFlattener,
	#superclass : #ASTRootVisitor,
	#category : #'Occam-Core-Compiler'
}

{ #category : #generated }
ParFlattener >> visitPar: anASTPar [
	anASTPar processes: (anASTPar processes inject:OrderedCollection new into:[:acc :each | acc addAll: (self acceptNode: each) flattenParallels. acc]).
	
	^anASTPar
]
