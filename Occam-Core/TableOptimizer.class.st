"
I optimize the assignment of literal tables.

The assignment 

lvalue := [ [ a00 , ... , a0n ], ... , [am0 , ... , amn ] ]

becomes

SEQ
  SEQ
    lvalue[0][0] := a00
    lvalue[0][1] :=	a01
	...
	lvalue[0][n] := a0n 
  ... 
  SEQ
    lvalue[m][0] := am0
    lvalue[m][1] :=	am1
	...
	lvalue[m][n] := amn 
"
Class {
	#name : #TableOptimizer,
	#superclass : #ASTRootVisitor,
	#category : #'Occam-Core-Compiler'
}

{ #category : #generated }
TableOptimizer >> visitAssign: anAssignment [

	| aSeq index |
	
	(anAssignment expr isKindOf: ASTTable) ifFalse:[^self].
		
	index := 0.

	aSeq := ASTSeq new.

	aSeq eNDToken:(SmaCCToken value:'').
	
	anAssignment expr exprs do:[:each | | eachAssignment eachLvalue eachIndex |

		"lvalue[index] := each"

		eachIndex := ASTLiteralInteger new.
		eachIndex integer: (SmaCCToken value: index asString).
						
		eachLvalue := ASTArrayComponent new.
		eachLvalue array: anAssignment lvalue copyTree.
		eachLvalue expr: eachIndex.
		 
		eachAssignment := ASTAssign new.
		
		eachAssignment lvalue: eachLvalue.
		eachAssignment expr: each copyTree.
				
		aSeq processes add: eachAssignment.

		index := index + 1.
	].
	
	aSeq parent: anAssignment parent.
	
	aSeq processes do:[:each | self acceptNode: each ].
		
	anAssignment become: aSeq.

]
