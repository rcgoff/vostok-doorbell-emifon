;
;  8048 Disassembly of emifon.bin
;  12/15/2018 19:08
;firmware:KR1816WE48-02 (or -2)
;device can remember user defined sequence up to 52 notes
;i.e. it can use 52 bytes of memory and left to systeem needs only 12 bytes, 8 registers + two stack entries
;
;music playing, sound generation routines are close similar to DOORBELL (firmware KR1816WE48-01)
;stored tunes format is identical
;but "tone duration tables" are different


;REGISTERS:
;R0 - tune start address
;R1
;R2
;R3 - ??used as port2 copy (see TMRTON)
;R4 - ??user flag register
;R5 - depends on musical tone
;R6
;R7 - depends on tone duration         

;
	org	0
;
	anl	p2,#0d0h	; 0000 - 9a d0	.P
	mov	a,r3		; 0002 - fb	{
X0003:	outl	p2,a		; 0003 - 3a	:
	mov	r2,#0dfh	; 0004 - ba df	:_
	jmp	X02e8		; 0006 - 44 e8	Dh
;
X0008:	jmp	X0203		; 0008 - 44 03	D.
;
X000a:	in	a,p1		; 000a - 09	.	;here we, for example, after tone processing
	cpl	a		; 000b - 37	7
	mov	r1,a		; 000c - a9	)
	jf0	X0020		; 000d - b6 20	6 
	jz	X0029		; 000f - c6 29	F)
X0011:	cpl	f0		; 0011 - 95	.
	mov	a,r4		; 0012 - fc	|
X0013:	jb3	X0026		; 0013 - 72 26	r&
X0015:	mov	a,r1		; 0015 - f9	y
	anl	a,#0f0h		; 0016 - 53 f0	Sp
	jnz	X0037		; 0018 - 96 37	.7
	mov	a,r1		; 001a - f9	y
	orl	a,#0d0h		; 001b - 43 d0	CP	;reading some table at 0d0h!
	movp	a,@a		; 001d - a3	#
	jmp	X003d		; 001e - 04 3d	.=
;
X0020:	db	0,0,0,0,0	; 0020 - 00	.	; data truncated
;
	org	25h
;
X0025:	nop			; 0025 - 00	.
X0026:	nop			; 0026 - 00	.
	jmp	X0030		; 0027 - 04 30	.0
;
X0029:	mov	a,r4		; 0029 - fc	|
	jb3	X0025		; 002a - 72 25	r%
	mov	a,r2		; 002c - fa	z
	add	a,#8		; 002d - 03 08	..
	mov	r2,a		; 002f - aa	*
X0030:	mov	a,#3		; 0030 - 23 03	#.
X0032:	dec	a		; 0032 - 07	.
	jnz	X0032		; 0033 - 96 32	.2
	jmp	X0041		; 0035 - 04 41	.A
;
X0037:	nop			; 0037 - 00	.
	swap	a		; 0038 - 47	G
	orl	a,#0d0h		; 0039 - 43 d0	CP	;reading some table at 0d0h!
	movp	a,@a		; 003b - a3	#
	swap	a		; 003c - 47	G
X003d:	anl	a,#0fh		; 003d - 53 0f	S.
	add	a,r2		; 003f - 6a	j
	mov	r2,a		; 0040 - aa	*
X0041:	mov	a,r3		; 0041 - fb	{
	jb4	X0057		; 0042 - 92 57	.W
	add	a,#0f0h		; 0044 - 03 f0	.p
	mov	r3,a		; 0046 - ab	+
	mov	a,r4		; 0047 - fc	|
	jf0	X0066		; 0048 - b6 66	6f
	mov	r2,#0dfh	; 004a - ba df	:_
	anl	a,#0f7h		; 004c - 53 f7	Sw
X004e:	clr	f0		; 004e - 85	.
	mov	r4,a		; 004f - ac	,
X0050:	jb5	X006a		; 0050 - b2 6a	2j
	jb3	X008e		; 0052 - 72 8e	r.
	nop			; 0054 - 00	.
X0055:	jmp	X006f		; 0055 - 04 6f	.o
;
X0057:	jb7	X00c2		; 0057 - f2 c2	rB
	add	a,#70h		; 0059 - 03 70	.p
	nop			; 005b - 00	.	; data truncated
;
	org	5fh
;
X005f:	mov	r3,a		; 005f - ab	+
	mov	a,r4		; 0060 - fc	|
	jmp	X0050		; 0061 - 04 50	.P
;
	org	64h
;
X0064:	jmp	X0087		; 0064 - 04 87	..
;
X0066:	orl	a,#8		; 0066 - 43 08	C.
	jmp	X004e		; 0068 - 04 4e	.N
;
X006a:	jb3	X0055		; 006a - 72 55	rU
	anl	a,#0dfh		; 006c - 53 df	S_
	mov	r4,a		; 006e - ac	,
X006f:	jb4	X0073		; 006f - 92 73	.s
	jmp	X0272		; 0071 - 44 72	Dr
;
X0073:	jb2	X0080		; 0073 - 52 80	R.
	jb1	X0082		; 0075 - 32 82	2.
X0077:	nop			; 0077 - 00	.	; data truncated
;
	org	79h
;
X0079:	mov	a,#2		; 0079 - 23 02	#.
X007b:	dec	a		; 007b - 07	.
	jnz	X007b		; 007c - 96 7b	.{
X007e:	jmp	X0147		; 007e - 24 47	$G
;
X0080:	jmp	X0077		; 0080 - 04 77	.w
;
X0082:	mov	a,r6		; 0082 - fe	~
	jz	X0064		; 0083 - c6 64	Fd
	dec	r6		; 0085 - ce	N
	nop			; 0086 - 00	.
X0087:	mov	a,r4		; 0087 - fc	|
	jb3	X008c		; 0088 - 72 8c	r.
	jmp	X007e		; 008a - 04 7e	.~
;
X008c:	jmp	X02cc		; 008c - 44 cc	DL
;
X008e:	mov	a,r2		; 008e - fa	z
	movp	a,@a		; 008f - a3	#
	mov	r1,a		; 0090 - a9	)
	jb5	X00a0		; 0091 - b2 a0	2 
	mov	a,r4		; 0093 - fc	|
	jb2	X0098		; 0094 - 52 98	R.
	jmp	X02d9		; 0096 - 44 d9	DY
;
X0098:	jb4	X0079		; 0098 - 92 79	.y
	jmp	X0272		; 009a - 44 72	Dr
;
X009c:	cpl	a		; 009c - 37	7
	xrl	a,r4		; 009d - dc	\
	jmp	X02df		; 009e - 44 df	D_
;
X00a0:	jb4	X009c		; 00a0 - 92 9c	..
	jb2	X00a7		; 00a2 - 52 a7	R'
	xch	a,r4		; 00a4 - 2c	,
	anl	a,#78h		; 00a5 - 53 78	Sx
X00a7:	orl	a,r4		; 00a7 - 4c	L
	mov	r4,a		; 00a8 - ac	,
	jb2	X00ad		; 00a9 - 52 ad	R-
	jmp	X026e		; 00ab - 44 6e	Dn
;
X00ad:	jb0	X00cc		; 00ad - 12 cc	.L
	jb1	X00b3		; 00af - 32 b3	23
	jmp	X026e		; 00b1 - 44 6e	Dn
;
X00b3:	jb7	X00ba		; 00b3 - f2 ba	r:
	orl	a,#80h		; 00b5 - 43 80	C.
	mov	r4,a		; 00b7 - ac	,
	jb4	X0008		; 00b8 - 92 08	..
X00ba:	mov	r1,#0		; 00ba - b9 00	9.
X00bc:	mov	a,r4		; 00bc - fc	|
	anl	a,#0efh		; 00bd - 53 ef	So
	mov	r4,a		; 00bf - ac	,
	jmp	X0282		; 00c0 - 44 82	D.
;
X00c2:	jb6	X00c8		; 00c2 - d2 c8	RH
	add	a,#0c0h		; 00c4 - 03 c0	.@
	jmp	X005f		; 00c6 - 04 5f	._
;
X00c8:	add	a,#0e0h		; 00c8 - 03 e0	.`
	jmp	X005f		; 00ca - 04 5f	._
;
X00cc:	mov	r1,#0eh		; 00cc - b9 0e	9.
	jmp	X00bc		; 00ce - 04 bc	.<
;


	org	0d0h
;--------------------------------------------------------------------seems to me this is table, because of code is quite insane
	db	00h		; 00d0 - 00
	anl	a,@r1		; 00d1 - 51	Q
	mov	t,a		; 00d2 - 62	b
	anl	a,@r1		; 00d3 - 51	Q
;
	db	73h		; 00d4 - 73	s
;
	anl	a,@r1		; 00d5 - 51	Q
	mov	t,a		; 00d6 - 62	b
	anl	a,@r1		; 00d7 - 51	Q
	dw	5184h		; 00d8 - 84 51	.Q
;
	mov	t,a		; 00da - 62	b
	anl	a,@r1		; 00db - 51	Q
;
	db	73h		; 00dc - 73	s
;
	anl	a,@r1		; 00dd - 51	Q
	mov	t,a		; 00de - 62	b
	anl	a,@r1		; 00df - 51	Q
	mov	r7,#6		; 00e0 - bf 06	?.
	dec	a		; 00e2 - 07	.
	ins	a,bus		; 00e3 - 08	.
	in	a,p1		; 00e4 - 09	.
	movd	a,p4		; 00e5 - 0c	.
;
	db	0bh		; 00e6 - 0b	.
;
	in	a,p2		; 00e7 - 0a	.
	inc	r1		; 00e8 - 19	.
	en	i		; 00e9 - 05	.
	jmp	X0003		; 00ea - 04 03	..
;
	outl	bus,a		; 00ec - 02	.
	inc	r2		; 00ed - 1a	.
	inc	r3		; 00ee - 1b	.
	db	01h		; 00ef - 01     .---------------------insane code again, table continues here!
	movd	a,p5		; 00f0 - 0d	.
	movd	a,p6		; 00f1 - 0e	.
	movd	a,p7		; 00f2 - 0f	.
	xch	a,@r1		; 00f3 - 21	!
	xch	a,@r0		; 00f4 - 20	 
	inc	@r0		; 00f5 - 10	.
	inc	r4		; 00f6 - 1c	.
	jmp	X0118		; 00f7 - 24 18	$.
;
	inc	a		; 00f9 - 17	.
	jtf	X0015		; 00fa - 16 15	..
	call	X0011		; 00fc - 14 11	..
	dw	1312h		; 00fe - 12 13	..
;--------------------------------------------------------------------end of table (?)

X0100:	mov	a,r1		; 0100 - f9	y
	orl	a,#0e0h		; 0101 - 43 e0	C`	;start address of note=1e0+r1 (remember that we'ra at 1st page)
	movp	a,@a		; 0103 - a3	#
	mov	r0,a		; 0104 - a8	(
	mov	a,#10h		; 0105 - 23 10	#.	
	xrl	a,r4		; 0107 - dc	\	;r4 XOR 0001.0000
	orl	a,#20h		; 0108 - 43 20	C 	;a OR   0010.0000
	mov	r4,a		; 010a - ac	,
	jb4	X0111		; 010b - 92 11	..
	jmp	X0272		; 010d - 44 72	Dr
;
X010f:	inc	r0		; 010f - 18	.
	mov	a,r4		; 0110 - fc	|
X0111:	jb0	X0116		; 0111 - 12 16	..
X0113:	mov	a,@r0		; 0113 - f0	p
	jmp	X0118		; 0114 - 24 18	$.
;
;------------------------next note of tune reading (same as RD_PG3 in DOORBELL)
;r0 contains address of note
;tune array is located at 3rd page 300h-3ffh
X0116:	mov	a,r0		; 0116 - f8	x
	movp3	a,@a		; 0117 - e3	c
X0118:	jz	X012c		; 0118 - c6 2c	F,	;x012c - end of playing (after reading 0)

;--------------------------note code parser (same as PG2GET in DOORBELL)
X011a:	mov	r1,a		; 011a - a9	)
	anl	a,#1fh		; 011b - 53 1f	S.
	orl	a,#0c0h		; 011d - 43 c0	C@	;1c0h is address of tone table (not 0c0h, remember that now we're at 1st page!)
	movp	a,@a		; 011f - a3	#
	mov	r5,a		; 0120 - ad	-
	mov	a,r1		; 0121 - f9	y
	anl	a,#0e0h		; 0122 - 53 e0	S`
	rr	a		; 0124 - 77	w
	swap	a		; 0125 - 47	G
	add	a,#78h		; 0126 - 03 78	.x	;178h is address of note duration table (not 078h, remember that now we're at 1st page!)
	movp	a,@a		; 0128 - a3	#
	mov	r7,a		; 0129 - af	/
	jmp	X02a2		; 012a - 44 a2	D"
;
;(x02a2 is something like DELAY in DOORBELL and after it jumps to X014d)
;
X012c:	jmp	X0290		; 012c - 44 90	D.
;
X012e:	mov	r7,#83h		; 012e - bf 83	?.
	mov	r6,#80h		; 0130 - be 80	>.
	mov	a,r4		; 0132 - fc	|
	jb1	X0145		; 0133 - 32 45	2E
	orl	a,#2		; 0135 - 43 02	C.
	mov	r0,#9		; 0137 - b8 09	8.
X0139:	orl	a,#30h		; 0139 - 43 30	C0
	mov	r4,a		; 013b - ac	,
	mov	a,r1		; 013c - f9	y
	mov	@r0,a		; 013d - a0	 
X013e:	orl	a,#0c0h		; 013e - 43 c0	C@
	movp	a,@a		; 0140 - a3	#
	mov	r5,a		; 0141 - ad	-
	nop			; 0142 - 00	.
	jmp	X02a2		; 0143 - 44 a2	D"
;
X0145:	jmp	X02b1		; 0145 - 44 b1	D1
;
X0147:	mov	r1,#8		; 0147 - b9 08	9.
	mov	a,@r1		; 0149 - f1	q
	jnz	X0164		; 014a - 96 64	.d
	inc	r7		; 014c - 1f	.
X014d:	mov	a,r7		; 014d - ff	.
	movp	a,@a		; 014e - a3	#
X014f:	jz	X0166		; 014f - c6 66	Ff
	mov	r1,a		; 0151 - a9	)
	rr	a		; 0152 - 77	w
	swap	a		; 0153 - 47	G
	anl	a,#7		; 0154 - 53 07	S.
	xch	a,r3		; 0156 - 2b	+
	anl	a,#0f8h		; 0157 - 53 f8	Sx
	orl	a,r3		; 0159 - 4b	K
	mov	r3,a		; 015a - ab	+
	mov	a,r1		; 015b - f9	y
	anl	a,#1fh		; 015c - 53 1f	S.
	mov	r1,#8		; 015e - b9 08	9.
	mov	@r1,a		; 0160 - a1	!
	clr	f1		; 0161 - a5	%
	jmp	X02d1		; 0162 - 44 d1	DQ
;
X0164:	jmp	X02c2		; 0164 - 44 c2	DB
;
X0166:	mov	a,r4		; 0166 - fc	|
	jb2	X016b		; 0167 - 52 6b	Rk
	jb1	X0172		; 0169 - 32 72	2r
X016b:	mov	a,r3		; 016b - fb	{
	anl	a,#0f0h		; 016c - 53 f0	Sp
	mov	r3,a		; 016e - ab	+
	outl	p2,a		; 016f - 3a	:
	jmp	X010f		; 0170 - 24 0f	$.
;
X0172:	jmp	X0200		; 0172 - 44 00	D.
	db	0,0,0,0
;
	org	178h
;---------------------------------------duration table index(8 entries) - absolutely identical to table at DOORBELL at 083h-0b8h
DURADDR:
	db	DUR0 mod 100h	; 0178 - 80     .
	db	DUR1 mod 100h	; 0179 - 8b     .
	db	DUR2 mod 100h	; 017a - 90     .
	db	DUR3 mod 100h	; 017b - 98
	db	DUR4 mod 100h	; 017c - a0     .
	db	DUR5 mod 100h	; 017d - a8     (
	db	DUR6 mod 100h	; 017e - b0
	db	DUR7 mod 100h	; 017f - b8     08

;---------------------------------------duration tables below are different from DOORBELL values
;---------------------------------------duration table for 80h
DUR0:
	db	0e3h		; 0180 - e3     c
	db	23h
	db	00h		; 0181 - 23 00  #.
	db	0c7h		; 0183 - c7     G
	db	0a7h		; 0184 - a7     '
	db	87h		; 0185 - 87     .
	db	67h		; 0186 - 67     g
	db	47h		; 0187 - 47     G
	db	27h		; 0188 - 27     '
	db	00h		; 0189 - 00     .       ; data truncated
	db	00h


;---------------------------------------duration table for 8bh
DUR1:
	db	0e3h		; 018b - e3     c
	db	0a3h		; 018c - a3     #
	db	63h		; 018d - 63     c
	db	23h
	db	00h		; 018e - 23 00  #.

;---------------------------------------duration table for 90h
DUR2:
	db	0e3h		; 0190 - e3     c
	db	0c3h		; 0191 - c3     C
	db	0a3h		; 0192 - a3     #
	db	83h		; 0193 - 83     .
	db	63h		; 0194 - 63     c
	db	23h
	db	00h		; 0195 - 23 00  #.
	db	00h		; 0197 - 00     .

;---------------------------------------duration table for 98h
DUR3:
	db	0e7h		; 0198 - e7     g
	db	0c3h		; 0199 - c3     C
	db	0a3h		; 019a - a3     #
	db	83h		; 019b - 83     .
	db	63h		; 019c - 63     c
	db	43h
	db	23h		; 019d - 43 23  C#
	db	00h		; 019f - 00     .

;---------------------------------------duration table for a0h
DUR4:
	db	0f8h	; 01a0 - f8     x
	db	0c3h	; 01a1 - c3     C
	db	0a3h	; 01a2 - a3     #
	db	83h	; 01a3 - 83     .
	db	63h	; 01a4 - 63     c
	db	43h
	db	23h	; 01a5 - 43 23  C#
	db	00h	; 01a7 - 00     .

;;---------------------------------------duration table for a8h
DUR5:
	db	0efh
	db	0c7h	; 01a8 - ef c7  oG
	db	0a7h	; 01aa - a7     '
	db	87h	; 01ab - 87     .
	db	67h	; 01ac - 67     g
	db	47h	; 01ad - 47     G
	db	27h	; 01ae - 27     '
	db	00h	; 01af - 00     .

;---------------------------------------duration table for b0h
DUR6:
	db	0efh
	db	0cfh	; 01b0 - ef cf  oO
	db	8fh	; 01b2 - 8f     .
	db	6fh	; 01b3 - 6f     o
	db	4fh	; 01b4 - 4f     O
	db	2fh	; 01b5 - 2f     /
	db	00h	; 01b6 - 00     .       ; data truncated
	db	00h

;---------------------------------------duration table for b8h
DUR7:
	db	0ffh	; 01b8 - ff
	db	0cfh	; 01b9 - cf     O
	db	0afh	; 01ba - af     /
	db	8fh	; 01bb - 8f     .
	db	6fh	; 01bc - 6f     o
	db	4fh	; 01bd - 4f     O
	db	2fh	; 01be - 2f     /
	db	00h	; 01bf - 00     .       ; data truncated


;-----------------------------------------------------musical tones table (absolutely identical to table at DOORBELL at 0c0-0dd)
;-----------------------------------------------------the higher the address, the higher the tone and the lower the value
;-----------------------------------------------------seems to me, 0d,0e,0f are 'small octave' values, becuse they has lowest values
	org     1c0h
TONETAB:
	db	00h
	db	0adh	;01=1.do
	db	0a2h	;02=1.do#
	db	95h	;03=1.re
	db	8bh	;04=1.re#
	db	81h	;05=1.mi
	db	77h	;06=1.fa
	db	6eh	;07=1.fa#
	db	66h	;08=1.sol
	db	5eh	;09=1.sol#
	db	56h	;0a=1.la
	db	4fh	;0b=1.la#
	db	49h	;0c=1.si
	db	0d5h	;0d=small.la
	db	0c7h	;0e=small.la#
	db	0b9h	;0f=small.si
	db	00h
	db	43h	;11=2.do
	db	3dh	;12=2.do#
	db	37h	;13=2.re
	db	32h	;14=2.re#
	db	2eh	;15=2.mi
	db	28h	;16=2.fa
	db	23h	;17=2.fa#
	db	1fh	;18=2.sol
	db	1bh	;19=2.sol#
	db	17h	;1a=2.la
	db	14h	;1b=2.la#
	db	11h	;1c=2.si
	db	00h
;--------------------------------------------------------
;
	org	1e0h
;----------------------------------------------------------------------tune address table
;offset of this table is note code (tune selection performs by pressing corresponding note on keyboard)
;note code is the same as stores in tune data, the same as table at 01c0h and in DOORBELL
;only 6 first left black keys turn tunes on
;don't undesrtand value at offset 00h, this note was undefined in doorbell
							;offset----note--------tune
	in	a,p1		; 01e0 - 09	.	;00h-----------------------------------------?????unknown note????----????not a tune address???
	db	TUNE0 mod 100h	; 01e1 - 00		;01h	- 1.do  - beep
	db	TUNE2 mod 100h	; 01e2 - 20  . 		;02h	- 1.do# - Ya na solnyshke lezhu
	db	TUNE0 mod 100h	; 01e3 - 00		;03h	- 1.re  - beep
	db	TUNE3 mod 100h	; 01e4 - 3f  .?		;04h 	- 1.re# - Pust vsegda budet solntse
	db	TUNE0 mod 100h	; 01e5 - 00		;05h	- 1.mi	- beep
	db	TUNE0 mod 100h	; 01e6 - 00 		;06h	- 1.fa	- beep
	db	TUNE4 mod 100h	; 01e6 - 5c  .\		;07h	- 1.fa# - Goluboi vagon
	db	TUNE0 mod 100h	; 01e8 - 00 		;08h	- 1.sol - beep
	db	TUNE5 mod 100h	; 01e9 - 89  ..		;09h	- 1.sol#- Vmeste veselo shagat
	db	TUNE0 mod 100h	; 01ea - 00		;0ah	- 1.la	- beep
	db	TUNE6 mod 100h	; 01eb - b1  .1		;0bh	- 1.la# - Bremenskiye muzykanty
							;	- 1.si, 0.la -beep
org	1eeh						;
	db	TUNE1 mod 100h	; 01ee - 02	.	;0eh	- 0.la# - Krylatye kacheli   (this is left-most black key, 1st tune, but last table entry!)
							; 	- 0.si and all notes in 2nd octave are beeps (00h)

	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-------------------------------------------------------------------------
;
	org	200h
;
X0200:	anl	a,#0efh		; 0200 - 53 ef	So
	mov	r4,a		; 0202 - ac	,
X0203:	mov	a,r3		; 0203 - fb	{
	anl	a,#0f0h		; 0204 - 53 f0	Sp
	mov	r3,a		; 0206 - ab	+
	outl	p2,a		; 0207 - 3a	:
	mov	a,r0		; 0208 - f8	x
	orl	a,#0c0h		; 0209 - 43 c0	C@
	cpl	a		; 020b - 37	7
	jz	X023a		; 020c - c6 3a	F:
	inc	r0		; 020e - 18	.
	mov	@r0,#0		; 020f - b0 00	0.
	dec	r0		; 0211 - c8	H
	mov	r5,#0		; 0212 - bd 00	=.
	mov	a,r6		; 0214 - fe	~
	cpl	a		; 0215 - 37	7
	jb6	X0220		; 0216 - d2 20	R 
	jb5	X0224		; 0218 - b2 24	2$
	jb4	X0228		; 021a - 92 28	.(
	jb3	X0232		; 021c - 72 32	r2
	jmp	X0233		; 021e - 44 33	D3
;
X0220:	jb5	X022c		; 0220 - b2 2c	2,
	jmp	X022d		; 0222 - 44 2d	D-
;
X0224:	jb4	X022e		; 0224 - 92 2e	..
	jmp	X022f		; 0226 - 44 2f	D/
;
X0228:	jb3	X0230		; 0228 - 72 30	r0
	jmp	X0231		; 022a - 44 31	D1
;
X022c:	inc	r5		; 022c - 1d	.
X022d:	inc	r5		; 022d - 1d	.
X022e:	inc	r5		; 022e - 1d	.
X022f:	inc	r5		; 022f - 1d	.
X0230:	inc	r5		; 0230 - 1d	.
X0231:	inc	r5		; 0231 - 1d	.
X0232:	inc	r5		; 0232 - 1d	.
X0233:	mov	a,r5		; 0233 - fd	}
	rl	a		; 0234 - e7	g
	swap	a		; 0235 - 47	G
	mov	r5,a		; 0236 - ad	-
	mov	a,@r0		; 0237 - f0	p
	orl	a,r5		; 0238 - 4d	M
	mov	@r0,a		; 0239 - a0	 
X023a:	mov	a,r4		; 023a - fc	|
	jb4	X02d3		; 023b - 92 d3	.S
	jmp	X0277		; 023d - 44 77	Dw
;
	org	242h
;
X0242:	nop			; 0242 - 00	.


;-----------------------------------------------------------
;TONE player
;------------very similar to tone processing in DOORBELL
;------------but little bit DIFFERENT! from 024d.
;------------namely, don't read port but use R3
;------------algorithm is quite the same.
TMRTON:	mov	a,#5dh		; 0243 - 23 5d	#]
	mov	t,a		; 0245 - 62	b
	strt	t		; 0246 - 55	U
TONE:	mov	a,r5		; 0247 - fd	}
	jz	MUSPAUSE	; 0248 - c6 5b	F[
TONLP:	dec	a		; 024a - 07	.
	jnz	TONLP		; 024b - 96 4a	.J
	mov	a,#8		; 024d - 23 08	#.
	xrl	a,r3		; 024f - db	[	;invert bit 3 in r3
TMRCHK:	mov	r3,a		; 0250 - ab	+
	outl	p2,a		; 0251 - 3a	:	;output r3 to port 2 (with inverted bit 3 if it isn't pause)
	jtf	X0260		; 0252 - 16 60	.`	;leave tone player after timer overflow
	mov	a,#23h		; 0254 - 23 23	##
LOWLP:	dec	a		; 0256 - 07	.
	jnz	LOWLP		; 0257 - 96 56	.V
	jmp	TONE		; 0259 - 44 47	DG
MUSPAUSE:
 	mov	a,r3		; 025b - fb	{
	anl	a,#0f7h		; 025c - 53 f7	Sw
	jmp	TMRCHK		; 025e - 44 50	DP
;----------------------------------------------------------------

X0260:	nop			; 0260 - 00	.	
        nop			; 0261 - 00     .
        nop			; 0262 - 00     .
	jmp	X000a		; 0263 - 04 0a	..
	db	0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
;
	org	26eh
;
X026e:	mov	a,r4		; 026e - fc	|
	anl	a,#0efh		; 026f - 53 ef	So
	mov	r4,a		; 0271 - ac	,
X0272:	mov	a,r3		; 0272 - fb	{
	anl	a,#0f0h		; 0273 - 53 f0	Sp
	mov	r3,a		; 0275 - ab	+
	outl	p2,a		; 0276 - 3a	:
X0277:	mov	r1,#3		; 0277 - b9 03	9.
X0279:	mov	a,#0feh		; 0279 - 23 fe	#~
X027b:	dec	a		; 027b - 07	.
	jnz	X027b		; 027c - 96 7b	.{
	djnz	r1,X0279	; 027e - e9 79	iy
	jmp	X000a		; 0280 - 04 0a	..
;
X0282:	mov	a,r3		; 0282 - fb	{
	anl	a,#0f0h		; 0283 - 53 f0	Sp
	mov	r3,a		; 0285 - ab	+
	outl	p2,a		; 0286 - 3a	:
	mov	a,r4		; 0287 - fc	|
	jb2	X028e		; 0288 - 52 8e	R.
	jb0	X028e		; 028a - 12 8e	..
	jmp	X012e		; 028c - 24 2e	$.
;
X028e:	jmp	X0100		; 028e - 24 00	$.
;
X0290:	mov	a,r4		; 0290 - fc	|
	jb0	X0295		; 0291 - 12 95	..
	jmp	X02f8		; 0293 - 44 f8	Dx
;
X0295:	jb2	X0299		; 0295 - 52 99	R.
	jmp	X029e		; 0297 - 44 9e	D.
;
X0299:	inc	r0		; 0299 - 18	.
	mov	a,r0		; 029a - f8	x
	movp3	a,@a		; 029b - e3	c
	jnz	X02a0		; 029c - 96 a0	. 
X029e:	jmp	X026e		; 029e - 44 6e	Dn
;
X02a0:	jmp	X011a		; 02a0 - 24 1a	$.
;
;----------------------------------------------------------------delay-like init routine
X02a2:	mov	a,r3		; 02a2 - fb	{
	orl	a,#8		; 02a3 - 43 08	C.
	mov	r3,a		; 02a5 - ab	+
	mov	r1,#6		; 02a6 - b9 06	9.
X02a8:	mov	a,#0deh		; 02a8 - 23 de	#^
X02aa:	dec	a		; 02aa - 07	.
	jnz	X02aa		; 02ab - 96 aa	.*
	djnz	r1,X02a8	; 02ad - e9 a8	i(
	jmp	X014d		; 02af - 24 4d	$M
;-----------------------------------------------------------------
;
X02b1:	mov	a,r0		; 02b1 - f8	x
	add	a,#0c1h		; 02b2 - 03 c1	.A
	cpl	a		; 02b4 - 37	7
	jz	X02bb		; 02b5 - c6 bb	F;
	inc	r0		; 02b7 - 18	.
	mov	a,r4		; 02b8 - fc	|
	jmp	X0139		; 02b9 - 24 39	$9
;
X02bb:	mov	a,r4		; 02bb - fc	|
	orl	a,#30h		; 02bc - 43 30	C0
	mov	r4,a		; 02be - ac	,
	mov	a,r1		; 02bf - f9	y
	jmp	X013e		; 02c0 - 24 3e	$>
;
X02c2:	dec	a		; 02c2 - 07	.
	mov	@r1,a		; 02c3 - a1	!
	mov	a,#5		; 02c4 - 23 05	#.
X02c6:	dec	a		; 02c6 - 07	.
	nop			; 02c7 - 00	.
	jnz	X02c6		; 02c8 - 96 c6	.F
	jmp	TMRTON		; 02ca - 44 43	DC
;
X02cc:	mov	a,#0ah		; 02cc - 23 0a	#.
X02ce:	dec	a		; 02ce - 07	.
	jnz	X02ce		; 02cf - 96 ce	.N
X02d1:	jmp	X0242		; 02d1 - 44 42	DB
;
X02d3:	jb2	X02d7		; 02d3 - 52 d7	RW
	jmp	X012e		; 02d5 - 24 2e	$.
;
X02d7:	jmp	X00ba		; 02d7 - 04 ba	.:
;
X02d9:	jb0	X0282		; 02d9 - 12 82	..
	jb4	X0203		; 02db - 92 03	..
	jmp	X0282		; 02dd - 44 82	D.
;
X02df:	orl	a,#20h		; 02df - 43 20	C 
	mov	r4,a		; 02e1 - ac	,
	jb4	X02e6		; 02e2 - 92 e6	.f
	jmp	X0272		; 02e4 - 44 72	Dr
;
X02e6:	jmp	X007e		; 02e6 - 04 7e	.~
;
X02e8:	clr	a		; 02e8 - 27	'
	jni	X02ee		; 02e9 - 86 ee	.n
X02eb:	mov	r4,a		; 02eb - ac	,
	jmp	X000a		; 02ec - 04 0a	..
;
X02ee:	jnt0	X02f2		; 02ee - 26 f2	&r
	orl	a,#1		; 02f0 - 43 01	C.
X02f2:	jnt1	X02eb		; 02f2 - 46 eb	Fk
	orl	a,#40h		; 02f4 - 43 40	C@
	jmp	X02eb		; 02f6 - 44 eb	Dk
;
X02f8:	jb6	X02fc		; 02f8 - d2 fc	R|
	jmp	X026e		; 02fa - 44 6e	Dn
;
X02fc:	mov	r0,#9		; 02fc - b8 09	8.
	jmp	X0113		; 02fe - 24 13	$.


;-----------------------------------------------------------------------------------------tunes
INCLUDE "TUNES-EM.ASM"


	end
