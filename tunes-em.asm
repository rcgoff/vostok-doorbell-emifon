TUNE0: ;------00h----beep
        db      1Ah             ;0300h   2.la     16
        db      00h             ;0301h   p        16

TUNE1: ;------02h----Krylatye kacheli
        db      65h             ;0302h   1.mi     4
        db      72h             ;0303h   2.do#    4
        db      0B2h            ;0304h   2.do#    2
        db      32h             ;0305h   2.do#    8
        db      33h             ;0306h   2.re     8
        db      72h             ;0307h   2.do#    4
        db      0ACh            ;0308h   1.si     2
        db      6Ch             ;0309h   1.si     4
        db      0B7h            ;030Ah   2.fa#    2
        db      30h             ;030Bh   pp       8
        db      37h             ;030Ch   2.fa#    8
        db      35h             ;030Dh   2.mi     8
        db      34h             ;030Eh   2.re#    8
        db      0D5h            ;030Fh   2.mi     2.
        db      6Ah             ;0310h   1.la     4
        db      0BAh            ;0311h   2.la     2
        db      30h             ;0312h   pp       8
        db      3Ah             ;0313h   2.la     8
        db      38h             ;0314h   2.sol    8
        db      36h             ;0315h   2.fa     8
        db      76h             ;0316h   2.fa     4
        db      0B5h            ;0317h   2.mi     2
        db      75h             ;0318h   2.mi     4
        db      37h             ;0319h   2.fa#    8
        db      35h             ;031Ah   2.mi     8
        db      0B7h            ;031Bh   2.fa#    2
        db      69h             ;031Ch   1.sol#   4
        db      0EAh            ;031Dh   1.la     4+16
        db      0D0h            ;031Eh   pp       2.
        db      00h             ;031Fh   p        16

TUNE2: ;------20h-----Ya na solnyshke
        db      4Bh             ;0320h   1.la#    8.
        db      09h             ;0321h   1.sol#   16
        db      68h             ;0322h   1.sol    4
        db      64h             ;0323h   1.re#    4
        db      61h             ;0324h   1.do     4
        db      63h             ;0325h   1.re     4
        db      0A4h            ;0326h   1.re#    2
        db      70h             ;0327h   pp       4
        db      4Bh             ;0328h   1.la#    8.
        db      09h             ;0329h   1.sol#   16
        db      68h             ;032Ah   1.sol    4
        db      64h             ;032Bh   1.re#    4
        db      61h             ;032Ch   1.do     4
        db      63h             ;032Dh   1.re     4
        db      0A4h            ;032Eh   1.re#    2
        db      70h             ;032Fh   pp       4
        db      48h             ;0330h   1.sol    8.
        db      0Bh             ;0331h   1.la#    16
        db      0C6h            ;0332h   1.fa     2.
        db      46h             ;0333h   1.fa     8.
        db      0Bh             ;0334h   1.la#    16
        db      0C4h            ;0335h   1.re#    2.
        db      46h             ;0336h   1.fa     8.
        db      08h             ;0337h   1.sol    16
        db      69h             ;0338h   1.sol#   4
        db      66h             ;0339h   1.fa     4
        db      6Bh             ;033Ah   1.la#    4
        db      69h             ;033Bh   1.sol#   4
        db      0A8h            ;033Ch   1.sol    2
        db      0D0h            ;033Dh   pp       2.
        db      00h             ;033Eh   p        16

TUNE3: ;------3fh-----Pust vsegda budet solntse
        db      63h             ;033Fh   1.re     4
        db      63h             ;0340h   1.re     4
        db      0A8h            ;0341h   1.sol    2
        db      6Ah             ;0342h   1.la     4
        db      6Ch             ;0343h   1.si     4
        db      6Ah             ;0344h   1.la     4
        db      68h             ;0345h   1.sol    4
        db      63h             ;0346h   1.re     4
        db      63h             ;0347h   1.re     4
        db      0A8h            ;0348h   1.sol    2
        db      6Ah             ;0349h   1.la     4
        db      6Ch             ;034Ah   1.si     4
        db      6Ch             ;034Bh   1.si     4
        db      6Ah             ;034Ch   1.la     4
        db      63h             ;034Dh   1.re     4
        db      63h             ;034Eh   1.re     4
        db      0AAh            ;034Fh   1.la     2
        db      6Ch             ;0350h   1.si     4
        db      71h             ;0351h   2.do     4
        db      73h             ;0352h   2.re     4
        db      6Ah             ;0353h   1.la     4
        db      6Ah             ;0354h   1.la     4
        db      6Ch             ;0355h   1.si     4
        db      0B1h            ;0356h   2.do     2
        db      6Ch             ;0357h   1.si     4
        db      6Ah             ;0358h   1.la     4
        db      0A8h            ;0359h   1.sol    2
        db      0D0h            ;035Ah   pp       2.
        db      00h             ;035Bh   p        16

TUNE4: ;------5ch-----Goluboi vagon
        db      25h             ;035Ch   1.mi     8
        db      2Ah             ;035Dh   1.la     8
        db      29h             ;035Eh   1.sol#   8
        db      2Ah             ;035Fh   1.la     8
        db      2Ch             ;0360h   1.si     8
        db      2Ah             ;0361h   1.la     8
        db      28h             ;0362h   1.sol    8
        db      2Ah             ;0363h   1.la     8
        db      68h             ;0364h   1.sol    4
        db      66h             ;0365h   1.fa     4
        db      66h             ;0366h   1.fa     4
        db      70h             ;0367h   pp       4
        db      23h             ;0368h   1.re     8
        db      28h             ;0369h   1.sol    8
        db      27h             ;036Ah   1.fa#    8
        db      28h             ;036Bh   1.sol    8
        db      2Ah             ;036Ch   1.la     8
        db      28h             ;036Dh   1.sol    8
        db      23h             ;036Eh   1.re     8
        db      26h             ;036Fh   1.fa     8
        db      0A5h            ;0370h   1.mi     2
        db      0B0h            ;0371h   pp       2
        db      25h             ;0372h   1.mi     8
        db      2Ah             ;0373h   1.la     8
        db      29h             ;0374h   1.sol#   8
        db      2Ah             ;0375h   1.la     8
        db      2Ch             ;0376h   1.si     8
        db      2Ah             ;0377h   1.la     8
        db      28h             ;0378h   1.sol    8
        db      26h             ;0379h   1.fa     8
        db      65h             ;037Ah   1.mi     4
        db      63h             ;037Bh   1.re     4
        db      6Ah             ;037Ch   1.la     4
        db      70h             ;037Dh   pp       4
        db      25h             ;037Eh   1.mi     8
        db      31h             ;037Fh   2.do     8
        db      2Ch             ;0380h   1.si     8
        db      2Ah             ;0381h   1.la     8
        db      29h             ;0382h   1.sol#   8
        db      2Ah             ;0383h   1.la     8
        db      2Ch             ;0384h   1.si     8
        db      29h             ;0385h   1.sol#   8
        db      0AAh            ;0386h   1.la     2
        db      0D0h            ;0387h   pp       2.
        db      00h             ;0388h   p        16

TUNE5: ;------89h-----Vmeste veselo shagat
        db      2Ah             ;0389h   1.la     8
        db      29h             ;038Ah   1.sol#   8
        db      4Bh             ;038Bh   1.la#    8.
        db      0Ah             ;038Ch   1.la     16
        db      2Ah             ;038Dh   1.la     8
        db      26h             ;038Eh   1.fa     8
        db      63h             ;038Fh   1.re     4
        db      23h             ;0390h   1.re     8
        db      25h             ;0391h   1.mi     8
        db      63h             ;0392h   1.re     4
        db      0A2h            ;0393h   1.do#    2
        db      23h             ;0394h   1.re     8
        db      25h             ;0395h   1.mi     8
        db      63h             ;0396h   1.re     4
        db      0A2h            ;0397h   1.do#    2
        db      23h             ;0398h   1.re     8
        db      25h             ;0399h   1.mi     8
        db      68h             ;039Ah   1.sol    4
        db      0A6h            ;039Bh   1.fa     2
        db      2Ah             ;039Ch   1.la     8
        db      29h             ;039Dh   1.sol#   8
        db      4Bh             ;039Eh   1.la#    8.
        db      0Ah             ;039Fh   1.la     16
        db      2Ah             ;03A0h   1.la     8
        db      26h             ;03A1h   1.fa     8
        db      63h             ;03A2h   1.re     4
        db      26h             ;03A3h   1.fa     8
        db      2Ah             ;03A4h   1.la     8
        db      71h             ;03A5h   2.do     4
        db      0ABh            ;03A6h   1.la#    2
        db      2Bh             ;03A7h   1.la#    8
        db      31h             ;03A8h   2.do     8
        db      6Bh             ;03A9h   1.la#    4
        db      0AAh            ;03AAh   1.la     2
        db      25h             ;03ABh   1.mi     8
        db      26h             ;03ACh   1.fa     8
        db      65h             ;03ADh   1.mi     4
        db      0A3h            ;03AEh   1.re     2
        db      0D0h            ;03AFh   pp       2.
        db      00h             ;03B0h   p        16

TUNE6: ;------0b1h----Bremenskiye muzykanty
        db      21h             ;03B1h   1.do     8
        db      21h             ;03B2h   1.do     8
        db      21h             ;03B3h   1.do     8
        db      23h             ;03B4h   1.re     8
        db      25h             ;03B5h   1.mi     8
        db      25h             ;03B6h   1.mi     8
        db      21h             ;03B7h   1.do     8
        db      25h             ;03B8h   1.mi     8
        db      68h             ;03B9h   1.sol    4
        db      65h             ;03BAh   1.mi     4
        db      68h             ;03BBh   1.sol    4
        db      70h             ;03BCh   pp       4
        db      26h             ;03BDh   1.fa     8
        db      26h             ;03BEh   1.fa     8
        db      26h             ;03BFh   1.fa     8
        db      25h             ;03C0h   1.mi     8
        db      23h             ;03C1h   1.re     8
        db      23h             ;03C2h   1.re     8
        db      26h             ;03C3h   1.fa     8
        db      2Ah             ;03C4h   1.la     8
        db      68h             ;03C5h   1.sol    4
        db      66h             ;03C6h   1.fa     4
        db      68h             ;03C7h   1.sol    4
        db      70h             ;03C8h   pp       4
        db      85h             ;03C9h   1.mi     4.
        db      25h             ;03CAh   1.mi     8
        db      68h             ;03CBh   1.sol    4
        db      65h             ;03CCh   1.mi     4
        db      2Ah             ;03CDh   1.la     8
        db      2Ah             ;03CEh   1.la     8
        db      2Ah             ;03CFh   1.la     8
        db      2Ch             ;03D0h   1.si     8
        db      71h             ;03D1h   2.do     4
        db      6Ah             ;03D2h   1.la     4
        db      33h             ;03D3h   2.re     8
        db      33h             ;03D4h   2.re     8
        db      33h             ;03D5h   2.re     8
        db      31h             ;03D6h   2.do     8
        db      2Ch             ;03D7h   1.si     8
        db      28h             ;03D8h   1.sol    8
        db      2Ch             ;03D9h   1.si     8
        db      33h             ;03DAh   2.re     8
        db      71h             ;03DBh   2.do     4
        db      6Ch             ;03DCh   1.si     4
        db      6Ah             ;03DDh   1.la     4
        db      70h             ;03DEh   pp       4
        db      86h             ;03DFh   1.fa     4.
        db      28h             ;03E0h   1.sol    8
        db      6Ah             ;03E1h   1.la     4
        db      71h             ;03E2h   2.do     4
        db      6Ch             ;03E3h   1.si     4
        db      6Ah             ;03E4h   1.la     4
        db      6Ch             ;03E5h   1.si     4
        db      73h             ;03E6h   2.re     4
        db      35h             ;03E7h   2.mi     8
        db      33h             ;03E8h   2.re     8
        db      71h             ;03E9h   2.do     4
        db      0D0h            ;03EAh   pp       2.
        db      00h             ;03EBh   p        16
        db      00h             ;03ECh   p        16

;----------------------------------------------------------------------last 0d19 bytes are 0ffh
        db      0FFh            ;03EDh
        db      0FFh            ;03EEh
        db      0FFh            ;03EFh
        db      0FFh            ;03F0h
        db      0FFh            ;03F1h
        db      0FFh            ;03F2h
        db      0FFh            ;03F3h
        db      0FFh            ;03F4h
        db      0FFh            ;03F5h
        db      0FFh            ;03F6h
        db      0FFh            ;03F7h
        db      0FFh            ;03F8h
        db      0FFh            ;03F9h
        db      0FFh            ;03FAh
        db      0FFh            ;03FBh
        db      0FFh            ;03FCh
        db      0FFh            ;03FDh
        db      0FFh            ;03FEh
        db      0FFh            ;03FFh

END
