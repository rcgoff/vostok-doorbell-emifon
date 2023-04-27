;
;  8048 Disassembly of doorbell.hex
;  12/9/2018 12:21


;NOVOSIBIRSK VOSTOK PLANT DOORBELL
;chip KP1816BE48-01
;disasembling by L.Yadrennikov: 09.12.2018,...,23.11.2019
;rcgoff@uits04.com

;*********************************************************************************
;there is some memorizing feature
;device can play tunes in memorized order
;and somehow memorize it
;but i don't know how. It is linked with P1.4 contact.


;if in no-fix, auto-change mode (t0=t1=0) after first (or second) button release,
;when both flags are 0, p1.4 will be 1, than
;we can set ON memorized play (r2.4=1)

;seems to me we need special flag which will show that memorizing is completed,
;i.e. that RAM isn't empty and we can play tunes in memorized sequence
;this flag should be set after memorizing
;-----------------this is r2.4

;also seems to me that we need ability to toggle memorized playing on/off, isn't it?
;or only by switching power off?
;*********************************************************************************

;32 melodies
;T1 - tune fixing              (log.HIGH=fixing ON)
;T0 - tune auto-change on/off  (log.HIGH=             (button pressed-log.HIGH)
;INT - select tune set         (log.high=tune set B)

;================================================================================================
;Из инструкции
;ВЫБОР ПРОГРАММЫ (INT) - нажатое положение - 1-я группа мелодий (у меня это tune set B)
;РЕЖИМ (T0) - определяет режим работы счетчика мелодий, управляемого нажатием звонковой кнопки.
;В отжатом положении переключателя счетчик автоматически возвращается в исходное состояние
;по окончании звучания мелодии. В этом случае соответствующим числом кратковременных нажатий
;звонковой кнопки можно выбрать конкретную мелодию. Подобная кодировка позволяет каждому
;члену семьи иметь "свою" мелодию, определяемую числом нажатий кнопки.
;В нажатом положении переключателя счетчик мелодий работает как кольцевой счетчик на 16.
;Это позволяет осуществлять последовательный выбор всех 16 мелодий группы.
;ПАМЯТЬ (T1) - нажатием переключателя ПАМЯТЬ счетчик мелодий блокируется в состояни, в котором
;он находился в момент нажатия переключателя. В этом случае будет воспроизводиться только одна
;выбранная мелодия.
;
;Звонок срабатывает по отжатии кнопки. Для правильного воспроизведения мелодии повторное нажатие
;кнопки рекомендуется производить не раньше, чем через 2 секунды после окончания звучания мелодии.
;
;Для проверки правильности звучания всех 32 мелодий необходимо:
;отключить звонок от сети; переключатель ВЫБОР ПРОГРАММЫ установить в нажатое положение;
;нажать и удерживать звонковую кнопку до подключения звонка к сети; подключить звонок к сети;
;отжать звонковую кнопку - звонок должен автоматически воспроизвести последовательно все 16
;мелодий 1-й группы. Аналогично проверяется 2-я группа мелодий после установки переключателя
;ВЫБОР ПРОГРАММЫ в отжатое положение.
;Положение переключателей РЕЖИМ и ПАМЯТЬ на проверку не влияет.
;================================================================================================


;PORT1
;P1.0 - doorbell button (active low)
;P1.4 - always GND (used in undocumented features!)

;PORT2
;P2.0  180k    - resistive divider output
;P2.1  91k     - resistive divider output
;P2.2  47k     - resistive divider output - all 3 are volume control for smooth sound fading and attack emulation
;P2.3 PCB track was cut and changed to P2.4  - tone control 1
;P2.4 - some unknown output to E2 transistor - tone control 2 (inverted simultaneously)

;FLAGS....
;F0
;F1

;REGISTERS....
;R0 - tune number
;R2 - flag control register
       ;bit 0
       ;bit 1  - ?! (not sure)run memorizing mode (see BUTPRES)
       ;bit 2  - ?! (not sure)tune A-set
       ;bit 3
       ;bit 4  - ?! (not sure) use memorized sequence (see routines DEMCONT, x016a, MEMOPLAY)
       ;bit 5  - tune B-set, or (not sure) select tune set
       ;bit 6  - button was pressed on startup (demo mode indicator)
       ;bit 7  - see PLYRET
;R3 - ?!(not sure) address for RAM memorizing
;R4 - address for tune reading // delay loop counter after detected button Press-and-Release (MLTPRES routine)
;R5 - (depends on musical tone by table at 0c0h)
;R6 - real duration (decoded from duration tables)
;R7 - (depends on tone duration by table at 083h)

;TIMER is used without interrupts
;interrupts isn't used

;only two subroutines (DELAY and INIT2), all the rest are JMP-style

;DATA STRUCTURE OF TUNE and LENGTH OF TUNE - see below


A_TBL  equ     0e0h                                                  ;offsets table address for tune set A
B_TBL  equ     0f0h                                                  ;offsets table address for tune set B

       org     0
       jmp     INIT            ; 0000 - 24 00

;       db      0ffh            ; 0002 - FF                           ;for binary compartibility with firmware
;here we can place "clr f0" and change origin to 2
       org 2
X0003: clr f0

       org     3
;------------------------------------------------this is play routine
;during call, R0 must contain tune number
;X0003:
       jb5     TUNEB           ; 0003 - b2 12                        ;A.5=1->>>this is tune from B-set
       mov     a,#A_TBL        ; 0005 - 23 e0                        ;otherwise - A-set
RDSTRT:add     a,r0            ; 0007 - 68
X0008: movp    a,@a            ; 0008 - a3                           ;read tune's starting address...
       mov     r4,a            ; 0009 - ac                           ;...and store it to R4
;--------DATA reading and playing loop (up to 007Ah)
PL_LOOP:mov    a,r2            ; 000a - fa                           ;r2 determines what page to read
       jb2     RD_PG2          ; 000b - 52 0f                        ;...page 2 (if r2.2=1)
       jb5     RD_PG3          ; 000d - b2 16                        ;...page 3 (if r2.5=1)

;-----read page2, if needed
RD_PG2:mov     a,r4            ; 000f - fc                           ;r4 determines offset in DATA reading
       jmp     PG2RD           ; 0010 - 44 00

TUNEB: mov     a,#B_TBL        ; 0012 - 23 f0
       jmp     RDSTRT          ; 0014 - 04 07

;-----read page3, if needed
RD_PG3:mov     a,r4            ; 0016 - fc                           ;r4 determines offset in DATA reading
       movp3   a,@a            ; 0017 - e3                           ;movp3 from @R4


;-----one tune byte processing
 ;now ACC has byte of one musical note
 ;-----low nibble=tone in octave
 ;-----high nibble=duration and octave number
 ;more precisely, bits 7-5: duration; bits 4-0: tone.

PG2RET:jz      ENDPLAY         ; 0018 - c6 75                        ;zero in data means end of tune
       mov     r1,a            ; 001a - a9                           ;backup note byte
;here we can place trioll patch call
       call TRLSET
;       anl     a,#1fh          ; 001b - 53 1f                        ; AND with (0001.1111)=select 5 lower bits
;this 2 bytes above should be moved into trioll patch


       orl     a,#TONETAB      ; 001d - 43 c0                        ; OR with (1100.0000)=get value like: (110X.XXXX) in range:0c0h-0dfh
       movp    a,@a            ; 001f - a3                           ;read byte with this offset (depends on tone)
       mov     r5,a            ; 0020 - ad                           ;and save them to R5

       mov     a,r1            ; 0021 - f9                           ;process tune byte again
       anl     a,#0e0h         ; 0022 - 53 e0                        ; AND with (1110.0000)=select 3 higher bits from tone byte
       rr      a               ; 0024 - 77
       swap    a               ; 0025 - 47                           ;move this 3 higher bits to bits 2,1,0.
       add     a,#DURADDR      ; 0026 - 03 83
       movp    a,@a            ; 0028 - a3                           ;read appropriate note duaration (address for detail array)
       mov     r7,a            ; 0029 - af                           ;and save it at R7
       call    DELAY           ; 002a - 34 99                        ;DELAY destroys r1

;--now we have  tone value at R5
;--and duration table address for certain duration at R7
;REMEMBER THAT only bits P2.0..P2.2 (volume DAC) and P2.4 (tone) are significant

;volume and duration decoder (from duration tables)   ;cycles
VOLDUR:mov     a,r7            ; 002c - ff            1              ;restore note duration address
       movp    a,@a            ; 002d - a3            2(3)           ;read next entry of certain note duration array
       jz      NXNOTE          ; 002e - c6 77         2(5)           ;00 in dur.table leads to next note
       mov     r1,a            ; 0030 - a9            1(6)           ;now r1 has current dur.byte from table

       in      a,p2            ; 0031 - 0a            2(8)           ;read previous value on port
       anl     a,#0f8h         ; 0032 - 53 f8         2(10)          ;AND f8=(1111.1000)=select 5 higher bits
                                                                     ;in other words, clear 3 lowest bits

       xrl     a,r1            ; 0034 - d9            1(11)          ;XOR with duration byte:inverse bit 3 and
                                                                     ;set bits 2..0 to values from duration byte
       orl     a,#0f0h         ; 0035 - 43 f0         2(13)
       outl    p2,a            ; 0037 - 3a            2(15)          ;out lowest nibble

       mov     a,r1            ; 0038 - f9            1(16)
       swap    a               ; 0039 - 47            1(17)
       anl     a,#0fh          ; 003a - 53 0f         2(19)
       mov     r6,a            ; 003c - ae            1(20)          ;save 4 higher bits of duration byte in r6
       clr     f1              ; 003d - a5            1(21)


;tone generation
;  23h      can vary          23h     depends on tone
; fixed  ___________________        _______________
;\______/                   \______/
                                                   ;cycles           ;timer is used for DURATION!
TMRTON:call TRLTMR
;       mov     a,#5dh          ; 003e - 23 5d       2                ;timer is loaded with FIXED value
       mov     t,a             ; 0040 - 62          1(3)
       strt    t               ; 0041 - 55          1(4)
;--------------tone processing
TONE:  mov     a,r5            ; 0042 - fd          1(5)             ;note tone processing
       jz      MUSPAUSE        ; 0043 - c6 56       2(7)             ;tone=0, but duration<>0 -->this is pause
       dec     a               ; 0045 - 07                           ;tone (high) loop
       jnz     $-1             ; 0046 - 96 45                        ;cowntdown note value, i.e. the lower the pitch,
                                                                     ;the longer the period and the larger should be
                                                                     ;value in tone array

       in      a,p2            ; 0048 - 0a                           ;read value previously sent
       xrl     a,#18h          ; 0049 - d3 18                        ;18h=(0001.1000): invert P2.3 and P2.4
       nop                     ; 004b - 00                           ;? - to reach true timing
       outl    p2,a            ; 004c - 3a                           ;out nibble again

TMRCHK:jtf     DURAT           ; 004d - 16 5a       2(13)            ;timer overflow? ->exit from tone player
       mov     a,#23h          ; 004f - 23 23       2(15)            ;time for HIGH P2.3-4 can vary, but time for LOW
       dec     a               ; 0051 - 07          1*23h=35(50)     ;P2.3-4 is fixed!
       jnz     $-1             ; 0052 - 96 51       2*23h=70(120)    ;LOW loop
       jmp     TONE            ; 0054 - 04 42       2(122)
MUSPAUSE:
       anl     p2,#0f7h        ; 0056 - 9a f7       2(9)             ;F7h=(1111.0111) on PAUSE, all is 1 except P2.3
       jmp     TMRCHK          ; 0058 - 04 4d       2(11)            ;in PAUSE,only waiting needed time (set by timer)


;Now r6 contains 4 higher bits of duration byte shifted to lower nibble.
;this and only this is duration information.
;one unit in r6 corresponds to one TONE generation loop.

DURAT: cpl     f1              ; 005a - b5           1               ;f1=1 means fixed duration
       jf1     FIXDUR          ; 005b - 76 71        2(3)
       mov     a,r6            ; 005d - fe           1(4)
       jnz     REALDUR         ; 005e - 96 68        2(6)
       inc     r7              ; 0060 - 1f          b1(7)            ;realDuration=0?
       mov     a,#19h          ; 0061 - 23 19       b2(9)            ; prepare next duration array value,
       dec     a               ; 0063 - 07          b1*25(34)        ; Minimal loop-delay,
       jnz     $-1             ; 0064 - 96 63       b2*25(84)
       jmp     VOLDUR          ; 0066 - 04 2c       b2*2(86)         ; and next duration array processing

REALDUR:                                                             ;if realDuration<>0,
       dec     r6              ; 0068 - ce          a1(7)            ; dectrease realDuration value,
       mov     a,#1fh          ; 0069 - 23 1f       a2(9)            ; generate some loop-delay,
       nop                     ; 006b - 00          a1(10)
REALP: dec     a               ; 006c - 07          a1*31(41)
       jnz     REALP           ; 006d - 96 6c       a2*31(103)       ; (means REALdurationLooP)
       jmp     TMRTON          ; 006f - 04 3e       a2(105)          ;and continue current note playing

FIXDUR:mov     a,#20h          ; 0071 - 23 20
       jmp     REALP           ; 0073 - 04 6c

ENDPLAY:jmp    PLYRET          ; 0075 - 24 7a                        ;far-jump to exit and continue button polling

NXNOTE:anl     p2,#0f0h        ; 0077 - 9a f0
       inc     r4              ; 0079 - 1c                           ;next tune byte
       jmp     PL_LOOP         ; 007a - 04 0a


       org     7eh
;------------------------start address table for memorizing mode (structure is the same as 0E0-0FF tables)
;
       db      0fdh            ; 007e - fd
       db      0fbh            ; 007f - fb

;--------------duration tables format:
;bits 2-0 - output for DAC (P2.0..P2.2),
;this DAC controls volume
;bits 4-7 - duration of playing with current volume

;total note duration is sum of high nibbles
;of all nonzero duration bytes


;--------------table for duration=0 (1/16)
       db      17h             ; 0080 - 17
       db      11h             ; 0081 - 11
       db      00h             ; 0082 - 00

;---------------------------------------------tone duration table, has 8 possible entries
;---------------------------------------------contains start addreses
       org     083h
DURADDR:
       db      80h             ; 0083 - 0, total duration (1+1)=2                      1/16
       db      8bh             ; 0084 - 1, total duration (1+1+1+1)=4                  1/8
       db      90h             ; 0085 - 2, total duration (1+1+1+1+1+1)=6              1/8 dotted
       db      98h             ; 0086 - 3, total duration (3+1+1+1+1+1+1)=9            1/4
       db      0a0h            ; 0087 - 4, total duration (b+1+1+1+1+1+1)=17           1/4 dotted
       db      0a8h            ; 0088 - 5, total duration (7+3*6)=25                   1/2
       db      0b0h            ; 0089 - 6, total duration (7*6)=42                     1/2 dotted
       db      0b8h            ; 008a - 7, total duration (f+7*6)=255+42=297           long pause? (not used)

;--------------table for duration=1 (1/8)
       org     08bh

       db      17h             ; 008b - 17
       db      15h             ; 008c - 15
       db      13h             ; 008d - 13
       db      11h             ;        11
       db      00h             ; 008f - 00

;--------------table for duration=2 (1/8 dotted)
       db      17h             ; 0090 - 17
       db      16h             ; 0091 - 16
       db      15h             ;        15
       db      14h             ; 0093 - 14
       db      13h             ;        13
       db      11h             ; 0095 - 11
       db      00h             ; 0096 - 00
       db      00h             ; 0097 - 00                           ;this is redundant, previous zero leads to stop

;--------------table for duration=3 (1/4)
       db      37h             ; 0098 - 37           (0011.0111)
       db      16h             ; 0099 - 16           (0001.0110)
       db      15h             ;        15           (0001.0101)
       db      14h             ; 009b - 14
       db      13h             ;        13
       db      12h             ; 009d - 12
       db      11h             ;        11
       db      00h             ; 009f - 00

;--------------table for duration=4 (1/4 dotted)
       db      0b7h            ; 00a0 - b7
       db      16h             ; 00a1 - 16
       db      15h             ;        15
       db      14h             ; 00a3 - 14
       db      13h             ;        13
       db      12h             ; 00a5 - 12
       db      11h             ;        11
       db      00h             ; 00a7 - 00

;--------------table for duration=5 (1/2)
       db      77h             ; 00a8 - 77
       db      36h             ; 00a9 - 36
       db      35h             ;        35
       db      34h             ; 00ab - 34
       db      33h             ;        33
       db      32h             ; 00ad - 32
       db      31h             ;        31
       db      00h             ; 00af - 00

;--------------table for duration=6 (1/2 dotted)
       db      77h             ; 00b0 - 77
       db      76h             ; 00b1 - 76
       db      74h             ;        74
       db      73h             ; 00b3 - 73
       db      72h             ; 00b4 - 72
       db      71h             ;        71
       db      00h             ; 00b6 - 00
       db      00h             ; 00b7 - 00                           ;this is redundant, previous zero leads to stop

;--------------table for duration=7 (long note)
;       db      0f7h            ; 00b8 - f7
;       db      76h             ; 00b9 - 76
;       db      75h             ;        75
;       db      74h             ; 00bb - 74
;       db      73h             ;        73
;       db      72h             ; 00bd - 72
;       db      71h             ;        71
;       db      00h             ; 00bf - 00
;--------------table for duration=7 (1/4+1/16) -  1/4 dotted used as volume pattern,
;-------------------------------------------------------duration calculations see in AUTUMN.XLSX sheet 3
       db      077h            ;  00b8
       db      16h             ;
       db      15h             ;
       db      14h             ;
       db      13h             ;
       db      12h             ;
       db      11h             ;
       db      00h             ; 00bf



;-----------------------------------------------------musical tones table
;-----------------------------------------------------the higher the address, the higher the tone and the lower the value
;-----------------------------------------------------seems to me, 0d,0e,0f are 'small octave' values, becuse they has lowest values
       org     0c0h
TONETAB:
       db      00h
       db      0adh           ;01=1.do
       db      0a2h           ;02=1.do#
       db      95h            ;03=1.re
       db      8bh            ;04=1.re#
       db      81h            ;05=1.mi
       db      77h            ;06=1.fa
       db      6eh            ;07=1.fa#
       db      66h            ;08=1.sol
       db      5eh            ;09=1.sol#
       db      56h            ;0a=1.la
       db      4fh            ;0b=1.la#
       db      49h            ;0c=1.si
       db      0d5h           ;0d=small.la
       db      0c7h           ;0e=small.la#
       db      0b9h           ;0f=small.si
       db      00h
       db      43h            ;11=2.do
       db      3dh            ;12=2.do#
       db      37h            ;13=2.re
       db      32h            ;14=2.re#
       db      2eh            ;15=2.mi
       db      28h            ;16=2.fa
       db      23h            ;17=2.fa#
       db      1fh            ;18=2.sol
       db      1bh            ;19=2.sol#
       db      17h            ;1a=2.la
       db      14h            ;1b=2.la#
       db      11h            ;1c=2.si
       db      00h


;------------------------------------------------------table of start addreses of tunes
       org     0e0h
;tune set A
       db      03h             ; 00e0 - 03                           ;tune 1a
       db      0dh             ; 00e1 - 0d                           ;tune 2a
       db      19h             ; 00e2 - 19                           ;tune 3a
       db      24h             ; 00e3 - 24                           ;tune 4a
       db      2eh             ; 00e0 - 2e                           ;tune 5a
       db      41h             ; 00e5 - 41                           ;tune 6a
       db      4eh             ; 00e6 - 4e                           ;tune 7a
       db      5ch             ; 00e7 - 5c                           ;tune 8a
       db      6bh             ; 00e8 - 6b                           ;tune 9a
       db      7ch             ; 00e9 - 7c                           ;tune 10a
       db      87h             ; 00ea - 87                           ;tune 11a
       db      93h             ; 00eb - 93                           ;tune 12a
       db      0a0h            ; 00ec - a0                           ;tune 13a
       db      0b1h            ; 00ed - b1                           ;tune 14a
       db      0c5h            ; 00ee-  c5                           ;tune 15a
       db      0dah            ; 00ef - da                           ;tune 16a

;tune set B
       db      00h             ; 00f0 - 00                           ;tune 1b
       db      00h
       db      00h
       db      00h
       db      00h
       db      00h
       db      00h
       db      00h
       db      00h
       db      00h
       db      00h
       db      00h
       db      00h
       db      00h
       db      00h
       db      00h
;       db      0ch             ; 00f1 - 0c                           ;tune 2b
;       db      16h             ; 00f2 - 16                           ;tune 3b
;       db      21h             ; 00f3 - 21                           ;tune 4b
;       db      2dh             ; 00f4 - 2d                           ;tune 5b
;       db      3ah             ; 00f5 - 3a                           ;tune 6b
;       db      49h             ; 00f6 - 49                           ;tune 7b
;       db      59h             ; 00f7 - 59                           ;tune 8b
;       db      69h             ; 00f8 - 69                           ;tune 9b
;       db      7dh             ; 00f9 - 7d                           ;tune 10b
;       db      8ah             ; 00fa - 8a                           ;tune 11b
;       db      0a6h            ; 00fb - a6                           ;tune 12b
;       db      0b3h            ; 00fc - b3                           ;tune 13b
;       db      0c2h            ; 00fd - c2                           ;tune 14b
;       db      0d8h            ; 00fe - d8                           ;tune 15b
;       db      0efh            ; 00ff - ef                           ;tune 16b


;INIT---------------------------------------------------------------------power-on initialisation
;---------------------------------------------------if button was pressed on startup,  it means demo mode: all 16 tunes of one set playing


;at startup, demo OFF:
;f1=1 (010b) f0=0 (on reset)
;get into BUTLOOP
;read button=1, jz to BUTPRES (0110)
;by f1=1 jmp to MLTPRES (0127)
;by R2.7=1 (startup condition) jmp to BUTLOOP (01de)

;if, during this cycle, button was pressed:



INIT:  ANL     P2,#0F0h        ; 0100 - 9A F0                        ;set lower nibble of P2 to zero (on reset they're all '1')
       call    INIT2           ; 0102 - 34 a3                        ;set R0=0ffh R1=40h R2=80h (1000.0000) R3=0ffh A=00h and clear RAM at 20h...40h
       in      a,p1            ; 0104 - 09                           ;read doorbell button
       mov     r2,#80h         ; 0105 - ba 80                        ;       NOT pressed button, r2=1000.0000
       jb0     X010b           ; 0107 - 12 0b                        ;button not pressed (P1.1=1) - skip next line
       mov     r2,#0c0h        ; 0109 - ba c0                        ;       pressed button,     r2=1100.0000 (bit 6 set)
X010b: cpl     f1              ; 010b - b5
;---button loop
BUTLOOP:in     a,p1            ; 010c - 09                           ;read doorbell button (if pressed 1110.1110 (#0EEh), not 1110.1111 (#0EFh)
       orl     a,#0f8h         ; 010d - 43 f8                        ;switch bits 7-3 to 1 (if pressed 1111.1110 (#0FEh), not 1111.1111 (#0FFh)
       cpl     a               ; 010f - 37                           ;if pressed 0000.0001 (#01h), not 0000.0000 (#00h)
       jz      X0125           ; 0110 - c6 25                        ;not pressed - jump to BUTPRES (it may mean: free state, or button release)
       jf0     X0122           ; 0112 - b6 22                        ;button was pressed!
       xch     a,r2            ; 0114 - 2a                           ;save button status to r2
       anl     a,#0f8h         ; 0115 - 53 f8                        ;r2=1v00.0000 AND with 1111.1000 - clear bits 2,1,0
       xrl     a,r2            ; 0117 - da                           ;?????r2 XOR
       mov     r2,a            ; 0118 - aa
X0119: cpl     f0              ; 0119 - 95                           ;set 'button pressed' flag
       call    DELAY           ; 011a - 34 99
       call    DELAY           ; 011c - 34 99
       call    DELAY           ; 011e - 34 99
       jmp     BUTLOOP         ; 0120 - 24 0c
;
X0122: clr     f1              ; 0122 - a5
       jmp     BUTLOOP         ; 0123 - 24 0c
;BUTPRES-------------------------------------------------------------------------routine if button pressed
X0125: jf0     X0119           ; 0125 - b6 19
       jf1     MLTPRES         ; 0127 - 76 dd                        ;MLTPRES - loop-delay for multiple pressings (tune nr increment)
       mov     a,r2            ; 0129 - fa                           ;select what-to-do by flag register
       jb6     PRESTRT         ; 012a - d2 3f                        ;r2.6=button pressed on startup (run demo mode)
       jb2     X0158           ; 012c - 52 58
       jt1     X015c           ; 012e - 56 5c                        ;T1= melody fix on/off
       jb1     MEMRIZR         ; 0130 - 32 b4                        ;r2.1=call MEMORIZER
       in      a,p1            ; 0132 - 09                           ;read MEMORIZER button (p1.4)
       jb4     X016a           ; 0133 - 92 6a                        ;
       mov     a,r2            ; 0135 - fa
       cpl     a               ; 0136 - 37
       jb4     X013b           ; 0137 - 92 3b                        ;r2.4=0 ->skip tune nr.clearing
       mov     r0,#0ffh        ; 0139 - b8 ff                        ;tune nr. clearing
X013b: cpl     a               ; 013b - 37
       anl     a,#0efh         ; 013c - 53 ef                        ;r2 and (1110.1111) - clear r2.4 (and exit memorized playing)
       mov     r2,a            ; 013e - aa

;----------------------
;here we after tune selection by series of button pressings
PRESTRT:inc    r0              ; 013f - 18                           ;tune increment
       mov     a,r2            ; 0140 - fa
       anl     a,#0dfh         ; 0141 - 53 df                        ;r2 AND 1101.1111 - set bit 5 to 0
       jni     X0147           ; 0143 - 86 47                        ;INT= select tune set
       orl     a,#20h          ; 0145 - 43 20                        ;one case: r2 OR 0010.0000 - set bit 5 to 1
X0147: mov     r2,a            ; 0147 - aa                           ;write r2

       ;---------------up-to-16 tune count
       mov     a,#10h          ; 0148 - 23 10
X014a: xrl     a,r0            ; 014a - d8                           ;r0 XOR 0001.0000 and check if zero means test r0.4==1
       jnz     X014f           ; 014b - 96 4f
       mov     r0,#0           ; 014d - b8 00                        ;if r0=10h , clr r0. with incr at 1st line of PRESTRT it makes up-to-16 count
       ;---------------------------------

X014f: cpl     f1              ; 014f - b5
       mov     r4,#44h         ; 0150 - bc 44                        ;starting value for "wait the next button pressing" loop

       mov     a,r2            ; 0152 - fa
       anl     a,#7fh          ; 0153 - 53 7f                        ;r2 AND 0111.1111 - set bit 7 to 0
       mov     r2,a            ; 0155 - aa
       jmp     BUTLOOP         ; 0156 - 24 0c
;-----------------------7-
;
X0158: mov     r4,#0efh        ; 0158 - bc ef                        ;0ef in tune set B is Mendelson march, in tune set A this is special beep sequence
       jmp     PL_LOOP         ; 015a - 04 0a
;
X015c: jb1     X01d9           ; 015c - 32 d9                        ;play beep in memo-wr
       jb4     X0166           ; 015e - 92 66                        ;or memo-rd mode
       mov     a,r0            ; 0160 - f8
       cpl     a               ; 0161 - 37
       jz      PRESTRT         ; 0162 - c6 3f
       jmp     X014f           ; 0164 - 24 4f
;
X0166: jb3     X014f           ; 0166 - 72 4f
X0168: jmp     X01d9           ; 0168 - 24 d9                        ;play beep
;
;---------------------------------------------------------------if p1.4=1 when button released
;----------------------------------------------------seems to me this is entrance to memorizing mode
X016a: mov     a,r2            ; 016a - fa
       jb4     X016f           ; 016b - 92 6f                        ;memorizer already on? yes - skip reset of tune counter
       mov     r0,#0ffh        ; 016d - b8 ff                        ;r2.4=1 -> reset tune counter
X016f: orl     a,#10h          ; 016f - 43 10                        ;r2 OR 0001.0000==r2.4=1 (switch memorized playing on)
       mov     r2,a            ; 0171 - aa
       cpl     a               ; 0172 - 37
       jb3     X01d9           ; 0173 - 72 d9                        ;play beep
       inc     r0              ; 0175 - 18                           ;next tune
       mov     a,r3            ; 0176 - fb
       inc     a               ; 0177 - 17
       jmp     X014a           ; 0178 - 24 4a

;-------------------------------------------------------------------------------------RET_FROM_PLAY
PLYRET:mov     a,r2            ; 017a - fa                           ;returning point from sound playing
       jb6     DEMRET          ; 017b - d2 91                        ;one case is demo mode
       jt0     X0183           ; 017d - 36 83                        ;other - Step-up count...
       jt1     X0183           ; 017f - 56 83                        ;...or Tune fix mode
X0181: mov     r0,#0ffh        ; 0181 - b8 ff                        ;else - reset tune number
X0183: anl     p2,#0f0h        ; 0183 - 9a f0                        ;P2 and 1111.0000
X0185: orl     p2,#10h         ; 0185 - 8a 10                        ;P2 or 0001.0000 - i.e. set p2 to: xxx1.0000
       mov     a,r2            ; 0187 - fa
       anl     a,#0b8h         ; 0188 - 53 b8                        ;r2 AND 1011.1000 clears bit 6(demo) and bits 2, 1 (memorizing), 0
       orl     a,#80h          ; 018a - 43 80                        ;r2 OR 1000.0000 sets bit 7
       mov     r2,a            ; 018c - aa
       clr     f1              ; 018d - a5
       cpl     f1              ; 018e - b5                           ;set f1
       jmp     BUTLOOP         ; 018f - 24 0c                        ;continue buttons polling


;-------------------------------------------------------------------------------------DEMORET - demo mode return handler
DEMRET:inc     r0              ; 0191 - 18                           ;next tune
       mov     a,r0            ; 0192 - f8
       xrl     a,#10h          ; 0193 - d3 10
       jz      X0181           ; 0195 - c6 81                        ;tune nr. exceeds 0f? this will end demo mode
       jmp     DEMCONT         ; 0197 - 24 e6                        ;otherwise - demo continue

;DELAY---------------------------------------------------------------------------------------delay routine on A and R1
DELAY: mov     r1,#6           ; 0199 - b9 06
OUTER: mov     a,#0dfh         ; 019b - 23 df
INNER: dec     a               ; 019d - 07                           ;1 cycle
       jnz     INNER           ; 019e - 96 9d                        ;2 cycles
       djnz    r1,OUTER        ; 01a0 - e9 9b
       retr                    ; 01a2 - 93


;-----------------------------------------------------------------------------------------INIT2
;-----------------------------------------------------------------------------------------clearing RAM and some other registers
INIT2: mov     r0,#0ffh        ; 01a3 - b8 ff
CLRAM: mov     r3,#0ffh        ; 01a5 - bb ff
       mov     r1,#20h         ; 01a7 - b9 20
X01a9: mov     @r1,#0          ; 01a9 - b1 00                        ;some data structure in RAM (starting from #20h...
       inc     r1              ; 01ab - 19
       mov     a,#40h          ; 01ac - 23 40                        ;....and ending at #40h) will be set to 0's
       xrl     a,r1            ; 01ae - d9
       jnz     X01a9           ; 01af - 96 a9
       mov     r2,#80h         ; 01b1 - ba 80
       retr                    ; 01b3 - 93                           ;on exit: R0=#0ffh R1=#40h R2=#80h R3=#0ffh A=#00h



;------------------------------MEMORIZER
;------------------------------one call - one RAM value
;------------------------------memorized - plays BEEP1
;------------------------------overflow, 1st call, error - plays BEEP2
;---------------------------------------------------------------some unused and undocumented feature,
;---------------------------------------------------------------that uses bit 4 of P1 and RAM
MEMRIZR:in     a,p1            ; 01b4 - 09
       jb4     X01d7           ; 01b5 - 92 d7                        ;check if p1.4=1, if yes, clear RAM and play BEEP2
       mov     a,r3            ; 01b7 - fb
       xrl     a,#0fh          ; 01b8 - d3 0f
       jz      X01d9           ; 01ba - c6 d9                        ;r3=0fh (memory overflow) ->  play BEEP2
       mov     a,r0            ; 01bc - f8
       cpl     a               ; 01bd - 37
       jz      X01d9           ; 01be - c6 d9                        ;r0=ffh (first button pressing) -> play BEEP2
       mov     a,r2            ; 01c0 - fa
       orl     a,#8            ; 01c1 - 43 08                        ;r2 OR 0000.1000 = set bit 3
       mov     r2,a            ; 01c3 - aa
       inc     r3              ; 01c4 - 1b                           ;increment address for memorizing
       mov     a,r3            ; 01c5 - fb
       orl     a,#20h          ; 01c6 - 43 20                        ;r1:=r3+20h=address for memorizing
       mov     r1,a            ; 01c8 - a9
       mov     a,#0e0h         ; 01c9 - 23 e0                        ;select tune set depending on INT button: choose offset in table
       jni     X01cf           ; 01cb - 86 cf
       mov     a,#0f0h         ; 01cd - 23 f0
X01cf: orl     a,r0            ; 01cf - 48                           ;r0(tune nr.)+offset depending on tune set=addr of starting byte value in 0e0-0ff table
       mov     @r1,a           ; 01d0 - a1                           ;write into RAM tune offset
       mov     r0,#0ffh        ; 01d1 - b8 ff                        ;reset tune nr
       mov     a,#7eh          ; 01d3 - 23 7e                        ;a:=0111.1110
       jmp     X01f2           ; 01d5 - 24 f2                        ;start playing with start address @07eh (play BEEP1)
;
X01d7: call    CLRAM           ; 01d7 - 34 a5                        ;part of INIT2 - clearing RAM
X01d9: mov     a,#7fh          ; 01d9 - 23 7f
       jmp     X01f2           ; 01db - 24 f2                        ;start playing with start adress @07fh (play BEEP2)
;
;---------MLTPRES - MuLTi PRESsing
;---------------------wait-the-next-button-pressing loop (#44h loaded to r4 in PRESTRT, here this value decrements with button polling
;---------------------if button will be pressed and released during this time slot, loop stops
MLTPRES:mov    a,r2            ; 01dd - fa                   ;here we at startup if button was not pressed or was released
       jb7     BUTLOOP         ; 01de - f2 0c
       dec     r4              ; 01e0 - cc
       call    DELAY           ; 01e1 - 34 99
       mov     a,r4            ; 01e3 - fc
       jnz     BUTLOOP         ; 01e4 - 96 0c                        ;if loop has ended (time slot is over), we should to start playing
                                                                     ;this means we're going to DEMCONT

;----------------------------------------------------------------demo-mode continue handler (after one tune has played and r0=++)
;----------------------------------------------------------------not only demo mode, we can get here from MLTPRES by normal program flow
DEMCONT:mov    a,r2            ; 01e6 - fa
       jb4     MEMOPLAY        ; 01e7 - 92 eb                        ;playing tune in memorized seuence if r2.4=1
       jmp     X0003           ; 01e9 - 04 03                        ;otherwise, standard full-featured play routine call
;----------------------------------------------------------------


;---------------------------------------------------------------MEMOPLAY
;---------------------------------------------------------------routine instead of normal playing if bit r2.4=1
;---------------------------------------------------------------calls from DEMCONT
;---this is (?!) playing with help of RAM (at offset 20h)
;---ram values should contain tune start addreses in table (0D0h...0EFh)
;---mb this is kind of random playing? or part of it
MEMOPLAY:
       mov     a,r0            ; 01eb - f8
       orl     a,#20h          ; 01ec - 43 20                        ;??offset 20h+tune number
       mov     r1,a            ; 01ee - a9
       mov     a,@r1           ; 01ef - f1                           ;??read RAM tune byte from 20h+tune nr.
       jb4     X01f8           ; 01f0 - 92 f8                        ;set r2.5 value (tune set) depending on bit 4 of RAM-read value
                                                                     ;start offset 0E0h:tune setA:bit4=0; offset 0D0h:set B:bit4=1
X01f2: xch     a,r2            ; 01f2 - 2a
       anl     a,#0dfh         ; 01f3 - 53 df                        ;r2 AND (1101.1111)=r2.5:=0
X01f5: xch     a,r2            ; 01f5 - 2a
       jmp     X0008           ; 01f6 - 04 08                        ;something playing, but can't guess what
                                                                     ;X008 call means that # of tune already converted to start addr (+offset) and
                                                                     ;stored at Acc


;
X01f8: xch     a,r2            ; 01f8 - 2a
       orl     a,#20h          ; 01f9 - 43 20                        ;r2 OR (0010.1111)=r2.5:=1 (set B)
       jmp     X01f5           ; 01fb - 24 f5


;----------------------------------------------------------------------this is small routine for reading data from this (2nd) page
       org     200h
PG2RD: movp    a,@a            ; 0200 - a3
       jmp     PG2RET          ; 0201 - 04 18

;---below is tune data. Every 00 means end-of-tune
;---this tune set active when middle button is NOT pressed;
INCLUDE "TUNESA.ASM"

;---------------------------offset EF: this short sequence (tune) should be played by X0158 routine, if tune set A active
       org     2efh
       db      78h
       db      3ah
       db      38h
       db      35h
       db      71h
       db      00h             ; 02f4
       db      00h             ; 02f5
       db      00h             ; 02f6
       db      00h             ; 02f7
       db      00h             ; 02f8
       db      00h             ; 02f9
       db      00h             ; 02fa

;---------------------------beeps used in indication of memorize modes
;indication beep 1
       org     2fbh
       db      0ch
       db      00h

;indication beep 2
       org     2fdh
       db      1ch
       db      1ch
       db      00h

;===========================page 3 - another set of tunes
;---------------------------this tunes active when middle button is pressed
org    300h
       ;Что такое осень с 19-го такта
INCLUDE "AUTUMN.ASM"
       db      0d0h
       db      00h
;INCLUDE "TUNESB.ASM"


org    3eeh
;--------------------------triol toggle patch. Triol toggling performed if tune byte=0ffh.
TRLSET:inc a
       jnz NOTRL
       cpl f0
       jmp NXNOTE
NOTRL: dec a
       anl     a,#1fh          ; 001b - 53 1f  S.                      ; AND with (0001.1111)=select 5 lower bits
       ret

;--------------------------triol timer patch.
TRLTMR:jf0 SHRTMR
       mov     a,#5dh          ;standard timer value
       ret
SHRTMR:mov     a,#93h          ;triol timer value
       ret

end