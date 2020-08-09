Class {
	#name : #TestTypechecker,
	#superclass : #TestCase,
	#category : #'Occam-Core-Tests'
}

{ #category : #tests }
TestTypechecker >> testAlt [

| aParser anAST |

aParser := OccamCoreParser on: (ReadStream on:
'PROC p()
  TIMER t :
  TIME now :
  INT x :
  INT y :
  CHAN OF INT c :
  SEQ
    t?now
    ALT
      TRUE & c?x
        SKIP
      c?y
        y := 2 + x
      FALSE
        SKIP
      t? AFTER 5 + now
        SKIP
:').

aParser setStartingState: OccamCoreParser startingStateForProcedure.

anAST := aParser parse.

TypeChecker check: anAST inContext: nil.

self assert: anAST isValid 

]

{ #category : #tests }
TestTypechecker >> testArrays [

| aParser anAST |

aParser := OccamCoreParser on: (ReadStream on:
'PROC p()
  [5]INT a :
  [5]INT b :
  [3][3][3] BYTE c :
  SEQ
    a[2] := b[1]
    c[0][1][2] := c[2][1][0] + 1
    b[FROM 1 FOR 3] := a[FROM 0 FOR 3]
:').

aParser setStartingState: OccamCoreParser startingStateForProcedure.

anAST := aParser parse.

TypeChecker check: anAST inContext: nil.

self assert: anAST isValid.

]

{ #category : #tests }
TestTypechecker >> testChannels [

| aParser anAST |

aParser := OccamCoreParser on: (ReadStream on:
'PROC p()
  CHAN OF INT a :
  CHAN OF INT b :
  TIMER t :
  TIME x :
  INT y :
  [2] CHAN OF INT c :
  SEQ
    t?x
    PAR
      a!1
      a?y
    PAR
      c[0]!y
      c[1]?y
:').

aParser setStartingState: OccamCoreParser startingStateForProcedure.

anAST := aParser parse.

TypeChecker check: anAST inContext: nil.

self assert: anAST isValid.

]

{ #category : #tests }
TestTypechecker >> testConversion [

| aParser anAST |

aParser := OccamCoreParser on: (ReadStream on:
'PROC p()
  BOOL a :
  BYTE b :
  INT c :
  INT16 d :
  INT32 e :
  REAL32 f :
  REAL64 g :
  SEQ
    a := TRUE 
    a := FALSE
    b := (BYTE 92)
    c := (INT 12.5)
    d := (INT16 0.5)
    e := (INT32 10.01)
    f := (REAL32 1)
    g := (REAL64 2)
:').

aParser setStartingState: OccamCoreParser startingStateForProcedure.

anAST := aParser parse.

TypeChecker check: anAST inContext: nil.

self assert: anAST isValid.

]

{ #category : #tests }
TestTypechecker >> testExpressions [

| aParser anAST |

aParser := OccamCoreParser on: (ReadStream on:
'PROC p()
  BOOL a :
  BYTE b :
  INT c :
  INT16 d :
  INT32 e :
  REAL32 f :
  REAL64 g.x :
  [ 3 ] INT aa :
  [ 16 ] BYTE s :
  VAL PI IS 3.14 :
  VAL one IS 1 :
  VAL hello IS "Hello" :
  SEQ
    a := TRUE AND FALSE
    a := TRUE OR TRUE
    a := NOT FALSE  
    b := (BYTE 5) /\ (BYTE 3)
    b := (BYTE 5) \/ (BYTE 3)
    b := (BYTE 5) >< (BYTE 3)
    b := ~(BYTE 5) 
    b := ''a''
    c := 5 + (2 * 3)
    c := (SIZE aa) + (BYTESIN BYTE)
    d := 8 - (20 / #5F)
    e := 10 \ 7
    f := 12.5E-01 * (4.7 + (PI * 0.3))
    g.x := 1.0E+001 * (18.3 / 0.1)
    a := 3 AFTER 5
    aa := [ 1, 2, 3 ]
    s := "**Hello, *"World*"**"
:').

aParser setStartingState: OccamCoreParser startingStateForProcedure.

anAST := aParser parse.

TypeChecker check: anAST inContext: nil.

self assert: anAST isValid.

]

{ #category : #tests }
TestTypechecker >> testFunctions [

| aParser anAST |

aParser := OccamCoreParser on: (ReadStream on:
'PROC p()
  INT x :
  INT FUNCTION q (VAL INT a)
    INT y :
    SEQ
      y := 5
      RESULT a + y
  :
  INT FUNCTION h (VAL INT a)
    INT FUNCTION k (VAL INT x)
      RESULT x + 1
    :
    RESULT k(a)
  :
  SEQ
    x := q(1) + h(1)
:').

aParser setStartingState: OccamCoreParser startingStateForProcedure.

anAST := aParser parse.

TypeChecker check: anAST inContext: nil.

self assert: anAST isValid.

]

{ #category : #tests }
TestTypechecker >> testIf [

| aParser anAST |

aParser := OccamCoreParser on: (ReadStream on:
'PROC p()
  INT x :
  IF
    TRUE
      x := 1
    FALSE
      SKIP
:').

aParser setStartingState: OccamCoreParser startingStateForProcedure.

anAST := aParser parse.

TypeChecker check: anAST inContext: nil.

self assert: anAST isValid.

]

{ #category : #tests }
TestTypechecker >> testParallel [

| aParser anAST |

aParser := OccamCoreParser on: (ReadStream on:
'PROC p()
  CHAN OF INT c :
  INT x :
  PAR
    c!5
    c?x
    STOP
:').

aParser setStartingState: OccamCoreParser startingStateForProcedure.

anAST := aParser parse.

TypeChecker check: anAST inContext: nil.

self assert: anAST isValid.

]

{ #category : #tests }
TestTypechecker >> testProcedures [

| aParser anAST |

aParser := OccamCoreParser on: (ReadStream on:
'PROC p()
  INT x :
  PROC q (INT a)
    a := 5
  :
  PROC h (VAL INT a)
    x := a
  :
  SEQ
    q(x)
    h(3)
:').

aParser setStartingState: OccamCoreParser startingStateForProcedure.

anAST := aParser parse.

TypeChecker check: anAST inContext: nil.

self assert: anAST isValid.

]

{ #category : #tests }
TestTypechecker >> testReplicatedSeq [

| aParser anAST |

aParser := OccamCoreParser on: (ReadStream on:
'PROC p()
  [ 10 ] INT a :
  SEQ i = 2 FOR 5
    a[i] := i + 1
:').

aParser setStartingState: OccamCoreParser startingStateForProcedure.

anAST := aParser parse.

TypeChecker check: anAST inContext: nil.

self assert: anAST isValid.

]

{ #category : #tests }
TestTypechecker >> testWhile [

| aParser anAST |

aParser := OccamCoreParser on: (ReadStream on:
'PROC p()
  INT x :
  WHILE TRUE
    x := 5
:').

aParser setStartingState: OccamCoreParser startingStateForProcedure.

anAST := aParser parse.

TypeChecker check: anAST inContext: nil.

self assert: anAST isValid.

]
