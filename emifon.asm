	;
;  8048 Disassembly of emifon.bin
;  12/15/2018 19:08
;firmware:KR1816WE48-02 (or -2)
;device can remember user defined sequence up to 54 notes
;i.e. it can use 54 bytes of memory and left to systeem needs only 10 bytes, 8 registers + 2 bytes also
;
;There's NO stack (for RAM ecomomy reasons) - only jumps, no calls, no returns.
;
;Here should be at least 4 modes:
;1.Playing the tune in ROM
;2.Playing notes played on keyboard
;3.Memorising a melody played on keyboard
;4.Playing memorised melody from RAM
;
;music playing, sound generation routines are close similar to DOORBELL (firmware KR1816WE48-01)
;stored tunes format is identical
;but "tone duration tables" are different


;REGISTERS:
;R0 - tune start address
;R1 - note value read from keyboard after decoding
;R2
;R3 - used as port2 copy (see TMRTON)
;R4 - user flag register
;     R4.0 - RAM/ROM note reading
;R5 - depends on musical tone
;R6
;R7 - depends on tone duration

;PORTS:
;P0 - not used
;P1 - keyboard return
;P2.0..2 - volume DAC (fade control)
;P2.3 - tone output
;P2.4..7 - keyboard scan

;
       org     0
;
       anl     p2,#0d0h        ; 0000 - 9a d0  .P
       mov     a,r3            ; 0002 - fb     {
X0003: outl    p2,a            ; 0003 - 3a     :
       mov     r2,#0dfh        ; 0004 - ba df  :_
       jmp     X02e8           ; 0006 - 44 e8  Dh
;
X0008: jmp     X0203           ; 0008 - 44 03  D.
;
X000a: in      a,p1            ; 000a - 09     .       ;here we, for example, after tone processing (timer overflow)
       cpl     a               ; 000b - 37     7
       mov     r1,a            ; 000c - a9     )       ;R1:=inverted P1
       jf0     X0020           ; 000d - b6 20  6 
       jz      X0029           ; 000f - c6 29  F)
X0011: cpl     f0              ; 0011 - 95     .
       mov     a,r4            ; 0012 - fc     |
X0013: jb3     X0026           ; 0013 - 72 26  r&
X0015: mov     a,r1            ; 0015 - f9     y
       anl     a,#0f0h         ; 0016 - 53 f0  Sp
       jnz     X0037           ; 0018 - 96 37  .7
       mov     a,r1            ; 001a - f9     y       ;read inverted P1
       orl     a,#0d0h         ; 001b - 43 d0  CP      ;1101.0000 table at D0-DF, F0-FF?
       movp    a,@a            ; 001d - a3     #
       jmp     X003d           ; 001e - 04 3d  .=
;
X0020: db      0,0,0,0,0       ; 0020 - 00     .       ; data truncated
;
       org     25h
;
X0025: nop                     ; 0025 - 00     .
X0026: nop                     ; 0026 - 00     .
       jmp     X0030           ; 0027 - 04 30  .0
;
X0029: mov     a,r4            ; 0029 - fc     |
       jb3     X0025           ; 002a - 72 25  r%
       mov     a,r2            ; 002c - fa     z
       add     a,#8            ; 002d - 03 08  ..
       mov     r2,a            ; 002f - aa     *
X0030: mov     a,#3            ; 0030 - 23 03  #.
       dec     a               ; 0032 - 07     .
       jnz     $-1             ; 0033 - 96 32  .2
       jmp     X0041           ; 0035 - 04 41  .A
;
X0037: nop                     ; 0037 - 00     .
       swap    a               ; 0038 - 47     G
       orl     a,#0d0h         ; 0039 - 43 d0  CP      ;reading some table at 0d0h!
       movp    a,@a            ; 003b - a3     #
       swap    a               ; 003c - 47     G
X003d: anl     a,#0fh          ; 003d - 53 0f  S.      ;here we are also after 0d0 (and/or 0f0?) table reading at x0015
       add     a,r2            ; 003f - 6a     j
       mov     r2,a            ; 0040 - aa     *
X0041: mov     a,r3            ; 0041 - fb     {
       jb4     X0057           ; 0042 - 92 57  .W
       add     a,#0f0h         ; 0044 - 03 f0  .p
       mov     r3,a            ; 0046 - ab     +
       mov     a,r4            ; 0047 - fc     |
       jf0     X0066           ; 0048 - b6 66  6f
       mov     r2,#0dfh        ; 004a - ba df  :_
       anl     a,#0f7h         ; 004c - 53 f7  Sw
X004e: clr     f0              ; 004e - 85     .
       mov     r4,a            ; 004f - ac     ,
X0050: jb5     X006a           ; 0050 - b2 6a  2j
       jb3     X008e           ; 0052 - 72 8e  r.
       nop                     ; 0054 - 00     .
X0055: jmp     X006f           ; 0055 - 04 6f  .o
;
X0057: jb7     X00c2           ; 0057 - f2 c2  rB
       add     a,#70h          ; 0059 - 03 70  .p
       nop                     ; 005b - 00     .       ; data truncated
;
       org     5fh
;
X005f: mov     r3,a            ; 005f - ab     +
       mov     a,r4            ; 0060 - fc     |
       jmp     X0050           ; 0061 - 04 50  .P
;
       org     64h
;
X0064: jmp     X0087           ; 0064 - 04 87  ..
;
X0066: orl     a,#8            ; 0066 - 43 08  C.
       jmp     X004e           ; 0068 - 04 4e  .N
;
X006a: jb3     X0055           ; 006a - 72 55  rU
       anl     a,#0dfh         ; 006c - 53 df  S_
       mov     r4,a            ; 006e - ac     ,
X006f: jb4     X0073           ; 006f - 92 73  .s
       jmp     X0272           ; 0071 - 44 72  Dr
;
X0073: jb2     X0080           ; 0073 - 52 80  R.
       jb1     X0082           ; 0075 - 32 82  2.
X0077: nop                     ; 0077 - 00     .
       nop                     ; 0078 - 00     .
X0079: mov     a,#2            ; 0079 - 23 02  #.
       dec     a               ; 007b - 07     .
       jnz     $-1             ; 007c - 96 7b  .{
X007e: jmp     X0147           ; 007e - 24 47  $G
;
X0080: jmp     X0077           ; 0080 - 04 77  .w
;
X0082: mov     a,r6            ; 0082 - fe     ~
       jz      X0064           ; 0083 - c6 64  Fd
       dec     r6              ; 0085 - ce     N
       nop                     ; 0086 - 00     .
X0087: mov     a,r4            ; 0087 - fc     |
       jb3     X008c           ; 0088 - 72 8c  r.
       jmp     X007e           ; 008a - 04 7e  .~
;
X008c: jmp     X02cc           ; 008c - 44 cc  DL
;
X008e: mov     a,r2            ; 008e - fa     z
       movp    a,@a            ; 008f - a3     #       ;decode note from keyboard
       mov     r1,a            ; 0090 - a9     )       ;save it to R1
       jb5     SELMOD          ; 0091 - b2 a0  2       ;jump if it's SW1..SW3
       mov     a,r4            ; 0093 - fc     |
       jb2     X0098           ; 0094 - 52 98  R.
       jmp     X02d9           ; 0096 - 44 d9  DY
;
X0098: jb4     X0079           ; 0098 - 92 79  .y
       jmp     X0272           ; 009a - 44 72  Dr
;
X009c: cpl     a               ; 009c - 37     7
       xrl     a,r4            ; 009d - dc     \
       jmp     X02df           ; 009e - 44 df  D_
;
;process switches. 21h=SW1, 20h=SW2, 24h=SW3
SELMOD:jb4     X009c           ; 00a0 - 92 9c  ..      ;???
       jb2     X00a7           ; 00a2 - 52 a7  R'      ;jump if SW3
       xch     a,r4            ; 00a4 - 2c     ,
       anl     a,#78h          ; 00a5 - 53 78  Sx
X00a7: orl     a,r4            ; 00a7 - 4c     L
       mov     r4,a            ; 00a8 - ac     ,
       jb2     X00ad           ; 00a9 - 52 ad  R-
       jmp     X026e           ; 00ab - 44 6e  Dn
;
X00ad: jb0     X00cc           ; 00ad - 12 cc  .L
       jb1     X00b3           ; 00af - 32 b3  23
       jmp     X026e           ; 00b1 - 44 6e  Dn
;
X00b3: jb7     X00ba           ; 00b3 - f2 ba  r:
       orl     a,#80h          ; 00b5 - 43 80  C.
       mov     r4,a            ; 00b7 - ac     ,
       jb4     X0008           ; 00b8 - 92 08  ..
X00ba: mov     r1,#0           ; 00ba - b9 00  9.
X00bc: mov     a,r4            ; 00bc - fc     |
       anl     a,#0efh         ; 00bd - 53 ef  So
       mov     r4,a            ; 00bf - ac     ,
       jmp     X0282           ; 00c0 - 44 82  D.
;
X00c2: jb6     X00c8           ; 00c2 - d2 c8  RH
       add     a,#0c0h         ; 00c4 - 03 c0  .@
       jmp     X005f           ; 00c6 - 04 5f  ._
;
X00c8: add     a,#0e0h         ; 00c8 - 03 e0  .`
       jmp     X005f           ; 00ca - 04 5f  ._
;
X00cc: mov     r1,#0eh         ; 00cc - b9 0e  9.
       jmp     X00bc           ; 00ce - 04 bc  .<
;


       org     0d0h
;--------------------------------------------------------------------seems to me this is table, because of code is quite insane
       db      00h             ; 00d0 - 00
       db      51h             ; 00d1 - 51     Q
       db      62h             ; 00d2 - 62     b
       db      51h             ; 00d3 - 51     Q
       db      73h             ; 00d4 - 73     s
       db      51h             ; 00d5 - 51     Q
       db      62h             ; 00d6 - 62     b
       db      51h             ; 00d7 - 51     Q
       db      84h             ; 00d8 - 84
       db      51h             ; 00d9 - 51     .Q
       db      62h             ; 00da - 62     b
       db      51h             ; 00db - 51     Q
       db      73h             ; 00dc - 73     s
       db      51h             ; 00dd - 51     Q
       db      62h             ; 00de - 62     b
       db      51h             ; 00df - 51     Q

;note decoding table in P1
;table for P2.5
       db      0bfh            ; 00e0 - bf             ;P1.0= (undefined)
       db      06h                      06  ?.         ;P1.1=1.F
       db      07h             ; 00e2 - 07     .       ;P1.2=1.F#
       db      08h             ; 00e3 - 08     .       ;P1.3=1.G
       db      09h             ; 00e4 - 09     .       ;P1.4=1.G#
       db      0ch             ; 00e5 - 0c     .       ;P1.5=1.H
       db      0bh             ; 00e6 - 0b     .       ;P1.6=1.A#
       db      0ah             ; 00e7 - 0a     .       ;P1.7=1.A

;table for P2.6
       db      19h             ; 00e8 - 19     .       ;P1.0= (undefined),2.G#
       db      05h             ; 00e9 - 05     .       ;P1.1=1.E
       db      04h             ; 00ea - 04             ;P1.2=1.D#
       db      03h                      03  ..         ;P1.3=1.D
       db      02h             ; 00ec - 02     .       ;P1.4=1.C#
       db      1ah             ; 00ed - 1a     .       ;P1.5= (undefined),2.A
       db      1bh             ; 00ee - 1b     .       ;P1.6= (undefined),2.A#
       db      01h             ; 00ef - 01     .       ;P1.7=1.C

;table for P2.7
       db      0dh             ; 00f0 - 0d     .       ;P1.0=0.la
       db      0eh             ; 00f1 - 0e     .       ;P1.1=0.la#
       db      0fh             ; 00f2 - 0f     .       ;P1.2=0.si
       db      21h             ; 00f3 - 21     !       ;P1.3= SW1
       db      20h             ; 00f4 - 20             ;P1.4= SW2
       db      10h             ; 00f5 - 10     .       ;P1.5= (undefined),pause
       db      1ch             ; 00f6 - 1c     .       ;P1.6= (undefined),2.H
       db      24h             ; 00f7 - 24             ;P1.7= SW3

;table for P2.4
       db      18h             ; 00f8 - 18  $.         ;P1.0=2.sol
       db      17h             ; 00f9 - 17     .       ;P1.1=2.F#
       db      16h             ; 00fa - 16             ;P1.2=2.F
       db      15h             ; 00fb - 15  ..         ;P1.3=2.E
       db      14h             ; 00fc - 14             ;P1.4=2.D#
       db      11h             ; 00fd - 11  ..         ;P1.5=2.C
       db      12h             ; 00fe - 12             ;P1.6=2.C#
       db      13h             ; 00ff - 13  ..         ;P1.7=2.D
;--------------------------------------------------------------------end of tables

X0100: mov     a,r1            ; 0100 - f9     y
       orl     a,#TUNETAB mod 100h      ; 0101 - 43 e0  C`      ;start address of note=1e0+r1
       movp    a,@a            ; 0103 - a3     #
       mov     r0,a            ; 0104 - a8     (       ;r0=tune start addr
       mov     a,#10h          ; 0105 - 23 10  #.      
       xrl     a,r4            ; 0107 - dc     \       ;r4 XOR 0001.0000 - invert bit 4
       orl     a,#20h          ; 0108 - 43 20  C       ;a OR   0010.0000 - set bit 5
       mov     r4,a            ; 010a - ac     ,
       jb4     NOTE1           ; 010b - 92 11  ..      ;read the 1st note
       jmp     X0272           ; 010d - 44 72  Dr
;
;------------------------next note of tune reading
;r0 contains address of note
NXNOTE:inc     r0              ; 010f - 18     .       ;next note addr
       mov     a,r4            ; 0110 - fc     |
NOTE1: jb0     ROMTU           ; 0111 - 12 16  ..      ;r4.0=1 - ROM, r4.0=0 - RAM
X0113: mov     a,@r0           ; 0113 - f0     p       ;read from RAM
       jmp     ENDCHK          ; 0114 - 24 18  $.
ROMTU: mov     a,r0            ; 0116 - f8     x
       movp3   a,@a            ; 0117 - e3     c       ;read from ROM, tune array is located at 3rd page 300h-3ffh
ENDCHK:jz      X012c           ; 0118 - c6 2c  F,      ;x012c - end of playing (after reading 0)

;--------------------------note code parser (same as PG2GET in DOORBELL)
;input:
;r1=note code from table
;return:
;R5=note pitch
;R7=duration
NOTEPARSE: 
       mov     r1,a            ; 011a - a9     )
       anl     a,#1fh          ; 011b - 53 1f  S.
       orl     a,#TONETAB mod 100h      ; 011d - 43 c0  C@
       movp    a,@a            ; 011f - a3     #
       mov     r5,a            ; 0120 - ad     -
       mov     a,r1            ; 0121 - f9     y
       anl     a,#0e0h         ; 0122 - 53 e0  S`
       rr      a               ; 0124 - 77     w
       swap    a               ; 0125 - 47     G
       add     a,#DURADDR mod 100h      ; 0126 - 03 78  .x
       movp    a,@a            ; 0128 - a3     #
       mov     r7,a            ; 0129 - af     /
       jmp     DELAY1          ; 012a - 44 a2  D"      ;set bit 4 in r3, delay and goto x014d
;
;(DELAY1 is something like DELAY in DOORBELL and after it jumps to X014d)
;
X012c: jmp     X0290           ; 012c - 44 90  D.

;playing a note from keyboard (????)
X012e: mov     r7,#DURFREE mod 100h     ; 012e - bf 83  ?.
       mov     r6,#80h         ; 0130 - be 80  >.
       mov     a,r4            ; 0132 - fc     |
       jb1     X0145           ; 0133 - 32 45  2E
       orl     a,#2            ; 0135 - 43 02  C.
       mov     r0,#9           ; 0137 - b8 09  8.
X0139: orl     a,#30h          ; 0139 - 43 30  C0
       mov     r4,a            ; 013b - ac     ,
       mov     a,r1            ; 013c - f9     y       ;read note code from keyboard
       mov     @r0,a           ; 013d - a0             ;store note code (?) or back it up @9h
X013e: orl     a,#TONETAB mod 100h      ; 013e - 43 c0  C@
       movp    a,@a            ; 0140 - a3     #
       mov     r5,a            ; 0141 - ad     -
       nop                     ; 0142 - 00     .
       jmp     DELAY1          ; 0143 - 44 a2  D"      ;DELAY1 and goto x014d
;
X0145: jmp     X02b1           ; 0145 - 44 b1  D1
;
X0147: mov     r1,#8           ; 0147 - b9 08  9.
       mov     a,@r1           ; 0149 - f1     q       ;recall bits 4..0 of duration value
       jnz     JDURLOOP        ; 014a - 96 64  .d      
       inc     r7              ; 014c - 1f     .       ;if bits are 0, prepare addr for the next byte of duration table

X014d: mov     a,r7            ; 014d - ff     .       ;here we also after DELAY1 delay after note parse
       movp    a,@a            ; 014e - a3     #       ;read next duration table value
X014f: jz      X0166           ; 014f - c6 66  Ff      ;next note if 0
       mov     r1,a            ; 0151 - a9     )       ;backup
       rr      a               ; 0152 - 77     w
       swap    a               ; 0153 - 47     G       
       anl     a,#7            ; 0154 - 53 07  S.      ;put bits 7,6,5 of vol-duration value to 2,1,0
       xch     a,r3            ; 0156 - 2b     +       ;r3:=3 high bits of vol-dur.value in 2,1,0, a:=old r3
       anl     a,#0f8h         ; 0157 - 53 f8  Sx      ;clear bit 3 in old r3 (tone out)
       orl     a,r3            ; 0159 - 4b     K       
       mov     r3,a            ; 015a - ab     +       ;r3:=old r3 OR bits 2,1,0 = vol.value
       mov     a,r1            ; 015b - f9     y       ;restore
       anl     a,#1fh          ; 015c - 53 1f  S.      ;bits 4..0 of duration value
       mov     r1,#8           ; 015e - b9 08  9.
       mov     @r1,a           ; 0160 - a1     !       ;store it in RAM @r0 of register bank 1 (@08h)
       clr     f1              ; 0161 - a5     %
       jmp     JTMRTON         ; 0162 - 44 d1  DQ      ;jump to tone player (TMRTON)
;
JDURLOOP:
       jmp     DURLOOP         ; 0164 - 44 c2  DB      ;if bits 4..0 of duration table nonzero
;
;next note (duration table ended)
X0166: mov     a,r4            ; 0166 - fc     |
       jb2     X016b           ; 0167 - 52 6b  Rk
       jb1     X0172           ; 0169 - 32 72  2r
X016b: mov     a,r3            ; 016b - fb     {
       anl     a,#0f0h         ; 016c - 53 f0  Sp
       mov     r3,a            ; 016e - ab     +
       outl    p2,a            ; 016f - 3a     :       ;switch volume and tone output off 
       jmp     NXNOTE          ; 0170 - 24 0f  $.      ;process the next note
;
X0172: jmp     X0200           ; 0172 - 44 00  D.
       db      0,0,0,0
;
       org     178h
;---------------------------------------duration table index(8 entries) - absolutely identical to table at DOORBELL at 083h-0b8h
DURADDR:
       db      DUR0 mod 100h   ; 0178 - 80     .
       db      DUR1 mod 100h   ; 0179 - 8b     .
       db      DUR2 mod 100h   ; 017a - 90     .
       db      DUR3 mod 100h   ; 017b - 98
       db      DUR4 mod 100h   ; 017c - a0     .
       db      DUR5 mod 100h   ; 017d - a8     (
       db      DUR6 mod 100h   ; 017e - b0
       db      DUR7 mod 100h   ; 017f - b8     08

;---------------------------------------duration tables below are different from DOORBELL values
;format: bits 7,6,5 - output to volume DAC
;        bits 4..0  - duration of current volume level
;in comparison with DOORBELL, volume and duration info is interchanged (another nibbles) and shifted
;---------------------------------------duration table for 80h
DUR0:
       db      0e3h            ; 0180 - e3     c
       db      23h
       db      00h             ; 0181 - 23 00  #.

;---------------------------------------duration table for free-playing from keys
DURFREE:
       db      0c7h            ; 0183 - c7     G
       db      0a7h            ; 0184 - a7     '
       db      87h             ; 0185 - 87     .
       db      67h             ; 0186 - 67     g
       db      47h             ; 0187 - 47     G
       db      27h             ; 0188 - 27     '
       db      00h             ; 0189 - 00     .       ; data truncated
       db      00h


;---------------------------------------duration table for 8bh
DUR1:
       db      0e3h            ; 018b - e3     c
       db      0a3h            ; 018c - a3     #
       db      63h             ; 018d - 63     c
       db      23h
       db      00h             ; 018e - 23 00  #.

;---------------------------------------duration table for 90h
DUR2:
       db      0e3h            ; 0190 - e3     c
       db      0c3h            ; 0191 - c3     C
       db      0a3h            ; 0192 - a3     #
       db      83h             ; 0193 - 83     .
       db      63h             ; 0194 - 63     c
       db      23h
       db      00h             ; 0195 - 23 00  #.
       db      00h             ; 0197 - 00     .

;---------------------------------------duration table for 98h
DUR3:
       db      0e7h            ; 0198 - e7     g
       db      0c3h            ; 0199 - c3     C
       db      0a3h            ; 019a - a3     #
       db      83h             ; 019b - 83     .
       db      63h             ; 019c - 63     c
       db      43h
       db      23h             ; 019d - 43 23  C#
       db      00h             ; 019f - 00     .

;---------------------------------------duration table for a0h
DUR4:
       db      0f8h    ; 01a0 - f8     x
       db      0c3h    ; 01a1 - c3     C
       db      0a3h    ; 01a2 - a3     #
       db      83h     ; 01a3 - 83     .
       db      63h     ; 01a4 - 63     c
       db      43h
       db      23h     ; 01a5 - 43 23  C#
       db      00h     ; 01a7 - 00     .

;;---------------------------------------duration table for a8h
DUR5:
       db      0efh
       db      0c7h    ; 01a8 - ef c7  oG
       db      0a7h    ; 01aa - a7     '
       db      87h     ; 01ab - 87     .
       db      67h     ; 01ac - 67     g
       db      47h     ; 01ad - 47     G
       db      27h     ; 01ae - 27     '
       db      00h     ; 01af - 00     .

;---------------------------------------duration table for b0h
DUR6:
       db      0efh
       db      0cfh    ; 01b0 - ef cf  oO
       db      8fh     ; 01b2 - 8f     .
       db      6fh     ; 01b3 - 6f     o
       db      4fh     ; 01b4 - 4f     O
       db      2fh     ; 01b5 - 2f     /
       db      00h     ; 01b6 - 00     .       ; data truncated
       db      00h

;---------------------------------------duration table for b8h
DUR7:
       db      0ffh    ; 01b8 - ff
       db      0cfh    ; 01b9 - cf     O
       db      0afh    ; 01ba - af     /
       db      8fh     ; 01bb - 8f     .
       db      6fh     ; 01bc - 6f     o
       db      4fh     ; 01bd - 4f     O
       db      2fh     ; 01be - 2f     /
       db      00h     ; 01bf - 00     .       ; data truncated


;-----------------------------------------------------musical tones table (absolutely identical to table at DOORBELL at 0c0-0dd)
;-----------------------------------------------------the higher the address, the higher the tone and the lower the value
;-----------------------------------------------------seems to me, 0d,0e,0f are 'small octave' values, becuse they has lowest values
       org     1c0h
TONETAB:
       db      00h
       db      0adh    ;01=1.do
       db      0a2h    ;02=1.do#
       db      95h     ;03=1.re
       db      8bh     ;04=1.re#
       db      81h     ;05=1.mi
       db      77h     ;06=1.fa
       db      6eh     ;07=1.fa#
       db      66h     ;08=1.sol
       db      5eh     ;09=1.sol#
       db      56h     ;0a=1.la
       db      4fh     ;0b=1.la#
       db      49h     ;0c=1.si
       db      0d5h    ;0d=small.la
       db      0c7h    ;0e=small.la#
       db      0b9h    ;0f=small.si
       db      00h
       db      43h     ;11=2.do
       db      3dh     ;12=2.do#
       db      37h     ;13=2.re
       db      32h     ;14=2.re#
       db      2eh     ;15=2.mi
       db      28h     ;16=2.fa
       db      23h     ;17=2.fa#
       db      1fh     ;18=2.sol
       db      1bh     ;19=2.sol#
       db      17h     ;1a=2.la
       db      14h     ;1b=2.la#
       db      11h     ;1c=2.si
       db      00h
;--------------------------------------------------------
;
       org     1e0h
;----------------------------------------------------------------------tune address table
;offset of this table is note code (tune selection performs by pressing corresponding note on keyboard)
;note code is the same as stores in tune data, the same as table at 01c0h and in DOORBELL
;only 6 first left black keys turn tunes on
;don't undesrtand value at offset 00h, this note was undefined in doorbell
TUNETAB:                                               ;offset----note--------tune
       in      a,p1            ; 01e0 - 09     .       ;00h-----------------------------------------?????unknown note????----????not a tune address???
       db      TUNE0 mod 100h  ; 01e1 - 00             ;01h    - 1.do  - beep
       db      TUNE2 mod 100h  ; 01e2 - 20  .          ;02h    - 1.do# - Ya na solnyshke lezhu
       db      TUNE0 mod 100h  ; 01e3 - 00             ;03h    - 1.re  - beep
       db      TUNE3 mod 100h  ; 01e4 - 3f  .?         ;04h    - 1.re# - Pust vsegda budet solntse
       db      TUNE0 mod 100h  ; 01e5 - 00             ;05h    - 1.mi  - beep
       db      TUNE0 mod 100h  ; 01e6 - 00             ;06h    - 1.fa  - beep
       db      TUNE4 mod 100h  ; 01e6 - 5c  .\         ;07h    - 1.fa# - Goluboi vagon
       db      TUNE0 mod 100h  ; 01e8 - 00             ;08h    - 1.sol - beep
       db      TUNE5 mod 100h  ; 01e9 - 89  ..         ;09h    - 1.sol#- Vmeste veselo shagat
       db      TUNE0 mod 100h  ; 01ea - 00             ;0ah    - 1.la  - beep
       db      TUNE6 mod 100h  ; 01eb - b1  .1         ;0bh    - 1.la# - Bremenskiye muzykanty
       db      TUNE0 mod 100h  ; 01ec - 00             ;       - 1.si  - beep
       db      TUNE0 mod 100h  ; 01ed - 00             ;       - 0.la  - beep
       db      TUNE1 mod 100h  ; 01ee - 02     .       ;0eh    - 0.la# - Krylatye kacheli   (this is left-most black key, 1st tune, but last table entry!)
       db      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0       ;       - 0.si and all notes in 2nd octave are beeps (00h)

;-------------------------------------------------------------------------
;
       org     200h
;-----------------------------------------------------code the duration of memorised note, by r6 value (???)
X0200: anl     a,#0efh         ; 0200 - 53 ef  So
       mov     r4,a            ; 0202 - ac     ,
X0203: mov     a,r3            ; 0203 - fb     {
       anl     a,#0f0h         ; 0204 - 53 f0  Sp
       mov     r3,a            ; 0206 - ab     +
       outl    p2,a            ; 0207 - 3a     :
       mov     a,r0            ; 0208 - f8     x
       orl     a,#0c0h         ; 0209 - 43 c0  C@      ;11xx.xxxx
       cpl     a               ; 020b - 37     7       ;00xx.xxxx
       jz      X023a           ; 020c - c6 3a  F:      ;jump if r0 was xx11.1111
       inc     r0              ; 020e - 18     .       
       mov     @r0,#0          ; 020f - b0 00  0.      ;clear next RAM addr
       dec     r0              ; 0211 - c8     H
       mov     r5,#0           ; 0212 - bd 00  =.
       mov     a,r6            ; 0214 - fe     ~       
       cpl     a               ; 0215 - 37     7
       jb6     BIT65           ; 0216 - d2 20  R 
       jb5     BIT54           ; 0218 - b2 24  2$
       jb4     BIT43           ; 021a - 92 28  .(
       jb3     SET1            ; 021c - 72 32  r2
       jmp     SET0            ; 021e - 44 33  D3
BIT65: jb5     SET7            ; 0220 - b2 2c  2,
       jmp     SET6            ; 0222 - 44 2d  D-
BIT54: jb4     SET5            ; 0224 - 92 2e  ..
       jmp     SET4            ; 0226 - 44 2f  D/
BIT43: jb3     SET3            ; 0228 - 72 30  r0
       jmp     SET2            ; 022a - 44 31  D1
SET7:  inc     r5              ; 022c - 1d     .       ;r6.(6..3)=00xx, dur=7
SET6:  inc     r5              ; 022d - 1d     .       ;r6.(6..3)=01xx, dur=6
SET5:  inc     r5              ; 022e - 1d     .       ;r6.(6..3)=100x, dur=5
SET4:  inc     r5              ; 022f - 1d     .       ;r6.(6..3)=101x, dur=4
SET3:  inc     r5              ; 0230 - 1d     .       ;r6.(6..3)=1100, dur=3
SET2:  inc     r5              ; 0231 - 1d     .       ;r6.(6..3)=1101, dur=2
SET1:  inc     r5              ; 0232 - 1d     .       ;r6.(6..3)=1110, dur=1
SET0:  mov     a,r5            ; 0233 - fd     }       ;r6.(6..3)=1111, dur=0
       rl      a               ; 0234 - e7     g
       swap    a               ; 0235 - 47     G       ;set bits 7-5 (duration of note) by value of bits 6-3 of r6
       mov     r5,a            ; 0236 - ad     -
       mov     a,@r0           ; 0237 - f0     p       
       orl     a,r5            ; 0238 - 4d     M
       mov     @r0,a           ; 0239 - a0             ;update these bits in RAM value @r0
X023a: mov     a,r4            ; 023a - fc     |
       jb4     X02d3           ; 023b - 92 d3  .S
       jmp     DELAY2          ; 023d - 44 77  Dw      ;jump to x000a after delay
;
       org     242h
;-----------------------------------------------------------
;TONE player
;------------very similar to tone processing in DOORBELL
;------------but little bit DIFFERENT! from 024d.
;------------namely, don't read port but use R3
;------------algorithm is quite the same.
;on call,r5- tone (from TONETAB)
TMRTON:nop                     ; 0242 - 00     .
       mov     a,#5dh          ; 0243 - 23 5d  #]
       mov     t,a             ; 0245 - 62     b
       strt    t               ; 0246 - 55     U
TONE:  mov     a,r5            ; 0247 - fd     }
       jz      MUSPAUSE        ; 0248 - c6 5b  F[
       dec     a               ; 024a - 07     .
       jnz     $-1             ; 024b - 96 4a  .J
       mov     a,#8            ; 024d - 23 08  #.
       xrl     a,r3            ; 024f - db     [       ;invert bit 3 in r3
TMRCHK:mov     r3,a            ; 0250 - ab     +
       outl    p2,a            ; 0251 - 3a     :       ;output r3 to port 2 (with inverted bit 3 if it isn't pause)
       jtf     X0260           ; 0252 - 16 60  .`      ;leave tone player after timer overflow
       mov     a,#23h          ; 0254 - 23 23  ##
       dec     a               ; 0256 - 07     .
       jnz     $-1             ; 0257 - 96 56  .V
       jmp     TONE            ; 0259 - 44 47  DG
MUSPAUSE:
       mov     a,r3            ; 025b - fb     {
       anl     a,#0f7h         ; 025c - 53 f7  Sw      ;set bit 3 to 0 if pause
       jmp     TMRCHK          ; 025e - 44 50  DP
;----------------------------------------------------------------

X0260: nop                     ; 0260 - 00     .       
       nop                     ; 0261 - 00     .
       nop                     ; 0262 - 00     .
       jmp     X000a           ; 0263 - 04 0a  ..
       db      0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
;
       org     26eh
;
X026e: mov     a,r4            ; 026e - fc     |
       anl     a,#0efh         ; 026f - 53 ef  So
       mov     r4,a            ; 0271 - ac     ,
X0272: mov     a,r3            ; 0272 - fb     {
       anl     a,#0f0h         ; 0273 - 53 f0  Sp
       mov     r3,a            ; 0275 - ab     +
       outl    p2,a            ; 0276 - 3a     :
DELAY2:mov     r1,#3           ; 0277 - b9 03  9.      ;two-loop delay
DELOP2:mov     a,#0feh         ; 0279 - 23 fe  #~
       dec     a               ; 027b - 07     .
       jnz     $-1             ; 027c - 96 7b  .{
       djnz    r1,DELOP2       ; 027e - e9 79  iy
       jmp     X000a           ; 0280 - 04 0a  ..
;
X0282: mov     a,r3            ; 0282 - fb     {
       anl     a,#0f0h         ; 0283 - 53 f0  Sp
       mov     r3,a            ; 0285 - ab     +
       outl    p2,a            ; 0286 - 3a     :
       mov     a,r4            ; 0287 - fc     |
       jb2     X028e           ; 0288 - 52 8e  R.
       jb0     X028e           ; 028a - 12 8e  ..
       jmp     X012e           ; 028c - 24 2e  $.
;
X028e: jmp     X0100           ; 028e - 24 00  $.
;
X0290: mov     a,r4            ; 0290 - fc     |
       jb0     X0295           ; 0291 - 12 95  ..
       jmp     X02f8           ; 0293 - 44 f8  Dx
;
X0295: jb2     X0299           ; 0295 - 52 99  R.
       jmp     X029e           ; 0297 - 44 9e  D.
;
X0299: inc     r0              ; 0299 - 18     .
       mov     a,r0            ; 029a - f8     x
       movp3   a,@a            ; 029b - e3     c
       jnz     JNOTEPARSE      ; 029c - 96 a0  . 
X029e: jmp     X026e           ; 029e - 44 6e  Dn
;
JNOTEPARSE: 
       jmp     NOTEPARSE       ; 02a0 - 24 1a  $.
;
;----------------------------------------------------------------delay-like init routine, and after note decode
DELAY1:mov     a,r3            ; 02a2 - fb     {
       orl     a,#8            ; 02a3 - 43 08  C.
       mov     r3,a            ; 02a5 - ab     +       ;set bit 4 in R3
       mov     r1,#6           ; 02a6 - b9 06  9.
DELOOP:mov     a,#0deh         ; 02a8 - 23 de  #^      ;delay
       dec     a               ; 02aa - 07     .
       jnz     $-1             ; 02ab - 96 aa  .*
       djnz    r1,DELOOP       ; 02ad - e9 a8  i(
       jmp     X014d           ; 02af - 24 4d  $M
;-----------------------------------------------------------------
;
X02b1: mov     a,r0            ; 02b1 - f8     x
       add     a,#0c1h         ; 02b2 - 03 c1  .A
       cpl     a               ; 02b4 - 37     7
       jz      X02bb           ; 02b5 - c6 bb  F;
       inc     r0              ; 02b7 - 18     .
       mov     a,r4            ; 02b8 - fc     |
       jmp     X0139           ; 02b9 - 24 39  $9
;
X02bb: mov     a,r4            ; 02bb - fc     |
       orl     a,#30h          ; 02bc - 43 30  C0
       mov     r4,a            ; 02be - ac     ,
       mov     a,r1            ; 02bf - f9     y
       jmp     X013e           ; 02c0 - 24 3e  $>
;
;if bits 4..0 of duration table is nonzero
DURLOOP:
       dec     a               ; 02c2 - 07     .
       mov     @r1,a           ; 02c3 - a1     !       ;countdown duration table value @08h
       mov     a,#5            ; 02c4 - 23 05  #.
       dec     a               ; 02c6 - 07     .
       nop                     ; 02c7 - 00     .
       jnz     $-2             ; 02c8 - 96 c6  .F      ;fixed-time loop
       jmp     TMRTON+1        ; 02ca - 44 43  DC      ;return to tone generation
;
X02cc: mov     a,#0ah          ; 02cc - 23 0a  #.
       dec     a               ; 02ce - 07     .
       jnz     $-1             ; 02cf - 96 ce  .N
JTMRTON: jmp     TMRTON          ; 02d1 - 44 42  DB
;
X02d3: jb2     X02d7           ; 02d3 - 52 d7  RW
       jmp     X012e           ; 02d5 - 24 2e  $.
;
X02d7: jmp     X00ba           ; 02d7 - 04 ba  .:
;
X02d9: jb0     X0282           ; 02d9 - 12 82  ..
       jb4     X0203           ; 02db - 92 03  ..
       jmp     X0282           ; 02dd - 44 82  D.
;
X02df: orl     a,#20h          ; 02df - 43 20  C 
       mov     r4,a            ; 02e1 - ac     ,
       jb4     X02e6           ; 02e2 - 92 e6  .f
       jmp     X0272           ; 02e4 - 44 72  Dr
;
X02e6: jmp     X007e           ; 02e6 - 04 7e  .~
;
X02e8: clr     a               ; 02e8 - 27     '
       jni     X02ee           ; 02e9 - 86 ee  .n
X02eb: mov     r4,a            ; 02eb - ac     ,
       jmp     X000a           ; 02ec - 04 0a  ..
;
X02ee: jnt0    X02f2           ; 02ee - 26 f2  &r
       orl     a,#1            ; 02f0 - 43 01  C.
X02f2: jnt1    X02eb           ; 02f2 - 46 eb  Fk
       orl     a,#40h          ; 02f4 - 43 40  C@
       jmp     X02eb           ; 02f6 - 44 eb  Dk
;
X02f8: jb6     X02fc           ; 02f8 - d2 fc  R|
       jmp     X026e           ; 02fa - 44 6e  Dn
;
X02fc: mov     r0,#9           ; 02fc - b8 09  8.
       jmp     X0113           ; 02fe - 24 13  $.


;-----------------------------------------------------------------------------------------tunes
INCLUDE "TUNES-EM.ASM"


       end
