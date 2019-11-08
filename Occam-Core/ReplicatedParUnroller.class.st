Class {
	#name : #ReplicatedParUnroller,
	#superclass : #ASTRootVisitor,
	#category : #'Occam-Core-Compiler'
}

{ #category : #generated }
ReplicatedParUnroller >> visitReplicatedPar: aReplicatedPar [

	self acceptNode: aReplicatedPar process.
	
	aReplicatedPar become: aReplicatedPar unroll.
]
