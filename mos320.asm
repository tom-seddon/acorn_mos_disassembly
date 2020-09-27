\ -*- mode:beebasm -*-
org &8000
cpu 1

OS_CLI=&FFF7:OSBYTE=&FFF4:OSWORD=&FFF1:OSWRCH=&FFEE
OSWRCR=&FFEC:OSNEWL=&FFE7:OSASCI=&FFE3:OSRDCH=&FFE0
OSBGET=&FFD7:OSFIND=&FFCE:OSGBPB=&FFD1:OSBPUT=&FFD4
OSFILE=&FFDD:OSARGS=&FFDA

CRTC=&FE00
ADC=$fe18
SYSTEM_VIA=$fe40
USER_VIA=$fe60
TUBE=&fee0
ROMSEL=&fe30
VCONTROL=&fe20
VPALETTE=&fe21

HAZEL_WORKSPACE=$df00

; Presumed addresses in ANDY that don't happen to coincide with other
;labels.

L8001=&8001
L8002=&8002
L8004=&8003
L8010=&8010
;L8011=&8011
;L8012=&8012
L8021=&8021
L8400=&8400
L8500=&8500
L8600=&8600
L8820=&8820
L87FF=&887F
L8803=&8803
L8804=&8804
L8836=&8836
L8837=&8837
L883C=&883C
L8840=&8840
L8844=&8844
L8845=&8845

; entry points in the View bank
XBA00=&BA00
XBA67=&BA67
XBEBE=&BEBE

; written to during startup
LFE8E=&fe8e

.L8000:JMP LAF77              :\ Language entry point
.L8003:JMP L9D72              :\ Service entry point
.L8006:EQUB &C2               :\ ROM type=SERV+LANG+6502
.L8007:EQUB L8011-L8000       :\ (C) offset
.L8008:EQUB &01               :\ Version 1.xx
.L8009:EQUS "TERMINAL"        :\ ROM title
.L8011:EQUB 0
.L8012:EQUS "(C)1984 Acorn":EQUB 0


\ STARTUP
\ =======
.L8020
LDA #&FE:TRB LFE34        :\ 8022= 1C 34 FE    .4~
STZ HAZEL_WORKSPACE+&DD        
TRB &0366
CLD              
LDX #&FF:TXS
STX USER_VIA+&3
LDA #&CF:STA SYSTEM_VIA+&2        :\ 8034= 8D 42 FE    .B~
LDY #&20         :\ 8037= A0 20         
LDX #&0A         :\ 8039= A2 0A       ".
JSR L98E4        :\ 803B= 20 E4 98     d.
JSR L9729        :\ 803E= 20 29 97     ).
LDA #&0C         :\ 8041= A9 0C       ).
TSB LFE34        :\ 8043= 0C 34 FE    .4~
LDA SYSTEM_VIA+&E        :\ 8046= AD 4E FE    -N~
ASL A            :\ 8049= 0A          .
PHA              :\ 804A= 48          H
BEQ L8054        :\ 804B= F0 07       p.
LDA &0258        :\ 804D= AD 58 02    -X.
LSR A            :\ 8050= 4A          J
DEC A            :\ 8051= 3A          :
BNE L8073        :\ 8052= D0 1F       P.
.L8054
TAY              :\ 8054= A8          (
.L8055
TYA              :\ 8055= 98          .
STZ &01          :\ 8056= 64 01       d.
STZ &00          :\ 8058= 64 00       d.
.L805A
STA (&00),Y      :\ 805A= 91 00       ..
INY              :\ 805C= C8          H
BNE L805A        :\ 805D= D0 FB       P{
INC &01          :\ 805F= E6 01       f.
LDX #&40:STX &0D00
LDX &01          :\ 8066= A6 01       &.
CPX #&E0         :\ 8068= E0 E0       ``
BCC L805A        :\ 806A= 90 EE       .n
LDA #&04         :\ 806C= A9 04       ).
TRB LFE34        :\ 806E= 1C 34 FE    .4~
BNE L8055        :\ 8071= D0 E2       Pb
.L8073
LDA #&11:STA HAZEL_WORKSPACE+&04        :\ 8075= 8D 04 DF    .._
LDA #&E8:STA HAZEL_WORKSPACE+&05        :\ 807A= 8D 05 DF    .._
LDA #&0C:TRB LFE34        :\ 807F= 1C 34 FE    .4~
LDA #&0F:STA &028E        :\ 8084= 8D 8E 02    ...
.L8087
DEC A:STA SYSTEM_VIA+&0        :\ 8088= 8D 40 FE    .@~
CMP #&09:BCS L8087        :\ 808D= B0 F8       0x
LDX #&01:JSR LF880        :\ 8091= 20 80 F8     .x
CPX #&80:JSR LF735        :\ 8096= 20 35 F7     5w
STZ &028D        :\ 8099= 9C 8D 02    ...
ROR A            :\ 809C= 6A          j
LDX #&9C         :\ 809D= A2 9C       ".
LDY #&8D         :\ 809F= A0 8D        .
PLA              :\ 80A1= 68          h
BEQ L80AD        :\ 80A2= F0 09       p.
LDY #&7E         :\ 80A4= A0 7E        ~
BCC L80DF        :\ 80A6= 90 37       .7
LDY #&87         :\ 80A8= A0 87        .
INC &028D        :\ 80AA= EE 8D 02    n..
.L80AD
INC &028D        :\ 80AD= EE 8D 02    n..
PHY              :\ 80B0= 5A          Z
JSR L8E76           :\ Read configured MODE
.L80B4
ORA #&08:STA &028F  :\ Store in OSBYTE 255 with boot off (b3=1)
.L80B9
JSR L98AE:AND #&10  :\ Read configured BOOT
LSR A:TRB &028F     :\ Reset OSBYTE 255 boot bit (b3) if BOOT
JSR L8E5A        :\ 80C2= 20 5A 8E     Z.
STY &0290        :\ 80C5= 8C 90 02    ...
STX &0291        :\ 80C8= 8E 91 02    ...
.L80CB
JSR L98AE        :\ 80CB= 20 AE 98     ..
AND #&08         :\ 80CE= 29 08       ).
BEQ L80D4        :\ 80D0= F0 02       p.
LDA #&01         :\ 80D2= A9 01       ).
.L80D4
STA &0366        :\ 80D4= 8D 66 03    .f.
JSR L927B        :\ 80D7= 20 7B 92     {.
PLY              :\ 80DA= 7A          z
LDX #&92         :\ 80DB= A2 92       ".
BRA L80F7        :\ 80DD= 80 18       ..
 
.L80DF
LDA #&87:TRB &028F  :\ Clear MODE bits from OSBYTE 255
LDA &0355:AND #&07  :\ Get current screen MODE b0-b2
TSB &028F           :\ Copy to OSBYTE 255
LDA #&10            :\ Test shadow screen bit in VDU flags
BIT &D0:BEQ L80F7   :\ Not shadow screen
LDA #&80:TSB &028F  :\ Set shadow screen bit in OSBYTE 255
.L80F7
LDA &028D:BNE L8104
CPX #&B1:BCS L8104
CPX #&A1:BCS L810E
.L8104
STZ &0200,X      :\ 8104= 9E 00 02    ...
CPX #&CD         :\ 8107= E0 CD       `M
BCC L810E        :\ 8109= 90 03       ..
DEC &0200,X      :\ 810B= DE 00 02    ^..
.L810E
INX              :\ 810E= E8          h
BNE L80F7        :\ 810F= D0 E6       Pf
LDX #&CF         :\ 8111= A2 CF       "O
.L8113
STZ &00,X        :\ 8113= 74 00       t.
INX              :\ 8115= E8          h
BNE L8113        :\ 8116= D0 FB       P{
LDA &028D        :\ 8118= AD 8D 02    -..
BNE L813D        :\ 811B= D0 20       P 
LDA &0246:PHA              :\ 8120= 48          H
LDA &024B:PHA              :\ 8124= 48          H
LDA &0244:PHA              :\ 8128= 48          H
LDA &0257:PHA              :\ 812C= 48          H
LDX &0256        :\ 812D= AE 56 02    .V.
.L8130
LDA LE2D6,Y      :\ 8130= B9 D6 E2    9Vb
STA &01FF,Y      :\ 8133= 99 FF 01    ...
DEY              :\ 8136= 88          .
CPY #&21         :\ 8137= C0 21       @!
BCS L8130        :\ 8139= B0 F5       0u
LDY #&12         :\ 813B= A0 12        .
.L813D
LDA LE2D6,Y      :\ 813D= B9 D6 E2    9Vb
STA &01FF,Y      :\ 8140= 99 FF 01    ...
DEY              :\ 8143= 88          .
BNE L813D        :\ 8144= D0 F7       Pw
LDA &028D        :\ 8146= AD 8D 02    -..
BNE L8164        :\ 8149= D0 19       P.
STX &0256        :\ 814B= 8E 56 02    .V.
PLA              :\ 814E= 68          h
CMP #&04         :\ 814F= C9 04       I.
BCS L8155        :\ 8151= B0 02       0.
LDA #&00         :\ 8153= A9 00       ).
.L8155
STA &0257        :\ 8155= 8D 57 02    .W.
PLA:STA &0244        :\ 8159= 8D 44 02    .D.
PLA:STA &024B        :\ 815D= 8D 4B 02    .K.
PLA:STA &0246        :\ 8161= 8D 46 02    .F.
.L8164
JSR L8EAD        :\ 8164= 20 AD 8E     -.
LDX #&20         :\ 8167= A2 20       " 
ASL A            :\ 8169= 0A          .
ASL A            :\ 816A= 0A          .
BMI L8174        :\ 816B= 30 07       0.
LDX #&30         :\ 816D= A2 30       "0
ASL A            :\ 816F= 0A          .
BMI L8174        :\ 8170= 30 02       0.
LDX #&A0         :\ 8172= A2 A0       " 
.L8174
STX &025A        :\ 8174= 8E 5A 02    .Z.
JSR LE590        :\ 8177= 20 90 E5     .e
JSR LF107        :\ 817A= 20 07 F1     .q
LDA &028D        :\ 817D= AD 8D 02    -..
BEQ L8196        :\ 8180= F0 14       p.
JSR L8EA8        :\ 8182= 20 A8 8E     (.
STA &0286        :\ 8185= 8D 86 02    ...
JSR L98AA        :\ 8188= 20 AA 98     *.
LSR A            :\ 818B= 4A          J
LSR A            :\ 818C= 4A          J
ROR &0246        :\ 818D= 6E 46 02    nF.
JSR L8E8D        :\ 8190= 20 8D 8E     ..
STA &0285        :\ 8193= 8D 85 02    ...
.L8196
JSR L8E97        :\ 8196= 20 97 8E     ..
ASL A            :\ 8199= 0A          .
ASL A            :\ 819A= 0A          .
ORA #&42         :\ 819B= 09 42       .B
STA &0250        :\ 819D= 8D 50 02    .P.
JSR LA9D6        :\ 81A0= 20 D6 A9     V)
LDX #&01         :\ 81A3= A2 01       ".
LDA #&7F         :\ 81A5= A9 7F       ).
.L81A7
STA SYSTEM_VIA+&D,X      :\ 81A7= 9D 4D FE    .M~
STA USER_VIA+&D,X      :\ 81AA= 9D 6D FE    .m~
DEX              :\ 81AD= CA          J
BPL L81A7        :\ 81AE= 10 F7       .w
CLI              :\ 81B0= 58          X
SEI              :\ 81B1= 78          x
BIT &FC          :\ 81B2= 24 FC       $|
BVC L81B9        :\ 81B4= 50 03       P.
JSR LF8CF        :\ 81B6= 20 CF F8     Ox
.L81B9
LDX #&D2:STX SYSTEM_VIA+&E    
LDX #&04:STX SYSTEM_VIA+&C    
LDA #&40:STA SYSTEM_VIA+&B    
LDA #&0E:STA SYSTEM_VIA+&6    
STA USER_VIA+&C:STA ADC+0
LDA #&27:STA SYSTEM_VIA+&7    
STA SYSTEM_VIA+&5
LDX #&08   
.L81DD
DEX              :\ 81DD= CA          J
JSR LF55D        :\ 81DE= 20 5D F5     ]u
CPX #&04         :\ 81E1= E0 04       `.
BNE L81DD        :\ 81E3= D0 F8       Px
JSR LF910        :\ 81E5= 20 10 F9     .y
STX &ED          :\ 81E8= 86 ED       .m
LDX #&00         :\ 81EA= A2 00       ".
JSR LE97D        :\ 81EC= 20 7D E9     }i
LDA &0282        :\ 81EF= AD 82 02    -..
AND #&7F         :\ 81F2= 29 7F       ).
JSR LEC89        :\ 81F4= 20 89 EC     .l
JSR L8E84        :\ 81F7= 20 84 8E     ..
PHA              :\ 81FA= 48          H
TAX              :\ 81FB= AA          *
JSR LEC6B        :\ 81FC= 20 6B EC     kl
PLX              :\ 81FF= FA          z
LDA #&07         :\ 8200= A9 07       ).
JSR LEC6D        :\ 8202= 20 6D EC     ml
JSR L98AE        :\ 8205= 20 AE 98     ..
BIT #&02         :\ 8208= 89 02       ..
BNE L8211        :\ 820A= D0 05       P.
LDA #&F0         :\ 820C= A9 F0       )p
STA &0264        :\ 820E= 8D 64 02    .d.
.L8211
JSR LE590        :\ 8211= 20 90 E5     .e
LDX &0284        :\ 8214= AE 84 02    ...
BEQ L821C        :\ 8217= F0 03       p.
JSR LF11A        :\ 8219= 20 1A F1     .q
.L821C
LDA &028D        :\ 821C= AD 8D 02    -..
BEQ L8224        :\ 821F= F0 03       p.
JMP LE3A0        :\ 8221= 4C A0 E3    L c
 
.L8224
LDA &028F:JSR LC799    :\ Select startup screen MODE
LDA &028D        :\ 822A= AD 8D 02    -..
DEC A            :\ 822D= 3A          :
BNE L8284        :\ 822E= D0 54       PT
LDA &ED          :\ 8230= A5 ED       %m
CMP #&33         :\ 8232= C9 33       I3
BNE L8284        :\ 8234= D0 4E       PN
LDX #&31         :\ 8236= A2 31       "1
.L8238
PHX              :\ 8238= DA          Z
LDY #&00         :\ 8239= A0 00        .
JSR L98DC        :\ 823B= 20 DC 98     \.
PLX              :\ 823E= FA          z
DEX              :\ 823F= CA          J
BPL L8238        :\ 8240= 10 F6       .v
LDY #&FF         :\ 8242= A0 FF        .
LDX #&06         :\ 8244= A2 06       ".
JSR L98DC        :\ 8246= 20 DC 98     \.
LDX #&07         :\ 8249= A2 07       ".
JSR L98DC        :\ 824B= 20 DC 98     \.
JSR LA958        :\ 824E= 20 58 A9     X)
ORA &430A        :\ 8251= 0D 0A 43    ..C
EOR &534F        :\ 8254= 4D 4F 53    MOS
JSR &4152        :\ 8257= 20 52 41     RA
EOR &7220        :\ 825A= 4D 20 72    M r
ADC &73          :\ 825D= 65 73       es
ADC &74          :\ 825F= 65 74       et
ORA &500A        :\ 8261= 0D 0A 50    ..P
ADC (&65)        :\ 8264= 72 65       re
EQUB &73         :\ 8266= 73          s
EQUB &73         :\ 8267= 73          s
JSR &7262        :\ 8268= 20 62 72     br
ADC &61          :\ 826B= 65 61       ea
EQUB &6B         :\ 826D= 6B          k
JSR &6F74        :\ 826E= 20 74 6F     to
JSR &6F63        :\ 8271= 20 63 6F     co
ROR &6974        :\ 8274= 6E 74 69    nti
ROR &6575        :\ 8277= 6E 75 65    nue
ORA &000A        :\ 827A= 0D 0A 00    ...
LDA #&03         :\ 827D= A9 03       ).
STA &0258        :\ 827F= 8D 58 02    .X.
.L8282
BRA L8282        :\ 8282= 80 FE       .~
 
.L8284
JSR LEDBA        :\ 8284= 20 BA ED     :m
STZ HAZEL_WORKSPACE+&D4        :\ 8287= 9C D4 DF    .T_
STZ HAZEL_WORKSPACE+&D5        :\ 828A= 9C D5 DF    .U_
LDY #&CA         :\ 828D= A0 CA        J
JSR LEA7E        :\ 828F= 20 7E EA     ~j
JSR LF349        :\ 8292= 20 49 F3     Is
LDA &028D        :\ 8295= AD 8D 02    -..
BEQ L829D        :\ 8298= F0 03       p.
JSR LEDD0        :\ 829A= 20 D0 ED     Pm
.L829D
JSR L98AA        :\ 829D= 20 AA 98     *.
LSR A            :\ 82A0= 4A          J
BCC L82D0        :\ 82A1= 90 2D       .-
JSR L98AE        :\ 82A3= 20 AE 98     ..
BIT #&04         :\ 82A6= 89 04       ..
PHP              :\ 82A8= 08          .
LDA #&10         :\ 82A9= A9 10       ).
TRB LFE34        :\ 82AB= 1C 34 FE    .4~
PLP              :\ 82AE= 28          (
BNE L82B4        :\ 82AF= D0 03       P.
TSB LFE34        :\ 82B1= 0C 34 FE    .4~
.L82B4
JSR LE375:BCS L82C6       :\ If Tube hardware present, jump to Tube PreInit
LDA LFE34:EOR #&10        :\ Toggle Internal/External Tube
STA LFE34
JSR LE375:BCC L82D0       :\ No Tube, skip past Tube PreInit
.L82C6
LDX #&FF:JSR LEE72        :\ Service call &FF - Tube PreInit
BNE L82D0                 :\ Not claimed, step past
DEC &027A                 :\ Tube PreInit claimed, set TubeFlag to &FF, Tube present
.L82D0
LDA &028D:BEQ L82FC       :\ Soft Break, don't ask about workspace
LDY #&DC                  :\ Start high workspace at &DC00 and work downwards
LDX #&24:JSR LEE72        :\ Ask ROMs how much private high workspace required
LDX #&21:JSR LEE72        :\ Ask ROMs for maximum shared high workspace required
PHY                       :\ Save top of shared workspace
LDX #&22:JSR LEE72        :\ Ask ROMs for private high workspace required
LDY #&0E                  :\ Start low workspace at &0E00
LDX #&01:JSR LEE72        :\ Ask ROMs for maximum shared workspace
LDX #&02:JSR LEE72        :\ Ask ROMs for private workspace
STY &0244                 :\ Set OSHWM - default PAGE
PLY                       :\ Get top of shared high workspace
LDX #&23:JSR LEE72        :\ Tell ROMs top of shared high workspace
.L82FC
LDX #&21      
.L82FE
LDA L8347-1,X:STA HAZEL_WORKSPACE+&05,X :\ Copy initial FS info blocks for CFS, TAPE, ROM
DEX:BNE L82FE
STZ &F2:LDA #&DF:STA &F3  :\ &F2/3=>FS Info Blocks
LDY #&27                  :\ Y=>end of FS Info Blocks
LDX #&25:JSR LEE72        :\ Ask ROMs for FS Info Blocks
LDA #&00:STA (&F2),Y      :\ Terminate FS Info blocks

LDA &0257:PHA:STZ &0257   :\ Save Spool handle and disable Spooling
                          :\ (Why would we be Spooling during Startup?)
LDX #&FE:LDY &027A
JSR LEE72                 :\ Tube PostInit
AND &0267:BPL L8340
LDY #&FF:JSR LE7A1        :\ Print <NL>"Acorn MOS"
LDA &028D:BEQ L833B       :\ Skip past if Soft Break
LDY #&0A:JSR LE7A1        :\ Print <BELL> (space in message for "xxK")
.L833B
LDY #&0F:JSR LE7A1        :\ Print <NL><NL>
.L8340
PLA:STA &0257             :\ Restore Spool handle
JMP LE40E    

\ Default FS Info Blocks
\ ======================
.L8347
EQUS "CFS     ":EQUB &01:EQUB &02:EQUB &01
EQUS "TAPE    ":EQUB &01:EQUB &02:EQUB &01
EQUS "ROM     ":EQUB &03:EQUB &03:EQUB &03

\ MOS command table
\ =================
.L8368
EQUS "CAT"      :EQUB LF1E5 DIV 256:EQUB LF1E5 AND 255:EQUB &80:EQUB &05 :\ XY=>parameters, FSC &05
EQUS "ADFS"     :EQUB L85AF DIV 256:EQUB L85AF AND 255:EQUB &00:EQUB &00 :\
EQUS "APPEND"   :EQUB L9014 DIV 256:EQUB L9014 AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "BASIC"    :EQUB L85A6 DIV 256:EQUB L85A6 AND 255:EQUB &00:EQUB &00 :\
EQUS "BUILD"    :EQUB L900F DIV 256:EQUB L900F AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "CLOSE"    :EQUB L937C DIV 256:EQUB L937C AND 255:EQUB &00:EQUB &FF :\
EQUS "CONFIGURE":EQUB L887A DIV 256:EQUB L887A AND 255:EQUB &00:EQUB &FF :\
EQUS "CODE"     :EQUB L93EB DIV 256:EQUB L93EB AND 255:EQUB &00:EQUB &88 :\ X,Y=parameters, OSBYTE &88
EQUS "CREATE"   :EQUB L9318 DIV 256:EQUB L9318 AND 255:EQUB &80:EQUB &07 :\ XY=>parameters, OSFILE &07
EQUS "DUMP"     :EQUB L8F42 DIV 256:EQUB L8F42 AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "DELETE"   :EQUB L946A DIV 256:EQUB L946A AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "EXEC"     :EQUB LA591 DIV 256:EQUB LA591 AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "EX"       :EQUB LF1E5 DIV 256:EQUB LF1E5 AND 255:EQUB &80:EQUB &09 :\ XY=>parameters, FSC &09
EQUS "FX"       :EQUB L93E5 DIV 256:EQUB L93E5 AND 255:EQUB &00:EQUB &FF :\
EQUS "GOIO"     :EQUB L92FD DIV 256:EQUB L92FD AND 255:EQUB &00:EQUB &FF :\
EQUS "GO"       :EQUB L92F5 DIV 256:EQUB L92F5 AND 255:EQUB &00:EQUB &FF :\
EQUS "HELP"     :EQUB L85CA DIV 256:EQUB L85CA AND 255:EQUB &00:EQUB &FF :\
EQUS "INFO"     :EQUB LF1E5 DIV 256:EQUB LF1E5 AND 255:EQUB &80:EQUB &0A :\ XY=>parameters, FSC &0A
EQUS "IGNORE"   :EQUB L9387 DIV 256:EQUB L9387 AND 255:EQUB &00:EQUB &FF :\
EQUS "INSERT"   :EQUB L871F DIV 256:EQUB L871F AND 255:EQUB &00:EQUB &FF :\
EQUS "KEY"      :EQUB L94C7 DIV 256:EQUB L94C7 AND 255:EQUB &00:EQUB &FF :\
EQUS "LOAD"     :EQUB L9316 DIV 256:EQUB L9316 AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "LIST"     :EQUB L8EC0 DIV 256:EQUB L8EC0 AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "LINE"     :EQUB LEC39 DIV 256:EQUB LEC39 AND 255:EQUB &00:EQUB &01 :\
EQUS "LIBFS"    :EQUB LE7F6 DIV 256:EQUB LE7F6 AND 255:EQUB &00:EQUB &00 :\
EQUS "MOTOR"    :EQUB L93EB DIV 256:EQUB L93EB AND 255:EQUB &00:EQUB &89 :\ X,Y=parameters, OSBYTE &89
EQUS "MOVE"     :EQUB L90B6 DIV 256:EQUB L90B6 AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "OPT"      :EQUB L93EB DIV 256:EQUB L93EB AND 255:EQUB &80:EQUB &8B :\ X,Y=parameters, OSBYTE &8B
EQUS "PRINT"    :EQUB L8EB9 DIV 256:EQUB L8EB9 AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "RUN"      :EQUB LF1E5 DIV 256:EQUB LF1E5 AND 255:EQUB &80:EQUB &04 :\ XY=>parameters, FSC &04
EQUS "REMOVE"   :EQUB L9371 DIV 256:EQUB L9371 AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "ROM"      :EQUB L93EB DIV 256:EQUB L93EB AND 255:EQUB &00:EQUB &8D :\ X,Y=parameters, OSBYTE &8D
EQUS "ROMS"     :EQUB L86A6 DIV 256:EQUB L86A6 AND 255:EQUB &00:EQUB &FF :\
EQUS "SAVE"     :EQUB L9318 DIV 256:EQUB L9318 AND 255:EQUB &80:EQUB &00 :\ XY=>parameters, OSFILE &00
EQUS "SHADOW"   :EQUB L9466 DIV 256:EQUB L9466 AND 255:EQUB &00:EQUB &FF :\
EQUS "SHOW"     :EQUB L9488 DIV 256:EQUB L9488 AND 255:EQUB &00:EQUB &FF :\
EQUS "SHUT"     :EQUB LF373 DIV 256:EQUB LF373 AND 255:EQUB &00:EQUB &00 :\
EQUS "SPOOL"    :EQUB L9433 DIV 256:EQUB L9433 AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "SPOOLON"  :EQUB L9420 DIV 256:EQUB L9420 AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "STATUS"   :EQUB L8895 DIV 256:EQUB L8895 AND 255:EQUB &00:EQUB &FF :\
EQUS "TAPE"     :EQUB L93EB DIV 256:EQUB L93EB AND 255:EQUB &00:EQUB &8C :\ X,Y=parameters, OSBYTE &8C
EQUS "TV"       :EQUB L93EB DIV 256:EQUB L93EB AND 255:EQUB &00:EQUB &90 :\ X,Y=parameters, OSBYTE &90
EQUS "TIME"     :EQUB L8744 DIV 256:EQUB L8744 AND 255:EQUB &00:EQUB &00 :\
EQUS "TYPE"     :EQUB L8ECB DIV 256:EQUB L8ECB AND 255:EQUB &80:EQUB &00 :\ XY=>parameters
EQUS "UNPLUG"   :EQUB L8722 DIV 256:EQUB L8722 AND 255:EQUB &00:EQUB &FF :\
EQUS "X"        :EQUB LE7FD DIV 256:EQUB LE7FD AND 255:EQUB &00:EQUB &00 :\
EQUS ""         :EQUB LF1E5 DIV 256:EQUB LF1E5 AND 255:EQUB &00:EQUB &03 :\ FSC &03
EQUB &00

.L84EE
LDA (&B0)        :\ 84EE= B2 B0       20
.L84F0
BMI L84FE        :\ 84F0= 30 0C       0.
.L84F2
TYA              :\ 84F2= 98          .
.L84F3
CLC              :\ 84F3= 18          .
ADC &F2          :\ 84F4= 65 F2       er
TAX              :\ 84F6= AA          *
LDY &F3          :\ 84F7= A4 F3       $s
.L84F9
BCC L84FC        :\ 84F9= 90 01       ..
INY              :\ 84FB= C8          H
.L84FC
LDA (&B0)        :\ 84FC= B2 B0       20
.L84FE
RTS              :\ 84FE= 60          `
 
\ Prepare OSCLI command line
\ ==========================
.L84FF
STX &F2          :\ 84FF= 86 F2       .r
STY &F3          :\ 8501= 84 F3       .s
LDA HAZEL_WORKSPACE+&00        :\ 8503= AD 00 DF    -._
JSR LFB4D        :\ 8506= 20 4D FB     M{
LDA #&08         :\ 8509= A9 08       ).
JSR LF1E5        :\ 850B= 20 E5 F1     eq
LDY #&FF         :\ 850E= A0 FF        .
.L8510
JSR LF2FE        :\ 8510= 20 FE F2     ~r
BEQ L84FE        :\ 8513= F0 E9       pi
CMP #&2A         :\ 8515= C9 2A       I*
BEQ L8510        :\ 8517= F0 F7       pw
JSR LF2FF        :\ 8519= 20 FF F2     .r
BEQ L84FE        :\ 851C= F0 E0       p`
CMP #&7C         :\ 851E= C9 7C       I|
BEQ L84FE        :\ 8520= F0 DC       p\
STZ HAZEL_WORKSPACE+&C6        :\ 8522= 9C C6 DF    .F_
CMP #&2D         :\ 8525= C9 2D       I-
BNE L8535        :\ 8527= D0 0C       P.
JSR LFAA6        :\ 8529= 20 A6 FA     &z
JSR LFB4D        :\ 852C= 20 4D FB     M{
SEC              :\ 852F= 38          8
ROR HAZEL_WORKSPACE+&C6        :\ 8530= 6E C6 DF    nF_
LDA (&F2),Y      :\ 8533= B1 F2       1r
.L8535
CMP #&2F         :\ 8535= C9 2F       I/
BNE L8542        :\ 8537= D0 09       P.
INY              :\ 8539= C8          H
JSR L84F2        :\ 853A= 20 F2 84     r.
LDA #&02         :\ 853D= A9 02       ).
JMP LF1E5        :\ 853F= 4C E5 F1    Leq
 
.L8542
STY &E6
LDA #L8368 AND 255:STA &B0  :\ Point to command table
LDA #L8368 DIV 256:STA &B1
BRA L8558
 
.L854E
EOR (&B0)        :\ 854E= 52 B0       R0
AND #&DF         :\ 8550= 29 DF       )_
BNE L8569        :\ 8552= D0 15       P.
JSR L859B        :\ 8554= 20 9B 85     ..
INY              :\ 8557= C8          H
.L8558
LDA (&F2),Y      :\ 8558= B1 F2       1r
JSR LEA71        :\ 855A= 20 71 EA     qj
BCC L854E        :\ 855D= 90 EF       .o
LDA (&B0)        :\ 855F= B2 B0       20
BMI L8582        :\ 8561= 30 1F       0.
LDA (&F2),Y      :\ 8563= B1 F2       1r
CMP #&2E         :\ 8565= C9 2E       I.
BEQ L856D        :\ 8567= F0 04       p.
.L8569
CLC              :\ 8569= 18          .
LDY &E6          :\ 856A= A4 E6       $f
DEY              :\ 856C= 88          .
.L856D
INY              :\ 856D= C8          H
.L856E
JSR L859B        :\ Get byte from table, update pointer
BEQ L85AF        :\ Zero byte
BPL L856E        :\ Loop until b7 set
BCS L8585        :\ 8575= B0 0E       0.
JSR L859B        :\ 8577= 20 9B 85     ..
JSR L859B        :\ 857A= 20 9B 85     ..
JSR L859B        :\ 857D= 20 9B 85     ..
BRA L8558        :\ 8580= 80 D6       .V
 
.L8582
JSR L859B        :\ 8582= 20 9B 85     ..
.L8585
PHA              :\ 8585= 48          H
JSR L859B        :\ 8586= 20 9B 85     ..
PHA              :\ 8589= 48          H
JSR L859B        :\ 858A= 20 9B 85     ..
BMI L8592        :\ 858D= 30 03       0.
STZ HAZEL_WORKSPACE+&C6        :\ 858F= 9C C6 DF    .F_
.L8592
JSR LF2FF        :\ 8592= 20 FF F2     .r
CLC              :\ 8595= 18          .
PHP              :\ 8596= 08          .
JSR L84EE        :\ 8597= 20 EE 84     n.
RTI              :\ 859A= 40          @
 
.L859B
LDA (&B0)        :\ 859B= B2 B0       20
PHA              :\ 859D= 48          H
INC &B0          :\ 859E= E6 B0       f0
BNE L85A4        :\ 85A0= D0 02       P.
INC &B1          :\ 85A2= E6 B1       f1
.L85A4
PLA              :\ 85A4= 68          h
.L85A5
RTS              :\ 85A5= 60          `

\ *BASIC
\ ======
.L85A6
LDX &024B        :\ Get BASIC ROM number
BMI L85AF        :\ If no BASIC ROM, jump to pass to ROMs and filing system
SEC              :\
JMP LE4C3        :\ Enter ROM as a language

\ *ADFS - pass straight to ROMs/Filing System
\ ===========================================
.L85AF
BIT HAZEL_WORKSPACE+&C6        :\ Check filing system flag
BMI L85C0        :\ If ... skip ROM service call
STZ HAZEL_WORKSPACE+&C6        :\ Clear filing system flag
LDY &E6
LDX #&04
JSR LEE03        :\ Service call 4 - Unknown command
BEQ L85A5        :\ Claimed, return
.L85C0
LDA &E6
JSR L84F3        :\ F2toXY
LDA #&03 
JMP LF1E5        :\ Pass to FSCV,3 - Unknown command

.L85CA 
LDX #&09         :\ 85CA= A2 09       ".
LDA &D0          :\ 85CC= A5 D0       %P
PHA              :\ 85CE= 48          H
LDA #&0E         :\ 85CF= A9 0E       ).
JSR OSWRCH       :\ 85D1= 20 EE FF     n.
JSR LEE72        :\ 85D4= 20 72 EE     rn
LDX #&18         :\ 85D7= A2 18       ".
JSR LEE72        :\ 85D9= 20 72 EE     rn
PLA              :\ 85DC= 68          h
BIT #&04         :\ 85DD= 89 04       ..
BNE L860D        :\ 85DF= D0 2C       P,
LDA #&0F         :\ 85E1= A9 0F       ).
JMP OSWRCH       :\ 85E3= 4C EE FF    Ln.
 
.L85E6
JSR LF2FF        :\ 85E6= 20 FF F2     .r
CMP #&26         :\ 85E9= C9 26       I&
BNE L860E        :\ 85EB= D0 21       P!
INY              :\ 85ED= C8          H
JSR L8648        :\ 85EE= 20 48 86     H.
BCC L8646        :\ 85F1= 90 53       .S
STA &E6          :\ 85F3= 85 E6       .f
JSR L8648        :\ 85F5= 20 48 86     H.
BCC L8608        :\ 85F8= 90 0E       ..
LDX #&04         :\ 85FA= A2 04       ".
.L85FC
ASL &E6          :\ 85FC= 06 E6       .f
DEX              :\ 85FE= CA          J
BNE L85FC        :\ 85FF= D0 FB       P{
TSB &E6          :\ 8601= 04 E6       .f
JSR L8648        :\ 8603= 20 48 86     H.
BCS L8631        :\ 8606= B0 29       0)
.L8608
LDX &E6          :\ 8608= A6 E6       &f
CMP #&0D         :\ 860A= C9 0D       I.
SEC              :\ 860C= 38          8
.L860D
RTS              :\ 860D= 60          `
 
.L860E
JSR L8634        :\ 860E= 20 34 86     4.
BCC L8646        :\ 8611= 90 33       .3
.L8613
STA &E6          :\ 8613= 85 E6       .f
JSR L8633        :\ 8615= 20 33 86     3.
BCC L8608        :\ 8618= 90 EE       .n
TAX              :\ 861A= AA          *
LDA &E6          :\ 861B= A5 E6       %f
ASL A            :\ 861D= 0A          .
BCS L8646        :\ 861E= B0 26       0&
ASL A            :\ 8620= 0A          .
BCS L8646        :\ 8621= B0 23       0#
ADC &E6          :\ 8623= 65 E6       ef
BCS L8646        :\ 8625= B0 1F       0.
ASL A            :\ 8627= 0A          .
BCS L8646        :\ 8628= B0 1C       0.
STA &E6          :\ 862A= 85 E6       .f
TXA              :\ 862C= 8A          .
ADC &E6          :\ 862D= 65 E6       ef
BCC L8613        :\ 862F= 90 E2       .b
.L8631
CLC              :\ 8631= 18          .
RTS              :\ 8632= 60          `
 
.L8633
INY              :\ 8633= C8          H
.L8634
LDA (&F2),Y      :\ 8634= B1 F2       1r
CMP #&3A         :\ 8636= C9 3A       I:
BCS L8646        :\ 8638= B0 0C       0.
CMP #&30         :\ 863A= C9 30       I0
BCC L8646        :\ 863C= 90 08       ..
AND #&0F         :\ 863E= 29 0F       ).
RTS              :\ 8640= 60          `
 
.L8641
JSR LF2FF        :\ 8641= 20 FF F2     .r
CMP #&0D         :\ 8644= C9 0D       I.
.L8646
CLC              :\ 8646= 18          .
RTS              :\ 8647= 60          `
 
.L8648
JSR L8634        :\ 8648= 20 34 86     4.
BCS L865A        :\ 864B= B0 0D       0.
AND #&DF         :\ 864D= 29 DF       )_
CMP #&47         :\ 864F= C9 47       IG
BCS L8641        :\ 8651= B0 EE       0n
.L8653
CMP #&41         :\ 8653= C9 41       IA
BCC L8641        :\ 8655= 90 EA       .j
EOR #&48         :\ 8657= 49 48       IH
INC A            :\ 8659= 1A          .
.L865A
INY              :\ 865A= C8          H
RTS              :\ 865B= 60          `
 
\ OSWORD 0 control block for *commands
\ ====================================
EQUW &DC00			; address
EQUB &F0			; max # chars
EQUB &20			; min ASCII char
EQUB &7E			; max ASCII char

.L8661
LDA #&8D         :\ 8661= A9 8D       ).
STA &0202        :\ 8663= 8D 02 02    ...
LDA #&86         :\ 8666= A9 86       ).
STA &0203        :\ 8668= 8D 03 02    ...
LDA #&1F         :\ 866B= A9 1F       ).
STA &028C        :\ 866D= 8D 8C 02    ...
.L8670
LDX #&FF         :\ 8670= A2 FF       ".
TXS              :\ 8672= 9A          .
CLI              :\ 8673= 58          X
JSR LEDBA        :\ 8674= 20 BA ED     :m
LDA #&2A         :\ 8677= A9 2A       )*
JSR OSWRCH       :\ 8679= 20 EE FF     n.
JSR L869D        :\ 867C= 20 9D 86     ..
BCC L8684        :\ 867F= 90 03       ..
JMP LA891        :\ 8681= 4C 91 A8    L.(
 
.L8684
LDX #&00         :\ 8684= A2 00       ".
LDY #&DC         :\ 8686= A0 DC        \
JSR OS_CLI       :\ 8688= 20 F7 FF     w.
BRA L8670        :\ 868B= 80 E3       .c
 
JSR OSNEWL       :\ 868D= 20 E7 FF     g.
LDY #&00         :\ 8690= A0 00        .
JSR LE7A7        :\ 8692= 20 A7 E7     'g
JSR OSNEWL       :\ 8695= 20 E7 FF     g.
BRA L8661        :\ 8698= 80 C7       .G
 
.L869A
JMP LFBED        :\ 869A= 4C ED FB    Lm{
 
.L869D
LDA #&00         :\ 869D= A9 00       ).
LDX #&5C         :\ 869F= A2 5C       "\
LDY #&86         :\ 86A1= A0 86        .
JMP OSWORD       :\ 86A3= 4C F1 FF    Lq.

.L86A6
JSR LF2FF        :\ 86A6= 20 FF F2     .r
BNE L869A        :\ 86A9= D0 EF       Po
LDY #&0F         :\ 86AB= A0 0F        .
.L86AD
INY              :\ 86AD= C8          H
JSR LA927        :\ 86AE= 20 27 A9     ')
EOR (&4F)        :\ 86B1= 52 4F       RO
EOR &0020        :\ 86B3= 4D 20 00    M .
TYA              :\ 86B6= 98          .
DEC A            :\ 86B7= 3A          :
PHA              :\ 86B8= 48          H
JSR LA873        :\ 86B9= 20 73 A8     s(
JSR L9F0C        :\ 86BC= 20 0C 9F     ..
LDA #&09         :\ 86BF= A9 09       ).
STA &F6          :\ 86C1= 85 F6       .v
LDA #&80         :\ 86C3= A9 80       ).
STA &F7          :\ 86C5= 85 F7       .w
PLX              :\ 86C7= FA          z
JSR LE587        :\ 86C8= 20 87 E5     .e
DEY              :\ 86CB= 88          .
BCC L8718        :\ 86CC= 90 4A       .J
.L86CE
JSR LF3FC        :\ 86CE= 20 FC F3     |s
CMP #&20         :\ 86D1= C9 20       I 
BCC L86E4        :\ 86D3= 90 0F       ..
CMP #&7F         :\ 86D5= C9 7F       I.
BCS L8718        :\ 86D7= B0 3F       0?
JSR OSWRCH       :\ 86D9= 20 EE FF     n.
INC &F6          :\ 86DC= E6 F6       fv
BIT &F6          :\ 86DE= 24 F6       $v
BVC L86CE        :\ 86E0= 50 EC       Pl
BRA L8718        :\ 86E2= 80 34       .4
 
.L86E4
TAX              :\ 86E4= AA          *
BNE L8718        :\ 86E5= D0 31       P1
LDA #&08         :\ 86E7= A9 08       ).
STA &F6          :\ 86E9= 85 F6       .v
LDA #&80         :\ 86EB= A9 80       ).
STA &F7          :\ 86ED= 85 F7       .w
JSR LF3FC        :\ 86EF= 20 FC F3     |s
JSR LA865        :\ 86F2= 20 65 A8     e(
.L86F5
PHY              :\ 86F5= 5A          Z
JSR LE9BB        :\ 86F6= 20 BB E9     ;i
STA &B0          :\ 86F9= 85 B0       .0
JSR L98B7        :\ 86FB= 20 B7 98     7.
AND &B0          :\ 86FE= 25 B0       %0
.L8700
BNE L8710        :\ 8700= D0 0E       P.
JSR LA958        :\ 8702= 20 58 A9     X)
EQUS " unplugged":EQUB 0
\JSR &6E75        :\ 8705= 20 75 6E     un
\BVS L8776        :\ 8708= 70 6C       pl
\ADC &67,X        :\ 870A= 75 67       ug
\EQUB &67         :\ 870C= 67          g
\ADC &64          :\ 870D= 65 64       ed
\BRK              :\ 870F= 00          .
.L8710
PLY              :\ 8710= 7A          z
JSR OSNEWL       :\ 8711= 20 E7 FF     g.
DEY              :\ 8714= 88          .
BPL L86AD        :\ 8715= 10 96       ..
RTS              :\ 8717= 60          `
 
.L8718
LDA #&3F         :\ 8718= A9 3F       )?
JSR OSWRCH       :\ 871A= 20 EE FF     n.
BRA L86F5        :\ 871D= 80 D6       .V

.L871F
SEC              :\ 871F= 38          8
BRA L8723        :\ 8720= 80 01       ..

.L8722
CLC              :\ 8722= 18          .
.L8723
PHP              :\ 8723= 08          .
JSR LF2FF        :\ 8724= 20 FF F2     .r
JSR L897D        :\ 8727= 20 7D 89     }.
TAY              :\ 872A= A8          (
JSR LE9BB        :\ 872B= 20 BB E9     ;i
PHA              :\ 872E= 48          H
JSR L98B7        :\ 872F= 20 B7 98     7.
STY &B0          :\ 8732= 84 B0       .0
PLA              :\ 8734= 68          h
PLP              :\ 8735= 28          (
BCC L873C        :\ 8736= 90 04       ..
ORA &B0          :\ 8738= 05 B0       .0
BRA L8740        :\ 873A= 80 04       ..
 
.L873C
EOR #&FF         :\ 873C= 49 FF       I.
AND &B0          :\ 873E= 25 B0       %0
.L8740
TAY              :\ 8740= A8          (
JMP L98E4        :\ 8741= 4C E4 98    Ld.
 
.L8744
STZ LDC00        :\ 8744= 9C 00 DC    ..\
LDX #LDC00 AND 255         :\ 8747= A2 00       ".
LDY #LDC00 DIV 256         :\ 8749= A0 DC        \
LDA #&0E         :\ 874B= A9 0E       ).
JSR OSWORD       :\ 874D= 20 F1 FF     q.
LDX #255-24         :\ 8750= A2 E7       "g
.L8752
LDA LDC00-(255-24),X      :\ 8752= BD 19 DB    =.[
JSR OSASCI       :\ 8755= 20 E3 FF     c.
INX              :\ 8758= E8          h
BNE L8752        :\ 8759= D0 F7       Pw
RTS              :\ 875B= 60          `
 
.L875C
ROL &4280        :\ 875C= 2E 80 42    ..B
EOR (&55,X)      :\ 875F= 41 55       AU
EQUB &44         :\ 8761= 44          D
STY &42          :\ 8762= 84 42       .B
EQUB &4F         :\ 8764= 4F          O
EQUB &4F         :\ 8765= 4F          O
EQUB &54         :\ 8766= 54          T
DEY              :\ 8767= 88          .
EQUB &43         :\ 8768= 43          C
EOR (&50,X)      :\ 8769= 41 50       AP
EQUB &53         :\ 876B= 53          S
STY &4144        :\ 876C= 8C 44 41    .DA
EQUB &54         :\ 876F= 54          T
EOR (&90,X)      :\ 8770= 41 90       A.
EQUB &44         :\ 8772= 44          D
EOR &4C          :\ 8773= 45 4C       EL
EOR (&59,X)      :\ 8775= 41 59       AY
STY &44,X        :\ 8777= 94 44       .D
EOR #&52         :\ 8779= 49 52       IR
TYA              :\ 877B= 98          .
EOR &58          :\ 877C= 45 58       EX
EQUB &54         :\ 877E= 54          T
EOR &42,X        :\ 877F= 55 42       UB
EOR &9C          :\ 8781= 45 9C       E.
LSR &44          :\ 8783= 46 44       FD
\EOR (&49)        :\ 8785= 52 49       RI
EQUS "R"
.L8786
EQUS "I"
.L8787
\LSR &45,X        :\ 8787= 56 45       VE
EQUS "V"
.L8788
EQUS "E"
.L8789
LDY #&46         :\ 8789= A0 46        F
EOR #&4C         :\ 878B= 49 4C       IL
EOR &A4          :\ 878D= 45 A4       E$
LSR &4C          :\ 878F= 46 4C       FL
EQUB &4F         :\ 8791= 4F          O
BVC L87E4        :\ 8792= 50 50       PP
EOR &48A8,Y      :\ 8794= 59 A8 48    Y(H
EOR (&52,X)      :\ 8797= 41 52       AR
EQUB &44         :\ 8799= 44          D
LDY &4749        :\ 879A= AC 49 47    ,IG
LSR &524F        :\ 879D= 4E 4F 52    NOR
EOR &B0          :\ 87A0= 45 B0       E0
EOR #&4E         :\ 87A2= 49 4E       IN
EQUB &54         :\ 87A4= 54          T
EOR &42,X        :\ 87A5= 55 42       UB
EOR &B4          :\ 87A7= 45 B4       E4
JMP &4E41        :\ 87A9= 4C 41 4E    LAN
 
EQUB &47         :\ 87AC= 47          G
CLV              :\ 87AD= B8          8
JMP &554F        :\ 87AE= 4C 4F 55    LOU
 
EQUB &44         :\ 87B1= 44          D
LDY &4F4D,X      :\ 87B2= BC 4D 4F    <MO
EQUB &44         :\ 87B5= 44          D
EOR &C0          :\ 87B6= 45 C0       E@
LSR &424F        :\ 87B8= 4E 4F 42    NOB
EQUB &4F         :\ 87BB= 4F          O
EQUB &4F         :\ 87BC= 4F          O
EQUB &54         :\ 87BD= 54          T
CPY &4E          :\ 87BE= C4 4E       DN
EQUB &4F         :\ 87C0= 4F          O
EQUB &43         :\ 87C1= 43          C
EOR (&50,X)      :\ 87C2= 41 50       AP
EQUB &53         :\ 87C4= 53          S
INY              :\ 87C5= C8          H
LSR &444F        :\ 87C6= 4E 4F 44    NOD
EOR #&52         :\ 87C9= 49 52       IR
CPY &4F4E        :\ 87CB= CC 4E 4F    LNO
EQUB &53         :\ 87CE= 53          S
EQUB &43         :\ 87CF= 43          C
EOR (&4F)        :\ 87D0= 52 4F       RO
EQUS "LLP"       :\ 87D2= 4C 4C D0    LLP
 
LSR &544F        :\ 87D5= 4E 4F 54    NOT
EOR &42,X        :\ 87D8= 55 42       UB
EOR &D4          :\ 87DA= 45 D4       ET
EQUS "PR"        :\ 87DC= 50 52       PR
EOR #&4E         :\ 87DE= 49 4E       IN
EQUB &54         :\ 87E0= 54          T
CLD              :\ 87E1= D8          X
EOR (&55),Y      :\ 87E2= 51 55       QU
.L87E4
EOR #&45         :\ 87E4= 49 45       IE
EQUB &54         :\ 87E6= 54          T
EQUB &DC         :\ 87E7= DC          \
EOR (&45)        :\ 87E8= 52 45       RE
BVC L8831        :\ 87EA= 50 45       PE
EOR (&54,X)      :\ 87EC= 41 54       AT
CPX #&53         :\ 87EE= E0 53       `S
EQUB &43         :\ 87F0= 43          C
EOR (&4F)        :\ 87F1= 52 4F       RO
JMP LE44C        :\ 87F3= 4C 4C E4    LLd
 
EQUB &53         :\ 87F6= 53          S
PHA              :\ 87F7= 48          H
.L87F8
EQUB &43         :\ 87F8= 43          C
EOR (&50,X)      :\ 87F9= 41 50       AP
EQUB &53         :\ 87FB= 53          S
INX              :\ 87FC= E8          h
EQUB &54         :\ 87FD= 54          T
EOR &42,X        :\ 87FE= 55 42       UB
.L8800
EOR &EC          :\ 8800= 45 EC       El
EQUB &54         :\ 8802= 54          T
LSR &F0,X        :\ 8803= 56 F0       Vp
BRK              :\ 8805= 00          .
EQUB &8B         :\ 8806= 8B          .
EQUB &EF         :\ 8807= EF          o
\STA L897E        :\ 8808= 8D 7E 89    .~.
EQUB &8D:EQUB &7E:EQUB &89
\BEQ L8798        :\ 880B= F0 8B       p.
EQUB &F0:EQUB &8B
JMP (&278A,X)    :\ 880D= 7C 8A 27    |.'
 
TXA              :\ 8810= 8A          .
CPX #&88         :\ 8811= E0 88       `.
EQUB &E7         :\ 8813= E7          g
TXA              :\ 8814= 8A          .
ADC &8A          :\ 8815= 65 8A       e.
ASL &8B,X        :\ 8817= 16 8B       ..
STA (&89,X)      :\ 8819= 81 89       ..
STZ &2D8B,X      :\ 881B= 9E 8B 2D    ..-
.L881E
DEY              :\ 881E= 88          .
\LDY LA98B,X      :\ 881F= BC 8B A9    <.)
EQUB &BC:EQUB &8B:EQUB &A9
TXA              :\ 8822= 8A          .
EQUB &43         :\ 8823= 43          C
TXA              :\ 8824= 8A          .
TSX              :\ 8825= BA          :
DEY              :\ 8826= 88          .
DEX              :\ 8827= CA          J
EQUB &8B         :\ 8828= 8B          .
STX &8A          :\ 8829= 86 8A       ..
LSR &0F8B,X      :\ 882B= 5E 8B 0F    ^..
DEY              :\ 882E= 88          .
\LDY &8B,X        :\ 882F= B4 8B       4.
EQUB &B4
.L8830
EQUB &B8
.L8831
\STA LAE88        :\ 8831= 8D 88 AE    ...
EQUB &8D
.L8832
EQUB &88
.L8833
EQUB &AE
.L8834
EQUB &8B         :\ 8834= 8B          .
.L8835
STA LB389        :\ 8835= 8D 89 B3    ..3
EQUB &8B         :\ 8838= 8B          .
EQUB &43         :\ 8839= 43          C
TXA              :\ 883A= 8A          .
EOR #&8A         :\ 883B= 49 8A       I.
.L883D
TSX              :\ 883D= BA          :
.L883E
TXA              :\ 883E= 8A          .
.L883F
EOR (&8B),Y      :\ 883F= 51 8B       Q.
.L8841
EQUB &07         :\ 8841= 07          .
.L8842
TXA              :\ 8842= 8A          .
.L8843
\ASL L9E8A        :\ 8843= 0E 8A 9E    ...
EQUB &0E:EQUB &8A:EQUB &9E
.L8846
DEY              :\ 8846= 88          .
.L8847
EQUB &EF         :\ 8847= EF          o
.L8848
EQUB &8B         :\ 8848= 8B          .
.L8849
BIT &8A          :\ 8849= 24 8A       $.
\AND LE08A        :\ 884B= 2D 8A E0    -.`
EQUB &2D:EQUB &8A:EQUB &E0
DEY              :\ 884E= 88          .
EQUB &DB         :\ 884F= DB          [
TXA              :\ 8850= 8A          .
ADC &88          :\ 8851= 65 88       e.
EQUB &C2         :\ 8853= C2          B
EQUB &8B         :\ 8854= 8B          .
LDA #&8A         :\ 8855= A9 8A       ).
EQUB &3B         :\ 8857= 3B          ;
TXA              :\ 8858= 8A          .
DEY              :\ 8859= 88          .
BIT #&E3         :\ 885A= 89 E3       .c
TXA              :\ 885C= 8A          .
EQUB &F4         :\ 885D= F4          t
BIT #&C6         :\ 885E= 89 C6       .F
EQUB &8B         :\ 8860= 8B          .
EQUB &77         :\ 8861= 77          w
TXA              :\ 8862= 8A          .
PHP              :\ 8863= 08          .
TXA              :\ 8864= 8A          .
\STZ LA089,X      :\ 8865= 9E 89 A0    ..
EQUB &9E:EQUB &89:EQUB &A0
EQUB &8B         :\ 8868= 8B          .
EQUB &33         :\ 8869= 33          3
TXA              :\ 886A= 8A          .
AND &8A,X        :\ 886B= 35 8A       5.
DEY              :\ 886D= 88          .
DEY              :\ 886E= 88          .
SBC (&8A,X)      :\ 886F= E1 8A       a.
ADC &89          :\ 8871= 65 89       e.
SBC LF48A        :\ 8873= ED 8A F4    m.t
BIT #&05         :\ 8876= 89 05       ..
EQUB &8B         :\ 8878= 8B          .
ASL &20,X        :\ 8879= 16

.L887A
JSR L8934        :\ 887A 20 34 89
BCS L8889        :\ 887D= B0 0A       0.
LDX #&28         :\ 887F= A2 28       "(
.L8881
LDY &E6          :\ 8881= A4 E6       $f
JSR LEE72        :\ 8883= 20 72 EE     rn
BNE L88AC        :\ 8886= D0 24       P$
RTS              :\ 8888= 60          `
 
.L8889
TAX              :\ 8889= AA          *
LDA L8786,X      :\ 888A= BD 86 87    =..
PHA              :\ 888D= 48          H
LDA L8787,X      :\ 888E= BD 87 87    =..
PHA              :\ 8891= 48          H
.L8892
JMP LF2FF        :\ 8892= 4C FF F2    L.r

.L8895
JSR L8934        :\ 8895= 20 34 89     4.
BCS L889E        :\ 8898= B0 04       0.
LDX #&29         :\ 889A= A2 29       ")
BRA L8881        :\ 889C= 80 E3       .c
 
.L889E
TAX              :\ 889E= AA          *
LDA L8788,X      :\ 889F= BD 88 87    =..
PHA              :\ 88A2= 48          H
LDA L8789,X      :\ 88A3= BD 89 87    =..
PHA              :\ 88A6= 48          H
JSR LF2FF        :\ 88A7= 20 FF F2     .r
BEQ L8892        :\ 88AA= F0 E6       pf
.L88AC
JMP L8976        :\ 88AC= 4C 76 89    Lv.
 
BNE L88AC        :\ 88AF= D0 FB       P{
LDA #&00         :\ 88B1= A9 00       ).
BRA L88B9        :\ 88B3= 80 04       ..
 
BNE L88AC        :\ 88B5= D0 F5       Pu
LDA #&80         :\ 88B7= A9 80       ).
.L88B9
LDY #&7F         :\ 88B9= A0 7F        .
BRA L88D8        :\ 88BB= 80 1B       ..
 
BNE L88AC        :\ 88BD= D0 ED       Pm
LDA #&00         :\ 88BF= A9 00       ).
BRA L88C7        :\ 88C1= 80 04       ..
 
BNE L88AC        :\ 88C3= D0 E7       Pg
LDA #&40         :\ 88C5= A9 40       )@
.L88C7
LDY #&BF         :\ 88C7= A0 BF        ?
BRA L88D8        :\ 88C9= 80 0D       ..
 
JSR L8971        :\ 88CB= 20 71 89     q.
JSR L8987        :\ 88CE= 20 87 89     ..
TXA              :\ 88D1= 8A          .
CMP #&08         :\ 88D2= C9 08       I.
BCS L88AC        :\ 88D4= B0 D6       0V
LDY #&F8         :\ 88D6= A0 F8        x
.L88D8
LDX #&19         :\ 88D8= A2 19       ".
BRA L892D        :\ 88DA= 80 51       .Q
 
BNE L88AC        :\ 88DC= D0 CE       PN
LDA #&10         :\ 88DE= A9 10       ).
BRA L88EC        :\ 88E0= 80 0A       ..
 
BNE L88AC        :\ 88E2= D0 C8       PH
LDA #&08         :\ 88E4= A9 08       ).
BRA L88EC        :\ 88E6= 80 04       ..
 
BNE L88AC        :\ 88E8= D0 C2       PB
LDA #&20         :\ 88EA= A9 20       ) 
.L88EC
LDY #&C7         :\ 88EC= A0 C7        G
BRA L88D8        :\ 88EE= 80 E8       .h
 
JSR L8971        :\ 88F0= 20 71 89     q.
JSR L8987        :\ 88F3= 20 87 89     ..
TXA              :\ 88F6= 8A          .
AND #&7F         :\ 88F7= 29 7F       ).
CMP #&08         :\ 88F9= C9 08       I.
BCS L8911        :\ 88FB= B0 14       0.
INX              :\ 88FD= E8          h
BPL L8902        :\ 88FE= 10 02       ..
ORA #&08         :\ 8900= 09 08       ..
.L8902
LDY #&F0         :\ 8902= A0 F0        p
BRA L892B        :\ 8904= 80 25       .%
 
BEQ L8930        :\ 8906= F0 28       p(
JSR L8971        :\ 8908= 20 71 89     q.
CPX #&FC         :\ 890B= E0 FC       `|
BCS L8913        :\ 890D= B0 04       0.
CPX #&04         :\ 890F= E0 04       `.
.L8911
BCS L8976        :\ 8911= B0 63       0c
.L8913
TXA              :\ 8913= 8A          .
ASL A            :\ 8914= 0A          .
STA &B1          :\ 8915= 85 B1       .1
LDX #&00         :\ 8917= A2 00       ".
JSR LF30A        :\ 8919= 20 0A F3     .s
BEQ L8922        :\ 891C= F0 04       p.
JSR L898F        :\ 891E= 20 8F 89     ..
TAX              :\ 8921= AA          *
.L8922
TXA              :\ 8922= 8A          .
ORA &B1          :\ 8923= 05 B1       .1
ASL A            :\ 8925= 0A          .
ASL A            :\ 8926= 0A          .
ASL A            :\ 8927= 0A          .
ASL A            :\ 8928= 0A          .
.L8929
LDY #&0F         :\ 8929= A0 0F        .
.L892B
LDX #&18         :\ 892B= A2 18       ".
.L892D
JMP L89D6        :\ 892D= 4C D6 89    LV.
 
.L8930
LDA #&00         :\ 8930= A9 00       ).
BRA L8929        :\ 8932= 80 F5       .u
 
.L8934
JSR LF2FF        :\ 8934= 20 FF F2     .r
STY &E6          :\ 8937= 84 E6       .f
BEQ L8979        :\ 8939= F0 3E       p>
LDX #&00         :\ 893B= A2 00       ".
BRA L894A        :\ 893D= 80 0B       ..
 
.L893F
EOR L875C,X      :\ 893F= 5D 5C 87    ]\.
AND #&DF         :\ 8942= 29 DF       )_
BNE L895C        :\ 8944= D0 16       P.
INY              :\ 8946= C8          H
.L8947
BCS L896C        :\ 8947= B0 23       0#
INX              :\ 8949= E8          h
.L894A
LDA (&F2),Y      :\ 894A= B1 F2       1r
JSR LEA71        :\ 894C= 20 71 EA     qj
BCC L893F        :\ 894F= 90 EE       .n
.L8951
LDA L875C,X      :\ 8951= BD 5C 87    =\.
BMI L896C        :\ 8954= 30 16       0.
LDA (&F2),Y      :\ 8956= B1 F2       1r
CMP #&2E         :\ 8958= C9 2E       I.
BEQ L8960        :\ 895A= F0 04       p.
.L895C
CLC              :\ 895C= 18          .
LDY &E6          :\ 895D= A4 E6       $f
DEY              :\ 895F= 88          .
.L8960
INY              :\ 8960= C8          H
DEX              :\ 8961= CA          J
.L8962
INX              :\ 8962= E8          h
LDA L875C,X      :\ 8963= BD 5C 87    =\.
BEQ L896E        :\ 8966= F0 06       p.
BPL L8962        :\ 8968= 10 F8       .x
BRA L8947        :\ 896A= 80 DB       .[
 
.L896C
SEC              :\ 896C= 38          8
RTS              :\ 896D= 60          `
 
.L896E
BCS L896C        :\ 896E= B0 FC       0|
.L8970
RTS              :\ 8970= 60          `
 
.L8971
JSR L85E6        :\ 8971= 20 E6 85     f.
BCS L8970        :\ 8974= B0 FA       0z
.L8976
JMP LFBED        :\ 8976= 4C ED FB    Lm{
 
.L8979
LDX #&01         :\ 8979= A2 01       ".
BRA L8951        :\ 897B= 80 D4       .T
 
.L897D
JSR L85E6        :\ 897D= 20 E6 85     f.
BCC L8976        :\ 8980= 90 F4       .t
TXA              :\ 8982= 8A          .
CMP #&10         :\ 8983= C9 10       I.
BCS L8976        :\ 8985= B0 EF       0o
.L8987
PHA              :\ 8987= 48          H
JSR LF2FF        :\ 8988= 20 FF F2     .r
.L898B
BNE L8976        :\ 898B= D0 E9       Pi
PLA              :\ 898D= 68          h
RTS              :\ 898E= 60          `
 
.L898F
JSR L8997        :\ 898F= 20 97 89     ..
CMP #&02         :\ 8992= C9 02       I.
BCS L8976        :\ 8994= B0 E0       0`
RTS              :\ 8996= 60          `
 
.L8997
JSR L85E6        :\ 8997= 20 E6 85     f.
BCC L8976        :\ 899A= 90 DA       .Z
TXA              :\ 899C= 8A          .
BRA L8987        :\ 899D= 80 E8       .h
 
CLC              :\ 899F= 18          .
BIT &38          :\ 89A0= 24 38       $8
PHP              :\ 89A2= 08          .
JSR L8971        :\ 89A3= 20 71 89     q.
JSR L8987        :\ 89A6= 20 87 89     ..
PLP              :\ 89A9= 28          (
TXA              :\ 89AA= 8A          .
TAY              :\ 89AB= A8          (
LDA #&1A         :\ 89AC= A9 1A       ).
ADC #&00         :\ 89AE= 69 00       i.
TAX              :\ 89B0= AA          *
.L89B1
JMP L98E4        :\ 89B1= 4C E4 98    Ld.
 
BEQ L8A03        :\ 89B4= F0 4D       pM
JSR L8971        :\ 89B6= 20 71 89     q.
PHX              :\ 89B9= DA          Z
JSR L8987        :\ 89BA= 20 87 89     ..
LDA #&00         :\ 89BD= A9 00       ).
JSR L8A05        :\ 89BF= 20 05 8A     ..
PLY              :\ 89C2= 7A          z
LDX #&1C         :\ 89C3= A2 1C       ".
BRA L89B1        :\ 89C5= 80 EA       .j
 
JSR L8997        :\ 89C7= 20 97 89     ..
CMP #&05         :\ 89CA= C9 05       I.
.L89CC
BCS L8976        :\ 89CC= B0 A8       0(
LDY #&1F         :\ 89CE= A0 1F        .
LSR A            :\ 89D0= 4A          J
ROR A            :\ 89D1= 6A          j
ROR A            :\ 89D2= 6A          j
ROR A            :\ 89D3= 6A          j
.L89D4
LDX #&1D         :\ 89D4= A2 1D       ".
.L89D6
STA &B1          :\ 89D6= 85 B1       .1
STY &B2          :\ 89D8= 84 B2       .2
JSR L98B7        :\ 89DA= 20 B7 98     7.
AND &B2          :\ 89DD= 25 B2       %2
ORA &B1          :\ 89DF= 05 B1       .1
TAY              :\ 89E1= A8          (
BRA L89B1        :\ 89E2= 80 CD       .M
 
CLC              :\ 89E4= 18          .
.L89E5
BNE L898B        :\ 89E5= D0 A4       P$
LDY #&FE         :\ 89E7= A0 FE        ~
LDA #&00         :\ 89E9= A9 00       ).
ROL A            :\ 89EB= 2A          *
BRA L89D4        :\ 89EC= 80 E6       .f
 
SEC              :\ 89EE= 38          8
BRA L89E5        :\ 89EF= 80 F4       .t
 
JSR L8997        :\ 89F1= 20 97 89     ..
BNE L89F8        :\ 89F4= D0 02       P.
LDA #&07         :\ 89F6= A9 07       ).
.L89F8
CMP #&09         :\ 89F8= C9 09       I.
BCS L89CC        :\ 89FA= B0 D0       0P
DEC A            :\ 89FC= 3A          :
LDY #&E3         :\ 89FD= A0 E3        c
ASL A            :\ 89FF= 0A          .
ASL A            :\ 8A00= 0A          .
BRA L89D4        :\ 8A01= 80 D1       .Q
 
.L8A03
LDA #&02         :\ 8A03= A9 02       ).
.L8A05
LDY #&FD         :\ 8A05= A0 FD        }
BRA L89D4        :\ 8A07= 80 CB       .K
 
BNE L89E5        :\ 8A09= D0 DA       PZ
LDA #&00         :\ 8A0B= A9 00       ).
BRA L8A13        :\ 8A0D= 80 04       ..
 
BNE L89E5        :\ 8A0F= D0 D4       PT
LDA #&02         :\ 8A11= A9 02       ).
.L8A13
LDY #&FD         :\ 8A13= A0 FD        }
BRA L8A24        :\ 8A15= 80 0D       ..
 
JSR L8997        :\ 8A17= 20 97 89     ..
CMP #&08         :\ 8A1A= C9 08       I.
BCS L89CC        :\ 8A1C= B0 AE       0.
LDY #&1F         :\ 8A1E= A0 1F        .
LSR A            :\ 8A20= 4A          J
ROR A            :\ 8A21= 6A          j
ROR A            :\ 8A22= 6A          j
ROR A            :\ 8A23= 6A          j
.L8A24
LDX #&1E         :\ 8A24= A2 1E       ".
.L8A26
BRA L89D6        :\ 8A26= 80 AE       ..
 
BNE L89E5        :\ 8A28= D0 BB       P;
LDA #&10         :\ 8A2A= A9 10       ).
BRA L8A32        :\ 8A2C= 80 04       ..
 
BNE L89E5        :\ 8A2E= D0 B5       P5
LDA #&00         :\ 8A30= A9 00       ).
.L8A32
LDY #&EF         :\ 8A32= A0 EF        o
BRA L8A24        :\ 8A34= 80 EE       .n
 
BNE L89E5        :\ 8A36= D0 AD       P-
LDA #&00         :\ 8A38= A9 00       ).
BRA L8A40        :\ 8A3A= 80 04       ..
 
BNE L89E5        :\ 8A3C= D0 A7       P'
LDA #&08         :\ 8A3E= A9 08       ).
.L8A40
LDY #&F7         :\ 8A40= A0 F7        w
BRA L8A24        :\ 8A42= 80 E0       .`
 
BNE L89CC        :\ 8A44= D0 86       P.
LDA #&04         :\ 8A46= A9 04       ).
BRA L8A4E        :\ 8A48= 80 04       ..
 
BNE L89CC        :\ 8A4A= D0 80       P.
LDA #&00         :\ 8A4C= A9 00       ).
.L8A4E
LDY #&FB         :\ 8A4E= A0 FB        {
BRA L8A24        :\ 8A50= 80 D2       .R
 
JSR L897D        :\ 8A52= 20 7D 89     }.
ASL A            :\ 8A55= 0A          .
ASL A            :\ 8A56= 0A          .
ASL A            :\ 8A57= 0A          .
ASL A            :\ 8A58= 0A          .
LDY #&0F         :\ 8A59= A0 0F        .
.L8A5B
LDX #&13         :\ 8A5B= A2 13       ".
BRA L8A26        :\ 8A5D= 80 C7       .G
 
JSR L897D        :\ 8A5F= 20 7D 89     }.
LDY #&F0         :\ 8A62= A0 F0        p
BRA L8A5B        :\ 8A64= 80 F5       .u
 
.L8A66
JSR L8EAD        :\ 8A66= 20 AD 8E     -.
ASL A            :\ 8A69= 0A          .
ASL A            :\ 8A6A= 0A          .
BMI L8A7A        :\ 8A6B= 30 0D       0.
ASL A            :\ 8A6D= 0A          .
BMI L8A84        :\ 8A6E= 30 14       0.
JSR LA958        :\ 8A70= 20 58 A9     X)
EQUB &53         :\ 8A73= 53          S
PLA              :\ 8A74= 68          h
ADC #&66         :\ 8A75= 69 66       if
STZ &20,X        :\ 8A77= 74 20       t 
BRK              :\ 8A79= 00          .
.L8A7A
JSR LA958        :\ 8A7A= 20 58 A9     X)
EQUB &43         :\ 8A7D= 43          C
ADC (&70,X)      :\ 8A7E= 61 70       ap
EQUB &73         :\ 8A80= 73          s
ORA &6000        :\ 8A81= 0D 00 60    ..`
.L8A84
JSR L8EB1        :\ 8A84= 20 B1 8E     1.
BRA L8A7A        :\ 8A87= 80 F1       .q
 
.L8A89
JSR L98AE        :\ 8A89= 20 AE 98     ..
BIT #&08         :\ 8A8C= 89 08       ..
BEQ L8A93        :\ 8A8E= F0 03       p.
JSR L8EB1        :\ 8A90= 20 B1 8E     1.
.L8A93
JSR LA958        :\ 8A93= 20 58 A9     X)
EQUB &53         :\ 8A96= 53          S
EQUB &63         :\ 8A97= 63          c
ADC (&6F)        :\ 8A98= 72 6F       ro
JMP (&0D6C)      :\ 8A9A= 6C 6C 0D    ll.
 
BRK              :\ 8A9D= 00          .
RTS              :\ 8A9E= 60          `
 
.L8A9F
JSR L98AE        :\ 8A9F= 20 AE 98     ..
BIT #&02         :\ 8AA2= 89 02       ..
BNE L8AB1        :\ 8AA4= D0 0B       P.
JSR LA958        :\ 8AA6= 20 58 A9     X)
EOR (&75),Y      :\ 8AA9= 51 75       Qu
ADC #&65         :\ 8AAB= 69 65       ie
STZ &0D,X        :\ 8AAD= 74 0D       t.
BRK              :\ 8AAF= 00          .
RTS              :\ 8AB0= 60          `
 
.L8AB1
JSR LA958        :\ 8AB1= 20 58 A9     X)
JMP &756F        :\ 8AB4= 4C 6F 75    Lou
 
STZ &0D          :\ 8AB7= 64 0D       d.
BRK              :\ 8AB9= 00          .
RTS              :\ 8ABA= 60          `
 
.L8ABB
JSR L98AE        :\ 8ABB= 20 AE 98     ..
BIT #&04         :\ 8ABE= 89 04       ..
BNE L8ACA        :\ 8AC0= D0 08       P.
JSR LA958        :\ 8AC2= 20 58 A9     X)
EOR #&6E         :\ 8AC5= 49 6E       In
BRK              :\ 8AC7= 00          .
BRA L8AD0        :\ 8AC8= 80 06       ..
 
.L8ACA
JSR LA958        :\ 8ACA= 20 58 A9     X)
EOR &78          :\ 8ACD= 45 78       Ex
BRK              :\ 8ACF= 00          .
.L8AD0
JSR LA958        :\ 8AD0= 20 58 A9     X)
STZ &65,X        :\ 8AD3= 74 65       te
ADC (&6E)        :\ 8AD5= 72 6E       rn
ADC (&6C,X)      :\ 8AD7= 61 6C       al
JSR &7554        :\ 8AD9= 20 54 75     Tu
EQUB &62         :\ 8ADC= 62          b
ADC &0D          :\ 8ADD= 65 0D       e.
BRK              :\ 8ADF= 00          .
RTS              :\ 8AE0= 60          `
 
.L8AE1
JSR L98AE        :\ 8AE1= 20 AE 98     ..
BIT #&10         :\ 8AE4= 89 10       ..
BNE L8AEB        :\ 8AE6= D0 03       P.
JSR L8EB1        :\ 8AE8= 20 B1 8E     1.
.L8AEB
JSR LA958        :\ 8AEB= 20 58 A9     X)
EQUB &42         :\ 8AEE= 42          B
EQUB &6F         :\ 8AEF= 6F          o
EQUB &6F         :\ 8AF0= 6F          o
STZ &0D,X        :\ 8AF1= 74 0D       t.
BRK              :\ 8AF3= 00          .
RTS              :\ 8AF4= 60          `
 
.L8AF5
JSR L98AA        :\ 8AF5= 20 AA 98     *.
LSR A            :\ 8AF8= 4A          J
BCS L8AFE        :\ 8AF9= B0 03       0.
JSR L8EB1        :\ 8AFB= 20 B1 8E     1.
.L8AFE
JSR LA958        :\ 8AFE= 20 58 A9     X)
EQUB &54         :\ 8B01= 54          T
ADC &62,X        :\ 8B02= 75 62       ub
ADC &0D          :\ 8B04= 65 0D       e.
BRK              :\ 8B06= 00          .
RTS              :\ 8B07= 60          `
 
.L8B08
JSR L8E9C        :\ 8B08= 20 9C 8E     ..
.L8B0B
JSR L8BC4        :\ 8B0B= 20 C4 8B     D.
BRA L8B2B        :\ 8B0E= 80 1B       ..

.L8B10
JSR L8EA4        :\ 8B10= 20 A4 8E     $.
AND #&0F         :\ 8B13= 29 0F       ).
BRA L8B0B        :\ 8B15= 80 F4       .t
 
.L8B17
JSR L8E5A        :\ 8B17= 20 5A 8E     Z.
JSR L8BC3        :\ 8B1A= 20 C3 8B     C.
LDA #&2C         :\ 8B1D= A9 2C       ),
JSR OSWRCH       :\ 8B1F= 20 EE FF     n.
TXA              :\ 8B22= 8A          .
BRA L8B28        :\ 8B23= 80 03       ..
 
JSR L8E76        :\ 8B25= 20 76 8E     v. Read configured MODE
.L8B28
JSR L8BC4        :\ 8B28= 20 C4 8B     D.
.L8B2B
JMP OSNEWL       :\ 8B2B= 4C E7 FF    Lg.
 
JSR L8B3A        :\ 8B2E= 20 3A 8B     :.
TYA              :\ 8B31= 98          .
BRA L8B28        :\ 8B32= 80 F4       .t
 
.L8B34
JSR L8B3F        :\ 8B34= 20 3F 8B     ?.
TYA              :\ 8B37= 98          .
BRA L8B28        :\ 8B38= 80 EE       .n
 
.L8B3A
LDX #&1A         :\ 8B3A= A2 1A       ".
JMP L98B7        :\ 8B3C= 4C B7 98    L7.
 
.L8B3F
LDX #&1B         :\ 8B3F= A2 1B       ".
JMP L98B7        :\ 8B41= 4C B7 98    L7.
 
JSR L98AA        :\ 8B44= 20 AA 98     *.
BIT #&02         :\ 8B47= 89 02       ..
BEQ L8B5A        :\ 8B49= F0 0F       p.
.L8B4B
JSR L8EB1        :\ 8B4B= 20 B1 8E     1.
JSR LA958        :\ 8B4E= 20 58 A9     X)
EOR #&67         :\ 8B51= 49 67       Ig
ROR &726F        :\ 8B53= 6E 6F 72    nor
ADC &0D          :\ 8B56= 65 0D       e.
BRK              :\ 8B58= 00          .
RTS              :\ 8B59= 60          `
 
.L8B5A
JSR L8EA8        :\ 8B5A= 20 A8 8E     (.
JSR L8BC4        :\ 8B5D= 20 C4 8B     D.
BRA L8B2B        :\ 8B60= 80 C9       .I
 
.L8B62
JSR L98AA        :\ 8B62= 20 AA 98     *.
BIT #&02         :\ 8B65= 89 02       ..
BNE L8B4B        :\ 8B67= D0 E2       Pb
JSR LA958        :\ 8B69= 20 58 A9     X)
EOR #&67         :\ 8B6C= 49 67       Ig
ROR &726F        :\ 8B6E= 6E 6F 72    nor
ADC &20          :\ 8B71= 65 20       e 
JSR &0020        :\ 8B73= 20 20 00      .
BRA L8B5A        :\ 8B76= 80 E2       .b
 
.L8B78
JSR L8E8D        :\ 8B78= 20 8D 8E     ..
BRA L8B28        :\ 8B7B= 80 AB       .+
 
.L8B7D
JSR L8E84        :\ 8B7D= 20 84 8E     ..
BRA L8B28        :\ 8B80= 80 A6       .&
 
JSR L8E97        :\ 8B82= 20 97 8E     ..
BRA L8B28        :\ 8B85= 80 A1       .!
 
.L8B87
JSR L8EAD        :\ 8B87= 20 AD 8E     -.
AND #&07         :\ 8B8A= 29 07       ).
BRA L8B28        :\ 8B8C= 80 9A       ..
 
.L8B8E
JSR L8EAD        :\ 8B8E= 20 AD 8E     -.
ASL A            :\ 8B91= 0A          .
BCS L8B9E        :\ 8B92= B0 0A       0.
JSR LA958        :\ 8B94= 20 58 A9     X)
PHA              :\ 8B97= 48          H
ADC (&72,X)      :\ 8B98= 61 72       ar
STZ &0D          :\ 8B9A= 64 0D       d.
BRK              :\ 8B9C= 00          .
RTS              :\ 8B9D= 60          `
 
.L8B9E
JSR LA958        :\ 8B9E= 20 58 A9     X)
; LSR &6C          :\ 8BA1= 46 6C       Fl
; EQUB &6F         :\ 8BA3= 6F          o
; BVS L8C16        :\ 8BA4= 70 70       pp
; ADC &000D,Y      :\ 8BA6= 79 0D 00    y..
EQUS "Floppy":EQUB 0
RTS              :\ 8BA9= 60          `
 
JSR L8EAD        :\ 8BAA= 20 AD 8E     -.
ASL A            :\ 8BAD= 0A          .
ASL A            :\ 8BAE= 0A          .
BCC L8BB4        :\ 8BAF= 90 03       ..
JSR L8EB1        :\ 8BB1= 20 B1 8E     1.
.L8BB4
JSR LA958        :\ 8BB4= 20 58 A9     X)
EQUB &44         :\ 8BB7= 44          D
ADC #&72         :\ 8BB8= 69 72       ir
ADC &63          :\ 8BBA= 65 63       ec
STZ &6F,X        :\ 8BBC= 74 6F       to
ADC (&79)        :\ 8BBE= 72 79       ry
ORA &6000        :\ 8BC0= 0D 00 60    ..`
.L8BC3
TYA              :\ 8BC3= 98          .
.L8BC4
SEC              :\ 8BC4= 38          8
LDY #&FF         :\ 8BC5= A0 FF        .
PHP              :\ 8BC7= 08          .
.L8BC8
INY              :\ 8BC8= C8          H
SBC #&64         :\ 8BC9= E9 64       id
BCS L8BC8        :\ 8BCB= B0 FB       0{
ADC #&64         :\ 8BCD= 69 64       id
PLP              :\ 8BCF= 28          (
JSR L8BE4        :\ 8BD0= 20 E4 8B     d.
LDY #&FF         :\ 8BD3= A0 FF        .
PHP              :\ 8BD5= 08          .
SEC              :\ 8BD6= 38          8
.L8BD7
INY              :\ 8BD7= C8          H
SBC #&0A         :\ 8BD8= E9 0A       i.
BCS L8BD7        :\ 8BDA= B0 FB       0{
ADC #&0A         :\ 8BDC= 69 0A       i.
PLP              :\ 8BDE= 28          (
JSR L8BE4        :\ 8BDF= 20 E4 8B     d.
CLC              :\ 8BE2= 18          .
TAY              :\ 8BE3= A8          (
.L8BE4
PHA              :\ 8BE4= 48          H
TYA              :\ 8BE5= 98          .
BNE L8BEA        :\ 8BE6= D0 02       P.
BCS L8BEE        :\ 8BE8= B0 04       0.
.L8BEA
JSR LA873        :\ 8BEA= 20 73 A8     s(
CLC              :\ 8BED= 18          .
.L8BEE
PLA              :\ 8BEE= 68          h
RTS              :\ 8BEF= 60          `
 
JSR L8987        :\ 8BF0= 20 87 89     ..
PHY              :\ 8BF3= 5A          Z
JSR LA958        :\ 8BF4= 20 58 A9     X)
EQUS "Configuration options:":EQUB &0D
EQUS "Baud     <D>":EQUB &0D
EQUS "Boot":EQUB &0D
EQUS "Caps":EQUB &0D
EQUS "Data     <D>":EQUB &0D
EQUS "Delay    <D>":EQUB &0D
EQUS "Dir":EQUB &0D
EQUS "ExTube":EQUB &0D
EQUS "FDrive   <D>",13
EQUS "File    <D>",13
EQUS "Floppy",13
EQUS "Hard",13
EQUS "Ignore   [<D>]",13
EQUS "InTube",13
EQUS "Lang     <D>",13
EQUS "Loud",13
EQUS "Mode     <D>",13
EQUS "NoBoot",13
EQUS "NoCAps",13
EQUS "NoDir",13
EQUS "NoScroll",13
EQUS "NoTube",13
EQUS "Print   <D>",13
EQUS "Quiet",13
EQUS "Repeat   <D>",13
EQUS "Scroll",13
EQUS "ShCaps",13
EQUS "Tube",13
EQUS "TV      [<D>[,<D>]]",13
EQUB 0
PLY 		 :\ 8D12= 7A
LDX #&28         :\ 8D13= A2 28       "(
JSR LEE72        :\ 8D15= 20 72 EE     rn
JSR LA958        :\ 8D18= 20 58 A9     X)
EQUB &57         :\ 8D1B= 57          W
PLA              :\ 8D1C= 68          h
ADC &72          :\ 8D1D= 65 72       er
ADC &3A          :\ 8D1F= 65 3A       e:
ORA &2044        :\ 8D21= 0D 44 20    .D 
ADC #&73         :\ 8D24= 69 73       is
JSR &2061        :\ 8D26= 20 61 20     a 
STZ &65          :\ 8D29= 64 65       de
EQUB &63         :\ 8D2B= 63          c
ADC #&6D         :\ 8D2C= 69 6D       im
ADC (&6C,X)      :\ 8D2E= 61 6C       al
JSR &756E        :\ 8D30= 20 6E 75     nu
ADC &6562        :\ 8D33= 6D 62 65    mbe
ADC (&2C)        :\ 8D36= 72 2C       r,
JSR &726F        :\ 8D38= 20 6F 72     or
ORA &2061        :\ 8D3B= 0D 61 20    .a 
PLA              :\ 8D3E= 68          h
ADC &78          :\ 8D3F= 65 78       ex
ADC (&64,X)      :\ 8D41= 61 64       ad
ADC &63          :\ 8D43= 65 63       ec
.L8D45
ADC #&6D         :\ 8D45= 69 6D       im
ADC (&6C,X)      :\ 8D47= 61 6C       al
JSR &756E        :\ 8D49= 20 6E 75     nu
ADC &6562        :\ 8D4C= 6D 62 65    mbe
ADC (&20)        :\ 8D4F= 72 20       r 
BVS L8DC5        :\ 8D51= 70 72       pr
ADC &63          :\ 8D53= 65 63       ec
ADC &64          :\ 8D55= 65 64       ed
ADC &64          :\ 8D57= 65 64       ed
JSR &7962        :\ 8D59= 20 62 79     by
JSR &0D26        :\ 8D5C= 20 26 0D     &.
EOR #&74         :\ 8D5F= 49 74       It
ADC &6D          :\ 8D61= 65 6D       em
EQUB &73         :\ 8D63= 73          s
JSR &6977        :\ 8D64= 20 77 69     wi
STZ &68,X        :\ 8D67= 74 68       th
ADC #&6E         :\ 8D69= 69 6E       in
JSR &205B        :\ 8D6B= 20 5B 20     [ 
EOR &6120,X      :\ 8D6E= 5D 20 61    ] a
ADC (&65)        :\ 8D71= 72 65       re
JSR &706F        :\ 8D73= 20 6F 70     op
STZ &69,X        :\ 8D76= 74 69       ti
EQUB &6F         :\ 8D78= 6F          o
ROR &6C61        :\ 8D79= 6E 61 6C    nal
ORA &6000        :\ 8D7C= 0D 00 60    ..`
JSR L8987        :\ 8D7F= 20 87 89     ..
PHY              :\ 8D82= 5A          Z
JSR LA958        :\ 8D83= 20 58 A9     X)
EQUB &43         :\ 8D86= 43          C
EQUB &6F         :\ 8D87= 6F          o
ROR &6966        :\ 8D88= 6E 66 69    nfi
EQUB &67         :\ 8D8B= 67          g
ADC &72,X        :\ 8D8C= 75 72       ur
ADC (&74,X)      :\ 8D8E= 61 74       at
ADC #&6F         :\ 8D90= 69 6F       io
ROR &7320        :\ 8D92= 6E 20 73    n s
STZ &61,X        :\ 8D95= 74 61       ta
STZ &75,X        :\ 8D97= 74 75       tu
EQUB &73         :\ 8D99= 73          s
DEC A            :\ 8D9A= 3A          :
ORA &6142        :\ 8D9B= 0D 42 61    .Ba
ADC &64,X        :\ 8D9E= 75 64       ud
JSR &2020        :\ 8DA0= 20 20 20       
JSR &0020        :\ 8DA3= 20 20 00      .
JSR L8B7D        :\ 8DA6= 20 7D 8B     }.
.L8DA9
JSR L8AE1        :\ 8DA9= 20 E1 8A     a.
JSR L8A66        :\ 8DAC= 20 66 8A     f.
JSR LA958        :\ 8DAF= 20 58 A9     X)
EQUB &44         :\ 8DB2= 44          D
ADC (&74,X)      :\ 8DB3= 61 74       at
ADC (&20,X)      :\ 8DB5= 61 20       a 
JSR &2020        :\ 8DB7= 20 20 20       
JSR &2000        :\ 8DBA= 20 00 20     . 
EQUB &82         :\ 8DBD= 82          .
EQUB &8B         :\ 8DBE= 8B          .
JSR LA958        :\ 8DBF= 20 58 A9     X)
EQUB &44         :\ 8DC2= 44          D
ADC &6C          :\ 8DC3= 65 6C       el
.L8DC5
ADC (&79,X)      :\ 8DC5= 61 79       ay
JSR &2020        :\ 8DC7= 20 20 20       
JSR &2000        :\ 8DCA= 20 00 20     . 
ROL &208B        :\ 8DCD= 2E 8B 20    .. 
TAX              :\ 8DD0= AA          *
EQUB &8B         :\ 8DD1= 8B          .
JSR L8ABB        :\ 8DD2= 20 BB 8A     ;.
JSR LA958        :\ 8DD5= 20 58 A9     X)
LSR &44          :\ 8DD8= 46 44       FD
ADC (&69)        :\ 8DDA= 72 69       ri
ROR &65,X        :\ 8DDC= 76 65       ve
JSR &2020        :\ 8DDE= 20 20 20       
BRK              :\ 8DE1= 00          .
JSR L8B87        :\ 8DE2= 20 87 8B     ..
JSR LA958        :\ 8DE5= 20 58 A9     X)
LSR &69          :\ 8DE8= 46 69       Fi
JMP (&2065)      :\ 8DEA= 6C 65 20    le 
JSR &2020        :\ 8DED= 20 20 20       
JSR &2000        :\ 8DF0= 20 00
JSR L8B10	 :\ 8DF2= 20 10 8B
JSR L8B8E        :\ 8DF5= 20 8E 8B     ..
JSR L8B62        :\ 8DF8= 20 62 8B     b.
JSR LA958        :\ 8DFB= 20 58 A9     X)
JMP &6E61        :\ 8DFE= 4C 61 6E    Lan
 
EQUB &67         :\ 8E01= 67          g
JSR &2020        :\ 8E02= 20 20 20       
JSR &0020        :\ 8E05= 20 20 00      .
JSR L8B08        :\ 8E08= 20 08 8B     ..
JSR LA958        :\ 8E0B= 20 58 A9     X)
EOR &646F        :\ 8E0E= 4D 6F 64    Mod
ADC &20          :\ 8E11= 65 20       e 
JSR &2020        :\ 8E13= 20 20 20       
JSR &2000        :\ 8E16= 20 00 20     . 
AND &8B          :\ 8E19= 25 8B       %.
JSR L8AF5        :\ 8E1B= 20 F5 8A     u.
JSR L8A9F        :\ 8E1E= 20 9F 8A     ..
JSR LA958        :\ 8E21= 20 58 A9     X)
EQUS "Print   ":EQUB 0
JSR L8B78        :\ 8E2E= 20 78 8B     x.
JSR LA958        :\ 8E31= 20 58 A9     X)
EQUS "Repeat   ":EQUB 0
JSR L8B34        :\ 8E3E= 20 34 8B     4.
JSR L8A89        :\ 8E41= 20 89 8A     ..
JSR LA958        :\ 8E44= 20 58 A9     X)
EQUB &54         :\ 8E47= 54          T
LSR &20,X        :\ 8E48= 56 20       V 
JSR &2020        :\ 8E4A= 20 20 20       
JSR &2020        :\ 8E4D= 20 20 20       
BRK              :\ 8E50= 00          .
JSR L8B17        :\ 8E51= 20 17 8B     ..
PLY              :\ 8E54= 7A          z
LDX #&29         :\ 8E55= A2 29       ")
JMP LEE72        :\ 8E57= 4C 72 EE    Lrn
 
.L8E5A
LDX #&18         :\ 8E5A= A2 18       ".
JSR L98B7        :\ 8E5C= 20 B7 98     7.
PHY              :\ 8E5F= 5A          Z
AND #&E0         :\ 8E60= 29 E0       )`
ASL A            :\ 8E62= 0A          .
ROL A            :\ 8E63= 2A          *
ROL A            :\ 8E64= 2A          *
ROL A            :\ 8E65= 2A          *
BIT #&04         :\ 8E66= 89 04       ..
BEQ L8E6C        :\ 8E68= F0 02       p.
ORA #&FC         :\ 8E6A= 09 FC       .|
.L8E6C
TAY              :\ 8E6C= A8          (
PLA              :\ 8E6D= 68          h
LDX #&00         :\ 8E6E= A2 00       ".
BIT #&10         :\ 8E70= 89 10       ..
BEQ L8E75        :\ 8E72= F0 01       p.
INX              :\ 8E74= E8          h
.L8E75
RTS              :\ 8E75= 60          `
 
\ Read configured MODE
\ --------------------
.L8E76
LDX #&18:JSR L98B7  :\ Read CMOS location 10 (&18-14)
AND #&0F            :\ Keep MODE bits
BIT #&08:BEQ L8E83  :\ Check shadow bit in b3
EOR #&88            :\ If >7, change to 128+n
.L8E83
RTS
 
.L8E84
JSR L98AA        :\ 8E84= 20 AA 98     *.
AND #&1C         :\ 8E87= 29 1C       ).
LSR A            :\ 8E89= 4A          J
LSR A            :\ 8E8A= 4A          J
INC A            :\ 8E8B= 1A          .
RTS              :\ 8E8C= 60          `
 
.L8E8D
JSR L98AA        :\ 8E8D= 20 AA 98     *.
.L8E90
AND #&E0         :\ 8E90= 29 E0       )`
ASL A            :\ 8E92= 0A          .
ROL A            :\ 8E93= 2A          *
ROL A            :\ 8E94= 2A          *
ROL A            :\ 8E95= 2A          *
RTS              :\ 8E96= 60          `
 
.L8E97
JSR L98AE        :\ 8E97= 20 AE 98     ..
BRA L8E90        :\ 8E9A= 80 F4       .t
 
.L8E9C
JSR L8EA4        :\ 8E9C= 20 A4 8E     $.
LSR A            :\ 8E9F= 4A          J
LSR A            :\ 8EA0= 4A          J
LSR A            :\ 8EA1= 4A          J
LSR A            :\ 8EA2= 4A          J
RTS              :\ 8EA3= 60          `
 
.L8EA4
LDX #&13         :\ 8EA4= A2 13       ".
BRA L8EAA        :\ 8EA6= 80 02       ..
 
.L8EA8
LDX #&1C         :\ 8EA8= A2 1C       ".
.L8EAA
JMP L98B7        :\ 8EAA= 4C B7 98    L7.
 
.L8EAD
LDX #&19         :\ 8EAD= A2 19       ".
BRA L8EAA        :\ 8EAF= 80 F9       .y
 
.L8EB1
JSR LA958        :\ 8EB1= 20 58 A9     X)
LSR &206F        :\ 8EB4= 4E 6F 20    No 
BRK              :\ 8EB7= 00          .
RTS              :\ 8EB8= 60          `

.L8EB9
LDA #&C0         :\ 8EB9= A9 C0       )@
STA HAZEL_WORKSPACE+&C2        :\ 8EBB= 8D C2 DF    .B_
BRA L8ED2        :\ 8EBE= 80 12       ..

.L8EC0
LSR HAZEL_WORKSPACE+&C2        :\ 8EC0= 4E C2 DF    NB_
STZ HAZEL_WORKSPACE+&C3        :\ 8EC3= 9C C3 DF    .C_
STZ HAZEL_WORKSPACE+&C4        :\ 8EC6= 9C C4 DF    .D_
BRA L8ECF        :\ 8EC9= 80 04       ..

.L8ECB
SEC              :\ 8ECB= 38          8
ROR HAZEL_WORKSPACE+&C2        :\ 8ECC= 6E C2 DF    nB_
.L8ECF
LSR HAZEL_WORKSPACE+&C2        :\ 8ECF= 4E C2 DF    NB_
.L8ED2
STZ HAZEL_WORKSPACE+&C5        :\ 8ED2= 9C C5 DF    .E_
JSR LA545        :\ 8ED5= 20 45 A5     E%
.L8ED8
BIT &FF          :\ 8ED8= 24 FF       $.
BMI L8F2E        :\ 8EDA= 30 52       0R
JSR OSBGET       :\ 8EDC= 20 D7 FF     W.
BCS L8F0F        :\ 8EDF= B0 2E       0.
BIT HAZEL_WORKSPACE+&C2        :\ 8EE1= 2C C2 DF    ,B_
BVS L8EEB        :\ 8EE4= 70 05       p.
PHA              :\ 8EE6= 48          H
JSR L91EB        :\ 8EE7= 20 EB 91     k.
PLA              :\ 8EEA= 68          h
.L8EEB
BIT HAZEL_WORKSPACE+&C2        :\ 8EEB= 2C C2 DF    ,B_
BMI L8F04        :\ 8EEE= 30 14       0.
CMP #&0D         :\ 8EF0= C9 0D       I.
BEQ L8F14        :\ 8EF2= F0 20       p 
CMP #&0A         :\ 8EF4= C9 0A       I.
BEQ L8F14        :\ 8EF6= F0 1C       p.
STA HAZEL_WORKSPACE+&C5        :\ 8EF8= 8D C5 DF    .E_
CMP #&22         :\ 8EFB= C9 22       I"
BEQ L8F04        :\ 8EFD= F0 05       p.
JSR L9606        :\ 8EFF= 20 06 96     ..
BRA L8F07        :\ 8F02= 80 03       ..
 
.L8F04
JSR OSWRCH       :\ 8F04= 20 EE FF     n.
.L8F07
JSR L8F3A        :\ 8F07= 20 3A 8F     :.
BCC L8EEB        :\ 8F0A= 90 DF       ._
.L8F0C
JSR OSNEWL       :\ 8F0C= 20 E7 FF     g.
.L8F0F
LDA #&00         :\ 8F0F= A9 00       ).
JMP OSFIND       :\ 8F11= 4C CE FF    LN.
 
.L8F14
CMP HAZEL_WORKSPACE+&C5        :\ 8F14= CD C5 DF    ME_
BEQ L8F29        :\ 8F17= F0 10       p.
PHA              :\ 8F19= 48          H
LDA HAZEL_WORKSPACE+&C5        :\ 8F1A= AD C5 DF    -E_
CMP #&0D         :\ 8F1D= C9 0D       I.
BEQ L8F34        :\ 8F1F= F0 13       p.
CMP #&0A         :\ 8F21= C9 0A       I.
BEQ L8F34        :\ 8F23= F0 0F       p.
PLA              :\ 8F25= 68          h
STA HAZEL_WORKSPACE+&C5        :\ 8F26= 8D C5 DF    .E_
.L8F29
JSR OSNEWL       :\ 8F29= 20 E7 FF     g.
BRA L8ED8        :\ 8F2C= 80 AA       .*
 
.L8F2E
JSR L8F0C        :\ 8F2E= 20 0C 8F     ..
JMP LA891        :\ 8F31= 4C 91 A8    L.(
 
.L8F34
PLA              :\ 8F34= 68          h
STZ HAZEL_WORKSPACE+&C5        :\ 8F35= 9C C5 DF    .E_
BRA L8F07        :\ 8F38= 80 CD       .M
 
.L8F3A
JSR OSBGET       :\ 8F3A= 20 D7 FF     W.
BIT &FF          :\ 8F3D= 24 FF       $.
BMI L8F2E        :\ 8F3F= 30 ED       0m
RTS              :\ 8F41= 60          `

.L8F42
STX &F2          :\ 8F42= 86 F2       .r
STY &F3          :\ 8F44= 84 F3       .s
LDX #&00         :\ 8F46= A2 00       ".
JSR L92BC        :\ 8F48= 20 BC 92     <.
LDX #&04         :\ 8F4B= A2 04       ".
JSR L92BC        :\ 8F4D= 20 BC 92     <.
LDY #&00         :\ 8F50= A0 00        .
LSR HAZEL_WORKSPACE+&C6        :\ 8F52= 4E C6 DF    NF_
JSR LF26D        :\ 8F55= 20 6D F2     mr
.L8F58
JSR LF27F        :\ 8F58= 20 7F F2     .r
BCC L8F58        :\ 8F5B= 90 FB       .{
BEQ L8F79        :\ 8F5D= F0 1A       p.
LDX #&00         :\ 8F5F= A2 00       ".
JSR L935B        :\ 8F61= 20 5B 93     [.
LDX #&03         :\ 8F64= A2 03       ".
.L8F66
LDA &02ED,X      :\ 8F66= BD ED 02    =m.
STA &02F1,X      :\ 8F69= 9D F1 02    .q.
DEX              :\ 8F6C= CA          J
BPL L8F66        :\ 8F6D= 10 F7       .w
JSR LF2FF        :\ 8F6F= 20 FF F2     .r
BEQ L8F79        :\ 8F72= F0 05       p.
LDX #&04         :\ 8F74= A2 04       ".
JSR L935B        :\ 8F76= 20 5B 93     [.
.L8F79
LDY &F3          :\ 8F79= A4 F3       $s
LDX &F2          :\ 8F7B= A6 F2       &r
ASL HAZEL_WORKSPACE+&C6        :\ 8F7D= 0E C6 DF    .F_
JSR LA545        :\ 8F80= 20 45 A5     E%
LDA #&02         :\ 8F83= A9 02       ).
JSR L9461        :\ 8F85= 20 61 94     a.
LDX #&03         :\ 8F88= A2 03       ".
.L8F8A
LDA &A8,X        :\ 8F8A= B5 A8       5(
CMP &02ED,X      :\ 8F8C= DD ED 02    ]m.
BCC L8FFB        :\ 8F8F= 90 6A       .j
BNE L8F96        :\ 8F91= D0 03       P.
DEX              :\ 8F93= CA          J
BPL L8F8A        :\ 8F94= 10 F4       .t
.L8F96
LDX #&03         :\ 8F96= A2 03       ".
.L8F98
LDA &02ED,X      :\ 8F98= BD ED 02    =m.
STA &A8,X        :\ 8F9B= 95 A8       .(
DEX              :\ 8F9D= CA          J
BPL L8F98        :\ 8F9E= 10 F8       .x
JSR L945F        :\ 8FA0= 20 5F 94     _.
.L8FA3
LDX #&00         :\ 8FA3= A2 00       ".
JSR OSBGET       :\ 8FA5= 20 D7 FF     W.
BCS L8FF0        :\ 8FA8= B0 46       0F
JSR L9239        :\ 8FAA= 20 39 92     9.
PHA              :\ 8FAD= 48          H
LDA &02F1        :\ 8FAE= AD F1 02    -q.
AND #&07         :\ 8FB1= 29 07       ).
BEQ L8FCA        :\ 8FB3= F0 15       p.
PHY              :\ 8FB5= 5A          Z
TAY              :\ 8FB6= A8          (
.L8FB7
PHY              :\ 8FB7= 5A          Z
JSR LA958        :\ 8FB8= 20 58 A9     X)
JSR &2020        :\ 8FBB= 20 20 20       
BRK              :\ 8FBE= 00          .
PLY              :\ 8FBF= 7A          z
LDA #&20         :\ 8FC0= A9 20       ) 
STA &02F5,X      :\ 8FC2= 9D F5 02    .u.
INX              :\ 8FC5= E8          h
DEY              :\ 8FC6= 88          .
BNE L8FB7        :\ 8FC7= D0 EE       Pn
PLY              :\ 8FC9= 7A          z
.L8FCA
PLA              :\ 8FCA= 68          h
.L8FCB
PHA              :\ 8FCB= 48          H
CMP #&20         :\ 8FCC= C9 20       I 
BCC L8FD4        :\ 8FCE= 90 04       ..
CMP #&7F         :\ 8FD0= C9 7F       I.
BCC L8FD6        :\ 8FD2= 90 02       ..
.L8FD4
LDA #&2E         :\ 8FD4= A9 2E       ).
.L8FD6
STA &02F5,X      :\ 8FD6= 9D F5 02    .u.
PLA              :\ 8FD9= 68          h
JSR LA865        :\ 8FDA= 20 65 A8     e(
INX              :\ 8FDD= E8          h
JSR L9248        :\ 8FDE= 20 48 92     H.
LDA &02F1        :\ 8FE1= AD F1 02    -q.
AND #&07         :\ 8FE4= 29 07       ).
BEQ L8FF3        :\ 8FE6= F0 0B       p.
JSR L8F3A        :\ 8FE8= 20 3A 8F     :.
BCC L8FCB        :\ 8FEB= 90 DE       .^
JSR L9257        :\ 8FED= 20 57 92     W.
.L8FF0
JMP L8F0F        :\ 8FF0= 4C 0F 8F    L..
 
.L8FF3
JSR L9257        :\ 8FF3= 20 57 92     W.
BRA L8FA3        :\ 8FF6= 80 AB       .+
 
.L8FF8
JMP LA54D        :\ 8FF8= 4C 4D A5    LM%
 
.L8FFB
JSR L8F0F        :\ 8FFB= 20 0F 8F     ..
JSR LAAED        :\ 8FFE= 20 ED AA     m*
EQUB &B7         :\ 9001= B7          7
EQUB &4F         :\ 9002= 4F          O
ADC &74,X        :\ 9003= 75 74       ut
EQUB &73         :\ 9005= 73          s
ADC #&64         :\ 9006= 69 64       id
ADC &20          :\ 9008= 65 20       e 
ROR &69          :\ 900A= 66 69       fi
JMP (&0065)      :\ 900C= 6C 65 00    le.

\ *BUILD
\ ======
.L900F
LSR HAZEL_WORKSPACE+&C2        :\ 900F= 4E C2 DF    NB_
BRA L9018        :\ 9012= 80 04       ..
.L9014
SEC              :\ 9014= 38          8
ROR HAZEL_WORKSPACE+&C2        :\ 9015= 6E C2 DF    nB_
.L9018
STZ HAZEL_WORKSPACE+&C3        :\ 9018= 9C C3 DF    .C_
STZ HAZEL_WORKSPACE+&C4        :\ 901B= 9C C4 DF    .D_
LDA #&80         :\ 901E= A9 80       ).
BIT HAZEL_WORKSPACE+&C2        :\ 9020= 2C C2 DF    ,B_
BPL L9027        :\ 9023= 10 02       ..
LDA #&C0         :\ 9025= A9 C0       )@
.L9027
JSR OSFIND       :\ 9027= 20 CE FF     N.
TAY              :\ 902A= A8          (
BEQ L8FF8        :\ 902B= F0 CB       pK
STY &02ED        :\ 902D= 8C ED 02    .m.
JSR L945A        :\ 9030= 20 5A 94     Z.
.L9033
JSR L91EB        :\ 9033= 20 EB 91     k.
.L9036
JSR L869D        :\ 9036= 20 9D 86     ..
PHP              :\ 9039= 08          .
BCC L904B        :\ 903A= 90 0F       ..
JSR OSNEWL       :\ 903C= 20 E7 FF     g.
LDA #&0D         :\ 903F= A9 0D       ).
STA LDC00,Y      :\ 9041= 99 00 DC    ..\
.L9044
PHY              :\ 9044= 5A          Z
LDA #&7E         :\ 9045= A9 7E       )~
JSR OSBYTE       :\ 9047= 20 F4 FF     t.
PLY              :\ 904A= 7A          z
.L904B
TYA              :\ 904B= 98          .
BEQ L909E        :\ 904C= F0 50       pP
JSR L90AB        :\ 904E= 20 AB 90     +.
LDY #&00         :\ 9051= A0 00        .
LDX #&00         :\ 9053= A2 00       ".
.L9055
JSR LF29C        :\ 9055= 20 9C F2     .r
STA LDC00,X      :\ 9058= 9D 00 DC    ..\
LDA #&01         :\ 905B= A9 01       ).
BIT &E4          :\ 905D= 24 E4       $d
BNE L906C        :\ 905F= D0 0B       P.
LDA #&07         :\ 9061= A9 07       ).
JSR OSWRCH       :\ 9063= 20 EE FF     n.
JSR L91F5        :\ 9066= 20 F5 91     u.
PLP              :\ 9069= 28          (
BRA L9036        :\ 906A= 80 CA       .J
 
.L906C
INX              :\ 906C= E8          h
BCC L9055        :\ 906D= 90 E6       .f
PLP              :\ 906F= 28          (
BCC L9073        :\ 9070= 90 01       ..
DEX              :\ 9072= CA          J
.L9073
PHP              :\ 9073= 08          .
PHX              :\ 9074= DA          Z
LDX #&0B         :\ 9075= A2 0B       ".
.L9077
STZ &02EE,X      :\ 9077= 9E EE 02    .n.
DEX              :\ 907A= CA          J
BPL L9077        :\ 907B= 10 FA       .z
PLX              :\ 907D= FA          z
STX &02F2        :\ 907E= 8E F2 02    .r.
LDA #&DC         :\ 9081= A9 DC       )\
STA &02EF        :\ 9083= 8D EF 02    .o.
DEC &02F0        :\ 9086= CE F0 02    Np.
DEC &02F1        :\ 9089= CE F1 02    Nq.
LDA #&02         :\ 908C= A9 02       ).
LDX #&ED         :\ 908E= A2 ED       "m
LDY #&02         :\ 9090= A0 02        .
JSR OSGBPB       :\ 9092= 20 D1 FF     Q.
PLP              :\ 9095= 28          (
BCC L9033        :\ 9096= 90 9B       ..
.L9098
LDY &02ED        :\ 9098= AC ED 02    ,m.
JMP L8F0F        :\ 909B= 4C 0F 8F    L..
 
.L909E
PLP              :\ 909E= 28          (
BCS L9098        :\ 909F= B0 F7       0w
LDA #&0D         :\ 90A1= A9 0D       ).
LDY &02ED        :\ 90A3= AC ED 02    ,m.
JSR OSBPUT       :\ 90A6= 20 D4 FF     T.
BRA L9033        :\ 90A9= 80 88       ..
 
.L90AB
LDA #&41         :\ 90AB= A9 41       )A
STA &E4          :\ 90AD= 85 E4       .d
STZ &F2          :\ 90AF= 64 F2       dr
LDA #&DC         :\ 90B1= A9 DC       )\
STA &F3          :\ 90B3= 85 F3       .s
RTS              :\ 90B5= 60          `

\ *MOVE
\ =====
.L90B6
LDA LFE34:STA HAZEL_WORKSPACE+&DC   :\ Save ACCCON
PHA:PHX:PHY           :\ Save ACCCON and command line pointer
LDY #&80              :\ Top of available shadow memory at &8000
LDA &D0               :\ Get VDU status
BIT #&10:BEQ L90CE    :\ Jump if not shadow screen, spare up to &8000
\ Shadow screen selected
JSR LF1C0             :\ Get screen bottom to XY
CPY #&30:BEQ L90E2    :\ Screen at &3000, no spare memory, jump to use Hazel

\ Non-shadow or small shadow screen selected
\ Y=top of available memory in shadow memory
.L90CE
LDA #&30:STA HAZEL_WORKSPACE+&D6    :\ &3000=start of shadow memory
LDA #&04:TSB LFE34
STA HAZEL_WORKSPACE+&DD             :\ set 'ACCCON changed'
TYA:SEC:SBC HAZEL_WORKSPACE+&D6     :\ A=length of space in shadow memory
BRA L90E9

\ No shadow memory available, use Hazel
.L90E2
LDA #&DD:STA HAZEL_WORKSPACE+&D6    :\ Buffer at &DD00
LDA #&02              :\ Buffer length=&200

\ &DFD6=high byte of buffer address
\ A=high byte of buffer length
.L90E9
STA HAZEL_WORKSPACE+&D7               :\ Store buffer length
PLY:PLX:PHX:PHY         :\ Get command line pointer
LDA #&40:JSR OSFIND     :\ Open source file
TAY:STY HAZEL_WORKSPACE+&D4:BEQ L9134 :\ Store source handle, jump if not found
PLY:PLX:STX &F2:STY &F3 :\ Get command line back again
PHX:PHY                 :\ And save it again
LDY #&00:JSR LF26D      :\ Step past first parameter
.L9108
JSR LF27F:BCC L9108
TYA:CLC:ADC &F2:STA HAZEL_WORKSPACE+&D8       :\ Save address of dest filename
TAX:LDA &F3:ADC #&00:STA HAZEL_WORKSPACE+&D9
TAY:ASL HAZEL_WORKSPACE+&C6           :\ Temporary filing system flag
LDA #&80:JSR OSFIND     :\ Open destination file
TAY:STY HAZEL_WORKSPACE+&D5:BNE L9137 :\ Store dest handle, jump if opened

\ Couldn't open destination
LDY HAZEL_WORKSPACE+&D4:STZ HAZEL_WORKSPACE+&D4     :\ Get source handle and clear it
JSR OSFIND              :\ Close source file
.L9134
JMP LA54D               :\ Jump to 'Not found' error

\ Source and dest opened
\ ----------------------
\ Build OSGBPB source file control block at &02ED
\ and destination control block at &DFC7
.L9137
LDX #&07
.L9139
STZ &02EE,X:STZ HAZEL_WORKSPACE+&C8,X         :\ Addr=0, Num=0
DEX:BPL L9139
LDA HAZEL_WORKSPACE+&D4:STA &02ED             :\ Source handle
LDA HAZEL_WORKSPACE+&D6:STA &02EF:STA HAZEL_WORKSPACE+&C9   :\ Buffer address
LDA HAZEL_WORKSPACE+&D7:STA &02F3:STA HAZEL_WORKSPACE+&CD   :\ Buffer length
DEC &02F0:DEC &02F1             :\ Source addr=&FFFFxxxx
DEC HAZEL_WORKSPACE+&CA:DEC HAZEL_WORKSPACE+&CB             :\ Dest addr=&FFFFxxxx

\ Should use &FFFExxxx and let filing system select correct memory
\ Unfortunately, CFS/RFS and DFS do not recognise &FFFExxxx, so
\ *MOVE has to do it itself, causing problems for filing systems
\ that /do/ recognise &FFFExxxx where they have to remember to
\ *do* *nothing* for &FFFFxxxx instead of select main memory as
\ &FFFFxxxx implies.

LDX #&ED:LDY #&02               :\ XY=>source OSGBPB block
LDA #&04:JSR OSGBPB             :\ Read data from source
PHP:BCC L9183                   :\ Jump if not at end of file
\ End of file, adjust destination buffer length for final part
LDA #&00:SBC &02F2:STA HAZEL_WORKSPACE+&CC
LDA HAZEL_WORKSPACE+&CD:SBC &02F3:STA HAZEL_WORKSPACE+&CD
.L9183
LDA HAZEL_WORKSPACE+&D5:STA HAZEL_WORKSPACE+&C7        :\ Destination handle
LDA #&02:LDX #&C7          :\ XY=>control block, A=write
LDY #&DF:JSR OSGBPB        :\ Write data
PLP:BCC L9137              :\ Loop until end of file
LDA #&00
LDY HAZEL_WORKSPACE+&D4:STZ HAZEL_WORKSPACE+&D4        :\ Get and clear source handle
PHY:JSR OSFIND             :\ Close source file
LDA #&00:LDY HAZEL_WORKSPACE+&D5         :\ Get dest handle
PHY:STZ HAZEL_WORKSPACE+&D5:JSR OSFIND   :\ Clear dest handle and close file
PLY:CPY #&04:BCS L91BD     :\ Dest not CFS/RFS, jump to...
PLY                        :\ Pop source handle
.L91B3
PLY:PLX                    :\ Restore XY
.L91B5
PLA:STZ HAZEL_WORKSPACE+&DD:STA LFE34    :\ Clear 'ACCCON changed', restore ACCCON
RTS
 
.L91BD
PLY:CPY #&04:BCC L91B3      :\ Source was CFS/RFS, jump to exit
PLY:STY &02EE:PLX:STX &02ED :\ Point to first parameter
LDX #&ED:LDY #&02
LDA #&05:JSR OSFILE         :\ Read info on source file
LDA HAZEL_WORKSPACE+&D8:STA &02ED         :\ Get address of dest filename
LDA HAZEL_WORKSPACE+&D9:STA &02EE         :\  and put in control block
LDA #&F0:TRB &02FB          :\ Mask out 'public' access bits
                            :\ Very annoying, as copying between
                            :\  filing systems that have 'public'
                            :\  bits means they get lost.
LDA #&01:JSR OSFILE         :\ Write info on dest file
BRA L91B5                   :\ Jump to restore ACCCON and exit
 
.L91EB
LDX #&00         :\ 91EB= A2 00       ".
SEC              :\ 91ED= 38          8
JSR L922E        :\ 91EE= 20 2E 92     ..
INX              :\ 91F1= E8          h
JSR L922E        :\ 91F2= 20 2E 92     ..
.L91F5
SEC              :\ 91F5= 38          8
LDA HAZEL_WORKSPACE+&C4        :\ 91F6= AD C4 DF    -D_
JSR L9211        :\ 91F9= 20 11 92     ..
LDA HAZEL_WORKSPACE+&C3        :\ 91FC= AD C3 DF    -C_
PHA              :\ 91FF= 48          H
PHP              :\ 9200= 08          .
LSR A            :\ 9201= 4A          J
LSR A            :\ 9202= 4A          J
LSR A            :\ 9203= 4A          J
LSR A            :\ 9204= 4A          J
PLP              :\ 9205= 28          (
JSR L921C        :\ 9206= 20 1C 92     ..
PLA              :\ 9209= 68          h
CLC              :\ 920A= 18          .
JSR L921C        :\ 920B= 20 1C 92     ..
JMP L9F0C        :\ 920E= 4C 0C 9F    L..
 
.L9211
PHA              :\ 9211= 48          H
PHP              :\ 9212= 08          .
LSR A            :\ 9213= 4A          J
LSR A            :\ 9214= 4A          J
LSR A            :\ 9215= 4A          J
LSR A            :\ 9216= 4A          J
PLP              :\ 9217= 28          (
JSR L921C        :\ 9218= 20 1C 92     ..
PLA              :\ 921B= 68          h
.L921C
AND #&0F         :\ 921C= 29 0F       ).
BNE L9229        :\ 921E= D0 09       P.
BCC L9229        :\ 9220= 90 07       ..
LDA #&20         :\ 9222= A9 20       ) 
JSR OSWRCH       :\ 9224= 20 EE FF     n.
SEC              :\ 9227= 38          8
RTS              :\ 9228= 60          `
 
.L9229
JSR LA873        :\ 9229= 20 73 A8     s(
CLC              :\ 922C= 18          .
RTS              :\ 922D= 60          `
 
.L922E
LDA #&00         :\ 922E= A9 00       ).
SED              :\ 9230= F8          x
ADC HAZEL_WORKSPACE+&C3,X      :\ 9231= 7D C3 DF    }C_
STA HAZEL_WORKSPACE+&C3,X      :\ 9234= 9D C3 DF    .C_
CLD              :\ 9237= D8          X
.L9238
RTS              :\ 9238= 60          `
 
.L9239
PHX              :\ 9239= DA          Z
PHA              :\ 923A= 48          H
LDX #&02         :\ 923B= A2 02       ".
.L923D
LDA &02F1,X      :\ 923D= BD F1 02    =q.
JSR LA86A        :\ 9240= 20 6A A8     j(
DEX              :\ 9243= CA          J
BPL L923D        :\ 9244= 10 F7       .w
BRA L9254        :\ 9246= 80 0C       ..
 
.L9248
PHX              :\ 9248= DA          Z
PHA              :\ 9249= 48          H
LDX #&FC         :\ 924A= A2 FC       "|
.L924C
INC &01F5,X      :\ 924C= FE F5 01    ~u.
BNE L9254        :\ 924F= D0 03       P.
INX              :\ 9251= E8          h
BNE L924C        :\ 9252= D0 F8       Px
.L9254
PLA              :\ 9254= 68          h
PLX              :\ 9255= FA          z
RTS              :\ 9256= 60          `
 
.L9257
PHY              :\ 9257= 5A          Z
PHX              :\ 9258= DA          Z
.L9259
CPX #&08         :\ 9259= E0 08       `.
BEQ L9267        :\ 925B= F0 0A       p.
JSR LA958        :\ 925D= 20 58 A9     X)
JSR &2020        :\ 9260= 20 20 20       
BRK              :\ 9263= 00          .
INX              :\ 9264= E8          h
BRA L9259        :\ 9265= 80 F2       .r
 
.L9267
PLX              :\ 9267= FA          z
JSR L9F0C        :\ 9268= 20 0C 9F     ..
LDY #&00         :\ 926B= A0 00        .
.L926D
LDA &02F5,Y      :\ 926D= B9 F5 02    9u.
JSR OSWRCH       :\ 9270= 20 EE FF     n.
INY              :\ 9273= C8          H
DEX              :\ 9274= CA          J
BNE L926D        :\ 9275= D0 F6       Pv
PLY              :\ 9277= 7A          z
JMP OSNEWL       :\ 9278= 4C E7 FF    Lg.
 
.L927B
LDX #&07         :\ 927B= A2 07       ".
.L927D
PHP              :\ 927D= 08          .
SEI              :\ 927E= 78          x
LDA #&B9         :\ 927F= A9 B9       )9
STA &F1          :\ 9281= 85 F1       .q
LDA #&89         :\ 9283= A9 89       ).
.L9285
STA &FB          :\ 9285= 85 FB       .{
JSR LE598        :\ 9287= 20 98 E5     .e
PHY              :\ 928A= 5A          Z
LDY #&00         :\ 928B= A0 00        .
STZ &FA          :\ 928D= 64 FA       dz
STZ &F0          :\ 928F= 64 F0       dp
.L9291
LDA (&F0),Y      :\ 9291= B1 F0       1p
STA (&FA),Y      :\ 9293= 91 FA       .z
INY              :\ 9295= C8          H
BNE L9291        :\ 9296= D0 F9       Py
INC &F1          :\ 9298= E6 F1       fq
INC &FB          :\ 929A= E6 FB       f{
DEX              :\ 929C= CA          J
BNE L9291        :\ 929D= D0 F2       Pr
PLY              :\ 929F= 7A          z
PLP              :\ 92A0= 28          (
JMP LE590        :\ 92A1= 4C 90 E5    L.e
 
.L92A4
LDX #&03         :\ 92A4= A2 03       ".
BRA L927D        :\ 92A6= 80 D5       .U
 
.L92A8
TXA              :\ 92A8= 8A          .
BEQ L927B        :\ 92A9= F0 D0       pP
CMP #&08         :\ 92AB= C9 08       I.
BCS L9238        :\ 92AD= B0 89       0.
PHP              :\ 92AF= 08          .
SEI              :\ 92B0= 78          x
ADC #&B8         :\ 92B1= 69 B8       i8
STA &F1          :\ 92B3= 85 F1       .q
TXA              :\ 92B5= 8A          .
LDX #&01         :\ 92B6= A2 01       ".
ADC #&88         :\ 92B8= 69 88       i.
BRA L9285        :\ 92BA= 80 C9       .I
 
.L92BC
STZ &02ED,X      :\ 92BC= 9E ED 02    .m.
STZ &02EE,X      :\ 92BF= 9E EE 02    .n.
STZ &02EF,X      :\ 92C2= 9E EF 02    .o.
STZ &02F0,X      :\ 92C5= 9E F0 02    .p.
RTS              :\ 92C8= 60          `
 
.L92C9
JSR LF2FF        :\ Skip spaces
JSR L8648        :\ 92CC= 20 48 86     H.
BCC L92F4        :\ 92CF= 90 23       .#
JSR L92BC        :\ 92D1= 20 BC 92     <.
.L92D4
PHY              :\ 92D4= 5A          Z
ROL A            :\ 92D5= 2A          *
ROL A            :\ 92D6= 2A          *
ROL A            :\ 92D7= 2A          *
ROL A            :\ 92D8= 2A          *
LDY #&04         :\ 92D9= A0 04        .
.L92DB
ROL A            :\ 92DB= 2A          *
ROL &02ED,X      :\ 92DC= 3E ED 02    >m.
ROL &02EE,X      :\ 92DF= 3E EE 02    >n.
ROL &02EF,X      :\ 92E2= 3E EF 02    >o.
ROL &02F0,X      :\ 92E5= 3E F0 02    >p.
BCS L934B        :\ 92E8= B0 61       0a
DEY              :\ 92EA= 88          .
BNE L92DB        :\ 92EB= D0 EE       Pn
PLY              :\ 92ED= 7A          z
JSR L8648        :\ 92EE= 20 48 86     H.
BCS L92D4        :\ 92F1= B0 E1       0a
SEC              :\ 92F3= 38          8
.L92F4
RTS              :\ 92F4= 60          `

\ *GO (<addr>)
\ ============
.L92F5 
JSR LF2FF        :\ Skip spaces
BNE L92FD        :\ Jump to read parameters
JMP L8661        :\ No parameters, enter CLICOM

\ *GOIO <addr>
\ ============
.L92FD
LDX #&00         :\ Use &02ED-&02F0
JSR L935B        :\ Read hex address
JSR LF2FF        :\ Skip spaces
PHP:TYA:CLC      :\ Update &F2/3 to point to any further parameters
ADC &F2:STA &F2
BCC L9310:INC &F3
.L9310
LDY #&00:PLP     :\ (&F2),Y=>parameters, EQ if no parameters
JMP (&02ED)      :\ Jump to address

.L9316 
LDA #&FF         :\ 9316= A9 FF       ).
.L9318
LSR HAZEL_WORKSPACE+&C6        :\ 9318= 4E C6 DF    NF_
.L931B
STX &F2          :\ 931B= 86 F2       .r
STY &F3          :\ 931D= 84 F3       .s
STX &02ED        :\ 931F= 8E ED 02    .m.
STY &02EE        :\ 9322= 8C EE 02    .n.
PHA              :\ 9325= 48          H
LDX #&02         :\ 9326= A2 02       ".
JSR L92BC        :\ 9328= 20 BC 92     <.
LDX #&0A         :\ 932B= A2 0A       ".
JSR L92BC        :\ 932D= 20 BC 92     <.
LDY #&FF         :\ 9330= A0 FF        .
STY &02F3        :\ 9332= 8C F3 02    .s.
INY              :\ 9335= C8          H
JSR LF26D        :\ 9336= 20 6D F2     mr
.L9339
JSR LF27F        :\ 9339= 20 7F F2     .r
BCC L9339        :\ 933C= 90 FB       .{
PLA              :\ 933E= 68          h
PHA              :\ 933F= 48          H
BPL L9392        :\ 9340= 10 50       .P
LDX #&02         :\ 9342= A2 02       ".
JSR L92C9        :\ 9344= 20 C9 92     I.
BCS L9361        :\ 9347= B0 18       0.
BEQ L9366        :\ 9349= F0 1B       p.
.L934B
JSR LAAED        :\ 934B= 20 ED AA     m*
EQUB &FC         :\ 934E= FC          |
EQUB &42         :\ 934F= 42          B
ADC (&64,X)      :\ 9350= 61 64       ad
JSR &6461        :\ 9352= 20 61 64     ad
STZ &72          :\ 9355= 64 72       dr
ADC &73          :\ 9357= 65 73       es
EQUB &73         :\ 9359= 73          s
BRK              :\ 935A= 00          .
.L935B
JSR L92C9        :\ Read hex address
BCC L934B        :\ Jump with bad address
RTS
 
.L9361
BNE L93E2        :\ 9361= D0 7F       P.
INC &02F3        :\ 9363= EE F3 02    ns.
.L9366
ASL HAZEL_WORKSPACE+&C6        :\ 9366= 0E C6 DF    .F_
.L9369
LDX #&ED         :\ 9369= A2 ED       "m
LDY #&02         :\ 936B= A0 02        .
PLA              :\ 936D= 68          h
JMP OSFILE       :\ 936E= 4C DD FF    L].
 
.L9371
STX &02ED        :\ 9371= 8E ED 02    .m.
STY &02EE        :\ 9374= 8C EE 02    .n.
LDA #&06         :\ 9377= A9 06       ).
PHA              :\ 9379= 48          H
BRA L9369        :\ 937A= 80 ED       .m

.L937C
JSR LF2FF        :\ 937C= 20 FF F2     .r
BNE L93E2        :\ 937F= D0 61       Pa
LDA #&00         :\ 9381= A9 00       ).
TAY              :\ 9383= A8          (
JMP (&021C)      :\ 9384= 6C 1C 02    l..

.L9387
BNE L938E        :\ 9387= D0 05       P.
SEC              :\ 9389= 38          8
ROR &0246        :\ 938A= 6E 46 02    nF.
RTS              :\ 938D= 60          `
 
.L938E
LDA #&06         :\ 938E= A9 06       ).
BRA L93EB        :\ 9390= 80 59       .Y
 
.L9392
BNE L939B        :\ 9392= D0 07       P.
LDX #&0A         :\ 9394= A2 0A       ".
JSR L92C9        :\ 9396= 20 C9 92     I.
BCC L93E2        :\ 9399= 90 47       .G
.L939B
CLV              :\ 939B= B8          8
LDA (&F2),Y      :\ 939C= B1 F2       1r
CMP #&2B         :\ 939E= C9 2B       I+
BNE L93A6        :\ 93A0= D0 04       P.
BIT LE34E        :\ 93A2= 2C 4E E3    ,Nc
INY              :\ 93A5= C8          H
.L93A6
LDX #&0E         :\ 93A6= A2 0E       ".
JSR L92C9        :\ 93A8= 20 C9 92     I.
BCC L93E2        :\ 93AB= 90 35       .5
PHP              :\ 93AD= 08          .
BVC L93BF        :\ 93AE= 50 0F       P.
LDX #&FC         :\ 93B0= A2 FC       "|
CLC              :\ 93B2= 18          .
.L93B3
LDA &01FB,X      :\ 93B3= BD FB 01    ={.
ADC &01FF,X      :\ 93B6= 7D FF 01    }..
STA &01FF,X      :\ 93B9= 9D FF 01    ...
INX              :\ 93BC= E8          h
BNE L93B3        :\ 93BD= D0 F4       Pt
.L93BF
LDX #&03         :\ 93BF= A2 03       ".
.L93C1
LDA &02F7,X      :\ 93C1= BD F7 02    =w.
STA &02F3,X      :\ 93C4= 9D F3 02    .s.
STA &02EF,X      :\ 93C7= 9D EF 02    .o.
DEX              :\ 93CA= CA          J
BPL L93C1        :\ 93CB= 10 F4       .t
PLP              :\ 93CD= 28          (
BEQ L9366        :\ 93CE= F0 96       p.
LDX #&06         :\ 93D0= A2 06       ".
JSR L92C9        :\ 93D2= 20 C9 92     I.
BCC L93E2        :\ 93D5= 90 0B       ..
BEQ L9366        :\ 93D7= F0 8D       p.
LDX #&02         :\ 93D9= A2 02       ".
JSR L92C9        :\ 93DB= 20 C9 92     I.
BCC L93E2        :\ 93DE= 90 02       ..
BEQ L9366        :\ 93E0= F0 84       p.
.L93E2
JMP LFBED        :\ 93E2= 4C ED FB    Lm{

.L93E5
JSR L85E6        :\ 93E5= 20 E6 85     f.
BCC L93E2        :\ 93E8= 90 F8       .x
TXA              :\ 93EA= 8A          .
.L93EB
PHP              :\ 93EB= 08          .
LSR HAZEL_WORKSPACE+&C6        :\ 93EC= 4E C6 DF    NF_
PLP              :\ 93EF= 28          (
PHA              :\ 93F0= 48          H
STZ &E5          :\ 93F1= 64 E5       de
STZ &E4          :\ 93F3= 64 E4       dd
JSR LF308        :\ 93F5= 20 08 F3     .s
BEQ L9412        :\ 93F8= F0 18       p.
JSR L85E6        :\ 93FA= 20 E6 85     f.
BCC L93E2        :\ 93FD= 90 E3       .c
STX &E5          :\ 93FF= 86 E5       .e
JSR LF30A        :\ 9401= 20 0A F3     .s
BEQ L9412        :\ 9404= F0 0C       p.
JSR L85E6        :\ 9406= 20 E6 85     f.
BCC L93E2        :\ 9409= 90 D7       .W
STX &E4          :\ 940B= 86 E4       .d
JSR LF2FF        :\ 940D= 20 FF F2     .r
BNE L93E2        :\ 9410= D0 D0       PP
.L9412
LDY &E4          :\ 9412= A4 E4       $d
LDX &E5          :\ 9414= A6 E5       &e
PLA              :\ 9416= 68          h
ASL HAZEL_WORKSPACE+&C6        :\ 9417= 0E C6 DF    .F_
JSR OSBYTE       :\ 941A= 20 F4 FF     t.
BVS L93E2        :\ 941D= 70 C3       pC
.L941F
RTS              :\ 941F= 60          `

.L9420
SEC              :\ 9420= 38          8
BRA L9433        :\ 9421= 80 10       ..
 
.L9423
LDX #&10         :\ 9423= A2 10       ".
JSR LEE72        :\ 9425= 20 72 EE     rn
BEQ L941F        :\ 9428= F0 F5       pu
JSR LA58B        :\ 942A= 20 8B A5     .%
LDA &0257        :\ 942D= AD 57 02    -W.
JSR LA56B        :\ 9430= 20 6B A5     k%
.L9433
PHP              :\ 9433= 08          .
PHY              :\ 9434= 5A          Z
LDY &0257        :\ 9435= AC 57 02    ,W.
STA &0257        :\ 9438= 8D 57 02    .W.
BEQ L9440        :\ 943B= F0 03       p.
JSR OSFIND       :\ 943D= 20 CE FF     N.
.L9440
LSR HAZEL_WORKSPACE+&C6        :\ 9440= 4E C6 DF    NF_
PLY              :\ 9443= 7A          z
PLP              :\ 9444= 28          (
BEQ L941F        :\ 9445= F0 D8       pX
LDA #&80         :\ 9447= A9 80       ).
BCC L944D        :\ 9449= 90 02       ..
LDA #&C0         :\ 944B= A9 C0       )@
.L944D
ASL HAZEL_WORKSPACE+&C6        :\ 944D= 0E C6 DF    .F_
JSR OSFIND       :\ 9450= 20 CE FF     N.
TAY              :\ 9453= A8          (
BEQ L93E2        :\ 9454= F0 8C       p.
STA &0257        :\ 9456= 8D 57 02    .W.
TAY              :\ 9459= A8          (
.L945A
LDA #&02         :\ 945A= A9 02       ).
JSR L9461        :\ 945C= 20 61 94     a.
.L945F
LDA #&01         :\ 945F= A9 01       ).
.L9461
LDX #&A8         :\ 9461= A2 A8       "(
JMP OSARGS       :\ 9463= 4C DA FF    LZ.

.L9466
LDA #&72         :\ 9466= A9 72       )r
BRA L93EB        :\ 9468= 80 81       ..

.L946A
JSR L9371        :\ 946A= 20 71 93     q.
TAY              :\ 946D= A8          (
BNE L941F        :\ 946E= D0 AF       P/
JMP LA54D        :\ 9470= 4C 4D A5    LM%
 
.L9473
JSR L85E6        :\ 9473= 20 E6 85     f.
BCC L947C        :\ 9476= 90 04       ..
CPX #&10         :\ 9478= E0 10       `.
BCC L941F        :\ 947A= 90 A3       .#
.L947C
JSR LAAED        :\ 947C= 20 ED AA     m*
EQUB &FB         :\ 947F= FB          {
EQUB &42         :\ 9480= 42          B
ADC (&64,X)      :\ 9481= 61 64       ad
JSR &656B        :\ 9483= 20 6B 65     ke
ADC &2000,Y      :\ 9486= 79 00       y.

.L9488
JSR L9473        :\ 9488 20 73 94
JSR LF2FF        :\ 948B 20 FF F2
BNE L947C        :\ 948E D0 EC
LDA #&22         :\ 9490 A9 22
JSR OSWRCH       :\ 9492= 20 EE FF     n.
LDA &F4          :\ 9495= A5 F4       %t
PHA              :\ 9497= 48          H
JSR LE598        :\ 9498= 20 98 E5     .e
LDA L8000,X      :\ 949B= BD 00 80    =..
STA &F2          :\ 949E= 85 F2       .r
LDA L8011,X      :\ 94A0= BD 11 80    =..
STA &F3          :\ 94A3= 85 F3       .s
LDY &E6          :\ 94A5= A4 E6       $f
JSR LEB55        :\ 94A7= 20 55 EB     Uk
TAY              :\ 94AA= A8          (
BEQ L94BB        :\ 94AB= F0 0E       p.
.L94AD
LDA (&F2)        :\ 94AD= B2 F2       2r
JSR L9606        :\ 94AF= 20 06 96     ..
INC &F2          :\ 94B2= E6 F2       fr
BNE L94B8        :\ 94B4= D0 02       P.
INC &F3          :\ 94B6= E6 F3       fs
.L94B8
DEY              :\ 94B8= 88          .
BNE L94AD        :\ 94B9= D0 F2       Pr
.L94BB
PLA              :\ 94BB= 68          h
JSR LE592        :\ 94BC= 20 92 E5     .e
LDA #&22         :\ 94BF= A9 22       )"
JSR OSWRCH       :\ 94C1= 20 EE FF     n.
JMP OSNEWL       :\ 94C4= 4C E7 FF    Lg.

.L94C7
JSR L9473        :\ 94C7= 20 73 94     s.
LDA &F4          :\ 94CA= A5 F4       %t
PHA              :\ 94CC= 48          H
JSR LE57F        :\ 94CD= 20 7F E5     .e
JSR LF2FF        :\ 94D0= 20 FF F2     .r
STZ &B0          :\ 94D3= 64 B0       d0
BEQ L94EC        :\ 94D5= F0 15       p.
LDX #&00         :\ 94D7= A2 00       ".
SEC              :\ 94D9= 38          8
JSR LF26E        :\ 94DA= 20 6E F2     nr
.L94DD
JSR LF27F        :\ 94DD= 20 7F F2     .r
BCS L94E8        :\ 94E0= B0 06       0.
STA LDC00,X      :\ 94E2= 9D 00 DC    ..\
INX              :\ 94E5= E8          h
BRA L94DD        :\ 94E6= 80 F5       .u
 
.L94E8
BNE L947C        :\ 94E8= D0 92       P.
STX &B0          :\ 94EA= 86 B0       .0
.L94EC
LDY &E6          :\ 94EC= A4 E6       $f
JSR LEB55        :\ 94EE= 20 55 EB     Uk
STA &B5          :\ 94F1= 85 B5       .5
SEC              :\ 94F3= 38          8
SBC &B0          :\ 94F4= E5 B0       e0
BCS L950E        :\ 94F6= B0 16       0.
EOR #&FF         :\ 94F8= 49 FF       I.
ADC #&01         :\ 94FA= 69 01       i.
ADC L8010        :\ 94FC= 6D 10 80    m..
TAX              :\ 94FF= AA          *
LDA L8021        :\ 9500= AD 21 80    -!.
ADC #&00         :\ 9503= 69 00       i.
CMP #&84         :\ 9505= C9 84       I.
BCC L950E        :\ 9507= 90 05       ..
BNE L94E8        :\ 9509= D0 DD       P]
TXA              :\ 950B= 8A          .
BNE L94E8        :\ 950C= D0 DA       PZ
.L950E
LDA &0268        :\ 950E= AD 68 02    -h.
BEQ L9545        :\ 9511= F0 32       p2
LDA &02C9        :\ 9513= AD C9 02    -I.
CMP &E6          :\ 9516= C5 E6       Ef
BCC L9545        :\ 9518= 90 2B       .+
BNE L952B        :\ 951A= D0 0F       P.
JSR LAAED        :\ 951C= 20 ED AA     m*
PLX              :\ 951F= FA          z
EQUS "Key in use",0
; EQUB &4B         :\ 9520= 4B          K
; ADC &79          :\ 9521= 65 79       ey
; JSR &6E69        :\ 9523= 20 69 6E     in
; JSR &7375        :\ 9526= 20 75 73     us
; ADC &00          :\ 9529= 65 00       e.
.L952B
STZ &B2          :\ 952B= 64 B2       d2
SEC              :\ 952D= 38          8
LDA &B0          :\ 952E= A5 B0       %0
SBC &B5          :\ 9530= E5 B5       e5
STA &B1          :\ 9532= 85 B1       .1
BCS L9538        :\ 9534= B0 02       0.
DEC &B2          :\ 9536= C6 B2       F2
.L9538
CLC              :\ 9538= 18          .
LDA &F8          :\ 9539= A5 F8       %x
ADC &B1          :\ 953B= 65 B1       e1
STA &F8          :\ 953D= 85 F8       .x
LDA &F9          :\ 953F= A5 F9       %y
ADC &B2          :\ 9541= 65 B2       e2
STA &F9          :\ 9543= 85 F9       .y
.L9545
DEC &0284        :\ 9545= CE 84 02    N..
LDX &E6          :\ 9548= A6 E6       &f
LDA &B5          :\ 954A= A5 B5       %5
BEQ L9593        :\ 954C= F0 45       pE
LDA L8000,X      :\ 954E= BD 00 80    =..
STA &B1          :\ 9551= 85 B1       .1
LDA L8011,X      :\ 9553= BD 11 80    =..
STA &B2          :\ 9556= 85 B2       .2
LDA L8001,X      :\ 9558= BD 01 80    =..
STA &B3          :\ 955B= 85 B3       .3
LDA L8012,X      :\ 955D= BD 12 80    =..
STA &B4          :\ 9560= 85 B4       .4
.L9562
LDA (&B3)        :\ 9562= B2 B3       23
STA (&B1)        :\ 9564= 92 B1       .1
INC &B1          :\ 9566= E6 B1       f1
BNE L956C        :\ 9568= D0 02       P.
INC &B2          :\ 956A= E6 B2       f2
.L956C
INC &B3          :\ 956C= E6 B3       f3
BNE L9572        :\ 956E= D0 02       P.
INC &B4          :\ 9570= E6 B4       f4
.L9572
LDA &B3          :\ 9572= A5 B3       %3
CMP L8010        :\ 9574= CD 10 80    M..
LDA &B4          :\ 9577= A5 B4       %4
SBC L8021        :\ 9579= ED 21 80    m!.
BCC L9562        :\ 957C= 90 E4       .d
.L957E
INX              :\ 957E= E8          h
CPX #&11         :\ 957F= E0 11       `.
BCS L9593        :\ 9581= B0 10       0.
SEC              :\ 9583= 38          8
LDA L8000,X      :\ 9584= BD 00 80    =..
SBC &B5          :\ 9587= E5 B5       e5
STA L8000,X      :\ 9589= 9D 00 80    ...
BCS L957E        :\ 958C= B0 F0       0p
DEC L8011,X      :\ 958E= DE 11 80    ^..
BRA L957E        :\ 9591= 80 EB       .k
 
.L9593
LDX &E6          :\ 9593= A6 E6       &f
LDA &B0          :\ 9595= A5 B0       %0
BEQ L95FF        :\ 9597= F0 66       pf
LDA L8010        :\ 9599= AD 10 80    -..
STA &B3          :\ 959C= 85 B3       .3
CLC              :\ 959E= 18          .
ADC &B0          :\ 959F= 65 B0       e0
STA &B1          :\ 95A1= 85 B1       .1
LDA L8021        :\ 95A3= AD 21 80    -!.
STA &B4          :\ 95A6= 85 B4       .4
ADC #&00         :\ 95A8= 69 00       i.
STA &B2          :\ 95AA= 85 B2       .2
LDA &B3          :\ 95AC= A5 B3       %3
SEC              :\ 95AE= 38          8
SBC L8000,X      :\ 95AF= FD 00 80    }..
STA &B5          :\ 95B2= 85 B5       .5
LDA &B4          :\ 95B4= A5 B4       %4
SBC L8011,X      :\ 95B6= FD 11 80    }..
STA &B6          :\ 95B9= 85 B6       .6
.L95BB
LDA &B5          :\ 95BB= A5 B5       %5
ORA &B6          :\ 95BD= 05 B6       .6
BEQ L95DF        :\ 95BF= F0 1E       p.
LDA &B1          :\ 95C1= A5 B1       %1
BNE L95C7        :\ 95C3= D0 02       P.
DEC &B2          :\ 95C5= C6 B2       F2
.L95C7
DEC &B1          :\ 95C7= C6 B1       F1
LDA &B3          :\ 95C9= A5 B3       %3
BNE L95CF        :\ 95CB= D0 02       P.
DEC &B4          :\ 95CD= C6 B4       F4
.L95CF
DEC &B3          :\ 95CF= C6 B3       F3
LDA (&B3)        :\ 95D1= B2 B3       23
STA (&B1)        :\ 95D3= 92 B1       .1
LDA &B5          :\ 95D5= A5 B5       %5
BNE L95DB        :\ 95D7= D0 02       P.
DEC &B6          :\ 95D9= C6 B6       F6
.L95DB
DEC &B5          :\ 95DB= C6 B5       F5
BRA L95BB        :\ 95DD= 80 DC       .\
 
.L95DF
INX              :\ 95DF= E8          h
CPX #&11         :\ 95E0= E0 11       `.
BCS L95F3        :\ 95E2= B0 0F       0.
LDA L8000,X      :\ 95E4= BD 00 80    =..
ADC &B0          :\ 95E7= 65 B0       e0
STA L8000,X      :\ 95E9= 9D 00 80    ...
BCC L95DF        :\ 95EC= 90 F1       .q
INC L8011,X      :\ 95EE= FE 11 80    ~..
BRA L95DF        :\ 95F1= 80 EC       .l
 
.L95F3
LDY #&00         :\ 95F3= A0 00        .
.L95F5
LDA LDC00,Y      :\ 95F5= B9 00 DC    9.\
STA (&B3),Y      :\ 95F8= 91 B3       .3
INY              :\ 95FA= C8          H
DEC &B0          :\ 95FB= C6 B0       F0
BNE L95F5        :\ 95FD= D0 F6       Pv
.L95FF
INC &0284        :\ 95FF= EE 84 02    n..
PLA              :\ 9602= 68          h
JMP LE592        :\ 9603= 4C 92 E5    L.e
 
.L9606
TAX              :\ 9606= AA          *
BMI L9631        :\ 9607= 30 28       0(
CMP #&20         :\ 9609= C9 20       I 
BCC L962C        :\ 960B= 90 1F       ..
INX              :\ 960D= E8          h
BMI L961F        :\ 960E= 30 0F       0.
DEX              :\ 9610= CA          J
CMP #&22         :\ 9611= C9 22       I"
BEQ L9626        :\ 9613= F0 11       p.
CMP #&7C         :\ 9615= C9 7C       I|
BNE L961C        :\ 9617= D0 03       P.
JSR OSWRCH       :\ 9619= 20 EE FF     n.
.L961C
JMP OSWRCH       :\ 961C= 4C EE FF    Ln.
 
.L961F
JSR L963C        :\ 961F= 20 3C 96     <.
LDA #&3F         :\ 9622= A9 3F       )?
BRA L961C        :\ 9624= 80 F6       .v
 
.L9626
JSR L963C        :\ 9626= 20 3C 96     <.
TXA              :\ 9629= 8A          .
BRA L961C        :\ 962A= 80 F0       .p
 
.L962C
ORA #&40         :\ 962C= 09 40       .@
TAX              :\ 962E= AA          *
BRA L9626        :\ 962F= 80 F5       .u
 
.L9631
PHA              :\ 9631= 48          H
LDX #&21         :\ 9632= A2 21       "!
JSR L9626        :\ 9634= 20 26 96     &.
PLA              :\ 9637= 68          h
AND #&7F         :\ 9638= 29 7F       ).
BRA L9606        :\ 963A= 80 CA       .J
 
.L963C
LDA #&7C         :\ 963C= A9 7C       )|
BRA L961C        :\ 963E= 80 DC       .\

\ Day string not matched
\ ---------------------- 
.L9640
PLA                :\ Drop number of characters matched
PLA                :\ Get offset to string table
PLY                :\ Get start of supplied string
CLC:ADC #&04       :\ Step to next string table entry
CMP #&1C:BCC L9666 :\ If not checked 28/4=7 entries, keep looking
RTS                :\ Otherwise exit silently

\ Month string not matched
\ ------------------------
.L964B
PLA                :\ Drop number of characters matched
PLA                :\ Get offset to string table
PLY                :\ Get start of supplied string
CLC:ADC #&04       :\ Step to next string table entry
CMP #&30:BCC L9698 :\ If not checked 48/4=12 entries, keep looking
.L9655
RTS                :\ Otherwise exit silently

\ OSWORD &0F routine
\ ==================
\ (&F0)=>control block
\ A=length byte from (&F0),0
\ Y=0
\ Uses OSFILE control block at &2ED-&2FF as workspace
\
.L9656
STZ &02ED
EOR #&0F:BEQ L9665        :\ len=15, set date
EOR #&07:BEQ L96D7        :\ len=8, set time
EOR #&10:BNE L9655        :\ len=24, set date+time

\ Set date and set date+time
\ --------------------------
\ (&F0),1=>"Day,00 Mon 0000"
\ (&F0),1=>"Day,00 Mon 0000.00:00:00"
\ A=0, Y=0
.L9665
INY                       :\ Point to supplied data
:
\ Translate day string into day number
.L9666
PHY                       :\ Push pointer to data string
PHA                       :\ Push offset to match strings
TAX                       :\ X=>match strings
LDA #&03                  :\ A=3 characters to match
.L966B
PHA              :\ Save number of characters to match
LDA (&F0),Y      :\ Get character from string
EOR L9768,X      :\ Compare with day string table
AND #&DF         :\ Force to upper case
BNE L9640        :\ No match step to check next entry
INX              :\ Step to next character to match
INY              :\ Step to next data character
PLA              :\ Get character count back
DEC A:BNE L966B  :\ Decrement and loop until 3 characters matched
LDA L9768,X      :\ Get translation byte from string table
STA &02F4        :\ Store it in workspace
\ Translates Sun,Mon,Tue,etc to &01,&02,&03,etc
:
PLX:PLX                   :\ Drop char count and table offset
LDA (&F0),Y               :\ Get next character
CMP #',':BNE L9655     :\ Not followed by a comma, so exit silently
LDX #&07:JSR L9730        :\ Get day of month
BCC L9655                 :\ Bad number, exit silently
INY:LDA (&F0),Y           :\ Get next character
EOR #' ':BNE L9655     :\ Not space, exit silently
INY                       :\ Step to first character of month
:
\ Translate month string into month number
\ This could use the same code as the Day translation
.L9698
PHY                       :\ Push pointer to data string
PHA                       :\ Push offset to match strings
TAX                       :\ X=>match strings
LDA #&03                  :\ A=3 characters to match
.L969D
PHA              :\ 969D= 48          H
LDA (&F0),Y      :\ 969E= B1 F0       1p
EOR L9784,X      :\ 96A0= 5D 84 97    ]..
AND #&DF         :\ 96A3= 29 DF       )_
BNE L964B        :\ 96A5= D0 A4       P$
INX              :\ 96A7= E8          h
INY              :\ 96A8= C8          H
PLA              :\ 96A9= 68          h
DEC A            :\ 96AA= 3A          :
BNE L969D        :\ 96AB= D0 F0       Pp
LDA L9784,X      :\ 96AD= BD 84 97    =..
STA &02F6        :\ 96B0= 8D F6 02    .v.
\ Translates Jan,Feb,Mar,etc to &01,&02,&03,etc..&09,&10,&11,&12
:
PLX:PLX                   :\ Drop char count and table offset
LDA (&F0),Y               :\ Get next character
CMP #' ':BNE L9655     :\ Not followed by space, exit silently
LDX #&09:JSR L9730        :\ Get century number
BCC L9655                 :\ Bad number, exit silently
JSR L9730                 :\ Get year number
BCC L9655                 :\ Bad number, exit silently
ROR &02ED                 :\
LDA (&F0)                 :\ Get data length
CMP #&0F:BEQ L96FF        :\ len=15, jump to just set date
:
\ Must be len=24 to set date+time
INY:LDA (&F0),Y           :\ Get next character
CMP #'.':BNE L9753      :\ If not full stop, exit silently

\ Set time
\ --------
.L96D7
LDX #&04         :\ 96D7= A2 04       ".
JSR L9730        :\ 96D9= 20 30 97     0.
BCC L9753        :\ 96DC= 90 75       .u
INY              :\ 96DE= C8          H
LDA (&F0),Y      :\ 96DF= B1 F0       1p
CMP #&3A         :\ 96E1= C9 3A       I:
BNE L9753        :\ 96E3= D0 6E       Pn
LDX #&02         :\ 96E5= A2 02       ".
JSR L9730        :\ 96E7= 20 30 97     0.
BCC L9753        :\ 96EA= 90 67       .g
INY              :\ 96EC= C8          H
LDA (&F0),Y      :\ 96ED= B1 F0       1p
CMP #&3A         :\ 96EF= C9 3A       I:
BNE L9753        :\ 96F1= D0 60       P`
LDX #&00         :\ 96F3= A2 00       ".
JSR L9730        :\ 96F5= 20 30 97     0.
BCC L9753        :\ 96F8= 90 59       .Y
LDA #&40         :\ 96FA= A9 40       )@
TSB &02ED        :\ 96FC= 0C ED 02    .m.
.L96FF
CLI              :\ 96FF= 58          X
SEI              :\ 9700= 78          x
LDY #&83         :\ 9701= A0 83        .
LDX #&0B         :\ 9703= A2 0B       ".
JSR L98E4        :\ 9705= 20 E4 98     d.
BIT &02ED        :\ 9708= 2C ED 02    ,m.
BPL L971C        :\ 970B= 10 0F       ..
LDX #&06         :\ 970D= A2 06       ".
.L970F
LDY &02EE,X      :\ 970F= BC EE 02    <n.
JSR L98E4        :\ 9712= 20 E4 98     d.
INX              :\ 9715= E8          h
CPX #&0A         :\ 9716= E0 0A       `.
BCC L970F        :\ 9718= 90 F5       .u
BVC L9729        :\ 971A= 50 0D       P.
.L971C
LDX #&00         :\ 971C= A2 00       ".
.L971E
LDY &02EE,X      :\ 971E= BC EE 02    <n.
JSR L98E4        :\ 9721= 20 E4 98     d.
INX              :\ 9724= E8          h
CPX #&06         :\ 9725= E0 06       `.
BCC L971E        :\ 9727= 90 F5       .u
.L9729
LDX #&0B         :\ 9729= A2 0B       ".
LDY #&02         :\ 972B= A0 02        .
JMP L98E4        :\ 972D= 4C E4 98    Ld.
 
.L9730
JSR L9754        :\ 9730= 20 54 97     T.
EOR #&20         :\ 9733= 49 20       I 
BEQ L973B        :\ 9735= F0 04       p.
EOR #&20         :\ 9737= 49 20       I 
BCC L9753        :\ 9739= 90 18       ..
.L973B
STA &02EE,X      :\ 973B= 9D EE 02    .n.
JSR L9754        :\ 973E= 20 54 97     T.
BCC L9753        :\ 9741= 90 10       ..
PHY              :\ 9743= 5A          Z
LDY #&04         :\ 9744= A0 04        .
ASL A            :\ 9746= 0A          .
ASL A            :\ 9747= 0A          .
ASL A            :\ 9748= 0A          .
ASL A            :\ 9749= 0A          .
.L974A
ASL A            :\ 974A= 0A          .
ROL &02EE,X      :\ 974B= 3E EE 02    >n.
DEY              :\ 974E= 88          .
BNE L974A        :\ 974F= D0 F9       Py
PLY              :\ 9751= 7A          z
SEC              :\ 9752= 38          8
.L9753
RTS              :\ 9753= 60          `
 
.L9754
INY              :\ 9754= C8          H
LDA (&F0),Y      :\ 9755= B1 F0       1p
CMP #&3A         :\ 9757= C9 3A       I:
BCS L9762        :\ 9759= B0 07       0.
CMP #&30         :\ 975B= C9 30       I0
BCC L9762        :\ 975D= 90 03       ..
AND #&0F         :\ 975F= 29 0F       ).
RTS              :\ 9761= 60          `
 
.L9762
CLC              :\ 9762= 18          .
RTS              :\ 9763= 60          `
 
.L9764
JSR &2020        :\ 9764= 20 20 20       
BRK              :\ 9767= 00          .
.L9768
EQUB &53         :\ 9768= 53          S
ADC &6E,X        :\ 9769= 75 6E       un
ORA (&4D,X)      :\ 976B= 01 4D       .M
EQUB &6F         :\ 976D= 6F          o
ROR &5402        :\ 976E= 6E 02 54    n.T
ADC &65,X        :\ 9771= 75 65       ue
EQUB &03         :\ 9773= 03          .
EQUB &57         :\ 9774= 57          W
ADC &64          :\ 9775= 65 64       ed
TSB &54          :\ 9777= 04 54       .T
PLA              :\ 9779= 68          h
ADC &05,X        :\ 977A= 75 05       u.
LSR &72          :\ 977C= 46 72       Fr
ADC #&06         :\ 977E= 69 06       i.
EQUB &53         :\ 9780= 53          S
ADC (&74,X)      :\ 9781= 61 74       at
EQUB &07         :\ 9783= 07          .
.L9784
LSR A            :\ 9784= 4A          J
ADC (&6E,X)      :\ 9785= 61 6E       an
ORA (&46,X)      :\ 9787= 01 46       .F
ADC &62          :\ 9789= 65 62       eb
EQUB &02         :\ 978B= 02          .
EOR &7261        :\ 978C= 4D 61 72    Mar
EQUB &03         :\ 978F= 03          .
EOR (&70,X)      :\ 9790= 41 70       Ap
ADC (&04)        :\ 9792= 72 04       r.
EOR &7961        :\ 9794= 4D 61 79    May
ORA &4A          :\ 9797= 05 4A       .J
ADC &6E,X        :\ 9799= 75 6E       un
ASL &4A          :\ 979B= 06 4A       .J
ADC &6C,X        :\ 979D= 75 6C       ul
EQUB &07         :\ 979F= 07          .
EOR (&75,X)      :\ 97A0= 41 75       Au
EQUB &67         :\ 97A2= 67          g
PHP              :\ 97A3= 08          .
EQUB &53         :\ 97A4= 53          S
ADC &70          :\ 97A5= 65 70       ep
ORA #&4F         :\ 97A7= 09 4F       .O
EQUB &63         :\ 97A9= 63          c
STZ &10,X        :\ 97AA= 74 10       t.
LSR &766F        :\ 97AC= 4E 6F 76    Nov
ORA (&44),Y      :\ 97AF= 11 44       .D
ADC &63          :\ 97B1= 65 63       ec
\ORA (&48)        :\ 97B3= 12 48       .H
EQUB &12
.L97B4
PHA
EOR #&02         :\ 97B5= 49 02       I.
BNE L97D4        :\ 97B7= D0 1B       P.
LDY #&07         :\ 97B9= A0 07        .
LDX #&00         :\ 97BB= A2 00       ".
.L97BD
LDA (&F0),Y      :\ 97BD= B1 F0       1p
STA &02EE,X      :\ 97BF= 9D EE 02    .n.
DEY              :\ 97C2= 88          .
INX              :\ 97C3= E8          h
INX              :\ 97C4= E8          h
CPX #&06         :\ 97C5= E0 06       `.
BCC L97BD        :\ 97C7= 90 F4       .t
.L97C9
LDA (&F0),Y      :\ 97C9= B1 F0       1p
STA &02EE,X      :\ 97CB= 9D EE 02    .n.
INX              :\ 97CE= E8          h
DEY              :\ 97CF= 88          .
BNE L97C9        :\ 97D0= D0 F7       Pw
BRA L9804        :\ 97D2= 80 30       .0
 
.L97D4
LDA &F0          :\ 97D4= A5 F0       %p
PHA              :\ 97D6= 48          H
LDA &F1          :\ 97D7= A5 F1       %q
PHA              :\ 97D9= 48          H
.L97DA
LDX #&0C         :\ 97DA= A2 0C       ".
JSR L98B7        :\ 97DC= 20 B7 98     7.
LDX #&09         :\ 97DF= A2 09       ".
.L97E1
JSR L98B7        :\ 97E1= 20 B7 98     7.
STA &02EE,X      :\ 97E4= 9D EE 02    .n.
DEX              :\ 97E7= CA          J
BPL L97E1        :\ 97E8= 10 F7       .w
LDX #&0A         :\ 97EA= A2 0A       ".
JSR L98B7        :\ 97EC= 20 B7 98     7.
BPL L97F5        :\ 97EF= 10 04       ..
.L97F1
CLI              :\ 97F1= 58          X
SEI              :\ 97F2= 78          x
BRA L97DA        :\ 97F3= 80 E5       .e
 
.L97F5
LDX #&0C         :\ 97F5= A2 0C       ".
JSR L98B7        :\ 97F7= 20 B7 98     7.
AND #&10         :\ 97FA= 29 10       ).
BNE L97F1        :\ 97FC= D0 F3       Ps
PLA              :\ 97FE= 68          h
STA &F1          :\ 97FF= 85 F1       .q
PLA              :\ 9801= 68          h
STA &F0          :\ 9802= 85 F0       .p
.L9804
PLA              :\ 9804= 68          h
DEC A            :\ 9805= 3A          :
BNE L9822        :\ 9806= D0 1A       P.
LDY #&00         :\ 9808= A0 00        .
LDX #&09         :\ 980A= A2 09       ".
.L980C
LDA &02EE,X      :\ 980C= BD EE 02    =n.
STA (&F0),Y      :\ 980F= 91 F0       .p
INY              :\ 9811= C8          H
DEX              :\ 9812= CA          J
CPX #&06         :\ 9813= E0 06       `.
BCS L980C        :\ 9815= B0 F5       0u
.L9817
LDA &02ED,X      :\ 9817= BD ED 02    =m.
STA (&F0),Y      :\ 981A= 91 F0       .p
INY              :\ 981C= C8          H
DEX              :\ 981D= CA          J
DEX              :\ 981E= CA          J
BPL L9817        :\ 981F= 10 F6       .v
RTS              :\ 9821= 60          `
 
.L9822
LDY #&18         :\ 9822= A0 18        .
LDA #&0D         :\ 9824= A9 0D       ).
STA (&F0),Y      :\ 9826= 91 F0       .p
LDX #&00         :\ 9828= A2 00       ".
DEY              :\ 982A= 88          .
JSR L9890        :\ 982B= 20 90 98     ..
LDA #&3A         :\ 982E= A9 3A       ):
STA (&F0),Y      :\ 9830= 91 F0       .p
LDY #&12         :\ 9832= A0 12        .
STA (&F0),Y      :\ 9834= 91 F0       .p
LDX #&02         :\ 9836= A2 02       ".
LDY #&14         :\ 9838= A0 14        .
JSR L9890        :\ 983A= 20 90 98     ..
LDX #&04         :\ 983D= A2 04       ".
LDY #&11         :\ 983F= A0 11        .
JSR L9890        :\ 9841= 20 90 98     ..
LDA #&2E         :\ 9844= A9 2E       ).
STA (&F0),Y      :\ 9846= 91 F0       .p
LDA &02F4        :\ 9848= AD F4 02    -t.
ASL A            :\ 984B= 0A          .
ASL A            :\ 984C= 0A          .
LDY #&00         :\ 984D= A0 00        .
TAX              :\ 984F= AA          *
.L9850
LDA L9764,X      :\ 9850= BD 64 97    =d.
STA (&F0),Y      :\ 9853= 91 F0       .p
INX              :\ 9855= E8          h
INY              :\ 9856= C8          H
CPY #&03         :\ 9857= C0 03       @.
BCC L9850        :\ 9859= 90 F5       .u
LDA #&2C         :\ 985B= A9 2C       ),
STA (&F0),Y      :\ 985D= 91 F0       .p
LDA &02F6        :\ 985F= AD F6 02    -v.
CMP #&10         :\ 9862= C9 10       I.
BCC L9868        :\ 9864= 90 02       ..
SBC #&06         :\ 9866= E9 06       i.
.L9868
DEC A            :\ 9868= 3A          :
ASL A            :\ 9869= 0A          .
ASL A            :\ 986A= 0A          .
TAX              :\ 986B= AA          *
LDY #&07         :\ 986C= A0 07        .
.L986E
LDA L9784,X      :\ 986E= BD 84 97    =..
STA (&F0),Y      :\ 9871= 91 F0       .p
INX              :\ 9873= E8          h
INY              :\ 9874= C8          H
CPY #&0A         :\ 9875= C0 0A       @.
BCC L986E        :\ 9877= 90 F5       .u
LDX #&09         :\ 9879= A2 09       ".
LDY #&0E         :\ 987B= A0 0E        .
JSR L9890        :\ 987D= 20 90 98     ..
LDA #&19         :\ 9880= A9 19       ).
JSR L9893        :\ 9882= 20 93 98     ..
LDA #&20         :\ 9885= A9 20       ) 
STA (&F0),Y      :\ 9887= 91 F0       .p
LDY #&06         :\ 9889= A0 06        .
STA (&F0),Y      :\ 988B= 91 F0       .p
DEY              :\ 988D= 88          .
LDX #&07         :\ 988E= A2 07       ".
.L9890
LDA &02EE,X      :\ 9890= BD EE 02    =n.
.L9893
PHA              :\ 9893= 48          H
JSR L989C        :\ 9894= 20 9C 98     ..
PLA              :\ 9897= 68          h
LSR A            :\ 9898= 4A          J
LSR A            :\ 9899= 4A          J
LSR A            :\ 989A= 4A          J
LSR A            :\ 989B= 4A          J
.L989C
AND #&0F         :\ 989C= 29 0F       ).
ORA #&30         :\ 989E= 09 30       .0
CMP #&3A         :\ 98A0= C9 3A       I:
BCC L98A6        :\ 98A2= 90 02       ..
ADC #&06         :\ 98A4= 69 06       i.
.L98A6
STA (&F0),Y      :\ 98A6= 91 F0       .p
DEY              :\ 98A8= 88          .
RTS              :\ 98A9= 60          `
 
.L98AA
LDX #&1D         :\ 98AA= A2 1D       ".
BRA L98B7        :\ 98AC= 80 09       ..
 
.L98AE
LDX #&1E:BRA L98B7  :\ Read CMOS location 16 (&1E-14)
 
.L98B2
JSR L98FD        :\ 98B2= 20 FD 98     }.
BCS L98DB        :\ 98B5= B0 24       0$
.L98B7
PHP              :\ 98B7= 08          .
SEI              :\ 98B8= 78          x
JSR L9906        :\ 98B9= 20 06 99     ..
LDA #&49         :\ 98BC= A9 49       )I
STA SYSTEM_VIA+&0        :\ 98BE= 8D 40 FE    .@~
STZ SYSTEM_VIA+&3        :\ 98C1= 9C 43 FE    .C~
LDA #&4A         :\ 98C4= A9 4A       )J
STA SYSTEM_VIA+&0        :\ 98C6= 8D 40 FE    .@~
LDY SYSTEM_VIA+&F        :\ 98C9= AC 4F FE    ,O~
.L98CC
LDA #&42         :\ 98CC= A9 42       )B
STA SYSTEM_VIA+&0        :\ 98CE= 8D 40 FE    .@~
LDA #&02         :\ 98D1= A9 02       ).
STA SYSTEM_VIA+&0        :\ 98D3= 8D 40 FE    .@~
STZ SYSTEM_VIA+&3        :\ 98D6= 9C 43 FE    .C~
PLP              :\ 98D9= 28          (
TYA              :\ 98DA= 98          .
.L98DB
RTS              :\ 98DB= 60          `
 
.L98DC
TXA              :\ 98DC= 8A          .
BEQ L98DB        :\ 98DD= F0 FC       p|
JSR L98FD        :\ 98DF= 20 FD 98     }.
BCS L98DB        :\ 98E2= B0 F7       0w
.L98E4
PHP              :\ 98E4= 08          .
SEI              :\ 98E5= 78          x
JSR L9906        :\ 98E6= 20 06 99     ..
LDA #&41         :\ 98E9= A9 41       )A
STA SYSTEM_VIA+&0        :\ 98EB= 8D 40 FE    .@~
LDA #&FF         :\ 98EE= A9 FF       ).
STA SYSTEM_VIA+&3        :\ 98F0= 8D 43 FE    .C~
LDA #&4A         :\ 98F3= A9 4A       )J
STA SYSTEM_VIA+&0        :\ 98F5= 8D 40 FE    .@~
STY SYSTEM_VIA+&F        :\ 98F8= 8C 4F FE    .O~
BRA L98CC        :\ 98FB= 80 CF       .O
 
.L98FD
CPX #&32         :\ 98FD= E0 32       `2
BCS L9905        :\ 98FF= B0 04       0.
TXA              :\ 9901= 8A          .
ADC #&0E         :\ 9902= 69 0E       i.
TAX              :\ 9904= AA          *
.L9905
RTS              :\ 9905= 60          `
 
.L9906
LDA #&02         :\ 9906= A9 02       ).
STA SYSTEM_VIA+&0        :\ 9908= 8D 40 FE    .@~
LDA #&82         :\ 990B= A9 82       ).
STA SYSTEM_VIA+&0        :\ 990D= 8D 40 FE    .@~
LDA #&FF         :\ 9910= A9 FF       ).
STA SYSTEM_VIA+&3        :\ 9912= 8D 43 FE    .C~
STX SYSTEM_VIA+&F        :\ 9915= 8E 4F FE    .O~
LDA #&C2         :\ 9918= A9 C2       )B
STA SYSTEM_VIA+&0        :\ 991A= 8D 40 FE    .@~
LDA #&42         :\ 991D= A9 42       )B
STA SYSTEM_VIA+&0        :\ 991F= 8D 40 FE    .@~
RTS              :\ 9922= 60          `
 
LDA #&03         :\ 9923= A9 03       ).
JSR LD298        :\ 9925= 20 98 D2     .R
BCC L993C        :\ 9928= 90 12       ..
JSR L9930        :\ 992A= 20 30 99     0.
JSR LD8A9        :\ 992D= 20 A9 D8     )X
.L9930
LDX #&20         :\ 9930= A2 20       " 
JMP LE2B8        :\ 9932= 4C B8 E2    L8b
 
LDA #&02         :\ 9935= A9 02       ).
JSR LD298        :\ 9937= 20 98 D2     .R
BCS L99A0        :\ 993A= B0 64       0d
.L993C
JSR LD3D2        :\ 993C= 20 D2 D3     RS
JSR L9ABF        :\ 993F= 20 BF 9A     ?.
BRA L994C        :\ 9942= 80 08       ..
 
JSR LD41A        :\ 9944= 20 1A D4     .T
BEQ L99A0        :\ 9947= F0 57       pW
JSR LD3D2        :\ 9949= 20 D2 D3     RS
.L994C
LDA &E1          :\ 994C= A5 E1       %a
BIT #&20         :\ 994E= 89 20       . 
BEQ L9957        :\ 9950= F0 05       p.
PHA              :\ 9952= 48          H
JSR LD6A3        :\ 9953= 20 A3 D6     #V
PLA              :\ 9956= 68          h
.L9957
BIT #&10         :\ 9957= 89 10       ..
BEQ L995E        :\ 9959= F0 03       p.
JSR LD698        :\ 995B= 20 98 D6     .V
.L995E
JSR L99FC        :\ 995E= 20 FC 99     |.
PHP              :\ 9961= 08          .
JSR L9A5A        :\ 9962= 20 5A 9A     Z.
LDX #&42         :\ 9965= A2 42       "B
LDY #&46         :\ 9967= A0 46        F
LDA #&20         :\ 9969= A9 20       ) 
BIT L8849        :\ 996B= 2C 49 88    ,I.
BEQ L998C        :\ 996E= F0 1C       p.
BMI L998A        :\ 9970= 30 18       0.
LDA &032C        :\ 9972= AD 2C 03    -,.
CMP &0337        :\ 9975= CD 37 03    M7.
BNE L9982        :\ 9978= D0 08       P.
LDA &032D        :\ 997A= AD 2D 03    --.
CMP &0338        :\ 997D= CD 38 03    M8.
BEQ L9992        :\ 9980= F0 10       p.
.L9982
LDX #&37         :\ 9982= A2 37       "7
JSR LD24D        :\ 9984= 20 4D D2     MR
LDX #&42         :\ 9987= A2 42       "B
CLV              :\ 9989= B8          8
.L998A
LDY #&2C         :\ 998A= A0 2C        ,
.L998C
BMI L9995        :\ 998C= 30 07       0.
BVC L9992        :\ 998E= 50 02       P.
LDX #&37         :\ 9990= A2 37       "7
.L9992
JSR LD24D        :\ 9992= 20 4D D2     MR
.L9995
PLP              :\ 9995= 28          (
BCC L994C        :\ 9996= 90 B4       .4
RTS              :\ 9998= 60          `
 
.L9999
LDA #&01         :\ 9999= A9 01       ).
JSR LD298        :\ 999B= 20 98 D2     .R
BCC L99A9        :\ 999E= 90 09       ..
.L99A0
LDX #&24         :\ 99A0= A2 24       "$
BRA L99DB        :\ 99A2= 80 37       .7
 
.L99A4
JSR LD41A        :\ 99A4= 20 1A D4     .T
BEQ L99A0        :\ 99A7= F0 F7       pw
.L99A9
JSR LD3D2        :\ 99A9= 20 D2 D3     RS
JSR L99C9        :\ 99AC= 20 C9 99     I.
.L99AF
JSR LD5E6        :\ 99AF= 20 E6 D5     fU
JSR L99C9        :\ 99B2= 20 C9 99     I.
LDA L8830        :\ 99B5= AD 30 88    -0.
ORA L8831        :\ 99B8= 0D 31 88    .1.
BEQ L99FB        :\ 99BB= F0 3E       p>
BIT L8848        :\ 99BD= 2C 48 88    ,H.
BVS L99AF        :\ 99C0= 70 ED       pm
LDX #&42         :\ 99C2= A2 42       "B
JSR L99D6        :\ 99C4= 20 D6 99     V.
BRA L99AF        :\ 99C7= 80 E6       .f
 
.L99C9
JSR LD334        :\ 99C9= 20 34 D3     4S
JSR L99DE        :\ 99CC= 20 DE 99     ^.
BIT L8848        :\ 99CF= 2C 48 88    ,H.
BMI L99FB        :\ 99D2= 30 27       0'
LDX #&46         :\ 99D4= A2 46       "F
.L99D6
PHX              :\ 99D6= DA          Z
JSR LD280        :\ 99D7= 20 80 D2     .R
PLX              :\ 99DA= FA          z
.L99DB
JMP LDB4C        :\ 99DB= 4C 4C DB    LL[
 
.L99DE
LDX #&03         :\ 99DE= A2 03       ".
.L99E0
LDA L8830,X      :\ 99E0= BD 30 88    =0.
STA &0342,X      :\ 99E3= 9D 42 03    .B.
STA &0346,X      :\ 99E6= 9D 46 03    .F.
DEX              :\ 99E9= CA          J
BPL L99E0        :\ 99EA= 10 F4       .t
.L99EC
LDY &0342        :\ 99EC= AC 42 03    ,B.
LDA &0343        :\ 99EF= AD 43 03    -C.
JSR LC92E        :\ 99F2= 20 2E C9     .I
STY &0342        :\ 99F5= 8C 42 03    .B.
STA &0343        :\ 99F8= 8D 43 03    .C.
.L99FB
RTS              :\ 99FB= 60          `
 
.L99FC
LDA &E1          :\ 99FC= A5 E1       %a
STA L8849        :\ 99FE= 8D 49 88    .I.
JSR L99DE        :\ 9A01= 20 DE 99     ^.
LDX #&01         :\ 9A04= A2 01       ".
.L9A06
STZ &0342,X      :\ 9A06= 9E 42 03    .B.
STZ &0346,X      :\ 9A09= 9E 46 03    .F.
DEX              :\ 9A0C= CA          J
BPL L9A06        :\ 9A0D= 10 F7       .w
.L9A0F
JSR L9A2E        :\ 9A0F= 20 2E 9A     ..
LDA L8830        :\ 9A12= AD 30 88    -0.
ORA L8831        :\ 9A15= 0D 31 88    .1.
BNE L9A20        :\ 9A18= D0 06       P.
SEC              :\ 9A1A= 38          8
LDA L8847        :\ 9A1B= AD 47 88    -G.
BNE L99EC        :\ 9A1E= D0 CC       PL
.L9A20
JSR LD5E6        :\ 9A20= 20 E6 D5     fU
LDA L8832        :\ 9A23= AD 32 88    -2.
CMP &0344        :\ 9A26= CD 44 03    MD.
BEQ L9A0F        :\ 9A29= F0 E4       pd
CLC              :\ 9A2B= 18          .
BRA L99EC        :\ 9A2C= 80 BE       .>
 
.L9A2E
JSR LD334        :\ 9A2E= 20 34 D3     4S
BIT L8848        :\ 9A31= 2C 48 88    ,H.
BMI L9A3D        :\ 9A34= 30 07       0.
PHP              :\ 9A36= 08          .
LDX #&46         :\ 9A37= A2 46       "F
JSR L9A41        :\ 9A39= 20 41 9A     A.
PLP              :\ 9A3C= 28          (
.L9A3D
BVS L9A59        :\ 9A3D= 70 1A       p.
LDX #&42         :\ 9A3F= A2 42       "B
.L9A41
LDA L8830        :\ 9A41= AD 30 88    -0.
TAY              :\ 9A44= A8          (
CMP &0300,X      :\ 9A45= DD 00 03    ]..
LDA L8831        :\ 9A48= AD 31 88    -1.
PHA              :\ 9A4B= 48          H
SBC &0301,X      :\ 9A4C= FD 01 03    }..
PLA              :\ 9A4F= 68          h
BCC L9A59        :\ 9A50= 90 07       ..
STA &0301,X      :\ 9A52= 9D 01 03    ...
TYA              :\ 9A55= 98          .
STA &0300,X      :\ 9A56= 9D 00 03    ...
.L9A59
RTS              :\ 9A59= 60          `
 
.L9A5A
LDA &0344        :\ 9A5A= AD 44 03    -D.
ORA &0345        :\ 9A5D= 0D 45 03    .E.
BNE L9ABE        :\ 9A60= D0 5C       P\
LDA &E1          :\ 9A62= A5 E1       %a
INC A            :\ 9A64= 1A          .
AND #&03         :\ 9A65= 29 03       ).
BNE L9ABE        :\ 9A67= D0 55       PU
LDA #&20         :\ 9A69= A9 20       ) 
BIT L8849        :\ 9A6B= 2C 49 88    ,I.
BPL L9A79        :\ 9A6E= 10 09       ..
BEQ L9A79        :\ 9A70= F0 07       p.
LDX #&2C         :\ 9A72= A2 2C       ",
LDY #&46         :\ 9A74= A0 46        F
JSR LC91E        :\ 9A76= 20 1E C9     .I
.L9A79
LDA #&10         :\ 9A79= A9 10       ).
BIT L8849        :\ 9A7B= 2C 49 88    ,I.
BVC L9A89        :\ 9A7E= 50 09       P.
BEQ L9A89        :\ 9A80= F0 07       p.
LDX #&37         :\ 9A82= A2 37       "7
LDY #&42         :\ 9A84= A0 42        B
JSR LC91E        :\ 9A86= 20 1E C9     .I
.L9A89
JSR L9ABF        :\ 9A89= 20 BF 9A     ?.
LDA &E1          :\ 9A8C= A5 E1       %a
EOR #&3C         :\ 9A8E= 49 3C       I<
ROL A            :\ 9A90= 2A          *
JSR LC66F        :\ 9A91= 20 6F C6     oF
ROR A            :\ 9A94= 6A          j
STA &E1          :\ 9A95= 85 E1       .a
BIT #&20         :\ 9A97= 89 20       . 
BEQ L9AAB        :\ 9A99= F0 10       p.
PHA              :\ 9A9B= 48          H
LDX #&2C         :\ 9A9C= A2 2C       ",
LDY #&46         :\ 9A9E= A0 46        F
JSR LD5CC        :\ 9AA0= 20 CC D5     LU
TYA              :\ 9AA3= 98          .
TAX              :\ 9AA4= AA          *
LDY #&46         :\ 9AA5= A0 46        F
JSR LC91E        :\ 9AA7= 20 1E C9     .I
PLA              :\ 9AAA= 68          h
.L9AAB
BIT #&10         :\ 9AAB= 89 10       ..
BEQ L9ABB        :\ 9AAD= F0 0C       p.
LDX #&37         :\ 9AAF= A2 37       "7
LDY #&42         :\ 9AB1= A0 42        B
JSR LD5CC        :\ 9AB3= 20 CC D5     LU
LDY #&42         :\ 9AB6= A0 42        B
JSR LC91E        :\ 9AB8= 20 1E C9     .I
.L9ABB
STZ L8849        :\ 9ABB= 9C 49 88    .I.
.L9ABE
RTS              :\ 9ABE= 60          `
 
.L9ABF
LDX #&03         :\ 9ABF= A2 03       ".
.L9AC1
STZ &033B,X      :\ 9AC1= 9E 3B 03    .;.
DEX              :\ 9AC4= CA          J
BPL L9AC1        :\ 9AC5= 10 FA       .z
LDY #&28         :\ 9AC7= A0 28        (
LDX #&1B         :\ 9AC9= A2 1B       ".
LDA #&2C         :\ 9ACB= A9 2C       ),
JSR L9ADF        :\ 9ACD= 20 DF 9A     _.
JSR LD6A8        :\ 9AD0= 20 A8 D6     (V
LDY #&1B         :\ 9AD3= A0 1B        .
LDX #&28         :\ 9AD5= A2 28       "(
LDA #&37         :\ 9AD7= A9 37       )7
JSR L9ADF        :\ 9AD9= 20 DF 9A     _.
JMP LD69D        :\ 9ADC= 4C 9D D6    L.V
 
.L9ADF
PHA              :\ 9ADF= 48          H
LDA &E1          :\ 9AE0= A5 E1       %a
LSR A            :\ 9AE2= 4A          J
BCC L9AF0        :\ 9AE3= 90 0B       ..
LDA L8847        :\ 9AE5= AD 47 88    -G.
BNE L9AEE        :\ 9AE8= D0 04       P.
LDX #&3B         :\ 9AEA= A2 3B       ";
BRA L9AF0        :\ 9AEC= 80 02       ..
 
.L9AEE
LDY #&3B         :\ 9AEE= A0 3B        ;
.L9AF0
TXA              :\ 9AF0= 8A          .
PLX              :\ 9AF1= FA          z
PHX              :\ 9AF2= DA          Z
PHA              :\ 9AF3= 48          H
PHY              :\ 9AF4= 5A          Z
TAY              :\ 9AF5= A8          (
LDA #&03         :\ 9AF6= A9 03       ).
STA &DA          :\ 9AF8= 85 DA       .Z
.L9AFA
LDA &0300,Y      :\ 9AFA= B9 00 03    9..
STA L881E,X      :\ 9AFD= 9D 1E 88    ...
INY              :\ 9B00= C8          H
INX              :\ 9B01= E8          h
DEC &DA          :\ 9B02= C6 DA       FZ
BPL L9AFA        :\ 9B04= 10 F4       .t
PLY              :\ 9B06= 7A          z
PLA              :\ 9B07= 68          h
PLX              :\ 9B08= FA          z
.L9B09
PHA              :\ 9B09= 48          H
PHY              :\ 9B0A= 5A          Z
JSR L9B61        :\ 9B0B= 20 61 9B     a.
DEX              :\ 9B0E= CA          J
PLY              :\ 9B0F= 7A          z
PLA              :\ 9B10= 68          h
PHX              :\ 9B11= DA          Z
INY              :\ 9B12= C8          H
INY              :\ 9B13= C8          H
INC A            :\ 9B14= 1A          .
INC A            :\ 9B15= 1A          .
INX              :\ 9B16= E8          h
INX              :\ 9B17= E8          h
JSR L9B61        :\ 9B18= 20 61 9B     a.
PLX              :\ 9B1B= FA          z
JSR L9B90        :\ 9B1C= 20 90 9B     ..
PHP              :\ 9B1F= 08          .
PHA              :\ 9B20= 48          H
LDA &0305,X      :\ 9B21= BD 05 03    =..
ASL A            :\ 9B24= 0A          .
ROR &030A,X      :\ 9B25= 7E 0A 03    ~..
BPL L9B2D        :\ 9B28= 10 03       ..
JSR L9B7F        :\ 9B2A= 20 7F 9B     ..
.L9B2D
PLA              :\ 9B2D= 68          h
ASL A            :\ 9B2E= 0A          .
ROR &030A,X      :\ 9B2F= 7E 0A 03    ~..
BPL L9B3B        :\ 9B32= 10 07       ..
INX              :\ 9B34= E8          h
INX              :\ 9B35= E8          h
JSR L9B7F        :\ 9B36= 20 7F 9B     ..
DEX              :\ 9B39= CA          J
DEX              :\ 9B3A= CA          J
.L9B3B
JSR L9B90        :\ 9B3B= 20 90 9B     ..
BPL L9B46        :\ 9B3E= 10 06       ..
LDA &0305,X      :\ 9B40= BD 05 03    =..
LDY &0304,X      :\ 9B43= BC 04 03    <..
.L9B46
PLP              :\ 9B46= 28          (
BMI L9B4F        :\ 9B47= 30 06       0.
CPY #&00         :\ 9B49= C0 00       @.
BNE L9B4E        :\ 9B4B= D0 01       P.
DEC A            :\ 9B4D= 3A          :
.L9B4E
DEY              :\ 9B4E= 88          .
.L9B4F
LSR A            :\ 9B4F= 4A          J
PHA              :\ 9B50= 48          H
TYA              :\ 9B51= 98          .
ROR A            :\ 9B52= 6A          j
SEC              :\ 9B53= 38          8
DEX              :\ 9B54= CA          J
JSR L9B5A        :\ 9B55= 20 5A 9B     Z.
INX              :\ 9B58= E8          h
PLA              :\ 9B59= 68          h
.L9B5A
SBC &0307,X      :\ 9B5A= FD 07 03    }..
STA &0309,X      :\ 9B5D= 9D 09 03    ...
RTS              :\ 9B60= 60          `
 
.L9B61
PHA              :\ 9B61= 48          H
LDA &0300,Y      :\ 9B62= B9 00 03    9..
STA &0300,X      :\ 9B65= 9D 00 03    ...
LDA &0301,Y      :\ 9B68= B9 01 03    9..
STA &0301,X      :\ 9B6B= 9D 01 03    ...
PLY              :\ 9B6E= 7A          z
SEC              :\ 9B6F= 38          8
JSR L9B75        :\ 9B70= 20 75 9B     u.
INX              :\ 9B73= E8          h
INY              :\ 9B74= C8          H
.L9B75
LDA &0300,Y      :\ 9B75= B9 00 03    9..
SBC &0300,X      :\ 9B78= FD 00 03    }..
STA &0304,X      :\ 9B7B= 9D 04 03    ...
RTS              :\ 9B7E= 60          `
 
.L9B7F
LDA &0305,X      :\ 9B7F= BD 05 03    =..
LDY &0304,X      :\ 9B82= BC 04 03    <..
JSR LC92E        :\ 9B85= 20 2E C9     .I
STA &0305,X      :\ 9B88= 9D 05 03    ...
TYA              :\ 9B8B= 98          .
STA &0304,X      :\ 9B8C= 9D 04 03    ...
RTS              :\ 9B8F= 60          `
 
.L9B90
LDA &0306,X      :\ 9B90= BD 06 03    =..
TAY              :\ 9B93= A8          (
CMP &0304,X      :\ 9B94= DD 04 03    ]..
LDA &0307,X      :\ 9B97= BD 07 03    =..
SBC &0305,X      :\ 9B9A= FD 05 03    }..
PHP              :\ 9B9D= 08          .
LDA &0307,X      :\ 9B9E= BD 07 03    =..
PLP              :\ 9BA1= 28          (
RTS              :\ 9BA2= 60          `
 
LDX #&28         :\ 9BA3= A2 28       "(
STX &DA          :\ 9BA5= 86 DA       .Z
LDX #&14         :\ 9BA7= A2 14       ".
LDY #&20         :\ 9BA9= A0 20         
LDA #&24         :\ 9BAB= A9 24       )$
JSR LD580        :\ 9BAD= 20 80 D5     .U
LDY #&14         :\ 9BB0= A0 14        .
LDX #&24         :\ 9BB2= A2 24       "$
JSR LD5B7        :\ 9BB4= 20 B7 D5     7U
STX L8830        :\ 9BB7= 8E 30 88    .0.
LDX #&20         :\ 9BBA= A2 20       " 
JSR LD5B7        :\ 9BBC= 20 B7 D5     7U
STX L8831        :\ 9BBF= 8E 31 88    .1.
LDX #&28         :\ 9BC2= A2 28       "(
JSR LD5B7        :\ 9BC4= 20 B7 D5     7U
STY L8833        :\ 9BC7= 8C 33 88    .3.
LDY L8831        :\ 9BCA= AC 31 88    ,1.
JSR LD5B7        :\ 9BCD= 20 B7 D5     7U
STY L8832        :\ 9BD0= 8C 32 88    .2.
LDY L8830        :\ 9BD3= AC 30 88    ,0.
JSR L9C0F        :\ 9BD6= 20 0F 9C     ..
LDA L8833        :\ 9BD9= AD 33 88    -3.
STA &E0          :\ 9BDC= 85 E0       .`
LDX #&2C         :\ 9BDE= A2 2C       ",
JSR L9B09        :\ 9BE0= 20 09 9B     ..
LDY &E1          :\ 9BE3= A4 E1       $a
JSR L9C56        :\ 9BE5= 20 56 9C     V.
LDY L8832        :\ 9BE8= AC 32 88    ,2.
LDA L8833        :\ 9BEB= AD 33 88    -3.
STA &E1          :\ 9BEE= 85 E1       .a
LDX #&37         :\ 9BF0= A2 37       "7
JSR L9C51        :\ 9BF2= 20 51 9C     Q.
BRA L9C0C        :\ 9BF5= 80 15       ..
 
LDY #&14         :\ 9BF7= A0 14        .
LDX #&24         :\ 9BF9= A2 24       "$
JSR LD5B7        :\ 9BFB= 20 B7 D5     7U
STY L8832        :\ 9BFE= 8C 32 88    .2.
LDY #&20         :\ 9C01= A0 20         
JSR L9C0F        :\ 9C03= 20 0F 9C     ..
LDA L8832        :\ 9C06= AD 32 88    -2.
JSR L9C4D        :\ 9C09= 20 4D 9C     M.
.L9C0C
JMP LDAE4        :\ 9C0C= 4C E4 DA    LdZ
 
.L9C0F
JSR LD5B7        :\ 9C0F= 20 B7 D5     7U
STX L8830        :\ 9C12= 8E 30 88    .0.
LDX L8832        :\ 9C15= AE 32 88    .2.
JSR LD5B7        :\ 9C18= 20 B7 D5     7U
STY L8832        :\ 9C1B= 8C 32 88    .2.
STX L8831        :\ 9C1E= 8E 31 88    .1.
LDY L8830        :\ 9C21= AC 30 88    ,0.
LDX #&FC         :\ 9C24= A2 FC       "|
.L9C26
LDA &0300,Y      :\ 9C26= B9 00 03    9..
STA &0246,X      :\ 9C29= 9D 46 02    .F.
STA &024A,X      :\ 9C2C= 9D 4A 02    .J.
INY              :\ 9C2F= C8          H
INX              :\ 9C30= E8          h
BNE L9C26        :\ 9C31= D0 F3       Ps
LDY L8830        :\ 9C33= AC 30 88    ,0.
LDA L8832        :\ 9C36= AD 32 88    -2.
STA &E1          :\ 9C39= 85 E1       .a
LDX #&37         :\ 9C3B= A2 37       "7
JSR L9B09        :\ 9C3D= 20 09 9B     ..
LDY L8830        :\ 9C40= AC 30 88    ,0.
LDA L8831        :\ 9C43= AD 31 88    -1.
JSR L9C4D        :\ 9C46= 20 4D 9C     M.
LDY L8831        :\ 9C49= AC 31 88    ,1.
RTS              :\ 9C4C= 60          `
 
.L9C4D
STA &E0          :\ 9C4D= 85 E0       .`
LDX #&2C         :\ 9C4F= A2 2C       ",
.L9C51
JSR L9B09        :\ 9C51= 20 09 9B     ..
LDY &E0          :\ 9C54= A4 E0       $`
.L9C56
PHY              :\ 9C56= 5A          Z
LDA &0302,Y      :\ 9C57= B9 02 03    9..
CMP &0344        :\ 9C5A= CD 44 03    MD.
BNE L9C67        :\ 9C5D= D0 08       P.
LDA &0303,Y      :\ 9C5F= B9 03 03    9..
CMP &0345        :\ 9C62= CD 45 03    ME.
BEQ L9CA0        :\ 9C65= F0 39       p9
.L9C67
LDX #&2C         :\ 9C67= A2 2C       ",
JSR L9CC0        :\ 9C69= 20 C0 9C     @.
LDX #&37         :\ 9C6C= A2 37       "7
JSR L9CC0        :\ 9C6E= 20 C0 9C     @.
JSR LDAE4        :\ 9C71= 20 E4 DA     dZ
LDX #&37         :\ 9C74= A2 37       "7
JSR LD726        :\ 9C76= 20 26 D7     &W
LDX #&2C         :\ 9C79= A2 2C       ",
JSR LD726        :\ 9C7B= 20 26 D7     &W
LDY #&37         :\ 9C7E= A0 37        7
JSR LD5CC        :\ 9C80= 20 CC D5     LU
PHX              :\ 9C83= DA          Z
LDX #&FC         :\ 9C84= A2 FC       "|
.L9C86
LDA &0300,Y      :\ 9C86= B9 00 03    9..
STA &024A,X      :\ 9C89= 9D 4A 02    .J.
INY              :\ 9C8C= C8          H
INX              :\ 9C8D= E8          h
BNE L9C86        :\ 9C8E= D0 F6       Pv
PLX              :\ 9C90= FA          z
LDY #&FC         :\ 9C91= A0 FC        |
.L9C93
LDA &0300,X      :\ 9C93= BD 00 03    =..
STA &0246,Y      :\ 9C96= 99 46 02    .F.
INX              :\ 9C99= E8          h
INY              :\ 9C9A= C8          H
BNE L9C93        :\ 9C9B= D0 F6       Pv
PLY              :\ 9C9D= 7A          z
BRA L9C56        :\ 9C9E= 80 B6       .6
 
.L9CA0
LDA #&2C         :\ 9CA0= A9 2C       ),
LDX &E0          :\ 9CA2= A6 E0       &`
JSR L9CAC        :\ 9CA4= 20 AC 9C     ,.
PLY              :\ 9CA7= 7A          z
LDA #&37         :\ 9CA8= A9 37       )7
LDX &E1          :\ 9CAA= A6 E1       &a
.L9CAC
STA &DE          :\ 9CAC= 85 DE       .^
LDA &0302,X      :\ 9CAE= BD 02 03    =..
CMP &0302,Y      :\ 9CB1= D9 02 03    Y..
BNE L9CBE        :\ 9CB4= D0 08       P.
LDA &0303,X      :\ 9CB6= BD 03 03    =..
CMP &0303,Y      :\ 9CB9= D9 03 03    Y..
BEQ L9CC3        :\ 9CBC= F0 05       p.
.L9CBE
LDX &DE          :\ 9CBE= A6 DE       &^
.L9CC0
JSR LD71D        :\ 9CC0= 20 1D D7     .W
.L9CC3
LDA &0300,X      :\ 9CC3= BD 00 03    =..
CMP &0342        :\ 9CC6= CD 42 03    MB.
LDA &0301,X      :\ 9CC9= BD 01 03    =..
SBC &0343        :\ 9CCC= ED 43 03    mC.
BPL L9CDE        :\ 9CCF= 10 0D       ..
LDA &0300,X      :\ 9CD1= BD 00 03    =..
STA &0342        :\ 9CD4= 8D 42 03    .B.
LDA &0301,X      :\ 9CD7= BD 01 03    =..
STA &0343        :\ 9CDA= 8D 43 03    .C.
RTS              :\ 9CDD= 60          `
 
.L9CDE
LDA &0346        :\ 9CDE= AD 46 03    -F.
CMP &0300,X      :\ 9CE1= DD 00 03    ]..
LDA &0347        :\ 9CE4= AD 47 03    -G.
SBC &0301,X      :\ 9CE7= FD 01 03    }..
BPL L9CF8        :\ 9CEA= 10 0C       ..
LDA &0300,X      :\ 9CEC= BD 00 03    =..
STA &0346        :\ 9CEF= 8D 46 03    .F.
LDA &0301,X      :\ 9CF2= BD 01 03    =..
STA &0347        :\ 9CF5= 8D 47 03    .G.
.L9CF8
RTS              :\ 9CF8= 60          `
 
JSR LDDA1        :\ 9CF9= 20 A1 DD     !]
STZ &0336        :\ 9CFC= 9C 36 03    .6.
STZ &0337        :\ 9CFF= 9C 37 03    .7.
JSR LDCB0        :\ 9D02= 20 B0 DC     0\
BNE L9D56        :\ 9D05= D0 4F       PO
JSR LDC1C        :\ 9D07= 20 1C DC     .\
.L9D0A
BIT &FF          :\ 9D0A= 24 FF       $.
BMI L9D56        :\ 9D0C= 30 48       0H
LDA &0336        :\ 9D0E= AD 36 03    -6.
CMP &0337        :\ 9D11= CD 37 03    M7.
BEQ L9D56        :\ 9D14= F0 40       p@
INC A            :\ 9D16= 1A          .
STA &0336        :\ 9D17= 8D 36 03    .6.
TAX              :\ 9D1A= AA          *
LDA L8400,X      :\ 9D1B= BD 00 84    =..
STA &0328        :\ 9D1E= 8D 28 03    .(.
LDA L8500,X      :\ 9D21= BD 00 85    =..
STA &032C        :\ 9D24= 8D 2C 03    .,.
LDA L8600,X      :\ 9D27= BD 00 86    =..
PHA              :\ 9D2A= 48          H
LSR A            :\ 9D2B= 4A          J
LSR A            :\ 9D2C= 4A          J
STA &0329        :\ 9D2D= 8D 29 03    .).
PLA              :\ 9D30= 68          h
AND #&03         :\ 9D31= 29 03       ).
STA &032D        :\ 9D33= 8D 2D 03    .-.
LDA L8700,X      :\ 9D36= BD 00 87    =..
STZ &032B        :\ 9D39= 9C 2B 03    .+.
CMP &0306        :\ 9D3C= CD 06 03    M..
BEQ L9D4B        :\ 9D3F= F0 0A       p.
STA &E0          :\ 9D41= 85 E0       .`
INC A            :\ 9D43= 1A          .
JSR LDC48        :\ 9D44= 20 48 DC     H\
BCS L9D56        :\ 9D47= B0 0D       0.
LDA &E0          :\ 9D49= A5 E0       %`
.L9D4B
CMP &0302        :\ 9D4B= CD 02 03    M..
BEQ L9D0A        :\ 9D4E= F0 BA       p:
DEC A            :\ 9D50= 3A          :
JSR LDC48        :\ 9D51= 20 48 DC     H\
BCC L9D0A        :\ 9D54= 90 B4       .4
.L9D56
RTS              :\ 9D56= 60          `
 
.L9D57
LDA &0332        :\ 9D57= AD 32 03    -2.
TAY              :\ 9D5A= A8          (
CMP &032C        :\ 9D5B= CD 2C 03    M,.
LDA &0333        :\ 9D5E= AD 33 03    -3.
TAX              :\ 9D61= AA          *
SBC &032D        :\ 9D62= ED 2D 03    m-.
BCS L9D71        :\ 9D65= B0 0A       0.
INY              :\ 9D67= C8          H
BNE L9D6B        :\ 9D68= D0 01       P.
INX              :\ 9D6A= E8          h
.L9D6B
STY &032E        :\ 9D6B= 8C 2E 03    ...
STX &032F        :\ 9D6E= 8E 2F 03    ./.
.L9D71
RTS              :\ 9D71= 60          `
 
.L9D72
CMP #&FE         :\ 9D72= C9 FE       I~
BCC L9DCC        :\ 9D74= 90 56       .V
BNE L9D8C        :\ 9D76= D0 14       P.
CPY #&00         :\ 9D78= C0 00       @.
BEQ L9DCC        :\ 9D7A= F0 50       pP
.L9D7C
BIT TUBE+0        :\ 9D7C= 2C E0 FE    ,`~
BPL L9D7C        :\ 9D7F= 10 FB       .{
LDA TUBE+1        :\ 9D81= AD E1 FE    -a~
BEQ L9DCA        :\ 9D84= F0 44       pD
JSR OSWRCH       :\ 9D86= 20 EE FF     n.
JMP L9D7C        :\ 9D89= 4C 7C 9D    L|.
 
.L9D8C
LDA #&7B         :\ 9D8C= A9 7B       ){
STA &0220        :\ 9D8E= 8D 20 02    . .
LDA #&06         :\ 9D91= A9 06       ).
STA &0221        :\ 9D93= 8D 21 02    .!.
LDA #&16         :\ 9D96= A9 16       ).
STA &0202        :\ 9D98= 8D 02 02    ...
LDA #&00         :\ 9D9B= A9 00       ).
STA &0203        :\ 9D9D= 8D 03 02    ...
LDA #&8E         :\ 9DA0= A9 8E       ).
STA TUBE+0        :\ 9DA2= 8D E0 FE    .`~
LDY #&00         :\ 9DA5= A0 00        .
.L9DA7
LDA LAB6E,Y      :\ 9DA7= B9 6E AB    9n+
STA &0400,Y      :\ 9DAA= 99 00 04    ...
LDA LAC65,Y      :\ 9DAD= B9 65 AC    9e,
STA &0500,Y      :\ 9DB0= 99 00 05    ...
LDA LAD65,Y      :\ 9DB3= B9 65 AD    9e-
STA &0600,Y      :\ 9DB6= 99 00 06    ...
DEY              :\ 9DB9= 88          .
BNE L9DA7        :\ 9DBA= D0 EB       Pk
JSR &041F        :\ 9DBC= 20 1F 04     ..
LDX #&41         :\ 9DBF= A2 41       "A
.L9DC1
LDA LAB2D,X      :\ 9DC1= BD 2D AB    =-+
STA &0016,X      :\ 9DC4= 9D 16 00    ...
DEX              :\ 9DC7= CA          J
BPL L9DC1        :\ 9DC8= 10 F7       .w

.L9DCA
LDA #&00            :\ Claim call and return

.L9DCC
CMP #&12:BNE L9DEA  :\ Jump if not SelectFS
CPY #&04:BCS L9E16  :\ Exit if not TAPE/ROM
CPY #&00:BEQ L9E16  :\ Exit if Y=0, no FS
LDX #&03:TYA        :\ X=ROMFS, A=FS number
CMP #&02:BCS L9DE3  :\ If A=2, ROMFS, jump to select it
LDX #&00:ADC #&02   :\ X=TAPE, A=speed+2
.L9DE3
ADC #&89            :\ Convert to TAPE/ROM select value
JSR LEDC0           :\ Call TAPE/ROM select routine
BRA L9DCA           :\ Jump to claim and return

.L9DEA
CMP #&06:BNE L9E17  :\ Not ErrorOccured
LDA HAZEL_WORKSPACE+&DD:BEQ L9DFC :\ Skip if ACCCON not changed
STZ HAZEL_WORKSPACE+&DD           :\ Clear ACCCON changed flag
LDA HAZEL_WORKSPACE+&DC:STA LFE34 :\ Restore ACCCON
.L9DFC
PHY              :\ 9DFC= 5A          Z
LDY HAZEL_WORKSPACE+&D4        :\ 9DFD= AC D4 DF    ,T_
BEQ L9E08        :\ 9E00= F0 06       p.
STZ HAZEL_WORKSPACE+&D4        :\ 9E02= 9C D4 DF    .T_
JSR L8F0F        :\ 9E05= 20 0F 8F     ..
.L9E08
LDY HAZEL_WORKSPACE+&D5        :\ 9E08= AC D5 DF    ,U_
BEQ L9E13        :\ 9E0B= F0 06       p.
STZ HAZEL_WORKSPACE+&D5        :\ 9E0D= 9C D5 DF    .U_
JSR L8F0F        :\ 9E10= 20 0F 8F     ..
.L9E13
PLY              :\ 9E13= 7A          z
LDA #&06         :\ 9E14= A9 06       ).
.L9E16
RTS              :\ 9E16= 60          `
 
.L9E17
CMP #&26         :\ 9E17= C9 26       I&
BNE L9E38        :\ 9E19= D0 1D       P.
LDA #&8D         :\ 9E1B= A9 8D       ).
JSR L9E2C        :\ 9E1D= 20 2C 9E     ,.
LDX #&03         :\ 9E20= A2 03       ".
LDA #&04         :\ 9E22= A9 04       ).
BIT &C6          :\ 9E24= 24 C6       $F
BEQ L9E2A        :\ 9E26= F0 02       p.
LDX #&00         :\ 9E28= A2 00       ".
.L9E2A
LDA #&8C         :\ 9E2A= A9 8C       ).
.L9E2C
JSR LEDC0        :\ 9E2C= 20 C0 ED     @m
LDA #&00         :\ 9E2F= A9 00       ).
TAY              :\ 9E31= A8          (
JSR LA1F9        :\ 9E32= 20 F9 A1     y!
LDA #&26         :\ 9E35= A9 26       )&
RTS              :\ 9E37= 60          `
 
.L9E38
CMP #&09         :\ 9E38= C9 09       I.
BNE L9E8F        :\ 9E3A= D0 53       PS
PHY              :\ 9E3C= 5A          Z
LDA (&F2),Y      :\ 9E3D= B1 F2       1r
CMP #&0D         :\ 9E3F= C9 0D       I.
BNE L9E61        :\ 9E41= D0 1E       P.
JSR L9EFC        :\ 9E43= 20 FC 9E     |.
JSR LA958        :\ 9E46= 20 58 A9     X)
JSR &4D20        :\ 9E49= 20 20 4D      M
EQUB &4F         :\ 9E4C= 4F          O
EQUB &53         :\ 9E4D= 53          S
ORA &540D        :\ 9E4E= 0D 0D 54    ..T
EOR &52          :\ 9E51= 45 52       ER
EOR &4E49        :\ 9E53= 4D 49 4E    MIN
EOR (&4C,X)      :\ 9E56= 41 4C       AL
JSR &2E31        :\ 9E58= 20 31 2E     1.
AND (&30)        :\ 9E5B= 32 30       20
ORA L8000        :\ 9E5D= 0D 00 80    ...
ROL A            :\ 9E60= 2A          *
.L9E61
LDX #&02         :\ 9E61= A2 02       ".
.L9E63
LDA (&F2),Y      :\ 9E63= B1 F2       1r
CMP #&2E         :\ 9E65= C9 2E       I.
BEQ L9E95        :\ 9E67= F0 2C       p,
AND #&DF         :\ 9E69= 29 DF       )_
CMP L9E92,X      :\ 9E6B= DD 92 9E    ]..
BNE L9E7B        :\ 9E6E= D0 0B       P.
INY              :\ 9E70= C8          H
DEX              :\ 9E71= CA          J
BPL L9E63        :\ 9E72= 10 EF       .o
LDA (&F2),Y      :\ 9E74= B1 F2       1r
JSR LEA71        :\ 9E76= 20 71 EA     qj
BCS L9E95        :\ 9E79= B0 1A       0.
.L9E7B
LDA (&F2),Y      :\ 9E7B= B1 F2       1r
CMP #&0D         :\ 9E7D= C9 0D       I.
BEQ L9E8B        :\ 9E7F= F0 0A       p.
INY              :\ 9E81= C8          H
CMP #&20         :\ 9E82= C9 20       I 
BNE L9E7B        :\ 9E84= D0 F5       Pu
JSR LF2FF        :\ 9E86= 20 FF F2     .r
BNE L9E61        :\ 9E89= D0 D6       PV
.L9E8B
PLY              :\ 9E8B= 7A          z
LDA #&09         :\ 9E8C= A9 09       ).
RTS              :\ 9E8E= 60          `
 
.L9E8F
JMP LAE19        :\ 9E8F= 4C 19 AE    L..
 
.L9E92
EQUS "SOM"
; EQUB &53         :\ 9E92= 53          S
; EQUB &4F         :\ 9E93= 4F          O
; EOR LFC20        :\ 9E94= 4D 20 FC    M |
; STZ &68A9,X      :\ 9E97= 9E A9 68    .)h

.L9E95
JSR L9EFC	 :\ 9E95= 20 FC 9E
LDA #&68	 :\ 9E98= A9 68
STA &B0          :\ 9E9A= 85 B0       .0
LDA #&83         :\ 9E9C= A9 83       ).
STA &B1          :\ 9E9E= 85 B1       .1
.L9EA0
LDA (&B0)        :\ 9EA0= B2 B0       20
BMI L9EF4        :\ 9EA2= 30 50       0P
JSR L9F0C        :\ 9EA4= 20 0C 9F     ..
JSR L9F0C        :\ 9EA7= 20 0C 9F     ..
LDA (&B0)        :\ 9EAA= B2 B0       20
.L9EAC
JSR L9F0E        :\ 9EAC= 20 0E 9F     ..
INC &B0          :\ 9EAF= E6 B0       f0
BNE L9EB5        :\ 9EB1= D0 02       P.
INC &B1          :\ 9EB3= E6 B1       f1
.L9EB5
LDA (&B0)        :\ 9EB5= B2 B0       20
BPL L9EAC        :\ 9EB7= 10 F3       .s
LDA #&04         :\ 9EB9= A9 04       ).
CLC              :\ 9EBB= 18          .
ADC &B0          :\ 9EBC= 65 B0       e0
STA &B0          :\ 9EBE= 85 B0       .0
BCC L9EC4        :\ 9EC0= 90 02       ..
INC &B1          :\ 9EC2= E6 B1       f1
.L9EC4
JSR LE25C        :\ 9EC4= 20 5C E2     \b
CPX #&13         :\ 9EC7= E0 13       `.
BEQ L9EEF        :\ 9EC9= F0 24       p$
.L9ECB
JSR LE252        :\ 9ECB= 20 52 E2     Rb
TXA              :\ 9ECE= 8A          .
BEQ L9EA0        :\ 9ECF= F0 CF       pO
CPX #&14         :\ 9ED1= E0 14       `.
BEQ L9EA0        :\ 9ED3= F0 CB       pK
BCC L9EE4        :\ 9ED5= 90 0D       ..
CPX #&28         :\ 9ED7= E0 28       `(
BEQ L9EA0        :\ 9ED9= F0 C5       pE
BCS L9EE9        :\ 9EDB= B0 0C       0.
JSR LE25C        :\ 9EDD= 20 5C E2     \b
CPX #&27         :\ 9EE0= E0 27       `'
BEQ L9EEF        :\ 9EE2= F0 0B       p.
.L9EE4
JSR L9F0C        :\ 9EE4= 20 0C 9F     ..
BRA L9ECB        :\ 9EE7= 80 E2       .b
 
.L9EE9
CPX #&3C         :\ 9EE9= E0 3C       `<
BCC L9EE4        :\ 9EEB= 90 F7       .w
BEQ L9EA0        :\ 9EED= F0 B1       p1
.L9EEF
JSR L9F1E        :\ 9EEF= 20 1E 9F     ..
BRA L9EA0        :\ 9EF2= 80 AC       .,
 
.L9EF4
JSR LE252        :\ 9EF4= 20 52 E2     Rb
TXA              :\ 9EF7= 8A          .
BEQ L9E8B        :\ 9EF8= F0 91       p.
BRA L9EEF        :\ 9EFA= 80 F3       .s
 
.L9EFC
PHY              :\ 9EFC= 5A          Z
JSR LA958        :\ 9EFD= 20 58 A9     X)
ORA &534F        :\ 9F00= 0D 4F 53    .OS
JSR &2E33        :\ 9F03= 20 33 2E     3.
AND (&30)        :\ 9F06= 32 30       20
ORA &7A00        :\ 9F08= 0D 00 7A    ..z
RTS              :\ 9F0B= 60          `
 
.L9F0C
LDA #&20         :\ 9F0C= A9 20       ) 
.L9F0E
PHX              :\ 9F0E= DA          Z
LDX &B0          :\ 9F0F= A6 B0       &0
PHX              :\ 9F11= DA          Z
LDX &B1          :\ 9F12= A6 B1       &1
JSR OSWRCH       :\ 9F14= 20 EE FF     n.
.L9F17
STX &B1          :\ 9F17= 86 B1       .1
PLX              :\ 9F19= FA          z
STX &B0          :\ 9F1A= 86 B0       .0
PLX              :\ 9F1C= FA          z
RTS              :\ 9F1D= 60          `
 
.L9F1E
PHX              :\ 9F1E= DA          Z
LDX &B0          :\ 9F1F= A6 B0       &0
PHX              :\ 9F21= DA          Z
LDX &B1          :\ 9F22= A6 B1       &1
JSR OSNEWL       :\ 9F24= 20 E7 FF     g.
BRA L9F17        :\ 9F27= 80 EE       .n

\ TAPE/ROM OSARGS handler
\ =======================
.L9F29
CPY #&00:BNE L9F3B  :\ Handle<>0 - read/write open file info
ORA #&00:BNE L9F3A  :\ A<>0 - read/write filing system info - exit

\ A=0, Y=0 - read current filing system
\ -------------------------------------
LDA #&03            :\ Prepare A=ROMFS
BIT &0247:BNE L9F3A :\ If TAPE/ROM switch
AND &C6             :\ Mask with speed to give A=2 or A=1
.L9F3A
RTS        

\ OSARGS handle<>0 - red/write open file info
\ -------------------------------------------
.L9F3B
CMP #&00:BNE L9F3A  :\ Not =PTR, exit unsupported
CPY #&02:BEQ L9F60  :\ =PTR#2 - read PTR on output handle

\ Read PTR on CFS/RFS input file
\ ------------------------------
LDA #&01:JSR LAA68  :\ Check if this is input channel and is open
LDA &039E:STA &00,X
PHY              :\ 9F4D= 5A          Z
LDA &03DE        :\ 9F4E= AD DE 03    -^.
LDY &03DD        :\ 9F51= AC DD 03    ,].
BNE L9F57        :\ 9F54= D0 01       P.
DEC A            :\ 9F56= 3A          :
.L9F57
DEY              :\ 9F57= 88          .
STY &01,X        :\ 9F58= 94 01       ..
PLY              :\ 9F5A= 7A          z
.L9F5B
STA &02,X        :\ 9F5B= 95 02       ..
STZ &03,X        :\ 9F5D= 74 03       t.
RTS              :\ 9F5F= 60          `

\ Read PTR on TAPE output file
\ ----------------------------
.L9F60
LDA #&02:JSR LAA68  :\ Check if this is output channel and is open
LDA &039D:STA &00,X :\ Copy PTR to control block
LDA &0394:STA &01,X  
LDA &0395:BRA L9F5B

\ TAPE/ROM FSC dispatch table
\ ---------------------------
.L9F74
AND (&F0,X)      :\ 9F74= 21 F0       !p
EQUB &0F         :\ 9F76= 0F          .
PLP              :\ 9F77= 28          (
EQUB &0F         :\ 9F78= 0F          .
EQUB &67         :\ 9F79= 67          g
AND &399D,Y      :\ 9F7A= 39 9D 39    9.9
EQUB &54         :\ 9F7D= 54          T
\AND LA412,Y      :\ 9F7E= 39 12 A4    9.$
EQUB &39:EQUB &12
.L9F80
EQUB &A4
LDY &A1          :\ 9F81= A4 A1       $!
LDA (&A1,X)      :\ 9F83= A1 A1       !!
LDA (&9F,X)      :\ 9F85= A1 9F       !.
EQUB &9F         :\ 9F87= 9F          .
EQUB &9F         :\ 9F88= 9F          .
LDA (&9F,X)      :\ 9F89= A1 9F       !.
LDA (&C9,X)      :\ 9F8B= A1 C9       !I

\ TAPE/ROM FSC
\ ============
.L9F8C
CMP #&0C:BCS L9F3A  :\ function<12 - exit unchanged
STX &BC:TAX         :\ Index into dispatch table
LDA L9F80,X:PHA
LDA L9F74,X:PHA
LDX &BC:RTS

.L9F9E
LDX #&03         :\ 9F9E= A2 03       ".
LDY #&03         :\ 9FA0= A0 03        .
LDA &0247        :\ 9FA2= AD 47 02    -G.
BNE L9F3A        :\ 9FA5= D0 93       P.
DEY              :\ 9FA7= 88          .
LDX #&01         :\ 9FA8= A2 01       ".
RTS              :\ 9FAA= 60          `
 
.L9FAB
PLA              :\ 9FAB= 68          h
PLP              :\ 9FAC= 28          (
SEC              :\ 9FAD= 38          8
RTS              :\ 9FAE= 60          `
 
.L9FAF
PHP              :\ 9FAF= 08          .
PHA              :\ 9FB0= 48          H
JSR LA9F3        :\ 9FB1= 20 F3 A9     s)
LDA &03C2        :\ 9FB4= AD C2 03    -B.
PHA              :\ 9FB7= 48          H
JSR LA502        :\ 9FB8= 20 02 A5     .%
PLA              :\ 9FBB= 68          h
BCS L9FAB        :\ 9FBC= B0 ED       0m
BEQ L9FD9        :\ 9FBE= F0 19       p.
LDX #&03         :\ 9FC0= A2 03       ".
LDA #&FF         :\ 9FC2= A9 FF       ).
.L9FC4
PHA              :\ 9FC4= 48          H
LDA &03BE,X      :\ 9FC5= BD BE 03    =>.
STA &B0,X        :\ 9FC8= 95 B0       .0
PLA              :\ 9FCA= 68          h
AND &B0,X        :\ 9FCB= 35 B0       50
DEX              :\ 9FCD= CA          J
BPL L9FC4        :\ 9FCE= 10 F4       .t
INC A            :\ 9FD0= 1A          .
BNE L9FD9        :\ 9FD1= D0 06       P.
JSR LA9B1        :\ 9FD3= 20 B1 A9     1)
JMP L934B        :\ 9FD6= 4C 4B 93    LK.
 
.L9FD9
LDA &03CA        :\ 9FD9= AD CA 03    -J.
LSR A            :\ 9FDC= 4A          J
PLA              :\ 9FDD= 68          h
PHA              :\ 9FDE= 48          H
BEQ L9FF1        :\ 9FDF= F0 10       p.
BCC L9FF8        :\ 9FE1= 90 15       ..
.L9FE3
JSR LA9BB        :\ 9FE3= 20 BB A9     ;)
JSR LAAED        :\ 9FE6= 20 ED AA     m*
CMP &4C,X        :\ 9FE9= D5 4C       UL
EQUB &6F         :\ 9FEB= 6F          o
EQUB &63         :\ 9FEC= 63          c
EQUB &6B         :\ 9FED= 6B          k
ADC &64          :\ 9FEE= 65 64       ed
BRK              :\ 9FF0= 00          .
.L9FF1
BCC L9FF8        :\ 9FF1= 90 05       ..
LDA #&03         :\ 9FF3= A9 03       ).
STA &0258        :\ 9FF5= 8D 58 02    .X.
.L9FF8
LDA #&30         :\ 9FF8= A9 30       )0
AND &BB          :\ 9FFA= 25 BB       %;
BEQ LA002        :\ 9FFC= F0 04       p.
LDA &C1          :\ 9FFE= A5 C1       %A
.LA000
BNE LA00A        :\ A000= D0 08       P.
.LA002
PHY              :\ A002= 5A          Z
JSR LAAA4        :\ A003= 20 A4 AA     $*
PLY              :\ A006= 7A          z
JSR LA6D2        :\ A007= 20 D2 A6     R&
.LA00A
JSR LA8A1        :\ A00A= 20 A1 A8     !(
BNE LA066        :\ A00D= D0 57       PW
JSR LAA35        :\ A00F= 20 35 AA     5*
BIT &03CA        :\ A012= 2C CA 03    ,J.
BMI LA01F        :\ A015= 30 08       0.
JSR LA85B        :\ A017= 20 5B A8     [(
JSR LA678        :\ A01A= 20 78 A6     x&
BRA L9FF8        :\ A01D= 80 D9       .Y
 
.LA01F
PLA:BEQ LA055            :\ RUN, no control block to update
LDY #&02
.LA024
LDA &03BC,Y:STA (&C8),Y  :\ Copy load/exec to control block
INY:CPY #&0A:BNE LA024
LDA &03C8:STA (&C8),Y    :\ Length b0-b7=Block Length b0-b7
INY:LDA &03C9:CLC
ADC &03C6:STA (&C8),Y    :\ Length b8-b15=Block Number+Block Length b8-b15
INY:LDA #&00
ADC &03C7:STA (&C8),Y    :\ Length b16-b23=overflow
INY:LDA #&00:STA (&C8),Y :\ Length b24-b31=&00
INY
.LA04B
LDA &03BD,Y:STA (&C8),Y  :\ Attrs=&00000000
INY:CPY #&12:BNE LA04B
:
.LA055
PLP
.LA056
JSR LA9B1
.LA059
BIT &BA:BMI LA064        :\ If flag set, skip printing newline
.LA05D
PHP:JSR LA923            :\ Print inline text
EQUB 13:EQUB 0           :\ Could just do JSR OSNEWL
PLP
.LA064
CLC:RTS

.LA066
JSR LA506        :\ A066= 20 06 A5     .%
BNE L9FF8        :\ A069= D0 8D       P.
.LA06B
STX &F2          :\ A06B= 86 F2       .r
STY &F3          :\ A06D= 84 F3       .s
LDY #&00         :\ A06F= A0 00        .
JSR LF26D        :\ A071= 20 6D F2     mr
LDX #&00         :\ A074= A2 00       ".
.LA076
JSR LF27F        :\ A076= 20 7F F2     .r
BCS LA088        :\ A079= B0 0D       0.
BEQ LA085        :\ A07B= F0 08       p.
STA &03D2,X      :\ A07D= 9D D2 03    .R.
INX              :\ A080= E8          h
CPX #&0B         :\ A081= E0 0B       `.
BNE LA076        :\ A083= D0 F1       Pq
.LA085
JMP LF28F        :\ A085= 4C 8F F2    L.r
 
.LA088
STZ &03D2,X      :\ A088= 9E D2 03    .R.
RTS              :\ A08B= 60          `

\ CFS/RFS OSFILE
\ ==============
.LA08C
PHA
STX &C8:STY &C9     :\ C8/9=>control block
LDA (&C8):TAX       :\ Get XY=>filename
LDY #&01
LDA (&C8),Y:TAY
JSR LA06B           :\ Parse filename
LDY #&02
.LA09E
LDA (&C8),Y      :\ A09E= B1 C8       1H
STA &03BC,Y      :\ A0A0= 99 BC 03    .<.
STA &00AE,Y      :\ A0A3= 99 AE 00    ...
INY              :\ A0A6= C8          H
CPY #&0A         :\ A0A7= C0 0A       @.
BNE LA09E        :\ A0A9= D0 F3       Ps
PLA              :\ A0AB= 68          h
BEQ LA0B5        :\ A0AC= F0 07       p.
CMP #&FF         :\ A0AE= C9 FF       I.
BNE LA064        :\ A0B0= D0 B2       P2
JMP L9FAF        :\ A0B2= 4C AF 9F    L/.
 
.LA0B5
STA &03C6        :\ A0B5= 8D C6 03    .F.
STA &03C7        :\ A0B8= 8D C7 03    .G.
.LA0BB
LDA (&C8),Y      :\ A0BB= B1 C8       1H
STA &00A6,Y      :\ A0BD= 99 A6 00    .&.
INY              :\ A0C0= C8          H
CPY #&12         :\ A0C1= C0 12       @.
BNE LA0BB        :\ A0C3= D0 F6       Pv
TXA              :\ A0C5= 8A          .
BEQ LA085        :\ A0C6= F0 BD       p=
JSR LA9F3        :\ A0C8= 20 F3 A9     s)
JSR LA822        :\ A0CB= 20 22 A8     "(
LDA #&00         :\ A0CE= A9 00       ).
JSR LAAA6        :\ A0D0= 20 A6 AA     &*
.LA0D3
SEC              :\ A0D3= 38          8
LDX #&FD         :\ A0D4= A2 FD       "}  -3
.LA0D6
LDA &FFB7,X      :\ A0D6= BD B7 FF    =7.
SBC &FFB3,X      :\ A0D9= FD B3 FF    }3.
STA &02CB,X      :\ A0DC= 9D CB 02    .K.
INX              :\ A0DF= E8          h
BNE LA0D6        :\ A0E0= D0 F4       Pt
TAY              :\ A0E2= A8          (
BNE LA0F3        :\ A0E3= D0 0E       P.
CPX &03C8        :\ A0E5= EC C8 03    lH.
LDA #&01         :\ A0E8= A9 01       ).
SBC &03C9        :\ A0EA= ED C9 03    mI.
BCC LA0F3        :\ A0ED= 90 04       ..
LDX #&80         :\ A0EF= A2 80       ".
BRA LA0FB        :\ A0F1= 80 08       ..
 
.LA0F3
LDA #&01         :\ A0F3= A9 01       ).
STA &03C9        :\ A0F5= 8D C9 03    .I.
STX &03C8        :\ A0F8= 8E C8 03    .H.
.LA0FB
STX &03CA        :\ A0FB= 8E CA 03    .J.
JSR LA6E9        :\ A0FE= 20 E9 A6     i&
BMI LA17B        :\ A101= 30 78       0x
JSR LA85B        :\ A103= 20 5B A8     [(
INC &03C6        :\ A106= EE C6 03    nF.
BNE LA0D3        :\ A109= D0 C8       PH
INC &03C7        :\ A10B= EE C7 03    nG.
BRA LA0D3        :\ A10E= 80 C3       .C
 
SEC              :\ A110= 38          8
ROR &CE          :\ A111= 66 CE       fN
PHX              :\ A113= DA          Z
PHY              :\ A114= 5A          Z
JSR LA06B        :\ A115= 20 6B A0     k 
LDA #&00         :\ A118= A9 00       ).
LDX #&FF         :\ A11A= A2 FF       ".
STX &03C2        :\ A11C= 8E C2 03    .B.
JSR L9FAF        :\ A11F= 20 AF 9F     /.
PLY              :\ A122= 7A          z
PLX              :\ A123= FA          z
BCC LA12E        :\ A124= 90 08       ..
JSR LA9CA        :\ A126= 20 CA A9     J)
LDA #&0B         :\ A129= A9 0B       ).
JMP (&021E)      :\ A12B= 6C 1E 02    l..
 
.LA12E
BIT &027A        :\ A12E= 2C 7A 02    ,z.
BPL LA13C        :\ A131= 10 09       ..
LDA &03C4        :\ A133= AD C4 03    -D.
AND &03C5        :\ A136= 2D C5 03    -E.
INC A            :\ A139= 1A          .
BNE LA14C        :\ A13A= D0 10       P.
.LA13C
LDX &03C2        :\ A13C= AE C2 03    .B.
LDY &03C3        :\ A13F= AC C3 03    ,C.
LDA #&A4         :\ A142= A9 A4       )$
JSR OSBYTE       :\ A144= 20 F4 FF     t.
LDA #&01         :\ A147= A9 01       ).
JMP (&03C2)      :\ A149= 6C C2 03    lB.
 
.LA14C
LDX #&C2         :\ A14C= A2 C2       "B
LDY #&03         :\ A14E= A0 03        .
LDA #&04         :\ A150= A9 04       ).
JMP LAAB0        :\ A152= 4C B0 AA    L0*
 
LDA #&08         :\ A155= A9 08       ).
TSB &E2          :\ A157= 04 E2       .b
LDA &E3          :\ A159= A5 E3       %c
PHA              :\ A15B= 48          H
ORA #&CC         :\ A15C= 09 CC       .L
STA &E3          :\ A15E= 85 E3       .c
JSR LA9F3        :\ A160= 20 F3 A9     s)
PLA              :\ A163= 68          h
STA &E3          :\ A164= 85 E3       .c
BRA LA16F        :\ A166= 80 07       ..
 
LDA #&08         :\ A168= A9 08       ).
TSB &E2          :\ A16A= 04 E2       .b
JSR LA9F3        :\ A16C= 20 F3 A9     s)
.LA16F
LDA #&00         :\ A16F= A9 00       ).
JSR LA17C        :\ A171= 20 7C A1     |!
JSR LA9CA        :\ A174= 20 CA A9     J)
.LA177
LDA #&08         :\ A177= A9 08       ).
TRB &E2          :\ A179= 14 E2       .b
.LA17B
RTS              :\ A17B= 60          `
 
.LA17C
PHA              :\ A17C= 48          H
LDA &0247        :\ A17D= AD 47 02    -G.
BEQ LA18B        :\ A180= F0 09       p.
JSR LF6FC        :\ A182= 20 FC F6     |v
JSR LF701        :\ A185= 20 01 F7     .w
CLV              :\ A188= B8          8
BCS LA1DB        :\ A189= B0 50       0P
.LA18B
JSR LA678        :\ A18B= 20 78 A6     x&
LDA &03C6        :\ A18E= AD C6 03    -F.
STA &B4          :\ A191= 85 B4       .4
LDA &03C7        :\ A193= AD C7 03    -G.
STA &B5          :\ A196= 85 B5       .5
LDX #&FF         :\ A198= A2 FF       ".
STX &03DF        :\ A19A= 8E DF 03    ._.
STZ &BA          :\ A19D= 64 BA       d:
BRA LA1B7        :\ A19F= 80 16       ..
 
.LA1A1
LDA &0247        :\ A1A1= AD 47 02    -G.
BEQ LA1DD        :\ A1A4= F0 37       p7
.LA1A6
JSR LF717        :\ A1A6= 20 17 F7     .w
.LA1A9
LDA #&FF         :\ A1A9= A9 FF       ).
STA &03C6        :\ A1AB= 8D C6 03    .F.
STA &03C7        :\ A1AE= 8D C7 03    .G.
.LA1B1
JSR LAA35        :\ A1B1= 20 35 AA     5*
JSR LA678        :\ A1B4= 20 78 A6     x&
.LA1B7
LDA &0247        :\ A1B7= AD 47 02    -G.
BEQ LA1BE        :\ A1BA= F0 02       p.
BVC LA1DB        :\ A1BC= 50 1D       P.
.LA1BE
PLA              :\ A1BE= 68          h
PHA              :\ A1BF= 48          H
BEQ LA1DD        :\ A1C0= F0 1B       p.
JSR LA95C        :\ A1C2= 20 5C A9     \)
BNE LA1A1        :\ A1C5= D0 DA       PZ
LDA #&30         :\ A1C7= A9 30       )0
AND &BB          :\ A1C9= 25 BB       %;
BEQ LA1DB        :\ A1CB= F0 0E       p.
LDA &03C6        :\ A1CD= AD C6 03    -F.
CMP &B6          :\ A1D0= C5 B6       E6
BNE LA1A1        :\ A1D2= D0 CD       PM
LDA &03C7        :\ A1D4= AD C7 03    -G.
CMP &B7          :\ A1D7= C5 B7       E7
BNE LA1A1        :\ A1D9= D0 C6       PF
.LA1DB
PLA              :\ A1DB= 68          h
RTS              :\ A1DC= 60          `
 
.LA1DD
BVC LA1E4        :\ A1DD= 50 05       P.
LDA #&FF         :\ A1DF= A9 FF       ).
JSR LA6D4        :\ A1E1= 20 D4 A6     T&
.LA1E4
LDX #&00         :\ A1E4= A2 00       ".
JSR LA8C4        :\ A1E6= 20 C4 A8     D(
LDA &0247        :\ A1E9= AD 47 02    -G.
BEQ LA1F2        :\ A1EC= F0 04       p.
BIT &BB          :\ A1EE= 24 BB       $;
BVC LA1A6        :\ A1F0= 50 B4       P4
.LA1F2
BIT &03CA        :\ A1F2= 2C CA 03    ,J.
BMI LA1A9        :\ A1F5= 30 B2       02
BRA LA1B1        :\ A1F7= 80 B8       .8

\ CFS/RFS OSFIND HANDLER
\ ====================== 
.LA1F9
STA &BC          :\ A1F9= 85 BC       .<
PHX              :\ A1FB= DA          Z
PHY              :\ A1FC= 5A          Z
ORA #&00         :\ A1FD= 09 00       ..
BNE LA220        :\ A1FF= D0 1F       P.
TYA              :\ A201= 98          .
BNE LA212        :\ A202= D0 0E       P.
LDA &0247        :\ A204= AD 47 02    -G.
BNE LA20C        :\ A207= D0 03       P.
JSR LA29C        :\ A209= 20 9C A2     ."
.LA20C
LDA #&01         :\ A20C= A9 01       ).
TRB &E2          :\ A20E= 14 E2       .b
BRA LA21E        :\ A210= 80 0C       ..
 
.LA212
LSR A            :\ A212= 4A          J
BCS LA20C        :\ A213= B0 F7       0w
LSR A            :\ A215= 4A          J
BCS LA21B        :\ A216= B0 03       0.
JMP LAA81        :\ A218= 4C 81 AA    L.*
 
.LA21B
JSR LA29C        :\ A21B= 20 9C A2     ."
.LA21E
BRA LA297        :\ A21E= 80 77       .w
 
.LA220
JSR LA06B        :\ A220= 20 6B A0     k 
BIT &BC          :\ A223= 24 BC       $<
BVC LA260        :\ A225= 50 39       P9
STZ &039E        :\ A227= 9C 9E 03    ...
STZ &03DD        :\ A22A= 9C DD 03    .].
STZ &03DE        :\ A22D= 9C DE 03    .^.
LDA #&C1         :\ A230= A9 C1       )A
TRB &E2          :\ A232= 14 E2       .b
JSR LA9E6        :\ A234= 20 E6 A9     f)
PHP              :\ A237= 08          .
JSR LA502        :\ A238= 20 02 A5     .%
JSR LA5B7        :\ A23B= 20 B7 A5     7%
PLP              :\ A23E= 28          (
LDX #&FF         :\ A23F= A2 FF       ".
.LA241
INX              :\ A241= E8          h
LDA &03B2,X      :\ A242= BD B2 03    =2.
STA &03A7,X      :\ A245= 9D A7 03    .'.
BNE LA241        :\ A248= D0 F7       Pw
INC A            :\ A24A= 1A          .
TSB &E2          :\ A24B= 04 E2       .b
LDA &02E9        :\ A24D= AD E9 02    -i.
ORA &02EA        :\ A250= 0D EA 02    .j.
BNE LA259        :\ A253= D0 04       P.
LDA #&40         :\ A255= A9 40       )@
TSB &E2          :\ A257= 04 E2       .b
.LA259
LDA #&01         :\ A259= A9 01       ).
ORA &0247        :\ A25B= 0D 47 02    .G.
BNE LA295        :\ A25E= D0 35       P5
.LA260
TXA              :\ A260= 8A          .
BNE LA266        :\ A261= D0 03       P.
JMP LF28F        :\ A263= 4C 8F F2    L.r
 
.LA266
LDX #&FF         :\ A266= A2 FF       ".
.LA268
INX              :\ A268= E8          h
LDA &03D2,X      :\ A269= BD D2 03    =R.
STA &0380,X      :\ A26C= 9D 80 03    ...
BNE LA268        :\ A26F= D0 F7       Pw
DEC A            :\ A271= 3A          :
LDX #&08         :\ A272= A2 08       ".
.LA274
STA &038B,X      :\ A274= 9D 8B 03    ...
DEX              :\ A277= CA          J
BNE LA274        :\ A278= D0 FA       Pz
TXA              :\ A27A= 8A          .
LDX #&14         :\ A27B= A2 14       ".
.LA27D
STA &0380,X      :\ A27D= 9D 80 03    ...
INX              :\ A280= E8          h
CPX #&1E         :\ A281= E0 1E       `.
BNE LA27D        :\ A283= D0 F8       Px
ROL &0397        :\ A285= 2E 97 03    ...
JSR LA9F3        :\ A288= 20 F3 A9     s)
JSR LA822        :\ A28B= 20 22 A8     "(
JSR LA9BB        :\ A28E= 20 BB A9     ;)
LDA #&02         :\ A291= A9 02       ).
TSB &E2          :\ A293= 04 E2       .b
.LA295
STA &BC          :\ A295= 85 BC       .<
.LA297
PLY              :\ A297= 7A          z
PLX              :\ A298= FA          z
LDA &BC          :\ A299= A5 BC       %<
.LA29B
RTS              :\ A29B= 60          `
 
.LA29C
LDA #&02         :\ A29C= A9 02       ).
AND &E2          :\ A29E= 25 E2       %b
BEQ LA29B        :\ A2A0= F0 F9       py
STZ &0397        :\ A2A2= 9C 97 03    ...
LDA #&80         :\ A2A5= A9 80       ).
LDX &039D        :\ A2A7= AE 9D 03    ...
STX &0396        :\ A2AA= 8E 96 03    ...
STA &0398        :\ A2AD= 8D 98 03    ...
JSR LA2B8        :\ A2B0= 20 B8 A2     8"
LDA #&02         :\ A2B3= A9 02       ).
TRB &E2          :\ A2B5= 14 E2       .b
RTS              :\ A2B7= 60          `
 
.LA2B8
JSR LA9E6        :\ A2B8= 20 E6 A9     f)
LDX #&11         :\ A2BB= A2 11       ".
.LA2BD
LDA &038C,X      :\ A2BD= BD 8C 03    =..
STA &03BE,X      :\ A2C0= 9D BE 03    .>.
DEX              :\ A2C3= CA          J
BPL LA2BD        :\ A2C4= 10 F7       .w
STX &B2          :\ A2C6= 86 B2       .2
STX &B3          :\ A2C8= 86 B3       .3
STZ &B0          :\ A2CA= 64 B0       d0
LDA #&09         :\ A2CC= A9 09       ).
STA &B1          :\ A2CE= 85 B1       .1
LDX #&7F         :\ A2D0= A2 7F       ".
JSR LAA4D        :\ A2D2= 20 4D AA     M*
STA &03DF        :\ A2D5= 8D DF 03    ._.
JSR LAA5A        :\ A2D8= 20 5A AA     Z*
JSR LAAA0        :\ A2DB= 20 A0 AA      *
JSR LA6E9        :\ A2DE= 20 E9 A6     i&
INC &0394        :\ A2E1= EE 94 03    n..
BNE LA2E9        :\ A2E4= D0 03       P.
INC &0395        :\ A2E6= EE 95 03    n..
.LA2E9
RTS              :\ A2E9= 60          `
 
.LA2EA
PHX              :\ A2EA= DA          Z
PHY              :\ A2EB= 5A          Z
LDA #&01         :\ A2EC= A9 01       ).
.LA2EE
JSR LAA68        :\ A2EE= 20 68 AA     h*
LDA &E2          :\ A2F1= A5 E2       %b
ASL A            :\ A2F3= 0A          .
BCS LA343        :\ A2F4= B0 4D       0M
ASL A            :\ A2F6= 0A          .
BCC LA301        :\ A2F7= 90 08       ..
LDA #&80         :\ A2F9= A9 80       ).
TSB &E2          :\ A2FB= 04 E2       .b
LDA #&FE         :\ A2FD= A9 FE       )~
BCS LA33B        :\ A2FF= B0 3A       0:
.LA301
LDX &039E        :\ A301= AE 9E 03    ...
INX              :\ A304= E8          h
CPX &02E9        :\ A305= EC E9 02    li.
BNE LA336        :\ A308= D0 2C       P,
BIT &02EB        :\ A30A= 2C EB 02    ,k.
BMI LA332        :\ A30D= 30 23       0#
LDA &02EC        :\ A30F= AD EC 02    -l.
PHA              :\ A312= 48          H
JSR LA9E6        :\ A313= 20 E6 A9     f)
PHP              :\ A316= 08          .
JSR LA5AF        :\ A317= 20 AF A5     /%
PLP              :\ A31A= 28          (
PLA              :\ A31B= 68          h
STA &BC          :\ A31C= 85 BC       .<
CLC              :\ A31E= 18          .
BIT &02EB        :\ A31F= 2C EB 02    ,k.
BPL LA33D        :\ A322= 10 19       ..
LDA &02E9        :\ A324= AD E9 02    -i.
ORA &02EA        :\ A327= 0D EA 02    .j.
BNE LA33D        :\ A32A= D0 11       P.
LDA #&40         :\ A32C= A9 40       )@
TSB &E2          :\ A32E= 04 E2       .b
BRA LA33D        :\ A330= 80 0B       ..
 
.LA332
LDA #&40         :\ A332= A9 40       )@
TSB &E2          :\ A334= 04 E2       .b
.LA336
DEX              :\ A336= CA          J
CLC              :\ A337= 18          .
LDA &0A00,X      :\ A338= BD 00 0A    =..
.LA33B
STA &BC          :\ A33B= 85 BC       .<
.LA33D
INC &039E        :\ A33D= EE 9E 03    n..
JMP LA297        :\ A340= 4C 97 A2    L."
 
.LA343
JSR LAAED        :\ A343= 20 ED AA     m*
EQUB &DF         :\ A346= DF          _
EOR &4F          :\ A347= 45 4F       EO
LSR &00          :\ A349= 46 00       F.
.LA34B
STA &C4          :\ A34B= 85 C4       .D
PHX              :\ A34D= DA          Z
PHY              :\ A34E= 5A          Z
LDA #&02         :\ A34F= A9 02       ).
JSR LAA68        :\ A351= 20 68 AA     h*
LDX &039D        :\ A354= AE 9D 03    ...
LDA &C4          :\ A357= A5 C4       %D
STA &0900,X      :\ A359= 9D 00 09    ...
INX              :\ A35C= E8          h
BNE LA365        :\ A35D= D0 06       P.
JSR LA2B8        :\ A35F= 20 B8 A2     8"
JSR LA9BB        :\ A362= 20 BB A9     ;)
.LA365
INC &039D        :\ A365= EE 9D 03    n..
LDA &C4          :\ A368= A5 C4       %D
JMP LA295        :\ A36A= 4C 95 A2    L."

\ TAPE/ROM OSGBPB handler
\ =======================
.LA36D
LSR A:BCS LA376     :\ Odd numbered calls - change PTR - exit with A=changed, SEC
BEQ LA376           :\ OSGBPB 0 - exit with A=unchanged, SEC
CMP #&03:BCC LA378  :\ function/2<3 - function<6 - function 2 and 4 - jump to do
.LA376
SEC:RTS
\ Call Return
\  0    A=0   SEC                        - unsupported
\  1    A=0   SEC  Write using new PTR   - unsupported
\  2    A=         Write with current PTR
\  3    A=1   SEC  Read with new PTR     - unsupported
\  4    A=         Read with current PTR
\  5+   A=A/2 SEC                        - unsupported

\ TAPE/ROM OSGBPB 2 and 4 - read/write with current PTR
\ -----------------------------------------------------
.LA378
LSR A            :\ A378= 4A          J
STX &CC          :\ A379= 86 CC       .L
STY &CD          :\ A37B= 84 CD       .M
LDY #&01         :\ A37D= A0 01        .
.LA37F
LDA (&CC),Y      :\ A37F= B1 CC       1L
STA &C8          :\ A381= 85 C8       .H
INY              :\ A383= C8          H
LDA (&CC),Y      :\ A384= B1 CC       1L
STA &C9          :\ A386= 85 C9       .I
INY              :\ A388= C8          H
LDA (&CC),Y      :\ A389= B1 CC       1L
INY              :\ A38B= C8          H
AND (&CC),Y      :\ A38C= 31 CC       1L
INC A            :\ A38E= 1A          .
AND &027A        :\ A38F= 2D 7A 02    -z.
PHA              :\ A392= 48          H
PHP              :\ A393= 08          .
BEQ LA3A7        :\ A394= F0 11       p.
LDX &CC          :\ A396= A6 CC       &L
LDY &CD          :\ A398= A4 CD       $M
INX              :\ A39A= E8          h
BNE LA39E        :\ A39B= D0 01       P.
INY              :\ A39D= C8          H
.LA39E
LDA #&00         :\ A39E= A9 00       ).
PLP              :\ A3A0= 28          (
PHP              :\ A3A1= 08          .
ADC #&00         :\ A3A2= 69 00       i.
JSR LAAB0        :\ A3A4= 20 B0 AA     0*
.LA3A7
LDA (&CC)        :\ A3A7= B2 CC       2L
TAY              :\ A3A9= A8          (
LDA #&01         :\ A3AA= A9 01       ).
PLP              :\ A3AC= 28          (
PHP              :\ A3AD= 08          .
ADC #&00         :\ A3AE= 69 00       i.
JSR LAA8D        :\ A3B0= 20 8D AA     .*
BCS LA3C1        :\ A3B3= B0 0C       0.
PLP              :\ A3B5= 28          (
PLA              :\ A3B6= 68          h
BEQ LA3BE        :\ A3B7= F0 05       p.
LDA #&80         :\ A3B9= A9 80       ).
JSR &0406        :\ A3BB= 20 06 04     ..
.LA3BE
JMP LAA81        :\ A3BE= 4C 81 AA    L.*
 
.LA3C1
PLP              :\ A3C1= 28          (
BCS LA401        :\ A3C2= B0 3D       0=
BIT &E2          :\ A3C4= 24 E2       $b
BPL LA3D3        :\ A3C6= 10 0B       ..
PLA              :\ A3C8= 68          h
BEQ LA3D0        :\ A3C9= F0 05       p.
LDA #&80         :\ A3CB= A9 80       ).
JSR &0406        :\ A3CD= 20 06 04     ..
.LA3D0
JMP LA343        :\ A3D0= 4C 43 A3    LC#
 
.LA3D3
JSR LAAE0        :\ A3D3= 20 E0 AA     `*
BEQ LA3F6        :\ A3D6= F0 1E       p.
LDA (&CC)        :\ A3D8= B2 CC       2L
TAY              :\ A3DA= A8          (
JSR LA2EA        :\ A3DB= 20 EA A2     j"
BCS LA3F6        :\ A3DE= B0 16       0.
PLX              :\ A3E0= FA          z
PHX              :\ A3E1= DA          Z
BEQ LA3E9        :\ A3E2= F0 05       p.
STA TUBE+5        :\ A3E4= 8D E5 FE    .e~
BRA LA3F1        :\ A3E7= 80 08       ..
 
.LA3E9
STA (&C8)        :\ A3E9= 92 C8       .H
INC &C8          :\ A3EB= E6 C8       fH
BNE LA3F1        :\ A3ED= D0 02       P.
INC &C9          :\ A3EF= E6 C9       fI
.LA3F1
JSR LAACA        :\ A3F1= 20 CA AA     J*
BRA LA3D3        :\ A3F4= 80 DD       .]
 
.LA3F6
PLA              :\ A3F6= 68          h
PHP              :\ A3F7= 08          .
BEQ LA3FF        :\ A3F8= F0 05       p.
LDA #&80         :\ A3FA= A9 80       ).
JSR &0406        :\ A3FC= 20 06 04     ..
.LA3FF
PLP              :\ A3FF= 28          (
RTS              :\ A400= 60          `
 
.LA401
JSR LAAE0        :\ A401= 20 E0 AA     `*
BEQ LA3F6        :\ A404= F0 F0       pp
LDA (&CC)        :\ A406= B2 CC       2L
TAY              :\ A408= A8          (
PLA              :\ A409= 68          h
PHA              :\ A40A= 48          H
BEQ LA412        :\ A40B= F0 05       p.
LDA TUBE+5        :\ A40D= AD E5 FE    -e~
BRA LA41A        :\ A410= 80 08       ..
 
.LA412
LDA (&C8)        :\ A412= B2 C8       2H
INC &C8          :\ A414= E6 C8       fH
BNE LA41A        :\ A416= D0 02       P.
INC &C9          :\ A418= E6 C9       fI
.LA41A
JSR LA34B        :\ A41A= 20 4B A3     K#
JSR LAACA        :\ A41D= 20 CA AA     J*
BRA LA401        :\ A420= 80 DF       ._

\ TAPE/ROM FSC 0 - *OPT
\ ---------------------
TXA:BEQ LA453        :\ *OPT 0
CPX #&03:BEQ LA448   :\ *OPT 3
CPY #&03:BCS LA433   :\ *OPT n,3+ - error Bad command (*BUG* should be Bad option)
DEX:BEQ LA436        :\ *OPT 1
DEX:BEQ LA43D        :\ *OPT 2
.LA433
JMP LFBED            :\ *OPT 4+ - error Bad command (*BUG* should be Bad option)

\ *OPT 1 - set message level
\ --------------------------
.LA436
LDA #&33         :\ A436= A9 33       )3
INY              :\ A438= C8          H
INY              :\ A439= C8          H
INY              :\ A43A= C8          H
BRA LA43F        :\ A43B= 80 02       ..

\ *OPT 2 - set error response level
\ ---------------------------------
.LA43D
LDA #&CC         :\ A43D= A9 CC       )L
.LA43F
INY              :\ A43F= C8          H
AND &E3          :\ A440= 25 E3       %c
.LA442
ORA LA456,Y      :\ A442= 19 56 A4    .V$
STA &E3          :\ A445= 85 E3       .c
RTS              :\ A447= 60          `

\ *OPT 3 - set interblock gap
\ ---------------------------
.LA448
TYA:BMI LA44D    ;\ *OPT 3,128+ - set to default
BNE LA44F        :\ *OPT 3,<>0 - use setting
.LA44D
LDA #&19         :\ *OPT 3,0 or *OPT 3,128+ - use default of 2.5 sec
.LA44F
STA &03D1:RTS    :\ Set inter-block gap
 
.LA453
TAY              :\ A453= A8          (
BRA LA442        :\ A454= 80 EC       .l
 
.LA456
; LDA (&00,X)      :\ A456= A1 00       !.
; EQUB &22         :\ A458= 22          "
; ORA (&00),Y      :\ A459= 11 00       ..
; DEY              :\ A45B= 88          .
; CPY LC0C6        :\ A45C= CC C6 C0    LF@
EQUB &A1:EQUB &00:EQUB &22:EQUB &11:EQUB &00:EQUB &88:EQUB &CC
.LA45D
DEC &C0
LDA &0247        :\ A45F= AD 47 02    -G.
BEQ LA46B        :\ A462= F0 07       p.
JSR LF710        :\ A464= 20 10 F7     .w
TAY              :\ A467= A8          (
CLC              :\ A468= 18          .
BRA LA485        :\ A469= 80 1A       ..
 
.LA46B
LDA LFE08        :\ A46B= AD 08 FE    -.~
PHA              :\ A46E= 48          H
AND #&02         :\ A46F= 29 02       ).
BEQ LA47E        :\ A471= F0 0B       p.
LDY &CA          :\ A473= A4 CA       $J
BEQ LA47E        :\ A475= F0 07       p.
PLA              :\ A477= 68          h
LDA &BD          :\ A478= A5 BD       %=
STA LFE09        :\ A47A= 8D 09 FE    ..~
RTS              :\ A47D= 60          `
 
.LA47E
LDY LFE09        :\ A47E= AC 09 FE    ,.~
PLA              :\ A481= 68          h
LSR A            :\ A482= 4A          J
LSR A            :\ A483= 4A          J
LSR A            :\ A484= 4A          J
.LA485
LDX &C2          :\ A485= A6 C2       &B
BEQ LA4F0        :\ A487= F0 67       pg
DEX              :\ A489= CA          J
BNE LA492        :\ A48A= D0 06       P.
BCC LA4F0        :\ A48C= 90 62       .b
LDY #&02         :\ A48E= A0 02        .
BRA LA4EE        :\ A490= 80 5C       .\
 
.LA492
DEX              :\ A492= CA          J
BNE LA4A8        :\ A493= D0 13       P.
BCS LA4F0        :\ A495= B0 59       0Y
TYA              :\ A497= 98          .
JSR LAA44        :\ A498= 20 44 AA     D*
LDY #&03         :\ A49B= A0 03        .
CMP #&2A         :\ A49D= C9 2A       I*
BEQ LA4EE        :\ A49F= F0 4D       pM
JSR LAA1C        :\ A4A1= 20 1C AA     .*
LDY #&01         :\ A4A4= A0 01        .
BRA LA4EE        :\ A4A6= 80 46       .F
 
.LA4A8
DEX              :\ A4A8= CA          J
BNE LA4B5        :\ A4A9= D0 0A       P.
BCS LA4B0        :\ A4AB= B0 03       0.
STY &BD          :\ A4AD= 84 BD       .=
RTS              :\ A4AF= 60          `
 
.LA4B0
LDA #&80         :\ A4B0= A9 80       ).
STA &C0          :\ A4B2= 85 C0       .@
RTS              :\ A4B4= 60          `
 
.LA4B5
DEX              :\ A4B5= CA          J
BNE LA4E1        :\ A4B6= D0 29       P)
BCS LA4E9        :\ A4B8= B0 2F       0/
TYA              :\ A4BA= 98          .
JSR LA6A9        :\ A4BB= 20 A9 A6     )&
LDY &BC          :\ A4BE= A4 BC       $<
INC &BC          :\ A4C0= E6 BC       f<
BIT &BD          :\ A4C2= 24 BD       $=
BMI LA4D3        :\ A4C4= 30 0D       0.
JSR LAABC        :\ A4C6= 20 BC AA     <*
BEQ LA4D0        :\ A4C9= F0 05       p.
STX TUBE+5        :\ A4CB= 8E E5 FE    .e~
BRA LA4D3        :\ A4CE= 80 03       ..
 
.LA4D0
TXA              :\ A4D0= 8A          .
STA (&B0),Y      :\ A4D1= 91 B0       .0
.LA4D3
INY              :\ A4D3= C8          H
CPY &03C8        :\ A4D4= CC C8 03    LH.
BNE LA4F0        :\ A4D7= D0 17       P.
LDA #&01         :\ A4D9= A9 01       ).
STA &BC          :\ A4DB= 85 BC       .<
LDY #&05         :\ A4DD= A0 05        .
BRA LA4EE        :\ A4DF= 80 0D       ..
 
.LA4E1
TYA              :\ A4E1= 98          .
JSR LA6A9        :\ A4E2= 20 A9 A6     )&
DEC &BC          :\ A4E5= C6 BC       F<
BPL LA4F0        :\ A4E7= 10 07       ..
.LA4E9
JSR LAA12        :\ A4E9= 20 12 AA     .*
LDY #&00         :\ A4EC= A0 00        .
.LA4EE
STY &C2          :\ A4EE= 84 C2       .B
.LA4F0
RTS              :\ A4F0= 60          `

\ TAPE/ROM FSC 1 - =EOF
\ ---------------------
PHA:PHY:TXA:TAY
LDA #&03:JSR LAA68  :\ Check if this channel is open for anything
LDA &E2:AND #&40    :\ Get EOF flag
TAX:PLY:PLA:RTS     :\ Return in X
 
.LA502
STZ &B4          :\ A502= 64 B4       d4
STZ &B5          :\ A504= 64 B5       d5
.LA506
LSR &CE          :\ A506= 46 CE       FN
LDA &B4          :\ A508= A5 B4       %4
PHA              :\ A50A= 48          H
STA &B6          :\ A50B= 85 B6       .6
LDA &B5          :\ A50D= A5 B5       %5
PHA              :\ A50F= 48          H
STA &B7          :\ A510= 85 B7       .7
JSR LA923        :\ A512= 20 23 A9     #)
EQUB &53         :\ A515= 53          S
ADC &61          :\ A516= 65 61       ea
ADC (&63)        :\ A518= 72 63       rc
PLA              :\ A51A= 68          h
ADC #&6E         :\ A51B= 69 6E       in
EQUB &67         :\ A51D= 67          g
ORA LA900        :\ A51E= 0D 00 A9    ..)
EQUB &FF         :\ A521= FF          .
JSR LA17C        :\ A522= 20 7C A1     |!
PLA              :\ A525= 68          h
STA &B5          :\ A526= 85 B5       .5
PLA              :\ A528= 68          h
STA &B4          :\ A529= 85 B4       .4
LDA &B6          :\ A52B= A5 B6       %6
ORA &B7          :\ A52D= 05 B7       .7
BNE LA564        :\ A52F= D0 33       P3
STZ &B4          :\ A531= 64 B4       d4
STZ &B5          :\ A533= 64 B5       d5
LDA &0247        :\ A535= AD 47 02    -G.
BEQ LA55B        :\ A538= F0 21       p!
BVS LA55B        :\ A53A= 70 1F       p.
JSR LA9CA        :\ A53C= 20 CA A9     J)
BIT &CE          :\ A53F= 24 CE       $N
BVC LA54D        :\ A541= 50 0A       P.
SEC              :\ A543= 38          8
.LA544
RTS              :\ A544= 60          `
 
.LA545
LDA #&40         :\ A545= A9 40       )@
JSR OSFIND       :\ A547= 20 CE FF     N.
TAY              :\ A54A= A8          (
BNE LA544        :\ A54B= D0 F7       Pw
.LA54D
JSR LAAED        :\ A54D= 20 ED AA     m*
DEC &4E,X        :\ A550= D6 4E       VN
EQUB &6F         :\ A552= 6F          o
STZ &20,X        :\ A553= 74 20       t 
ROR &6F          :\ A555= 66 6F       fo
ADC &6E,X        :\ A557= 75 6E       un
STZ &00          :\ A559= 64 00       d.
.LA55B
LDA &C1          :\ A55B= A5 C1       %A
BNE LA564        :\ A55D= D0 05       P.
LDX #&B1         :\ A55F= A2 B1       "1
JSR LAA4D        :\ A561= 20 4D AA     M*
.LA564
LDY #&FF         :\ A564= A0 FF        .
STY &03DF        :\ A566= 8C DF 03    ._.
CLC              :\ A569= 18          .
RTS              :\ A56A= 60          `
 
.LA56B
BEQ LA584        :\ A56B= F0 17       p.
PHA              :\ A56D= 48          H
LDA #&07         :\ A56E= A9 07       ).
JSR LF1E5        :\ A570= 20 E5 F1     eq
PLA              :\ A573= 68          h
CLC              :\ A574= 18          .
PHP              :\ A575= 08          .
SEI              :\ A576= 78          x
STA &FA          :\ A577= 85 FA       .z
CPY &FA          :\ A579= C4 FA       Dz
BCC LA583        :\ A57B= 90 06       ..
CPX &FA          :\ A57D= E4 FA       dz
BCC LA587        :\ A57F= 90 06       ..
BEQ LA587        :\ A581= F0 04       p.
.LA583
PLP              :\ A583= 28          (
.LA584
PLA              :\ A584= 68          h
PLA              :\ A585= 68          h
RTS              :\ A586= 60          `
 
.LA587
PLP              :\ A587= 28          (
LDA #&00         :\ A588= A9 00       ).
RTS              :\ A58A= 60          `
 
.LA58B
LDA &0256        :\ A58B= AD 56 02    -V.
JSR LA56B        :\ A58E= 20 6B A5     k%
.LA591
PHP              :\ A591= 08          .
PHY              :\ A592= 5A          Z
LDY &0256        :\ A593= AC 56 02    ,V.
STA &0256        :\ A596= 8D 56 02    .V.
BEQ LA59E        :\ A599= F0 03       p.
JSR OSFIND       :\ A59B= 20 CE FF     N.
.LA59E
LSR HAZEL_WORKSPACE+&C6        :\ A59E= 4E C6 DF    NF_
PLY              :\ A5A1= 7A          z
PLP              :\ A5A2= 28          (
BEQ LA5AE        :\ A5A3= F0 09       p.
ASL HAZEL_WORKSPACE+&C6        :\ A5A5= 0E C6 DF    .F_
JSR LA545        :\ A5A8= 20 45 A5     E%
STA &0256        :\ A5AB= 8D 56 02    .V.
.LA5AE
RTS              :\ A5AE= 60          `
 
.LA5AF
LDX #&A6         :\ A5AF= A2 A6       "&
JSR LAA4D        :\ A5B1= 20 4D AA     M*
JSR LA678        :\ A5B4= 20 78 A6     x&
.LA5B7
LDA &03CA        :\ A5B7= AD CA 03    -J.
LSR A            :\ A5BA= 4A          J
BCC LA5C0        :\ A5BB= 90 03       ..
JMP L9FE3        :\ A5BD= 4C E3 9F    Lc.
 
.LA5C0
LDA &03DD        :\ A5C0= AD DD 03    -].
STA &B4          :\ A5C3= 85 B4       .4
LDA &03DE        :\ A5C5= AD DE 03    -^.
STA &B5          :\ A5C8= 85 B5       .5
STZ &B0          :\ A5CA= 64 B0       d0
LDA #&0A         :\ A5CC= A9 0A       ).
STA &B1          :\ A5CE= 85 B1       .1
LDA #&FF         :\ A5D0= A9 FF       ).
STA &B2          :\ A5D2= 85 B2       .2
STA &B3          :\ A5D4= 85 B3       .3
JSR LA6D2        :\ A5D6= 20 D2 A6     R&
JSR LA8A1        :\ A5D9= 20 A1 A8     !(
BNE LA603        :\ A5DC= D0 25       P%
LDA &0AFF        :\ A5DE= AD FF 0A    -..
STA &02EC        :\ A5E1= 8D EC 02    .l.
JSR LAA35        :\ A5E4= 20 35 AA     5*
STX &03DD        :\ A5E7= 8E DD 03    .].
STY &03DE        :\ A5EA= 8C DE 03    .^.
LDX #&02         :\ A5ED= A2 02       ".
.LA5EF
LDA &03C8,X      :\ A5EF= BD C8 03    =H.
STA &02E9,X      :\ A5F2= 9D E9 02    .i.
DEX              :\ A5F5= CA          J
BPL LA5EF        :\ A5F6= 10 F7       .w
BIT &02EB        :\ A5F8= 2C EB 02    ,k.
BPL LA600        :\ A5FB= 10 03       ..
JSR LA059        :\ A5FD= 20 59 A0     Y 
.LA600
JMP LA9C5        :\ A600= 4C C5 A9    LE)
 
.LA603
JSR LA506        :\ A603= 20 06 A5     .%
BRA LA5B7        :\ A606= 80 AF       ./
 
.LA608
CMP #&2A         :\ A608= C9 2A       I*
BEQ LA643        :\ A60A= F0 37       p7
CMP #&23         :\ A60C= C9 23       I#
BNE LA61F        :\ A60E= D0 0F       P.
INC &03C6        :\ A610= EE C6 03    nF.
BNE LA618        :\ A613= D0 03       P.
INC &03C7        :\ A615= EE C7 03    nG.
.LA618
LDX #&FF         :\ A618= A2 FF       ".
BIT LE34E        :\ A61A= 2C 4E E3    ,Nc
BRA LA670        :\ A61D= 80 51       .Q
 
.LA61F
JSR LA177        :\ A61F= 20 77 A1     w!
JSR LAAED        :\ A622= 20 ED AA     m*
EQUB &D7:EQUS "Bad ROM":EQUB 0
; EQUB &D7         :\ A625= D7          W
; EQUB &42         :\ A626= 42          B
; ADC (&64,X)      :\ A627= 61 64       ad
; JSR &4F52        :\ A629= 20 52 4F     RO
; EOR LA000        :\ A62C= 4D 00 A0    M. 
; EQUB &FF         :\ A62F= FF          .

.LA62E
LDY #&FF
JSR LAA5C        :\ A630= 20 5C AA     \*
LDA #&01         :\ A633= A9 01       ).
STA &C2          :\ A635= 85 C2       .B
JSR LAA1C        :\ A637= 20 1C AA     .*
.LA63A
JSR LA880        :\ A63A= 20 80 A8     .(
LDA #&03         :\ A63D= A9 03       ).
CMP &C2          :\ A63F= C5 C2       EB
BNE LA63A        :\ A641= D0 F7       Pw
.LA643
JSR LAA46        :\ A643= 20 46 AA     F*
.LA646
JSR LA694        :\ A646= 20 94 A6     .&
BVC LA665        :\ A649= 50 1A       P.
STA &03B2,Y      :\ A64B= 99 B2 03    .2.
BEQ LA656        :\ A64E= F0 06       p.
INY              :\ A650= C8          H
CPY #&0B         :\ A651= C0 0B       @.
BNE LA646        :\ A653= D0 F1       Pq
DEY              :\ A655= 88          .
.LA656
LDX #&0C         :\ A656= A2 0C       ".
.LA658
JSR LA694        :\ A658= 20 94 A6     .&
BVC LA665        :\ A65B= 50 08       P.
STA &03B2,X      :\ A65D= 9D B2 03    .2.
INX              :\ A660= E8          h
CPX #&1F         :\ A661= E0 1F       `.
BNE LA658        :\ A663= D0 F3       Ps
.LA665
TYA              :\ A665= 98          .
TAX              :\ A666= AA          *
STZ &03B2,X      :\ A667= 9E B2 03    .2.
LDA &BE          :\ A66A= A5 BE       %>
ORA &BF          :\ A66C= 05 BF       .?
STA &C1          :\ A66E= 85 C1       .A
.LA670
JSR LAA44        :\ A670= 20 44 AA     D*
STY &C2          :\ A673= 84 C2       .B
TXA              :\ A675= 8A          .
BNE LA6CC        :\ A676= D0 54       PT
.LA678
LDA &0247        :\ A678= AD 47 02    -G.
BEQ LA62E        :\ A67B= F0 B1       p1
.LA67D
JSR LF710        :\ A67D= 20 10 F7     .w
CMP #&2B         :\ A680= C9 2B       I+
BNE LA608        :\ A682= D0 84       P.
LDA #&08         :\ A684= A9 08       ).
AND &E2          :\ A686= 25 E2       %b
BEQ LA68D        :\ A688= F0 03       p.
JSR LA05D        :\ A68A= 20 5D A0     ] 
.LA68D
JSR LF701        :\ A68D= 20 01 F7     .w
BCC LA67D        :\ A690= 90 EB       .k
CLV              :\ A692= B8          8
RTS              :\ A693= 60          `
 
.LA694
LDA &0247        :\ A694= AD 47 02    -G.
BEQ LA6A6        :\ A697= F0 0D       p.
PHX              :\ A699= DA          Z
PHY              :\ A69A= 5A          Z
JSR LF710        :\ A69B= 20 10 F7     .w
STA &BD          :\ A69E= 85 BD       .=
LDA #&FF         :\ A6A0= A9 FF       ).
STA &C0          :\ A6A2= 85 C0       .@
PLY              :\ A6A4= 7A          z
PLX              :\ A6A5= FA          z
.LA6A6
JSR LA778        :\ A6A6= 20 78 A7     x'
.LA6A9
PHP              :\ A6A9= 08          .
PHA              :\ A6AA= 48          H
SEC              :\ A6AB= 38          8
ROR &CB          :\ A6AC= 66 CB       fK
EOR &BF          :\ A6AE= 45 BF       E?
STA &BF          :\ A6B0= 85 BF       .?
.LA6B2
LDA &BF          :\ A6B2= A5 BF       %?
CLC              :\ A6B4= 18          .
BPL LA6C2        :\ A6B5= 10 0B       ..
EOR #&08         :\ A6B7= 49 08       I.
STA &BF          :\ A6B9= 85 BF       .?
LDA &BE          :\ A6BB= A5 BE       %>
EOR #&10         :\ A6BD= 49 10       I.
STA &BE          :\ A6BF= 85 BE       .>
SEC              :\ A6C1= 38          8
.LA6C2
ROL &BE          :\ A6C2= 26 BE       &>
ROL &BF          :\ A6C4= 26 BF       &?
LSR &CB          :\ A6C6= 46 CB       FK
BNE LA6B2        :\ A6C8= D0 E8       Ph
PLA              :\ A6CA= 68          h
PLP              :\ A6CB= 28          (
.LA6CC
RTS              :\ A6CC= 60          `
 
.LA6CD
JSR LA776        :\ A6CD= 20 76 A7     v'
BRA LA6A9        :\ A6D0= 80 D7       .W
 
.LA6D2
LDA #&00         :\ A6D2= A9 00       ).
.LA6D4
STA &BD          :\ A6D4= 85 BD       .=
LDX #&00         :\ A6D6= A2 00       ".
STZ &BC          :\ A6D8= 64 BC       d<
BVC LA6E6        :\ A6DA= 50 0A       P.
LDA &03C8        :\ A6DC= AD C8 03    -H.
ORA &03C9        :\ A6DF= 0D C9 03    .I.
BEQ LA6E6        :\ A6E2= F0 02       p.
LDX #&04         :\ A6E4= A2 04       ".
.LA6E6
STX &C2          :\ A6E6= 86 C2       .B
RTS              :\ A6E8= 60          `
 
.LA6E9
PHP              :\ A6E9= 08          .
LDX #&03         :\ A6EA= A2 03       ".
.LA6EC
STZ &03CB,X      :\ A6EC= 9E CB 03    .K.
DEX              :\ A6EF= CA          J
BPL LA6EC        :\ A6F0= 10 FA       .z
LDA &03C6        :\ A6F2= AD C6 03    -F.
ORA &03C7        :\ A6F5= 0D C7 03    .G.
BNE LA6FF        :\ A6F8= D0 05       P.
JSR LA784        :\ A6FA= 20 84 A7     .'
BRA LA702        :\ A6FD= 80 03       ..
 
.LA6FF
JSR LA788        :\ A6FF= 20 88 A7     .'
.LA702
LDA #&2A         :\ A702= A9 2A       )*
STA &BD          :\ A704= 85 BD       .=
JSR LAA44        :\ A706= 20 44 AA     D*
JSR LAA16        :\ A709= 20 16 AA     .*
JSR LA778        :\ A70C= 20 78 A7     x'
DEY              :\ A70F= 88          .
.LA710
INY              :\ A710= C8          H
LDA &03D2,Y      :\ A711= B9 D2 03    9R.
STA &03B2,Y      :\ A714= 99 B2 03    .2.
JSR LA6CD        :\ A717= 20 CD A6     M&
BNE LA710        :\ A71A= D0 F4       Pt
LDX #&0C         :\ A71C= A2 0C       ".
.LA71E
LDA &03B2,X      :\ A71E= BD B2 03    =2.
JSR LA6CD        :\ A721= 20 CD A6     M&
INX              :\ A724= E8          h
CPX #&1D         :\ A725= E0 1D       `.
BNE LA71E        :\ A727= D0 F5       Pu
JSR LA76F        :\ A729= 20 6F A7     o'
LDA &03C8        :\ A72C= AD C8 03    -H.
ORA &03C9        :\ A72F= 0D C9 03    .I.
BEQ LA74F        :\ A732= F0 1B       p.
JSR LAA46        :\ A734= 20 46 AA     F*
.LA737
JSR LAABC        :\ A737= 20 BC AA     <*
BEQ LA741        :\ A73A= F0 05       p.
LDA TUBE+5        :\ A73C= AD E5 FE    -e~
BRA LA743        :\ A73F= 80 02       ..
 
.LA741
LDA (&B0),Y      :\ A741= B1 B0       10
.LA743
JSR LA6CD        :\ A743= 20 CD A6     M&
INY              :\ A746= C8          H
CPY &03C8        :\ A747= CC C8 03    LH.
BNE LA737        :\ A74A= D0 EB       Pk
JSR LA76F        :\ A74C= 20 6F A7     o'
.LA74F
JSR LA778        :\ A74F= 20 78 A7     x'
JSR LA778        :\ A752= 20 78 A7     x'
JSR LAA12        :\ A755= 20 12 AA     .*
LDA #&01         :\ A758= A9 01       ).
JSR LA78A        :\ A75A= 20 8A A7     .'
PLP              :\ A75D= 28          (
JSR LA7AB        :\ A75E= 20 AB A7     +'
BIT &03CA        :\ A761= 2C CA 03    ,J.
BPL LA76E        :\ A764= 10 08       ..
PHP              :\ A766= 08          .
JSR LA784        :\ A767= 20 84 A7     .'
JSR LA056        :\ A76A= 20 56 A0     V 
PLP              :\ A76D= 28          (
.LA76E
RTS              :\ A76E= 60          `
 
.LA76F
LDA &BF          :\ A76F= A5 BF       %?
JSR LA776        :\ A771= 20 76 A7     v'
LDA &BE          :\ A774= A5 BE       %>
.LA776
STA &BD          :\ A776= 85 BD       .=
.LA778
JSR LA880        :\ A778= 20 80 A8     .(
BIT &C0          :\ A77B= 24 C0       $@
BPL LA778        :\ A77D= 10 F9       .y
STZ &C0          :\ A77F= 64 C0       d@
LDA &BD          :\ A781= A5 BD       %=
RTS              :\ A783= 60          `
 
.LA784
LDA #&32         :\ A784= A9 32       )2
BRA LA78A        :\ A786= 80 02       ..
 
.LA788
LDA &C7          :\ A788= A5 C7       %G
.LA78A
LDX #&05         :\ A78A= A2 05       ".
.LA78C
STA &0240        :\ A78C= 8D 40 02    .@.
.LA78F
JSR LA880        :\ A78F= 20 80 A8     .(
BIT &0240        :\ A792= 2C 40 02    ,@.
BPL LA78F        :\ A795= 10 F8       .x
DEX              :\ A797= CA          J
BNE LA78C        :\ A798= D0 F2       Pr
RTS              :\ A79A= 60          `
 
.LA79B
LDA &03C6        :\ A79B= AD C6 03    -F.
ORA &03C7        :\ A79E= 0D C7 03    .G.
BEQ LA7A8        :\ A7A1= F0 05       p.
BIT &03DF        :\ A7A3= 2C DF 03    ,_.
BPL LA7AB        :\ A7A6= 10 03       ..
.LA7A8
JSR LA059        :\ A7A8= 20 59 A0     Y 
.LA7AB
LDY #&00         :\ A7AB= A0 00        .
STZ &BA          :\ A7AD= 64 BA       d:
LDA &03CA        :\ A7AF= AD CA 03    -J.
STA &03DF        :\ A7B2= 8D DF 03    ._.
JSR LEF1B        :\ A7B5= 20 1B EF     .o
BEQ LA821        :\ A7B8= F0 67       pg
LDA #&0D         :\ A7BA= A9 0D       ).
JSR OSWRCH       :\ A7BC= 20 EE FF     n.
.LA7BF
LDA &03B2,Y      :\ A7BF= B9 B2 03    92.
BEQ LA7D4        :\ A7C2= F0 10       p.
CMP #&20         :\ A7C4= C9 20       I 
BCC LA7CC        :\ A7C6= 90 04       ..
CMP #&7F         :\ A7C8= C9 7F       I.
BCC LA7CE        :\ A7CA= 90 02       ..
.LA7CC
LDA #&3F         :\ A7CC= A9 3F       )?
.LA7CE
JSR OSWRCH       :\ A7CE= 20 EE FF     n.
INY              :\ A7D1= C8          H
BNE LA7BF        :\ A7D2= D0 EB       Pk
.LA7D4
LDA &0247        :\ A7D4= AD 47 02    -G.
BEQ LA7DD        :\ A7D7= F0 04       p.
BIT &BB          :\ A7D9= 24 BB       $;
BVC LA821        :\ A7DB= 50 44       PD
.LA7DD
JSR L9F0C        :\ A7DD= 20 0C 9F     ..
INY              :\ A7E0= C8          H
CPY #&0B         :\ A7E1= C0 0B       @.
BCC LA7D4        :\ A7E3= 90 EF       .o
LDA &03C6        :\ A7E5= AD C6 03    -F.
TAX              :\ A7E8= AA          *
JSR LA86A        :\ A7E9= 20 6A A8     j(
BIT &03CA        :\ A7EC= 2C CA 03    ,J.
BPL LA821        :\ A7EF= 10 30       .0
TXA              :\ A7F1= 8A          .
CLC              :\ A7F2= 18          .
ADC &03C9        :\ A7F3= 6D C9 03    mI.
JSR LA865        :\ A7F6= 20 65 A8     e(
.LA7F9
LDA &03C8        :\ A7F9= AD C8 03    -H.
JSR LA86A        :\ A7FC= 20 6A A8     j(
BIT &BB          :\ A7FF= 24 BB       $;
BVC LA821        :\ A801= 50 1E       P.
LDX #&04         :\ A803= A2 04       ".
.LA805
JSR L9F0C        :\ A805= 20 0C 9F     ..
DEX              :\ A808= CA          J
BNE LA805        :\ A809= D0 FA       Pz
LDX #&0F         :\ A80B= A2 0F       ".
JSR LA815        :\ A80D= 20 15 A8     .(
JSR L9F0C        :\ A810= 20 0C 9F     ..
LDX #&13         :\ A813= A2 13       ".
.LA815
LDY #&04         :\ A815= A0 04        .
.LA817
LDA &03B2,X      :\ A817= BD B2 03    =2.
JSR LA86A        :\ A81A= 20 6A A8     j(
DEX              :\ A81D= CA          J
DEY              :\ A81E= 88          .
BNE LA817        :\ A81F= D0 F6       Pv
.LA821
RTS              :\ A821= 60          `
 
.LA822
LDA &0247        :\ A822= AD 47 02    -G.
BEQ LA82D        :\ A825= F0 06       p.
JSR LA9CA        :\ A827= 20 CA A9     J)
JMP LFBED        :\ A82A= 4C ED FB    Lm{
 
.LA82D
JSR LAA5A        :\ A82D= 20 5A AA     Z*
JSR LAAA0        :\ A830= 20 A0 AA      *
JSR LEF1B        :\ A833= 20 1B EF     .o
BEQ LA821        :\ A836= F0 E9       pi
JSR LA923        :\ A838= 20 23 A9     #)
; EOR (&45)        :\ A83B= 52 45       RE
; EQUB &43         :\ A83D= 43          C
; EQUB &4F         :\ A83E= 4F          O
; EOR (&44)        :\ A83F= 52 44       RD
; JSR &6874        :\ A841= 20 74 68     th
; ADC &6E          :\ A844= 65 6E       en
; JSR &4552        :\ A846= 20 52 45     RE
; EQUB &54         :\ A849= 54          T
; EOR &52,X        :\ A84A= 55 52       UR
; LSR &2000        :\ A84C= 4E 00 20    N. 
; BRA LA7F9        :\ A84F= 80 A8       .(
EQUS "RECORD then RETURN":EQUB &00

.LA84E
JSR LA880 
JSR OSRDCH       :\ A851= 20 E0 FF     `.
CMP #&0D         :\ A854= C9 0D       I.
BNE LA84E        :\ A856= D0 F6       Pv
JMP OSNEWL       :\ A858= 4C E7 FF    Lg.
 
.LA85B
LDX #&FD         :\ A85B= A2 FD       "}
.LA85D
INC &B4,X        :\ A85D= F6 B4       v4
BNE LA864        :\ A85F= D0 03       P.
INX              :\ A861= E8          h
BNE LA85D        :\ A862= D0 F9       Py
.LA864
RTS              :\ A864= 60          `
 
.LA865
PHA              :\ A865= 48          H
JSR L9F0C        :\ A866= 20 0C 9F     ..
PLA              :\ A869= 68          h
.LA86A
PHA              :\ A86A= 48          H
LSR A            :\ A86B= 4A          J
LSR A            :\ A86C= 4A          J
LSR A            :\ A86D= 4A          J
LSR A            :\ A86E= 4A          J
JSR LA873        :\ A86F= 20 73 A8     s(
PLA              :\ A872= 68          h
.LA873
AND #&0F         :\ A873= 29 0F       ).
ORA #&30         :\ A875= 09 30       .0
CMP #&3A         :\ A877= C9 3A       I:
BCC LA87D        :\ A879= 90 02       ..
ADC #&06         :\ A87B= 69 06       i.
.LA87D
JMP OSWRCH       :\ A87D= 4C EE FF    Ln.
 
.LA880
PHP              :\ A880= 08          .
BIT &EB          :\ A881= 24 EB       $k
BMI LA889        :\ A883= 30 04       0.
BIT &FF          :\ A885= 24 FF       $.
BMI LA88B        :\ A887= 30 02       0.
.LA889
PLP              :\ A889= 28          (
RTS              :\ A88A= 60          `
 
.LA88B
JSR LA177        :\ A88B= 20 77 A1     w!
JSR LA9BB        :\ A88E= 20 BB A9     ;)
.LA891
LDA #&7E         :\ A891= A9 7E       )~
JSR OSBYTE       :\ A893= 20 F4 FF     t.
JSR LAAED        :\ A896= 20 ED AA     m*
EQUB &11:EQUS "Escape":EQUB &00
; ORA (&45),Y      :\ A899= 11 45       .E
; EQUB &73         :\ A89B= 73          s
; EQUB &63         :\ A89C= 63          c
; ADC (&70,X)      :\ A89D= 61 70       ap
; ADC &00          :\ A89F= 65 00       e.
.LA8A1
TYA              :\ A8A1= 98          .
BEQ LA8B1        :\ A8A2= F0 0D       p.
JSR LA923        :\ A8A4= 20 23 A9     #)
EQUB &0D:EQUS "Loading":EQUB &00
; ORA &6F4C        :\ A8A7= 0D 4C 6F    .Lo
; ADC (&64,X)      :\ A8AA= 61 64       ad
; ADC #&6E         :\ A8AC= 69 6E       in
; EQUB &67         :\ A8AE= 67          g
; ORA &6400        :\ A8AF= 0D 00 64    ..d
.LA8B1
STZ &BA          :\ A8B1= 64 BA          :
LDX #&FF         :\ A8B3= A2 FF       ".
LDA &C1          :\ A8B5= A5 C1       %A
BNE LA8C4        :\ A8B7= D0 0B       P.
JSR LA95C        :\ A8B9= 20 5C A9     \)
PHP              :\ A8BC= 08          .
LDX #&FF         :\ A8BD= A2 FF       ".
LDY #&11         :\ A8BF= A0 11        .
PLP              :\ A8C1= 28          (
BNE LA8DA        :\ A8C2= D0 16       P.
.LA8C4
LDY #&04         :\ A8C4= A0 04        .
LDA &C1          :\ A8C6= A5 C1       %A
BNE LA8DA        :\ A8C8= D0 10       P.
LDA &03C6        :\ A8CA= AD C6 03    -F.
CMP &B4          :\ A8CD= C5 B4       E4
BNE LA8D8        :\ A8CF= D0 07       P.
LDA &03C7        :\ A8D1= AD C7 03    -G.
CMP &B5          :\ A8D4= C5 B5       E5
BEQ LA8E3        :\ A8D6= F0 0B       p.
.LA8D8
LDY #&1E         :\ A8D8= A0 1E        .
.LA8DA
PHY              :\ A8DA= 5A          Z
PHX              :\ A8DB= DA          Z
JSR LA7A8        :\ A8DC= 20 A8 A7     ('
PLX              :\ A8DF= FA          z
PLY              :\ A8E0= 7A          z
BRA LA8F3        :\ A8E1= 80 10       ..
 
.LA8E3
PHX              :\ A8E3= DA          Z
JSR LA79B        :\ A8E4= 20 9B A7     .'
JSR LA9A0        :\ A8E7= 20 A0 A9      )
PLX              :\ A8EA= FA          z
LDA &BE          :\ A8EB= A5 BE       %>
ORA &BF          :\ A8ED= 05 BF       .?
BEQ LA96A        :\ A8EF= F0 79       py
LDY #&04         :\ A8F1= A0 04        .
.LA8F3
LDA #&AB         :\ A8F3= A9 AB       )+
DEC &BA          :\ A8F5= C6 BA       F:
PHA              :\ A8F7= 48          H
BIT &EB          :\ A8F8= 24 EB       $k
BMI LA909        :\ A8FA= 30 0D       0.
TXA              :\ A8FC= 8A          .
AND &0247        :\ A8FD= 2D 47 02    -G.
.LA900
BNE LA909        :\ A900= D0 07       P.
TXA              :\ A902= 8A          .
AND #&11         :\ A903= 29 11       ).
AND &BB          :\ A905= 25 BB       %;
BEQ LA918        :\ A907= F0 0F       p.
.LA909
PLA              :\ A909= 68          h
STA &B9          :\ A90A= 85 B9       .9
STY &B8          :\ A90C= 84 B8       .8
JSR LA58B        :\ A90E= 20 8B A5     .%
LSR &EB          :\ A911= 46 EB       Fk
JSR LA9B1        :\ A913= 20 B1 A9     1)
BRA LA955        :\ A916= 80 3D       .=
 
.LA918
TYA              :\ A918= 98          .
CLC              :\ A919= 18          .
ADC #&03         :\ A91A= 69 03       i.
TAY              :\ A91C= A8          (
BCC LA922        :\ A91D= 90 03       ..
PLA              :\ A91F= 68          h
INC A            :\ A920= 1A          .
PHA              :\ A921= 48          H
.LA922
PHY              :\ A922= 5A          Z
.LA923
JSR LEF1B        :\ A923= 20 1B EF     .o
TAY              :\ A926= A8          (
.LA927
PLA              :\ A927= 68          h
STA &B8          :\ A928= 85 B8       .8
PLA              :\ A92A= 68          h
STA &B9          :\ A92B= 85 B9       .9
PHY              :\ A92D= 5A          Z
TYA              :\ A92E= 98          .
PHP              :\ A92F= 08          .
.LA930
INC &B8          :\ A930= E6 B8       f8
BNE LA936        :\ A932= D0 02       P.
INC &B9          :\ A934= E6 B9       f9
.LA936
LDA (&B8)        :\ A936= B2 B8       28
BEQ LA94D        :\ A938= F0 13       p.
PLP              :\ A93A= 28          (
PHP              :\ A93B= 08          .
BEQ LA930        :\ A93C= F0 F2       pr
LDY &B8          :\ A93E= A4 B8       $8
PHY              :\ A940= 5A          Z
LDY &B9          :\ A941= A4 B9       $9
JSR OSASCI       :\ A943= 20 E3 FF     c.
STY &B9          :\ A946= 84 B9       .9
PLY              :\ A948= 7A          z
STY &B8          :\ A949= 84 B8       .8
BRA LA930        :\ A94B= 80 E3       .c
 
.LA94D
PLP              :\ A94D= 28          (
INC &B8          :\ A94E= E6 B8       f8
BNE LA954        :\ A950= D0 02       P.
INC &B9          :\ A952= E6 B9       f9
.LA954
PLY              :\ A954= 7A          z
.LA955
JMP (&00B8)      :\ A955= 6C B8 00    l8.
 
.LA958
LDY #&01         :\ A958= A0 01        .
BRA LA927        :\ A95A= 80 CB       .K
 
.LA95C
LDX #&FF         :\ A95C= A2 FF       ".
.LA95E
INX              :\ A95E= E8          h
LDA &03D2,X      :\ A95F= BD D2 03    =R.
BNE LA96B        :\ A962= D0 07       P.
TXA              :\ A964= 8A          .
BEQ LA96A        :\ A965= F0 03       p.
LDA &03B2,X      :\ A967= BD B2 03    =2.
.LA96A
RTS              :\ A96A= 60          `
 
.LA96B
JSR LEA71        :\ A96B= 20 71 EA     qj
EOR &03B2,X      :\ A96E= 5D B2 03    ]2.
BCS LA975        :\ A971= B0 02       0.
AND #&DF         :\ A973= 29 DF       )_
.LA975
BEQ LA95E        :\ A975= F0 E7       pg
.LA977
RTS              :\ A977= 60          `
 
.LA978
LDA &BA          :\ A978= A5 BA       %:
BEQ LA99D        :\ A97A= F0 21       p!
TXA              :\ A97C= 8A          .
BEQ LA99D        :\ A97D= F0 1E       p.
LDA #&22         :\ A97F= A9 22       )"
BIT &BB          :\ A981= 24 BB       $;
BEQ LA99D        :\ A983= F0 18       p.
JSR LAA12        :\ A985= 20 12 AA     .*
TAY              :\ A988= A8          (
JSR LA927        :\ A989= 20 27 A9     ')
ORA &5207        :\ A98C= 0D 07 52    ..R
ADC &77          :\ A98F= 65 77       ew
ADC #&6E         :\ A991= 69 6E       in
STZ &20          :\ A993= 64 20       d 
STZ &61,X        :\ A995= 74 61       ta
BVS LA9FE        :\ A997= 70 65       pe
ORA &000D        :\ A999= 0D 0D 00    ...
RTS              :\ A99C= 60          `
 
.LA99D
JSR LA05D        :\ A99D= 20 5D A0     ] 
.LA9A0
LDA &C2          :\ A9A0= A5 C2       %B
BEQ LA977        :\ A9A2= F0 D3       pS
JSR LA880        :\ A9A4= 20 80 A8     .(
LDA &0247        :\ A9A7= AD 47 02    -G.
BEQ LA9A0        :\ A9AA= F0 F4       pt
JSR LA45D        :\ A9AC= 20 5D A4     ]$
BRA LA9A0        :\ A9AF= 80 EF       .o
 
.LA9B1
JSR LEF1B        :\ A9B1= 20 1B EF     .o
BEQ LA9BB        :\ A9B4= F0 05       p.
.LA9B6
LDA #&07         :\ A9B6= A9 07       ).
JSR OSWRCH       :\ A9B8= 20 EE FF     n.
.LA9BB
LDA &027A        :\ A9BB= AD 7A 02    -z.
BEQ LA9C5        :\ A9BE= F0 05       p.
LDA #&80         :\ A9C0= A9 80       ).
JSR &0406        :\ A9C2= 20 06 04     ..
.LA9C5
LDX #&00         :\ A9C5= A2 00       ".
JSR LAA61        :\ A9C7= 20 61 AA     a*
.LA9CA
PHP              :\ A9CA= 08          .
SEI              :\ A9CB= 78          x
LDA &0282        :\ A9CC= AD 82 02    -..
STA LFE10        :\ A9CF= 8D 10 FE    ..~
STZ &EA          :\ A9D2= 64 EA       dj
BRA LA9D7        :\ A9D4= 80 01       ..
 
.LA9D6
PHP              :\ A9D6= 08          .
.LA9D7
JSR LAA12        :\ A9D7= 20 12 AA     .*
LDA &0250        :\ A9DA= AD 50 02    -P.
JMP LE921        :\ A9DD= 4C 21 E9    L!i
 
.LA9E0
PLP              :\ A9E0= 28          (
BIT &FF          :\ A9E1= 24 FF       $.
BPL LA9FD        :\ A9E3= 10 18       ..
RTS              :\ A9E5= 60          `
 
.LA9E6
LDA &E3          :\ A9E6= A5 E3       %c
ASL A            :\ A9E8= 0A          .
ASL A            :\ A9E9= 0A          .
ASL A            :\ A9EA= 0A          .
ASL A            :\ A9EB= 0A          .
STA &BB          :\ A9EC= 85 BB       .;
LDA &03D1        :\ A9EE= AD D1 03    -Q.
BRA LA9FB        :\ A9F1= 80 08       ..
 
.LA9F3
LDA &E3          :\ A9F3= A5 E3       %c
AND #&F0         :\ A9F5= 29 F0       )p
STA &BB          :\ A9F7= 85 BB       .;
LDA #&06         :\ A9F9= A9 06       ).
.LA9FB
STA &C7          :\ A9FB= 85 C7       .G
.LA9FD
CLI              :\ A9FD= 58          X
.LA9FE
PHP              :\ A9FE= 08          .
SEI              :\ A9FF= 78          x
.LAA00
BIT &024F        :\ AA00= 2C 4F 02    ,O.
BPL LA9E0        :\ AA03= 10 DB       .[
LDA &EA          :\ AA05= A5 EA       %j
BMI LA9E0        :\ AA07= 30 D7       0W
LDA #&01         :\ AA09= A9 01       ).
STA &EA          :\ AA0B= 85 EA       .j
JSR LAA12        :\ AA0D= 20 12 AA     .*
PLP              :\ AA10= 28          (
RTS              :\ AA11= 60          `
 
.LAA12
LDA #&03         :\ AA12= A9 03       ).
BRA LAA31        :\ AA14= 80 1B       ..
 
.LAA16
LDA #&30         :\ AA16= A9 30       )0
STA &CA          :\ AA18= 85 CA       .J
BRA LAA2F        :\ AA1A= 80 13       ..
 
.LAA1C
LDA #&05         :\ AA1C= A9 05       ).
STA LFE10        :\ AA1E= 8D 10 FE    ..~
LDX #&FF         :\ AA21= A2 FF       ".
.LAA23
DEX              :\ AA23= CA          J
BNE LAA23        :\ AA24= D0 FD       P}
STZ &CA          :\ AA26= 64 CA       dJ
LDA #&D0         :\ AA28= A9 D0       )P
.LAA2A
LDY #&85         :\ AA2A= A0 85        .
STY LFE10        :\ AA2C= 8C 10 FE    ..~
.LAA2F
ORA &C6          :\ AA2F= 05 C6       .F
.LAA31
STA LFE08        :\ AA31= 8D 08 FE    ..~
RTS              :\ AA34= 60          `
 
.LAA35
LDX &03C6        :\ AA35= AE C6 03    .F.
LDY &03C7        :\ AA38= AC C7 03    ,G.
INX              :\ AA3B= E8          h
STX &B4          :\ AA3C= 86 B4       .4
BNE LAA41        :\ AA3E= D0 01       P.
INY              :\ AA40= C8          H
.LAA41
STY &B5          :\ AA41= 84 B5       .5
RTS              :\ AA43= 60          `
 
.LAA44
STZ &C0          :\ AA44= 64 C0       d@
.LAA46
LDY #&00         :\ AA46= A0 00        .
STZ &BE          :\ AA48= 64 BE       d>
STZ &BF          :\ AA4A= 64 BF       d?
RTS              :\ AA4C= 60          `
 
.LAA4D
LDY #&FF         :\ AA4D= A0 FF        .
.LAA4F
INY              :\ AA4F= C8          H
INX              :\ AA50= E8          h
LDA &0300,X      :\ AA51= BD 00 03    =..
STA &03D2,Y      :\ AA54= 99 D2 03    .R.
BNE LAA4F        :\ AA57= D0 F6       Pv
RTS              :\ AA59= 60          `
 
.LAA5A
LDY #&00         :\ AA5A= A0 00        .
.LAA5C
CLI              :\ AA5C= 58          X
LDX #&01         :\ AA5D= A2 01       ".
STY &C3          :\ AA5F= 84 C3       .C
.LAA61
LDA #&89         :\ AA61= A9 89       ).
LDY &C3          :\ AA63= A4 C3       $C
JMP OSBYTE       :\ AA65= 4C F4 FF    Lt.

\ Check if TAPE/ROM channel is open
\ ---------------------------------
\ Y=handle to check, A=status mask to use
.LAA68
PHY:JSR LAA8D:PLY
BCS LAAC9           :\ Channel open, exit
CPY &0257:BNE LAA79 :\ Not SPOOL handle
STZ &0257:BRA LAA81 :\ Clear the SPOOL handle
.LAA79
CPY &0256:BNE LAA81 :\ Not EXEC handle
STZ &0256           :\ Clear the EXEC handle
.LAA81
JSR LAAED           :\ Generate error
EQUB &DE:EQUS "Channel":BRK

.LAA8D
PHA:TYA:EOR &0247   :\ Toggle channel with CFS/RFS switch
TAY:PLA             :\ If CFS=unchanged, if RFS 1/2/3->3/0/1 
AND &E2             :\ Mask with open channels bitmask
LSR A               :\ Move 'input open if tested' into Carry
DEY:BEQ LAA9F       :\ Exit if testing CFS#1 or RFS#3
LSR A               :\ Move 'output open if tested' into Carry
DEY:BEQ LAA9F       :\ Exit if testing CFS#2
CLC                 :\ Otherwise, Carry=Not Open
.LAA9F
RTS
 
.LAAA0
LDA #&10         :\ AAA0= A9 10       ).
BRA LAA2A        :\ AAA2= 80 86       ..
 
.LAAA4
LDA #&01         :\ AAA4= A9 01       ).
.LAAA6
JSR LAABC        :\ AAA6= 20 BC AA     <*
BEQ LAAC9        :\ AAA9= F0 1E       p.
TXA              :\ AAAB= 8A          .
LDX #&B0         :\ AAAC= A2 B0       "0
LDY #&00         :\ AAAE= A0 00        .
.LAAB0
PHA              :\ AAB0= 48          H
LDA #&C0         :\ AAB1= A9 C0       )@
.LAAB3
JSR &0406        :\ AAB3= 20 06 04     ..
BCC LAAB3        :\ AAB6= 90 FB       .{
PLA              :\ AAB8= 68          h
JMP &0406        :\ AAB9= 4C 06 04    L..
 
.LAABC
TAX              :\ AABC= AA          *
LDA &B2          :\ AABD= A5 B2       %2
AND &B3          :\ AABF= 25 B3       %3
INC A            :\ AAC1= 1A          .
BEQ LAAC9        :\ AAC2= F0 05       p.
LDA &027A        :\ AAC4= AD 7A 02    -z.
AND #&80         :\ AAC7= 29 80       ).
.LAAC9
RTS              :\ AAC9= 60          `
 
.LAACA
LDY #&05         :\ AACA= A0 05        .
.LAACC
LDA (&CC),Y      :\ AACC= B1 CC       1L
BNE LAAD7        :\ AACE= D0 07       P.
INY              :\ AAD0= C8          H
CPY #&08         :\ AAD1= C0 08       @.
BCC LAACC        :\ AAD3= 90 F7       .w
.LAAD5
LDA (&CC),Y      :\ AAD5= B1 CC       1L
.LAAD7
DEC A            :\ AAD7= 3A          :
STA (&CC),Y      :\ AAD8= 91 CC       .L
DEY              :\ AADA= 88          .
CPY #&05         :\ AADB= C0 05       @.
BCS LAAD5        :\ AADD= B0 F6       0v
RTS              :\ AADF= 60          `
 
.LAAE0
LDY #&08         :\ AAE0= A0 08        .
LDA #&00         :\ AAE2= A9 00       ).
.LAAE4
ORA (&CC),Y      :\ AAE4= 11 CC       .L
DEY              :\ AAE6= 88          .
CPY #&05         :\ AAE7= C0 05       @.
BCS LAAE4        :\ AAE9= B0 F9       0y
TAX              :\ AAEB= AA          *
RTS              :\ AAEC= 60          `
 
.LAAED
SEI              :\ AAED= 78          x
PLA              :\ AAEE= 68          h
STA &FA          :\ AAEF= 85 FA       .z
PLA              :\ AAF1= 68          h
STA &FB          :\ AAF2= 85 FB       .{
STZ &0100        :\ AAF4= 9C 00 01    ...
LDY #&00         :\ AAF7= A0 00        .
.LAAF9
INY              :\ AAF9= C8          H
LDA (&FA),Y      :\ AAFA= B1 FA       1z
STA &0100,Y      :\ AAFC= 99 00 01    ...
.LAAFF
BNE LAAF9        :\ AAFF= D0 F8       Px
JMP &0100        :\ AB01= 4C 00 01    L..
 
JSR LAAED        :\ AB04= 20 ED AA     m*
CLD              :\ AB07= D8          X
ORA &6144        :\ AB08= 0D 44 61    .Da
STZ &61,X        :\ AB0B= 74 61       ta
EQUB &3F         :\ AB0D= 3F          ?
BRK              :\ AB0E= 00          .
BRA LAB2A        :\ AB0F= 80 19       ..
 
JSR LAAED        :\ AB11= 20 ED AA     m*
EQUB &DB         :\ AB14= DB          [
ORA &6946        :\ AB15= 0D 46 69    .Fi
JMP (&3F65)      :\ AB18= 6C 65 3F    le?
 
BRK              :\ AB1B= 00          .
BRA LAB2A        :\ AB1C= 80 0C       ..
 
JSR LAAED        :\ AB1E= 20 ED AA     m*
PHX              :\ AB21= DA          Z
ORA &6C42        :\ AB22= 0D 42 6C    .Bl
EQUB &6F         :\ AB25= 6F          o
EQUB &63         :\ AB26= 63          c
EQUB &6B         :\ AB27= 6B          k
EQUB &3F         :\ AB28= 3F          ?
BRK              :\ AB29= 00          .
.LAB2A
JMP LA978        :\ AB2A= 4C 78 A9    Lx)
 
.LAB2D
LDA #&FF         :\ AB2D= A9 FF       ).
JSR &066C        :\ AB2F= 20 6C 06     l.
LDA TUBE+3        :\ AB32= AD E3 FE    -c~
LDA #&00         :\ AB35= A9 00       ).
JSR &0661        :\ AB37= 20 61 06     a.
TAY              :\ AB3A= A8          (
LDA (&FD),Y      :\ AB3B= B1 FD       1}
JSR &0661        :\ AB3D= 20 61 06     a.
.LAB40
INY              :\ AB40= C8          H
LDA (&FD),Y      :\ AB41= B1 FD       1}
JSR &0661        :\ AB43= 20 61 06     a.
TAX              :\ AB46= AA          *
BNE LAB40        :\ AB47= D0 F7       Pw
LDX #&FF         :\ AB49= A2 FF       ".
TXS              :\ AB4B= 9A          .
CLI              :\ AB4C= 58          X
.LAB4D
BIT TUBE+0        :\ AB4D= 2C E0 FE    ,`~
BPL LAB58        :\ AB50= 10 06       ..
.LAB52
LDA TUBE+1        :\ AB52= AD E1 FE    -a~
JSR OSWRCH       :\ AB55= 20 EE FF     n.
.LAB58
BIT TUBE+2        :\ AB58= 2C E2 FE    ,b~
BPL LAB4D        :\ AB5B= 10 F0       .p
BIT TUBE+0        :\ AB5D= 2C E0 FE    ,`~
BMI LAB52        :\ AB60= 30 F0       0p
LDX TUBE+3        :\ AB62= AE E3 FE    .c~
STX &51          :\ AB65= 86 51       .Q
JMP (&0500)      :\ AB67= 6C 00 05    l..
 
BRK              :\ AB6A= 00          .
BRA LAB6D        :\ AB6B= 80 00       ..
 
.LAB6D
BRK              :\ AB6D= 00          .
.LAB6E
JMP &04C2        :\ AB6E= 4C C2 04    LB.
 
JMP &0675        :\ AB71= 4C 75 06    Lu.
 
CMP #&80         :\ AB74= C9 80       I.
BCC LABA1        :\ AB76= 90 29       .)
CMP #&C0         :\ AB78= C9 C0       I@
BCS LAB94        :\ AB7A= B0 18       0.
ORA #&40         :\ AB7C= 09 40       .@
CMP &15          :\ AB7E= C5 15       E.
BNE LABA0        :\ AB80= D0 1E       P.
PHP              :\ AB82= 08          .
SEI              :\ AB83= 78          x
LDA #&05         :\ AB84= A9 05       ).
JSR &066C        :\ AB86= 20 6C 06     l.
JSR &066A        :\ AB89= 20 6A 06     j.
PLP              :\ AB8C= 28          (
LDA #&80         :\ AB8D= A9 80       ).
STA &15          :\ AB8F= 85 15       ..
STA &14          :\ AB91= 85 14       ..
RTS              :\ AB93= 60          `
 
.LAB94
ASL &14          :\ AB94= 06 14       ..
BCS LAB9E        :\ AB96= B0 06       0.
CMP &15          :\ AB98= C5 15       E.
BEQ LABA0        :\ AB9A= F0 04       p.
CLC              :\ AB9C= 18          .
RTS              :\ AB9D= 60          `
 
.LAB9E
STA &15          :\ AB9E= 85 15       ..
.LABA0
RTS              :\ ABA0= 60          `
 
.LABA1
PHP              :\ ABA1= 08          .
SEI              :\ ABA2= 78          x
STY &13          :\ ABA3= 84 13       ..
STX &12          :\ ABA5= 86 12       ..
JSR &066C        :\ ABA7= 20 6C 06     l.
TAX              :\ ABAA= AA          *
LDY #&03         :\ ABAB= A0 03        .
JSR &066A        :\ ABAD= 20 6A 06     j.
.LABB0
LDA (&12),Y      :\ ABB0= B1 12       1.
JSR &066C        :\ ABB2= 20 6C 06     l.
DEY              :\ ABB5= 88          .
BPL LABB0        :\ ABB6= 10 F8       .x
LDY #&18         :\ ABB8= A0 18        .
STY TUBE+0        :\ ABBA= 8C E0 FE    .`~
LDA &0518,X      :\ ABBD= BD 18 05    =..
STA TUBE+0        :\ ABC0= 8D E0 FE    .`~
LSR A            :\ ABC3= 4A          J
LSR A            :\ ABC4= 4A          J
BCC LABCD        :\ ABC5= 90 06       ..
BIT TUBE+5        :\ ABC7= 2C E5 FE    ,e~
BIT TUBE+5        :\ ABCA= 2C E5 FE    ,e~
.LABCD
JSR &066C        :\ ABCD= 20 6C 06     l.
.LABD0
BIT TUBE+6        :\ ABD0= 2C E6 FE    ,f~
BVC LABD0        :\ ABD3= 50 FB       P{
BCS LABE4        :\ ABD5= B0 0D       0.
CPX #&04         :\ ABD7= E0 04       `.
BNE LABEC        :\ ABD9= D0 11       P.
.LABDB
JSR &0414        :\ ABDB= 20 14 04     ..
JSR &0661        :\ ABDE= 20 61 06     a.
JMP &0032        :\ ABE1= 4C 32 00    L2.
 
.LABE4
LSR A            :\ ABE4= 4A          J
BCC LABEC        :\ ABE5= 90 05       ..
LDY #&88         :\ ABE7= A0 88        .
STY TUBE+0        :\ ABE9= 8C E0 FE    .`~
.LABEC
PLP              :\ ABEC= 28          (
RTS              :\ ABED= 60          `
 
.LABEE
LDX &028D        :\ ABEE= AE 8D 02    ...
BEQ LABDB        :\ ABF1= F0 E8       ph
.LABF3
LDA #&FF         :\ ABF3= A9 FF       ).
JSR &0406        :\ ABF5= 20 06 04     ..
BCC LABF3        :\ ABF8= 90 F9       .y
JSR &04C9        :\ ABFA= 20 C9 04     I.
.LABFD
PHP              :\ ABFD= 08          .
SEI              :\ ABFE= 78          x
LDA #&07         :\ ABFF= A9 07       ).
JSR &04BB        :\ AC01= 20 BB 04     ;.
LDY #&00         :\ AC04= A0 00        .
STZ &00          :\ AC06= 64 00       d.
.LAC08
LDA (&00),Y      :\ AC08= B1 00       1.
STA TUBE+5        :\ AC0A= 8D E5 FE    .e~
NOP              :\ AC0D= EA          j
NOP              :\ AC0E= EA          j
NOP              :\ AC0F= EA          j
INY              :\ AC10= C8          H
BNE LAC08        :\ AC11= D0 F5       Pu
PLP              :\ AC13= 28          (
INC &54          :\ AC14= E6 54       fT
BNE LAC1E        :\ AC16= D0 06       P.
INC &55          :\ AC18= E6 55       fU
BNE LAC1E        :\ AC1A= D0 02       P.
INC &56          :\ AC1C= E6 56       fV
.LAC1E
INC &01          :\ AC1E= E6 01       f.
BIT &01          :\ AC20= 24 01       $.
BVC LABFD        :\ AC22= 50 D9       PY
JSR &04C9        :\ AC24= 20 C9 04     I.
LDA #&04         :\ AC27= A9 04       ).
LDY #&00         :\ AC29= A0 00        .
LDX #&53         :\ AC2B= A2 53       "S
JMP &0406        :\ AC2D= 4C 06 04    L..
 
CLI              :\ AC30= 58          X
BCS LABF3        :\ AC31= B0 C0       0@
BNE LABEE        :\ AC33= D0 B9       P9
BRA LAC98        :\ AC35= 80 61       .a
 
LDA #&80         :\ AC37= A9 80       ).
STA &54          :\ AC39= 85 54       .T
STA &01          :\ AC3B= 85 01       ..
LDA #&20         :\ AC3D= A9 20       ) 
AND L8006        :\ AC3F= 2D 06 80    -..
TAY              :\ AC42= A8          (
STY &53          :\ AC43= 84 53       .S
BEQ LAC60        :\ AC45= F0 19       p.
LDX L8007        :\ AC47= AE 07 80    ...
.LAC4A
INX              :\ AC4A= E8          h
LDA L8000,X      :\ AC4B= BD 00 80    =..
BNE LAC4A        :\ AC4E= D0 FA       Pz
LDA L8001,X      :\ AC50= BD 01 80    =..
STA &53          :\ AC53= 85 53       .S
LDA L8002,X      :\ AC55= BD 02 80    =..
STA &54          :\ AC58= 85 54       .T
LDY L8003,X      :\ AC5A= BC 03 80    <..
LDA L8004,X      :\ AC5D= BD 04 80    =..
.LAC60
STA &56          :\ AC60= 85 56       .V
STY &55          :\ AC62= 84 55       .U
RTS              :\ AC64= 60          `
 
.LAC65
AND &05,X        :\ AC65= 35 05       5.
DEY              :\ AC67= 88          .
ORA &DA          :\ AC68= 05 DA       .Z
ORA &EB          :\ AC6A= 05 EB       .k
ORA &07          :\ AC6C= 05 07       ..
ASL &36          :\ AC6E= 06 36       .6
ASL &59          :\ AC70= 06 59       .Y
ORA &2C          :\ AC72= 05 2C       .,
ORA &20          :\ AC74= 05 20       . 
ORA &3F          :\ AC76= 05 3F       .?
ORA &B2          :\ AC78= 05 B2       .2
ORA &9A          :\ AC7A= 05 9A       ..
ORA &86          :\ AC7C= 05 86       ..
DEY              :\ AC7E= 88          .
STX &98,Y        :\ AC7F= 96 98       ..
CLC              :\ AC81= 18          .
CLC              :\ AC82= 18          .
EQUB &82         :\ AC83= 82          .
CLC              :\ AC84= 18          .
JSR &06A1        :\ AC85= 20 A1 06     !.
TAY              :\ AC88= A8          (
JSR &06A1        :\ AC89= 20 A1 06     !.
JSR OSBPUT       :\ AC8C= 20 D4 FF     T.
BRA LACF3        :\ AC8F= 80 62       .b
 
JSR &06A1        :\ AC91= 20 A1 06     !.
TAY              :\ AC94= A8          (
JSR OSBGET       :\ AC95= 20 D7 FF     W.
.LAC98
BRA LAC9D        :\ AC98= 80 03       ..
 
JSR OSRDCH       :\ AC9A= 20 E0 FF     `.
.LAC9D
ROR A            :\ AC9D= 6A          j
JSR &0661        :\ AC9E= 20 61 06     a.
ROL A            :\ ACA1= 2A          *
BRA LACF5        :\ ACA2= 80 51       .Q
 
JSR &06A1        :\ ACA4= 20 A1 06     !.
BEQ LACB3        :\ ACA7= F0 0A       p.
PHA              :\ ACA9= 48          H
JSR &0574        :\ ACAA= 20 74 05     t.
PLA              :\ ACAD= 68          h
JSR OSFIND       :\ ACAE= 20 CE FF     N.
BRA LACF5        :\ ACB1= 80 42       .B
 
.LACB3
JSR &06A1        :\ ACB3= 20 A1 06     !.
TAY              :\ ACB6= A8          (
LDA #&00         :\ ACB7= A9 00       ).
JSR OSFIND       :\ ACB9= 20 CE FF     N.
BRA LACF3        :\ ACBC= 80 35       .5
 
JSR &06A1        :\ ACBE= 20 A1 06     !.
TAY              :\ ACC1= A8          (
LDX #&04         :\ ACC2= A2 04       ".
JSR &0693        :\ ACC4= 20 93 06     ..
JSR OSARGS       :\ ACC7= 20 DA FF     Z.
JSR &0661        :\ ACCA= 20 61 06     a.
LDX #&03         :\ ACCD= A2 03       ".
.LACCF
LDA &00,X        :\ ACCF= B5 00       5.
JSR &0661        :\ ACD1= 20 61 06     a.
DEX              :\ ACD4= CA          J
BPL LACCF        :\ ACD5= 10 F8       .x
BRA LACFD        :\ ACD7= 80 24       .$
 
LDX #&00         :\ ACD9= A2 00       ".
LDY #&00         :\ ACDB= A0 00        .
.LACDD
JSR &06A1        :\ ACDD= 20 A1 06     !.
STA &0700,Y      :\ ACE0= 99 00 07    ...
INY              :\ ACE3= C8          H
BEQ LACEA        :\ ACE4= F0 04       p.
CMP #&0D         :\ ACE6= C9 0D       I.
BNE LACDD        :\ ACE8= D0 F3       Ps
.LACEA
LDY #&07         :\ ACEA= A0 07        .
RTS              :\ ACEC= 60          `
 
JSR &0574        :\ ACED= 20 74 05     t.
JSR OS_CLI       :\ ACF0= 20 F7 FF     w.
.LACF3
LDA #&7F         :\ ACF3= A9 7F       ).
.LACF5
BIT TUBE+2        :\ ACF5= 2C E2 FE    ,b~
BVC LACF5        :\ ACF8= 50 FB       P{
STA TUBE+3        :\ ACFA= 8D E3 FE    .c~
.LACFD
BRA LAD4D        :\ ACFD= 80 4E       .N
 
LDX #&0D         :\ ACFF= A2 0D       ".
JSR &0693        :\ AD01= 20 93 06     ..
LDY #&00         :\ AD04= A0 00        .
JSR OSGBPB       :\ AD06= 20 D1 FF     Q.
PHA              :\ AD09= 48          H
LDX #&0C         :\ AD0A= A2 0C       ".
.LAD0C
LDA &00,X        :\ AD0C= B5 00       5.
JSR &0661        :\ AD0E= 20 61 06     a.
DEX              :\ AD11= CA          J
BPL LAD0C        :\ AD12= 10 F8       .x
PLA              :\ AD14= 68          h
BRA LAC9D        :\ AD15= 80 86       ..
 
LDX #&10         :\ AD17= A2 10       ".
.LAD19
JSR &06A1        :\ AD19= 20 A1 06     !.
STA &01,X        :\ AD1C= 95 01       ..
DEX              :\ AD1E= CA          J
BNE LAD19        :\ AD1F= D0 F8       Px
JSR &0574        :\ AD21= 20 74 05     t.
STX &00          :\ AD24= 86 00       ..
STY &01          :\ AD26= 84 01       ..
LDY #&00         :\ AD28= A0 00        .
JSR &06A1        :\ AD2A= 20 A1 06     !.
JSR OSFILE       :\ AD2D= 20 DD FF     ].
JSR &0661        :\ AD30= 20 61 06     a.
LDX #&10         :\ AD33= A2 10       ".
.LAD35
LDA &01,X        :\ AD35= B5 01       5.
JSR &0661        :\ AD37= 20 61 06     a.
DEX              :\ AD3A= CA          J
BNE LAD35        :\ AD3B= D0 F8       Px
BRA LAD4D        :\ AD3D= 80 0E       ..
 
JSR &069D        :\ AD3F= 20 9D 06     ..
JSR OSBYTE       :\ AD42= 20 F4 FF     t.
.LAD45
BIT TUBE+2        :\ AD45= 2C E2 FE    ,b~
BVC LAD45        :\ AD48= 50 FB       P{
STX TUBE+3        :\ AD4A= 8E E3 FE    .c~
.LAD4D
JMP &0036        :\ AD4D= 4C 36 00    L6.
 
JSR &069D        :\ AD50= 20 9D 06     ..
TAY              :\ AD53= A8          (
JSR &06A1        :\ AD54= 20 A1 06     !.
JSR OSBYTE       :\ AD57= 20 F4 FF     t.
EOR #&9D         :\ AD5A= 49 9D       I.
BEQ LAD4D        :\ AD5C= F0 EF       po
ROR A            :\ AD5E= 6A          j
JSR &0661        :\ AD5F= 20 61 06     a.
.LAD62
BIT TUBE+2        :\ AD62= 2C E2 FE    ,b~
.LAD65
BVC LAD62        :\ AD65= 50 FB       P{
STY TUBE+3        :\ AD67= 8C E3 FE    .c~
BRA LAD45        :\ AD6A= 80 D9       .Y
 
JSR &06A1        :\ AD6C= 20 A1 06     !.
TAY              :\ AD6F= A8          (
JSR &06AA        :\ AD70= 20 AA 06     *.
BMI LAD7F        :\ AD73= 30 0A       0.
.LAD75
JSR &06A1        :\ AD75= 20 A1 06     !.
STA &0128,X      :\ AD78= 9D 28 01    .(.
DEX              :\ AD7B= CA          J
BPL LAD75        :\ AD7C= 10 F7       .w
TYA              :\ AD7E= 98          .
.LAD7F
LDX #&28         :\ AD7F= A2 28       "(
LDY #&01         :\ AD81= A0 01        .
JSR OSWORD       :\ AD83= 20 F1 FF     q.
JSR &06AA        :\ AD86= 20 AA 06     *.
BMI LAD4D        :\ AD89= 30 C2       0B
.LAD8B
LDY &0128,X      :\ AD8B= BC 28 01    <(.
.LAD8E
BIT TUBE+2        :\ AD8E= 2C E2 FE    ,b~
BVC LAD8E        :\ AD91= 50 FB       P{
STY TUBE+3        :\ AD93= 8C E3 FE    .c~
DEX              :\ AD96= CA          J
BPL LAD8B        :\ AD97= 10 F2       .r
.LAD99
BRA LAD4D        :\ AD99= 80 B2       .2
 
LDX #&04         :\ AD9B= A2 04       ".
.LAD9D
JSR &06A1        :\ AD9D= 20 A1 06     !.
STA &00,X        :\ ADA0= 95 00       ..
DEX              :\ ADA2= CA          J
BPL LAD9D        :\ ADA3= 10 F8       .x
INX              :\ ADA5= E8          h
TXA              :\ ADA6= 8A          .
TAY              :\ ADA7= A8          (
JSR OSWORD       :\ ADA8= 20 F1 FF     q.
BCC LADB2        :\ ADAB= 90 05       ..
LDA #&FF         :\ ADAD= A9 FF       ).
JMP &0590        :\ ADAF= 4C 90 05    L..
 
.LADB2
LDX #&00         :\ ADB2= A2 00       ".
LDA #&7F         :\ ADB4= A9 7F       ).
JSR &0661        :\ ADB6= 20 61 06     a.
.LADB9
LDA &0700,X      :\ ADB9= BD 00 07    =..
JSR &0661        :\ ADBC= 20 61 06     a.
INX              :\ ADBF= E8          h
CMP #&0D         :\ ADC0= C9 0D       I.
BNE LADB9        :\ ADC2= D0 F5       Pu
BRA LAD99        :\ ADC4= 80 D3       .S
 
.LADC6
BIT TUBE+2        :\ ADC6= 2C E2 FE    ,b~
BVC LADC6        :\ ADC9= 50 FB       P{
STA TUBE+3        :\ ADCB= 8D E3 FE    .c~
RTS              :\ ADCE= 60          `
 
LDA &15          :\ ADCF= A5 15       %.
.LADD1
BIT TUBE+6        :\ ADD1= 2C E6 FE    ,f~
BVC LADD1        :\ ADD4= 50 FB       P{
STA TUBE+7        :\ ADD6= 8D E7 FE    .g~
RTS              :\ ADD9= 60          `
 
LDA &FF          :\ ADDA= A5 FF       %.
SEC              :\ ADDC= 38          8
ROR A            :\ ADDD= 6A          j
BRA LADEF        :\ ADDE= 80 0F       ..
 
PHA              :\ ADE0= 48          H
LDA #&00         :\ ADE1= A9 00       ).
JSR &068A        :\ ADE3= 20 8A 06     ..
TYA              :\ ADE6= 98          .
JSR &068A        :\ ADE7= 20 8A 06     ..
TXA              :\ ADEA= 8A          .
JSR &068A        :\ ADEB= 20 8A 06     ..
PLA              :\ ADEE= 68          h
.LADEF
BIT TUBE+0        :\ ADEF= 2C E0 FE    ,`~
BVC LADEF        :\ ADF2= 50 FB       P{
STA TUBE+1        :\ ADF4= 8D E1 FE    .a~
RTS              :\ ADF7= 60          `
 
.LADF8
JSR &06A1        :\ ADF8= 20 A1 06     !.
STA &FF,X        :\ ADFB= 95 FF       ..
DEX              :\ ADFD= CA          J
BNE LADF8        :\ ADFE= D0 F8       Px
BRA LAE06        :\ AE00= 80 04       ..
 
JSR &06A1        :\ AE02= 20 A1 06     !.
TAX              :\ AE05= AA          *
.LAE06
BIT TUBE+2        :\ AE06= 2C E2 FE    ,b~
BPL LAE06        :\ AE09= 10 FB       .{
LDA TUBE+3        :\ AE0B= AD E3 FE    -c~
RTS              :\ AE0E= 60          `
 
.LAE0F
BIT TUBE+2        :\ AE0F= 2C E2 FE    ,b~
BPL LAE0F        :\ AE12= 10 FB       .{
LDX TUBE+3        :\ AE14= AE E3 FE    .c~
DEX              :\ AE17= CA          J
RTS              :\ AE18= 60          `
 
.LAE19
PHP              :\ AE19= 08          .
PHY              :\ AE1A= 5A          Z
PHX              :\ AE1B= DA          Z
PHA              :\ AE1C= 48          H
CMP #&04         :\ AE1D= C9 04       I.
BEQ LAE2E        :\ AE1F= F0 0D       p.
CMP #&07         :\ AE21= C9 07       I.
BEQ LAE4A        :\ AE23= F0 25       p%
CMP #&2A         :\ AE25= C9 2A       I*
BEQ LAE9D        :\ AE27= F0 74       pt
.LAE29
PLA              :\ AE29= 68          h
PLX              :\ AE2A= FA          z
PLY              :\ AE2B= 7A          z
PLP              :\ AE2C= 28          (
RTS              :\ AE2D= 60          `
 
.LAE2E
JSR LB832        :\ AE2E= 20 32 B8     28
CMP #&0B         :\ AE31= C9 0B       I.
BNE LAE29        :\ AE33= D0 F4       Pt
PLA              :\ AE35= 68          h
PLX              :\ AE36= FA          z
LDA #&8E         :\ AE37= A9 8E       ).
JSR OSBYTE       :\ AE39= 20 F4 FF     t.
.LAE3C
LDX #&04         :\ AE3C= A2 04       ".
.LAE3E
LDA &0229,X      :\ AE3E= BD 29 02    =).
CMP LAE93-1,X      :\ AE41= DD 92 AE    ]..
BNE LAE49        :\ AE44= D0 03       P.
DEX              :\ AE46= CA          J
BNE LAE3E        :\ AE47= D0 F5       Pu
.LAE49
RTS              :\ AE49= 60          `
 
.LAE4A
PHY              :\ AE4A= 5A          Z
PLY              :\ AE4B= 7A          z
BNE LAE29        :\ AE4C= D0 DB       P[
LDA &EF          :\ AE4E= A5 EF       %o
CMP #&60         :\ AE50= C9 60       I`
BNE LAE29        :\ AE52= D0 D5       PU
PLA              :\ AE54= 68          h
PHY              :\ AE55= 5A          Z
SEI              :\ AE56= 78          x
LDA &F0          :\ AE57= A5 F0       %p
BMI LAE6C        :\ AE59= 30 11       0.
LSR A            :\ AE5B= 4A          J
BNE LAE66        :\ AE5C= D0 08       P.
LDA #&11         :\ AE5E= A9 11       ).
STA &76          :\ AE60= 85 76       .v
ROR &74          :\ AE62= 66 74       ft
BRA LAE29        :\ AE64= 80 C3       .C
 
.LAE66
STZ &78          :\ AE66= 64 78       dx
ROR &77          :\ AE68= 66 77       fw
.LAE6A
BRA LAE29        :\ AE6A= 80 BD       .=
 
.LAE6C
LSR A            :\ AE6C= 4A          J
BCC LAE9D        :\ AE6D= 90 2E       ..
STZ &75          :\ AE6F= 64 75       du
JSR LAE3C        :\ AE71= 20 3C AE     <.
BEQ LAE29        :\ AE74= F0 B3       p3
LDX #&04         :\ AE76= A2 04       ".
.LAE78
LDA &0229,X      :\ AE78= BD 29 02    =).
STA &6F,X        :\ AE7B= 95 6F       .o
LDA LAE93-1,X      :\ AE7D= BD 92 AE    =..
STA &0229,X      :\ AE80= 9D 29 02    .).
DEX              :\ AE83= CA          J
BNE LAE78        :\ AE84= D0 F2       Pr
LDX #&06         :\ AE86= A2 06       ".
.LAE88
LDA LAE96,X      :\ AE88= BD 96 AE    =..
STA &0DDD,X      :\ AE8B= 9D DD 0D    .].
DEX              :\ AE8E= CA          J
BNE LAE88        :\ AE8F= D0 F7       Pw
BRA LAE6A        :\ AE91= 80 D7       .W

.LAE93
EQUB &3F         :\ AE93= 3F          ?
EQUB &FF         :\ AE94= FF          .
EQUB &42         :\ AE95= 42          B
.LAE96
EQUB &FF         :\ AE96= FF          .
EQUB &D4         :\ AE97= D4          T
LDX &130F        :\ AE98= AE 0F 13    ...
EQUB &AF         :\ AE9B= AF          /
EQUB &0F         :\ AE9C= 0F          .
.LAE9D
SEI              :\ AE9D= 78          x
JSR LAE3C        :\ AE9E= 20 3C AE     <.
BNE LAE6A        :\ AEA1= D0 C7       PG
LDX #&06         :\ AEA3= A2 06       ".
.LAEA5
LDA &0DDD,X      :\ AEA5= BD DD 0D    =].
CMP LAE96,X      :\ AEA8= DD 96 AE    ]..
BNE LAE6A        :\ AEAB= D0 BD       P=
DEX              :\ AEAD= CA          J
BNE LAEA5        :\ AEAE= D0 F5       Pu
LDX #&04         :\ AEB0= A2 04       ".
.LAEB2
LDA &6F,X        :\ AEB2= B5 6F       5o
STA &0229,X      :\ AEB4= 9D 29 02    .).
DEX              :\ AEB7= CA          J
BNE LAEB2        :\ AEB8= D0 F8       Px
LDA #&E6         :\ AEBA= A9 E6       )f
JSR LB823        :\ AEBC= 20 23 B8     #8
LDA #&CB         :\ AEBF= A9 CB       )K
LDX #&09         :\ AEC1= A2 09       ".
JSR LB825        :\ AEC3= 20 25 B8     %8
JSR LB11A        :\ AEC6= 20 1A B1     .1
INC A            :\ AEC9= 1A          .
.LAECA
JSR LB823        :\ AECA= 20 23 B8     #8
DEC A            :\ AECD= 3A          :
CMP #&01         :\ AECE= C9 01       I.
BNE LAECA        :\ AED0= D0 F8       Px
BRA LAE6A        :\ AED2= 80 96       ..
 
PHP              :\ AED4= 08          .
SEI              :\ AED5= 78          x
CPX #&01         :\ AED6= E0 01       `.
BNE LAF0B        :\ AED8= D0 31       P1
BIT &77          :\ AEDA= 24 77       $w
BPL LAEEC        :\ AEDC= 10 0E       ..
CMP #&13         :\ AEDE= C9 13       I.
BEQ LAEE7        :\ AEE0= F0 05       p.
CMP #&11         :\ AEE2= C9 11       I.
BNE LAEEC        :\ AEE4= D0 06       P.
CLC              :\ AEE6= 18          .
.LAEE7
ROR &78          :\ AEE7= 66 78       fx
.LAEE9
PLP              :\ AEE9= 28          (
CLC              :\ AEEA= 18          .
RTS              :\ AEEB= 60          `
 
.LAEEC
BIT &74          :\ AEEC= 24 74       $t
BPL LAF0B        :\ AEEE= 10 1B       ..
PHA              :\ AEF0= 48          H
SEC              :\ AEF1= 38          8
JSR LAF0F        :\ AEF2= 20 0F AF     ./
TYA              :\ AEF5= 98          .
BNE LAF08        :\ AEF6= D0 10       P.
CPX #&20         :\ AEF8= E0 20       ` 
BCS LAF08        :\ AEFA= B0 0C       0.
LDA #&13         :\ AEFC= A9 13       ).
CPX #&10         :\ AEFE= E0 10       `.
BCC LAF06        :\ AF00= 90 04       ..
CMP &76          :\ AF02= C5 76       Ev
BEQ LAF08        :\ AF04= F0 02       p.
.LAF06
STA &75          :\ AF06= 85 75       .u
.LAF08
PLA              :\ AF08= 68          h
LDX #&01         :\ AF09= A2 01       ".
.LAF0B
PLP              :\ AF0B= 28          (
JMP (&0070)      :\ AF0C= 6C 70 00    lp.
 
.LAF0F
CLV              :\ AF0F= B8          8
JMP (&022E)      :\ AF10= 6C 2E 02    l..
 
PHP              :\ AF13= 08          .
SEI              :\ AF14= 78          x
CPX #&01         :\ AF15= E0 01       `.
BNE LAF37        :\ AF17= D0 1E       P.
BIT &74          :\ AF19= 24 74       $t
BPL LAF33        :\ AF1B= 10 16       ..
CLC              :\ AF1D= 18          .
JSR LAF0F        :\ AF1E= 20 0F AF     ./
CPY #&00         :\ AF21= C0 00       @.
BNE LAF31        :\ AF23= D0 0C       P.
CPX #&20         :\ AF25= E0 20       ` 
BCS LAF31        :\ AF27= B0 08       0.
LDA #&11         :\ AF29= A9 11       ).
CMP &76          :\ AF2B= C5 76       Ev
BEQ LAF31        :\ AF2D= F0 02       p.
STA &75          :\ AF2F= 85 75       .u
.LAF31
LDX #&01         :\ AF31= A2 01       ".
.LAF33
PLP              :\ AF33= 28          (
JMP (&0072)      :\ AF34= 6C 72 00    lr.
 
.LAF37
CPX #&02         :\ AF37= E0 02       `.
BNE LAF33        :\ AF39= D0 F8       Px
LDA &75          :\ AF3B= A5 75       %u
TAY              :\ AF3D= A8          (
BEQ LAF48        :\ AF3E= F0 08       p.
BVS LAEE9        :\ AF40= 70 A7       p'
STZ &75          :\ AF42= 64 75       du
STA &76          :\ AF44= 85 76       .v
BRA LAEE9        :\ AF46= 80 A1       .!
 
.LAF48
LDA &78          :\ AF48= A5 78       %x
BPL LAF33        :\ AF4A= 10 E7       .g
PLP              :\ AF4C= 28          (
SEC              :\ AF4D= 38          8
.LAF4E
RTS              :\ AF4E= 60          `
 
LDA #&DA         :\ AF4F= A9 DA       )Z
JSR LB823        :\ AF51= 20 23 B8     #8
JSR LB634        :\ AF54= 20 34 B6     46
LDY #&00         :\ AF57= A0 00        .
LDA (&FD),Y      :\ AF59= B1 FD       1}
BNE LAF63        :\ AF5B= D0 06       P.
STZ &20          :\ AF5D= 64 20       d 
LDA #&16         :\ AF5F= A9 16       ).
STA &6F          :\ AF61= 85 6F       .o
.LAF63
LDA #&0D         :\ AF63= A9 0D       ).
.LAF65
JSR OSASCI       :\ AF65= 20 E3 FF     c.
INY              :\ AF68= C8          H
LDA (&FD),Y      :\ AF69= B1 FD       1}
BNE LAF65        :\ AF6B= D0 F8       Px
JSR OSNEWL       :\ AF6D= 20 E7 FF     g.
SEC              :\ AF70= 38          8
ROR &19          :\ AF71= 66 19       f.
LDA &1A          :\ AF73= A5 1A       %.
BNE LAFF4        :\ AF75= D0 7D       P}
.LAF77
DEC A            :\ AF77= 3A          :
BNE LAF4E        :\ AF78= D0 D4       PT
LDA #&01         :\ AF7A= A9 01       ).
STA &6F          :\ AF7C= 85 6F       .o
.LAF7E
SEI              :\ AF7E= 78          x
LDX #&FE         :\ AF7F= A2 FE       "~
TXS              :\ AF81= 9A          .
LDA #&4F         :\ AF82= A9 4F       )O
STA &0202        :\ AF84= 8D 02 02    ...
LDA #&AF         :\ AF87= A9 AF       )/
STA &0203        :\ AF89= 8D 03 02    ...
LDA #&B1         :\ AF8C= A9 B1       )1
STA &0230        :\ AF8E= 8D 30 02    .0.
LDA #&B7         :\ AF91= A9 B7       )7
STA &0231        :\ AF93= 8D 31 02    .1.
LDA #&B1         :\ AF96= A9 B1       )1
STA &0232        :\ AF98= 8D 32 02    .2.
LDA #&B7         :\ AF9B= A9 B7       )7
STA &0233        :\ AF9D= 8D 33 02    .3.
LDX #&6E         :\ AFA0= A2 6E       "n
.LAFA2
STZ &00,X        :\ AFA2= 74 00       t.
DEX              :\ AFA4= CA          J
BPL LAFA2        :\ AFA5= 10 FB       .{
DEC &21          :\ AFA7= C6 21       F!
DEC &34          :\ AFA9= C6 34       F4
DEC &36          :\ AFAB= C6 36       F6
CLI              :\ AFAD= 58          X
LDA #&0B         :\ AFAE= A9 0B       ).
JSR LB690        :\ AFB0= 20 90 B6     .6
LDA #&87         :\ AFB3= A9 87       ).
JSR OSBYTE       :\ AFB5= 20 F4 FF     t.
TYA              :\ AFB8= 98          .
JSR LB579        :\ AFB9= 20 79 B5     y5
LDY #&FF         :\ AFBC= A0 FF        .
.LAFBE
INY              :\ AFBE= C8          H
LDA LAFCE,Y      :\ AFBF= B9 CE AF    9N/
BEQ LAFF4        :\ AFC2= F0 30       p0
LDX LAFE1,Y      :\ AFC4= BE E1 AF    >a/
PHY              :\ AFC7= 5A          Z
JSR LB825        :\ AFC8= 20 25 B8     %8
PLY              :\ AFCB= 7A          z
BRA LAFBE        :\ AFCC= 80 F0       .p
 
.LAFCE
EQUB &CB         :\ AFCE= CB          K
RTS              :\ AFCF= 60          `
 
RTS              :\ AFD0= 60          `
 
RTS              :\ AFD1= 60          `
 
EQUB &0F         :\ AFD2= 0F          .
EQUB &0F         :\ AFD3= 0F          .
CMP LDFDE,X      :\ AFD4= DD DE DF    ]^_
CPX #&E1         :\ AFD7= E0 E1       `a
EQUB &E2         :\ AFD9= E2          b
EQUB &E3         :\ AFDA= E3          c
CPX &E5          :\ AFDB= E4 E5       de
TSB &7E          :\ AFDD= 04 7E       .~
INC &02          :\ AFDF= E6 02       f.
.LAFE1
BRK              :\ AFE1= 00          .
ORA (&03,X)      :\ AFE2= 01 03       ..
EQUB &FF         :\ AFE4= FF          .
ORA (&02,X)      :\ AFE5= 01 02       ..
CPY #&D0         :\ AFE7= C0 D0       @P
CPX #&F0         :\ AFE9= E0 F0       `p
ORA (&90,X)      :\ AFEB= 01 90       ..
LDY #&A0         :\ AFED= A0 A0         
ORA (&00,X)      :\ AFEF= 01 00       ..
BRK              :\ AFF1= 00          .
ORA (&02,X)      :\ AFF2= 01 02       ..
.LAFF4
LDX #&FE         :\ AFF4= A2 FE       "~
TXS              :\ AFF6= 9A          .
SEC              :\ AFF7= 38          8
ROR &1A          :\ AFF8= 66 1A       f.
STZ &1D          :\ AFFA= 64 1D       d.
JSR LB004        :\ AFFC= 20 04 B0     .0
JSR LB004        :\ AFFF= 20 04 B0     .0
BRA LB030        :\ B002= 80 2C       .,
 
.LB004
JSR LB041        :\ B004= 20 41 B0     A0
LDY #&01         :\ B007= A0 01        .
STA (&1B),Y      :\ B009= 91 1B       ..
INY              :\ B00B= C8          H
TXA              :\ B00C= 8A          .
STA (&1B),Y      :\ B00D= 91 1B       ..
INY              :\ B00F= C8          H
TYA              :\ B010= 98          .
STA (&1B),Y      :\ B011= 91 1B       ..
ASL A            :\ B013= 0A          .
STA (&1B)        :\ B014= 92 1B       ..
RTS              :\ B016= 60          `
 
.LB017
PHP              :\ B017= 08          .
PHA              :\ B018= 48          H
PHX              :\ B019= DA          Z
PHY              :\ B01A= 5A          Z
TSX              :\ B01B= BA          :
INX              :\ B01C= E8          h
TXA              :\ B01D= 8A          .
EOR #&FF         :\ B01E= 49 FF       I.
STA (&1B)        :\ B020= 92 1B       ..
TAY              :\ B022= A8          (
.LB023
PLA              :\ B023= 68          h
STA (&1B),Y      :\ B024= 91 1B       ..
DEY              :\ B026= 88          .
BNE LB023        :\ B027= D0 FA       Pz
LDA #&20         :\ B029= A9 20       ) 
STA &1E          :\ B02B= 85 1E       ..
JSR LB041        :\ B02D= 20 41 B0     A0
.LB030
LDA (&1B)        :\ B030= B2 1B       2.
TAX              :\ B032= AA          *
LDY #&00         :\ B033= A0 00        .
.LB035
INY              :\ B035= C8          H
LDA (&1B),Y      :\ B036= B1 1B       1.
PHA              :\ B038= 48          H
DEX              :\ B039= CA          J
BNE LB035        :\ B03A= D0 F9       Py
PLY              :\ B03C= 7A          z
PLX              :\ B03D= FA          z
PLA              :\ B03E= 68          h
PLP              :\ B03F= 28          (
RTS              :\ B040= 60          `
 
.LB041
LDY #&04         :\ B041= A0 04        .
STY &1C          :\ B043= 84 1C       ..
LDY #&20         :\ B045= A0 20         
LDX #&50         :\ B047= A2 50       "P
LDA #&B6         :\ B049= A9 B6       )6
LSR &1D          :\ B04B= 46 1D       F.
BCS LB05B        :\ B04D= B0 0C       0.
INC &1D          :\ B04F= E6 1D       f.
LDY #&04         :\ B051= A0 04        .
STY &1C          :\ B053= 84 1C       ..
LDY #&00         :\ B055= A0 00        .
LDX #&5D         :\ B057= A2 5D       "]
LDA #&B0         :\ B059= A9 B0       )0
.LB05B
STY &1B          :\ B05B= 84 1B       ..
RTS              :\ B05D= 60          `
 
.LB05E
JSR LB063        :\ B05E= 20 63 B0     c0
BRA LB05E        :\ B061= 80 FB       .{
 
.LB063
BIT &20          :\ B063= 24 20       $ 
BPL LB06C        :\ B065= 10 05       ..
JSR LB096        :\ B067= 20 96 B0     .0
BCC LB083        :\ B06A= 90 17       ..
.LB06C
BRA LB017        :\ B06C= 80 A9       .)
 
.LB06E
CMP #&0A         :\ B06E= C9 0A       I.
BCC LB081        :\ B070= 90 0F       ..
LDX #&00         :\ B072= A2 00       ".
.LB074
INX              :\ B074= E8          h
SBC #&0A         :\ B075= E9 0A       i.
CMP #&0A         :\ B077= C9 0A       I.
BCS LB074        :\ B079= B0 F9       0y
PHA              :\ B07B= 48          H
TXA              :\ B07C= 8A          .
JSR LB06E        :\ B07D= 20 6E B0     n0
PLA              :\ B080= 68          h
.LB081
ORA #&30         :\ B081= 09 30       .0
.LB083
PHA              :\ B083= 48          H
PHY              :\ B084= 5A          Z
TAY              :\ B085= A8          (
LDA #&8A         :\ B086= A9 8A       ).
LDX #&02         :\ B088= A2 02       ".
JSR OSBYTE       :\ B08A= 20 F4 FF     t.
PLY              :\ B08D= 7A          z
PLA              :\ B08E= 68          h
BCC LB0B0        :\ B08F= 90 1F       ..
JSR LB017        :\ B091= 20 17 B0     .0
BRA LB083        :\ B094= 80 ED       .m
 
.LB096
LDY &6F          :\ B096= A4 6F       $o
BEQ LB0B1        :\ B098= F0 17       p.
INC &6F          :\ B09A= E6 6F       fo
LDA LB14B,Y      :\ B09C= B9 4B B1    9K1
BPL LB0AE        :\ B09F= 10 0D       ..
STZ &6F          :\ B0A1= 64 6F       do
PHA              :\ B0A3= 48          H
LDA #&D9         :\ B0A4= A9 D9       )Y
JSR LB823        :\ B0A6= 20 23 B8     #8
PLA              :\ B0A9= 68          h
LDY #&18         :\ B0AA= A0 18        .
STY &1F          :\ B0AC= 84 1F       ..
.LB0AE
ASL A            :\ B0AE= 0A          .
LSR A            :\ B0AF= 4A          J
.LB0B0
RTS              :\ B0B0= 60          `
 
.LB0B1
LDA #&81         :\ B0B1= A9 81       ).
JSR LB823        :\ B0B3= 20 23 B8     #8
TXA              :\ B0B6= 8A          .
BCS LB0B0        :\ B0B7= B0 F7       0w
BPL LB0B0        :\ B0B9= 10 F5       .u
CMP #&E0         :\ B0BB= C9 E0       I`
BCS LB0B0        :\ B0BD= B0 F1       0q
JSR LB0C4        :\ B0BF= 20 C4 B0     D0
SEC              :\ B0C2= 38          8
.LB0C3
RTS              :\ B0C3= 60          `
 
.LB0C4
CMP #&99         :\ B0C4= C9 99       I.
BEQ LB12A        :\ B0C6= F0 62       pb
AND #&0F         :\ B0C8= 29 0F       ).
BEQ LB0E9        :\ B0CA= F0 1D       p.
CMP #&02         :\ B0CC= C9 02       I.
BCC LB0EE        :\ B0CE= 90 1E       ..
BEQ LB0C3        :\ B0D0= F0 F1       pq
CMP #&04         :\ B0D2= C9 04       I.
BCC LB116        :\ B0D4= 90 40       .@
BEQ LB11A        :\ B0D6= F0 42       pB
CMP #&06         :\ B0D8= C9 06       I.
BCC LB10A        :\ B0DA= 90 2E       ..
BEQ LB0F5        :\ B0DC= F0 17       p.
CMP #&08         :\ B0DE= C9 08       I.
BCC LB0C3        :\ B0E0= 90 E1       .a
BEQ LB11E        :\ B0E2= F0 3A       p:
CMP #&09         :\ B0E4= C9 09       I.
BEQ LB12E        :\ B0E6= F0 46       pF
RTS              :\ B0E8= 60          `
 
.LB0E9
LDA #&0C         :\ B0E9= A9 0C       ).
.LB0EB
JMP OSWRCH       :\ B0EB= 4C EE FF    Ln.
 
.LB0EE
LDA #&16         :\ B0EE= A9 16       ).
STA &6F          :\ B0F0= 85 6F       .o
STZ &20          :\ B0F2= 64 20       d 
RTS              :\ B0F4= 60          `
 
.LB0F5
LDX #&10         :\ B0F5= A2 10       ".
JSR LB101        :\ B0F7= 20 01 B1     .1
AND #&10         :\ B0FA= 29 10       ).
BNE LB113        :\ B0FC= D0 15       P.
.LB0FE
JMP LB7B6        :\ B0FE= 4C B6 B7    L67
 
.LB101
LDA #&EC         :\ B101= A9 EC       )l
LDY #&FF         :\ B103= A0 FF        .
JSR OSBYTE       :\ B105= 20 F4 FF     t.
TXA              :\ B108= 8A          .
RTS              :\ B109= 60          `
 
.LB10A
LDX #&40         :\ B10A= A2 40       "@
JSR LB101        :\ B10C= 20 01 B1     .1
AND #&40         :\ B10F= 29 40       )@
BEQ LB0FE        :\ B111= F0 EB       pk
.LB113
JMP LB7E2        :\ B113= 4C E2 B7    Lb7
 
.LB116
LDA #&02         :\ B116= A9 02       ).
BRA LB0EB        :\ B118= 80 D1       .Q
 
.LB11A
LDA #&03         :\ B11A= A9 03       ).
BRA LB0EB        :\ B11C= 80 CD       .M
 
.LB11E
LDA #&FF         :\ B11E= A9 FF       ).
EOR &21          :\ B120= 45 21       E!
STA &21          :\ B122= 85 21       .!
STA &20          :\ B124= 85 20       . 
BNE LB0FE        :\ B126= D0 D6       PV
BRA LB113        :\ B128= 80 E9       .i
 
.LB12A
LDX #&0C         :\ B12A= A2 0C       ".
BRA LB130        :\ B12C= 80 02       ..
 
.LB12E
LDX #&AF         :\ B12E= A2 AF       "/
.LB130
PHX              :\ B130= DA          Z
LDX #&60         :\ B131= A2 60       "`
JSR LB82A        :\ B133= 20 2A B8     *8
PLX              :\ B136= FA          z
.LB137
PHX              :\ B137= DA          Z
LDA #&13         :\ B138= A9 13       ).
JSR OSBYTE       :\ B13A= 20 F4 FF     t.
PLX              :\ B13D= FA          z
DEX              :\ B13E= CA          J
BNE LB137        :\ B13F= D0 F6       Pv
LDX #&00         :\ B141= A2 00       ".
JSR LB82A        :\ B143= 20 2A B8     *8
.LB146
JSR LB198        :\ B146= 20 98 B1     .1
BCC LB146        :\ B149= 90 FB       .{
.LB14B
RTS              :\ B14B= 60          `
 
EQUB &1B         :\ B14C= 1B          .
LSR &4B2A,X      :\ B14D= 5E 2A 4B    ^*K
EOR &59          :\ B150= 45 59       EY
AND &217C,Y      :\ B152= 39 7C 21    9|!
JMP (&1B59,X)    :\ B155= 7C 59 1B    |Y.
 
EQUB &5C         :\ B158= 5C          \
EQUB &54         :\ B159= 54          T
EOR &52          :\ B15A= 45 52       ER
EOR &4E49        :\ B15C= 4D 49 4E    MIN
EOR (&4C,X)      :\ B15F= 41 4C       AL
ORA &3D0A        :\ B161= 0D 0A 3D    ..=
EQUB &1B         :\ B164= 1B          .
\BNE LB187        :\ B165= D0 20       P
\BVS LB11A        :\ B167= 70 B1       p1
EQUB &D0
.LB166
JSR LB170
BCS LB1C4        :\ B169= B0 59       0Y
CMP #&1B         :\ B16B= C9 1B       I.
BNE LB166        :\ B16D= D0 F7       Pw
RTS              :\ B16F= 60          `
 
.LB170
JSR LB17A        :\ B170= 20 7A B1     z1
CMP #&7F         :\ B173= C9 7F       I.
BEQ LB170        :\ B175= F0 F9       py
CMP #&20         :\ B177= C9 20       I 
RTS              :\ B179= 60          `
 
.LB17A
PHX              :\ B17A= DA          Z
PHY              :\ B17B= 5A          Z
.LB17C
JSR LB189        :\ B17C= 20 89 B1     .1
BCS LB184        :\ B17F= B0 03       0.
PLY              :\ B181= 7A          z
PLX              :\ B182= FA          z
RTS              :\ B183= 60          `
 
.LB184
JSR LB017        :\ B184= 20 17 B0     .0
.LB187
BRA LB17C        :\ B187= 80 F3       .s
 
.LB189
BIT &20          :\ B189= 24 20       $ 
BMI LB190        :\ B18B= 30 03       0.
JMP LB096        :\ B18D= 4C 96 B0    L.0
 
.LB190
BIT &25          :\ B190= 24 25       $%
BMI LB1E0        :\ B192= 30 4C       0L
BIT &23          :\ B194= 24 23       $#
BMI LB1A3        :\ B196= 30 0B       0.
.LB198
LDA #&91         :\ B198= A9 91       ).
LDX #&01         :\ B19A= A2 01       ".
JSR OSBYTE       :\ B19C= 20 F4 FF     t.
TYA              :\ B19F= 98          .
AND &22          :\ B1A0= 25 22       %"
.LB1A2
RTS              :\ B1A2= 60          `
 
.LB1A3
JSR LB198        :\ B1A3= 20 98 B1     .1
BCS LB1A2        :\ B1A6= B0 FA       0z
JSR LB1D0        :\ B1A8= 20 D0 B1     P1
BCC LB201        :\ B1AB= 90 54       .T
ASL A            :\ B1AD= 0A          .
ASL A            :\ B1AE= 0A          .
ASL A            :\ B1AF= 0A          .
ASL A            :\ B1B0= 0A          .
STA &24          :\ B1B1= 85 24       .$
.LB1B3
JSR LB198        :\ B1B3= 20 98 B1     .1
BCC LB1BD        :\ B1B6= 90 05       ..
JSR LB017        :\ B1B8= 20 17 B0     .0
BRA LB1B3        :\ B1BB= 80 F6       .v
 
.LB1BD
JSR LB1D0        :\ B1BD= 20 D0 B1     P1
BCC LB1B3        :\ B1C0= 90 F1       .q
ORA &24          :\ B1C2= 05 24       .$
.LB1C4
CLC              :\ B1C4= 18          .
RTS              :\ B1C5= 60          `
 
.LB1C6
JSR LB166        :\ B1C6= 20 66 B1     f1
BCC LB1D0        :\ B1C9= 90 05       ..
PLX              :\ B1CB= FA          z
PLX              :\ B1CC= FA          z
JMP LB389        :\ B1CD= 4C 89 B3    L.3
 
.LB1D0
CMP #&3A         :\ B1D0= C9 3A       I:
BCS LB1D7        :\ B1D2= B0 03       0.
SBC #&2F         :\ B1D4= E9 2F       i/
RTS              :\ B1D6= 60          `
 
.LB1D7
SBC #&37         :\ B1D7= E9 37       i7
CMP #&10         :\ B1D9= C9 10       I.
BCS LB1C4        :\ B1DB= B0 E7       0g
CMP #&0A         :\ B1DD= C9 0A       I.
.LB1DF
RTS              :\ B1DF= 60          `
 
.LB1E0
STZ &26          :\ B1E0= 64 26       d&
JSR LB198        :\ B1E2= 20 98 B1     .1
BCS LB1DF        :\ B1E5= B0 F8       0x
CMP #&7F         :\ B1E7= C9 7F       I.
BCS LB1DF        :\ B1E9= B0 F4       0t
CMP #&20         :\ B1EB= C9 20       I 
BCS LB203        :\ B1ED= B0 14       0.
BIT &27          :\ B1EF= 24 27       $'
BMI LB201        :\ B1F1= 30 0E       0.
CMP #&07         :\ B1F3= C9 07       I.
BCC LB201        :\ B1F5= 90 0A       ..
BEQ LB240        :\ B1F7= F0 47       pG
CMP #&0B         :\ B1F9= C9 0B       I.
BCC LB240        :\ B1FB= 90 43       .C
CMP #&0D         :\ B1FD= C9 0D       I.
BEQ LB240        :\ B1FF= F0 3F       p?
.LB201
SEC              :\ B201= 38          8
RTS              :\ B202= 60          `
 
.LB203
STZ &27          :\ B203= 64 27       d'
CMP #&7C         :\ B205= C9 7C       I|
BNE LB23E        :\ B207= D0 35       P5
.LB209
JSR LB198        :\ B209= 20 98 B1     .1
BCC LB213        :\ B20C= 90 05       ..
JSR LB017        :\ B20E= 20 17 B0     .0
BRA LB209        :\ B211= 80 F6       .v
 
.LB213
CMP #&20         :\ B213= C9 20       I 
BCC LB242        :\ B215= 90 2B       .+
CMP #&21         :\ B217= C9 21       I!
BNE LB22F        :\ B219= D0 14       P.
LDA #&80         :\ B21B= A9 80       ).
STA &26          :\ B21D= 85 26       .&
.LB21F
JSR LB198        :\ B21F= 20 98 B1     .1
BCC LB229        :\ B222= 90 05       ..
JSR LB017        :\ B224= 20 17 B0     .0
BRA LB21F        :\ B227= 80 F6       .v
 
.LB229
CMP #&20         :\ B229= C9 20       I 
BCC LB21F        :\ B22B= 90 F2       .r
BRA LB203        :\ B22D= 80 D4       .T
 
.LB22F
CMP #&3F         :\ B22F= C9 3F       I?
BNE LB236        :\ B231= D0 03       P.
LDA #&7F         :\ B233= A9 7F       ).
CLC              :\ B235= 18          .
.LB236
BCC LB23E        :\ B236= 90 06       ..
CMP #&7C         :\ B238= C9 7C       I|
BEQ LB23E        :\ B23A= F0 02       p.
AND #&9F         :\ B23C= 29 9F       ).
.LB23E
ORA &26          :\ B23E= 05 26       .&
.LB240
CLC              :\ B240= 18          .
RTS              :\ B241= 60          `
 
.LB242
SEC              :\ B242= 38          8
ROR &27          :\ B243= 66 27       f'
SEC              :\ B245= 38          8
RTS              :\ B246= 60          `
 
.LB247
LDA #&00         :\ B247= A9 00       ).
STA &F2          :\ B249= 85 F2       .r
LDA #&05         :\ B24B= A9 05       ).
STA &F3          :\ B24D= 85 F3       .s
LDY #&00         :\ B24F= A0 00        .
.LB251
JSR LB17A        :\ B251= 20 7A B1     z1
LDX &1F          :\ B254= A6 1F       &.
BEQ LB296        :\ B256= F0 3E       p>
STZ &2B          :\ B258= 64 2B       d+
CMP #&1B         :\ B25A= C9 1B       I.
BNE LB262        :\ B25C= D0 04       P.
LDY #&00         :\ B25E= A0 00        .
BRA LB266        :\ B260= 80 04       ..
 
.LB262
CMP #&0D         :\ B262= C9 0D       I.
BNE LB273        :\ B264= D0 0D       P.
.LB266
LDA #&0D         :\ B266= A9 0D       ).
STA (&F2),Y      :\ B268= 91 F2       .r
BIT &2B          :\ B26A= 24 2B       $+
BMI LB271        :\ B26C= 30 03       0.
JSR OSASCI       :\ B26E= 20 E3 FF     c.
.LB271
CLC              :\ B271= 18          .
RTS              :\ B272= 60          `
 
.LB273
CMP #&7F         :\ B273= C9 7F       I.
BNE LB27E        :\ B275= D0 07       P.
CPY #&00         :\ B277= C0 00       @.
BEQ LB251        :\ B279= F0 D6       pV
DEY              :\ B27B= 88          .
BRA LB291        :\ B27C= 80 13       ..
 
.LB27E
CMP #&7F         :\ B27E= C9 7F       I.
BCS LB251        :\ B280= B0 CF       0O
CMP #&20         :\ B282= C9 20       I 
BCC LB251        :\ B284= 90 CB       .K
CPY #&FF         :\ B286= C0 FF       @.
BCS LB251        :\ B288= B0 C7       0G
STA (&F2),Y      :\ B28A= 91 F2       .r
INY              :\ B28C= C8          H
BIT &2B          :\ B28D= 24 2B       $+
BMI LB251        :\ B28F= 30 C0       0@
.LB291
JSR LB728        :\ B291= 20 28 B7     (7
BRA LB251        :\ B294= 80 BB       .;
 
.LB296
CMP #&1B         :\ B296= C9 1B       I.
BNE LB27E        :\ B298= D0 E4       Pd
JSR LB166        :\ B29A= 20 66 B1     f1
CMP #&5C         :\ B29D= C9 5C       I\
BEQ LB266        :\ B29F= F0 C5       pE
SEC              :\ B2A1= 38          8
RTS              :\ B2A2= 60          `
 
.LB2A3
LDX #&19         :\ B2A3= A2 19       ".
.LB2A5
DEX              :\ B2A5= CA          J
STZ &00,X        :\ B2A6= 74 00       t.
BNE LB2A5        :\ B2A8= D0 FB       P{
.LB2AA
STZ &3A          :\ B2AA= 64 3A       d:
STZ &3B          :\ B2AC= 64 3B       d;
.LB2AE
JSR LB166        :\ B2AE= 20 66 B1     f1
BCS LB2E0        :\ B2B1= B0 2D       0-
JSR LB8AD        :\ B2B3= 20 AD B8     -8
BCC LB2E5        :\ B2B6= 90 2D       .-
PHA              :\ B2B8= 48          H
LDA &3A          :\ B2B9= A5 3A       %:
STA &02,X        :\ B2BB= 95 02       ..
LDA &3B          :\ B2BD= A5 3B       %;
STA &03,X        :\ B2BF= 95 03       ..
PLA              :\ B2C1= 68          h
CMP #&40         :\ B2C2= C9 40       I@
BCS LB2F5        :\ B2C4= B0 2F       0/
CMP #&30         :\ B2C6= C9 30       I0
BCC LB2D7        :\ B2C8= 90 0D       ..
CMP #&3C         :\ B2CA= C9 3C       I<
BCS LB2E3        :\ B2CC= B0 15       0.
INC &00          :\ B2CE= E6 00       f.
INX              :\ B2D0= E8          h
INX              :\ B2D1= E8          h
INX              :\ B2D2= E8          h
CPX #&18         :\ B2D3= E0 18       `.
BCC LB2AA        :\ B2D5= 90 D3       .S
.LB2D7
CMP #&40         :\ B2D7= C9 40       I@
BCS LB2F5        :\ B2D9= B0 1A       0.
JSR LB166        :\ B2DB= 20 66 B1     f1
BCC LB2D7        :\ B2DE= 90 F7       .w
.LB2E0
JMP LB389        :\ B2E0= 4C 89 B3    L.3
 
.LB2E3
STA &01,X        :\ B2E3= 95 01       ..
.LB2E5
LDA &00          :\ B2E5= A5 00       %.
BNE LB2AE        :\ B2E7= D0 C5       PE
INC &00          :\ B2E9= E6 00       f.
BRA LB2AE        :\ B2EB= 80 C1       .A
 
.LB2ED
LDA #&01         :\ B2ED= A9 01       ).
STA &02          :\ B2EF= 85 02       ..
STZ &01          :\ B2F1= 64 01       d.
STZ &03          :\ B2F3= 64 03       d.
.LB2F5
RTS              :\ B2F5= 60          `
 
.LB2F6
LDA #&03         :\ B2F6= A9 03       ).
BRA LB2FC        :\ B2F8= 80 02       ..
 
.LB2FA
LDA #&00         :\ B2FA= A9 00       ).
.LB2FC
PHX              :\ B2FC= DA          Z
TAX              :\ B2FD= AA          *
LDA &01,X        :\ B2FE= B5 01       5.
CMP #&01         :\ B300= C9 01       I.
LDA &03,X        :\ B302= B5 03       5.
BEQ LB307        :\ B304= F0 01       p.
SEC              :\ B306= 38          8
.LB307
LDA &02,X        :\ B307= B5 02       5.
PLX              :\ B309= FA          z
AND #&FF         :\ B30A= 29 FF       ).
RTS              :\ B30C= 60          `
 
.LB30D
PLA              :\ B30D= 68          h
STA &28          :\ B30E= 85 28       .(
PLA              :\ B310= 68          h
STA &29          :\ B311= 85 29       .)
LDA &01          :\ B313= A5 01       %.
BNE LB338        :\ B315= D0 21       P!
LDA &02          :\ B317= A5 02       %.
ORA &03          :\ B319= 05 03       ..
BNE LB31F        :\ B31B= D0 02       P.
INC &02          :\ B31D= E6 02       f.
.LB31F
LDA &02          :\ B31F= A5 02       %.
BNE LB325        :\ B321= D0 02       P.
DEC &03          :\ B323= C6 03       F.
.LB325
DEC &02          :\ B325= C6 02       F.
BNE LB32D        :\ B327= D0 04       P.
LDA &03          :\ B329= A5 03       %.
BEQ LB332        :\ B32B= F0 05       p.
.LB32D
JSR LB332        :\ B32D= 20 32 B3     23
BRA LB31F        :\ B330= 80 ED       .m
 
.LB332
LDA &29          :\ B332= A5 29       %)
PHA              :\ B334= 48          H
LDA &28          :\ B335= A5 28       %(
PHA              :\ B337= 48          H
.LB338
RTS              :\ B338= 60          `
 
.LB339
DEC &1E          :\ B339= C6 1E       F.
BNE LB340        :\ B33B= D0 03       P.
JSR LB017        :\ B33D= 20 17 B0     .0
.LB340
LDA &6F          :\ B340= A5 6F       %o
BNE LB348        :\ B342= D0 04       P.
LDA &21          :\ B344= A5 21       %!
STA &20          :\ B346= 85 20       . 
.LB348
RTS              :\ B348= 60          `
 
.LB349
JSR LB34E        :\ B349= 20 4E B3     N3
BRA LB349        :\ B34C= 80 FB       .{
 
.LB34E
JSR LB339        :\ B34E= 20 39 B3     93
JSR LB170        :\ B351= 20 70 B1     p1
.LB354
CMP #&20         :\ B354= C9 20       I 
BCC LB361        :\ B356= 90 09       ..
JMP LB728        :\ B358= 4C 28 B7    L(7
 
.LB35B
JMP LB46C        :\ B35B= 4C 6C B4    Ll4
 
.LB35E
JMP LB493        :\ B35E= 4C 93 B4    L.4
 
.LB361
PHA              :\ B361= 48          H
JSR LB2ED        :\ B362= 20 ED B2     m2
PLA              :\ B365= 68          h
CMP #&07         :\ B366= C9 07       I.
BCC LB3BB        :\ B368= 90 51       .Q
BEQ LB3E9        :\ B36A= F0 7D       p}
CMP #&09         :\ B36C= C9 09       I.
BCC LB35B        :\ B36E= 90 EB       .k
BEQ LB35E        :\ B370= F0 EC       pl
CMP #&0B         :\ B372= C9 0B       I.
BCC LB3EE        :\ B374= 90 78       .x
CMP #&0D         :\ B376= C9 0D       I.
BEQ LB3E9        :\ B378= F0 6F       po
CMP #&1B         :\ B37A= C9 1B       I.
BNE LB3BB        :\ B37C= D0 3D       P=
.LB37E
LDX &6F          :\ B37E= A6 6F       &o
BNE LB386        :\ B380= D0 04       P.
BIT &2D          :\ B382= 24 2D       $-
BMI LB3BB        :\ B384= 30 35       05
.LB386
JSR LB166        :\ B386= 20 66 B1     f1
.LB389
CMP #&1B         :\ B389= C9 1B       I.
BEQ LB37E        :\ B38B= F0 F1       pq
CMP #&25         :\ B38D= C9 25       I%
BEQ LB401        :\ B38F= F0 70       pp
CMP #&28         :\ B391= C9 28       I(
BEQ LB404        :\ B393= F0 6F       po
CMP #&44         :\ B395= C9 44       ID
BEQ LB3EE        :\ B397= F0 55       pU
CMP #&45         :\ B399= C9 45       IE
BEQ LB3EB        :\ B39B= F0 4E       pN
CMP #&4D         :\ B39D= C9 4D       IM
BEQ LB3E7        :\ B39F= F0 46       pF
CMP #&50         :\ B3A1= C9 50       IP
BEQ LB3C5        :\ B3A3= F0 20       p 
CMP #&5B         :\ B3A5= C9 5B       I[
BEQ LB407        :\ B3A7= F0 5E       p^
CMP #&5D         :\ B3A9= C9 5D       I]
STZ &2B          :\ B3AB= 64 2B       d+
BEQ LB3F6        :\ B3AD= F0 47       pG
CMP #&5E         :\ B3AF= C9 5E       I^
BEQ LB3F3        :\ B3B1= F0 40       p@
CMP #&5F         :\ B3B3= C9 5F       I_
BEQ LB3BC        :\ B3B5= F0 05       p.
CMP #&63         :\ B3B7= C9 63       Ic
BEQ LB3FE        :\ B3B9= F0 43       pC
.LB3BB
RTS              :\ B3BB= 60          `
 
.LB3BC
JSR LB247        :\ B3BC= 20 47 B2     G2
BCS LB389        :\ B3BF= B0 C8       0H
.LB3C1
SEC              :\ B3C1= 38          8
JMP (&0232)      :\ B3C2= 6C 32 02    l2.
 
.LB3C5
SEC              :\ B3C5= 38          8
ROR &2B          :\ B3C6= 66 2B       f+
JSR LB247        :\ B3C8= 20 47 B2     G2
BCS LB389        :\ B3CB= B0 BC       0<
LDX &1F          :\ B3CD= A6 1F       &.
STZ &1F          :\ B3CF= 64 1F       d.
BEQ LB3E4        :\ B3D1= F0 11       p.
LDY #&00         :\ B3D3= A0 00        .
JSR LB89E        :\ B3D5= 20 9E B8     .8
BEQ LB3BB        :\ B3D8= F0 E1       pa
STX &6F          :\ B3DA= 86 6F       .o
CMP #&2A         :\ B3DC= C9 2A       I*
BEQ LB3FB        :\ B3DE= F0 1B       p.
CMP #&21         :\ B3E0= C9 21       I!
BEQ LB3C1        :\ B3E2= F0 DD       p]
.LB3E4
JMP LB4F2        :\ B3E4= 4C F2 B4    Lr4
 
.LB3E7
LDA #&0B         :\ B3E7= A9 0B       ).
.LB3E9
BRA LB3F0        :\ B3E9= 80 05       ..
 
.LB3EB
JMP OSNEWL       :\ B3EB= 4C E7 FF    Lg.
 
.LB3EE
LDA #&0A         :\ B3EE= A9 0A       ).
.LB3F0
JMP OSWRCH       :\ B3F0= 4C EE FF    Ln.
 
.LB3F3
SEC              :\ B3F3= 38          8
ROR &2B          :\ B3F4= 66 2B       f+
.LB3F6
JSR LB247        :\ B3F6= 20 47 B2     G2
BCS LB389        :\ B3F9= B0 8E       0.
.LB3FB
JMP LB61F        :\ B3FB= 4C 1F B6    L.6
 
.LB3FE
JMP LAF7E        :\ B3FE= 4C 7E AF    L~/
 
.LB401
JMP LB640        :\ B401= 4C 40 B6    L@6
 
.LB404
JMP LB68B        :\ B404= 4C 8B B6    L.6
 
.LB407
JSR LB2A3        :\ B407= 20 A3 B2     #2
LDX #&0E         :\ B40A= A2 0E       ".
.LB40C
CMP LB41E-1,X      :\ B40C= DD 1D B4    ].4
BEQ LB418        :\ B40F= F0 07       p.
DEX              :\ B411= CA          J
BNE LB40C        :\ B412= D0 F8       Px
SEC              :\ B414= 38          8
JMP (&0230)      :\ B415= 6C 30 02    l0.
 
.LB418
TXA              :\ B418= 8A          .
ASL A            :\ B419= 0A          .
TAX              :\ B41A= AA          *
JMP (LB42A,X)    :\ B41B= 7C 2A B4    |*4
 .LB41E
EOR (&42,X)      :\ B41E= 41 42       AB
EQUB &43         :\ B420= 43          C
EQUB &44         :\ B421= 44          D
PHA              :\ B422= 48          H
LSR A            :\ B423= 4A          J
EQUB &4B         :\ B424= 4B          K
EQUB &53         :\ B425= 53          S
CLI              :\ B426= 58          X
PLA              :\ B427= 68          h
\JMP (&666E)      :\ B428= 6C 6E 66    lnf
EQUB &6C
EQUB &6E
.LB42A
EQUB &66
 
EQUB &63         :\ B42B= 63          c
CMP &B4          :\ B42C= C5 B4       E4
STA &B4          :\ B42E= 85 B4       .4
EQUB &93         :\ B430= 93          .
LDY &6C,X        :\ B431= B4 6C       4l
LDY &A7,X        :\ B433= B4 A7       4'
LDY &FD,X        :\ B435= B4 FD       4}
LDA &0D,X        :\ B437= B5 0D       5.
LDX &20,Y        :\ B439= B6 20       6 
EQUB &B7         :\ B43B= B7          7
SBC (&B5,X)      :\ B43C= E1 B5       a5
LDA (&B6),Y      :\ B43E= B1 B6       16
LDA LA9B6        :\ B440= AD B6 A9    -6)
LDA &A7,X        :\ B443= B5 A7       5'
LDY &D1,X        :\ B445= B4 D1       4Q
\LDY &20,X        :\ B447= B4 20       4
\EOR L80B4        :\ B449= 4D B4 80    M4.
\EQUB &FB         :\ B44C= FB          {
EQUB &B4
.LB448
JSR LB44D
BRA LB448
.LB44D
JSR LB339        :\ B44D= 20 39 B3     93
JSR LB17A        :\ B450= 20 7A B1     z1
CMP #&1B         :\ B453= C9 1B       I.
BNE LB466        :\ B455= D0 0F       P.
LDA #&DA         :\ B457= A9 DA       )Z
LDY #&FF         :\ B459= A0 FF        .
LDX #&00         :\ B45B= A2 00       ".
JSR OSBYTE       :\ B45D= 20 F4 FF     t.
LDA #&1B         :\ B460= A9 1B       ).
CPX #&00         :\ B462= E0 00       `.
BEQ LB469        :\ B464= F0 03       p.
.LB466
JMP OSWRCH       :\ B466= 4C EE FF    Ln.
 
.LB469
JMP LB37E        :\ B469= 4C 7E B3    L~3
 
.LB46C
LDA #&08         :\ B46C= A9 08       ).
STA &2C          :\ B46E= 85 2C       .,
JSR LB30D        :\ B470= 20 0D B3     .3
JSR LB821        :\ B473= 20 21 B8     !8
TXA              :\ B476= 8A          .
BNE LB480        :\ B477= D0 07       P.
BIT &34          :\ B479= 24 34       $4
BPL LB4E2        :\ B47B= 10 65       .e
.LB47D
TYA              :\ B47D= 98          .
.LB47E
BEQ LB4E2        :\ B47E= F0 62       pb
.LB480
LDA &2C          :\ B480= A5 2C       %,
.LB482
JMP OSWRCH       :\ B482= 4C EE FF    Ln.
 
LDA #&0A         :\ B485= A9 0A       ).
STA &2C          :\ B487= 85 2C       .,
JSR LB30D        :\ B489= 20 0D B3     .3
JSR LB821        :\ B48C= 20 21 B8     !8
.LB48F
CPY &39          :\ B48F= C4 39       D9
BRA LB47E        :\ B491= 80 EB       .k
 
.LB493
LDA #&09         :\ B493= A9 09       ).
STA &2C          :\ B495= 85 2C       .,
JSR LB30D        :\ B497= 20 0D B3     .3
JSR LB821        :\ B49A= 20 21 B8     !8
CPX &37          :\ B49D= E4 37       d7
.LB49F
BCC LB480        :\ B49F= 90 DF       ._
LDA &34          :\ B4A1= A5 34       %4
BEQ LB4E2        :\ B4A3= F0 3D       p=
BRA LB48F        :\ B4A5= 80 E8       .h
 
JSR LB2FA        :\ B4A7= 20 FA B2     z2
BCS LB4E2        :\ B4AA= B0 36       06
TAY              :\ B4AC= A8          (
BEQ LB4B0        :\ B4AD= F0 01       p.
DEY              :\ B4AF= 88          .
.LB4B0
JSR LB2F6        :\ B4B0= 20 F6 B2     v2
BCS LB4E2        :\ B4B3= B0 2D       0-
TAX              :\ B4B5= AA          *
BEQ LB4B9        :\ B4B6= F0 01       p.
DEX              :\ B4B8= CA          J
.LB4B9
LDA #&1F         :\ B4B9= A9 1F       ).
JSR OSWRCH       :\ B4BB= 20 EE FF     n.
TXA              :\ B4BE= 8A          .
JSR OSWRCH       :\ B4BF= 20 EE FF     n.
TYA              :\ B4C2= 98          .
BRA LB482        :\ B4C3= 80 BD       .=
 
LDA #&0B         :\ B4C5= A9 0B       ).
STA &2C          :\ B4C7= 85 2C       .,
JSR LB30D        :\ B4C9= 20 0D B3     .3
JSR LB821        :\ B4CC= 20 21 B8     !8
BRA LB47D        :\ B4CF= 80 AC       .,
 
JSR LB2FA        :\ B4D1= 20 FA B2     z2
BNE LB4E2        :\ B4D4= D0 0C       P.
TAY              :\ B4D6= A8          (
.LB4D7
LDA #&1B         :\ B4D7= A9 1B       ).
.LB4D9
INY              :\ B4D9= C8          H
JSR LB083        :\ B4DA= 20 83 B0     .0
LDA LB4E2,Y      :\ B4DD= B9 E2 B4    9b4
BNE LB4D9        :\ B4E0= D0 F7       Pw
.LB4E2
RTS              :\ B4E2= 60          `
 
EQUB &5B         :\ B4E3= 5B          [
ROL &6335,X      :\ B4E4= 3E 35 63    >5c
BRK              :\ B4E7= 00          .
EQUB &5B         :\ B4E8= 5B          [
BMI LB559        :\ B4E9= 30 6E       0n
BRK              :\ B4EB= 00          .
EQUB &5B         :\ B4EC= 5B          [
EQUB &33         :\ B4ED= 33          3
ROR &5B00        :\ B4EE= 6E 00 5B    n.[
BRK              :\ B4F1= 00          .
.LB4F2
JSR LB830        :\ B4F2= 20 30 B8     08
BCS LB547        :\ B4F5= B0 50       0P
CMP #&07         :\ B4F7= C9 07       I.
BCS LB518        :\ B4F9= B0 1D       0.
PHA              :\ B4FB= 48          H
JSR LB832        :\ B4FC= 20 32 B8     28
STZ &2E          :\ B4FF= 64 2E       d.
CMP #&0A         :\ B501= C9 0A       I.
BEQ LB50B        :\ B503= F0 06       p.
DEC &2E          :\ B505= C6 2E       F.
CMP #&09         :\ B507= C9 09       I.
BNE LB546        :\ B509= D0 3B       P;
.LB50B
PLY              :\ B50B= 7A          z
CPY #&06         :\ B50C= C0 06       @.
BNE LB515        :\ B50E= D0 05       P.
LDA &2E          :\ B510= A5 2E       %.
STA &34          :\ B512= 85 34       .4
.LB514
RTS              :\ B514= 60          `
 
.LB515
JMP LB6E0        :\ B515= 4C E0 B6    L`6
 
.LB518
CMP #&08         :\ B518= C9 08       I.
BEQ LB53A        :\ B51A= F0 1E       p.
BCS LB54A        :\ B51C= B0 2C       0,
.LB51E
JSR LB89E        :\ B51E= 20 9E B8     .8
BEQ LB514        :\ B521= F0 F1       pq
JSR LB565        :\ B523= 20 65 B5     e5
JSR LB89E        :\ B526= 20 9E B8     .8
BEQ LB535        :\ B529= F0 0A       p.
CMP #&2C         :\ B52B= C9 2C       I,
BNE LB547        :\ B52D= D0 18       P.
INY              :\ B52F= C8          H
JSR LB535        :\ B530= 20 35 B5     55
BRA LB51E        :\ B533= 80 E9       .i
 
.LB535
LDA &3A          :\ B535= A5 3A       %:
JMP OSWRCH       :\ B537= 4C EE FF    Ln.
 
.LB53A
JSR LB89E        :\ B53A= 20 9E B8     .8
JSR LB565        :\ B53D= 20 65 B5     e5
BCS LB547        :\ B540= B0 05       0.
LDA &3A          :\ B542= A5 3A       %:
BRA LB579        :\ B544= 80 33       .3
 
.LB546
PLA              :\ B546= 68          h
.LB547
JMP LB7B3        :\ B547= 4C B3 B7    L37
 
.LB54A
LDY #&00         :\ B54A= A0 00        .
CMP #&0B         :\ B54C= C9 0B       I.
BCC LB547        :\ B54E= 90 F7       .w
BEQ LB561        :\ B550= F0 0F       p.
INY              :\ B552= C8          H
CMP #&0E         :\ B553= C9 0E       I.
BEQ LB561        :\ B555= F0 0A       p.
BCS LB547        :\ B557= B0 EE       0n
.LB559
LDY #&04         :\ B559= A0 04        .
CMP #&0C         :\ B55B= C9 0C       I.
BEQ LB561        :\ B55D= F0 02       p.
LDY #&05         :\ B55F= A0 05        .
.LB561
TYA              :\ B561= 98          .
JMP LB64F        :\ B562= 4C 4F B6    LO6
 
.LB565
JSR LB8A9        :\ B565= 20 A9 B8     )8
BCS LB573        :\ B568= B0 09       0.
.LB56A
INY              :\ B56A= C8          H
LDA (&F2),Y      :\ B56B= B1 F2       1r
JSR LB8AD        :\ B56D= 20 AD B8     -8
BCC LB56A        :\ B570= 90 F8       .x
CLC              :\ B572= 18          .
.LB573
RTS              :\ B573= 60          `
 
JSR LB2FA        :\ B574= 20 FA B2     z2
BCS LB547        :\ B577= B0 CE       0N
.LB579
TAY              :\ B579= A8          (
AND #&7F         :\ B57A= 29 7F       ).
CMP #&08         :\ B57C= C9 08       I.
BCS LB547        :\ B57E= B0 C7       0G
TAX              :\ B580= AA          *
LDA LB5A1,X      :\ B581= BD A1 B5    =!5
LSR A            :\ B584= 4A          J
LDX #&1F         :\ B585= A2 1F       ".
BCS LB58B        :\ B587= B0 02       0.
LDX #&18         :\ B589= A2 18       ".
.LB58B
STX &39          :\ B58B= 86 39       .9
STA &37          :\ B58D= 85 37       .7
INC A            :\ B58F= 1A          .
STA &38          :\ B590= 85 38       .8
LDA #&16         :\ B592= A9 16       ).
JSR OSWRCH       :\ B594= 20 EE FF     n.
TYA              :\ B597= 98          .
JSR OSWRCH       :\ B598= 20 EE FF     n.
ASL A            :\ B59B= 0A          .
CMP #&0E         :\ B59C= C9 0E       I.
ROR &30          :\ B59E= 66 30       f0
RTS              :\ B5A0= 60          `
 
.LB5A1
EQUB &9F         :\ B5A1= 9F          .
EQUB &4F         :\ B5A2= 4F          O
EQUB &27         :\ B5A3= 27          '
STZ &274F,X      :\ B5A4= 9E 4F 27    .O'
LSR &204E        :\ B5A7= 4E 4E 20    NN 
PLX              :\ B5AA= FA          z
LDA (&B0)        :\ B5AB= B2 B0       20
CLI              :\ B5AD= 58          X
CMP #&05         :\ B5AE= C9 05       I.
BEQ LB5D4        :\ B5B0= F0 22       p"
CMP #&06         :\ B5B2= C9 06       I.
.LB5B4
BNE LB606        :\ B5B4= D0 50       PP
JSR LB821        :\ B5B6= 20 21 B8     !8
INX              :\ B5B9= E8          h
PHX              :\ B5BA= DA          Z
INY              :\ B5BB= C8          H
PHY              :\ B5BC= 5A          Z
LDY #&0D         :\ B5BD= A0 0D        .
JSR LB4D7        :\ B5BF= 20 D7 B4     W4
PLA              :\ B5C2= 68          h
JSR LB06E        :\ B5C3= 20 6E B0     n0
LDA #&3B         :\ B5C6= A9 3B       );
JSR LB083        :\ B5C8= 20 83 B0     .0
PLA              :\ B5CB= 68          h
JSR LB06E        :\ B5CC= 20 6E B0     n0
LDA #&52         :\ B5CF= A9 52       )R
JMP LB083        :\ B5D1= 4C 83 B0    L.0
 
.LB5D4
LDY #&05         :\ B5D4= A0 05        .
BIT &19          :\ B5D6= 24 19       $.
STZ &19          :\ B5D8= 64 19       d.
BPL LB5DE        :\ B5DA= 10 02       ..
LDY #&09         :\ B5DC= A0 09        .
.LB5DE
JMP LB4D7        :\ B5DE= 4C D7 B4    LW4
 
JSR LB821        :\ B5E1= 20 21 B8     !8
PHX              :\ B5E4= DA          Z
PHY              :\ B5E5= 5A          Z
LDA #&20         :\ B5E6= A9 20       ) 
STA &2C          :\ B5E8= 85 2C       .,
JSR LB5F2        :\ B5EA= 20 F2 B5     r5
PLY              :\ B5ED= 7A          z
PLX              :\ B5EE= FA          z
JMP LB4B9        :\ B5EF= 4C B9 B4    L94
 
.LB5F2
JSR LB30D        :\ B5F2= 20 0D B3     .3
JSR LB821        :\ B5F5= 20 21 B8     !8
CPX &38          :\ B5F8= E4 38       d8
JMP LB49F        :\ B5FA= 4C 9F B4    L.4
 
JSR LB2FA        :\ B5FD= 20 FA B2     z2
BCS LB606        :\ B600= B0 04       0.
CMP #&03         :\ B602= C9 03       I.
BCC LB618        :\ B604= 90 12       ..
.LB606
RTS              :\ B606= 60          `
 
.LB607
EQUB &0F         :\ B607= 0F          .
EQUB &13         :\ B608= 13          .
INC A            :\ B609= 1A          .
BRK              :\ B60A= 00          .
TSB &0B          :\ B60B= 04 0B       ..
JSR LB2FA        :\ B60D= 20 FA B2     z2
BCS LB606        :\ B610= B0 F4       0t
CMP #&03         :\ B612= C9 03       I.
BCS LB606        :\ B614= B0 F0       0p
ADC #&03         :\ B616= 69 03       i.
.LB618
TAX              :\ B618= AA          *
LDA LB607,X      :\ B619= BD 07 B6    =.6
JMP LB7E6        :\ B61C= 4C E6 B7    Lf7
 
.LB61F
LDA &20          :\ B61F= A5 20       % 
AND &36          :\ B621= 25 36       %6
BPL LB628        :\ B623= 10 03       ..
JMP LB7B3        :\ B625= 4C B3 B7    L37
 
.LB628
LDA #&E5         :\ B628= A9 E5       )e
JSR LB823        :\ B62A= 20 23 B8     #8
LDX #&00         :\ B62D= A2 00       ".
LDY #&05         :\ B62F= A0 05        .
JSR OS_CLI       :\ B631= 20 F7 FF     w.
.LB634
LDA #&E5         :\ B634= A9 E5       )e
LDX #&01         :\ B636= A2 01       ".
JSR LB825        :\ B638= 20 25 B8     %8
LDA #&7E         :\ B63B= A9 7E       )~
JMP OSBYTE       :\ B63D= 4C F4 FF    Lt.
 
.LB640
JSR LB1C6        :\ B640= 20 C6 B1     F1
CMP #&07         :\ B643= C9 07       I.
BCC LB64F        :\ B645= 90 08       ..
BNE LB606        :\ B647= D0 BD       P=
JSR LB166        :\ B649= 20 66 B1     f1
JMP LB354        :\ B64C= 4C 54 B3    LT3
 
.LB64F
STA &2A          :\ B64F= 85 2A       .*
STZ &25          :\ B651= 64 25       d%
STZ &23          :\ B653= 64 23       d#
LDX #&FE         :\ B655= A2 FE       "~
TXS              :\ B657= 9A          .
INX              :\ B658= E8          h
STX &22          :\ B659= 86 22       ."
LDA &2A          :\ B65B= A5 2A       %*
CMP #&06         :\ B65D= C9 06       I.
BCC LB665        :\ B65F= 90 04       ..
ROR &23          :\ B661= 66 23       f#
BRA LB66D        :\ B663= 80 08       ..
 
.LB665
CMP #&04         :\ B665= C9 04       I.
BCC LB67B        :\ B667= 90 12       ..
BEQ LB671        :\ B669= F0 06       p.
ROR &25          :\ B66B= 66 25       f%
.LB66D
STZ &27          :\ B66D= 64 27       d'
LSR &22          :\ B66F= 46 22       F"
.LB671
ROR &30          :\ B671= 66 30       f0
LDA #&21         :\ B673= A9 21       )!
JSR LB7E6        :\ B675= 20 E6 B7     f7
JMP LB448        :\ B678= 4C 48 B4    LH4
 
.LB67B
STZ &30          :\ B67B= 64 30       d0
LSR A            :\ B67D= 4A          J
ROR &2D          :\ B67E= 66 2D       f-
LSR A            :\ B680= 4A          J
ROR &22          :\ B681= 66 22       f"
LDA #&1E         :\ B683= A9 1E       ).
JSR LB7E6        :\ B685= 20 E6 B7     f7
JMP LB349        :\ B688= 4C 49 B3    LI3
 
.LB68B
JSR LB1C6        :\ B68B= 20 C6 B1     F1
BCC LB69B        :\ B68E= 90 0B       ..
.LB690
LSR A            :\ B690= 4A          J
AND #&04         :\ B691= 29 04       ).
BNE LB69C        :\ B693= D0 07       P.
ROR A            :\ B695= 6A          j
LSR A            :\ B696= 4A          J
ADC #&40         :\ B697= 69 40       i@
STA &33          :\ B699= 85 33       .3
.LB69B
RTS              :\ B69B= 60          `
 
.LB69C
STZ &33          :\ B69C= 64 33       d3
LDX #&60         :\ B69E= A2 60       "`
LDY #&23         :\ B6A0= A0 23        #
BCC LB6A8        :\ B6A2= 90 04       ..
PHX              :\ B6A4= DA          Z
PHY              :\ B6A5= 5A          Z
PLX              :\ B6A6= FA          z
PLY              :\ B6A7= 7A          z
.LB6A8
STX &31          :\ B6A8= 86 31       .1
STY &32          :\ B6AA= 84 32       .2
RTS              :\ B6AC= 60          `
 
LDA #&00         :\ B6AD= A9 00       ).
BRA LB6B3        :\ B6AF= 80 02       ..
 
LDA #&FF         :\ B6B1= A9 FF       ).
.LB6B3
STA &2E          :\ B6B3= 85 2E       ..
STZ &2F          :\ B6B5= 64 2F       d/
.LB6B7
LDX &2F          :\ B6B7= A6 2F       &/
INX              :\ B6B9= E8          h
INX              :\ B6BA= E8          h
INX              :\ B6BB= E8          h
CPX #&1B         :\ B6BC= E0 1B       `.
BEQ LB6DF        :\ B6BE= F0 1F       p.
STX &2F          :\ B6C0= 86 2F       ./
JSR LB6C7        :\ B6C2= 20 C7 B6     G6
BRA LB6B7        :\ B6C5= 80 F0       .p
 
.LB6C7
LDY &FFFF,X      :\ B6C7= BC FF FF    <..
LDA &00,X        :\ B6CA= B5 00       5.
BNE LB6DF        :\ B6CC= D0 11       P.
LDA LFFFE,X      :\ B6CE= BD FE FF    =~.
CMP #&3E         :\ B6D1= C9 3E       I>
BCC LB6DF        :\ B6D3= 90 0A       ..
BEQ LB6E0        :\ B6D5= F0 09       p.
LDA &2E          :\ B6D7= A5 2E       %.
CPY #&07         :\ B6D9= C0 07       @.
BNE LB6DF        :\ B6DB= D0 02       P.
STA &34          :\ B6DD= 85 34       .4
.LB6DF
RTS              :\ B6DF= 60          `
 
.LB6E0
LDA &2E          :\ B6E0= A5 2E       %.
CPY #&01         :\ B6E2= C0 01       @.
BCS LB6ED        :\ B6E4= B0 07       0.
INC A            :\ B6E6= 1A          .
ASL A            :\ B6E7= 0A          .
TAX              :\ B6E8= AA          *
LDA #&04         :\ B6E9= A9 04       ).
BRA LB6F6        :\ B6EB= 80 09       ..
 
.LB6ED
BNE LB6F9        :\ B6ED= D0 0A       P.
TAX              :\ B6EF= AA          *
BEQ LB6F4        :\ B6F0= F0 02       p.
LDX #&21         :\ B6F2= A2 21       "!
.LB6F4
LDA #&CB         :\ B6F4= A9 CB       )K
.LB6F6
JMP LB825        :\ B6F6= 4C 25 B8    L%8
 
.LB6F9
CPY #&03         :\ B6F9= C0 03       @.
BCS LB707        :\ B6FB= B0 0A       0.
BIT &20          :\ B6FD= 24 20       $ 
BPL LB704        :\ B6FF= 10 03       ..
TAY              :\ B701= A8          (
BEQ LB6DF        :\ B702= F0 DB       p[
.LB704
STA &36          :\ B704= 85 36       .6
.LB706
RTS              :\ B706= 60          `
 
.LB707
BNE LB712        :\ B707= D0 09       P.
ROL A            :\ B709= 2A          *
LDA #&00         :\ B70A= A9 00       ).
.LB70C
ROL A            :\ B70C= 2A          *
TAX              :\ B70D= AA          *
LDA #&60         :\ B70E= A9 60       )`
BRA LB6F6        :\ B710= 80 E4       .d
 
.LB712
CPY #&05         :\ B712= C0 05       @.
BCS LB71B        :\ B714= B0 05       0.
ROL A            :\ B716= 2A          *
LDA #&01         :\ B717= A9 01       ).
BRA LB70C        :\ B719= 80 F1       .q
 
.LB71B
BNE LB706        :\ B71B= D0 E9       Pi
STA &35          :\ B71D= 85 35       .5
RTS              :\ B71F= 60          `
 
JSR LB30D        :\ B720= 20 0D B3     .3
LDA #&23         :\ B723= A9 23       )#
JMP LB7E6        :\ B725= 4C E6 B7    Lf7
 
.LB728
PHY              :\ B728= 5A          Z
PHX              :\ B729= DA          Z
PHA              :\ B72A= 48          H
BIT &30          :\ B72B= 24 30       $0
BMI LB74C        :\ B72D= 30 1D       0.
CMP #&40         :\ B72F= C9 40       I@
BCC LB739        :\ B731= 90 06       ..
TAY              :\ B733= A8          (
BMI LB739        :\ B734= 30 03       0.
CLC              :\ B736= 18          .
ADC &33          :\ B737= 65 33       e3
.LB739
TAY              :\ B739= A8          (
CPY #&60         :\ B73A= C0 60       @`
BNE LB740        :\ B73C= D0 02       P.
LDA #&BB         :\ B73E= A9 BB       );
.LB740
CPY #&BB         :\ B740= C0 BB       @;
BNE LB746        :\ B742= D0 02       P.
LDA &32          :\ B744= A5 32       %2
.LB746
CPY #&23         :\ B746= C0 23       @#
BNE LB74C        :\ B748= D0 02       P.
LDA &31          :\ B74A= A5 31       %1
.LB74C
PHA              :\ B74C= 48          H
JSR LB821        :\ B74D= 20 21 B8     !8
CPX &38          :\ B750= E4 38       d8
BEQ LB75E        :\ B752= F0 0A       p.
.LB754
PLA              :\ B754= 68          h
JSR OSWRCH       :\ B755= 20 EE FF     n.
PHA              :\ B758= 48          H
.LB759
PLA              :\ B759= 68          h
PLA              :\ B75A= 68          h
PLX              :\ B75B= FA          z
PLY              :\ B75C= 7A          z
RTS              :\ B75D= 60          `
 
.LB75E
BIT &34          :\ B75E= 24 34       $4
BPL LB759        :\ B760= 10 F7       .w
BIT &35          :\ B762= 24 35       $5
BPL LB754        :\ B764= 10 EE       .n
PLA              :\ B766= 68          h
PHA              :\ B767= 48          H
CMP #&20         :\ B768= C9 20       I 
BCC LB754        :\ B76A= 90 E8       .h
BNE LB773        :\ B76C= D0 05       P.
JSR OSNEWL       :\ B76E= 20 E7 FF     g.
BRA LB759        :\ B771= 80 E6       .f
 
.LB773
LDA #&0D         :\ B773= A9 0D       ).
JSR OSWRCH       :\ B775= 20 EE FF     n.
JSR LB4B9        :\ B778= 20 B9 B4     94
LDY #&00         :\ B77B= A0 00        .
.LB77D
PHY              :\ B77D= 5A          Z
LDA #&08         :\ B77E= A9 08       ).
JSR OSWRCH       :\ B780= 20 EE FF     n.
LDA #&87         :\ B783= A9 87       ).
JSR OSBYTE       :\ B785= 20 F4 FF     t.
PLY              :\ B788= 7A          z
TXA              :\ B789= 8A          .
CMP #&20         :\ B78A= C9 20       I 
BEQ LB79B        :\ B78C= F0 0D       p.
STA &0440,Y      :\ B78E= 99 40 04    .@.
INY              :\ B791= C8          H
CPY &38          :\ B792= C4 38       D8
BNE LB77D        :\ B794= D0 E7       Pg
JSR OSNEWL       :\ B796= 20 E7 FF     g.
BRA LB754        :\ B799= 80 B9       .9
 
.LB79B
PHY              :\ B79B= 5A          Z
LDA #&00         :\ B79C= A9 00       ).
JSR LB7E6        :\ B79E= 20 E6 B7     f7
JSR OSNEWL       :\ B7A1= 20 E7 FF     g.
PLY              :\ B7A4= 7A          z
INY              :\ B7A5= C8          H
.LB7A6
DEY              :\ B7A6= 88          .
BEQ LB754        :\ B7A7= F0 AB       p+
LDA &043F,Y      :\ B7A9= B9 3F 04    9?.
JSR OSWRCH       :\ B7AC= 20 EE FF     n.
BRA LB7A6        :\ B7AF= 80 F5       .u
 
BCC LB7F9        :\ B7B1= 90 46       .F
.LB7B3
SEC              :\ B7B3= 38          8
ROR &19          :\ B7B4= 66 19       f.
.LB7B6
LDX #&32         :\ B7B6= A2 32       "2
.LB7B8
LDA #&D5         :\ B7B8= A9 D5       )U
JSR LB825        :\ B7BA= 20 25 B8     %8
PHX              :\ B7BD= DA          Z
LDX #&01         :\ B7BE= A2 01       ".
LDA #&D6         :\ B7C0= A9 D6       )V
JSR LB825        :\ B7C2= 20 25 B8     %8
PHX              :\ B7C5= DA          Z
LDA #&EC         :\ B7C6= A9 EC       )l
LDX #&14         :\ B7C8= A2 14       ".
JSR LB825        :\ B7CA= 20 25 B8     %8
LDA #&07         :\ B7CD= A9 07       ).
JSR OSWRCH       :\ B7CF= 20 EE FF     n.
LDA #&EC         :\ B7D2= A9 EC       )l
JSR LB825        :\ B7D4= 20 25 B8     %8
PLX              :\ B7D7= FA          z
LDA #&D6         :\ B7D8= A9 D6       )V
JSR LB825        :\ B7DA= 20 25 B8     %8
PLX              :\ B7DD= FA          z
LDA #&D5         :\ B7DE= A9 D5       )U
BRA LB825        :\ B7E0= 80 43       .C
 
.LB7E2
LDX #&8C         :\ B7E2= A2 8C       ".
BRA LB7B8        :\ B7E4= 80 D2       .R
 
.LB7E6
TAY              :\ B7E6= A8          (
LDX #&0A         :\ B7E7= A2 0A       ".
LDA #&97         :\ B7E9= A9 97       ).
.LB7EB
ASL A            :\ B7EB= 0A          .
BCS LB7EF        :\ B7EC= B0 01       0.
INY              :\ B7EE= C8          H
.LB7EF
LSR A            :\ B7EF= 4A          J
JSR OSWRCH       :\ B7F0= 20 EE FF     n.
LDA LB7FA,Y      :\ B7F3= B9 FA B7    9z7
DEX              :\ B7F6= CA          J
BNE LB7EB        :\ B7F7= D0 F2       Pr
.LB7F9
RTS              :\ B7F9= 60          `
 
.LB7FA
; PHP              :\ B7FA= 08          .
; ORA &06          :\ B7FB= 05 06       ..
; BRA LB807        :\ B7FD= 80 08       ..
 
; TSB &05          :\ B7FF= 04 05       ..
; BRK              :\ B801= 00          .
; BRK              :\ B802= 00          .
; ORA (&80,X)      :\ B803= 01 80       ..
; PHP              :\ B805= 08          .
; TSB &06          :\ B806= 04 06       ..
; BRA LB812        :\ B808= 80 08       ..
 
; ORA &0A          :\ B80A= 05 0A       ..
; BRA LB816        :\ B80C= 80 08       ..
 
; BRK              :\ B80E= 00          .
; ORA &00          :\ B80F= 05 00       ..
; BRK              :\ B811= 00          .
EQUB &08
EQUB &05
EQUB &06
EQUB &80
EQUB &08
EQUB &04
EQUB &05
EQUB &00
EQUB &00
EQUB &01
EQUB &80
EQUB &08
EQUB &04
EQUB &06
EQUB &80
EQUB &08
EQUB &05
EQUB &0A
EQUB &80
EQUB &08
EQUB &00
EQUB &05
EQUB &00
EQUB &00   

.LB812
\ORA (&80,X)      :\ B812= 01 80       ..
EQUB &01
EQUB &80
\PHP              :\ B814= 08          .
EQUB &08
\BRK              :\ B815= 00          .
EQUB &00
\.LB816
\ASL A            :\ B816= 0A          .
EQUB &0A
\BRA LB829        :\ B817= 80 10       ..
EQUB &80
EQUB &10
\ORA (&80,X)      :\ B819= 01 80       ..
EQUB &01
equb &80
\BPL LB79D        :\ B81B= 10 80       ..
EQUB &10
EQUB &80
EQUB &07         :\ B81D= 07          .
EQUB &00         :\ B81E= 00          .
EQUB &03         :\ B81F= 03          .
\BRA LB7CB        :\ B820= 80 A9       .)
\ LDA &A2          :\ B822= A5 A2       %"
\ BRK              :\ B824= 00          .
EQUB &80
.LB821
LDA #&A5
.LB823
LDX #&00
.LB825
LDY #&00         :\ B825= A0 00        .
.LB827
JMP OSBYTE       :\ B827= 4C F4 FF    Lt.
 
.LB82A
LDA #&9C         :\ B82A= A9 9C       ).
LDY #&9F         :\ B82C= A0 9F        .
BRA LB827        :\ B82E= 80 F7       .w
 
.LB830
LDY #&00         :\ B830= A0 00        .
.LB832
LDX #&FF         :\ B832= A2 FF       ".
PHX              :\ B834= DA          Z
.LB835
PLA              :\ B835= 68          h
INC A            :\ B836= 1A          .
PHA              :\ B837= 48          H
PHY              :\ B838= 5A          Z
JSR LB89E        :\ B839= 20 9E B8     .8
.LB83C
CMP #&2E         :\ B83C= C9 2E       I.
BEQ LB858        :\ B83E= F0 18       p.
CMP #&40         :\ B840= C9 40       I@
BCS LB846        :\ B842= B0 02       0.
LDA #&00         :\ B844= A9 00       ).
.LB846
AND #&5F         :\ B846= 29 5F       )_
INX              :\ B848= E8          h
EOR LB86B,X      :\ B849= 5D 6B B8    ]k8
BEQ LB853        :\ B84C= F0 05       p.
ASL A            :\ B84E= 0A          .
BEQ LB858        :\ B84F= F0 07       p.
BRA LB85D        :\ B851= 80 0A       ..
 
.LB853
INY              :\ B853= C8          H
LDA (&F2),Y      :\ B854= B1 F2       1r
BRA LB83C        :\ B856= 80 E4       .d
 
.LB858
INY              :\ B858= C8          H
PLA              :\ B859= 68          h
PLA              :\ B85A= 68          h
CLC              :\ B85B= 18          .
RTS              :\ B85C= 60          `
 
.LB85D
PLY              :\ B85D= 7A          z
.LB85E
LDA LB86B,X      :\ B85E= BD 6B B8    =k8
BNE LB866        :\ B861= D0 03       P.
SEC              :\ B863= 38          8
PLA              :\ B864= 68          h
RTS              :\ B865= 60          `
 
.LB866
BMI LB835        :\ B866= 30 CD       0M
INX              :\ B868= E8          h
BRA LB85E        :\ B869= 80 F3       .s
 
.LB86B
EQUB &43         :\ B86B= 43          C
EQUB &4B         :\ B86C= 4B          K
CPY &434D        :\ B86D= CC 4D 43    LMC
CPY &5250        :\ B870= CC 50 52    LPR
EQUB &4F         :\ B873= 4F          O
EQUB &D4         :\ B874= D4          T
EOR (&46)        :\ B875= 52 46       RF
EQUB &C3         :\ B877= C3          C
EQUB &54         :\ B878= 54          T
LSR &C3          :\ B879= 46 C3       FC
EQUB &57         :\ B87B= 57          W
EQUB &57         :\ B87C= 57          W
CMP &5741        :\ B87D= CD 41 57    MAW
CMP &4456        :\ B880= CD 56 44    MVD
CMP &4D,X        :\ B883= D5 4D       UM
EQUB &4F         :\ B885= 4F          O
EQUB &44         :\ B886= 44          D
CMP &4F          :\ B887= C5 4F       EO
DEC &464F        :\ B889= CE 4F 46    NOF
DEC &54          :\ B88C= C6 54       FT
EOR &52          :\ B88E= 45 52       ER
EOR &4E49        :\ B890= 4D 49 4E    MIN
EOR (&CC,X)      :\ B893= 41 CC       AL
EQUB &42         :\ B895= 42          B
EQUB &42         :\ B896= 42          B
EQUB &C3         :\ B897= C3          C
EQUB &47         :\ B898= 47          G
EQUB &D3         :\ B899= D3          S
EQUB &54         :\ B89A= 54          T
EQUB &54         :\ B89B= 54          T
\CMP L8800,Y      :\ B89C= D9 00 88    Y..
EQUB &D9
EQUB &00
.LB89E
EQUB &88
.LB89F
INY              :\ B89F= C8          H
LDA (&F2),Y      :\ B8A0= B1 F2       1r
CMP #&20         :\ B8A2= C9 20       I 
BEQ LB89F        :\ B8A4= F0 F9       py
CMP #&0D         :\ B8A6= C9 0D       I.
RTS              :\ B8A8= 60          `
 
.LB8A9
STZ &3A          :\ B8A9= 64 3A       d:
STZ &3B          :\ B8AB= 64 3B       d;
.LB8AD
CMP #&30         :\ B8AD= C9 30       I0
BCC LB8B5        :\ B8AF= 90 04       ..
CMP #&3A         :\ B8B1= C9 3A       I:
BCC LB8B7        :\ B8B3= 90 02       ..
.LB8B5
SEC              :\ B8B5= 38          8
RTS              :\ B8B6= 60          `
 
.LB8B7
SBC #&2F         :\ B8B7= E9 2F       i/
PHA              :\ B8B9= 48          H
LDA &3B          :\ B8BA= A5 3B       %;
PHA              :\ B8BC= 48          H
LDA &3A          :\ B8BD= A5 3A       %:
ASL A            :\ B8BF= 0A          .
ROL &3B          :\ B8C0= 26 3B       &;
ASL A            :\ B8C2= 0A          .
ROL &3B          :\ B8C3= 26 3B       &;
CLC              :\ B8C5= 18          .
ADC &3A          :\ B8C6= 65 3A       e:
STA &3A          :\ B8C8= 85 3A       .:
PLA              :\ B8CA= 68          h
ADC &3B          :\ B8CB= 65 3B       e;
STA &3B          :\ B8CD= 85 3B       .;
ASL &3A          :\ B8CF= 06 3A       .:
ROL &3B          :\ B8D1= 26 3B       &;
PLA              :\ B8D3= 68          h
CLC              :\ B8D4= 18          .
ADC &3A          :\ B8D5= 65 3A       e:
STA &3A          :\ B8D7= 85 3A       .:
BCC LB8DE        :\ B8D9= 90 03       ..
INC &3B          :\ B8DB= E6 3B       f;
CLC              :\ B8DD= 18          .
.LB8DE
RTS              :\ B8DE= 60          `

\ Unused space
\ ============
EQUB &FF         :\ B8DF= FF          .
EQUB &FF         :\ B8E0= FF          .
EQUB &FF         :\ B8E1= FF          .
EQUB &FF         :\ B8E2= FF          .
EQUB &FF         :\ B8E3= FF          .
EQUB &FF         :\ B8E4= FF          .
EQUB &FF         :\ B8E5= FF          .
EQUB &FF         :\ B8E6= FF          .
EQUB &FF         :\ B8E7= FF          .
EQUB &FF         :\ B8E8= FF          .
EQUB &FF         :\ B8E9= FF          .
EQUB &FF         :\ B8EA= FF          .
EQUB &FF         :\ B8EB= FF          .
EQUB &FF         :\ B8EC= FF          .
EQUB &FF         :\ B8ED= FF          .
EQUB &FF         :\ B8EE= FF          .
EQUB &FF         :\ B8EF= FF          .
EQUB &FF         :\ B8F0= FF          .
EQUB &FF         :\ B8F1= FF          .
EQUB &FF         :\ B8F2= FF          .
EQUB &FF         :\ B8F3= FF          .
EQUB &FF         :\ B8F4= FF          .
EQUB &FF         :\ B8F5= FF          .
EQUB &FF         :\ B8F6= FF          .
EQUB &FF         :\ B8F7= FF          .
EQUB &FF         :\ B8F8= FF          .
EQUB &FF         :\ B8F9= FF          .
EQUB &FF         :\ B8FA= FF          .
.LB8FB
EQUB &FF         :\ B8FB= FF          .
EQUB &FF         :\ B8FC= FF          .
EQUB &FF         :\ B8FD= FF          .
EQUB &FF         :\ B8FE= FF          .
EQUB &FF         :\ B8FF= FF          .

\ Default font
\ ============
.LB900
EQUD &00000000:EQUD &00000000 :\ CHR$32  -  
EQUD &18181818:EQUD &00180018 :\ CHR$33  - !
EQUD &006C6C6C:EQUD &00000000 :\ CHR$34  - "
EQUD &367F3636:EQUD &0036367F :\ CHR$35  - #
EQUD &3E683F0C:EQUD &00187E0B :\ CHR$36  - $
EQUD &180C6660:EQUD &00066630 :\ CHR$37  - %
EQUD &386C6C38:EQUD &003B666D :\ CHR$38  - &
EQUD &0030180C:EQUD &00000000 :\ CHR$39  - '
EQUD &3030180C:EQUD &000C1830 :\ CHR$40  - (
EQUD &0C0C1830:EQUD &0030180C :\ CHR$41  - )
EQUD &3C7E1800:EQUD &0000187E :\ CHR$42  - *
EQUD &7E181800:EQUD &00001818 :\ CHR$43  - +
EQUD &00000000:EQUD &30181800 :\ CHR$44  - ,
EQUD &7E000000:EQUD &00000000 :\ CHR$45  - -
EQUD &00000000:EQUD &00181800 :\ CHR$46  - .
EQUD &180C0600:EQUD &00006030 :\ CHR$47  - /
EQUD &7E6E663C:EQUD &003C6676 :\ CHR$48  - 0
EQUD &18183818:EQUD &007E1818 :\ CHR$49  - 1
EQUD &0C06663C:EQUD &007E3018 :\ CHR$50  - 2
EQUD &1C06663C:EQUD &003C6606 :\ CHR$51  - 3
EQUD &6C3C1C0C:EQUD &000C0C7E :\ CHR$52  - 4
EQUD &067C607E:EQUD &003C6606 :\ CHR$53  - 5
EQUD &7C60301C:EQUD &003C6666 :\ CHR$54  - 6
EQUD &180C067E:EQUD &00303030 :\ CHR$55  - 7
EQUD &3C66663C:EQUD &003C6666 :\ CHR$56  - 8
EQUD &3E66663C:EQUD &00380C06 :\ CHR$57  - 9
EQUD &18180000:EQUD &00181800 :\ CHR$58  - :
EQUD &18180000:EQUD &30181800 :\ CHR$59  - ;
EQUD &6030180C:EQUD &000C1830 :\ CHR$60  - <
EQUD &007E0000:EQUD &0000007E :\ CHR$61  - =
EQUD &060C1830:EQUD &0030180C :\ CHR$62  - >
EQUD &180C663C:EQUD &00180018 :\ CHR$63  - ?
EQUD &6A6E663C:EQUD &003C606E :\ CHR$64  - @
EQUD &7E66663C:EQUD &00666666 :\ CHR$65  - A
EQUD &7C66667C:EQUD &007C6666 :\ CHR$66  - B
EQUD &6060663C:EQUD &003C6660 :\ CHR$67  - C
EQUD &66666C78:EQUD &00786C66 :\ CHR$68  - D
EQUD &7C60607E:EQUD &007E6060 :\ CHR$69  - E
EQUD &7C60607E:EQUD &00606060 :\ CHR$70  - F
EQUD &6E60663C:EQUD &003C6666 :\ CHR$71  - G
EQUD &7E666666:EQUD &00666666 :\ CHR$72  - H
EQUD &1818187E:EQUD &007E1818 :\ CHR$73  - I
EQUD &0C0C0C3E:EQUD &00386C0C :\ CHR$74  - J
EQUD &70786C66:EQUD &00666C78 :\ CHR$75  - K
EQUD &60606060:EQUD &007E6060 :\ CHR$76  - L
EQUD &6B7F7763:EQUD &0063636B :\ CHR$77  - M
EQUD &7E766666:EQUD &0066666E :\ CHR$78  - N
EQUD &6666663C:EQUD &003C6666 :\ CHR$79  - O
EQUD &7C66667C:EQUD &00606060 :\ CHR$80  - P
EQUD &6666663C:EQUD &00366C6A :\ CHR$81  - Q
EQUD &7C66667C:EQUD &0066666C :\ CHR$82  - R
EQUD &3C60663C:EQUD &003C6606 :\ CHR$83  - S
EQUD &1818187E:EQUD &00181818 :\ CHR$84  - T
EQUD &66666666:EQUD &003C6666 :\ CHR$85  - U
EQUD &66666666:EQUD &00183C66 :\ CHR$86  - V
EQUD &6B6B6363:EQUD &0063777F :\ CHR$87  - W
EQUD &183C6666:EQUD &0066663C :\ CHR$88  - X
EQUD &3C666666:EQUD &00181818 :\ CHR$89  - Y
EQUD &180C067E:EQUD &007E6030 :\ CHR$90  - Z
EQUD &6060607C:EQUD &007C6060 :\ CHR$91  - [
EQUD &18306000:EQUD &0000060C :\ CHR$92  - \
EQUD &0606063E:EQUD &003E0606 :\ CHR$93  - ]
EQUD &42663C18:EQUD &00000000 :\ CHR$94  - ^
EQUD &00000000:EQUD &FF000000 :\ CHR$95  - _
EQUD &7C30361C:EQUD &007E3030 :\ CHR$96  - `
EQUD &063C0000:EQUD &003E663E :\ CHR$97  - a
EQUD &667C6060:EQUD &007C6666 :\ CHR$98  - b
EQUD &663C0000:EQUD &003C6660 :\ CHR$99  - c
EQUD &663E0606:EQUD &003E6666 :\ CHR$100 - d
EQUD &663C0000:EQUD &003C607E :\ CHR$101 - e
EQUD &7C30301C:EQUD &00303030 :\ CHR$102 - f
EQUD &663E0000:EQUD &3C063E66 :\ CHR$103 - g
EQUD &667C6060:EQUD &00666666 :\ CHR$104 - h
EQUD &18380018:EQUD &003C1818 :\ CHR$105 - i
EQUD &18380018:EQUD &70181818 :\ CHR$106 - j
EQUD &6C666060:EQUD &00666C78 :\ CHR$107 - k
EQUD &18181838:EQUD &003C1818 :\ CHR$108 - l
EQUD &7F360000:EQUD &00636B6B :\ CHR$109 - m
EQUD &667C0000:EQUD &00666666 :\ CHR$110 - n
EQUD &663C0000:EQUD &003C6666 :\ CHR$111 - o
EQUD &667C0000:EQUD &60607C66 :\ CHR$112 - p
EQUD &663E0000:EQUD &07063E66 :\ CHR$113 - q
EQUD &766C0000:EQUD &00606060 :\ CHR$114 - r
EQUD &603E0000:EQUD &007C063C :\ CHR$115 - s
EQUD &307C3030:EQUD &001C3030 :\ CHR$116 - t
EQUD &66660000:EQUD &003E6666 :\ CHR$117 - u
EQUD &66660000:EQUD &00183C66 :\ CHR$118 - v
EQUD &6B630000:EQUD &00367F6B :\ CHR$119 - w
EQUD &3C660000:EQUD &00663C18 :\ CHR$120 - x
EQUD &66660000:EQUD &3C063E66 :\ CHR$121 - y
EQUD &0C7E0000:EQUD &007E3018 :\ CHR$122 - z
EQUD &7018180C:EQUD &000C1818 :\ CHR$123 - {
EQUD &00181818:EQUD &00181818 :\ CHR$124 - |
EQUD &0E181830:EQUD &00301818 :\ CHR$125 - }
EQUD &00466B31:EQUD &00000000 :\ CHR$126 - ~
EQUD &FFFFFFFF:EQUD &FFFFFFFF :\ CHR$127 - 
EQUB &66:EQUB &00:EQUB &3C:EQUB &66:EQUB &7E:EQUB &66:EQUB &66:EQUB &00 ; 128
EQUB &3C:EQUB &66:EQUB &3C:EQUB &66:EQUB &7E:EQUB &66:EQUB &66:EQUB &00 ; 129
EQUB &3F:EQUB &66:EQUB &66:EQUB &7F:EQUB &66:EQUB &66:EQUB &67:EQUB &00 ; 130
EQUB &3C:EQUB &66:EQUB &60:EQUB &60:EQUB &60:EQUB &66:EQUB &3C:EQUB &60 ; 131
EQUB &0C:EQUB &18:EQUB &7E:EQUB &60:EQUB &7C:EQUB &60:EQUB &7E:EQUB &00 ; 132
EQUB &66:EQUB &3C:EQUB &66:EQUB &66:EQUB &66:EQUB &66:EQUB &3C:EQUB &00 ; 133
EQUB &66:EQUB &00:EQUB &66:EQUB &66:EQUB &66:EQUB &66:EQUB &3C:EQUB &00 ; 134
EQUB &7E:EQUB &C3:EQUB &9D:EQUB &B1:EQUB &9D:EQUB &C3:EQUB &7E:EQUB &00 ; 135
EQUB &00:EQUB &18:EQUB &38:EQUB &7F:EQUB &38:EQUB &18:EQUB &00:EQUB &00 ; 136
EQUB &00:EQUB &18:EQUB &1C:EQUB &FE:EQUB &1C:EQUB &18:EQUB &00:EQUB &00 ; 137
EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &7E:EQUB &3C:EQUB &18:EQUB &00 ; 138
EQUB &00:EQUB &18:EQUB &3C:EQUB &7E:EQUB &18:EQUB &18:EQUB &18:EQUB &18 ; 139
EQUB &30:EQUB &18:EQUB &3C:EQUB &06:EQUB &3E:EQUB &66:EQUB &3E:EQUB &00 ; 140
EQUB &30:EQUB &18:EQUB &3C:EQUB &66:EQUB &7E:EQUB &60:EQUB &3C:EQUB &00 ; 141
EQUB &66:EQUB &00:EQUB &3C:EQUB &66:EQUB &7E:EQUB &60:EQUB &3C:EQUB &00 ; 142
EQUB &3C:EQUB &66:EQUB &3C:EQUB &66:EQUB &7E:EQUB &60:EQUB &3C:EQUB &00 ; 143
EQUB &66:EQUB &00:EQUB &3C:EQUB &06:EQUB &3E:EQUB &66:EQUB &3E:EQUB &00 ; 144
EQUB &3C:EQUB &66:EQUB &3C:EQUB &06:EQUB &3E:EQUB &66:EQUB &3E:EQUB &00 ; 145
EQUB &00:EQUB &00:EQUB &3F:EQUB &0D:EQUB &3F:EQUB &6C:EQUB &3F:EQUB &00 ; 146
EQUB &00:EQUB &00:EQUB &3C:EQUB &66:EQUB &60:EQUB &66:EQUB &3C:EQUB &60 ; 147
EQUB &0C:EQUB &18:EQUB &3C:EQUB &66:EQUB &7E:EQUB &60:EQUB &3C:EQUB &00 ; 148
EQUB &66:EQUB &00:EQUB &3C:EQUB &66:EQUB &66:EQUB &66:EQUB &3C:EQUB &00 ; 149
EQUB &66:EQUB &00:EQUB &66:EQUB &66:EQUB &66:EQUB &66:EQUB &3E:EQUB &00 ; 150
EQUB &30:EQUB &18:EQUB &00:EQUB &38:EQUB &18:EQUB &18:EQUB &3C:EQUB &00 ; 151
EQUB &3C:EQUB &66:EQUB &00:EQUB &38:EQUB &18:EQUB &18:EQUB &3C:EQUB &00 ; 152
EQUB &30:EQUB &18:EQUB &00:EQUB &3C:EQUB &66:EQUB &66:EQUB &3C:EQUB &00 ; 153
EQUB &3C:EQUB &66:EQUB &00:EQUB &3C:EQUB &66:EQUB &66:EQUB &3C:EQUB &00 ; 154
EQUB &30:EQUB &18:EQUB &00:EQUB &66:EQUB &66:EQUB &66:EQUB &3E:EQUB &00 ; 155
EQUB &3C:EQUB &66:EQUB &00:EQUB &66:EQUB &66:EQUB &66:EQUB &3E:EQUB &00 ; 156
EQUB &66:EQUB &00:EQUB &66:EQUB &66:EQUB &66:EQUB &3E:EQUB &06:EQUB &3C ; 157
EQUB &00:EQUB &66:EQUB &3C:EQUB &66:EQUB &66:EQUB &3C:EQUB &66:EQUB &00 ; 158
EQUB &3C:EQUB &60:EQUB &3C:EQUB &66:EQUB &3C:EQUB &06:EQUB &3C:EQUB &00 ; 159
EQUB &3C:EQUB &66:EQUB &3C:EQUB &00:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 160
EQUB &00:EQUB &00:EQUB &00:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18 ; 161
EQUB &00:EQUB &00:EQUB &00:EQUB &1F:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 162
EQUB &00:EQUB &00:EQUB &00:EQUB &1F:EQUB &18:EQUB &18:EQUB &18:EQUB &18 ; 163
EQUB &00:EQUB &00:EQUB &00:EQUB &F8:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 164
EQUB &00:EQUB &00:EQUB &00:EQUB &F8:EQUB &18:EQUB &18:EQUB &18:EQUB &18 ; 165
EQUB &00:EQUB &00:EQUB &00:EQUB &FF:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 166
EQUB &00:EQUB &00:EQUB &00:EQUB &FF:EQUB &18:EQUB &18:EQUB &18:EQUB &18 ; 167
EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 168
EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18 ; 169
EQUB &18:EQUB &18:EQUB &18:EQUB &1F:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 170
EQUB &18:EQUB &18:EQUB &18:EQUB &1F:EQUB &18:EQUB &18:EQUB &18:EQUB &18 ; 171
EQUB &18:EQUB &18:EQUB &18:EQUB &F8:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 172
EQUB &18:EQUB &18:EQUB &18:EQUB &F8:EQUB &18:EQUB &18:EQUB &18:EQUB &18 ; 173
EQUB &18:EQUB &18:EQUB &18:EQUB &FF:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 174
EQUB &18:EQUB &18:EQUB &18:EQUB &FF:EQUB &18:EQUB &18:EQUB &18:EQUB &18 ; 175
EQUB &00:EQUB &00:EQUB &00:EQUB &07:EQUB &0C:EQUB &18:EQUB &18:EQUB &18 ; 176
EQUB &00:EQUB &00:EQUB &00:EQUB &E0:EQUB &30:EQUB &18:EQUB &18:EQUB &18 ; 177
EQUB &18:EQUB &18:EQUB &0C:EQUB &07:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 178
EQUB &18:EQUB &18:EQUB &30:EQUB &E0:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 179
EQUB &18:EQUB &00:EQUB &18:EQUB &18:EQUB &30:EQUB &66:EQUB &3C:EQUB &00 ; 180
EQUB &18:EQUB &00:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &00 ; 181
EQUB &36:EQUB &6C:EQUB &00:EQUB &66:EQUB &76:EQUB &6E:EQUB &66:EQUB &00 ; 182
EQUB &36:EQUB &6C:EQUB &00:EQUB &7C:EQUB &66:EQUB &66:EQUB &66:EQUB &00 ; 183
EQUB &18:EQUB &7E:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &00 ; 184
EQUB &18:EQUB &7E:EQUB &18:EQUB &18:EQUB &18:EQUB &7E:EQUB &18:EQUB &00 ; 185
EQUB &18:EQUB &18:EQUB &18:EQUB &00:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 186
EQUB &30:EQUB &18:EQUB &0C:EQUB &00:EQUB &00:EQUB &00:EQUB &00:EQUB &00 ; 187
EQUB &3F:EQUB &7B:EQUB &7B:EQUB &3B:EQUB &1B:EQUB &1B:EQUB &1F:EQUB &00 ; 188
EQUB &00:EQUB &00:EQUB &00:EQUB &18:EQUB &18:EQUB &00:EQUB &00:EQUB &00 ; 189
EQUB &03:EQUB &03:EQUB &06:EQUB &06:EQUB &76:EQUB &1C:EQUB &0C:EQUB &00 ; 190
EQUB &AA:EQUB &55:EQUB &AA:EQUB &55:EQUB &AA:EQUB &55:EQUB &AA:EQUB &55 ; 191
EQUB &3E:EQUB &63:EQUB &67:EQUB &6B:EQUB &73:EQUB &63:EQUB &3E:EQUB &00 ; 192
EQUB &1C:EQUB &36:EQUB &63:EQUB &63:EQUB &7F:EQUB &63:EQUB &63:EQUB &00 ; 193
EQUB &7E:EQUB &33:EQUB &33:EQUB &3E:EQUB &33:EQUB &33:EQUB &7E:EQUB &00 ; 194
EQUB &7F:EQUB &63:EQUB &60:EQUB &60:EQUB &60:EQUB &60:EQUB &60:EQUB &00 ; 195
EQUB &1C:EQUB &1C:EQUB &36:EQUB &36:EQUB &63:EQUB &63:EQUB &7F:EQUB &00 ; 196
EQUB &7F:EQUB &33:EQUB &30:EQUB &3E:EQUB &30:EQUB &33:EQUB &7F:EQUB &00 ; 197
EQUB &7E:EQUB &66:EQUB &0C:EQUB &18:EQUB &30:EQUB &66:EQUB &7E:EQUB &00 ; 198
EQUB &77:EQUB &33:EQUB &33:EQUB &3F:EQUB &33:EQUB &33:EQUB &77:EQUB &00 ; 199
EQUB &3E:EQUB &63:EQUB &63:EQUB &7F:EQUB &63:EQUB &63:EQUB &3E:EQUB &00 ; 200
EQUB &3C:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &3C:EQUB &00 ; 201
EQUB &63:EQUB &66:EQUB &6C:EQUB &78:EQUB &6C:EQUB &66:EQUB &63:EQUB &00 ; 202
EQUB &1C:EQUB &1C:EQUB &36:EQUB &36:EQUB &63:EQUB &63:EQUB &63:EQUB &00 ; 203
EQUB &63:EQUB &77:EQUB &7F:EQUB &6B:EQUB &63:EQUB &63:EQUB &63:EQUB &00 ; 204
EQUB &63:EQUB &73:EQUB &7B:EQUB &6F:EQUB &67:EQUB &63:EQUB &63:EQUB &00 ; 205
EQUB &7E:EQUB &00:EQUB &00:EQUB &3C:EQUB &00:EQUB &00:EQUB &7E:EQUB &00 ; 206
EQUB &3E:EQUB &63:EQUB &63:EQUB &63:EQUB &63:EQUB &63:EQUB &3E:EQUB &00 ; 207
EQUB &7F:EQUB &36:EQUB &36:EQUB &36:EQUB &36:EQUB &36:EQUB &36:EQUB &00 ; 208
EQUB &7E:EQUB &33:EQUB &33:EQUB &3E:EQUB &30:EQUB &30:EQUB &78:EQUB &00 ; 209
EQUB &7F:EQUB &63:EQUB &30:EQUB &18:EQUB &30:EQUB &63:EQUB &7F:EQUB &00 ; 210
EQUB &7E:EQUB &5A:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &00 ; 211
EQUB &66:EQUB &66:EQUB &66:EQUB &3C:EQUB &18:EQUB &18:EQUB &3C:EQUB &00 ; 212
EQUB &3E:EQUB &08:EQUB &3E:EQUB &6B:EQUB &3E:EQUB &08:EQUB &3E:EQUB &00 ; 213
EQUB &63:EQUB &63:EQUB &36:EQUB &1C:EQUB &36:EQUB &63:EQUB &63:EQUB &00 ; 214
EQUB &3E:EQUB &08:EQUB &6B:EQUB &6B:EQUB &3E:EQUB &08:EQUB &3E:EQUB &00 ; 215
EQUB &3E:EQUB &63:EQUB &63:EQUB &63:EQUB &36:EQUB &36:EQUB &63:EQUB &00 ; 216
EQUB &7F:EQUB &63:EQUB &63:EQUB &36:EQUB &36:EQUB &1C:EQUB &1C:EQUB &00 ; 217
EQUB &18:EQUB &18:EQUB &7E:EQUB &18:EQUB &18:EQUB &00:EQUB &7E:EQUB &00 ; 218
EQUB &00:EQUB &7E:EQUB &00:EQUB &18:EQUB &18:EQUB &7E:EQUB &18:EQUB &18 ; 219
EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &00 ; 220
EQUB &36:EQUB &36:EQUB &36:EQUB &36:EQUB &36:EQUB &36:EQUB &36:EQUB &00 ; 221
EQUB &00:EQUB &66:EQUB &66:EQUB &66:EQUB &66:EQUB &66:EQUB &3C:EQUB &00 ; 222
EQUB &00:EQUB &3C:EQUB &66:EQUB &66:EQUB &66:EQUB &66:EQUB &66:EQUB &00 ; 223
EQUB &00:EQUB &03:EQUB &3E:EQUB &67:EQUB &6B:EQUB &73:EQUB &3E:EQUB &60 ; 224
EQUB &00:EQUB &00:EQUB &3B:EQUB &6E:EQUB &66:EQUB &6E:EQUB &3B:EQUB &00 ; 225
EQUB &1E:EQUB &33:EQUB &33:EQUB &3E:EQUB &33:EQUB &33:EQUB &3E:EQUB &60 ; 226
EQUB &00:EQUB &00:EQUB &66:EQUB &36:EQUB &1C:EQUB &18:EQUB &30:EQUB &30 ; 227
EQUB &3C:EQUB &60:EQUB &30:EQUB &3C:EQUB &66:EQUB &66:EQUB &3C:EQUB &00 ; 228
EQUB &00:EQUB &00:EQUB &1E:EQUB &30:EQUB &1C:EQUB &30:EQUB &1E:EQUB &00 ; 229
EQUB &3E:EQUB &0C:EQUB &18:EQUB &30:EQUB &60:EQUB &60:EQUB &3E:EQUB &06 ; 230
EQUB &00:EQUB &00:EQUB &7C:EQUB &66:EQUB &66:EQUB &66:EQUB &06:EQUB &06 ; 231
EQUB &3C:EQUB &66:EQUB &66:EQUB &7E:EQUB &66:EQUB &66:EQUB &3C:EQUB &00 ; 232
EQUB &00:EQUB &00:EQUB &18:EQUB &18:EQUB &18:EQUB &18:EQUB &0C:EQUB &00 ; 233
EQUB &00:EQUB &00:EQUB &66:EQUB &6C:EQUB &78:EQUB &6C:EQUB &66:EQUB &00 ; 234
EQUB &60:EQUB &30:EQUB &18:EQUB &1C:EQUB &36:EQUB &63:EQUB &63:EQUB &00 ; 235
EQUB &00:EQUB &00:EQUB &33:EQUB &33:EQUB &33:EQUB &33:EQUB &3E:EQUB &60 ; 236
EQUB &00:EQUB &00:EQUB &63:EQUB &33:EQUB &1B:EQUB &1E:EQUB &1C:EQUB &00 ; 237
EQUB &3C:EQUB &60:EQUB &60:EQUB &3C:EQUB &60:EQUB &60:EQUB &3E:EQUB &06 ; 238
EQUB &00:EQUB &00:EQUB &3E:EQUB &63:EQUB &63:EQUB &63:EQUB &3E:EQUB &00 ; 239
EQUB &00:EQUB &00:EQUB &7F:EQUB &36:EQUB &36:EQUB &36:EQUB &36:EQUB &00 ; 240
EQUB &00:EQUB &00:EQUB &3C:EQUB &66:EQUB &66:EQUB &7C:EQUB &60:EQUB &60 ; 241
EQUB &00:EQUB &00:EQUB &3F:EQUB &66:EQUB &66:EQUB &66:EQUB &3C:EQUB &00 ; 242
EQUB &00:EQUB &00:EQUB &7E:EQUB &18:EQUB &18:EQUB &18:EQUB &0C:EQUB &00 ; 243
EQUB &00:EQUB &00:EQUB &73:EQUB &33:EQUB &33:EQUB &33:EQUB &1E:EQUB &00 ; 244
EQUB &00:EQUB &00:EQUB &3E:EQUB &6B:EQUB &6B:EQUB &3E:EQUB &18:EQUB &18 ; 245
EQUB &00:EQUB &00:EQUB &66:EQUB &36:EQUB &1C:EQUB &1C:EQUB &36:EQUB &33 ; 246
EQUB &00:EQUB &00:EQUB &63:EQUB &6B:EQUB &6B:EQUB &3E:EQUB &18:EQUB &18 ; 247
EQUB &00:EQUB &00:EQUB &36:EQUB &63:EQUB &6B:EQUB &7F:EQUB &36:EQUB &00 ; 248
EQUB &38:EQUB &0C:EQUB &06:EQUB &3E:EQUB &66:EQUB &66:EQUB &3C:EQUB &00 ; 249
EQUB &00:EQUB &31:EQUB &6B:EQUB &46:EQUB &00:EQUB &7F:EQUB &00:EQUB &00 ; 250
EQUB &00:EQUB &7E:EQUB &00:EQUB &7E:EQUB &00:EQUB &7E:EQUB &00:EQUB &00 ; 251
EQUB &07:EQUB &1C:EQUB &70:EQUB &1C:EQUB &07:EQUB &00:EQUB &7F:EQUB &00 ; 252
EQUB &06:EQUB &0C:EQUB &7E:EQUB &18:EQUB &7E:EQUB &30:EQUB &60:EQUB &00 ; 253
EQUB &70:EQUB &1C:EQUB &07:EQUB &1C:EQUB &70:EQUB &00:EQUB &7F:EQUB &00 ; 254
EQUB &FF:EQUB &FF:EQUB &FF:EQUB &FF:EQUB &FF:EQUB &FF:EQUB &FF:EQUB &FF ; 255

\ VDU driver entry block
\ ======================
.LC000:LDA (&D6),Y:RTS  :\ Read from VDU memory
.LC003:STA (&D6),Y:RTS  :\ Write to VDU memory
.LC006:JMP LDB51        :\
.LC009:JMP LDAE8        :\
.LC00C:JMP LD1DE        :\
.LC00F:JMP LD1A8        :\
.LC012:JMP LDEC8        :\
.LC015:JMP LC4DF        :\
.LC018                  :\ Fetch byte from ROM Y
LDX &F4                 :\ Get current ROM
STY &F4:STY ROMSEL       :\ Select ROM in Y
LDA (&F6)               :\ Get byte with ROM Y paged in
JMP LE581               :\ Page in ROM X and return
 
.LC024
JMP (&035D)      :\ C024= 6C 5D 03    l].

; VDU DRIVER ENTRY POINT
; ======================
.LC027
LDX &026A        :\ C027= AE 6A 02    .j.
BEQ LC059        :\ C02A= F0 2D       p-
STA &0224,X      :\ C02C= 9D 24 02    .$.
INC &026A        :\ C02F= EE 6A 02    nj.
BEQ LC036        :\ C032= F0 02       p.
.LC034
CLC              :\ C034= 18          .
.LC035
RTS              :\ C035= 60          `
 
.LC036
BIT &D0          :\ C036= 24 D0       $P
BPL LC053        :\ C038= 10 19       ..
LDY &035E        :\ C03A= AC 5E 03    ,^.
CPY #&C0         :\ C03D= C0 C0       @@
.LC03F
BNE LC034        :\ C03F= D0 F3       Ps
LDY &035D        :\ C041= AC 5D 03    ,].
CPY #&E2         :\ C044= C0 E2       @b
BNE LC034        :\ C046= D0 EC       Pl
.LC048
TAX              :\ C048= AA          *
LDA &D0          :\ C049= A5 D0       %P
LSR A            :\ C04B= 4A          J
BCC LC035        :\ C04C= 90 E7       .g
TXA              :\ C04E= 8A          .
.LC04F
CLC              :\ C04F= 18          .
JMP LE8B9        :\ C050= 4C B9 E8    L9h
 
.LC053
JSR LC0FA        :\ C053= 20 FA C0     z@
CLC              :\ C056= 18          .
BRA LC0C0        :\ C057= 80 67       .g
 
.LC059
JSR LC0FA        :\ C059= 20 FA C0     z@
BVC LC06D        :\ C05C= 50 0F       P.
BMI LC06D        :\ C05E= 30 0D       0.
CMP #&0D         :\ C060= C9 0D       I.
BNE LC06D        :\ C062= D0 09       P.
PHA              :\ C064= 48          H
LDA #&42         :\ C065= A9 42       )B
TRB &D0          :\ C067= 14 D0       .P
JSR LCF50        :\ C069= 20 50 CF     PO
PLA              :\ C06C= 68          h
.LC06D
CMP #&20         :\ C06D= C9 20       I 
BCC LC077        :\ C06F= 90 06       ..
CMP #&7F         :\ C071= C9 7F       I.
BNE LC096        :\ C073= D0 21       P!
LDA #&20         :\ C075= A9 20       ) 
.LC077
TAY              :\ C077= A8          (
LDA LE027,Y      :\ C078= B9 27 E0    9'`
STA &035D        :\ C07B= 8D 5D 03    .].
LDA LE048,Y      :\ C07E= B9 48 E0    9H`
BMI LC0B3        :\ C081= 30 30       00
TAX              :\ C083= AA          *
ORA #&F0         :\ C084= 09 F0       .p
STA &026A        :\ C086= 8D 6A 02    .j.
TXA              :\ C089= 8A          .
LSR A            :\ C08A= 4A          J
LSR A            :\ C08B= 4A          J
LSR A            :\ C08C= 4A          J
LSR A            :\ C08D= 4A          J
CLC              :\ C08E= 18          .
ADC #&C0         :\ C08F= 69 C0       i@
STA &035E        :\ C091= 8D 5E 03    .^.
BRA LC0CA        :\ C094= 80 34       .4
 
.LC096
BIT &D0          :\ C096= 24 D0       $P
BMI LC0C7        :\ C098= 30 2D       0-
JSR LCE0C        :\ C09A= 20 0C CE     .N
LDA #&20         :\ C09D= A9 20       ) 
BIT &0366        :\ C09F= 2C 66 03    ,f.
BNE LC0C7        :\ C0A2= D0 23       P#
JSR LC276        :\ C0A4= 20 76 C2     vB
BRA LC0C7        :\ C0A7= 80 1E       ..
 
.LC0A9
EOR #&06         :\ C0A9= 49 06       I.
BNE LC0C5        :\ C0AB= D0 18       P.
LDA #&80         :\ C0AD= A9 80       ).
TRB &D0          :\ C0AF= 14 D0       .P
BRA LC0CA        :\ C0B1= 80 17       ..
 
.LC0B3
STA &035E        :\ C0B3= 8D 5E 03    .^.
TYA              :\ C0B6= 98          .
EOR #&F7         :\ C0B7= 49 F7       Iw
CMP #&FA         :\ C0B9= C9 FA       Iz
TYA              :\ C0BB= 98          .
BIT &D0          :\ C0BC= 24 D0       $P
BMI LC0A9        :\ C0BE= 30 E9       0i
.LC0C0
PHP              :\ C0C0= 08          .
JSR LC024        :\ C0C1= 20 24 C0     $@
PLP              :\ C0C4= 28          (
.LC0C5
BCC LC0CA        :\ C0C5= 90 03       ..
.LC0C7
LDA &D0          :\ C0C7= A5 D0       %P
LSR A            :\ C0C9= 4A          J
.LC0CA
BIT &D0          :\ C0CA= 24 D0       $P
BVC LC0E1        :\ C0CC= 50 13       P.
JSR LC105        :\ C0CE= 20 05 C1     .A
.LC0D1
PHP              :\ C0D1= 08          .
PHA              :\ C0D2= 48          H
LDA &D0          :\ C0D3= A5 D0       %P
EOR #&02         :\ C0D5= 49 02       I.
STA &D0          :\ C0D7= 85 D0       .P
JSR LE2AE        :\ C0D9= 20 AE E2     .b
JSR LC6D8        :\ C0DC= 20 D8 C6     XF
PLA              :\ C0DF= 68          h
.LC0E0
PLP              :\ C0E0= 28          (
.LC0E1
RTS              :\ C0E1= 60          `
 
JSR LC0CA        :\ C0E2= 20 CA C0     J@
JSR LC048        :\ C0E5= 20 48 C0     H@
BRA LC0FA        :\ C0E8= 80 10       ..
 
PHA              :\ C0EA= 48          H
JSR LC0CA        :\ C0EB= 20 CA C0     J@
JSR LE93A        :\ C0EE= 20 3A E9     :i
LDA #&01         :\ C0F1= A9 01       ).
TSB &D0          :\ C0F3= 04 D0       .P
PLA              :\ C0F5= 68          h
AND #&01         :\ C0F6= 29 01       ).
TRB &D0          :\ C0F8= 14 D0       .P
.LC0FA
BIT &D0          :\ C0FA= 24 D0       $P
BVC LC0E1        :\ C0FC= 50 E3       Pc
JSR LC0D1        :\ C0FE= 20 D1 C0     Q@
PHP              :\ C101= 08          .
SEC              :\ C102= 38          8
BRA LC107        :\ C103= 80 02       ..
 
.LC105
PHP              :\ C105= 08          .
CLC              :\ C106= 18          .
.LC107
PHA              :\ C107= 48          H
LDA &D8          :\ C108= A5 D8       %X
STA &E0          :\ C10A= 85 E0       .`
LDA &D9          :\ C10C= A5 D9       %Y
STA &E1          :\ C10E= 85 E1       .a
LDY &034F        :\ C110= AC 4F 03    ,O.
DEY              :\ C113= 88          .
BNE LC124        :\ C114= D0 0E       P.
LDA &0338        :\ C116= AD 38 03    -8.
BCS LC132        :\ C119= B0 17       0.
LDA (&D8)        :\ C11B= B2 D8       2X
STA &0338        :\ C11D= 8D 38 03    .8.
LDA #&7F         :\ C120= A9 7F       ).
BRA LC132        :\ C122= 80 0E       ..
 
.LC124
LDA #&FF         :\ C124= A9 FF       ).
CPY #&1F         :\ C126= C0 1F       @.
BNE LC12C        :\ C128= D0 02       P.
LDA #&3F         :\ C12A= A9 3F       )?
.LC12C
STA &DA          :\ C12C= 85 DA       .Z
.LC12E
LDA (&E0)        :\ C12E= B2 E0       2`
EOR &DA          :\ C130= 45 DA       EZ
.LC132
STA (&E0)        :\ C132= 92 E0       .`
INC &E0          :\ C134= E6 E0       f`
BNE LC141        :\ C136= D0 09       P.
INC &E1          :\ C138= E6 E1       fa
BPL LC141        :\ C13A= 10 05       ..
.LC13C
LDA &034E        :\ C13C= AD 4E 03    -N.
STA &E1          :\ C13F= 85 E1       .a
.LC141
DEY              :\ C141= 88          .
BPL LC12E        :\ C142= 10 EA       .j
PLA              :\ C144= 68          h
PLP              :\ C145= 28          (
RTS              :\ C146= 60          `
 
.LC147
EQUW LC1BE       :\ C147= BE C1       ..
EQUW LC1B1       :\ C149= B1 C1       ..
EQUW LC1BE       :\ C14B= BE C1       ..
EQUW LC1B1       :\ C14D= B1 C1       ..
EQUW LC195       :\ C14F= 95 C1       ..
EQUW LC195       :\ C151= 95 C1       ..
EQUW LC1A2       :\ C153= A2 C1       ..
EQUW LC1A2       :\ C155= A2 C1       ..
.LC157
EQUW LC201       :\ C157= 01 C2       ..
EQUW LC1EE       :\ C159= EE C1       ..
EQUW LC201       :\ C15B= 01 C2       ..
EQUW LC1EE       :\ C15D= EE C1       ..
EQUW LC221       :\ C15F= 21 C2       !.
EQUW LC221       :\ C161= 21 C2       !.
EQUW LC210       :\ C163= 10 C2       ..
EQUW LC210       :\ C165= 10 C2       ..
.LC167
EQUW LC2D3       :\ C167= D3 C2       ..
EQUW LC2CB       :\ C169= CB C2       ..
EQUW LC2D3       :\ C16B= D3 C2       ..
EQUW LC2CB       :\ C16D= CB C2       ..
EQUW LC2E2       :\ C16F= E2 C2       ..
EQUW LC2E2       :\ C171= E2 C2       ..
EQUW LC2DA       :\ C173= DA C2       ..
EQUW LC2DA       :\ C175= DA C2       ..
.LC177
EQUW LC310       :\ C177= 10 C3       ..
EQUW LC2F2       :\ C179= F2 C2       ..
EQUW LC310       :\ C17B= 10 C3       ..
EQUW LC2F2       :\ C17D= F2 C2       ..
EQUW LC35A       :\ C17F= 5A C3       Z.
EQUW LC35A       :\ C181= 5A C3       Z.
EQUW LC338       :\ C183= 38 C3       8.
EQUW LC338       :\ C185= 38 C3       8.
.LC187
EOR &0366        :\ C187= 4D 66 03    Mf.
AND #&0E         :\ C18A= 29 0E       ).
PHA              :\ C18C= 48          H
JSR LD1A6        :\ C18D= 20 A6 D1     &Q
PLX              :\ C190= FA          z
SEC              :\ C191= 38          8
JMP (LC147,X)    :\ C192= 7C 47 C1    |GA

.LC195
LDA &0326        :\ C195= AD 26 03    -&.
SBC #&08         :\ C198= E9 08       i.
STA &0326        :\ C19A= 8D 26 03    .&.
DEC &0327        :\ C19D= CE 27 03    N'.
BRA LC1AA        :\ C1A0= 80 08       ..

.LC1A2
LDA &0326        :\ C1A2= AD 26 03    -&.
ADC #&07         :\ C1A5= 69 07       i.
STA &0326        :\ C1A7= 8D 26 03    .&.
.LC1AA
BCC LC1CB        :\ C1AA= 90 1F       ..
INC &0327        :\ C1AC= EE 27 03    n'.
BRA LC1CB        :\ C1AF= 80 1A       ..

.LC1B1
LDA &0324        :\ C1B1= AD 24 03    -$.
SBC #&08         :\ C1B4= E9 08       i.
STA &0324        :\ C1B6= 8D 24 03    .$.
DEC &0325        :\ C1B9= CE 25 03    N%.
BRA LC1C6        :\ C1BC= 80 08       ..

.LC1BE
LDA &0324        :\ C1BE= AD 24 03    -$.
ADC #&07         :\ C1C1= 69 07       i.
STA &0324        :\ C1C3= 8D 24 03    .$.
.LC1C6
BCC LC1CB        :\ C1C6= 90 03       ..
INC &0325        :\ C1C8= EE 25 03    n%.
.LC1CB
LDA &DA          :\ C1CB= A5 DA       %Z
BNE LC1DB        :\ C1CD= D0 0C       P.
BIT &0366        :\ C1CF= 2C 66 03    ,f.
BVS LC1DB        :\ C1D2= 70 07       p.
PHX              :\ C1D4= DA          Z
JSR LD1A6        :\ C1D5= 20 A6 D1     &Q
PLX              :\ C1D8= FA          z
TAY              :\ C1D9= A8          (
RTS              :\ C1DA= 60          `
 
.LC1DB
LDA #&00         :\ C1DB= A9 00       ).
RTS              :\ C1DD= 60          `
 
.LC1DE
LDA #&00         :\ C1DE= A9 00       ).
.LC1E0
STZ &DA          :\ C1E0= 64 DA       dZ
ASL A            :\ C1E2= 0A          .
ROL &DA          :\ C1E3= 26 DA       &Z
ASL A            :\ C1E5= 0A          .
ROL &DA          :\ C1E6= 26 DA       &Z
ASL A            :\ C1E8= 0A          .
ROL &DA          :\ C1E9= 26 DA       &Z
JMP (LC157,X)    :\ C1EB= 7C 57 C1    |WA

.LC1EE
EOR #&F9         :\ C1EE= 49 F9       Iy
ADC &0304        :\ C1F0= 6D 04 03    m..
STA &0324        :\ C1F3= 8D 24 03    .$.
LDA &DA          :\ C1F6= A5 DA       %Z
EOR #&FF         :\ C1F8= 49 FF       I.
ADC &0305        :\ C1FA= 6D 05 03    m..
STA &0325        :\ C1FD= 8D 25 03    .%.
RTS              :\ C200= 60          `

.LC201
ADC &0300        :\ C201= 6D 00 03    m..
STA &0324        :\ C204= 8D 24 03    .$.
LDA &DA          :\ C207= A5 DA       %Z
ADC &0301        :\ C209= 6D 01 03    m..
STA &0325        :\ C20C= 8D 25 03    .%.
RTS              :\ C20F= 60          `

.LC210
EOR #&07         :\ C210= 49 07       I.
ADC &0302        :\ C212= 6D 02 03    m..
STA &0326        :\ C215= 8D 26 03    .&.
LDA &DA          :\ C218= A5 DA       %Z
ADC &0303        :\ C21A= 6D 03 03    m..
STA &0327        :\ C21D= 8D 27 03    .'.
RTS              :\ C220= 60          `

.LC221
SEC              :\ C221= 38          8
EOR #&FF         :\ C222= 49 FF       I.
ADC &0306        :\ C224= 6D 06 03    m..
STA &0326        :\ C227= 8D 26 03    .&.
LDA &DA          :\ C22A= A5 DA       %Z
EOR #&FF         :\ C22C= 49 FF       I.
ADC &0307        :\ C22E= 6D 07 03    m..
STA &0327        :\ C231= 8D 27 03    .'.
RTS              :\ C234= 60          `
 
.LC235
LDA #&00         :\ C235= A9 00       ).
JSR LC187        :\ C237= 20 87 C1     .A
BEQ LC249        :\ C23A= F0 0D       p.
JSR LC1DE        :\ C23C= 20 DE C1     ^A
.LC23F
LDA #&08         :\ C23F= A9 08       ).
.LC241
JSR LC187        :\ C241= 20 87 C1     .A
BEQ LC249        :\ C244= F0 03       p.
JSR LC1DE        :\ C246= 20 DE C1     ^A
.LC249
JMP LC4DF        :\ C249= 4C DF C4    L_D
 
JSR LD12D        :\ C24C= 20 2D D1     -Q
BCS LC235        :\ C24F= B0 E4       0d
LDA #&00         :\ C251= A9 00       ).
JSR LC2E9        :\ C253= 20 E9 C2     iB
BCC LC273        :\ C256= 90 1B       ..
.LC258
JSR LC38F        :\ C258= 20 8F C3     .C
.LC25B
JSR LE2D2        :\ C25B= 20 D2 E2     Rb
BNE LC23F        :\ C25E= D0 DF       P_
CLC              :\ C260= 18          .
JSR LC88E        :\ C261= 20 8E C8     .H
LDA #&08         :\ C264= A9 08       ).
JSR LC2E9        :\ C266= 20 E9 C2     iB
.LC269
BCC LC273        :\ C269= 90 08       ..
JSR LC37B        :\ C26B= 20 7B C3     {C
BCC LC273        :\ C26E= 90 03       ..
JMP LD051        :\ C270= 4C 51 D0    LQP
 
.LC273
JMP LC6ED        :\ C273= 4C ED C6    LmF
 
.LC276
JSR LE2D2        :\ C276= 20 D2 E2     Rb
BNE LC235        :\ C279= D0 BA       P:
JSR LC2E9        :\ C27B= 20 E9 C2     iB
BCC LC273        :\ C27E= 90 F3       .s
LDA #&01         :\ C280= A9 01       ).
BIT &0366        :\ C282= 2C 66 03    ,f.
BEQ LC258        :\ C285= F0 D1       pQ
SEC              :\ C287= 38          8
ROR &036C        :\ C288= 6E 6C 03    nl.
.LC28B
RTS              :\ C28B= 60          `
 
.LC28C
LDA #&06         :\ C28C= A9 06       ).
JSR LC187        :\ C28E= 20 87 C1     .A
BEQ LC249        :\ C291= F0 B6       p6
JSR LC1DE        :\ C293= 20 DE C1     ^A
.LC296
LDA #&0E         :\ C296= A9 0E       ).
BRA LC241        :\ C298= 80 A7       .'
 
.LC29A
JSR LE2D2        :\ C29A= 20 D2 E2     Rb
BNE LC28C        :\ C29D= D0 ED       Pm
LSR &036C        :\ C29F= 4E 6C 03    Nl.
BIT &036C        :\ C2A2= 2C 6C 03    ,l.
BVS LC28B        :\ C2A5= 70 E4       pd
LDA #&06         :\ C2A7= A9 06       ).
JSR LC2E9        :\ C2A9= 20 E9 C2     iB
BCC LC273        :\ C2AC= 90 C5       .E
JSR LC38F        :\ C2AE= 20 8F C3     .C
JSR LE2D2        :\ C2B1= 20 D2 E2     Rb
BNE LC296        :\ C2B4= D0 E0       P`
DEC &0269        :\ C2B6= CE 69 02    Ni.
BPL LC2BE        :\ C2B9= 10 03       ..
INC &0269        :\ C2BB= EE 69 02    ni.
.LC2BE
LDA #&0E         :\ C2BE= A9 0E       ).
JSR LC2E9        :\ C2C0= 20 E9 C2     iB
BRA LC269        :\ C2C3= 80 A4       .$
 
.LC2C5
LDA #&00         :\ C2C5= A9 00       ).
.LC2C7
CLC              :\ C2C7= 18          .
JMP (LC167,X)    :\ C2C8= 7C 67 C1    |gA

.LC2CB
SEC              :\ C2CB= 38          8
EOR #&FF         :\ C2CC= 49 FF       I.
ADC &030A        :\ C2CE= 6D 0A 03    m..
BRA LC2D6        :\ C2D1= 80 03       ..

.LC2D3
ADC &0308        :\ C2D3= 6D 08 03    m..
.LC2D6
STA &0318        :\ C2D6= 8D 18 03    ...
RTS              :\ C2D9= 60          `

.LC2DA
SEC              :\ C2DA= 38          8
EOR #&FF         :\ C2DB= 49 FF       I.
ADC &0309        :\ C2DD= 6D 09 03    m..
BRA LC2E5        :\ C2E0= 80 03       ..

.LC2E2
ADC &030B        :\ C2E2= 6D 0B 03    m..
.LC2E5
STA &0319        :\ C2E5= 8D 19 03    ...
RTS              :\ C2E8= 60          `
 
.LC2E9
EOR &0366        :\ C2E9= 4D 66 03    Mf.
AND #&0E         :\ C2EC= 29 0E       ).
TAX              :\ C2EE= AA          *
.LC2EF
JMP (LC177,X)    :\ C2EF= 7C 77 C1    |wA

.LC2F2
LDA &0308        :\ C2F2= AD 08 03    -..
CMP &0318        :\ C2F5= CD 18 03    M..
BCS LC337        :\ C2F8= B0 3D       0=
DEC &0318        :\ C2FA= CE 18 03    N..
SEC              :\ C2FD= 38          8
LDA &034A        :\ C2FE= AD 4A 03    -J.
SBC &034F        :\ C301= ED 4F 03    mO.
STA &034A        :\ C304= 8D 4A 03    .J.
STA &D8          :\ C307= 85 D8       .X
BCS LC336        :\ C309= B0 2B       0+
DEC &034B        :\ C30B= CE 4B 03    NK.
BRA LC32B        :\ C30E= 80 1B       ..

.LC310
LDA &0318        :\ C310= AD 18 03    -..
CMP &030A        :\ C313= CD 0A 03    M..
BCS LC337        :\ C316= B0 1F       0.
INC &0318        :\ C318= EE 18 03    n..
LDA &034A        :\ C31B= AD 4A 03    -J.
ADC &034F        :\ C31E= 6D 4F 03    mO.
STA &034A        :\ C321= 8D 4A 03    .J.
STA &D8          :\ C324= 85 D8       .X
BCC LC337        :\ C326= 90 0F       ..
INC &034B        :\ C328= EE 4B 03    nK.
.LC32B
LDA &034B        :\ C32B= AD 4B 03    -K.
.LC32E
BPL LC334        :\ C32E= 10 04       ..
SEC              :\ C330= 38          8
SBC &0354        :\ C331= ED 54 03    mT.
.LC334
STA &D9          :\ C334= 85 D9       .Y
.LC336
CLC              :\ C336= 18          .
.LC337
RTS              :\ C337= 60          `

.LC338
LDA &030B        :\ C338= AD 0B 03    -..
CMP &0319        :\ C33B= CD 19 03    M..
BCS LC337        :\ C33E= B0 F7       0w
DEC &0319        :\ C340= CE 19 03    N..
SEC              :\ C343= 38          8
LDA &034A        :\ C344= AD 4A 03    -J.
SBC &0352        :\ C347= ED 52 03    mR.
STA &034A        :\ C34A= 8D 4A 03    .J.
STA &D8          :\ C34D= 85 D8       .X
LDA &034B        :\ C34F= AD 4B 03    -K.
SBC &0353        :\ C352= ED 53 03    mS.
STA &034B        :\ C355= 8D 4B 03    .K.
BRA LC32E        :\ C358= 80 D4       .T

.LC35A
LDA &0319        :\ C35A= AD 19 03    -..
CMP &0309        :\ C35D= CD 09 03    M..
BCS LC337        :\ C360= B0 D5       0U
INC &0319        :\ C362= EE 19 03    n..
LDA &034A        :\ C365= AD 4A 03    -J.
ADC &0352        :\ C368= 6D 52 03    mR.
STA &034A        :\ C36B= 8D 4A 03    .J.
STA &D8          :\ C36E= 85 D8       .X
LDA &034B        :\ C370= AD 4B 03    -K.
ADC &0353        :\ C373= 6D 53 03    mS.
STA &034B        :\ C376= 8D 4B 03    .K.
BRA LC32E        :\ C379= 80 B3       .3
 
.LC37B
LDA #&10         :\ C37B= A9 10       ).
BIT &0366        :\ C37D= 2C 66 03    ,f.
BNE LC38F        :\ C380= D0 0D       P.
TXA              :\ C382= 8A          .
EOR #&06         :\ C383= 49 06       I.
PHA              :\ C385= 48          H
LDA #&42         :\ C386= A9 42       )B
BIT &D0          :\ C388= 24 D0       $P
BEQ LC3A2        :\ C38A= F0 16       p.
BVS LC397        :\ C38C= 70 09       p.
PLA              :\ C38E= 68          h
.LC38F
JSR LC2C5        :\ C38F= 20 C5 C2     EB
JSR LCCFA        :\ C392= 20 FA CC     zL
CLC              :\ C395= 18          .
RTS              :\ C396= 60          `
 
.LC397
JSR LE2AE        :\ C397= 20 AE E2     .b
PLX              :\ C39A= FA          z
PHX              :\ C39B= DA          Z
JSR LC2EF        :\ C39C= 20 EF C2     oB
JSR LE2AE        :\ C39F= 20 AE E2     .b
.LC3A2
PLX              :\ C3A2= FA          z
SEC              :\ C3A3= 38          8
.LC3A4
RTS              :\ C3A4= 60          `
 
LDX &0355        :\ C3A5= AE 55 03    .U.
LDA &0321        :\ C3A8= AD 21 03    -!.
CMP &0323        :\ C3AB= CD 23 03    M#.
BCC LC3A4        :\ C3AE= 90 F4       .t
CMP LE101,X      :\ C3B0= DD 01 E1    ].a
BEQ LC3B7        :\ C3B3= F0 02       p.
BCS LC3A4        :\ C3B5= B0 ED       0m
.LC3B7
LDA &0322        :\ C3B7= AD 22 03    -".
CMP LE109,X      :\ C3BA= DD 09 E1    ].a
BEQ LC3C2        :\ C3BD= F0 03       p.
BCS LC3A4        :\ C3BF= B0 E3       0c
SEC              :\ C3C1= 38          8
.LC3C2
SBC &0320        :\ C3C2= ED 20 03    m .
BCC LC3A4        :\ C3C5= 90 DD       .]
JSR LC780        :\ C3C7= 20 80 C7     .G
LDA #&08         :\ C3CA= A9 08       ).
TSB &D0          :\ C3CC= 04 D0       .P
LDX #&20         :\ C3CE= A2 20       " 
LDY #&08         :\ C3D0= A0 08        .
JSR LC91E        :\ C3D2= 20 1E C9     .I
JSR LE2AE        :\ C3D5= 20 AE E2     .b
JSR LCCDA        :\ C3D8= 20 DA CC     ZL
BCC LC3E0        :\ C3DB= 90 03       ..
JSR LC3E8        :\ C3DD= 20 E8 C3     hC
.LC3E0
JSR LE2AE        :\ C3E0= 20 AE E2     .b
JSR LCCDA        :\ C3E3= 20 DA CC     ZL
BCC LC407        :\ C3E6= 90 1F       ..
.LC3E8
LDA &D0          :\ C3E8= A5 D0       %P
PHA              :\ C3EA= 48          H
AND #&DF         :\ C3EB= 29 DF       )_
STA &D0          :\ C3ED= 85 D0       .P
JSR LC47C        :\ C3EF= 20 7C C4     |D
PLA              :\ C3F2= 68          h
STA &D0          :\ C3F3= 85 D0       .P
RTS              :\ C3F5= 60          `
 
.LC3F6
LDA &0366        :\ C3F6= AD 66 03    -f.
AND #&0E         :\ C3F9= 29 0E       ).
TAX              :\ C3FB= AA          *
JSR LE2D2        :\ C3FC= 20 D2 E2     Rb
BNE LC40A        :\ C3FF= D0 09       P.
LSR &036C        :\ C401= 4E 6C 03    Nl.
JSR LC38F        :\ C404= 20 8F C3     .C
.LC407
JMP LC6ED        :\ C407= 4C ED C6    LmF
 
.LC40A
JSR LC1DE        :\ C40A= 20 DE C1     ^A
JMP LC4DF        :\ C40D= 4C DF C4    L_D
 
.LC410
JSR LC47C        :\ C410= 20 7C C4     |D
LDA &0361        :\ C413= AD 61 03    -a.
BEQ LC3A4        :\ C416= F0 8C       p.
LDX #&00         :\ C418= A2 00       ".
JSR LC902        :\ C41A= 20 02 C9     .I
JSR LC951        :\ C41D= 20 51 C9     QI
.LC420
LDX #&2A         :\ C420= A2 2A       "*
LDY #&2E         :\ C422= A0 2E        .
JSR LE2B2        :\ C424= 20 B2 E2     2b
.LC427
LDX #&28         :\ C427= A2 28       "(
LDY #&2C         :\ C429= A0 2C        ,
JSR LDAE8        :\ C42B= 20 E8 DA     hZ
LDA &032A        :\ C42E= AD 2A 03    -*.
BNE LC436        :\ C431= D0 03       P.
DEC &032B        :\ C433= CE 2B 03    N+.
.LC436
DEC &032A        :\ C436= CE 2A 03    N*.
LDA &032A        :\ C439= AD 2A 03    -*.
CMP &032E        :\ C43C= CD 2E 03    M..
LDA &032B        :\ C43F= AD 2B 03    -+.
SBC &032F        :\ C442= ED 2F 03    m/.
BPL LC427        :\ C445= 10 E0       .`
RTS              :\ C447= 60          `
 
LDX #&20         :\ C448= A2 20       " 
JSR LC8E6        :\ C44A= 20 E6 C8     fH
BRA LC420        :\ C44D= 80 D1       .Q

; VDU 12 - CLS
; ============
.LC44F
LDA #&20:BIT &D0
BNE LC410        :\ VDU 5 mode
LDA #&08:BIT &D0
BNE LC45E        :\ Software CLS (window defined)
JMP LC866        :\ Do a hardware CLS

; Clear screen within text window
; -------------------------------
.LC45E
JSR LC908        :\ C45E= 20 08 C9     .I
LDX &0308        :\ C461= AE 08 03    ...
STX &0318        :\ C464= 8E 18 03    ...
LDX &030B        :\ C467= AE 0B 03    ...
.LC46A
STX &0319        :\ C46A= 8E 19 03    ...
JSR LCCFA        :\ C46D= 20 FA CC     zL
JSR LCAE8        :\ C470= 20 E8 CA     hJ
LDX &0319        :\ C473= AE 19 03    ...
CPX &0309        :\ C476= EC 09 03    l..
INX              :\ C479= E8          h
BCC LC46A        :\ C47A= 90 EE       .n
.LC47C
STZ &0323        :\ C47C= 9C 23 03    .#.
STZ &0322        :\ C47F= 9C 22 03    .".
LDA &0366        :\ C482= AD 66 03    -f.
AND #&0E         :\ C485= 29 0E       ).
TAX              :\ C487= AA          *
.LC488
JSR LE2D2        :\ C488= 20 D2 E2     Rb
BNE LC4CF        :\ C48B= D0 42       PB
LDA &0318        :\ C48D= AD 18 03    -..
PHA              :\ C490= 48          H
LDA &0319        :\ C491= AD 19 03    -..
PHA              :\ C494= 48          H
LDA &0322        :\ C495= AD 22 03    -".
JSR LC2C7        :\ C498= 20 C7 C2     GB
PHX              :\ C49B= DA          Z
TXA              :\ C49C= 8A          .
EOR #&08         :\ C49D= 49 08       I.
TAX              :\ C49F= AA          *
LDA &0323        :\ C4A0= AD 23 03    -#.
JSR LCCD7        :\ C4A3= 20 D7 CC     WL
PLX              :\ C4A6= FA          z
BCC LC4BA        :\ C4A7= 90 11       ..
LDA #&01         :\ C4A9= A9 01       ).
BIT &0366        :\ C4AB= 2C 66 03    ,f.
BEQ LC4C1        :\ C4AE= F0 11       p.
LDA &0322        :\ C4B0= AD 22 03    -".
DEC A            :\ C4B3= 3A          :
JSR LCCD7        :\ C4B4= 20 D7 CC     WL
BCS LC4C1        :\ C4B7= B0 08       0.
SEC              :\ C4B9= 38          8
.LC4BA
ROR &036C        :\ C4BA= 6E 6C 03    nl.
PLA              :\ C4BD= 68          h
PLA              :\ C4BE= 68          h
BRA LC4CC        :\ C4BF= 80 0B       ..
 
.LC4C1
PLA              :\ C4C1= 68          h
STA &0319        :\ C4C2= 8D 19 03    ...
PLA              :\ C4C5= 68          h
STA &0318        :\ C4C6= 8D 18 03    ...
JSR LCCFA        :\ C4C9= 20 FA CC     zL
.LC4CC
JMP LC6ED        :\ C4CC= 4C ED C6    LmF
 
.LC4CF
LDA &0322        :\ C4CF= AD 22 03    -".
JSR LC1E0        :\ C4D2= 20 E0 C1     `A
TXA              :\ C4D5= 8A          .
EOR #&08         :\ C4D6= 49 08       I.
TAX              :\ C4D8= AA          *
LDA &0323        :\ C4D9= AD 23 03    -#.
JSR LC1E0        :\ C4DC= 20 E0 C1     `A
.LC4DF
LDY #&10         :\ C4DF= A0 10        .
JSR LC91C        :\ C4E1= 20 1C C9     .I
LDX #&02         :\ C4E4= A2 02       ".
LDY #&02         :\ C4E6= A0 02        .
JSR LC4FC        :\ C4E8= 20 FC C4     |D
LDX #&00         :\ C4EB= A2 00       ".
LDY #&04         :\ C4ED= A0 04        .
LDA &0361        :\ C4EF= AD 61 03    -a.
.LC4F2
DEY              :\ C4F2= 88          .
LSR A            :\ C4F3= 4A          J
BNE LC4F2        :\ C4F4= D0 FC       P|
LDA &0356        :\ C4F6= AD 56 03    -V.
BEQ LC4FC        :\ C4F9= F0 01       p.
INY              :\ C4FB= C8          H
.LC4FC
ASL &0310,X      :\ C4FC= 1E 10 03    ...
ROL &0311,X      :\ C4FF= 3E 11 03    >..
DEY              :\ C502= 88          .
BNE LC4FC        :\ C503= D0 F7       Pw
SEC              :\ C505= 38          8
JSR LC50A        :\ C506= 20 0A C5     .E
INX              :\ C509= E8          h
.LC50A
LDA &0310,X      :\ C50A= BD 10 03    =..
SBC &030C,X      :\ C50D= FD 0C 03    }..
STA &0310,X      :\ C510= 9D 10 03    ...
RTS              :\ C513= 60          `
 
STZ &0269        :\ C514= 9C 69 02    .i.
LDA #&91         :\ C517= A9 91       ).
EOR #&95         :\ C519= 49 95       I.
.LC51B
TSB &D0          :\ C51B= 04 D0       .P
RTS              :\ C51D= 60          `
 
LDA &0361        :\ C51E= AD 61 03    -a.
BEQ LC52C        :\ C521= F0 09       p.
JSR LCF50        :\ C523= 20 50 CF     PO
LDA #&2B         :\ C526= A9 2B       )+
EOR #&0B         :\ C528= 49 0B       I.
TRB &D0          :\ C52A= 14 D0       .P
.LC52C
RTS              :\ C52C= 60          `
 
LDA &0361        :\ C52D= AD 61 03    -a.
BEQ LC52C        :\ C530= F0 FA       pz
LDA #&20         :\ C532= A9 20       ) 
JSR LCF53        :\ C534= 20 53 CF     SO
BRA LC51B        :\ C537= 80 E2       .b
 
LDY #&00         :\ C539= A0 00        .
LDA &0323        :\ C53B= AD 23 03    -#.
BPL LC541        :\ C53E= 10 01       ..
INY              :\ C540= C8          H
.LC541
AND &0360        :\ C541= 2D 60 03    -`.
STA &DA          :\ C544= 85 DA       .Z
LDA &0360        :\ C546= AD 60 03    -`.
BEQ LC563        :\ C549= F0 18       p.
AND #&07         :\ C54B= 29 07       ).
CLC              :\ C54D= 18          .
ADC &DA          :\ C54E= 65 DA       eZ
TAX              :\ C550= AA          *
LDA LE14B,X      :\ C551= BD 4B E1    =Ka
STA &0357,Y      :\ C554= 99 57 03    .W.
LDA &0357        :\ C557= AD 57 03    -W.
EOR #&FF         :\ C55A= 49 FF       I.
STA &D3          :\ C55C= 85 D3       .S
EOR &0358        :\ C55E= 4D 58 03    MX.
STA &D2          :\ C561= 85 D2       .R
.LC563
RTS              :\ C563= 60          `
 
LDY #&00         :\ C564= A0 00        .
LDA &0323        :\ C566= AD 23 03    -#.
BPL LC56C        :\ C569= 10 01       ..
.LC56B
INY              :\ C56B= C8          H
.LC56C
AND &0360        :\ C56C= 2D 60 03    -`.
STA &036D,Y      :\ C56F= 99 6D 03    .m.
LDA &0322        :\ C572= AD 22 03    -".
STA &035B,Y      :\ C575= 99 5B 03    .[.
AND #&F0         :\ C578= 29 F0       )p
STA &036A,Y      :\ C57A= 99 6A 03    .j.
.LC57D
LDA &035B        :\ C57D= AD 5B 03    -[.
LDX &036D        :\ C580= AE 6D 03    .m.
LDY #&00         :\ C583= A0 00        .
JSR LC590        :\ C585= 20 90 C5     .E
LDA &035C        :\ C588= AD 5C 03    -\.
LDX &036E        :\ C58B= AE 6E 03    .n.
LDY #&08         :\ C58E= A0 08        .
.LC590
AND #&F0         :\ C590= 29 F0       )p
BNE LC5AC        :\ C592= D0 18       P.
STX &DA          :\ C594= 86 DA       .Z
LDA &0360        :\ C596= AD 60 03    -`.
AND #&07         :\ C599= 29 07       ).
CLC              :\ C59B= 18          .
ADC &DA          :\ C59C= 65 DA       eZ
TAX              :\ C59E= AA          *
LDA LE14B,X      :\ C59F= BD 4B E1    =Ka
LDX #&07         :\ C5A2= A2 07       ".
.LC5A4
STA L8820,Y      :\ C5A4= 99 20 88    . .
INY              :\ C5A7= C8          H
DEX              :\ C5A8= CA          J
BPL LC5A4        :\ C5A9= 10 F9       .y
RTS              :\ C5AB= 60          `
 
.LC5AC
LSR A            :\ C5AC= 4A          J
TAX              :\ C5AD= AA          *
LDA #&07         :\ C5AE= A9 07       ).
STA &DA          :\ C5B0= 85 DA       .Z
.LC5B2
LDA L87F8,X      :\ C5B2= BD F8 87    =x.
STA L8820,Y      :\ C5B5= 99 20 88    . .
INX              :\ C5B8= E8          h
INY              :\ C5B9= C8          H
DEC &DA          :\ C5BA= C6 DA       FZ
BPL LC5B2        :\ C5BC= 10 F4       .t
RTS              :\ C5BE= 60          `
 
.LC5BF
LDA #&20         :\ C5BF= A9 20       ) 
STA &0358        :\ C5C1= 8D 58 03    .X.
RTS              :\ C5C4= 60          `
 
.LC5C5
LDX #&05         :\ C5C5= A2 05       ".
.LC5C7
STZ &0357,X      :\ C5C7= 9E 57 03    .W.
DEX              :\ C5CA= CA          J
BPL LC5C7        :\ C5CB= 10 FA       .z
STZ &036E        :\ C5CD= 9C 6E 03    .n.
STZ &036B        :\ C5D0= 9C 6B 03    .k.
LDA #&FF         :\ C5D3= A9 FF       ).
LDX &0360        :\ C5D5= AE 60 03    .`.
BEQ LC5BF        :\ C5D8= F0 E5       pe
CPX #&0F         :\ C5DA= E0 0F       `.
BNE LC5E0        :\ C5DC= D0 02       P.
LDA #&3F         :\ C5DE= A9 3F       )?
.LC5E0
STA &0357        :\ C5E0= 8D 57 03    .W.
EOR #&FF         :\ C5E3= 49 FF       I.
STA &D2          :\ C5E5= 85 D2       .R
STA &D3          :\ C5E7= 85 D3       .S
TXA              :\ C5E9= 8A          .
AND #&07         :\ C5EA= 29 07       ).
STA &036D        :\ C5EC= 8D 6D 03    .m.
STZ &036A        :\ C5EF= 9C 6A 03    .j.
PHX              :\ C5F2= DA          Z
JSR LC57D        :\ C5F3= 20 7D C5     }E
PLX              :\ C5F6= FA          z
STX &031F        :\ C5F7= 8E 1F 03    ...
CPX #&03         :\ C5FA= E0 03       `.
BEQ LC60F        :\ C5FC= F0 11       p.
BCC LC620        :\ C5FE= 90 20       . 
STX &0320        :\ C600= 8E 20 03    . .
.LC603
JSR LC62D        :\ C603= 20 2D C6     -F
DEC &0320        :\ C606= CE 20 03    N .
DEC &031F        :\ C609= CE 1F 03    N..
BPL LC603        :\ C60C= 10 F5       .u
RTS              :\ C60E= 60          `
 
.LC60F
LDX #&07         :\ C60F= A2 07       ".
STX &0320        :\ C611= 8E 20 03    . .
.LC614
JSR LC62D        :\ C614= 20 2D C6     -F
LSR &0320        :\ C617= 4E 20 03    N .
DEC &031F        :\ C61A= CE 1F 03    N..
BPL LC614        :\ C61D= 10 F5       .u
RTS              :\ C61F= 60          `
 
.LC620
LDX #&07         :\ C620= A2 07       ".
JSR LC62A        :\ C622= 20 2A C6     *F
LDX #&00         :\ C625= A2 00       ".
STZ &031F        :\ C627= 9C 1F 03    ...
.LC62A
STX &0320        :\ C62A= 8E 20 03    . .
.LC62D
PHP              :\ C62D= 08          .
SEI              :\ C62E= 78          x
LDA &031F        :\ C62F= AD 1F 03    -..
AND &0360        :\ C632= 2D 60 03    -`.
TAX              :\ C635= AA          *
LDA &0320        :\ C636= AD 20 03    - .
.LC639
AND #&0F         :\ C639= 29 0F       ).
STA &036F,X      :\ C63B= 9D 6F 03    .o.
TAY              :\ C63E= A8          (
LDA &0360        :\ C63F= AD 60 03    -`.
STA &FA          :\ C642= 85 FA       .z
CMP #&03         :\ C644= C9 03       I.
PHP              :\ C646= 08          .
TXA              :\ C647= 8A          .
.LC648
LSR A            :\ C648= 4A          J
ROR &FA          :\ C649= 66 FA       fz
BCS LC648        :\ C64B= B0 FB       0{
ASL &FA          :\ C64D= 06 FA       .z
TYA              :\ C64F= 98          .
ORA &FA          :\ C650= 05 FA       .z
TAX              :\ C652= AA          *
LDY #&F0         :\ C653= A0 F0        p
.LC655
PLP              :\ C655= 28          (
PHP              :\ C656= 08          .
BNE LC65C        :\ C657= D0 03       P.
JSR LC66F        :\ C659= 20 6F C6     oF
.LC65C
JSR LF261        :\ C65C= 20 61 F2     ar
CLC              :\ C65F= 18          .
TYA              :\ C660= 98          .
ADC &0360        :\ C661= 6D 60 03    m`.
TAY              :\ C664= A8          (
TXA              :\ C665= 8A          .
ADC #&10         :\ C666= 69 10       i.
TAX              :\ C668= AA          *
INY              :\ C669= C8          H
BNE LC655        :\ C66A= D0 E9       Pi
PLP              :\ C66C= 28          (
PLP              :\ C66D= 28          (
RTS              :\ C66E= 60          `
 
.LC66F
ROL A            :\ C66F= 2A          *
STA &DA          :\ C670= 85 DA       .Z
ROL A            :\ C672= 2A          *
ROL A            :\ C673= 2A          *
PHP              :\ C674= 08          .
ROL &DA          :\ C675= 26 DA       &Z
ROR A            :\ C677= 6A          j
PLP              :\ C678= 28          (
ROR A            :\ C679= 6A          j
ROR A            :\ C67A= 6A          j
RTS              :\ C67B= 60          `
 
LDA &031B        :\ C67C= AD 1B 03    -..
CMP #&20         :\ C67F= C9 20       I 
BCC LC691        :\ C681= 90 0E       ..
JSR LE22C        :\ C683= 20 2C E2     ,b
LDY #&07         :\ C686= A0 07        .
.LC688
LDA &031C,Y      :\ C688= B9 1C 03    9..
STA (&DE),Y      :\ C68B= 91 DE       .^
DEY              :\ C68D= 88          .
BPL LC688        :\ C68E= 10 F8       .x
RTS              :\ C690= 60          `
 
.LC691
ASL A            :\ C691= 0A          .
TAX              :\ C692= AA          *
LSR A            :\ C693= 4A          J
CMP #&11         :\ C694= C9 11       I.
BCS LC6A7        :\ C696= B0 0F       0.
JMP (LE069,X)    :\ C698= 7C 69 E0    |i`
 
LDX &0361        :\ C69B= AE 61 03    .a.
BEQ LC6A3        :\ C69E= F0 03       p.
JMP LD146        :\ C6A0= 4C 46 D1    LFQ
 
.LC6A3
LDA &031F        :\ C6A3= AD 1F 03    -..
CLC              :\ C6A6= 18          .
.LC6A7
JMP (&0226)      :\ C6A7= 6C 26 02    l&.
 
.LC6AA
LDX #&2C         :\ C6AA= A2 2C       ",
.LC6AC
STZ &0300,X      :\ C6AC= 9E 00 03    ...
DEX              :\ C6AF= CA          J
BPL LC6AC        :\ C6B0= 10 FA       .z
JSR LE2A2        :\ C6B2= 20 A2 E2     "b
STX &030A        :\ C6B5= 8E 0A 03    ...
STY &0309        :\ C6B8= 8C 09 03    ...
TXA              :\ C6BB= 8A          .
JSR LC780        :\ C6BC= 20 80 C7     .G
LDY #&03         :\ C6BF= A0 03        .
STY &0323        :\ C6C1= 8C 23 03    .#.
INY              :\ C6C4= C8          H
STY &0321        :\ C6C5= 8C 21 03    .!.
DEC &0322        :\ C6C8= CE 22 03    N".
DEC &0320        :\ C6CB= CE 20 03    N .
JSR LC71F        :\ C6CE= 20 1F C7     .G
LDA #&08         :\ C6D1= A9 08       ).
TRB &D0          :\ C6D3= 14 D0       .P
JMP LC47C        :\ C6D5= 4C 7C C4    L|D
 
.LC6D8
JSR LCCFA        :\ C6D8= 20 FA CC     zL
BRA LC6ED        :\ C6DB= 80 10       ..
 
.LC6DD
STX &034A        :\ C6DD= 8E 4A 03    .J.
STA &034B        :\ C6E0= 8D 4B 03    .K.
BPL LC6E9        :\ C6E3= 10 04       ..
SEC              :\ C6E5= 38          8
SBC &0354        :\ C6E6= ED 54 03    mT.
.LC6E9
STX &D8          :\ C6E9= 86 D8       .X
STA &D9          :\ C6EB= 85 D9       .Y
.LC6ED
LDX &034A        :\ C6ED= AE 4A 03    .J.
LDA &034B        :\ C6F0= AD 4B 03    -K.
LDY #&0E         :\ C6F3= A0 0E        .
.LC6F5
PHA              :\ C6F5= 48          H
LDA &0355        :\ C6F6= AD 55 03    -U.
CMP #&07         :\ C6F9= C9 07       I.
PLA              :\ C6FB= 68          h
BCS LC70D        :\ C6FC= B0 0F       0.
STX &DA          :\ C6FE= 86 DA       .Z
LSR A            :\ C700= 4A          J
ROR &DA          :\ C701= 66 DA       fZ
LSR A            :\ C703= 4A          J
ROR &DA          :\ C704= 66 DA       fZ
LSR A            :\ C706= 4A          J
ROR &DA          :\ C707= 66 DA       fZ
LDX &DA          :\ C709= A6 DA       &Z
BRA LC711        :\ C70B= 80 04       ..
 
.LC70D
SBC #&74         :\ C70D= E9 74       it
EOR #&20         :\ C70F= 49 20       I 
.LC711
STY CRTC+0        :\ C711= 8C 00 FE    ..~
STA CRTC+1        :\ C714= 8D 01 FE    ..~
INY              :\ C717= C8          H
STY CRTC+0        :\ C718= 8C 00 FE    ..~
STX CRTC+1        :\ C71B= 8E 01 FE    ..~
RTS              :\ C71E= 60          `
 
.LC71F
JSR LC779        :\ C71F= 20 79 C7     yG
LDX #&02         :\ C722= A2 02       ".
.LC724
SEC              :\ C724= 38          8
LDA &0320,X      :\ C725= BD 20 03    = .
SBC &031C,X      :\ C728= FD 1C 03    }..
STA &032C,X      :\ C72B= 9D 2C 03    .,.
LDA &0321,X      :\ C72E= BD 21 03    =!.
SBC &031D,X      :\ C731= FD 1D 03    }..
STA &032D,X      :\ C734= 9D 2D 03    .-.
DEX              :\ C737= CA          J
DEX              :\ C738= CA          J
BPL LC724        :\ C739= 10 E9       .i
ORA &032F        :\ C73B= 0D 2F 03    ./.
BMI LC779        :\ C73E= 30 39       09
LDX #&20         :\ C740= A2 20       " 
JSR LD1DE        :\ C742= 20 DE D1     ^Q
LDX #&1C         :\ C745= A2 1C       ".
JSR LD1DE        :\ C747= 20 DE D1     ^Q
LDA &031F        :\ C74A= AD 1F 03    -..
ORA &031D        :\ C74D= 0D 1D 03    ...
BMI LC779        :\ C750= 30 27       0'
LDA &0323        :\ C752= AD 23 03    -#.
BNE LC779        :\ C755= D0 22       P"
LDX &0355        :\ C757= AE 55 03    .U.
LDA &0321        :\ C75A= AD 21 03    -!.
STA &DA          :\ C75D= 85 DA       .Z
LDA &0320        :\ C75F= AD 20 03    - .
LSR &DA          :\ C762= 46 DA       FZ
ROR A            :\ C764= 6A          j
LSR &DA          :\ C765= 46 DA       FZ
BNE LC779        :\ C767= D0 10       P.
ROR A            :\ C769= 6A          j
LSR A            :\ C76A= 4A          J
CMP LE109,X      :\ C76B= DD 09 E1    ].a
BEQ LC772        :\ C76E= F0 02       p.
BPL LC779        :\ C770= 10 07       ..
.LC772
LDY #&00         :\ C772= A0 00        .
LDX #&1C         :\ C774= A2 1C       ".
JSR LC904        :\ C776= 20 04 C9     .I
.LC779
LDX #&10         :\ C779= A2 10       ".
LDY #&28         :\ C77B= A0 28        (
JMP LE2BA        :\ C77D= 4C BA E2    L:b
 
.LC780
JSR LC93B        :\ C780= 20 3B C9     ;I
STA &034C        :\ C783= 8D 4C 03    .L.
STX &034D        :\ C786= 8E 4D 03    .M.
RTS              :\ C789= 60          `
 
LDX #&20         :\ C78A= A2 20       " 
LDY #&0C         :\ C78C= A0 0C        .
JSR LC91E        :\ C78E= 20 1E C9     .I
JMP LC4DF        :\ C791= 4C DF C4    L_D
 
LDA &0323        :\ C794= AD 23 03    -#.
BRA LC7BC        :\ C797= 80 23       .#
 
.LC799
STA &DA          :\ C799= 85 DA       .Z
LDA &F4          :\ C79B= A5 F4       %t
PHA              :\ C79D= 48          H
ORA #&80         :\ C79E= 09 80       ..
JSR LE592        :\ C7A0= 20 92 E5     .e
JSR LC7AA        :\ C7A3= 20 AA C7     *G
PLA              :\ C7A6= 68          h
JMP LE592        :\ C7A7= 4C 92 E5    L.e
 
.LC7AA
LDX #&7F         :\ C7AA= A2 7F       ".
STZ &D0          :\ C7AC= 64 D0       dP
LDA &0366        :\ C7AE= AD 66 03    -f.
.LC7B1
STZ &02FF,X      :\ C7B1= 9E FF 02    ...
DEX              :\ C7B4= CA          J
BNE LC7B1        :\ C7B5= D0 FA       Pz
STA &0366        :\ C7B7= 8D 66 03    .f.
LDA &DA          :\ C7BA= A5 DA       %Z

; VDU 22 - MODE 
; -------------
.LC7BC
STZ &028A        :\ C7BC= 9C 8A 02    ...
STZ &028B        :\ C7BF= 9C 8B 02    ...
TAY              :\ C7C2= A8          (
BMI LC7D5        :\ C7C3= 30 10       0.
LDX &027F        :\ C7C5= AE 7F 02    ...
BEQ LC7D5        :\ C7C8= F0 0B       p.
LDA #&10         :\ C7CA= A9 10       ).
TRB &D0          :\ C7CC= 14 D0       .P
LDA #&03         :\ C7CE= A9 03       ).
TRB LFE34        :\ C7D0= 1C 34 FE    .4~
BRA LC7DE        :\ C7D3= 80 09       ..
 
.LC7D5
LDA #&10         :\ C7D5= A9 10       ).
TSB &D0          :\ C7D7= 04 D0       .P
LDA #&03         :\ C7D9= A9 03       ).
TSB LFE34        :\ C7DB= 0C 34 FE    .4~
.LC7DE
TYA              :\ C7DE= 98          .
AND #&07         :\ C7DF= 29 07       ).
TAX              :\ C7E1= AA          *
STX &0355        :\ C7E2= 8E 55 03    .U.
LDA LE13C,X      :\ C7E5= BD 3C E1    =<a
STA &0360        :\ C7E8= 8D 60 03    .`.
LDA LE119,X      :\ C7EB= BD 19 E1    =.a
STA &034F        :\ C7EE= 8D 4F 03    .O.
LDA LE162,X      :\ C7F1= BD 62 E1    =ba
STA &0361        :\ C7F4= 8D 61 03    .a.
BNE LC7FB        :\ C7F7= D0 02       P.
LDA #&07         :\ C7F9= A9 07       ).
.LC7FB
ASL A            :\ C7FB= 0A          .
TAY              :\ C7FC= A8          (
LDA LE12E,Y      :\ C7FD= B9 2E E1    9.a
STA &0363        :\ C800= 8D 63 03    .c.
.LC803
ASL A            :\ C803= 0A          .
BPL LC803        :\ C804= 10 FD       .}
STA &0362        :\ C806= 8D 62 03    .b.
LDY LE168,X      :\ C809= BC 68 E1    <ha
STY &0356        :\ C80C= 8C 56 03    .V.
LDA LE174,Y      :\ C80F= B9 74 E1    9ta
PHP              :\ C812= 08          .
SEI              :\ C813= 78          x
STA SYSTEM_VIA+&0        :\ C814= 8D 40 FE    .@~
LDA LE170,Y      :\ C817= B9 70 E1    9pa
STA SYSTEM_VIA+&0        :\ C81A= 8D 40 FE    .@~
PLP              :\ C81D= 28          (
LDA LE179,Y      :\ C81E= B9 79 E1    9ya
STA &0354        :\ C821= 8D 54 03    .T.
LDA LE17E,Y      :\ C824= B9 7E E1    9~a
STA &034E        :\ C827= 8D 4E 03    .N.
LDA #&EE         :\ C82A= A9 EE       )n
TRB &D0          :\ C82C= 14 D0       .P
LDX &0355        :\ C82E= AE 55 03    .U.
LDA LE111,X      :\ C831= BD 11 E1    =.a
JSR LF250        :\ C834= 20 50 F2     Pr
PHP              :\ C837= 08          .
SEI              :\ C838= 78          x
LDX LE183,Y      :\ C839= BE 83 E1    >.a
LDY #&0B         :\ C83C= A0 0B        .
.LC83E
LDA LE188,X      :\ C83E= BD 88 E1    =.a
JSR LCF01        :\ C841= 20 01 CF     .O
DEX              :\ C844= CA          J
DEY              :\ C845= 88          .
BPL LC83E        :\ C846= 10 F6       .v
PLP              :\ C848= 28          (
JSR LC5C5        :\ C849= 20 C5 C5     EE
JSR LCF6D        :\ C84C= 20 6D CF     mO
LDA #&AA         :\ C84F= A9 AA       )*
STA &0367        :\ C851= 8D 67 03    .g.
STA &0368        :\ C854= 8D 68 03    .h.
JSR LC6AA        :\ C857= 20 AA C6     *F
LDA &034C        :\ C85A= AD 4C 03    -L.
LDX &034D        :\ C85D= AE 4D 03    .M.
STA &0352        :\ C860= 8D 52 03    .R.
STX &0353        :\ C863= 8E 53 03    .S.

; Do a fast hardware CLS of the whole screen
; ------------------------------------------
.LC866
LDX #&00         :\ C866= A2 00       ".
LDA &034E        :\ C868= AD 4E 03    -N.
STZ &0350        :\ C86B= 9C 50 03    .P.
STA &0351        :\ C86E= 8D 51 03    .Q.
JSR LC6DD        :\ C871= 20 DD C6     ]F
LDY #&0C         :\ C874= A0 0C        .
JSR LC711        :\ C876= 20 11 C7     .G
STZ &0269        :\ C879= 9C 69 02    .i.
SEC              :\ C87C= 38          8
LDA #&80         :\ C87D= A9 80       ).
SBC &034E        :\ C87F= ED 4E 03    mN.
TAX              :\ C882= AA          *
LDY #&00         :\ C883= A0 00        .
JSR LCB84        :\ C885= 20 84 CB     .K
JMP LC47C        :\ C888= 4C 7C C4    L|D
 
.LC88B
JSR LC8CF        :\ Clear paged mode counter
.LC88E
JSR LF230        :\ Call KEYV to test Shift & Ctrl keys
BCC LC895        :\ Ctrl not pressed, exit loop
BMI LC88B        :\ Shift pressed, loop back
.LC895
LDA &D0          :\ C895= A5 D0       %P
EOR #&04         :\ C897= 49 04       I.
AND #&46         :\ C899= 29 46       )F
BNE LC8D6        :\ C89B= D0 39       P9
JSR LC8D7        :\ C89D= 20 D7 C8     WH
LDA &0318,Y      :\ C8A0= B9 18 03    9..
CMP &0308,X      :\ C8A3= DD 08 03    ]..
BNE LC8D3        :\ C8A6= D0 2B       P+
SEC              :\ C8A8= 38          8
INY              :\ C8A9= C8          H
DEY              :\ C8AA= 88          .
BNE LC8B5        :\ C8AB= D0 08       P.
LDA &030A        :\ C8AD= AD 0A 03    -..
SBC &0308        :\ C8B0= ED 08 03    m..
BRA LC8BB        :\ C8B3= 80 06       ..
 
.LC8B5
LDA &0309        :\ C8B5= AD 09 03    -..
SBC &030B        :\ C8B8= ED 0B 03    m..
.LC8BB
PHA              :\ C8BB= 48          H
LSR A            :\ C8BC= 4A          J
LSR A            :\ C8BD= 4A          J
STA &DA          :\ C8BE= 85 DA       .Z
SEC              :\ C8C0= 38          8
PLA              :\ C8C1= 68          h
SBC &DA          :\ C8C2= E5 DA       eZ
CMP &0269        :\ C8C4= CD 69 02    Mi.
BCS LC8D3        :\ C8C7= B0 0A       0.
.LC8C9
JSR LF230        :\ C8C9= 20 30 F2     0r
SEC              :\ C8CC= 38          8
BPL LC8C9        :\ C8CD= 10 FA       .z

.LC8CF
STZ &0269        :\ Clear paged mode counter
NOP              :\ C8D2= EA          j
.LC8D3
INC &0269        :\ C8D3= EE 69 02    ni.
.LC8D6
RTS              :\ C8D6= 60          `
 
.LC8D7
LDA &0366        :\ C8D7= AD 66 03    -f.
AND #&0E         :\ C8DA= 29 0E       ).
LSR A            :\ C8DC= 4A          J
TAX              :\ C8DD= AA          *
LDA LE204,X      :\ C8DE= BD 04 E2    =.b
TAX              :\ C8E1= AA          *
AND #&01         :\ C8E2= 29 01       ).
TAY              :\ C8E4= A8          (
RTS              :\ C8E5= 60          `
 
.LC8E6
LDY #&24         :\ C8E6= A0 24        $
JSR LD5B7        :\ C8E8= 20 B7 D5     7U
PHY              :\ C8EB= 5A          Z
PHX              :\ C8EC= DA          Z
JSR LD5CC        :\ C8ED= 20 CC D5     LU
PLA              :\ C8F0= 68          h
PHY              :\ C8F1= 5A          Z
LDY #&28         :\ C8F2= A0 28        (
JSR LC8F9        :\ C8F4= 20 F9 C8     yH
PLX              :\ C8F7= FA          z
PLA              :\ C8F8= 68          h
.LC8F9
PHA              :\ C8F9= 48          H
JSR LC90C        :\ C8FA= 20 0C C9     .I
PLX              :\ C8FD= FA          z
INX              :\ C8FE= E8          h
INX              :\ C8FF= E8          h
BRA LC90C        :\ C900= 80 0A       ..
 
.LC902
LDY #&28         :\ C902= A0 28        (
.LC904
LDA #&08         :\ C904= A9 08       ).
BRA LC920        :\ C906= 80 18       ..
 
.LC908
LDX #&4C         :\ C908= A2 4C       "L
LDY #&28         :\ C90A= A0 28        (
.LC90C
LDA #&02         :\ C90C= A9 02       ).
BRA LC920        :\ C90E= 80 10       ..
 
.LC910
LDX #&08         :\ C910= A2 08       ".
LDY #&2C         :\ C912= A0 2C        ,
BRA LC91E        :\ C914= 80 08       ..
 
.LC916
LDX #&20         :\ C916= A2 20       " 
BRA LC91E        :\ C918= 80 04       ..
 
.LC91A
LDY #&14         :\ C91A= A0 14        .
.LC91C
LDX #&24         :\ C91C= A2 24       "$
.LC91E
LDA #&04         :\ C91E= A9 04       ).
.LC920
PHA              :\ C920= 48          H
LDA &0300,X      :\ C921= BD 00 03    =..
STA &0300,Y      :\ C924= 99 00 03    ...
INX              :\ C927= E8          h
INY              :\ C928= C8          H
PLA              :\ C929= 68          h
DEC A            :\ C92A= 3A          :
BNE LC920        :\ C92B= D0 F3       Ps
RTS              :\ C92D= 60          `
 
.LC92E
PHA              :\ C92E= 48          H
TYA              :\ C92F= 98          .
EOR #&FF         :\ C930= 49 FF       I.
TAY              :\ C932= A8          (
PLA              :\ C933= 68          h
EOR #&FF         :\ C934= 49 FF       I.
INY              :\ C936= C8          H
BNE LC93A        :\ C937= D0 01       P.
INC A            :\ C939= 1A          .
.LC93A
RTS              :\ C93A= 60          `
 
.LC93B
INC A            :\ C93B= 1A          .
.LC93C
STA &DA          :\ C93C= 85 DA       .Z
STZ &DB          :\ C93E= 64 DB       d[
LDA &034F        :\ C940= AD 4F 03    -O.
.LC943
LSR A            :\ C943= 4A          J
BCS LC94C        :\ C944= B0 06       0.
ASL &DA          :\ C946= 06 DA       .Z
ROL &DB          :\ C948= 26 DB       &[
BRA LC943        :\ C94A= 80 F7       .w
 
.LC94C
LDA &DA          :\ C94C= A5 DA       %Z
LDX &DB          :\ C94E= A6 DB       &[
RTS              :\ C950= 60          `
 
.LC951
LDX #&08         :\ C951= A2 08       ".
STX &0359        :\ C953= 8E 59 03    .Y.
LDA &035C        :\ C956= AD 5C 03    -\.
AND #&0F         :\ C959= 29 0F       ).
STA &035A        :\ C95B= 8D 5A 03    .Z.
RTS              :\ C95E= 60          `
 
LDA #&00         :\ C95F= A9 00       ).
PHA              :\ C961= 48          H
PHA              :\ C962= 48          H
LDX &032A        :\ C963= AE 2A 03    .*.
JSR LCC7D        :\ C966= 20 7D CC     }L
BRA LC97F        :\ C969= 80 14       ..
 
SEC              :\ C96B= 38          8
LDA &034F        :\ C96C= AD 4F 03    -O.
SBC &032A        :\ C96F= ED 2A 03    m*.
PHA              :\ C972= 48          H
JSR LE2A2        :\ C973= 20 A2 E2     "b
PHX              :\ C976= DA          Z
LDA #&00         :\ C977= A9 00       ).
LDX &032A        :\ C979= AE 2A 03    .*.
JSR LCC5D        :\ C97C= 20 5D CC     ]L
.LC97F
STX &0350        :\ C97F= 8E 50 03    .P.
STA &0351        :\ C982= 8D 51 03    .Q.
PLX              :\ C985= FA          z
LDY #&00         :\ C986= A0 00        .
JSR LCCB0        :\ C988= 20 B0 CC     0L
PLX              :\ C98B= FA          z
LDA #&00         :\ C98C= A9 00       ).
JSR LCC5D        :\ C98E= 20 5D CC     ]L
STX &D8          :\ C991= 86 D8       .X
STA &D9          :\ C993= 85 D9       .Y
JSR LE2A2        :\ C995= 20 A2 E2     "b
JSR LCAAE        :\ C998= 20 AE CA     .J
BRA LC9B8        :\ C99B= 80 1B       ..
 
LDY #&00         :\ C99D= A0 00        .
JSR LCC77        :\ C99F= 20 77 CC     wL
BRA LC9AA        :\ C9A2= 80 06       ..
 
JSR LE2A2        :\ C9A4= 20 A2 E2     "b
JSR LCC57        :\ C9A7= 20 57 CC     WL
.LC9AA
STX &0350        :\ C9AA= 8E 50 03    .P.
STA &0351        :\ C9AD= 8D 51 03    .Q.
LDX #&00         :\ C9B0= A2 00       ".
JSR LCCB0        :\ C9B2= 20 B0 CC     0L
JSR LCAE8        :\ C9B5= 20 E8 CA     hJ
.LC9B8
LDY #&0C         :\ C9B8= A0 0C        .
LDA &0351        :\ C9BA= AD 51 03    -Q.
LDX &0350        :\ C9BD= AE 50 03    .P.
JMP LC6F5        :\ C9C0= 4C F5 C6    LuF
 
JSR LCCA0        :\ C9C3= 20 A0 CC      L
.LC9C6
STA &DD          :\ C9C6= 85 DD       .]
STX &DC          :\ C9C8= 86 DC       .\
JSR LCC2C        :\ C9CA= 20 2C CC     ,L
LDA &0329        :\ C9CD= AD 29 03    -).
LDX &0328        :\ C9D0= AE 28 03    .(.
JSR LCC5D        :\ C9D3= 20 5D CC     ]L
JSR LCC88        :\ C9D6= 20 88 CC     .L
STX &D8          :\ C9D9= 86 D8       .X
STA &D9          :\ C9DB= 85 D9       .Y
LDA #&00         :\ C9DD= A9 00       ).
LDX &032A        :\ C9DF= AE 2A 03    .*.
JSR LCC7D        :\ C9E2= 20 7D CC     }L
JSR LCC88        :\ C9E5= 20 88 CC     .L
STX &DA          :\ C9E8= 86 DA       .Z
STA &DB          :\ C9EA= 85 DB       .[
LDY &0328        :\ C9EC= AC 28 03    ,(.
LDX &0329        :\ C9EF= AE 29 03    .).
BVC LCA17        :\ C9F2= 50 23       P#
LDY &E0          :\ C9F4= A4 E0       $`
LDX &E1          :\ C9F6= A6 E1       &a
JSR LCBE7        :\ C9F8= 20 E7 CB     gK
LDY &E0          :\ C9FB= A4 E0       $`
BCC LCA08        :\ C9FD= 90 09       ..
LDX #&80         :\ C9FF= A2 80       ".
STX &DB          :\ CA01= 86 DB       .[
STZ &DA          :\ CA03= 64 DA       dZ
LDY &032A        :\ CA05= AC 2A 03    ,*.
.LCA08
LDX #&00         :\ CA08= A2 00       ".
JSR LCBF3        :\ CA0A= 20 F3 CB     sK
LDX #&80         :\ CA0D= A2 80       ".
STX &D9          :\ CA0F= 86 D9       .Y
STZ &D8          :\ CA11= 64 D8       dX
LDY &DE          :\ CA13= A4 DE       $^
LDX &DF          :\ CA15= A6 DF       &_
.LCA17
JSR LCBE7        :\ CA17= 20 E7 CB     gK
JSR LCC97        :\ CA1A= 20 97 CC     .L
JSR LCC94        :\ CA1D= 20 94 CC     .L
JSR LCC57        :\ CA20= 20 57 CC     WL
STX &D8          :\ CA23= 86 D8       .X
STA &D9          :\ CA25= 85 D9       .Y
DEC &032B        :\ CA27= CE 2B 03    N+.
BPL LC9C6        :\ CA2A= 10 9A       ..
RTS              :\ CA2C= 60          `
 
JSR LCCA0        :\ CA2D= 20 A0 CC      L
.LCA30
JSR LCC2C        :\ CA30= 20 2C CC     ,L
LDA #&00         :\ CA33= A9 00       ).
LDX &032A        :\ CA35= AE 2A 03    .*.
JSR LCC5D        :\ CA38= 20 5D CC     ]L
STX &DA          :\ CA3B= 86 DA       .Z
STA &DB          :\ CA3D= 85 DB       .[
JSR LCC57        :\ CA3F= 20 57 CC     WL
STX &DC          :\ CA42= 86 DC       .\
STA &DD          :\ CA44= 85 DD       .]
LDY &0328        :\ CA46= AC 28 03    ,(.
LDX &0329        :\ CA49= AE 29 03    .).
BVC LCA73        :\ CA4C= 50 25       P%
LDY &DE          :\ CA4E= A4 DE       $^
LDX &DF          :\ CA50= A6 DF       &_
JSR LCBA8        :\ CA52= 20 A8 CB     (K
LDY &DE          :\ CA55= A4 DE       $^
BCC LCA63        :\ CA57= 90 0A       ..
LDX &034E        :\ CA59= AE 4E 03    .N.
STX &DB          :\ CA5C= 86 DB       .[
STZ &DA          :\ CA5E= 64 DA       dZ
LDY &032A        :\ CA60= AC 2A 03    ,*.
.LCA63
LDX #&00         :\ CA63= A2 00       ".
JSR LCBB4        :\ CA65= 20 B4 CB     4K
LDX &034E        :\ CA68= AE 4E 03    .N.
STX &D9          :\ CA6B= 86 D9       .Y
STZ &D8          :\ CA6D= 64 D8       dX
LDY &E0          :\ CA6F= A4 E0       $`
LDX &E1          :\ CA71= A6 E1       &a
.LCA73
JSR LCBA8        :\ CA73= 20 A8 CB     (K
JSR LCC94        :\ CA76= 20 94 CC     .L
DEC &032B        :\ CA79= CE 2B 03    N+.
BPL LCA30        :\ CA7C= 10 B2       .2
.LCA7E
RTS              :\ CA7E= 60          `
 
.LCA7F
STX &DC          :\ CA7F= 86 DC       .\
TAX              :\ CA81= AA          *
SEC              :\ CA82= 38          8
SBC &DC          :\ CA83= E5 DC       e\
BEQ LCA7E        :\ CA85= F0 F7       pw
STA &DD          :\ CA87= 85 DD       .]
PHX              :\ CA89= DA          Z
JSR LC93C        :\ CA8A= 20 3C C9     <I
PLX              :\ CA8D= FA          z
LDA &0366        :\ CA8E= AD 66 03    -f.
BIT #&08         :\ CA91= 89 08       ..
BNE LCAA0        :\ CA93= D0 0B       P.
BIT #&02         :\ CA95= 89 02       ..
JSR LCCCA        :\ CA97= 20 CA CC     JL
LDY &DA          :\ CA9A= A4 DA       $Z
LDX &DB          :\ CA9C= A6 DB       &[
BRA LCACE        :\ CA9E= 80 2E       ..
 
.LCAA0
BIT #&04         :\ CAA0= 89 04       ..
JSR LCCCA        :\ CAA2= 20 CA CC     JL
LDA &034F        :\ CAA5= AD 4F 03    -O.
STA &032A        :\ CAA8= 8D 2A 03    .*.
LDY &DD          :\ CAAB= A4 DD       $]
DEY              :\ CAAD= 88          .
.LCAAE
TYA              :\ CAAE= 98          .
BEQ LCAC9        :\ CAAF= F0 18       p.
STY &DC          :\ CAB1= 84 DC       .\
.LCAB3
JSR LCC57        :\ CAB3= 20 57 CC     WL
STX &DA          :\ CAB6= 86 DA       .Z
STA &DB          :\ CAB8= 85 DB       .[
JSR LCAC9        :\ CABA= 20 C9 CA     IJ
LDX &DA          :\ CABD= A6 DA       &Z
STX &D8          :\ CABF= 86 D8       .X
LDA &DB          :\ CAC1= A5 DB       %[
STA &D9          :\ CAC3= 85 D9       .Y
DEC &DC          :\ CAC5= C6 DC       F\
BNE LCAB3        :\ CAC7= D0 EA       Pj
.LCAC9
LDX #&00         :\ CAC9= A2 00       ".
LDY &032A        :\ CACB= AC 2A 03    ,*.
.LCACE
LDA &0328        :\ CACE= AD 28 03    -(.
PHA              :\ CAD1= 48          H
LDA &0329        :\ CAD2= AD 29 03    -).
PHA              :\ CAD5= 48          H
STY &0328        :\ CAD6= 8C 28 03    .(.
STX &0329        :\ CAD9= 8E 29 03    .).
JSR LCAE8        :\ CADC= 20 E8 CA     hJ
PLA              :\ CADF= 68          h
STA &0329        :\ CAE0= 8D 29 03    .).
PLA              :\ CAE3= 68          h
STA &0328        :\ CAE4= 8D 28 03    .(.
RTS              :\ CAE7= 60          `
 
.LCAE8
LDX &D8          :\ CAE8= A6 D8       &X
LDA &D9          :\ CAEA= A5 D9       %Y
JSR LCC2C        :\ CAEC= 20 2C CC     ,L
BRA LCB6A        :\ CAEF= 80 79       .y
 
LDX #&77         :\ CAF1= A2 77       "w
LDA #&CC         :\ CAF3= A9 CC       )L
LDY &032D        :\ CAF5= AC 2D 03    ,-.
BRA LCB01        :\ CAF8= 80 07       ..
 
LDX #&57         :\ CAFA= A2 57       "W
LDA #&CC         :\ CAFC= A9 CC       )L
LDY &032F        :\ CAFE= AC 2F 03    ,/.
.LCB01
STX &035D        :\ CB01= 8E 5D 03    .].
STA &035E        :\ CB04= 8D 5E 03    .^.
SEC              :\ CB07= 38          8
LDA &032D        :\ CB08= AD 2D 03    --.
SBC &032F        :\ CB0B= ED 2F 03    m/.
STA &032B        :\ CB0E= 8D 2B 03    .+.
LDX &032C        :\ CB11= AE 2C 03    .,.
JSR LCCB0        :\ CB14= 20 B0 CC     0L
STA &DD          :\ CB17= 85 DD       .]
STX &DC          :\ CB19= 86 DC       .\
JSR LCC2C        :\ CB1B= 20 2C CC     ,L
LDA &032B        :\ CB1E= AD 2B 03    -+.
BEQ LCB6A        :\ CB21= F0 47       pG
.LCB23
PHP              :\ CB23= 08          .
JSR LC024        :\ CB24= 20 24 C0     $@
STX &DA          :\ CB27= 86 DA       .Z
STA &DB          :\ CB29= 85 DB       .[
STX &DC          :\ CB2B= 86 DC       .\
STA &DD          :\ CB2D= 85 DD       .]
PLP              :\ CB2F= 28          (
BVC LCB4F        :\ CB30= 50 1D       P.
CLV              :\ CB32= B8          8
.LCB33
LDX &DF          :\ CB33= A6 DF       &_
LDY &DE          :\ CB35= A4 DE       $^
JSR LCBB4        :\ CB37= 20 B4 CB     4K
LDA &034E        :\ CB3A= AD 4E 03    -N.
BVS LCB45        :\ CB3D= 70 06       p.
STA &D9          :\ CB3F= 85 D9       .Y
STZ &D8          :\ CB41= 64 D8       dX
BRA LCB49        :\ CB43= 80 04       ..
 
.LCB45
STA &DB          :\ CB45= 85 DB       .[
STZ &DA          :\ CB47= 64 DA       dZ
.LCB49
LDX &E1          :\ CB49= A6 E1       &a
LDY &E0          :\ CB4B= A4 E0       $`
BRA LCB5A        :\ CB4D= 80 0B       ..
 
.LCB4F
JSR LCC2C        :\ CB4F= 20 2C CC     ,L
BVS LCB33        :\ CB52= 70 DF       p_
LDX &0329        :\ CB54= AE 29 03    .).
LDY &0328        :\ CB57= AC 28 03    ,(.
.LCB5A
JSR LCBB4        :\ CB5A= 20 B4 CB     4K
LDX &DC          :\ CB5D= A6 DC       &\
STX &D8          :\ CB5F= 86 D8       .X
LDA &DD          :\ CB61= A5 DD       %]
STA &D9          :\ CB63= 85 D9       .Y
DEC &032B        :\ CB65= CE 2B 03    N+.
BNE LCB23        :\ CB68= D0 B9       P9
.LCB6A
LDX &0329        :\ CB6A= AE 29 03    .).
LDY &0328        :\ CB6D= AC 28 03    ,(.
BVC LCB84        :\ CB70= 50 12       P.
LDX &DF          :\ CB72= A6 DF       &_
LDY &DE          :\ CB74= A4 DE       $^
JSR LCB84        :\ CB76= 20 84 CB     .K
LDA &034E        :\ CB79= AD 4E 03    -N.
STA &D9          :\ CB7C= 85 D9       .Y
STZ &D8          :\ CB7E= 64 D8       dX
LDX &E1          :\ CB80= A6 E1       &a
LDY &E0          :\ CB82= A4 E0       $`
.LCB84
TYA              :\ CB84= 98          .
CLC              :\ CB85= 18          .
ADC &D8          :\ CB86= 65 D8       eX
STA &D8          :\ CB88= 85 D8       .X
BCS LCB8E        :\ CB8A= B0 02       0.
DEC &D9          :\ CB8C= C6 D9       FY
.LCB8E
TYA              :\ CB8E= 98          .
EOR #&FF         :\ CB8F= 49 FF       I.
TAY              :\ CB91= A8          (
LSR A            :\ CB92= 4A          J
LDA &0358        :\ CB93= AD 58 03    -X.
BCS LCB9F        :\ CB96= B0 07       0.
BRA LCB9C        :\ CB98= 80 02       ..
 
.LCB9A
STA (&D8),Y      :\ CB9A= 91 D8       .X
.LCB9C
INY              :\ CB9C= C8          H
STA (&D8),Y      :\ CB9D= 91 D8       .X
.LCB9F
INY              :\ CB9F= C8          H
BNE LCB9A        :\ CBA0= D0 F8       Px
INC &D9          :\ CBA2= E6 D9       fY
DEX              :\ CBA4= CA          J
BPL LCB9A        :\ CBA5= 10 F3       .s
RTS              :\ CBA7= 60          `
 
.LCBA8
SEC              :\ CBA8= 38          8
TYA              :\ CBA9= 98          .
SBC &032A        :\ CBAA= ED 2A 03    m*.
TAY              :\ CBAD= A8          (
BCS LCBB4        :\ CBAE= B0 04       0.
DEX              :\ CBB0= CA          J
BMI LCBE6        :\ CBB1= 30 33       03
SEC              :\ CBB3= 38          8
.LCBB4
PHP              :\ CBB4= 08          .
TYA              :\ CBB5= 98          .
CLC              :\ CBB6= 18          .
ADC &DA          :\ CBB7= 65 DA       eZ
STA &DA          :\ CBB9= 85 DA       .Z
BCS LCBBF        :\ CBBB= B0 02       0.
DEC &DB          :\ CBBD= C6 DB       F[
.LCBBF
TYA              :\ CBBF= 98          .
CLC              :\ CBC0= 18          .
ADC &D8          :\ CBC1= 65 D8       eX
STA &D8          :\ CBC3= 85 D8       .X
BCS LCBC9        :\ CBC5= B0 02       0.
DEC &D9          :\ CBC7= C6 D9       FY
.LCBC9
TYA              :\ CBC9= 98          .
EOR #&FF         :\ CBCA= 49 FF       I.
TAY              :\ CBCC= A8          (
LSR A            :\ CBCD= 4A          J
BCS LCBDB        :\ CBCE= B0 0B       0.
BRA LCBD6        :\ CBD0= 80 04       ..
 
.LCBD2
LDA (&DA),Y      :\ CBD2= B1 DA       1Z
STA (&D8),Y      :\ CBD4= 91 D8       .X
.LCBD6
INY              :\ CBD6= C8          H
LDA (&DA),Y      :\ CBD7= B1 DA       1Z
STA (&D8),Y      :\ CBD9= 91 D8       .X
.LCBDB
INY              :\ CBDB= C8          H
BNE LCBD2        :\ CBDC= D0 F4       Pt
INC &DB          :\ CBDE= E6 DB       f[
INC &D9          :\ CBE0= E6 D9       fY
DEX              :\ CBE2= CA          J
BPL LCBD2        :\ CBE3= 10 ED       .m
.LCBE5
PLP              :\ CBE5= 28          (
.LCBE6
RTS              :\ CBE6= 60          `
 
.LCBE7
SEC              :\ CBE7= 38          8
TYA              :\ CBE8= 98          .
SBC &032A        :\ CBE9= ED 2A 03    m*.
TAY              :\ CBEC= A8          (
BCS LCBF3        :\ CBED= B0 04       0.
DEX              :\ CBEF= CA          J
BMI LCBE6        :\ CBF0= 30 F4       0t
SEC              :\ CBF2= 38          8
.LCBF3
PHP              :\ CBF3= 08          .
TYA              :\ CBF4= 98          .
EOR #&FF         :\ CBF5= 49 FF       I.
PHA              :\ CBF7= 48          H
SEC              :\ CBF8= 38          8
ADC &DA          :\ CBF9= 65 DA       eZ
STA &DA          :\ CBFB= 85 DA       .Z
BCS LCC01        :\ CBFD= B0 02       0.
DEC &DB          :\ CBFF= C6 DB       F[
.LCC01
PLA              :\ CC01= 68          h
SEC              :\ CC02= 38          8
ADC &D8          :\ CC03= 65 D8       eX
STA &D8          :\ CC05= 85 D8       .X
BCS LCC0B        :\ CC07= B0 02       0.
DEC &D9          :\ CC09= C6 D9       FY
.LCC0B
TYA              :\ CC0B= 98          .
LSR A            :\ CC0C= 4A          J
BCS LCC23        :\ CC0D= B0 14       0.
BNE LCC1E        :\ CC0F= D0 0D       P.
.LCC11
DEX              :\ CC11= CA          J
BMI LCBE5        :\ CC12= 30 D1       0Q
DEC &DB          :\ CC14= C6 DB       F[
DEC &D9          :\ CC16= C6 D9       FY
BRA LCC1E        :\ CC18= 80 04       ..
 
.LCC1A
LDA (&DA),Y      :\ CC1A= B1 DA       1Z
STA (&D8),Y      :\ CC1C= 91 D8       .X
.LCC1E
DEY              :\ CC1E= 88          .
LDA (&DA),Y      :\ CC1F= B1 DA       1Z
STA (&D8),Y      :\ CC21= 91 D8       .X
.LCC23
DEY              :\ CC23= 88          .
BNE LCC1A        :\ CC24= D0 F4       Pt
LDA (&DA)        :\ CC26= B2 DA       2Z
STA (&D8)        :\ CC28= 92 D8       .X
BRA LCC11        :\ CC2A= 80 E5       .e
 
.LCC2C
PHA              :\ CC2C= 48          H
TXA              :\ CC2D= 8A          .
CLC              :\ CC2E= 18          .
ADC &0328        :\ CC2F= 6D 28 03    m(.
TAX              :\ CC32= AA          *
.LCC33
PLA              :\ CC33= 68          h
ADC &0329        :\ CC34= 6D 29 03    m).
BVC LCC56        :\ CC37= 50 1D       P.
STX &E0          :\ CC39= 86 E0       .`
AND #&7F         :\ CC3B= 29 7F       ).
STA &E1          :\ CC3D= 85 E1       .a
ORA &E0          :\ CC3F= 05 E0       .`
BEQ LCC55        :\ CC41= F0 12       p.
PHP              :\ CC43= 08          .
SEC              :\ CC44= 38          8
LDA &0328        :\ CC45= AD 28 03    -(.
SBC &E0          :\ CC48= E5 E0       e`
STA &DE          :\ CC4A= 85 DE       .^
LDA &0329        :\ CC4C= AD 29 03    -).
SBC &E1          :\ CC4F= E5 E1       ea
STA &DF          :\ CC51= 85 DF       ._
PLP              :\ CC53= 28          (
RTS              :\ CC54= 60          `
 
.LCC55
CLV              :\ CC55= B8          8
.LCC56
RTS              :\ CC56= 60          `
 
.LCC57
LDA &0353        :\ CC57= AD 53 03    -S.
LDX &0352        :\ CC5A= AE 52 03    .R.
.LCC5D
CLC              :\ CC5D= 18          .
.LCC5E
PHP              :\ CC5E= 08          .
PHA              :\ CC5F= 48          H
TXA              :\ CC60= 8A          .
ADC &D8          :\ CC61= 65 D8       eX
TAX              :\ CC63= AA          *
PLA              :\ CC64= 68          h
ADC &D9          :\ CC65= 65 D9       eY
BPL LCC6D        :\ CC67= 10 04       ..
SEC              :\ CC69= 38          8
SBC &0354        :\ CC6A= ED 54 03    mT.
.LCC6D
CMP &034E        :\ CC6D= CD 4E 03    MN.
BCS LCC75        :\ CC70= B0 03       0.
ADC &0354        :\ CC72= 6D 54 03    mT.
.LCC75
PLP              :\ CC75= 28          (
RTS              :\ CC76= 60          `
 
.LCC77
LDA &0353        :\ CC77= AD 53 03    -S.
LDX &0352        :\ CC7A= AE 52 03    .R.
.LCC7D
PHA              :\ CC7D= 48          H
TXA              :\ CC7E= 8A          .
EOR #&FF         :\ CC7F= 49 FF       I.
TAX              :\ CC81= AA          *
PLA              :\ CC82= 68          h
EOR #&FF         :\ CC83= 49 FF       I.
SEC              :\ CC85= 38          8
BRA LCC5E        :\ CC86= 80 D6       .V
 
.LCC88
CMP &034E        :\ CC88= CD 4E 03    MN.
BNE LCC93        :\ CC8B= D0 06       P.
CPX #&00         :\ CC8D= E0 00       `.
BNE LCC93        :\ CC8F= D0 02       P.
LDA #&80         :\ CC91= A9 80       ).
.LCC93
RTS              :\ CC93= 60          `
 
.LCC94
JSR LCAC9        :\ CC94= 20 C9 CA     IJ
.LCC97
LDX &DC          :\ CC97= A6 DC       &\
STX &D8          :\ CC99= 86 D8       .X
LDA &DD          :\ CC9B= A5 DD       %]
STA &D9          :\ CC9D= 85 D9       .Y
RTS              :\ CC9F= 60          `
 
.LCCA0
SEC              :\ CCA0= 38          8
LDA &032D        :\ CCA1= AD 2D 03    --.
SBC &032F        :\ CCA4= ED 2F 03    m/.
STA &032B        :\ CCA7= 8D 2B 03    .+.
LDX &032C        :\ CCAA= AE 2C 03    .,.
LDY &032F        :\ CCAD= AC 2F 03    ,/.
.LCCB0
LDA &0318        :\ CCB0= AD 18 03    -..
PHA              :\ CCB3= 48          H
LDA &0319        :\ CCB4= AD 19 03    -..
PHA              :\ CCB7= 48          H
STX &0318        :\ CCB8= 8E 18 03    ...
STY &0319        :\ CCBB= 8C 19 03    ...
JSR LCCFA        :\ CCBE= 20 FA CC     zL
PLY              :\ CCC1= 7A          z
STY &0319        :\ CCC2= 8C 19 03    ...
PLY              :\ CCC5= 7A          z
STY &0318        :\ CCC6= 8C 18 03    ...
RTS              :\ CCC9= 60          `
 
.LCCCA
BEQ LCCCF        :\ CCCA= F0 03       p.
DEX              :\ CCCC= CA          J
STX &DC          :\ CCCD= 86 DC       .\
.LCCCF
LDA &0366        :\ CCCF= AD 66 03    -f.
AND #&0E         :\ CCD2= 29 0E       ).
TAX              :\ CCD4= AA          *
LDA &DC          :\ CCD5= A5 DC       %\
.LCCD7
JSR LC2C7        :\ CCD7= 20 C7 C2     GB
.LCCDA
LDX &0318        :\ CCDA= AE 18 03    ...
CPX &0308        :\ CCDD= EC 08 03    l..
BMI LCCF8        :\ CCE0= 30 16       0.
CPX &030A        :\ CCE2= EC 0A 03    l..
BEQ LCCE9        :\ CCE5= F0 02       p.
BPL LCCF8        :\ CCE7= 10 0F       ..
.LCCE9
LDX &0319        :\ CCE9= AE 19 03    ...
CPX &030B        :\ CCEC= EC 0B 03    l..
BMI LCCF8        :\ CCEF= 30 07       0.
CPX &0309        :\ CCF1= EC 09 03    l..
BMI LCCFA        :\ CCF4= 30 04       0.
BEQ LCCFA        :\ CCF6= F0 02       p.
.LCCF8
SEC              :\ CCF8= 38          8
RTS              :\ CCF9= 60          `
 
\ Set up display address without using BBC lookup table at &E0/1
.LCCFA
LDA &0356        :\ Get memory map type 0-4
AND #&FE         :\ Reduce to 0,0,2,2,4
TAX              :\ Index into jump table
LDY &0319        :\ Get current line
JMP (LCD06,X)    :\ Jump to calculation setup
.LCD06
EQUW LCD21       :\ Memory map 0,1  MODE 0,1,2,3
EQUW LCD15       :\ Memory map 2,3  MODE 4,5,6
EQUW LCD0C       :\ Memory map 4    MODE 7

.LCD0C
LDX LE0AF,Y      :\ Get offset high byte for start of this line
LDA LE0C8,Y      :\ Get offset low byte for start of this line
CLC
BRA LCD29        :\ CD13= 80 14       ..

.LCD15
LDA LE0E1,Y      :\ CD15= B9 E1 E0    9a`
LSR A            :\ CD18= 4A          J
TAX              :\ CD19= AA          *
TYA              :\ CD1A= 98          .
AND #&03         :\ CD1B= 29 03       ).
LSR A            :\ CD1D= 4A          J
ROR A            :\ CD1E= 6A          j
BRA LCD28        :\ CD1F= 80 07       ..

.LCD21 
LDX LE0E1,Y      :\ CD21= BE E1 E0    >a`
TYA              :\ CD24= 98          .
AND #&01         :\ CD25= 29 01       ).
LSR A            :\ CD27= 4A          J
.LCD28
ROR A               :\ A=A/2 +(128*carry)

.LCD29
ADC &0350           :\ window area start address lo
STA &D8             :\ store it
TXA
ADC &0351           :\ window start address hi
TAY
LDA &0318           :\ text column
LDX &034F           :\ bytes per character
DEX
BEQ LCD4E           :\ 1 colour, MODE 7
CPX #&0F
BEQ LCD43           :\ 4 colours, MODE 1 or MODE 5
BCC LCD44           :\ 2 colours, MODE 0,3,4,6
ASL A               :\ 16 colours, MODE 2
.LCD43
ASL A            :\ CD43= 0A          .
.LCD44
ASL A            :\ CD44= 0A          .
ASL A            :\ CD45= 0A          .
BCC LCD4A        :\ CD46= 90 02       ..
INY              :\ CD48= C8          H
INY              :\ CD49= C8          H
.LCD4A
ASL A            :\ CD4A= 0A          .
BCC LCD4F        :\ CD4B= 90 02       ..
INY              :\ CD4D= C8          H
.LCD4E
CLC              :\ CD4E= 18          .
.LCD4F
ADC &D8          :\ CD4F= 65 D8       eX
STA &D8          :\ CD51= 85 D8       .X
STA &034A        :\ CD53= 8D 4A 03    .J.
TAX              :\ CD56= AA          *
TYA              :\ CD57= 98          .
ADC #&00         :\ CD58= 69 00       i.
STA &034B        :\ CD5A= 8D 4B 03    .K.
BPL LCD63        :\ CD5D= 10 04       ..
SEC              :\ CD5F= 38          8
SBC &0354        :\ CD60= ED 54 03    mT.
.LCD63
STA &D9          :\ CD63= 85 D9       .Y
CLC              :\ CD65= 18          .
RTS              :\ CD66= 60          `
 
.LCD67
INC &0324        :\ CD67= EE 24 03    n$.
BNE LCD6F        :\ CD6A= D0 03       P.
INC &0325        :\ CD6C= EE 25 03    n%.
.LCD6F
ASL A            :\ CD6F= 0A          .
.LCD70
BPL LCD67        :\ CD70= 10 F5       .u
PHY              :\ CD72= 5A          Z
STA &DD          :\ CD73= 85 DD       .]
LDX #&24         :\ CD75= A2 24       "$
JSR LDEC8        :\ CD77= 20 C8 DE     H^
BRA LCD7E        :\ CD7A= 80 02       ..
 
.LCD7C
BPL LCD81        :\ CD7C= 10 03       ..
.LCD7E
JSR LDB51        :\ CD7E= 20 51 DB     Q[
.LCD81
LSR &D1          :\ CD81= 46 D1       FQ
BCC LCD88        :\ CD83= 90 03       ..
JSR LDA67        :\ CD85= 20 67 DA     gZ
.LCD88
ASL &DD          :\ CD88= 06 DD       .]
BNE LCD7C        :\ CD8A= D0 F0       Pp
LDX #&28         :\ CD8C= A2 28       "(
LDY #&24         :\ CD8E= A0 24        $
JSR LC90C        :\ CD90= 20 0C C9     .I
PLY              :\ CD93= 7A          z
BRA LCDE6        :\ CD94= 80 50       .P
 
.LCD96
JSR LE22C        :\ CD96= 20 2C E2     ,b
STZ &0359        :\ CD99= 9C 59 03    .Y.
LDA &035B        :\ CD9C= AD 5B 03    -[.
AND #&0F         :\ CD9F= 29 0F       ).
.LCDA1
STA &035A        :\ CDA1= 8D 5A 03    .Z.
LDY #&28         :\ CDA4= A0 28        (
JSR LC91C        :\ CDA6= 20 1C C9     .I
LDY #&24         :\ CDA9= A0 24        $
LDX #&00         :\ CDAB= A2 00       ".
JSR LCEB4        :\ CDAD= 20 B4 CE     4N
STA &DC          :\ CDB0= 85 DC       .\
LDX #&04         :\ CDB2= A2 04       ".
JSR LCEB4        :\ CDB4= 20 B4 CE     4N
ROR A            :\ CDB7= 6A          j
TRB &DC          :\ CDB8= 14 DC       .\
LDX #&26         :\ CDBA= A2 26       "&
LDY #&06         :\ CDBC= A0 06        .
JSR LCEB4        :\ CDBE= 20 B4 CE     4N
STA &DD          :\ CDC1= 85 DD       .]
LDX #&26         :\ CDC3= A2 26       "&
LDY #&02         :\ CDC5= A0 02        .
JSR LCEB4        :\ CDC7= 20 B4 CE     4N
ROR A            :\ CDCA= 6A          j
TRB &DD          :\ CDCB= 14 DD       .]
LDY #&07         :\ CDCD= A0 07        .
.LCDCF
LDA (&DE),Y      :\ CDCF= B1 DE       1^
AND &DC          :\ CDD1= 25 DC       %\
LSR &DD          :\ CDD3= 46 DD       F]
BCS LCDD9        :\ CDD5= B0 02       0.
LDA #&00         :\ CDD7= A9 00       ).
.LCDD9
STA &032C,Y      :\ CDD9= 99 2C 03    .,.
DEY              :\ CDDC= 88          .
BPL LCDCF        :\ CDDD= 10 F0       .p
LDY #&F8         :\ CDDF= A0 F8        x
.LCDE1
LDA &0234,Y      :\ CDE1= B9 34 02    94.
BNE LCD70        :\ CDE4= D0 8A       P.
.LCDE6
LDX &0326        :\ CDE6= AE 26 03    .&.
BNE LCDEE        :\ CDE9= D0 03       P.
DEC &0327        :\ CDEB= CE 27 03    N'.
.LCDEE
DEC &0326        :\ CDEE= CE 26 03    N&.
INY              :\ CDF1= C8          H
BNE LCDE1        :\ CDF2= D0 ED       Pm
LDX #&2A         :\ CDF4= A2 2A       "*
LDY #&26         :\ CDF6= A0 26        &
JMP LC90C        :\ CDF8= 4C 0C C9    L.I
 
.LCDFB
LDA #&F8         :\ CDFB= A9 F8       )x
STA &DE          :\ CDFD= 85 DE       .^
LDA #&BB         :\ CDFF= A9 BB       );
STA &DF          :\ CE01= 85 DF       ._
LDX #&08         :\ CE03= A2 08       ".
STX &0359        :\ CE05= 8E 59 03    .Y.
LDA #&00         :\ CE08= A9 00       ).
BRA LCDA1        :\ CE0A= 80 95       ..
 
.LCE0C
JSR LD12D        :\ CE0C= 20 2D D1     -Q
BCS LCD96        :\ CE0F= B0 85       0.
LDX &0360        :\ CE11= AE 60 03    .`.
BEQ LCE4D        :\ CE14= F0 37       p7
JSR LE22C        :\ CE16= 20 2C E2     ,b
.LCE19
LDY #&07         :\ CE19= A0 07        .
CPX #&03         :\ CE1B= E0 03       `.
BEQ LCE53        :\ CE1D= F0 34       p4
BCS LCE7C        :\ CE1F= B0 5B       0[
.LCE21
LDA (&DE),Y      :\ CE21= B1 DE       1^
ORA &D2          :\ CE23= 05 D2       .R
EOR &D3          :\ CE25= 45 D3       ES
STA (&D8),Y      :\ CE27= 91 D8       .X
DEY              :\ CE29= 88          .
BPL LCE21        :\ CE2A= 10 F5       .u
RTS              :\ CE2C= 60          `
 
LDA #&20         :\ CE2D= A9 20       ) 
BIT &0366        :\ CE2F= 2C 66 03    ,f.
BNE LCE37        :\ CE32= D0 03       P.
JSR LC29A        :\ CE34= 20 9A C2     .B
.LCE37
JSR LE2D2        :\ CE37= 20 D2 E2     Rb
BNE LCDFB        :\ CE3A= D0 BF       P?
LDX &0360        :\ CE3C= AE 60 03    .`.
BEQ LCE4B        :\ CE3F= F0 0A       p.
LDA #&00         :\ CE41= A9 00       ).
STA &DE          :\ CE43= 85 DE       .^
LDA #&B9         :\ CE45= A9 B9       )9
STA &DF          :\ CE47= 85 DF       ._
BRA LCE19        :\ CE49= 80 CE       .N
 
.LCE4B
LDA #&20         :\ CE4B= A9 20       ) 
.LCE4D
JSR LDDE5        :\ CE4D= 20 E5 DD     e]
STA (&D8)        :\ CE50= 92 D8       .X
RTS              :\ CE52= 60          `
 
.LCE53
LDA &D9          :\ CE53= A5 D9       %Y
LDX &D8          :\ CE55= A6 D8       &X
JSR LCEE7        :\ CE57= 20 E7 CE     gN
.LCE5A
LDA (&DE),Y      :\ CE5A= B1 DE       1^
AND #&0F         :\ CE5C= 29 0F       ).
TAX              :\ CE5E= AA          *
LDA LE013,X      :\ CE5F= BD 13 E0    =.`
ORA &D2          :\ CE62= 05 D2       .R
EOR &D3          :\ CE64= 45 D3       ES
STA (&E0),Y      :\ CE66= 91 E0       .`
LDA (&DE),Y      :\ CE68= B1 DE       1^
LSR A            :\ CE6A= 4A          J
LSR A            :\ CE6B= 4A          J
LSR A            :\ CE6C= 4A          J
LSR A            :\ CE6D= 4A          J
TAX              :\ CE6E= AA          *
LDA LE013,X      :\ CE6F= BD 13 E0    =.`
ORA &D2          :\ CE72= 05 D2       .R
EOR &D3          :\ CE74= 45 D3       ES
STA (&D8),Y      :\ CE76= 91 D8       .X
DEY              :\ CE78= 88          .
BPL LCE5A        :\ CE79= 10 DF       ._
RTS              :\ CE7B= 60          `
 
.LCE7C
LDA &D9          :\ CE7C= A5 D9       %Y
LDX &D8          :\ CE7E= A6 D8       &X
JSR LCED9        :\ CE80= 20 D9 CE     YN
.LCE83
LDA (&DE),Y      :\ CE83= B1 DE       1^
JSR LCEA9        :\ CE85= 20 A9 CE     )N
STA (&E0),Y      :\ CE88= 91 E0       .`
LDA (&DE),Y      :\ CE8A= B1 DE       1^
LSR A            :\ CE8C= 4A          J
LSR A            :\ CE8D= 4A          J
PHA              :\ CE8E= 48          H
JSR LCEA9        :\ CE8F= 20 A9 CE     )N
STA (&DC),Y      :\ CE92= 91 DC       .\
PLA              :\ CE94= 68          h
LSR A            :\ CE95= 4A          J
LSR A            :\ CE96= 4A          J
PHA              :\ CE97= 48          H
JSR LCEA9        :\ CE98= 20 A9 CE     )N
STA (&DA),Y      :\ CE9B= 91 DA       .Z
PLA              :\ CE9D= 68          h
LSR A            :\ CE9E= 4A          J
LSR A            :\ CE9F= 4A          J
JSR LCEA9        :\ CEA0= 20 A9 CE     )N
STA (&D8),Y      :\ CEA3= 91 D8       .X
DEY              :\ CEA5= 88          .
BPL LCE83        :\ CEA6= 10 DB       .[
RTS              :\ CEA8= 60          `
 
.LCEA9
AND #&03         :\ CEA9= 29 03       ).
TAX              :\ CEAB= AA          *
LDA LE023,X      :\ CEAC= BD 23 E0    =#`
ORA &D2          :\ CEAF= 05 D2       .R
EOR &D3          :\ CEB1= 45 D3       ES
RTS              :\ CEB3= 60          `
 
.LCEB4
SEC              :\ CEB4= 38          8
LDA &0300,X      :\ CEB5= BD 00 03    =..
SBC &0300,Y      :\ CEB8= F9 00 03    y..
STA &DA          :\ CEBB= 85 DA       .Z
LDA &0301,X      :\ CEBD= BD 01 03    =..
SBC &0301,Y      :\ CEC0= F9 01 03    y..
BMI LCED1        :\ CEC3= 30 0C       0.
BNE LCED5        :\ CEC5= D0 0E       P.
LDX &DA          :\ CEC7= A6 DA       &Z
CPX #&08         :\ CEC9= E0 08       `.
BCS LCED5        :\ CECB= B0 08       0.
LDA LE127,X      :\ CECD= BD 27 E1    ='a
RTS              :\ CED0= 60          `
 
.LCED1
LDA #&FF         :\ CED1= A9 FF       ).
SEC              :\ CED3= 38          8
RTS              :\ CED4= 60          `
 
.LCED5
LDA #&00         :\ CED5= A9 00       ).
CLC              :\ CED7= 18          .
RTS              :\ CED8= 60          `
 
.LCED9
JSR LCEE7        :\ CED9= 20 E7 CE     gN
STX &DA          :\ CEDC= 86 DA       .Z
STA &DB          :\ CEDE= 85 DB       .[
JSR LCEE7        :\ CEE0= 20 E7 CE     gN
STX &DC          :\ CEE3= 86 DC       .\
STA &DD          :\ CEE5= 85 DD       .]
.LCEE7
PHA              :\ CEE7= 48          H
TXA              :\ CEE8= 8A          .
CLC              :\ CEE9= 18          .
ADC #&08         :\ CEEA= 69 08       i.
TAX              :\ CEEC= AA          *
PLA              :\ CEED= 68          h
BCC LCEF6        :\ CEEE= 90 06       ..
INC A            :\ CEF0= 1A          .
BPL LCEF6        :\ CEF1= 10 03       ..
LDA &034E        :\ CEF3= AD 4E 03    -N.
.LCEF6
STX &E0          :\ CEF6= 86 E0       .`
STA &E1          :\ CEF8= 85 E1       .a
RTS              :\ CEFA= 60          `
 
LDA &031D        :\ CEFB= AD 1D 03    -..
LDY &031C        :\ CEFE= AC 1C 03    ,..
.LCF01
CPY #&07         :\ CF01= C0 07       @.
BCC LCF24        :\ CF03= 90 1F       ..
BNE LCF0A        :\ CF05= D0 03       P.
ADC &0290        :\ CF07= 6D 90 02    m..
.LCF0A
CPY #&08         :\ CF0A= C0 08       @.
BNE LCF15        :\ CF0C= D0 07       P.
ORA #&00         :\ CF0E= 09 00       ..
BMI LCF15        :\ CF10= 30 03       0.
EOR &0291        :\ CF12= 4D 91 02    M..
.LCF15
CPY #&0A         :\ CF15= C0 0A       @.
BNE LCF24        :\ CF17= D0 0B       P.
STA &035F        :\ CF19= 8D 5F 03    ._.
JSR LE2D2        :\ CF1C= 20 D2 E2     Rb
BNE LCF2A        :\ CF1F= D0 09       P.
LDA &035F        :\ CF21= AD 5F 03    -_.
.LCF24
STY CRTC+0        :\ CF24= 8C 00 FE    ..~
STA CRTC+1        :\ CF27= 8D 01 FE    ..~
.LCF2A
RTS              :\ CF2A= 60          `
 
.LCF2B
JSR LE2D2        :\ CF2B= 20 D2 E2     Rb
BNE LCF2A        :\ CF2E= D0 FA       Pz
LDA &031C        :\ CF30= AD 1C 03    -..
AND #&03         :\ CF33= 29 03       ).
ASL A            :\ CF35= 0A          .
TAX              :\ CF36= AA          *
LDA #&20         :\ CF37= A9 20       ) 
JMP (LCF3C,X)    :\ CF39= 7C 3C CF    |<O
 
.LCF3C
EQUW LCF53       :\ CF3C= 53 CF       S.
EQUW LCF50       :\ CF3E= 50 CF       P.
EQUW LCF44       :\ CF40= 44 CF       D.
EQUW LCF4B       :\ CF42= 4B CF       K.

.LCF44
LDA #&60         :\ CF44= A9 60       )`
TRB &035F        :\ CF46= 1C 5F 03    ._.
BRA LCF50        :\ CF49= 80 05       ..

.LCF4B
LDA #&60         :\ CF4B= A9 60       )`
TSB &035F        :\ CF4D= 0C 5F 03    ._.
.LCF50
LDA &035F        :\ CF50= AD 5F 03    -_.
.LCF53
LDY #&0A         :\ CF53= A0 0A        .
BRA LCF24        :\ CF55= 80 CD       .M
 
SBC #&01         :\ CF57= E9 01       i.
ASL A            :\ CF59= 0A          .
ASL A            :\ CF5A= 0A          .
ASL A            :\ CF5B= 0A          .
ADC #&07         :\ CF5C= 69 07       i.
TAY              :\ CF5E= A8          (
LDX #&07         :\ CF5F= A2 07       ".
.LCF61
LDA &031C,X      :\ CF61= BD 1C 03    =..
STA L8800,Y      :\ CF64= 99 00 88    ...
DEY              :\ CF67= 88          .
DEX              :\ CF68= CA          J
BPL LCF61        :\ CF69= 10 F6       .v
BRA LCF93        :\ CF6B= 80 26       .&
 
.LCF6D
LDA &0355        :\ CF6D= AD 55 03    -U.
BNE LCF73        :\ CF70= D0 01       P.
DEC A            :\ CF72= 3A          :
.LCF73
AND #&03         :\ CF73= 29 03       ).
INC A            :\ CF75= 1A          .
ASL A            :\ CF76= 0A          .
ASL A            :\ CF77= 0A          .
ASL A            :\ CF78= 0A          .
ASL A            :\ CF79= 0A          .
TAX              :\ CF7A= AA          *
LDY #&1C         :\ CF7B= A0 1C        .
.LCF7D
LDA LE1C3,X      :\ CF7D= BD C3 E1    =Ca
STA L87FF,Y      :\ CF80= 99 FF 87    ...
STA L8803,Y      :\ CF83= 99 03 88    ...
DEX              :\ CF86= CA          J
DEY              :\ CF87= 88          .
TYA              :\ CF88= 98          .
BIT #&07         :\ CF89= 89 07       ..
BNE LCF7D        :\ CF8B= D0 F0       Pp
DEY              :\ CF8D= 88          .
DEY              :\ CF8E= 88          .
DEY              :\ CF8F= 88          .
DEY              :\ CF90= 88          .
BPL LCF7D        :\ CF91= 10 EA       .j
.LCF93
JMP LC57D        :\ CF93= 4C 7D C5    L}E
 
SBC #&0B         :\ CF96= E9 0B       i.
ASL A            :\ CF98= 0A          .
ASL A            :\ CF99= 0A          .
ASL A            :\ CF9A= 0A          .
ADC #&03         :\ CF9B= 69 03       i.
PHA              :\ CF9D= 48          H
LDX #&07         :\ CF9E= A2 07       ".
.LCFA0
LDA &031C,X      :\ CFA0= BD 1C 03    =..
AND &0360        :\ CFA3= 2D 60 03    -`.
STA &DA          :\ CFA6= 85 DA       .Z
LDA &0360        :\ CFA8= AD 60 03    -`.
AND #&07         :\ CFAB= 29 07       ).
ADC &DA          :\ CFAD= 65 DA       eZ
TAY              :\ CFAF= A8          (
LDA LE14B,Y      :\ CFB0= B9 4B E1    9Ka
STA &031C,X      :\ CFB3= 9D 1C 03    ...
DEX              :\ CFB6= CA          J
BPL LCFA0        :\ CFB7= 10 E7       .g
LDA #&55         :\ CFB9= A9 55       )U
LDX &0355        :\ CFBB= AE 55 03    .U.
BNE LCFC2        :\ CFBE= D0 02       P.
LDA #&33         :\ CFC0= A9 33       )3
.LCFC2
STA &DA          :\ CFC2= 85 DA       .Z
PLY              :\ CFC4= 7A          z
LDX #&07         :\ CFC5= A2 07       ".
.LCFC7
LDA &031C,X      :\ CFC7= BD 1C 03    =..
DEX              :\ CFCA= CA          J
EOR &031C,X      :\ CFCB= 5D 1C 03    ]..
AND &DA          :\ CFCE= 25 DA       %Z
EOR &031C,X      :\ CFD0= 5D 1C 03    ]..
STA L8800,Y      :\ CFD3= 99 00 88    ...
STA L8804,Y      :\ CFD6= 99 04 88    ...
DEY              :\ CFD9= 88          .
DEX              :\ CFDA= CA          J
BPL LCFC7        :\ CFDB= 10 EA       .j
BRA LCF93        :\ CFDD= 80 B4       .4
 
LDA &031C        :\ CFDF= AD 1C 03    -..
STA &0367        :\ CFE2= 8D 67 03    .g.
RTS              :\ CFE5= 60          `
 
LDA &031C        :\ CFE6= AD 1C 03    -..
BNE LCFF5        :\ CFE9= D0 0A       P.
JSR LC910        :\ CFEB= 20 10 C9     .I
LDA &D0          :\ CFEE= A5 D0       %P
AND #&08         :\ CFF0= 29 08       ).
ASL A            :\ CFF2= 0A          .
BRA LD006        :\ CFF3= 80 11       ..
 
.LCFF5
LDA #&00         :\ CFF5= A9 00       ).
STA &032C        :\ CFF7= 8D 2C 03    .,.
STA &032F        :\ CFFA= 8D 2F 03    ./.
JSR LE2A2        :\ CFFD= 20 A2 E2     "b
STX &032E        :\ D000= 8E 2E 03    ...
STY &032D        :\ D003= 8C 2D 03    .-.
.LD006
STA &DC          :\ D006= 85 DC       .\
SEC              :\ D008= 38          8
LDA &032E        :\ D009= AD 2E 03    -..
SBC &032C        :\ D00C= ED 2C 03    m,.
JSR LC93B        :\ D00F= 20 3B C9     ;I
STA &0328        :\ D012= 8D 28 03    .(.
STX &0329        :\ D015= 8E 29 03    .).
LDX &034F        :\ D018= AE 4F 03    .O.
CPX #&01         :\ D01B= E0 01       `.
BEQ LD026        :\ D01D= F0 07       p.
LDA &031E        :\ D01F= AD 1E 03    -..
BEQ LD026        :\ D022= F0 02       p.
LDX #&08         :\ D024= A2 08       ".
.LD026
STX &032A        :\ D026= 8E 2A 03    .*.
LDA &031D        :\ D029= AD 1D 03    -..
LSR A            :\ D02C= 4A          J
PHP              :\ D02D= 08          .
ROL A            :\ D02E= 2A          *
PLP              :\ D02F= 28          (
ROL A            :\ D030= 2A          *
ASL A            :\ D031= 0A          .
CMP #&10         :\ D032= C9 10       I.
BCC LD039        :\ D034= 90 03       ..
EOR &0366        :\ D036= 4D 66 03    Mf.
.LD039
AND #&0E         :\ D039= 29 0E       ).
ORA &DC          :\ D03B= 05 DC       .\
.LD03D
TAX              :\ D03D= AA          *
LDA &0350        :\ D03E= AD 50 03    -P.
STA &D8          :\ D041= 85 D8       .X
LDA &0351        :\ D043= AD 51 03    -Q.
STA &D9          :\ D046= 85 D9       .Y
JSR LD04E        :\ D048= 20 4E D0     NP
JMP LC6D8        :\ D04B= 4C D8 C6    LXF
 
.LD04E
JMP (LE20C,X)    :\ D04E= 7C 0C E2    |.b
 
.LD051
PHX              :\ D051= DA          Z
JSR LC910        :\ D052= 20 10 C9     .I
JSR LC908        :\ D055= 20 08 C9     .I
LDX &034F        :\ D058= AE 4F 03    .O.
STX &032A        :\ D05B= 8E 2A 03    .*.
PLA              :\ D05E= 68          h
LSR A            :\ D05F= 4A          J
EOR &D0          :\ D060= 45 D0       EP
AND #&F7         :\ D062= 29 F7       )w
EOR &D0          :\ D064= 45 D0       EP
ASL A            :\ D066= 0A          .
BRA LD03D        :\ D067= 80 D4       .T
 
STZ &0334        :\ D069= 9C 34 03    .4.
STZ &0335        :\ D06C= 9C 35 03    .5.
JSR LE252        :\ D06F= 20 52 E2     Rb
STX &0336        :\ D072= 8E 36 03    .6.
STY &0337        :\ D075= 8C 37 03    .7.
JSR LE25C        :\ D078= 20 5C E2     \b
INX              :\ D07B= E8          h
STX &0338        :\ D07C= 8E 38 03    .8.
STY &0339        :\ D07F= 8C 39 03    .9.
LDY #&00         :\ D082= A0 00        .
LDA &031C        :\ D084= AD 1C 03    -..
JSR LD0E5        :\ D087= 20 E5 D0     eP
LDA &031D        :\ D08A= AD 1D 03    -..
JSR LD0E5        :\ D08D= 20 E5 D0     eP
LDA &0333        :\ D090= AD 33 03    -3.
CMP &0331        :\ D093= CD 31 03    M1.
BCC LD10E        :\ D096= 90 76       .v
BNE LD0A2        :\ D098= D0 08       P.
LDA &0330        :\ D09A= AD 30 03    -0.
CMP &0332        :\ D09D= CD 32 03    M2.
BCS LD10E        :\ D0A0= B0 6C       0l
.LD0A2
LDA &0318        :\ D0A2= AD 18 03    -..
PHA              :\ D0A5= 48          H
LDA &0319        :\ D0A6= AD 19 03    -..
PHA              :\ D0A9= 48          H
LDY &0331        :\ D0AA= AC 31 03    ,1.
.LD0AD
PHY              :\ D0AD= 5A          Z
LDA &0366        :\ D0AE= AD 66 03    -f.
EOR #&08         :\ D0B1= 49 08       I.
AND #&0E         :\ D0B3= 29 0E       ).
TAX              :\ D0B5= AA          *
TYA              :\ D0B6= 98          .
JSR LC2C7        :\ D0B7= 20 C7 C2     GB
LDX #&00         :\ D0BA= A2 00       ".
LDA &0338        :\ D0BC= AD 38 03    -8.
CPY &0331        :\ D0BF= CC 31 03    L1.
BNE LD0C7        :\ D0C2= D0 03       P.
LDX &0330        :\ D0C4= AE 30 03    .0.
.LD0C7
CPY &0333        :\ D0C7= CC 33 03    L3.
BEQ LD0D3        :\ D0CA= F0 07       p.
JSR LCA7F        :\ D0CC= 20 7F CA     .J
PLY              :\ D0CF= 7A          z
INY              :\ D0D0= C8          H
BRA LD0AD        :\ D0D1= 80 DA       .Z
 
.LD0D3
LDA &0332        :\ D0D3= AD 32 03    -2.
JSR LCA7F        :\ D0D6= 20 7F CA     .J
PLY              :\ D0D9= 7A          z
PLA              :\ D0DA= 68          h
STA &0319        :\ D0DB= 8D 19 03    ...
PLA              :\ D0DE= 68          h
STA &0318        :\ D0DF= 8D 18 03    ...
JMP LCCFA        :\ D0E2= 4C FA CC    LzL
 
.LD0E5
PHA              :\ D0E5= 48          H
AND #&03         :\ D0E6= 29 03       ).
ASL A            :\ D0E8= 0A          .
JSR LD0F0        :\ D0E9= 20 F0 D0     pP
PLA              :\ D0EC= 68          h
LSR A            :\ D0ED= 4A          J
ORA #&01         :\ D0EE= 09 01       ..
.LD0F0
TAX              :\ D0F0= AA          *
AND #&01         :\ D0F1= 29 01       ).
PHA              :\ D0F3= 48          H
LDA &0334,X      :\ D0F4= BD 34 03    =4.
PLX              :\ D0F7= FA          z
CLC              :\ D0F8= 18          .
INY              :\ D0F9= C8          H
ADC &031D,Y      :\ D0FA= 79 1D 03    y..
BMI LD109        :\ D0FD= 30 0A       0.
CMP &0338,X      :\ D0FF= DD 38 03    ]8.
BCC LD10B        :\ D102= 90 07       ..
LDA &0338,X      :\ D104= BD 38 03    =8.
BRA LD10B        :\ D107= 80 02       ..
 
.LD109
LDA #&00         :\ D109= A9 00       ).
.LD10B
STA &032F,Y      :\ D10B= 99 2F 03    ./.
.LD10E
RTS              :\ D10E= 60          `
 
SEC              :\ D10F= 38          8
LDX &031C        :\ D110= AE 1C 03    ...
LDY #&00         :\ D113= A0 00        .
BCC LD11A        :\ D115= 90 03       ..
JMP LEC92        :\ D117= 4C 92 EC    L.l
 
.LD11A
SEC              :\ D11A= 38          8
JMP LEC94        :\ D11B= 4C 94 EC    L.l
 
LDA &0366        :\ D11E= AD 66 03    -f.
AND &031D        :\ D121= 2D 1D 03    -..
EOR &031C        :\ D124= 4D 1C 03    M..
STA &0366        :\ D127= 8D 66 03    .f.
LSR A            :\ D12A= 4A          J
BCS LD145        :\ D12B= B0 18       0.
.LD12D
PHA              :\ D12D= 48          H
PHX              :\ D12E= DA          Z
JSR LE2D2        :\ D12F= 20 D2 E2     Rb
SEC              :\ D132= 38          8
BNE LD143        :\ D133= D0 0E       P.
CLC              :\ D135= 18          .
BIT &036C        :\ D136= 2C 6C 03    ,l.
BPL LD143        :\ D139= 10 08       ..
PHP              :\ D13B= 08          .
JSR LC3F6        :\ D13C= 20 F6 C3     vC
JSR LC25B        :\ D13F= 20 5B C2     [B
PLP              :\ D142= 28          (
.LD143
PLX              :\ D143= FA          z
PLA              :\ D144= 68          h
.LD145
RTS              :\ D145= 60          `
 
.LD146
LDX #&20         :\ D146= A2 20       " 
JSR LD1E2        :\ D148= 20 E2 D1     bQ
LDA &031F        :\ D14B= AD 1F 03    -..
LDY #&05         :\ D14E= A0 05        .
AND #&03         :\ D150= 29 03       ).
BEQ LD160        :\ D152= F0 0C       p.
LSR A            :\ D154= 4A          J
DEY              :\ D155= 88          .
BCC LD160        :\ D156= 90 08       ..
TAX              :\ D158= AA          *
LDY &035B,X      :\ D159= BC 5B 03    <[.
ASL A            :\ D15C= 0A          .
ASL A            :\ D15D= 0A          .
ASL A            :\ D15E= 0A          .
TAX              :\ D15F= AA          *
.LD160
STX &0359        :\ D160= 8E 59 03    .Y.
TYA              :\ D163= 98          .
AND #&0F         :\ D164= 29 0F       ).
STA &035A        :\ D166= 8D 5A 03    .Z.
LDA &031F        :\ D169= AD 1F 03    -..
LSR A            :\ D16C= 4A          J
LSR A            :\ D16D= 4A          J
AND #&FE         :\ D16E= 29 FE       )~
TAX              :\ D170= AA          *
CMP #&34         :\ D171= C9 34       I4
BCS LD190        :\ D173= B0 1B       0.
AND #&F3         :\ D175= 29 F3       )s
CMP #&12         :\ D177= C9 12       I.
PHP              :\ D179= 08          .
BEQ LD184        :\ D17A= F0 08       p.
CPX #&2E         :\ D17C= E0 2E       `.
BEQ LD184        :\ D17E= F0 04       p.
CPY #&05         :\ D180= C0 05       @.
BEQ LD19D        :\ D182= F0 19       p.
.LD184
LDA &031F        :\ D184= AD 1F 03    -..
JSR LD193        :\ D187= 20 93 D1     .Q
PLP              :\ D18A= 28          (
BNE LD19E        :\ D18B= D0 11       P.
JMP LC4DF        :\ D18D= 4C DF C4    L_D
 
.LD190
JMP LC6A3        :\ D190= 4C A3 C6    L#F
 
.LD193
CPX #&10         :\ D193= E0 10       `.
BCS LD19A        :\ D195= B0 03       0.
JMP LD8A9        :\ D197= 4C A9 D8    L)X
 
.LD19A
JMP (LE07B,X)    :\ D19A= 7C 7B E0    |{`
 
.LD19D
PLA              :\ D19D= 68          h
.LD19E
JSR LC91A        :\ D19E= 20 1A C9     .I
LDY #&24         :\ D1A1= A0 24        $
JMP LC916        :\ D1A3= 4C 16 C9    L.I
 
.LD1A6
LDX #&24         :\ D1A6= A2 24       "$
.LD1A8
INX              :\ D1A8= E8          h
INX              :\ D1A9= E8          h
JSR LD1B5        :\ D1AA= 20 B5 D1     5Q
DEX              :\ D1AD= CA          J
DEX              :\ D1AE= CA          J
ASL A            :\ D1AF= 0A          .
ASL A            :\ D1B0= 0A          .
LDY #&00         :\ D1B1= A0 00        .
BRA LD1B9        :\ D1B3= 80 04       ..
 
.LD1B5
LDY #&02         :\ D1B5= A0 02        .
.LD1B7
LDA #&00         :\ D1B7= A9 00       ).
.LD1B9
STA &DA          :\ D1B9= 85 DA       .Z
LDA &0300,X      :\ D1BB= BD 00 03    =..
CMP &0300,Y      :\ D1BE= D9 00 03    Y..
LDA &0301,X      :\ D1C1= BD 01 03    =..
SBC &0301,Y      :\ D1C4= F9 01 03    y..
BMI LD1D9        :\ D1C7= 30 10       0.
LDA &0304,Y      :\ D1C9= B9 04 03    9..
CMP &0300,X      :\ D1CC= DD 00 03    ]..
LDA &0305,Y      :\ D1CF= B9 05 03    9..
SBC &0301,X      :\ D1D2= FD 01 03    }..
BPL LD1DB        :\ D1D5= 10 04       ..
INC &DA          :\ D1D7= E6 DA       fZ
.LD1D9
INC &DA          :\ D1D9= E6 DA       fZ
.LD1DB
LDA &DA          :\ D1DB= A5 DA       %Z
RTS              :\ D1DD= 60          `
 
.LD1DE
LDA #&FF         :\ D1DE= A9 FF       ).
BRA LD1E5        :\ D1E0= 80 03       ..
 
.LD1E2
LDA &031F        :\ D1E2= AD 1F 03    -..
.LD1E5
STA &DA          :\ D1E5= 85 DA       .Z
LDY #&02         :\ D1E7= A0 02        .
JSR LD20B        :\ D1E9= 20 0B D2     .R
JSR LD242        :\ D1EC= 20 42 D2     BR
LDY #&00         :\ D1EF= A0 00        .
DEX              :\ D1F1= CA          J
DEX              :\ D1F2= CA          J
JSR LD20B        :\ D1F3= 20 0B D2     .R
LDY &0361        :\ D1F6= AC 61 03    ,a.
CPY #&03         :\ D1F9= C0 03       @.
BEQ LD202        :\ D1FB= F0 05       p.
BCS LD205        :\ D1FD= B0 06       0.
JSR LD242        :\ D1FF= 20 42 D2     BR
.LD202
JSR LD242        :\ D202= 20 42 D2     BR
.LD205
LDA &0356        :\ D205= AD 56 03    -V.
BNE LD242        :\ D208= D0 38       P8
RTS              :\ D20A= 60          `
 
.LD20B
CLC              :\ D20B= 18          .
LDA &DA          :\ D20C= A5 DA       %Z
AND #&04         :\ D20E= 29 04       ).
BEQ LD21B        :\ D210= F0 09       p.
LDA &0302,X      :\ D212= BD 02 03    =..
PHA              :\ D215= 48          H
LDA &0303,X      :\ D216= BD 03 03    =..
BRA LD229        :\ D219= 80 0E       ..
 
.LD21B
LDA &0302,X      :\ D21B= BD 02 03    =..
ADC &0310,Y      :\ D21E= 79 10 03    y..
PHA              :\ D221= 48          H
LDA &0303,X      :\ D222= BD 03 03    =..
ADC &0311,Y      :\ D225= 79 11 03    y..
CLC              :\ D228= 18          .
.LD229
STA &0311,Y      :\ D229= 99 11 03    ...
ADC &030D,Y      :\ D22C= 79 0D 03    y..
STA &0303,X      :\ D22F= 9D 03 03    ...
PLA              :\ D232= 68          h
STA &0310,Y      :\ D233= 99 10 03    ...
CLC              :\ D236= 18          .
ADC &030C,Y      :\ D237= 79 0C 03    y..
STA &0302,X      :\ D23A= 9D 02 03    ...
BCC LD242        :\ D23D= 90 03       ..
INC &0303,X      :\ D23F= FE 03 03    ~..
.LD242
LDA &0303,X      :\ D242= BD 03 03    =..
ASL A            :\ D245= 0A          .
ROR &0303,X      :\ D246= 7E 03 03    ~..
ROR &0302,X      :\ D249= 7E 02 03    ~..
RTS              :\ D24C= 60          `
 
.LD24D
PHX              :\ D24D= DA          Z
PHY              :\ D24E= 5A          Z
PHY              :\ D24F= 5A          Z
PHX              :\ D250= DA          Z
PHY              :\ D251= 5A          Z
JSR LD280        :\ D252= 20 80 D2     .R
PLX              :\ D255= FA          z
JSR LD280        :\ D256= 20 80 D2     .R
PLX              :\ D259= FA          z
PLY              :\ D25A= 7A          z
JSR LDAE8        :\ D25B= 20 E8 DA     hZ
PLX              :\ D25E= FA          z
JSR LD268        :\ D25F= 20 68 D2     hR
PLX              :\ D262= FA          z
BRA LD268        :\ D263= 80 03       ..
 
.LD265
JSR L9B09        :\ D265= 20 09 9B     ..
.LD268
LDY #&00         :\ D268= A0 00        .
JSR LD270        :\ D26A= 20 70 D2     pR
INX              :\ D26D= E8          h
LDY #&02         :\ D26E= A0 02        .
.LD270
SEC              :\ D270= 38          8
JSR LD276        :\ D271= 20 76 D2     vR
INX              :\ D274= E8          h
INY              :\ D275= C8          H
.LD276
LDA &0300,X      :\ D276= BD 00 03    =..
SBC &0314,Y      :\ D279= F9 14 03    y..
STA &0300,X      :\ D27C= 9D 00 03    ...
.LD27F
RTS              :\ D27F= 60          `
 
.LD280
LDY #&00         :\ D280= A0 00        .
JSR LD288        :\ D282= 20 88 D2     .R
INX              :\ D285= E8          h
LDY #&02         :\ D286= A0 02        .
.LD288
CLC              :\ D288= 18          .
JSR LD28E        :\ D289= 20 8E D2     .R
INX              :\ D28C= E8          h
INY              :\ D28D= C8          H
.LD28E
LDA &0300,X      :\ D28E= BD 00 03    =..
ADC &0314,Y      :\ D291= 79 14 03    y..
STA &0300,X      :\ D294= 9D 00 03    ...
RTS              :\ D297= 60          `
 
.LD298
STA &E1          :\ D298= 85 E1       .a
JSR LD425        :\ D29A= 20 25 D4     %T
BEQ LD27F        :\ D29D= F0 E0       p`
LDY #&14         :\ D29F= A0 14        .
LDA #&20         :\ D2A1= A9 20       ) 
LDX #&2C         :\ D2A3= A2 2C       ",
JSR LD265        :\ D2A5= 20 65 D2     eR
JSR LD3AA        :\ D2A8= 20 AA D3     *S
LDA #&01         :\ D2AB= A9 01       ).
.LD2AD
STY &E0          :\ D2AD= 84 E0       .`
TSB &E0          :\ D2AF= 04 E0       .`
LDX #&2C         :\ D2B1= A2 2C       ",
LDY #&28         :\ D2B3= A0 28        (
JSR LC91E        :\ D2B5= 20 1E C9     .I
BIT &0335        :\ D2B8= 2C 35 03    ,5.
PHP              :\ D2BB= 08          .
LDX #&2C         :\ D2BC= A2 2C       ",
JSR LD726        :\ D2BE= 20 26 D7     &W
PLP              :\ D2C1= 28          (
BPL LD2C7        :\ D2C2= 10 03       ..
JSR LD3AA        :\ D2C4= 20 AA D3     *S
.LD2C7
LDY &032C        :\ D2C7= AC 2C 03    ,,.
LDA &032D        :\ D2CA= AD 2D 03    --.
BMI LD2D2        :\ D2CD= 30 03       0.
JSR LC92E        :\ D2CF= 20 2E C9     .I
.LD2D2
PHA              :\ D2D2= 48          H
CLC              :\ D2D3= 18          .
TYA              :\ D2D4= 98          .
ADC L8830        :\ D2D5= 6D 30 88    m0.
TAY              :\ D2D8= A8          (
PLA              :\ D2D9= 68          h
ADC L8831        :\ D2DA= 6D 31 88    m1.
BPL LD2AD        :\ D2DD= 10 CE       .N
INC A            :\ D2DF= 1A          .
BNE LD305        :\ D2E0= D0 23       P#
INY              :\ D2E2= C8          H
BNE LD305        :\ D2E3= D0 20       P 
LDA &E0          :\ D2E5= A5 E0       %`
BEQ LD305        :\ D2E7= F0 1C       p.
LDA &032C        :\ D2E9= AD 2C 03    -,.
CMP &0328        :\ D2EC= CD 28 03    M(.
BEQ LD305        :\ D2EF= F0 14       p.
LDX #&2C         :\ D2F1= A2 2C       ",
LDY #&28         :\ D2F3= A0 28        (
LDA &0336        :\ D2F5= AD 36 03    -6.
ASL A            :\ D2F8= 0A          .
EOR &0336        :\ D2F9= 4D 36 03    M6.
BPL LD302        :\ D2FC= 10 04       ..
INX              :\ D2FE= E8          h
INX              :\ D2FF= E8          h
INY              :\ D300= C8          H
INY              :\ D301= C8          H
.LD302
JSR LC90C        :\ D302= 20 0C C9     .I
.LD305
JSR LD425        :\ D305= 20 25 D4     %T
LDA &0329        :\ D308= AD 29 03    -).
TAX              :\ D30B= AA          *
EOR &031C        :\ D30C= 4D 1C 03    M..
BMI LD329        :\ D30F= 30 18       0.
LDY #&02         :\ D311= A0 02        .
JSR LD46F        :\ D313= 20 6F D4     oT
BNE LD324        :\ D316= D0 0C       P.
LDX &032B        :\ D318= AE 2B 03    .+.
LDY #&00         :\ D31B= A0 00        .
JSR LD46F        :\ D31D= 20 6F D4     oT
BEQ LD333        :\ D320= F0 11       p.
EOR #&80         :\ D322= 49 80       I.
.LD324
STX &DA          :\ D324= 86 DA       .Z
EOR &DA          :\ D326= 45 DA       EZ
TAX              :\ D328= AA          *
.LD329
TXA              :\ D329= 8A          .
AND #&80         :\ D32A= 29 80       ).
BEQ LD330        :\ D32C= F0 02       p.
LDA #&C0         :\ D32E= A9 C0       )@
.LD330
TSB &E1          :\ D330= 04 E1       .a
CLC              :\ D332= 18          .
.LD333
RTS              :\ D333= 60          `
 
.LD334
LDA &E1          :\ D334= A5 E1       %a
STA L8848        :\ D336= 8D 48 88    .H.
BIT #&03         :\ D339= 89 03       ..
BEQ LD333        :\ D33B= F0 F6       pv
LDA #&10         :\ D33D= A9 10       ).
STA &DC          :\ D33F= 85 DC       .\
ASL A            :\ D341= 0A          .
STA &DD          :\ D342= 85 DD       .]
LDX #&1B         :\ D344= A2 1B       ".
JSR LD34F        :\ D346= 20 4F D3     OS
ASL &DC          :\ D349= 06 DC       .\
LSR &DD          :\ D34B= 46 DD       F]
LDX #&28         :\ D34D= A2 28       "(
.LD34F
LDA #&80         :\ D34F= A9 80       ).
STA &DA          :\ D351= 85 DA       .Z
LDA &0302,X      :\ D353= BD 02 03    =..
CMP L8832        :\ D356= CD 32 88    M2.
BNE LD333        :\ D359= D0 D8       PX
LDA &0303,X      :\ D35B= BD 03 03    =..
CMP L8833        :\ D35E= CD 33 88    M3.
BNE LD333        :\ D361= D0 D0       PP
LDY &0300,X      :\ D363= BC 00 03    <..
LDA &0301,X      :\ D366= BD 01 03    =..
BPL LD370        :\ D369= 10 05       ..
LSR &DA          :\ D36B= 46 DA       FZ
JSR LC92E        :\ D36D= 20 2E C9     .I
.LD370
CPY L8830        :\ D370= CC 30 88    L0.
BNE LD333        :\ D373= D0 BE       P>
CMP L8831        :\ D375= CD 31 88    M1.
BNE LD333        :\ D378= D0 B9       P9
LDA &E1          :\ D37A= A5 E1       %a
BIT #&02         :\ D37C= 89 02       ..
BEQ LD399        :\ D37E= F0 19       p.
LDY #&30         :\ D380= A0 30        0
BIT #&01         :\ D382= 89 01       ..
BEQ LD388        :\ D384= F0 02       p.
LDY &DC          :\ D386= A4 DC       $\
.LD388
TYA              :\ D388= 98          .
LSR A            :\ D389= 4A          J
LSR A            :\ D38A= 4A          J
BIT &E1          :\ D38B= 24 E1       $a
BNE LD395        :\ D38D= D0 06       P.
ORA &DC          :\ D38F= 05 DC       .\
TSB &E1          :\ D391= 04 E1       .a
BRA LD399        :\ D393= 80 04       ..
 
.LD395
ORA &DD          :\ D395= 05 DD       .]
TRB &E1          :\ D397= 14 E1       .a
.LD399
LDA &DA          :\ D399= A5 DA       %Z
BIT &E1          :\ D39B= 24 E1       $a
BEQ LD330        :\ D39D= F0 91       p.
TRB &E1          :\ D39F= 14 E1       .a
LDA &E1          :\ D3A1= A5 E1       %a
STA L8848        :\ D3A3= 8D 48 88    .H.
STA L8849        :\ D3A6= 8D 49 88    .I.
RTS              :\ D3A9= 60          `
 
.LD3AA
LDA &032E        :\ D3AA= AD 2E 03    -..
STA L8832        :\ D3AD= 8D 32 88    .2.
LDA &032F        :\ D3B0= AD 2F 03    -/.
STA L8833        :\ D3B3= 8D 33 88    .3.
JSR LD3FC        :\ D3B6= 20 FC D3     |S
JSR LD513        :\ D3B9= 20 13 D5     .U
STY L8830        :\ D3BC= 8C 30 88    .0.
LDA L8846        :\ D3BF= AD 46 88    -F.
LSR A            :\ D3C2= 4A          J
LDA L883D        :\ D3C3= AD 3D 88    -=.
BCC LD3CE        :\ D3C6= 90 06       ..
CMP #&80         :\ D3C8= C9 80       I.
ROR A            :\ D3CA= 6A          j
ROR L8830        :\ D3CB= 6E 30 88    n0.
.LD3CE
STA L8831        :\ D3CE= 8D 31 88    .1.
RTS              :\ D3D1= 60          `
 
.LD3D2
STZ L8847        :\ D3D2= 9C 47 88    .G.
STZ L8830        :\ D3D5= 9C 30 88    .0.
STZ L8831        :\ D3D8= 9C 31 88    .1.
STZ L8834        :\ D3DB= 9C 34 88    .4.
STZ L8835        :\ D3DE= 9C 35 88    .5.
LDA L8832        :\ D3E1= AD 32 88    -2.
ASL A            :\ D3E4= 0A          .
STA L8836        :\ D3E5= 8D 36 88    .6.
LDA L8833        :\ D3E8= AD 33 88    -3.
ROL A            :\ D3EB= 2A          *
STA L8837        :\ D3EC= 8D 37 88    .7.
LDA L8846        :\ D3EF= AD 46 88    -F.
BIT #&02         :\ D3F2= 89 02       ..
BEQ LD3FC        :\ D3F4= F0 06       p.
ASL L8836        :\ D3F6= 0E 36 88    .6.
ROL L8837        :\ D3F9= 2E 37 88    .7.
.LD3FC
LDA L8846        :\ D3FC= AD 46 88    -F.
LSR A            :\ D3FF= 4A          J
LSR A            :\ D400= 4A          J
LDY L8832        :\ D401= AC 32 88    ,2.
LDA L8833        :\ D404= AD 33 88    -3.
JSR LD4C5        :\ D407= 20 C5 D4     ET
SEC              :\ D40A= 38          8
LDX #&FC         :\ D40B= A2 FC       "|
.LD40D
LDA L873C,X      :\ D40D= BD 3C 87    =<.
SBC L8744,X      :\ D410= FD 44 87    }D.
STA L8744,X      :\ D413= 9D 44 87    .D.
INX              :\ D416= E8          h
BNE LD40D        :\ D417= D0 F4       Pt
RTS              :\ D419= 60          `
 
.LD41A
JSR LC91A        :\ D41A= 20 1A C9     .I
STZ &E1          :\ D41D= 64 E1       da
LDX #&20         :\ D41F= A2 20       " 
JSR LD427        :\ D421= 20 27 D4     'T
RTS              :\ D424= 60          `
 
.LD425
LDX #&24         :\ D425= A2 24       "$
.LD427
LDY #&1B         :\ D427= A0 1B        .
JSR LC91E        :\ D429= 20 1E C9     .I
LDX #&1B         :\ D42C= A2 1B       ".
JSR LD268        :\ D42E= 20 68 D2     hR
JSR LD486        :\ D431= 20 86 D4     .T
JSR LD513        :\ D434= 20 13 D5     .U
LDY #&0C         :\ D437= A0 0C        .
JSR LD4AB        :\ D439= 20 AB D4     +T
JSR LD513        :\ D43C= 20 13 D5     .U
CMP #&20         :\ D43F= C9 20       I 
BCC LD448        :\ D441= 90 05       ..
PLA              :\ D443= 68          h
PLA              :\ D444= 68          h
PLA              :\ D445= 68          h
PLA              :\ D446= 68          h
RTS              :\ D447= 60          `
 
.LD448
STY L8844        :\ D448= 8C 44 88    .D.
STA L8845        :\ D44B= 8D 45 88    .E.
LDA L8846        :\ D44E= AD 46 88    -F.
BIT #&02         :\ D451= 89 02       ..
BEQ LD45B        :\ D453= F0 06       p.
LSR L8845        :\ D455= 4E 45 88    NE.
ROR L8844        :\ D458= 6E 44 88    nD.
.LD45B
LDY L8844        :\ D45B= AC 44 88    ,D.
LDA L8845        :\ D45E= AD 45 88    -E.
JSR LC92E        :\ D461= 20 2E C9     .I
STY L8832        :\ D464= 8C 32 88    .2.
STA L8833        :\ D467= 8D 33 88    .3.
ORA L8832        :\ D46A= 0D 32 88    .2.
SEC              :\ D46D= 38          8
RTS              :\ D46E= 60          `
 
.LD46F
STZ &DA          :\ D46F= 64 DA       dZ
LDA &031B,Y      :\ D471= B9 1B 03    9..
CMP &0328,Y      :\ D474= D9 28 03    Y(.
BEQ LD47B        :\ D477= F0 02       p.
INC &DA          :\ D479= E6 DA       fZ
.LD47B
LDA &031C,Y      :\ D47B= B9 1C 03    9..
SBC &0329,Y      :\ D47E= F9 29 03    y).
BNE LD485        :\ D481= D0 02       P.
LDA &DA          :\ D483= A5 DA       %Z
.LD485
RTS              :\ D485= 60          `
 
.LD486
LDX &0355        :\ D486= AE 55 03    .U.
LDA LD4BF,X      :\ D489= BD BF D4    =?T
STA L8846        :\ D48C= 8D 46 88    .F.
LSR A            :\ D48F= 4A          J
PHA              :\ D490= 48          H
LDX #&04         :\ D491= A2 04       ".
.LD493
STZ L8837,X      :\ D493= 9E 37 88    .7.
DEX              :\ D496= CA          J
BNE LD493        :\ D497= D0 FA       Pz
JSR LD4A0        :\ D499= 20 A0 D4      T
PLA              :\ D49C= 68          h
LSR A            :\ D49D= 4A          J
LDX #&02         :\ D49E= A2 02       ".
.LD4A0
LDY &031B,X      :\ D4A0= BC 1B 03    <..
LDA &031C,X      :\ D4A3= BD 1C 03    =..
JSR LD4C5        :\ D4A6= 20 C5 D4     ET
LDY #&10         :\ D4A9= A0 10        .
.LD4AB
CLC              :\ D4AB= 18          .
LDX #&FC         :\ D4AC= A2 FC       "|
.LD4AE
LDA L873C,X      :\ D4AE= BD 3C 87    =<.
ADC L8830,Y      :\ D4B1= 79 30 88    y0.
STA L873C,X      :\ D4B4= 9D 3C 87    .<.
STA L8744,X      :\ D4B7= 9D 44 87    .D.
INY              :\ D4BA= C8          H
INX              :\ D4BB= E8          h
BNE LD4AE        :\ D4BC= D0 F0       Pp
RTS              :\ D4BE= 60          `
 
.LD4BF
EQUB &02         :\ D4BF= 02          .
BRK              :\ D4C0= 00          .
ORA (&FF,X)      :\ D4C1= 01 FF       ..
BRK              :\ D4C3= 00          .
\ORA (&8C,X)      :\ D4C4= 01       ..
EQUB &01
.LD4C5
STY L883C        :\ D4C5= 8C 3C 88
BCC LD4CF        :\ D4C8= 90 04
ASL L883C        :\ D4CA= 0E 3C 88
ROL L883D        :\ D4CD= 2A 8D 3D
.LD4CF
DEY              :\ D4D0= 88
LDY L883C        :\ D4D1= AC 3C 88    ,<.
TAX              :\ D4D4= AA          *
BPL LD4DA        :\ D4D5= 10 03       ..
JSR LC92E        :\ D4D7= 20 2E C9     .I
.LD4DA
STY L883C        :\ D4DA= 8C 3C 88    .<.
STA L883D        :\ D4DD= 8D 3D 88    .=.
STY L8840        :\ D4E0= 8C 40 88    .@.
STZ L8842        :\ D4E3= 9C 42 88    .B.
STZ L8843        :\ D4E6= 9C 43 88    .C.
LDY #&0F         :\ D4E9= A0 0F        .
LSR A            :\ D4EB= 4A          J
STA L8841        :\ D4EC= 8D 41 88    .A.
ROR L8840        :\ D4EF= 6E 40 88    n@.
.LD4F2
BCC LD507        :\ D4F2= 90 13       ..
CLC              :\ D4F4= 18          .
LDA L883C        :\ D4F5= AD 3C 88    -<.
ADC L8842        :\ D4F8= 6D 42 88    mB.
STA L8842        :\ D4FB= 8D 42 88    .B.
LDA L883D        :\ D4FE= AD 3D 88    -=.
ADC L8843        :\ D501= 6D 43 88    mC.
STA L8843        :\ D504= 8D 43 88    .C.
.LD507
LDX #&03         :\ D507= A2 03       ".
.LD509
ROR L8840,X      :\ D509= 7E 40 88    ~@.
DEX              :\ D50C= CA          J
BPL LD509        :\ D50D= 10 FA       .z
DEY              :\ D50F= 88          .
BPL LD4F2        :\ D510= 10 E0       .`
RTS              :\ D512= 60          `
 
.LD513
LDX #&02         :\ D513= A2 02       ".
.LD515
STZ L883C,X      :\ D515= 9E 3C 88    .<.
STZ &DB,X        :\ D518= 74 DB       t[
DEX              :\ D51A= CA          J
BPL LD515        :\ D51B= 10 F8       .x
LDY #&03         :\ D51D= A0 03        .
.LD51F
LDA L8840,Y      :\ D51F= B9 40 88    9@.
STA &DA          :\ D522= 85 DA       .Z
PHY              :\ D524= 5A          Z
LDY #&03         :\ D525= A0 03        .
.LD527
PHY              :\ D527= 5A          Z
SEC              :\ D528= 38          8
ROL L883C        :\ D529= 2E 3C 88    .<.
ROL L883D        :\ D52C= 2E 3D 88    .=.
ROL L883E        :\ D52F= 2E 3E 88    .>.
LDX #&01         :\ D532= A2 01       ".
LDA &DB          :\ D534= A5 DB       %[
.LD536
ASL &DA          :\ D536= 06 DA       .Z
ROL A            :\ D538= 2A          *
ROL &DC          :\ D539= 26 DC       &\
ROL &DD          :\ D53B= 26 DD       &]
DEX              :\ D53D= CA          J
BPL LD536        :\ D53E= 10 F6       .v
STA &DB          :\ D540= 85 DB       .[
SEC              :\ D542= 38          8
SBC L883C        :\ D543= ED 3C 88    m<.
TAX              :\ D546= AA          *
LDA &DC          :\ D547= A5 DC       %\
SBC L883D        :\ D549= ED 3D 88    m=.
TAY              :\ D54C= A8          (
LDA &DD          :\ D54D= A5 DD       %]
SBC L883E        :\ D54F= ED 3E 88    m>.
BCC LD55F        :\ D552= 90 0B       ..
STA &DD          :\ D554= 85 DD       .]
STY &DC          :\ D556= 84 DC       .\
STX &DB          :\ D558= 86 DB       .[
INC L883C        :\ D55A= EE 3C 88    n<.
BRA LD562        :\ D55D= 80 03       ..
 
.LD55F
DEC L883C        :\ D55F= CE 3C 88    N<.
.LD562
PLY              :\ D562= 7A          z
DEY              :\ D563= 88          .
BPL LD527        :\ D564= 10 C1       .A
PLY              :\ D566= 7A          z
DEY              :\ D567= 88          .
BPL LD51F        :\ D568= 10 B5       .5
LSR L883E        :\ D56A= 4E 3E 88    N>.
ROR L883D        :\ D56D= 6E 3D 88    n=.
ROR L883C        :\ D570= 6E 3C 88    n<.
STZ L883E        :\ D573= 9C 3E 88    .>.
STZ L883F        :\ D576= 9C 3F 88    .?.
LDY L883C        :\ D579= AC 3C 88    ,<.
LDA L883D        :\ D57C= AD 3D 88    -=.
RTS              :\ D57F= 60          `
 
.LD580
JSR LD58D        :\ D580= 20 8D D5     .U
INY              :\ D583= C8          H
INY              :\ D584= C8          H
INX              :\ D585= E8          h
INX              :\ D586= E8          h
INC A            :\ D587= 1A          .
INC A            :\ D588= 1A          .
INC &DA          :\ D589= E6 DA       fZ
INC &DA          :\ D58B= E6 DA       fZ
.LD58D
PHX              :\ D58D= DA          Z
PHY              :\ D58E= 5A          Z
PHA              :\ D58F= 48          H
CLC              :\ D590= 18          .
LDA &0300,X      :\ D591= BD 00 03    =..
ADC &0300,Y      :\ D594= 79 00 03    y..
STA &DE          :\ D597= 85 DE       .^
LDA &0301,X      :\ D599= BD 01 03    =..
ADC &0301,Y      :\ D59C= 79 01 03    y..
PLX              :\ D59F= FA          z
PHA              :\ D5A0= 48          H
LDY &DA          :\ D5A1= A4 DA       $Z
SEC              :\ D5A3= 38          8
LDA &DE          :\ D5A4= A5 DE       %^
SBC &0300,X      :\ D5A6= FD 00 03    }..
STA &0300,Y      :\ D5A9= 99 00 03    ...
PLA              :\ D5AC= 68          h
SBC &0301,X      :\ D5AD= FD 01 03    }..
STA &0301,Y      :\ D5B0= 99 01 03    ...
TXA              :\ D5B3= 8A          .
PLY              :\ D5B4= 7A          z
PLX              :\ D5B5= FA          z
RTS              :\ D5B6= 60          `
 
.LD5B7
SEC              :\ D5B7= 38          8
LDA &0302,Y      :\ D5B8= B9 02 03    9..
SBC &0302,X      :\ D5BB= FD 02 03    }..
STA &DE          :\ D5BE= 85 DE       .^
LDA &0303,Y      :\ D5C0= B9 03 03    9..
SBC &0303,X      :\ D5C3= FD 03 03    }..
BMI LD5D1        :\ D5C6= 30 09       0.
ORA &DE          :\ D5C8= 05 DE       .^
BNE LD5D5        :\ D5CA= D0 09       P.
.LD5CC
JSR LD5D6        :\ D5CC= 20 D6 D5     VU
BPL LD5D5        :\ D5CF= 10 04       ..
.LD5D1
TXA              :\ D5D1= 8A          .
PHY              :\ D5D2= 5A          Z
PLX              :\ D5D3= FA          z
TAY              :\ D5D4= A8          (
.LD5D5
RTS              :\ D5D5= 60          `
 
.LD5D6
LDA &0300,Y      :\ D5D6= B9 00 03    9..
CMP &0300,X      :\ D5D9= DD 00 03    ]..
LDA &0301,Y      :\ D5DC= B9 01 03    9..
SBC &0301,X      :\ D5DF= FD 01 03    }..
RTS              :\ D5E2= 60          `
 
.LD5E3
INC L8847        :\ D5E3= EE 47 88    nG.
.LD5E6
LDA L8847        :\ D5E6= AD 47 88    -G.
BNE LD5FA        :\ D5E9= D0 0F       P.
LDA L8832        :\ D5EB= AD 32 88    -2.
ORA L8833        :\ D5EE= 0D 33 88    .3.
BEQ LD5E3        :\ D5F1= F0 F0       pp
LDX #&00         :\ D5F3= A2 00       ".
JSR LD644        :\ D5F5= 20 44 D6     DV
BPL LD643        :\ D5F8= 10 49       .I
.LD5FA
LDX #&02         :\ D5FA= A2 02       ".
JSR LD644        :\ D5FC= 20 44 D6     DV
BPL LD643        :\ D5FF= 10 42       .B
LDX #&00         :\ D601= A2 00       ".
JSR LD60A        :\ D603= 20 0A D6     .V
BPL LD643        :\ D606= 10 3B       .;
LDX #&02         :\ D608= A2 02       ".
.LD60A
LDA L8830,X      :\ D60A= BD 30 88    =0.
BNE LD612        :\ D60D= D0 03       P.
DEC L8831,X      :\ D60F= DE 31 88    ^1.
.LD612
DEC L8830,X      :\ D612= DE 30 88    ^0.
TXA              :\ D615= 8A          .
LSR A            :\ D616= 4A          J
INC A            :\ D617= 1A          .
BIT L8846        :\ D618= 2C 46 88    ,F.
BEQ LD620        :\ D61B= F0 03       p.
JSR LD620        :\ D61D= 20 20 D6      V
.LD620
JSR LD636        :\ D620= 20 36 D6     6V
CLC              :\ D623= 18          .
LDA L8840        :\ D624= AD 40 88    -@.
ADC L8834,X      :\ D627= 7D 34 88    }4.
STA L8840        :\ D62A= 8D 40 88    .@.
LDA L8841        :\ D62D= AD 41 88    -A.
ADC L8835,X      :\ D630= 7D 35 88    }5.
STA L8841        :\ D633= 8D 41 88    .A.
.LD636
PHP              :\ D636= 08          .
LDA L8834,X      :\ D637= BD 34 88    =4.
BNE LD63F        :\ D63A= D0 03       P.
DEC L8835,X      :\ D63C= DE 35 88    ^5.
.LD63F
DEC L8834,X      :\ D63F= DE 34 88    ^4.
PLP              :\ D642= 28          (
.LD643
RTS              :\ D643= 60          `
 
.LD644
INC L8830,X      :\ D644= FE 30 88    ~0.
BNE LD64C        :\ D647= D0 03       P.
INC L8831,X      :\ D649= FE 31 88    ~1.
.LD64C
TXA              :\ D64C= 8A          .
LSR A            :\ D64D= 4A          J
INC A            :\ D64E= 1A          .
BIT L8846        :\ D64F= 2C 46 88    ,F.
BEQ LD657        :\ D652= F0 03       p.
JSR LD657        :\ D654= 20 57 D6     WV
.LD657
JSR LD66D        :\ D657= 20 6D D6     mV
SEC              :\ D65A= 38          8
LDA L8840        :\ D65B= AD 40 88    -@.
SBC L8834,X      :\ D65E= FD 34 88    }4.
STA L8840        :\ D661= 8D 40 88    .@.
LDA L8841        :\ D664= AD 41 88    -A.
SBC L8835,X      :\ D667= FD 35 88    }5.
STA L8841        :\ D66A= 8D 41 88    .A.
.LD66D
PHP              :\ D66D= 08          .
INC L8834,X      :\ D66E= FE 34 88    ~4.
BNE LD676        :\ D671= D0 03       P.
INC L8835,X      :\ D673= FE 35 88    ~5.
.LD676
PLP              :\ D676= 28          (
RTS              :\ D677= 60          `
 
PHA              :\ D678= 48          H
SEC              :\ D679= 38          8
LDA &0300,Y      :\ D67A= B9 00 03    9..
SBC &0300,X      :\ D67D= FD 00 03    }..
PHA              :\ D680= 48          H
LDA &0301,Y      :\ D681= B9 01 03    9..
SBC &0301,X      :\ D684= FD 01 03    }..
PLY              :\ D687= 7A          z
CMP #&80         :\ D688= C9 80       I.
BCC LD68F        :\ D68A= 90 03       ..
JSR LC92E        :\ D68C= 20 2E C9     .I
.LD68F
PLX              :\ D68F= FA          z
STA &0301,X      :\ D690= 9D 01 03    ...
TYA              :\ D693= 98          .
STA &0300,X      :\ D694= 9D 00 03    ...
RTS              :\ D697= 60          `
 
.LD698
LDX #&37         :\ D698= A2 37       "7
JSR LD723        :\ D69A= 20 23 D7     #W
.LD69D
BIT &030A,X      :\ D69D= 3C 0A 03    <..
BVS LD6B2        :\ D6A0= 70 10       p.
RTS              :\ D6A2= 60          `
 
.LD6A3
LDX #&2C         :\ D6A3= A2 2C       ",
JSR LD723        :\ D6A5= 20 23 D7     #W
.LD6A8
BIT &030A,X      :\ D6A8= 3C 0A 03    <..
BVC LD6B2        :\ D6AB= 50 05       P.
RTS              :\ D6AD= 60          `
 
.LD6AE
PLX              :\ D6AE= FA          z
JSR LD726        :\ D6AF= 20 26 D7     &W
.LD6B2
LDA &0309,X      :\ D6B2= BD 09 03    =..
BMI LD6C7        :\ D6B5= 30 10       0.
LDY #&03         :\ D6B7= A0 03        .
PHX              :\ D6B9= DA          Z
.LD6BA
LDA &0300,X      :\ D6BA= BD 00 03    =..
CMP L881E,X      :\ D6BD= DD 1E 88    ]..
BNE LD6AE        :\ D6C0= D0 EC       Pl
INX              :\ D6C2= E8          h
DEY              :\ D6C3= 88          .
BPL LD6BA        :\ D6C4= 10 F4       .t
PLX              :\ D6C6= FA          z
.LD6C7
RTS              :\ D6C7= 60          `
 
.LD6C8
JSR LD6FD        :\ D6C8= 20 FD D6     }V
LDA &030A,X      :\ D6CB= BD 0A 03    =..
ASL A            :\ D6CE= 0A          .
ASL A            :\ D6CF= 0A          .
LDA &030A,X      :\ D6D0= BD 0A 03    =..
ROR A            :\ D6D3= 6A          j
STA &DA          :\ D6D4= 85 DA       .Z
CLC              :\ D6D6= 18          .
BPL LD6E8        :\ D6D7= 10 0F       ..
LDA &0302,X      :\ D6D9= BD 02 03    =..
SBC &0304        :\ D6DC= ED 04 03    m..
TAY              :\ D6DF= A8          (
LDA &0303,X      :\ D6E0= BD 03 03    =..
SBC &0305        :\ D6E3= ED 05 03    m..
BRA LD6F5        :\ D6E6= 80 0D       ..
 
.LD6E8
LDA &0300        :\ D6E8= AD 00 03    -..
SBC &0302,X      :\ D6EB= FD 02 03    }..
TAY              :\ D6EE= A8          (
LDA &0301        :\ D6EF= AD 01 03    -..
SBC &0303,X      :\ D6F2= FD 03 03    }..
.LD6F5
JSR LD7A4        :\ D6F5= 20 A4 D7     $W
JSR LD6FD        :\ D6F8= 20 FD D6     }V
BRA LD755        :\ D6FB= 80 58       .X
 
.LD6FD
TXA              :\ D6FD= 8A          .
INC A            :\ D6FE= 1A          .
PHA              :\ D6FF= 48          H
INC A            :\ D700= 1A          .
TAY              :\ D701= A8          (
JSR LE2B2        :\ D702= 20 B2 E2     2b
INX              :\ D705= E8          h
INX              :\ D706= E8          h
INY              :\ D707= C8          H
INY              :\ D708= C8          H
JSR LE2B2        :\ D709= 20 B2 E2     2b
PLX              :\ D70C= FA          z
JSR LD711        :\ D70D= 20 11 D7     .W
DEX              :\ D710= CA          J
.LD711
LDA &0308,X      :\ D711= BD 08 03    =..
EOR #&FF         :\ D714= 49 FF       I.
STA &0308,X      :\ D716= 9D 08 03    ...
RTS              :\ D719= 60          `
 
.LD71A
JSR LD726        :\ D71A= 20 26 D7     &W
.LD71D
LDA &0309,X      :\ D71D= BD 09 03    =..
BPL LD71A        :\ D720= 10 F8       .x
RTS              :\ D722= 60          `
 
.LD723
JSR LD71D        :\ D723= 20 1D D7     .W
.LD726
LDA &0309,X      :\ D726= BD 09 03    =..
BPL LD755        :\ D729= 10 2A       .*
.LD72B
CLC              :\ D72B= 18          .
LDA &0308,X      :\ D72C= BD 08 03    =..
ADC &0304,X      :\ D72F= 7D 04 03    }..
STA &0308,X      :\ D732= 9D 08 03    ...
LDA &0309,X      :\ D735= BD 09 03    =..
ADC &0305,X      :\ D738= 7D 05 03    }..
STA &0309,X      :\ D73B= 9D 09 03    ...
BMI LD743        :\ D73E= 30 03       0.
JSR LD755        :\ D740= 20 55 D7     UW
.LD743
PHX              :\ D743= DA          Z
INX              :\ D744= E8          h
INX              :\ D745= E8          h
BIT &0308,X      :\ D746= 3C 08 03    <..
BMI LD76E        :\ D749= 30 23       0#
.LD74B
INC &0300,X      :\ D74B= FE 00 03    ~..
BNE LD753        :\ D74E= D0 03       P.
INC &0301,X      :\ D750= FE 01 03    ~..
.LD753
PLX              :\ D753= FA          z
RTS              :\ D754= 60          `
 
.LD755
SEC              :\ D755= 38          8
LDA &0308,X      :\ D756= BD 08 03    =..
SBC &0306,X      :\ D759= FD 06 03    }..
STA &0308,X      :\ D75C= 9D 08 03    ...
LDA &0309,X      :\ D75F= BD 09 03    =..
SBC &0307,X      :\ D762= FD 07 03    }..
STA &0309,X      :\ D765= 9D 09 03    ...
PHX              :\ D768= DA          Z
BIT &030A,X      :\ D769= 3C 0A 03    <..
BVC LD74B        :\ D76C= 50 DD       P]
.LD76E
LDA &0300,X      :\ D76E= BD 00 03    =..
BNE LD776        :\ D771= D0 03       P.
DEC &0301,X      :\ D773= DE 01 03    ^..
.LD776
DEC &0300,X      :\ D776= DE 00 03    ^..
PLX              :\ D779= FA          z
RTS              :\ D77A= 60          `
 
.LD77B
CLC              :\ D77B= 18          .
LDA &030A,X      :\ D77C= BD 0A 03    =..
STA &DA          :\ D77F= 85 DA       .Z
BPL LD792        :\ D781= 10 0F       ..
LDA &0302,X      :\ D783= BD 02 03    =..
SBC &0306        :\ D786= ED 06 03    m..
TAY              :\ D789= A8          (
LDA &0303,X      :\ D78A= BD 03 03    =..
SBC &0307        :\ D78D= ED 07 03    m..
BRA LD79F        :\ D790= 80 0D       ..
 
.LD792
LDA &0302        :\ D792= AD 02 03    -..
SBC &0302,X      :\ D795= FD 02 03    }..
TAY              :\ D798= A8          (
LDA &0303        :\ D799= AD 03 03    -..
SBC &0303,X      :\ D79C= FD 03 03    }..
.LD79F
JSR LD7A4        :\ D79F= 20 A4 D7     $W
BRA LD72B        :\ D7A2= 80 87       ..
 
.LD7A4
STY &DE          :\ D7A4= 84 DE       .^
STA &DF          :\ D7A6= 85 DF       ._
LDA &0302,X      :\ D7A8= BD 02 03    =..
LDY &0303,X      :\ D7AB= BC 03 03    <..
ASL &DA          :\ D7AE= 06 DA       .Z
BCS LD7BC        :\ D7B0= B0 0A       0.
ADC &DE          :\ D7B2= 65 DE       e^
STA &0302,X      :\ D7B4= 9D 02 03    ...
TYA              :\ D7B7= 98          .
ADC &DF          :\ D7B8= 65 DF       e_
BRA LD7C4        :\ D7BA= 80 08       ..
 
.LD7BC
SBC &DE          :\ D7BC= E5 DE       e^
STA &0302,X      :\ D7BE= 9D 02 03    ...
TYA              :\ D7C1= 98          .
SBC &DF          :\ D7C2= E5 DF       e_
.LD7C4
STA &0303,X      :\ D7C4= 9D 03 03    ...
LDA #&00         :\ D7C7= A9 00       ).
BIT &0309,X      :\ D7C9= 3C 09 03    <..
BPL LD7CF        :\ D7CC= 10 01       ..
DEC A            :\ D7CE= 3A          :
.LD7CF
STA &DC          :\ D7CF= 85 DC       .\
LSR A            :\ D7D1= 4A          J
STA &DD          :\ D7D2= 85 DD       .]
LDY #&10         :\ D7D4= A0 10        .
.LD7D6
LDA &DD          :\ D7D6= A5 DD       %]
ASL A            :\ D7D8= 0A          .
ROL &0308,X      :\ D7D9= 3E 08 03    >..
ROL &0309,X      :\ D7DC= 3E 09 03    >..
ROL &DC          :\ D7DF= 26 DC       &\
ROL &DD          :\ D7E1= 26 DD       &]
ASL &DE          :\ D7E3= 06 DE       .^
ROL &DF          :\ D7E5= 26 DF       &_
BCC LD802        :\ D7E7= 90 19       ..
CLC              :\ D7E9= 18          .
LDA &DC          :\ D7EA= A5 DC       %\
ADC &0304,X      :\ D7EC= 7D 04 03    }..
STA &DC          :\ D7EF= 85 DC       .\
LDA &DD          :\ D7F1= A5 DD       %]
ADC &0305,X      :\ D7F3= 7D 05 03    }..
STA &DD          :\ D7F6= 85 DD       .]
BCC LD802        :\ D7F8= 90 08       ..
INC &0308,X      :\ D7FA= FE 08 03    ~..
BNE LD802        :\ D7FD= D0 03       P.
INC &0309,X      :\ D7FF= FE 09 03    ~..
.LD802
DEY              :\ D802= 88          .
BNE LD7D6        :\ D803= D0 D1       PQ
BIT &0309,X      :\ D805= 3C 09 03    <..
BVC LD815        :\ D808= 50 0B       P.
LDA &DC          :\ D80A= A5 DC       %\
STA &0308,X      :\ D80C= 9D 08 03    ...
LDA &DD          :\ D80F= A5 DD       %]
STA &0309,X      :\ D811= 9D 09 03    ...
RTS              :\ D814= 60          `
 
.LD815
LDY #&10         :\ D815= A0 10        .
.LD817
ROL &DC          :\ D817= 26 DC       &\
ROL &DD          :\ D819= 26 DD       &]
ROL &0308,X      :\ D81B= 3E 08 03    >..
ROL &0309,X      :\ D81E= 3E 09 03    >..
SEC              :\ D821= 38          8
LDA &0308,X      :\ D822= BD 08 03    =..
SBC &0306,X      :\ D825= FD 06 03    }..
STA &DE          :\ D828= 85 DE       .^
LDA &0309,X      :\ D82A= BD 09 03    =..
SBC &0307,X      :\ D82D= FD 07 03    }..
BCC LD83A        :\ D830= 90 08       ..
STA &0309,X      :\ D832= 9D 09 03    ...
LDA &DE          :\ D835= A5 DE       %^
STA &0308,X      :\ D837= 9D 08 03    ...
.LD83A
DEY              :\ D83A= 88          .
BNE LD817        :\ D83B= D0 DA       PZ
ROL &DC          :\ D83D= 26 DC       &\
ROL &DD          :\ D83F= 26 DD       &]
SEC              :\ D841= 38          8
LDA &0308,X      :\ D842= BD 08 03    =..
SBC &0306,X      :\ D845= FD 06 03    }..
STA &0308,X      :\ D848= 9D 08 03    ...
LDA &0309,X      :\ D84B= BD 09 03    =..
SBC &0307,X      :\ D84E= FD 07 03    }..
STA &0309,X      :\ D851= 9D 09 03    ...
LDA &0300,X      :\ D854= BD 00 03    =..
LDY &0301,X      :\ D857= BC 01 03    <..
ASL &DA          :\ D85A= 06 DA       .Z
BCS LD869        :\ D85C= B0 0B       0.
SEC              :\ D85E= 38          8
ADC &DC          :\ D85F= 65 DC       e\
STA &0300,X      :\ D861= 9D 00 03    ...
TYA              :\ D864= 98          .
ADC &DD          :\ D865= 65 DD       e]
BRA LD872        :\ D867= 80 09       ..
 
.LD869
CLC              :\ D869= 18          .
SBC &DC          :\ D86A= E5 DC       e\
STA &0300,X      :\ D86C= 9D 00 03    ...
TYA              :\ D86F= 98          .
SBC &DD          :\ D870= E5 DD       e]
.LD872
STA &0301,X      :\ D872= 9D 01 03    ...
.LD875
RTS              :\ D875= 60          `
 
.LD876
ASL &0332        :\ D876= 0E 32 03    .2.
LDY #&2C         :\ D879= A0 2C        ,
JSR LC916        :\ D87B= 20 16 C9     .I
ASL &DB          :\ D87E= 06 DB       .[
BCC LD88F        :\ D880= 90 0D       ..
JSR LDA26        :\ D882= 20 26 DA     &Z
BEQ LD875        :\ D885= F0 EE       pn
LDX #&00         :\ D887= A2 00       ".
LDA &0332        :\ D889= AD 32 03    -2.
JSR LDA0F        :\ D88C= 20 0F DA     .Z
.LD88F
BIT &DB          :\ D88F= 24 DB       $[
BVC LD8A2        :\ D891= 50 0F       P.
JSR LDA26        :\ D893= 20 26 DA     &Z
BEQ LD875        :\ D896= F0 DD       p]
LDX #&04         :\ D898= A2 04       ".
LDA &0332        :\ D89A= AD 32 03    -2.
EOR #&80         :\ D89D= 49 80       I.
JSR LDA0F        :\ D89F= 20 0F DA     .Z
.LD8A2
LDX #&28         :\ D8A2= A2 28       "(
LDY #&2C         :\ D8A4= A0 2C        ,
JMP LDAE8        :\ D8A6= 4C E8 DA    LhZ
 
.LD8A9
ASL A            :\ D8A9= 0A          .
ASL A            :\ D8AA= 0A          .
STA &DB          :\ D8AB= 85 DB       .[
AND #&C0         :\ D8AD= 29 C0       )@
EOR #&40         :\ D8AF= 49 40       I@
BNE LD8B9        :\ D8B1= D0 06       P.
LDA &0367        :\ D8B3= AD 67 03    -g.
STA &0368        :\ D8B6= 8D 68 03    .h.
.LD8B9
JSR LD1A6        :\ D8B9= 20 A6 D1     &Q
STA &DC          :\ D8BC= 85 DC       .\
BEQ LD8C4        :\ D8BE= F0 04       p.
LDA #&80         :\ D8C0= A9 80       ).
TRB &DB          :\ D8C2= 14 DB       .[
.LD8C4
LDX #&20         :\ D8C4= A2 20       " 
JSR LD1A8        :\ D8C6= 20 A8 D1     (Q
STA &E0          :\ D8C9= 85 E0       .`
BEQ LD8D7        :\ D8CB= F0 0A       p.
TAX              :\ D8CD= AA          *
LDA #&20         :\ D8CE= A9 20       ) 
TRB &DB          :\ D8D0= 14 DB       .[
TXA              :\ D8D2= 8A          .
BIT &DC          :\ D8D3= 24 DC       $\
.LD8D5
BNE LD875        :\ D8D5= D0 9E       P.
.LD8D7
LDY #&24         :\ D8D7= A0 24        $
LDA #&20         :\ D8D9= A9 20       ) 
LDX #&28         :\ D8DB= A2 28       "(
JSR L9B09        :\ D8DD= 20 09 9B     ..
BIT &DB          :\ D8E0= 24 DB       $[
BVS LD8EC        :\ D8E2= 70 08       p.
LDA &032E        :\ D8E4= AD 2E 03    -..
ORA &032F        :\ D8E7= 0D 2F 03    ./.
BEQ LD876        :\ D8EA= F0 8A       p.
.LD8EC
LDA &DC          :\ D8EC= A5 DC       %\
BIT #&0C         :\ D8EE= 89 0C       ..
BEQ LD900        :\ D8F0= F0 0E       p.
LDX #&28         :\ D8F2= A2 28       "(
JSR LD77B        :\ D8F4= 20 7B D7     {W
LDX #&28         :\ D8F7= A2 28       "(
JSR LD1A8        :\ D8F9= 20 A8 D1     (Q
BIT &E0          :\ D8FC= 24 E0       $`
BNE LD8D5        :\ D8FE= D0 D5       PU
.LD900
BIT #&03         :\ D900= 89 03       ..
BEQ LD90E        :\ D902= F0 0A       p.
LDX #&28         :\ D904= A2 28       "(
JSR LD6C8        :\ D906= 20 C8 D6     HV
LDX #&28         :\ D909= A2 28       "(
JSR LD1A8        :\ D90B= 20 A8 D1     (Q
.LD90E
TAY              :\ D90E= A8          (
BNE LD8D5        :\ D90F= D0 C4       PD
LDY #&20         :\ D911= A0 20         
LDX #&22         :\ D913= A2 22       ""
LDA &E0          :\ D915= A5 E0       %`
BEQ LD928        :\ D917= F0 0F       p.
LDY #&04         :\ D919= A0 04        .
LDX #&06         :\ D91B= A2 06       ".
BIT &0332        :\ D91D= 2C 32 03    ,2.
BPL LD924        :\ D920= 10 02       ..
LDX #&02         :\ D922= A2 02       ".
.LD924
BVC LD928        :\ D924= 50 02       P.
LDY #&00         :\ D926= A0 00        .
.LD928
CLC              :\ D928= 18          .
LDA &0300,X      :\ D929= BD 00 03    =..
SBC &032A        :\ D92C= ED 2A 03    m*.
BCC LD934        :\ D92F= 90 03       ..
INC A            :\ D931= 1A          .
EOR #&FF         :\ D932= 49 FF       I.
.LD934
STA &DC          :\ D934= 85 DC       .\
CLC              :\ D936= 18          .
LDA &0300,Y      :\ D937= B9 00 03    9..
SBC &0328        :\ D93A= ED 28 03    m(.
TAX              :\ D93D= AA          *
LDA &0301,Y      :\ D93E= B9 01 03    9..
SBC &0329        :\ D941= ED 29 03    m).
BMI LD952        :\ D944= 30 0C       0.
INX              :\ D946= E8          h
BNE LD94A        :\ D947= D0 01       P.
INC A            :\ D949= 1A          .
.LD94A
EOR #&FF         :\ D94A= 49 FF       I.
TAY              :\ D94C= A8          (
TXA              :\ D94D= 8A          .
EOR #&FF         :\ D94E= 49 FF       I.
TAX              :\ D950= AA          *
TYA              :\ D951= 98          .
.LD952
STA &DD          :\ D952= 85 DD       .]
STX &E0          :\ D954= 86 E0       .`
LDX #&28         :\ D956= A2 28       "(
JSR LDF41        :\ D958= 20 41 DF     A_
ASL &DB          :\ D95B= 06 DB       .[
BCS LD989        :\ D95D= B0 2A       0*
.LD95F
BIT &DB          :\ D95F= 24 DB       $[
BVC LD96E        :\ D961= 50 0B       P.
LDA &E0          :\ D963= A5 E0       %`
AND &DC          :\ D965= 25 DC       %\
AND &DD          :\ D967= 25 DD       %]
INC A            :\ D969= 1A          .
BEQ LD9A0        :\ D96A= F0 34       p4
BIT &DB          :\ D96C= 24 DB       $[
.LD96E
BPL LD979        :\ D96E= 10 09       ..
LDA &0368        :\ D970= AD 68 03    -h.
ASL A            :\ D973= 0A          .
ROL &0368        :\ D974= 2E 68 03    .h.
BCC LD989        :\ D977= 90 10       ..
.LD979
LDA &D1          :\ D979= A5 D1       %Q
AND &D4          :\ D97B= 25 D4       %T
ORA (&D6),Y      :\ D97D= 11 D6       .V
STA &DA          :\ D97F= 85 DA       .Z
LDA &D1          :\ D981= A5 D1       %Q
AND &D5          :\ D983= 25 D5       %U
EOR &DA          :\ D985= 45 DA       EZ
STA (&D6),Y      :\ D987= 91 D6       .V
.LD989
LDA &0331        :\ D989= AD 31 03    -1.
BPL LD9DC        :\ D98C= 10 4E       .N
INC &DC          :\ D98E= E6 DC       f\
BEQ LD9A0        :\ D990= F0 0E       p.
BIT &0332        :\ D992= 2C 32 03    ,2.
BMI LD9A1        :\ D995= 30 0A       0.
DEY              :\ D997= 88          .
DEX              :\ D998= CA          J
BPL LD9BF        :\ D999= 10 24       .$
JSR LDA4C        :\ D99B= 20 4C DA     LZ
BRA LD9BF        :\ D99E= 80 1F       ..
 
.LD9A0
RTS              :\ D9A0= 60          `
 
.LD9A1
INY              :\ D9A1= C8          H
INX              :\ D9A2= E8          h
CPX #&08         :\ D9A3= E0 08       `.
BNE LD9BF        :\ D9A5= D0 18       P.
SEC              :\ D9A7= 38          8
TYA              :\ D9A8= 98          .
SBC #&08         :\ D9A9= E9 08       i.
CLC              :\ D9AB= 18          .
ADC &0352        :\ D9AC= 6D 52 03    mR.
TAY              :\ D9AF= A8          (
LDA &D7          :\ D9B0= A5 D7       %W
ADC &0353        :\ D9B2= 6D 53 03    mS.
BPL LD9BB        :\ D9B5= 10 04       ..
SEC              :\ D9B7= 38          8
SBC &0354        :\ D9B8= ED 54 03    mT.
.LD9BB
STA &D7          :\ D9BB= 85 D7       .W
LDX #&00         :\ D9BD= A2 00       ".
.LD9BF
LDA &0369        :\ D9BF= AD 69 03    -i.
BEQ LD9C7        :\ D9C2= F0 03       p.
JSR LDA7C        :\ D9C4= 20 7C DA     |Z
.LD9C7
CLC              :\ D9C7= 18          .
LDA &0330        :\ D9C8= AD 30 03    -0.
ADC &032C        :\ D9CB= 6D 2C 03    m,.
STA &0330        :\ D9CE= 8D 30 03    .0.
LDA &0331        :\ D9D1= AD 31 03    -1.
ADC &032D        :\ D9D4= 6D 2D 03    m-.
STA &0331        :\ D9D7= 8D 31 03    .1.
BMI LD95F        :\ D9DA= 30 83       0.
.LD9DC
INC &E0          :\ D9DC= E6 E0       f`
BNE LD9E4        :\ D9DE= D0 04       P.
INC &DD          :\ D9E0= E6 DD       f]
BEQ LD9A0        :\ D9E2= F0 BC       p<
.LD9E4
BIT &0332        :\ D9E4= 2C 32 03    ,2.
BVS LD9F2        :\ D9E7= 70 09       p.
LSR &D1          :\ D9E9= 46 D1       FQ
BCC LD9F9        :\ D9EB= 90 0C       ..
JSR LDA67        :\ D9ED= 20 67 DA     gZ
BRA LD9F9        :\ D9F0= 80 07       ..
 
.LD9F2
ASL &D1          :\ D9F2= 06 D1       .Q
BCC LD9F9        :\ D9F4= 90 03       ..
JSR LDA34        :\ D9F6= 20 34 DA     4Z
.LD9F9
SEC              :\ D9F9= 38          8
LDA &0330        :\ D9FA= AD 30 03    -0.
SBC &032E        :\ D9FD= ED 2E 03    m..
STA &0330        :\ DA00= 8D 30 03    .0.
LDA &0331        :\ DA03= AD 31 03    -1.
SBC &032F        :\ DA06= ED 2F 03    m/.
STA &0331        :\ DA09= 8D 31 03    .1.
JMP LD95F        :\ DA0C= 4C 5F D9    L_Y
 
.LDA0F
BMI LDA1A        :\ DA0F= 30 09       0.
INC &0328,X      :\ DA11= FE 28 03    ~(.
BNE LDA25        :\ DA14= D0 0F       P.
INC &0329,X      :\ DA16= FE 29 03    ~).
RTS              :\ DA19= 60          `
 
.LDA1A
LDA &0328,X      :\ DA1A= BD 28 03    =(.
BNE LDA22        :\ DA1D= D0 03       P.
DEC &0329,X      :\ DA1F= DE 29 03    ^).
.LDA22
DEC &0328,X      :\ DA22= DE 28 03    ^(.
.LDA25
RTS              :\ DA25= 60          `
 
.LDA26
LDY #&04         :\ DA26= A0 04        .
.LDA28
LDA &0327,Y      :\ DA28= B9 27 03    9'.
CMP &032B,Y      :\ DA2B= D9 2B 03    Y+.
BNE LDA33        :\ DA2E= D0 03       P.
DEY              :\ DA30= 88          .
BNE LDA28        :\ DA31= D0 F5       Pu
.LDA33
RTS              :\ DA33= 60          `
 
.LDA34
LDA &0363        :\ DA34= AD 63 03    -c.
STA &D1          :\ DA37= 85 D1       .Q
TYA              :\ DA39= 98          .
SBC #&08         :\ DA3A= E9 08       i.
TAY              :\ DA3C= A8          (
BCS LDA4B        :\ DA3D= B0 0C       0.
LDA &D7          :\ DA3F= A5 D7       %W
DEC A            :\ DA41= 3A          :
CMP &034E        :\ DA42= CD 4E 03    MN.
BCS LDA49        :\ DA45= B0 02       0.
LDA #&7F         :\ DA47= A9 7F       ).
.LDA49
STA &D7          :\ DA49= 85 D7       .W
.LDA4B
RTS              :\ DA4B= 60          `
 
.LDA4C
CLC              :\ DA4C= 18          .
TYA              :\ DA4D= 98          .
ADC #&08         :\ DA4E= 69 08       i.
SEC              :\ DA50= 38          8
SBC &0352        :\ DA51= ED 52 03    mR.
TAY              :\ DA54= A8          (
LDA &D7          :\ DA55= A5 D7       %W
SBC &0353        :\ DA57= ED 53 03    mS.
CMP &034E        :\ DA5A= CD 4E 03    MN.
BCS LDA62        :\ DA5D= B0 03       0.
ADC &0354        :\ DA5F= 6D 54 03    mT.
.LDA62
STA &D7          :\ DA62= 85 D7       .W
LDX #&07         :\ DA64= A2 07       ".
RTS              :\ DA66= 60          `
 
.LDA67
LDA &0362        :\ DA67= AD 62 03    -b.
STA &D1          :\ DA6A= 85 D1       .Q
.LDA6C
TYA              :\ DA6C= 98          .
ADC #&07         :\ DA6D= 69 07       i.
TAY              :\ DA6F= A8          (
BCC LDA7B        :\ DA70= 90 09       ..
INC &D7          :\ DA72= E6 D7       fW
BPL LDA7B        :\ DA74= 10 05       ..
LDA &034E        :\ DA76= AD 4E 03    -N.
STA &D7          :\ DA79= 85 D7       .W
.LDA7B
RTS              :\ DA7B= 60          `
 
.LDA7C
PHX              :\ DA7C= DA          Z
TXA              :\ DA7D= 8A          .
ORA &0359        :\ DA7E= 0D 59 03    .Y.
TAX              :\ DA81= AA          *
LDA L8820,X      :\ DA82= BD 20 88    = .
LDX &035A        :\ DA85= AE 5A 03    .Z.
PHA              :\ DA88= 48          H
ORA LE144,X      :\ DA89= 1D 44 E1    .Da
EOR LE145,X      :\ DA8C= 5D 45 E1    ]Ea
STA &D4          :\ DA8F= 85 D4       .T
PLA              :\ DA91= 68          h
ORA LE143,X      :\ DA92= 1D 43 E1    .Ca
EOR LE148,X      :\ DA95= 5D 48 E1    ]Ha
STA &D5          :\ DA98= 85 D5       .U
PLX              :\ DA9A= FA          z
RTS              :\ DA9B= 60          `
 
.LDA9C
LDA &0301,Y      :\ DA9C= B9 01 03    9..
PHA              :\ DA9F= 48          H
LDA &0300,Y      :\ DAA0= B9 00 03    9..
PHA              :\ DAA3= 48          H
AND &0361        :\ DAA4= 2D 61 03    -a.
CLC              :\ DAA7= 18          .
ADC &0361        :\ DAA8= 6D 61 03    ma.
TAY              :\ DAAB= A8          (
LDA LE12E,Y      :\ DAAC= B9 2E E1    9.a
EOR LE120,Y      :\ DAAF= 59 20 E1    Y a
STA &DC          :\ DAB2= 85 DC       .\
LDA &0300,X      :\ DAB4= BD 00 03    =..
AND &0361        :\ DAB7= 2D 61 03    -a.
ADC &0361        :\ DABA= 6D 61 03    ma.
TAY              :\ DABD= A8          (
LDA LE120,Y      :\ DABE= B9 20 E1    9 a
STA &D1          :\ DAC1= 85 D1       .Q
SEC              :\ DAC3= 38          8
PLA              :\ DAC4= 68          h
ORA &0361        :\ DAC5= 0D 61 03    .a.
SBC &0300,X      :\ DAC8= FD 00 03    }..
TAY              :\ DACB= A8          (
PLA              :\ DACC= 68          h
SBC &0301,X      :\ DACD= FD 01 03    }..
STA &DD          :\ DAD0= 85 DD       .]
TYA              :\ DAD2= 98          .
LDY &0361        :\ DAD3= AC 61 03    ,a.
CPY #&03         :\ DAD6= C0 03       @.
BEQ LDADF        :\ DAD8= F0 05       p.
BCC LDAE2        :\ DADA= 90 06       ..
LSR &DD          :\ DADC= 46 DD       F]
ROR A            :\ DADE= 6A          j
.LDADF
LSR &DD          :\ DADF= 46 DD       F]
ROR A            :\ DAE1= 6A          j
.LDAE2
LSR A            :\ DAE2= 4A          J
.LDAE3
RTS              :\ DAE3= 60          `
 
.LDAE4
LDX #&42         :\ DAE4= A2 42       "B
LDY #&46         :\ DAE6= A0 46        F
.LDAE8
JSR LD5CC        :\ DAE8= 20 CC D5     LU
STX &DE          :\ DAEB= 86 DE       .^
STY &DF          :\ DAED= 84 DF       ._
LDX &DF          :\ DAEF= A6 DF       &_
LDY #&00         :\ DAF1= A0 00        .
JSR LD1B7        :\ DAF3= 20 B7 D1     7Q
BEQ LDAFF        :\ DAF6= F0 07       p.
LSR A            :\ DAF8= 4A          J
BEQ LDAE3        :\ DAF9= F0 E8       ph
LDX #&04         :\ DAFB= A2 04       ".
STX &DF          :\ DAFD= 86 DF       ._
.LDAFF
LDX &DE          :\ DAFF= A6 DE       &^
JSR LD1A8        :\ DB01= 20 A8 D1     (Q
LSR A            :\ DB04= 4A          J
BNE LDAE3        :\ DB05= D0 DC       P\
LDA &0302,X      :\ DB07= BD 02 03    =..
BCC LDB10        :\ DB0A= 90 04       ..
LDX #&00         :\ DB0C= A2 00       ".
STX &DE          :\ DB0E= 86 DE       .^
.LDB10
JSR LDECB        :\ DB10= 20 CB DE     K^
LDX &DE          :\ DB13= A6 DE       &^
LDY &DF          :\ DB15= A4 DF       $_
JSR LDA9C        :\ DB17= 20 9C DA     .Z
TAX              :\ DB1A= AA          *
LDY &031A        :\ DB1B= AC 1A 03    ,..
TXA              :\ DB1E= 8A          .
BEQ LDB44        :\ DB1F= F0 23       p#
JSR LDB51        :\ DB21= 20 51 DB     Q[
BRA LDB2E        :\ DB24= 80 08       ..
 
.LDB26
LDA (&D6),Y      :\ DB26= B1 D6       1V
ORA &D4          :\ DB28= 05 D4       .T
EOR &D5          :\ DB2A= 45 D5       EU
STA (&D6),Y      :\ DB2C= 91 D6       .V
.LDB2E
TYA              :\ DB2E= 98          .
CLC              :\ DB2F= 18          .
ADC #&08         :\ DB30= 69 08       i.
TAY              :\ DB32= A8          (
BCC LDB3E        :\ DB33= 90 09       ..
INC &D7          :\ DB35= E6 D7       fW
BPL LDB3E        :\ DB37= 10 05       ..
LDA &034E        :\ DB39= AD 4E 03    -N.
STA &D7          :\ DB3C= 85 D7       .W
.LDB3E
DEX              :\ DB3E= CA          J
BNE LDB26        :\ DB3F= D0 E5       Pe
DEX              :\ DB41= CA          J
STX &D1          :\ DB42= 86 D1       .Q
.LDB44
LDA &DC          :\ DB44= A5 DC       %\
TRB &D1          :\ DB46= 14 D1       .Q
BRA LDB51        :\ DB48= 80 07       ..
 
LDX #&20         :\ DB4A= A2 20       " 
.LDB4C
JSR LDEC3        :\ DB4C= 20 C3 DE     C^
BNE LDB61        :\ DB4F= D0 10       P.
.LDB51
LDA &D1          :\ DB51= A5 D1       %Q
AND &D4          :\ DB53= 25 D4       %T
ORA (&D6),Y      :\ DB55= 11 D6       .V
STA &DA          :\ DB57= 85 DA       .Z
LDA &D5          :\ DB59= A5 D5       %U
AND &D1          :\ DB5B= 25 D1       %Q
EOR &DA          :\ DB5D= 45 DA       EZ
.LDB5F
STA (&D6),Y      :\ DB5F= 91 D6       .V
.LDB61
RTS              :\ DB61= 60          `
 
LDX #&2A         :\ DB62= A2 2A       "*
LDY #&32         :\ DB64= A0 32        2
JSR LC90C        :\ DB66= 20 0C C9     .I
LDX #&36         :\ DB69= A2 36       "6
LDY #&3E         :\ DB6B= A0 3E        >
JSR LC90C        :\ DB6D= 20 0C C9     .I
LDX #&2A         :\ DB70= A2 2A       "*
JSR LD1B5        :\ DB72= 20 B5 D1     5Q
PHA              :\ DB75= 48          H
LDX #&36         :\ DB76= A2 36       "6
JSR LD1B5        :\ DB78= 20 B5 D1     5Q
BEQ LDB8C        :\ DB7B= F0 0F       p.
PLA              :\ DB7D= 68          h
BNE LDB85        :\ DB7E= D0 05       P.
LDA &0345        :\ DB80= AD 45 03    -E.
BEQ LDB86        :\ DB83= F0 01       p.
.LDB85
RTS              :\ DB85= 60          `
 
.LDB86
LDX #&28         :\ DB86= A2 28       "(
LDY #&2C         :\ DB88= A0 2C        ,
BRA LDB93        :\ DB8A= 80 07       ..
 
.LDB8C
PLA              :\ DB8C= 68          h
BEQ LDB96        :\ DB8D= F0 07       p.
LDX #&34         :\ DB8F= A2 34       "4
LDY #&38         :\ DB91= A0 38        8
.LDB93
JMP LDAE8        :\ DB93= 4C E8 DA    LhZ
 
.LDB96
LDX #&30         :\ DB96= A2 30       "0
JSR LDEC8        :\ DB98= 20 C8 DE     H^
BIT &0347        :\ DB9B= 2C 47 03    ,G.
BMI LDBA9        :\ DB9E= 30 09       0.
TYA              :\ DBA0= 98          .
SEC              :\ DBA1= 38          8
SBC #&08         :\ DBA2= E9 08       i.
TAY              :\ DBA4= A8          (
BCS LDBA9        :\ DBA5= B0 02       0.
DEC &D7          :\ DBA7= C6 D7       FW
.LDBA9
LDA &0344        :\ DBA9= AD 44 03    -D.
STA &DD          :\ DBAC= 85 DD       .]
.LDBAE
LDA (&D6),Y      :\ DBAE= B1 D6       1V
LDX &0342        :\ DBB0= AE 42 03    .B.
BEQ LDBB9        :\ DBB3= F0 04       p.
.LDBB5
ASL A            :\ DBB5= 0A          .
DEX              :\ DBB6= CA          J
BNE LDBB5        :\ DBB7= D0 FC       P|
.LDBB9
STA &DA          :\ DBB9= 85 DA       .Z
SEC              :\ DBBB= 38          8
JSR LDA6C        :\ DBBC= 20 6C DA     lZ
LDA (&D6),Y      :\ DBBF= B1 D6       1V
LDX &0343        :\ DBC1= AE 43 03    .C.
BEQ LDBCA        :\ DBC4= F0 04       p.
.LDBC6
LSR A            :\ DBC6= 4A          J
DEX              :\ DBC7= CA          J
BNE LDBC6        :\ DBC8= D0 FC       P|
.LDBCA
EOR &DA          :\ DBCA= 45 DA       EZ
AND &E1          :\ DBCC= 25 E1       %a
EOR &DA          :\ DBCE= 45 DA       EZ
LDX &DD          :\ DBD0= A6 DD       &]
STA L8830,X      :\ DBD2= 9D 30 88    .0.
DEC &DD          :\ DBD5= C6 DD       F]
BPL LDBAE        :\ DBD7= 10 D5       .U
LDX #&34         :\ DBD9= A2 34       "4
LDY #&38         :\ DBDB= A0 38        8
JSR LDAE8        :\ DBDD= 20 E8 DA     hZ
LDA &0345        :\ DBE0= AD 45 03    -E.
BNE LDBE8        :\ DBE3= D0 03       P.
JSR LDB86        :\ DBE5= 20 86 DB     .[
.LDBE8
LDX #&3C         :\ DBE8= A2 3C       "<
JSR LDEC8        :\ DBEA= 20 C8 DE     H^
LDA &0346        :\ DBED= AD 46 03    -F.
STA &DA          :\ DBF0= 85 DA       .Z
LDX &0344        :\ DBF2= AE 44 03    .D.
BEQ LDC0C        :\ DBF5= F0 15       p.
JSR LDC10        :\ DBF7= 20 10 DC     .\
LDA #&FF         :\ DBFA= A9 FF       ).
STA &DA          :\ DBFC= 85 DA       .Z
BRA LDC05        :\ DBFE= 80 05       ..
 
.LDC00
LDA L8830,X      :\ DC00= BD 30 88    =0.
STA (&D6),Y      :\ DC03= 91 D6       .V
.LDC05
SEC              :\ DC05= 38          8
JSR LDA6C        :\ DC06= 20 6C DA     lZ
DEX              :\ DC09= CA          J
BNE LDC00        :\ DC0A= D0 F4       Pt
.LDC0C
LDA &E0          :\ DC0C= A5 E0       %`
TRB &DA          :\ DC0E= 14 DA       .Z
.LDC10
LDA L8830,X      :\ DC10= BD 30 88    =0.
EOR (&D6),Y      :\ DC13= 51 D6       QV
AND &DA          :\ DC15= 25 DA       %Z
EOR (&D6),Y      :\ DC17= 51 D6       QV
STA (&D6),Y      :\ DC19= 91 D6       .V
RTS              :\ DC1B= 60          `
 
.LDC1C
LDA &0337        :\ DC1C= AD 37 03    -7.
INC A            :\ DC1F= 1A          .
CMP &0336        :\ DC20= CD 36 03    M6.
BEQ LDC47        :\ DC23= F0 22       p"
STA &0337        :\ DC25= 8D 37 03    .7.
TAX              :\ DC28= AA          *
LDA &032E        :\ DC29= AD 2E 03    -..
STA L8400,X      :\ DC2C= 9D 00 84    ...
LDA &0332        :\ DC2F= AD 32 03    -2.
STA L8500,X      :\ DC32= 9D 00 85    ...
LDA &032F        :\ DC35= AD 2F 03    -/.
ASL A            :\ DC38= 0A          .
ASL A            :\ DC39= 0A          .
ORA &0333        :\ DC3A= 0D 33 03    .3.
STA L8600,X      :\ DC3D= 9D 00 86    ...
LDA &0330        :\ DC40= AD 30 03    -0.
STA L8700,X      :\ DC43= 9D 00 87    ...
.LDC46
CLC              :\ DC46= 18          .
.LDC47
RTS              :\ DC47= 60          `
 
.LDC48
STA &032A        :\ DC48= 8D 2A 03    .*.
LDX #&28         :\ DC4B= A2 28       "(
JSR LDCB0        :\ DC4D= 20 B0 DC     0\
BNE LDC5C        :\ DC50= D0 0A       P.
.LDC52
JSR LDC1C        :\ DC52= 20 1C DC     .\
BCS LDC47        :\ DC55= B0 F0       0p
JSR L9D57        :\ DC57= 20 57 9D     W.
BCS LDC46        :\ DC5A= B0 EA       0j
.LDC5C
JSR LDCC1        :\ DC5C= 20 C1 DC     A\
JSR L9D57        :\ DC5F= 20 57 9D     W.
BCS LDC46        :\ DC62= B0 E2       0b
JSR LDCD7        :\ DC64= 20 D7 DC     W\
JSR LDCB8        :\ DC67= 20 B8 DC     8\
BRA LDC52        :\ DC6A= 80 E6       .f
 
JSR LDD9F        :\ DC6C= 20 9F DD     .]
JSR LDCB0        :\ DC6F= 20 B0 DC     0\
CLC              :\ DC72= 18          .
BRA LDC83        :\ DC73= 80 0E       ..
 
JSR LDD9F        :\ DC75= 20 9F DD     .]
JSR LDCC9        :\ DC78= 20 C9 DC     I\
JSR LDCD2        :\ DC7B= 20 D2 DC     R\
BNE LDC83        :\ DC7E= D0 03       P.
JSR LDCB8        :\ DC80= 20 B8 DC     8\
.LDC83
PHP              :\ DC83= 08          .
LDX #&2E         :\ DC84= A2 2E       ".
LDY #&14         :\ DC86= A0 14        .
JSR LC91E        :\ DC88= 20 1E C9     .I
PLP              :\ DC8B= 28          (
PHP              :\ DC8C= 08          .
BEQ LDC91        :\ DC8D= F0 02       p.
LDX #&2E         :\ DC8F= A2 2E       ".
.LDC91
LDY #&24         :\ DC91= A0 24        $
JSR LC90C        :\ DC93= 20 0C C9     .I
LDX #&30         :\ DC96= A2 30       "0
JSR LC90C        :\ DC98= 20 0C C9     .I
PLP              :\ DC9B= 28          (
BEQ LDCA3        :\ DC9C= F0 05       p.
BCS LDCA4        :\ DC9E= B0 04       0.
INC &0316        :\ DCA0= EE 16 03    n..
.LDCA3
RTS              :\ DCA3= 60          `
 
.LDCA4
LDA &0324        :\ DCA4= AD 24 03    -$.
BNE LDCAC        :\ DCA7= D0 03       P.
DEC &0325        :\ DCA9= CE 25 03    N%.
.LDCAC
DEC &0324        :\ DCAC= CE 24 03    N$.
RTS              :\ DCAF= 60          `
 
.LDCB0
JSR LDCD2        :\ DCB0= 20 D2 DC     R\
BNE LDD0A        :\ DCB3= D0 55       PU
JSR LDD0B        :\ DCB5= 20 0B DD     .]
.LDCB8
LDX #&2E         :\ DCB8= A2 2E       ".
LDY #&32         :\ DCBA= A0 32        2
JSR LDAE8        :\ DCBC= 20 E8 DA     hZ
BRA LDD07        :\ DCBF= 80 46       .F
 
.LDCC1
JSR LDCC9        :\ DCC1= 20 C9 DC     I\
LDX #&2C         :\ DCC4= A2 2C       ",
JSR LDCD9        :\ DCC6= 20 D9 DC     Y\
.LDCC9
PHP              :\ DCC9= 08          .
LDA &E1          :\ DCCA= A5 E1       %a
EOR #&08         :\ DCCC= 49 08       I.
STA &E1          :\ DCCE= 85 E1       .a
PLP              :\ DCD0= 28          (
RTS              :\ DCD1= 60          `
 
.LDCD2
LDY #&2E         :\ DCD2= A0 2E        .
JSR LC91E        :\ DCD4= 20 1E C9     .I
.LDCD7
LDX #&04         :\ DCD7= A2 04       ".
.LDCD9
LDY #&34         :\ DCD9= A0 34        4
JSR LC90C        :\ DCDB= 20 0C C9     .I
LDX #&34         :\ DCDE= A2 34       "4
JSR LDD35        :\ DCE0= 20 35 DD     5]
BNE LDD0A        :\ DCE3= D0 25       P%
.LDCE5
LSR &D1          :\ DCE5= 46 D1       FQ
BCC LDCF1        :\ DCE7= 90 08       ..
.LDCE9
JSR LDA67        :\ DCE9= 20 67 DA     gZ
JSR LDD65        :\ DCEC= 20 65 DD     e]
BCS LDCE9        :\ DCEF= B0 F8       0x
.LDCF1
JSR LDD85        :\ DCF1= 20 85 DD     .]
BCS LDCE5        :\ DCF4= B0 EF       0o
SEC              :\ DCF6= 38          8
LDA &0334        :\ DCF7= AD 34 03    -4.
SBC &DE          :\ DCFA= E5 DE       e^
STA &0332        :\ DCFC= 8D 32 03    .2.
LDA &0335        :\ DCFF= AD 35 03    -5.
SBC &DF          :\ DD02= E5 DF       e_
STA &0333        :\ DD04= 8D 33 03    .3.
.LDD07
LDA #&00         :\ DD07= A9 00       ).
SEC              :\ DD09= 38          8
.LDD0A
RTS              :\ DD0A= 60          `
 
.LDD0B
LDX #&00         :\ DD0B= A2 00       ".
JSR LDD35        :\ DD0D= 20 35 DD     5]
BNE LDD0A        :\ DD10= D0 F8       Px
.LDD12
ASL &D1          :\ DD12= 06 D1       .Q
BCC LDD1E        :\ DD14= 90 08       ..
.LDD16
JSR LDA34        :\ DD16= 20 34 DA     4Z
JSR LDD65        :\ DD19= 20 65 DD     e]
BCS LDD16        :\ DD1C= B0 F8       0x
.LDD1E
JSR LDD85        :\ DD1E= 20 85 DD     .]
BCS LDD12        :\ DD21= B0 EF       0o
LDA &0300        :\ DD23= AD 00 03    -..
ADC &DE          :\ DD26= 65 DE       e^
STA &032E        :\ DD28= 8D 2E 03    ...
LDA &0301        :\ DD2B= AD 01 03    -..
ADC &DF          :\ DD2E= 65 DF       e_
STA &032F        :\ DD30= 8D 2F 03    ./.
BRA LDD07        :\ DD33= 80 D2       .R
 
.LDD35
SEC              :\ DD35= 38          8
LDA &032E        :\ DD36= AD 2E 03    -..
SBC &0300,X      :\ DD39= FD 00 03    }..
TAY              :\ DD3C= A8          (
LDA &032F        :\ DD3D= AD 2F 03    -/.
SBC &0301,X      :\ DD40= FD 01 03    }..
BPL LDD48        :\ DD43= 10 03       ..
JSR LC92E        :\ DD45= 20 2E C9     .I
.LDD48
STY &DE          :\ DD48= 84 DE       .^
STA &DF          :\ DD4A= 85 DF       ._
LDX #&2E         :\ DD4C= A2 2E       ".
JSR LDEC3        :\ DD4E= 20 C3 DE     C^
CLC              :\ DD51= 18          .
BNE LDD64        :\ DD52= D0 10       P.
LDA (&D6),Y      :\ DD54= B1 D6       1V
EOR L8830,X      :\ DD56= 5D 30 88    ]0.
STA &DA          :\ DD59= 85 DA       .Z
AND &D1          :\ DD5B= 25 D1       %Q
BEQ LDD61        :\ DD5D= F0 02       p.
LDA #&08         :\ DD5F= A9 08       ).
.LDD61
EOR &E1          :\ DD61= 45 E1       Ea
SEC              :\ DD63= 38          8
.LDD64
RTS              :\ DD64= 60          `
 
.LDD65
LDA (&D6),Y      :\ DD65= B1 D6       1V
EOR L8830,X      :\ DD67= 5D 30 88    ]0.
STA &DA          :\ DD6A= 85 DA       .Z
ORA &E1          :\ DD6C= 05 E1       .a
CLC              :\ DD6E= 18          .
BNE LDD84        :\ DD6F= D0 13       P.
LDA &DE          :\ DD71= A5 DE       %^
SBC &0361        :\ DD73= ED 61 03    ma.
PHA              :\ DD76= 48          H
LDA &DF          :\ DD77= A5 DF       %_
SBC #&00         :\ DD79= E9 00       i.
BCC LDD83        :\ DD7B= 90 06       ..
STA &DF          :\ DD7D= 85 DF       ._
PLA              :\ DD7F= 68          h
STA &DE          :\ DD80= 85 DE       .^
RTS              :\ DD82= 60          `
 
.LDD83
PLA              :\ DD83= 68          h
.LDD84
RTS              :\ DD84= 60          `
 
.LDD85
LDA &DA          :\ DD85= A5 DA       %Z
AND &D1          :\ DD87= 25 D1       %Q
BEQ LDD8D        :\ DD89= F0 02       p.
LDA #&08         :\ DD8B= A9 08       ).
.LDD8D
EOR &E1          :\ DD8D= 45 E1       Ea
BNE LDD9E        :\ DD8F= D0 0D       P.
LDA &DE          :\ DD91= A5 DE       %^
BNE LDD9B        :\ DD93= D0 06       P.
LDA &DF          :\ DD95= A5 DF       %_
BEQ LDD9E        :\ DD97= F0 05       p.
DEC &DF          :\ DD99= C6 DF       F_
.LDD9B
DEC &DE          :\ DD9B= C6 DE       F^
SEC              :\ DD9D= 38          8
.LDD9E
RTS              :\ DD9E= 60          `
 
.LDD9F
LSR A            :\ DD9F= 4A          J
LSR A            :\ DDA0= 4A          J
.LDDA1
AND #&08         :\ DDA1= 29 08       ).
STA &E1          :\ DDA3= 85 E1       .a
EOR #&0F         :\ DDA5= 49 0F       I.
TAX              :\ DDA7= AA          *
LDY #&07         :\ DDA8= A0 07        .
.LDDAA
LDA L8820,X      :\ DDAA= BD 20 88    = .
STA L8830,Y      :\ DDAD= 99 30 88    .0.
DEX              :\ DDB0= CA          J
DEY              :\ DDB1= 88          .
BPL LDDAA        :\ DDB2= 10 F6       .v
LDX #&20         :\ DDB4= A2 20       " 
RTS              :\ DDB6= 60          `
 
.LDDB7
JSR LC0FA        :\ DDB7= 20 FA C0     z@
LDX &0361        :\ DDBA= AE 61 03    .a.
BEQ LDDE0        :\ DDBD= F0 21       p!
PHA              :\ DDBF= 48          H
TAX              :\ DDC0= AA          *
JSR LD1DE        :\ DDC1= 20 DE D1     ^Q
PLX              :\ DDC4= FA          z
JSR LDEC3        :\ DDC5= 20 C3 DE     C^
BNE LDDE0        :\ DDC8= D0 16       P.
LDA (&D6),Y      :\ DDCA= B1 D6       1V
STZ &DA          :\ DDCC= 64 DA       dZ
BRA LDDD1        :\ DDCE= 80 01       ..
 
.LDDD0
ASL A            :\ DDD0= 0A          .
.LDDD1
ASL &D1          :\ DDD1= 06 D1       .Q
BCC LDDD0        :\ DDD3= 90 FB       .{
ASL A            :\ DDD5= 0A          .
ROL &DA          :\ DDD6= 26 DA       &Z
LDX &D1          :\ DDD8= A6 D1       &Q
BNE LDDD1        :\ DDDA= D0 F5       Pu
LDA &DA          :\ DDDC= A5 DA       %Z
BRA LDDE2        :\ DDDE= 80 02       ..
 
.LDDE0
LDA #&FF         :\ DDE0= A9 FF       ).
.LDDE2
JMP LC0CA        :\ DDE2= 4C CA C0    LJ@
 
.LDDE5
CMP #&23         :\ DDE5= C9 23       I#
BEQ LDDF3        :\ DDE7= F0 0A       p.
CMP #&5F         :\ DDE9= C9 5F       I_
BEQ LDDF5        :\ DDEB= F0 08       p.
CMP #&60         :\ DDED= C9 60       I`
BNE LDDF7        :\ DDEF= D0 06       P.
EOR #&3F         :\ DDF1= 49 3F       I?
.LDDF3
EOR #&43         :\ DDF3= 49 43       IC
.LDDF5
EOR #&3F         :\ DDF5= 49 3F       I?
.LDDF7
RTS              :\ DDF7= 60          `
 
.LDDF8
CLI              :\ DDF8= 58          X
BIT &D0          :\ DDF9= 24 D0       $P
BVC LDE03        :\ DDFB= 50 06       P.
JSR LC0FA        :\ DDFD= 20 FA C0     z@
JSR LC0D1        :\ DE00= 20 D1 C0     Q@
.LDE03
LDY &0360        :\ DE03= AC 60 03    ,`.
BNE LDE1F        :\ DE06= D0 17       P.
LDA (&D8)        :\ DE08= B2 D8       2X
JSR LDDE5        :\ DE0A= 20 E5 DD     e]
JSR LDDE5        :\ DE0D= 20 E5 DD     e]
.LDE10
BIT &D0          :\ DE10= 24 D0       $P
BVC LDE1A        :\ DE12= 50 06       P.
JSR LC0D1        :\ DE14= 20 D1 C0     Q@
JSR LC0CA        :\ DE17= 20 CA C0     J@
.LDE1A
LDY &0355        :\ DE1A= AC 55 03    ,U.
TAX              :\ DE1D= AA          *
RTS              :\ DE1E= 60          `
 
.LDE1F
JSR LDE56        :\ DE1F= 20 56 DE     V^
LDA &F4          :\ DE22= A5 F4       %t
PHA              :\ DE24= 48          H
JSR LE57F        :\ DE25= 20 7F E5     .e
LDA #&20         :\ DE28= A9 20       ) 
TAX              :\ DE2A= AA          *
JSR LE22C        :\ DE2B= 20 2C E2     ,b
.LDE2E
LDY #&07         :\ DE2E= A0 07        .
.LDE30
LDA &0328,Y      :\ DE30= B9 28 03    9(.
EOR (&DE),Y      :\ DE33= 51 DE       Q^
BNE LDE41        :\ DE35= D0 0A       P.
DEY              :\ DE37= 88          .
BPL LDE30        :\ DE38= 10 F6       .v
TXA              :\ DE3A= 8A          .
.LDE3B
PLX              :\ DE3B= FA          z
JSR LE581        :\ DE3C= 20 81 E5     .e
BRA LDE10        :\ DE3F= 80 CF       .O
 
.LDE41
INX              :\ DE41= E8          h
CLC              :\ DE42= 18          .
LDA &DE          :\ DE43= A5 DE       %^
ADC #&08         :\ DE45= 69 08       i.
STA &DE          :\ DE47= 85 DE       .^
BCC LDE4D        :\ DE49= 90 02       ..
INC &DF          :\ DE4B= E6 DF       f_
.LDE4D
CPX #&7F         :\ DE4D= E0 7F       `.
BEQ LDE41        :\ DE4F= F0 F0       pp
TXA              :\ DE51= 8A          .
BNE LDE2E        :\ DE52= D0 DA       PZ
BRA LDE3B        :\ DE54= 80 E5       .e
 
.LDE56
LDX &D8          :\ DE56= A6 D8       &X
LDA &D9          :\ DE58= A5 D9       %Y
JSR LCED9        :\ DE5A= 20 D9 CE     YN
LDY #&07         :\ DE5D= A0 07        .
.LDE5F
LDX &0360        :\ DE5F= AE 60 03    .`.
CPX #&03         :\ DE62= E0 03       `.
BEQ LDE6F        :\ DE64= F0 09       p.
BCS LDE7B        :\ DE66= B0 13       0.
LDA (&D8),Y      :\ DE68= B1 D8       1X
EOR &0358        :\ DE6A= 4D 58 03    MX.
BRA LDE91        :\ DE6D= 80 22       ."
 
.LDE6F
LDA (&D8),Y      :\ DE6F= B1 D8       1X
JSR LDEA2        :\ DE71= 20 A2 DE     "^
LDA (&DA),Y      :\ DE74= B1 DA       1Z
JSR LDEA2        :\ DE76= 20 A2 DE     "^
BRA LDE8F        :\ DE79= 80 14       ..
 
.LDE7B
LDA (&D8),Y      :\ DE7B= B1 D8       1X
JSR LDE98        :\ DE7D= 20 98 DE     .^
LDA (&DA),Y      :\ DE80= B1 DA       1Z
JSR LDE98        :\ DE82= 20 98 DE     .^
LDA (&DC),Y      :\ DE85= B1 DC       1\
JSR LDE98        :\ DE87= 20 98 DE     .^
LDA (&E0),Y      :\ DE8A= B1 E0       1`
JSR LDE98        :\ DE8C= 20 98 DE     .^
.LDE8F
LDA &DF          :\ DE8F= A5 DF       %_
.LDE91
STA &0328,Y      :\ DE91= 99 28 03    .(.
DEY              :\ DE94= 88          .
BPL LDE5F        :\ DE95= 10 C8       .H
RTS              :\ DE97= 60          `
 
.LDE98
EOR &0358        :\ DE98= 4D 58 03    MX.
JSR LDEB5        :\ DE9B= 20 B5 DE     5^
AND #&03         :\ DE9E= 29 03       ).
BRA LDEAE        :\ DEA0= 80 0C       ..
 
.LDEA2
EOR &0358        :\ DEA2= 4D 58 03    MX.
JSR LDEBA        :\ DEA5= 20 BA DE     :^
AND #&0F         :\ DEA8= 29 0F       ).
ASL &DF          :\ DEAA= 06 DF       ._
ASL &DF          :\ DEAC= 06 DF       ._
.LDEAE
ASL &DF          :\ DEAE= 06 DF       ._
ASL &DF          :\ DEB0= 06 DF       ._
TSB &DF          :\ DEB2= 04 DF       ._
RTS              :\ DEB4= 60          `
 
.LDEB5
STA &DE          :\ DEB5= 85 DE       .^
JSR LDEBE        :\ DEB7= 20 BE DE     >^
.LDEBA
STA &DE          :\ DEBA= 85 DE       .^
LSR A            :\ DEBC= 4A          J
LSR A            :\ DEBD= 4A          J
.LDEBE
LSR A            :\ DEBE= 4A          J
LSR A            :\ DEBF= 4A          J
ORA &DE          :\ DEC0= 05 DE       .^
.LDEC2
RTS              :\ DEC2= 60          `
 
.LDEC3
JSR LD1A8        :\ DEC3= 20 A8 D1     (Q
BNE LDEC2        :\ DEC6= D0 FA       Pz
.LDEC8
LDA &0302,X      :\ DEC8= BD 02 03    =..
.LDECB
EOR #&FF         :\ DECB= 49 FF       I.
TAY              :\ DECD= A8          (
AND #&07         :\ DECE= 29 07       ).
STA &DA          :\ DED0= 85 DA       .Z
TYA              :\ DED2= 98          .
AND #&F8         :\ DED3= 29 F8       )x
LSR A            :\ DED5= 4A          J
STA &D7          :\ DED6= 85 D7       .W
LSR A            :\ DED8= 4A          J
LSR A            :\ DED9= 4A          J
ADC &D7          :\ DEDA= 65 D7       eW
LSR A            :\ DEDC= 4A          J
STA &D7          :\ DEDD= 85 D7       .W
LDA #&00         :\ DEDF= A9 00       ).
ROR A            :\ DEE1= 6A          j
LDY &0356        :\ DEE2= AC 56 03    ,V.
BEQ LDEEA        :\ DEE5= F0 03       p.
LSR &D7          :\ DEE7= 46 D7       FW
ROR A            :\ DEE9= 6A          j
.LDEEA
ORA &DA          :\ DEEA= 05 DA       .Z
ADC &0350        :\ DEEC= 6D 50 03    mP.
STA &031A        :\ DEEF= 8D 1A 03    ...
LDA &D7          :\ DEF2= A5 D7       %W
ADC &0351        :\ DEF4= 6D 51 03    mQ.
STA &D7          :\ DEF7= 85 D7       .W
LDA &0301,X      :\ DEF9= BD 01 03    =..
STA &D6          :\ DEFC= 85 D6       .V
LDA &0300,X      :\ DEFE= BD 00 03    =..
.LDF01
AND &0361        :\ DF01= 2D 61 03    -a.
.LDF04
ADC &0361        :\ DF04= 6D 61 03    ma.
TAY              :\ DF07= A8          (
.LDF08
LDA LE12E,Y      :\ DF08= B9 2E E1    9.a
STA &D1          :\ DF0B= 85 D1       .Q
LDA &0300,X      :\ DF0D= BD 00 03    =..
.LDF10
LDY &0361        :\ DF10= AC 61 03    ,a.
CPY #&03         :\ DF13= C0 03       @.
BEQ LDF1C        :\ DF15= F0 05       p.
BCS LDF1F        :\ DF17= B0 06       0.
ASL A            :\ DF19= 0A          .
ROL &D6          :\ DF1A= 26 D6       &V
.LDF1C
ASL A            :\ DF1C= 0A          .
ROL &D6          :\ DF1D= 26 D6       &V
.LDF1F
AND #&F8         :\ DF1F= 29 F8       )x
CLC              :\ DF21= 18          .
ADC &031A        :\ DF22= 6D 1A 03    m..
STA &031A        :\ DF25= 8D 1A 03    ...
LDA &D6          :\ DF28= A5 D6       %V
ADC &D7          :\ DF2A= 65 D7       eW
BPL LDF32        :\ DF2C= 10 04       ..
SEC              :\ DF2E= 38          8
SBC &0354        :\ DF2F= ED 54 03    mT.
.LDF32
STA &D7          :\ DF32= 85 D7       .W
STZ &D6          :\ DF34= 64 D6       dV
LDX &DA          :\ DF36= A6 DA       &Z
JSR LDA7C        :\ DF38= 20 7C DA     |Z
LDY &031A        :\ DF3B= AC 1A 03    ,..
.LDF3E
LDA #&00         :\ DF3E= A9 00       ).
RTS              :\ DF40= 60          `
 
.LDF41
JSR LDEC8        :\ DF41= 20 C8 DE     H^
PHX              :\ DF44= DA          Z
LDX #&00         :\ DF45= A2 00       ".
LDA &035A        :\ DF47= AD 5A 03    -Z.
CMP #&04         :\ DF4A= C9 04       I.
BCS LDF59        :\ DF4C= B0 0B       0.
LDX &036A        :\ DF4E= AE 6A 03    .j.
LDA &0359        :\ DF51= AD 59 03    -Y.
BEQ LDF59        :\ DF54= F0 03       p.
LDX &036B        :\ DF56= AE 6B 03    .k.
.LDF59
STX &0369        :\ DF59= 8E 69 03    .i.
PLX              :\ DF5C= FA          z
RTS              :\ DF5D= 60          `
 
.LDF5E
LDA #&20         :\ DF5E= A9 20       ) 
BIT &D0          :\ DF60= 24 D0       $P
BVC LDF3E        :\ DF62= 50 DA       PZ
BNE LDF3E        :\ DF64= D0 D8       PX
JSR LDDF8        :\ DF66= 20 F8 DD     x]
BEQ LDF77        :\ DF69= F0 0C       p.
PHA              :\ DF6B= 48          H
JSR LDFD5        :\ DF6C= 20 D5 DF     U_
BNE LDF76        :\ DF6F= D0 05       P.
LDA #&09         :\ DF71= A9 09       ).
JSR LDFBC        :\ DF73= 20 BC DF     <_
.LDF76
PLA              :\ DF76= 68          h
.LDF77
RTS              :\ DF77= 60          `
 
.LDF78
PHA              :\ DF78= 48          H
JSR LDFD5        :\ DF79= 20 D5 DF     U_
BNE LDF76        :\ DF7C= D0 F8       Px
BVS LDF96        :\ DF7E= 70 16       p.
LDA &035F        :\ DF80= AD 5F 03    -_.
AND #&DF         :\ DF83= 29 DF       )_
JSR LCF53        :\ DF85= 20 53 CF     SO
LDX #&18         :\ DF88= A2 18       ".
LDY #&64         :\ DF8A= A0 64        d
JSR LC90C        :\ DF8C= 20 0C C9     .I
JSR LC105        :\ DF8F= 20 05 C1     .A
LDA #&02         :\ DF92= A9 02       ).
TSB &D0          :\ DF94= 04 D0       .P
.LDF96
PLA              :\ DF96= 68          h
AND #&7F         :\ DF97= 29 7F       ).
STA &DA          :\ DF99= 85 DA       .Z
CMP #&0A         :\ DF9B= C9 0A       I.
BCS LDFAD        :\ DF9D= B0 0E       0.
LDA &0366        :\ DF9F= AD 66 03    -f.
LSR A            :\ DFA2= 4A          J
AND #&05         :\ DFA3= 29 05       ).
BIT #&04         :\ DFA5= 89 04       ..
BEQ LDFBA        :\ DFA7= F0 11       p.
EOR #&07         :\ DFA9= 49 07       I.
BRA LDFBA        :\ DFAB= 80 0D       ..
 
.LDFAD
LDA &0366        :\ DFAD= AD 66 03    -f.
LSR A            :\ DFB0= 4A          J
LSR A            :\ DFB1= 4A          J
AND #&03         :\ DFB2= 29 03       ).
BIT #&02         :\ DFB4= 89 02       ..
BEQ LDFBA        :\ DFB6= F0 02       p.
EOR #&01         :\ DFB8= 49 01       I.
.LDFBA
EOR &DA          :\ DFBA= 45 DA       EZ
.LDFBC
TAY              :\ DFBC= A8          (
LDA #&40         :\ DFBD= A9 40       )@
TRB &D0          :\ DFBF= 14 D0       .P
TYA              :\ DFC1= 98          .
.LDFC2
LDX &036C        :\ DFC2= AE 6C 03    .l.
.LDFC5
PHX              :\ DFC5= DA          Z
.LDFC6
LSR &036C        :\ DFC6= 4E 6C 03    Nl.
.LDFC9
JSR LC027        :\ DFC9= 20 27 C0     '@
.LDFCC
PLA              :\ DFCC= 68          h
.LDFCD
STA &036C        :\ DFCD= 8D 6C 03    .l.
LDA #&40         :\ DFD0= A9 40       )@
TSB &D0          :\ DFD2= 04 D0       .P
.LDFD4
RTS              :\ DFD4= 60          `
 
.LDFD5
LDX &026A        :\ DFD5= AE 6A 02    .j.
.LDFD8
BNE LDFDE        :\ DFD8= D0 04       P.
.LDFDA
LDA #&A0         :\ DFDA= A9 A0       ) 
.LDFDC
BIT &D0          :\ DFDC= 24 D0       $P
.LDFDE
RTS              :\ DFDE= 60          `
 
.LDFDF
LDX #&8E         :\ DFDF= A2 8E       ".  ; select VIEW+ANDY
JSR LE581        :\ DFE1= 20 81 E5     .e
JSR XBEBE        :\ DFE4= 20 BE BE     >>
BRA LDFF1        :\ DFE7= 80 08       ..
 
LDX #&8E         :\ DFE9= A2 8E       ".
JSR LE581        :\ DFEB= 20 81 E5     .e
JSR XBA00        :\ DFEE= 20 00 BA     .:
.LDFF1
JMP LE57F        :\ DFF1= 4C 7F E5    L.e
 
LDX #&8E         :\ DFF4= A2 8E       ".
JSR LE581        :\ DFF6= 20 81 E5     .e
JSR XBA67        :\ DFF9= 20 67 BA     g:
BRA LDFF1        :\ DFFC= 80 F3       .s
 
BRK              :\ DFFE= 00          .
BRK              :\ DFFF= 00          .
ORA &6341        :\ E000= 0D 41 63    .Ac
EQUB &6F         :\ E003= 6F          o
ADC (&6E)        :\ E004= 72 6E       rn
JSR &4F4D        :\ E006= 20 4D 4F     MO
EQUB &53         :\ E009= 53          S
BRK              :\ E00A= 00          .
EQUB &07         :\ E00B= 07          .
BRK              :\ E00C= 00          . Space for "xxK"
BRK              :\ E00D= 00          .
BRK              :\ E00E= 00          .
BRK              :\ E00F= 00          .
PHP              :\ E010= 08          .
\ORA &000D        :\ E011= 0D 0D 00    ...
EQUB &0D
EQUB &0D
.LE013
EQUB &00
; ORA (&22),Y      :\ E014= 11 22       ."
; EQUB &33         :\ E016= 33          3
; EQUB &44         :\ E017= 44          D
; EOR &66,X        :\ E018= 55 66       Uf
; EQUB &77         :\ E01A= 77          w
; DEY              :\ E01B= 88          .
; STA LBBAA,Y      :\ E01C= 99 AA BB    .*;
; CPY LEEDD        :\ E01F= CC DD EE    L]n
; EQUB &FF         :\ E022= FF          .
EQUB &11
EQUB &22
EQUB &33
EQUB &44
EQUB &55
EQUB &66
EQUB &77
EQUB &88
EQUB &99
EQUB &AA
EQUB &BB
EQUB &CC
EQUB &DD
EQUB &EE
EQUB &FF
.LE023
; BRK              :\ E023= 00          .
; EOR &AA,X        :\ E024= 55 AA       U*
; EQUB &FF         :\ E026= FF          .
EQUB &00
EQUB &55
EQUB &AA
EQUB &FF

; VDU control code dispatch table, low bytes
; ==========================================
.LE027
EQUB &35         :\ E027= 35          5
EQUB &E2         :\ E028= E2          .
EQUB &EA         :\ E029= EA          .
EQUB &EA         :\ E02A= EA          .
EQUB &1E         :\ E02B= 1E          .
EQUB &2D         :\ E02C= 2D          -
EQUB &35         :\ E02D= 35          5
EQUB &B6         :\ E02E= B6          .
EQUB &9A         :\ E02F= 9A          .
EQUB &4C         :\ E030= 4C          L
EQUB &5B         :\ E031= 5B          [
EQUB &B1         :\ E032= B1          .
EQUB &4F         :\ E033= 4F          O
EQUB &F6         :\ E034= F6          .
EQUB &14         :\ E035= 14          .
EQUB &28         :\ E036= 28          (
EQUB &13         :\ E037= 13          .
EQUB &39         :\ E038= 39          9
EQUB &64         :\ E039= 64          d
EQUB &2D         :\ E03A= 2D          -
EQUB &C5         :\ E03B= C5          .
EQUB &19         :\ E03C= 19          .
EQUB &94         :\ E03D= 94          .
EQUB &7C         :\ E03E= 7C          |
EQUB &1F         :\ E03F= 1F          .
EQUB &9B         :\ E040= 9B          .
EQUB &AA         :\ E041= AA          .
EQUB &35         :\ E042= 35          5
EQUB &A5         :\ E043= A5          .
EQUB &8A         :\ E044= 8A          .
EQUB &7C         :\ E045= 7C          |
EQUB &82         :\ E046= 82          .
EQUB &2D         :\ E047= 2D          -

; VDU control code dispatch table, high bytes
; ===========================================
.LE048
EQUB &C0         :\ E048= C0          .
EQUB &0F         :\ E049= 0F          .
EQUB &C0         :\ E04A= C0          .
EQUB &C0         :\ E04B= C0          .
EQUB &C5         :\ E04C= C5          .
EQUB &C5         :\ E04D= C5          .
EQUB &C0         :\ E04E= C0          .
EQUB &EF         :\ E04F= EF          .
EQUB &C2         :\ E050= C2          .
EQUB &C2         :\ E051= C2          .
EQUB &C2         :\ E052= C2          .
EQUB &C2         :\ E053= C2          .
EQUB &C4         :\ E054= C4          .
EQUB &C3         :\ E055= C3          .
EQUB &C5         :\ E056= C5          .
EQUB &C5         :\ E057= C5          .
EQUB &C4         :\ E058= C4          .
EQUB &5F         :\ E059= 5F          _
EQUB &5E         :\ E05A= 5E          ^
EQUB &6B         :\ E05B= 6B          k
EQUB &C5         :\ E05C= C5          .
EQUB &C5         :\ E05D= C5          .
EQUB &7F         :\ E05E= 7F          
EQUB &67         :\ E05F= 67          g
EQUB &78         :\ E060= 78          x
EQUB &6B         :\ E061= 6B          k
EQUB &C6         :\ E062= C6          .
EQUB &C0         :\ E063= C0          .
EQUB &3C         :\ E064= 3C          <
EQUB &7C         :\ E065= 7C          |
EQUB &C4         :\ E066= C4          .
EQUB &4E         :\ E067= 4E          N
EQUB &CE         :\ E068= CE          .
.LE069
EQUB &FB
DEC LCF2B        :\ E06A= CE 2B CF    N+O
EQUB &57         :\ E06D= 57          W
EQUB &CF         :\ E06E= CF          O
EQUB &57         :\ E06F= 57          W
EQUB &CF         :\ E070= CF          O
EQUB &57         :\ E071= 57          W
EQUB &CF         :\ E072= CF          O
EQUB &57         :\ E073= 57          W
EQUB &CF         :\ E074= CF          O
EQUB &DF         :\ E075= DF          _
EQUB &CF         :\ E076= CF          O
INC &CF          :\ E077= E6 CF       fO
ADC #&D0         :\ E079= 69 D0       iP
.LE07B
EQUB &0F         :\ E07B= 0F          .
CMP (&10),Y      :\ E07C= D1 10       Q.
CMP (&6D),Y      :\ E07E= D1 6D       Qm
EQUB &CF         :\ E080= CF          O
STX &CF,Y        :\ E081= 96 CF       .O
STX &CF,Y        :\ E083= 96 CF       .O
STX &CF,Y        :\ E085= 96 CF       .O
STX &CF,Y        :\ E087= 96 CF       .O
ASL &4AD1,X      :\ E089= 1E D1 4A    .QJ
.LE08C
EQUB &DB         :\ E08C= DB          [
\JMP (LF7DC)      :\ E08D= 6C DC F7    l\w
EQUB &6C
EQUB &DC
EQUB &F7
 
EQUB &9B         :\ E090= 9B          .
ADC &DC,X        :\ E091= 75 DC       u\
PHA              :\ E093= 48          H
CPY &6C          :\ E094= C4 6C       Dl
EQUB &DC         :\ E096= DC          \
EQUB &A3         :\ E097= A3          #
EQUB &9B         :\ E098= 9B          .
ADC &DC,X        :\ E099= 75 DC       u\
SBC LF99C,Y      :\ E09B= F9 9C F9    y.y
STZ L99A4        :\ E09E= 9C A4 99    .$.
EQUB &44         :\ E0A1= 44          D
STA L9999,Y      :\ E0A2= 99 99 99    ...
AND &99,X        :\ E0A5= 35 99       5.
EQUB &23         :\ E0A7= 23          #
STA HAZEL_WORKSPACE+&DF,Y      :\ E0A8= 99 DF DF    .__
SBC #&DF         :\ E0AB= E9 DF       i_
EQUB &F4         :\ E0AD= F4          t
EQUB &DF         :\ E0AE= DF          _

\ Times 40 lookup table, high bytes
.LE0AF
BRK              :\ E0AF= 00          .
BRK              :\ E0B0= 00          .
BRK              :\ E0B1= 00          .
BRK              :\ E0B2= 00          .
BRK              :\ E0B3= 00          .
BRK              :\ E0B4= 00          .
BRK              :\ E0B5= 00          .
ORA (&01,X)      :\ E0B6= 01 01       ..
ORA (&01,X)      :\ E0B8= 01 01       ..
ORA (&01,X)      :\ E0BA= 01 01       ..
EQUB &02         :\ E0BC= 02          .
EQUB &02         :\ E0BD= 02          .
EQUB &02         :\ E0BE= 02          .
EQUB &02         :\ E0BF= 02          .
EQUB &02         :\ E0C0= 02          .
EQUB &02         :\ E0C1= 02          .
EQUB &02         :\ E0C2= 02          .
EQUB &03         :\ E0C3= 03          .
EQUB &03         :\ E0C4= 03          .
EQUB &03         :\ E0C5= 03          .
EQUB &03         :\ E0C6= 03          .
EQUB &03         :\ E0C7= 03          .

\ Times 40 lookup table, low bytes
.LE0C8
EQUB &00         :\ E0C8= 00          .
EQUB &28         :\ E0C9= 28          (
EQUB &50         :\ E0CA= 50          P
EQUB &78         :\ E0CB= 78          x
EQUB &A0         :\ E0CC= A0          .
EQUB &C8         :\ E0CD= C8          .
EQUB &F0         :\ E0CE= F0          .
EQUB &18         :\ E0CF= 18          .
EQUB &40         :\ E0D0= 40          @
EQUB &68         :\ E0D1= 68          h
EQUB &90         :\ E0D2= 90          .
EQUB &B8         :\ E0D3= B8          .
EQUB &E0         :\ E0D4= E0          .
EQUB &08         :\ E0D5= 08          .
EQUB &30         :\ E0D6= 30          0
EQUB &58         :\ E0D7= 58          X
EQUB &80         :\ E0D8= 80          .
EQUB &A8         :\ E0D9= A8          .
EQUB &D0         :\ E0DA= D0          .
EQUB &F8         :\ E0DB= F8          .
EQUB &20         :\ E0DC= 20
EQUB &48         :\ E0DD= 48          H
EQUB &70         :\ E0DE= 70          p
EQUB &98         :\ E0DF= 98          .
EQUB &C0         :\ E0E0= C0          .

\ Times 320 lookup table
.LE0E1
EQUB &00         :\ E0E1= 00
EQUB &02         :\ E0E2= 02          .
ORA &07          :\ E0E3= 05 07       ..
ASL A            :\ E0E5= 0A          .
TSB &110F        :\ E0E6= 0C 0F 11    ...
TRB &16          :\ E0E9= 14 16       ..
ORA &1E1B,Y      :\ E0EB= 19 1B 1E    ...
JSR &2523        :\ E0EE= 20 23 25     #%
PLP              :\ E0F1= 28          (
ROL A            :\ E0F2= 2A          *
AND &322F        :\ E0F3= 2D 2F 32    -/2
BIT &37,X        :\ E0F6= 34 37       47
AND &3E3C,Y      :\ E0F8= 39 3C 3E    9<>
EOR (&43,X)      :\ E0FB= 41 43       AC
LSR &48          :\ E0FD= 46 48       FH
EQUB &4B         :\ E0FF= 4B          K
\EOR &1F1F        :\ E100= 4D 1F 1F    M..
EQUB &4D
.LE101
EQUB &1F
EQUB &1F
EQUB &1F         :\ E103= 1F          .
CLC              :\ E104= 18          .
EQUB &1F         :\ E105= 1F          .
EQUB &1F         :\ E106= 1F          .
CLC              :\ E107= 18          .
CLC              :\ E108= 18          .
.LE109
EQUB &4F         :\ E109= 4F          O
EQUB &27         :\ E10A= 27          '
EQUB &13         :\ E10B= 13          .
EQUB &4F         :\ E10C= 4F          O
EQUB &27         :\ E10D= 27          '
EQUB &13         :\ E10E= 13          .
EQUB &27         :\ E10F= 27          '
EQUB &27         :\ E110= 27          '
.LE111
\STZ LF4D8        :\ E111= 9C D8 F4    .Xt
EQUB &9C
EQUB &D8
EQUB &F4
\STZ LC488        :\ E114= 9C 88 C4    ..D
EQUB &9C
EQUB &88
EQUB &C4
DEY              :\ E117= 88          .
EQUB &4B         :\ E118= 4B          K
.LE119
PHP              :\ E119= 08          .
BPL LE13C        :\ E11A= 10 20       . 
PHP              :\ E11C= 08          .
PHP              :\ E11D= 08          .
BPL LE128        :\ E11E= 10 08       ..
.LE120
ORA (&FF,X)      :\ E120= 01 FF       ..
EOR &FF,X        :\ E122= 55 FF       U.
EQUB &77         :\ E124= 77          w
EQUB &33         :\ E125= 33          3
\ORA (&FF),Y      :\ E126= 11 FF       ..
EQUB &11
.LE127
EQUB &FF
.LE128
EQUB &7F         :\ E128= 7F          .
EQUB &3F         :\ E129= 3F          ?
EQUB &1F         :\ E12A= 1F          .
EQUB &0F         :\ E12B= 0F          .
EQUB &07         :\ E12C= 07          .
EQUB &03         :\ E12D= 03          .
.LE12E
ORA (&AA,X)      :\ E12E= 01 AA       .*
.LE130
EOR &88,X        :\ E130= 55 88       U.
EQUB &44         :\ E132= 44          D
EQUB &22         :\ E133= 22          "
ORA (&80),Y      :\ E134= 11 80       ..
RTI              :\ E136= 40          @
 
JSR &0810        :\ E137= 20 10 08     ..
TSB &02          :\ E13A= 04 02       ..
.LE13C
ORA (&03,X)      :\ E13C= 01 03       ..
EQUB &0F         :\ E13E= 0F          .
ORA (&01,X)      :\ E13F= 01 01       ..
EQUB &03         :\ E141= 03          .
\ORA (&00,X)      :\ E142= 01 00       ..
EQUB &01
.LE143
EQUB &00
.LE144
EQUB &FF         :\ E144= FF          .
.LE145
BRK              :\ E145= 00          .
BRK              :\ E146= 00          .
EQUB &FF         :\ E147= FF          .
.LE148
EQUB &FF         :\ E148= FF          .
EQUB &FF         :\ E149= FF          .
EQUB &FF         :\ E14A= FF          .
.LE14B
BRK              :\ E14B= 00          .
BRK              :\ E14C= 00          .
EQUB &FF         :\ E14D= FF          .
BRK              :\ E14E= 00          .
EQUB &0F         :\ E14F= 0F          .
\BEQ LE151        :\ E150= F0 FF       p.
EQUB &F0
EQUB &FF
BRK              :\ E152= 00          .
EQUB &03         :\ E153= 03          .
TSB &300F        :\ E154= 0C 0F 30    ..0
EQUB &33         :\ E157= 33          3
BIT LC03F,X      :\ E158= 3C 3F C0    <?@
EQUB &C3         :\ E15B= C3          C
\CPY LF0CF        :\ E15C= CC CF F0    LOp
EQUB &CC
EQUB &CF
EQUB &F0
EQUB &F3         :\ E15F= F3          s
EQUB &FC         :\ E160= FC          |
EQUB &FF         :\ E161= FF          .
.LE162
EQUB &07         :\ E162= 07          .
EQUB &03         :\ E163= 03          .
\ORA (&00,X)      :\ E164= 01 00       ..
EQUB &01
.LE165
EQUB &00
EQUB &07         :\ E166= 07          .
EQUB &03         :\ E167= 03          .
.LE168
BRK              :\ E168= 00          .
BRK              :\ E169= 00          .
BRK              :\ E16A= 00          .
ORA (&02,X)      :\ E16B= 01 02       ..
EQUB &02         :\ E16D= 02          .
EQUB &03         :\ E16E= 03          .
\TSB &0D          :\ E16F= 04 0D       ..
EQUB &04
.LE170
EQUB &0D
ORA &0D          :\ E171= 05 0D       ..
\ORA &04          :\ E173= 05 04       ..
EQUB &05
.LE174
EQUB &04
TSB &0C          :\ E175= 04 0C       ..
\TSB &5004        :\ E177= 0C 04 50    ..P
EQUB &0C
EQUB &04
.LE179
EQUB &50
RTI              :\ E17A= 40          @
 
PLP              :\ E17B= 28          (
\JSR &3004        :\ E17C= 20 04 30     .0
EQUB &20
EQUB &04
.LE17E
EQUB &30
RTI              :\ E17F= 40          @
 
CLI              :\ E180= 58          X
RTS              :\ E181= 60          `
 
\JMP (&170B,X)    :\ E182= 7C 0B 17    |..
EQUB &7C
.LE183
EQUB &0B
EQUB &17
 
EQUB &23         :\ E185= 23          #
EQUB &2F         :\ E186= 2F          /
EQUB &3B         :\ E187= 3B          ;
.LE188
EQUB &7F         :\ E188= 7F          .
\BVC LE1ED        :\ E189= 50 62       Pb
EQUB &50
EQUB &62
PLP              :\ E18B= 28          (
ROL &00          :\ E18C= 26 00       &.
JSR &0122        :\ E18E= 20 22 01     ".
EQUB &07         :\ E191= 07          .
EQUB &67         :\ E192= 67          g
PHP              :\ E193= 08          .
EQUB &7F         :\ E194= 7F          .
\BVC LE1F9        :\ E195= 50 62       Pb
EQUB &50
EQUB &62
PLP              :\ E197= 28          (
ASL &1902,X      :\ E198= 1E 02 19    ...
EQUB &1B         :\ E19B= 1B          .
ORA (&09,X)      :\ E19C= 01 09       ..
EQUB &67         :\ E19E= 67          g
ORA #&3F         :\ E19F= 09 3F       .?
PLP              :\ E1A1= 28          (
AND (&24),Y      :\ E1A2= 31 24       1$
ROL &00          :\ E1A4= 26 00       &.
JSR &0122        :\ E1A6= 20 22 01     ".
EQUB &07         :\ E1A9= 07          .
EQUB &67         :\ E1AA= 67          g
PHP              :\ E1AB= 08          .
EQUB &3F         :\ E1AC= 3F          ?
PLP              :\ E1AD= 28          (
AND (&24),Y      :\ E1AE= 31 24       1$
ASL &1902,X      :\ E1B0= 1E 02 19    ...
EQUB &1B         :\ E1B3= 1B          .
ORA (&09,X)      :\ E1B4= 01 09       ..
EQUB &67         :\ E1B6= 67          g
ORA #&3F         :\ E1B7= 09 3F       .?
PLP              :\ E1B9= 28          (
EQUB &33         :\ E1BA= 33          3
BIT &1E          :\ E1BB= 24 1E       $.
EQUB &02         :\ E1BD= 02          .
ORA L931B,Y      :\ E1BE= 19 1B 93    ...
ORA (&72)        :\ E1C1= 12 72       .r
.LE1C3
EQUB &13         :\ E1C3= 13          .
TAX              :\ E1C4= AA          *
BRK              :\ E1C5= 00          .
TAX              :\ E1C6= AA          *
BRK              :\ E1C7= 00          .
TAX              :\ E1C8= AA          *
EOR &AA,X        :\ E1C9= 55 AA       U*
EOR &FF,X        :\ E1CB= 55 FF       U.
EOR &FF,X        :\ E1CD= 55 FF       U.
EOR &11,X        :\ E1CF= 55 11       U.
EQUB &22         :\ E1D1= 22          "
EQUB &44         :\ E1D2= 44          D
DEY              :\ E1D3= 88          .
LDA &0F          :\ E1D4= A5 0F       %.
LDA &0F          :\ E1D6= A5 0F       %.
LDA &5A          :\ E1D8= A5 5A       %Z
LDA &5A          :\ E1DA= A5 5A       %Z
BEQ LE238        :\ E1DC= F0 5A       pZ
BEQ LE23A        :\ E1DE= F0 5A       pZ
SBC &FA,X        :\ E1E0= F5 FA       uz
SBC &FA,X        :\ E1E2= F5 FA       uz
EQUB &0B         :\ E1E4= 0B          .
EQUB &07         :\ E1E5= 07          .
EQUB &0B         :\ E1E6= 0B          .
EQUB &07         :\ E1E7= 07          .
EQUB &23         :\ E1E8= 23          #
EQUB &13         :\ E1E9= 13          .
EQUB &23         :\ E1EA= 23          #
EQUB &13         :\ E1EB= 13          .
ASL &0E0D        :\ E1EC= 0E 0D 0E    ...
ORA &2F1F        :\ E1EF= 0D 1F 2F    ../
EQUB &1F         :\ E1F2= 1F          .
EQUB &2F         :\ E1F3= 2F          /
\CPY LCC00        :\ E1F4= CC 00 CC    L.L
EQUB &CC
EQUB &00
EQUB &CC
BRK              :\ E1F7= 00          .
CPY LCC33        :\ E1F8= CC 33 CC    L3L
EQUB &33         :\ E1FB= 33          3
EQUB &FF         :\ E1FC= FF          .
EQUB &33         :\ E1FD= 33          3
EQUB &FF         :\ E1FE= FF          .
EQUB &33         :\ E1FF= 33          3
EQUB &03         :\ E200= 03          .
\TSB LC030        :\ E201= 0C 30 C0    .0@
EQUB &0C
EQUB &30
EQUB &C0
.LE204
ORA (&01,X)      :\ E204= 01 01       ..
EQUB &03         :\ E206= 03          .
EQUB &03         :\ E207= 03          .
EQUB &02         :\ E208= 02          .
BRK              :\ E209= 00          .
EQUB &02         :\ E20A= 02          .
BRK              :\ E20B= 00          .
.LE20C
EQUB &5F         :\ E20C= 5F          _
CMP #&6B         :\ E20D= C9 6B       Ik
CMP #&5F         :\ E20F= C9 5F       I_
CMP #&6B         :\ E211= C9 6B       Ik
CMP #&9D         :\ E213= C9 9D       I.
CMP #&9D         :\ E215= C9 9D       I.
CMP #&A4         :\ E217= C9 A4       I$
CMP #&A4         :\ E219= C9 A4       I$
CMP #&C3         :\ E21B= C9 C3       IC
CMP #&2D         :\ E21D= C9 2D       I-
DEX              :\ E21F= CA          J
EQUB &C3         :\ E220= C3          C
CMP #&2D         :\ E221= C9 2D       I-
DEX              :\ E223= CA          J
SBC (&CA),Y      :\ E224= F1 CA       qJ
SBC (&CA),Y      :\ E226= F1 CA       qJ
PLX              :\ E228= FA          z
DEX              :\ E229= CA          J
PLX              :\ E22A= FA          z
DEX              :\ E22B= CA          J
.LE22C
ASL A            :\ E22C= 0A          .
ROL A            :\ E22D= 2A          *
ROL A            :\ E22E= 2A          *
TAY              :\ E22F= A8          (
AND #&03         :\ E230= 29 03       ).
ROL A            :\ E232= 2A          *
ADC #&88         :\ E233= 69 88       i.
STA &DF          :\ E235= 85 DF       ._
TYA              :\ E237= 98          .
.LE238
AND #&F8         :\ E238= 29 F8       )x
.LE23A
STA &DE          :\ E23A= 85 DE       .^
RTS              :\ E23C= 60          `
 
.LE23D
JSR LF3AB        :\ E23D= 20 AB F3     +s
BIT &D0          :\ E240= 24 D0       $P
BVC LE252        :\ E242= 50 0E       P.
JSR LE2AE        :\ E244= 20 AE E2     .b
JSR LE252        :\ E247= 20 52 E2     Rb
PHX              :\ E24A= DA          Z
PHY              :\ E24B= 5A          Z
JSR LE2AE        :\ E24C= 20 AE E2     .b
PLY              :\ E24F= 7A          z
PLX              :\ E250= FA          z
RTS              :\ E251= 60          `
 
.LE252
JSR LE26D        :\ E252= 20 6D E2     mb
BIT &036C        :\ E255= 2C 6C 03    ,l.
BPL LE25B        :\ E258= 10 01       ..
INX              :\ E25A= E8          h
.LE25B
RTS              :\ E25B= 60          `
 
.LE25C
SEC              :\ E25C= 38          8
LDA &030A        :\ E25D= AD 0A 03    -..
SBC &0308        :\ E260= ED 08 03    m..
PHA              :\ E263= 48          H
LDA #&00         :\ E264= A9 00       ).
TAY              :\ E266= A8          (
BRA LE279        :\ E267= 80 10       ..

.LE269
BIT &D0          :\ E269= 24 D0       $P
BVC LE23D        :\ E26B= 50 D0       PP
.LE26D
LDA #&02         :\ E26D= A9 02       ).
LDY #&10         :\ E26F= A0 10        .
LDX #&00         :\ E271= A2 00       ".
JSR LE28A        :\ E273= 20 8A E2     .b
PHA              :\ E276= 48          H
LDA #&04         :\ E277= A9 04       ).
.LE279
INY              :\ E279= C8          H
LDX #&03         :\ E27A= A2 03       ".
JSR LE28A        :\ E27C= 20 8A E2     .b
TAX              :\ E27F= AA          *
TAY              :\ E280= A8          (
LDA #&08         :\ E281= A9 08       ).
BIT &0366        :\ E283= 2C 66 03    ,f.
BEQ LE2AC        :\ E286= F0 24       p$
PLY              :\ E288= 7A          z
RTS              :\ E289= 60          `
 
.LE28A
SEC              :\ E28A= 38          8
BIT &0366        :\ E28B= 2C 66 03    ,f.
BEQ LE29B        :\ E28E= F0 0B       p.
TXA              :\ E290= 8A          .
EOR #&02         :\ E291= 49 02       I.
TAX              :\ E293= AA          *
LDA &0308,X      :\ E294= BD 08 03    =..
SBC &0308,Y      :\ E297= F9 08 03    y..
RTS              :\ E29A= 60          `
 
.LE29B
LDA &0308,Y      :\ E29B= B9 08 03    9..
SBC &0308,X      :\ E29E= FD 08 03    }..
RTS              :\ E2A1= 60          `
 
.LE2A2
LDX &0355        :\ E2A2= AE 55 03    .U.
LDY LE109,X      :\ E2A5= BC 09 E1    <.a
PHY              :\ E2A8= 5A          Z
LDY LE101,X      :\ E2A9= BC 01 E1    <.a
.LE2AC
PLX              :\ E2AC= FA          z
RTS              :\ E2AD= 60          `
 
.LE2AE
LDX #&18         :\ E2AE= A2 18       ".
LDY #&64         :\ E2B0= A0 64        d
.LE2B2
LDA #&02         :\ E2B2= A9 02       ).
BRA LE2BC        :\ E2B4= 80 06       ..
 
.LE2B6
LDX #&24         :\ E2B6= A2 24       "$
.LE2B8
LDY #&14         :\ E2B8= A0 14        .
.LE2BA
LDA #&04         :\ E2BA= A9 04       ).
.LE2BC
PHA              :\ E2BC= 48          H
LDA &0300,X      :\ E2BD= BD 00 03    =..
PHA              :\ E2C0= 48          H
LDA &0300,Y      :\ E2C1= B9 00 03    9..
STA &0300,X      :\ E2C4= 9D 00 03    ...
PLA              :\ E2C7= 68          h
STA &0300,Y      :\ E2C8= 99 00 03    ...
INX              :\ E2CB= E8          h
INY              :\ E2CC= C8          H
PLA              :\ E2CD= 68          h
DEC A            :\ E2CE= 3A          :
BNE LE2BC        :\ E2CF= D0 EB       Pk
RTS              :\ E2D1= 60          `
 
.LE2D2
LDA &D0          :\ E2D2= A5 D0       %P
AND #&20         :\ E2D4= 29 20       ) 
.LE2D6
RTS              :\ E2D6= 60          `

\ Default vector table
\ ====================
.LE2D7
SBC &65FB        :\ E2D7= ED FB 65    m{e
SBC &FF          :\ E2DA= E5 FF       e.
SBC &0C          :\ E2DC= E5 0C       e.
INC &02          :\ E2DE= E6 02       f.
INX              :\ E2E0= E8          h
LDA (&EE),Y      :\ E2E1= B1 EE       1n
AND &22EF,Y      :\ E2E3= 39 EF 22    9o"
INX              :\ E2E6= E8          h
\LDY &1BE7,X      :\ E2E7= BC E7 1B    <g.
EQUB &BC
.LE2E8
EQUB &E7
EQUB &1B
EQUB &FF         :\ E2EA= FF          .
ASL &21FF,X      :\ E2EB= 1E FF 21    ..!
EQUB &FF         :\ E2EE= FF          .
BIT &FF          :\ E2EF= 24 FF       $.
EQUB &27         :\ E2F1= 27          '
EQUB &FF         :\ E2F2= FF          .
ROL A            :\ E2F3= 2A          *
EQUB &FF         :\ E2F4= FF          .
AND LAAFF        :\ E2F5= 2D FF AA    -.*
EQUB &FF         :\ E2F8= FF          .
TAX              :\ E2F9= AA          *
EQUB &FF         :\ E2FA= FF          .
TAX              :\ E2FB= AA          *
EQUB &FF         :\ E2FC= FF          .
TAX              :\ E2FD= AA          *
EQUB &FF         :\ E2FE= FF          .
JMP &43F7        :\ E2FF= 4C F7 43    LwC
 
NOP              :\ E302= EA          j
SED              :\ E303= F8          x
SBC #&7B         :\ E304= E9 7B       i{
SBC #&AA         :\ E306= E9 AA       i*
EQUB &FF         :\ E308= FF          .
TAX              :\ E309= AA          *
EQUB &FF         :\ E30A= FF          .
TAX              :\ E30B= AA          *
EQUB &FF         :\ E30C= FF          .
BCC LE310        :\ E30D= 90 01       ..
EQUB &9F         :\ E30F= 9F          .
.LE310
ORA &02A1        :\ E310= 0D A1 02    .!.
EQUB &82         :\ E313= 82          .
SED              :\ E314= F8          x
BRK              :\ E315= 00          .
EQUB &03         :\ E316= 03          .
BRK              :\ E317= 00          .
BRK              :\ E318= 00          .
EQUB &FF         :\ E319= FF          .
BRK              :\ E31A= 00          .
BRK              :\ E31B= 00          .
ORA (&00,X)      :\ E31C= 01 00       ..
BRK              :\ E31E= 00          .
BRK              :\ E31F= 00          .
BRK              :\ E320= 00          .
BRK              :\ E321= 00          .
EQUB &FF         :\ E322= FF          .
TSB &04          :\ E323= 04 04       ..
BRK              :\ E325= 00          .
EQUB &FF         :\ E326= FF          .
EQUB &42         :\ E327= 42          B
ORA &1919,Y      :\ E328= 19 19 19    ...
AND (&08)        :\ E32B= 32 08       2.
BRK              :\ E32D= 00          .
BRK              :\ E32E= 00          .
BRK              :\ E32F= 00          .
BRK              :\ E330= 00          .
JSR &0009        :\ E331= 20 09 00     ..
BRK              :\ E334= 00          .
BRK              :\ E335= 00          .
BRK              :\ E336= 00          .
BRK              :\ E337= 00          .
BRK              :\ E338= 00          .
BRK              :\ E339= 00          .
EQUB &03         :\ E33A= 03          .
BCC LE3A1        :\ E33B= 90 64       .d
ASL &81          :\ E33D= 06 81       ..
BRK              :\ E33F= 00          .
BRK              :\ E340= 00          .
BRK              :\ E341= 00          .
ORA #&1B         :\ E342= 09 1B       ..
ORA (&D0,X)      :\ E344= 01 D0       .P
CPX #&F0         :\ E346= E0 F0       `p
ORA (&80,X)      :\ E348= 01 80       ..
BCC LE34C        :\ E34A= 90 00       ..
.LE34C
BRK              :\ E34C= 00          .
BRK              :\ E34D= 00          .
.LE34E
EQUB &FF         :\ E34E= FF          .
EQUB &FF         :\ E34F= FF          .
EQUB &FF         :\ E350= FF          .
BRK              :\ E351= 00          .
BRK              :\ E352= 00          .
BRK              :\ E353= 00          .
BRK              :\ E354= 00          .
BMI LE358        :\ E355= 30 01       0.
BRK              :\ E357= 00          .
.LE358
BRK              :\ E358= 00          .
STZ &05          :\ E359= 64 05       d.
EQUB &FF         :\ E35B= FF          .
ORA (&0A,X)      :\ E35C= 01 0A       ..
BRK              :\ E35E= 00          .
BRK              :\ E35F= 00          .
BRK              :\ E360= 00          .
BRK              :\ E361= 00          .
BRK              :\ E362= 00          .
EQUB &FF         :\ E363= FF          .

\ STARTUP
\ =======
.LE364
LDA #&40:STA &0D00:SEI    :\ Disable NMIs and IRQs
LDA #&53:STA LFE8E        :\
JSR LE590:JMP L8020       :\ Page in ROM 15 and continue

\ Check if a coprocessor is attached to the Tube
\ ----------------------------------------------
.LE375
LDX #&01:STX TUBE+0        :\ 
LDA TUBE+0:EOR #&01        :\ 
LDX #&81:STX TUBE+0        :\ 
AND TUBE+0:ROR A           :\ Cy=0 if no Tube, Cy=1 if Tube
RTS
 
.LE389
PHY              :\ E389= 5A          Z
PHX              :\ E38A= DA          Z
JSR LE9BB        :\ E38B= 20 BB E9     ;i
STA &FC          :\ E38E= 85 FC       .|
JSR LE590        :\ E390= 20 90 E5     .e
JSR L98B7        :\ E393= 20 B7 98     7.
TYA              :\ E396= 98          .
AND &FC          :\ E397= 25 FC       %|
CMP #&01         :\ E399= C9 01       I.
PLX              :\ E39B= FA          z
PLY              :\ E39C= 7A          z
JMP LE581        :\ E39D= 4C 81 E5    L.e
 
.LE3A0
TXA              :\ E3A0= 8A          .
.LE3A1
TAY              :\ E3A1= A8          (
JSR LE389        :\ E3A2= 20 89 E3     .c
BCC LE3DB        :\ E3A5= 90 34       .4
JSR LE3F7        :\ E3A7= 20 F7 E3     wc
BCC LE3DB        :\ E3AA= 90 2F       ./
LDX &F4          :\ E3AC= A6 F4       &t
LDY &F4          :\ E3AE= A4 F4       $t
.LE3B0
INY              :\ E3B0= C8          H
CPY #&10         :\ E3B1= C0 10       @.
BCS LE3DF        :\ E3B3= B0 2A       0*
JSR LE389        :\ E3B5= 20 89 E3     .c
BCC LE3B0        :\ E3B8= 90 F6       .v
TYA              :\ E3BA= 98          .
EOR #&FF         :\ E3BB= 49 FF       I.
STA &FA          :\ E3BD= 85 FA       .z
LDA #&7F         :\ E3BF= A9 7F       ).
STA &FB          :\ E3C1= 85 FB       .{
.LE3C3
STY ROMSEL        :\ E3C3= 8C 30 FE    .0~
LDA (&FA),Y      :\ E3C6= B1 FA       1z
STX ROMSEL        :\ E3C8= 8E 30 FE    .0~
CMP (&FA),Y      :\ E3CB= D1 FA       Qz
BNE LE3B0        :\ E3CD= D0 E1       Pa
INC &FA          :\ E3CF= E6 FA       fz
BNE LE3C3        :\ E3D1= D0 F0       Pp
INC &FB          :\ E3D3= E6 FB       f{
LDA &FB          :\ E3D5= A5 FB       %{
CMP #&84         :\ E3D7= C9 84       I.
BCC LE3C3        :\ E3D9= 90 E8       .h
.LE3DB
LDX &F4          :\ E3DB= A6 F4       &t
BRA LE3EC        :\ E3DD= 80 0D       ..
 
.LE3DF
LDA L8006        :\ E3DF= AD 06 80    -..
STA &02A1,X      :\ E3E2= 9D A1 02    .!.
AND #&8F         :\ E3E5= 29 8F       ).
BNE LE3EC        :\ E3E7= D0 03       P.
STX &024B        :\ E3E9= 8E 4B 02    .K.
.LE3EC
INX              :\ E3EC= E8          h
CPX #&10         :\ E3ED= E0 10       `.
BCC LE3A0        :\ E3EF= 90 AF       ./
JSR LE590        :\ E3F1= 20 90 E5     .e
JMP L8224        :\ E3F4= 4C 24 82    L$.
 
.LE3F7
JSR LE581        :\ E3F7= 20 81 E5     .e
LDX #&03         :\ E3FA= A2 03       ".
LDY L8007        :\ E3FC= AC 07 80    ,..
CLC              :\ E3FF= 18          .
.LE400
LDA L8000,Y      :\ E400= B9 00 80    9..
EOR LE513,X      :\ E403= 5D 13 E5    ].e
BNE LE40D        :\ E406= D0 05       P.
INY              :\ E408= C8          H
DEX              :\ E409= CA          J
BPL LE400        :\ E40A= 10 F4       .t
SEC              :\ E40C= 38          8
.LE40D
RTS              :\ E40D= 60          `
 
\ End of STARTUP code
\ ===================
.LE40E
SEC:JSR LF349        :\ Call Break Intercept Vector
LDX #&27:JSR LEE72   :\ Service call &27 - Break pressed
LDY &0256:BEQ LE424  :\ Get Exec handle, skip past if closed
STZ &0256            :\ Clear Exec handle
LDA #&00:JSR OSFIND  :\ Close Exec channel
.LE424
SEC:ROR HAZEL_WORKSPACE+&00        :\ 
LDA &028D:BEQ LE431  :\ Soft Break
SEC:ROR HAZEL_WORKSPACE+&02        :\ 
.LE431
JSR LEE64                :\ Set default ROMFS/TAPEFS settings
JSR LF230                :\ Test Shift and Ctrl keys
LSR A:LSR A:LSR A:LSR A  :\ Move SHIFT status from b7 to b3
EOR &028F:AND #&08:TAY   :\ Toggle with OSBYTE 255 boot status
LDX HAZEL_WORKSPACE+&03                :\ Get current filing system
LDA &028D:BEQ LE454      :\ Soft Break, use current filing system
JSR LE590                :\ E449= 20 90 E5     .e
.LE44C
PHY              :\ E44C= 5A          Z
JSR L8EA4        :\ E44D= 20 A4 8E     $.
AND #&0F         :\ E450= 29 0F       ).
PLY              :\ E452= 7A          z
TAX              :\ E453= AA          *
.LE454
BIT &02A1,X      :\ E454= 3C A1 02    <!.
BPL LE478        :\ E457= 10 1F       ..
JSR LE581        :\ E459= 20 81 E5     .e
CPX #&0F         :\ E45C= E0 0F       `.
BNE LE46C        :\ E45E= D0 0C       P.
JSR LF910        :\ E460= 20 10 F9     .y
INX              :\ E463= E8          h
BEQ LE47F        :\ E464= F0 19       p.
CPX #&63         :\ E466= E0 63       `c
BEQ LE47F        :\ E468= F0 15       p.
BRA LE478        :\ E46A= 80 0C       ..
 
.LE46C
LDA #&03:JSR L8003        :\ Filing System selection
TAX              :\ E471= AA          *
JSR LE590        :\ E472= 20 90 E5     .e
TXA              :\ E475= 8A          .
BEQ LE4A3        :\ E476= F0 2B       p+
.LE478
LDX #&03:JSR LEE72        :\ E47A= 20 72 EE     rn
BEQ LE4A3        :\ E47D= F0 24       p$
.LE47F
TYA              :\ E47F= 98          .
BNE LE499        :\ E480= D0 17       P.
LDA #&8D         :\ E482= A9 8D       ).
JSR LED9A        :\ E484= 20 9A ED     .m
LDX #&08         :\ E487= A2 08       ".
LDY #&F4         :\ E489= A0 F4        t
DEC &0267        :\ E48B= CE 67 02    Ng.
JSR OS_CLI       :\ E48E= 20 F7 FF     w.
INC &0267        :\ E491= EE 67 02    ng.
BRA LE4A3        :\ E494= 80 0D       ..
 
.LE496
INC &0267        :\ E496= EE 67 02    ng.
.LE499
SEC              :\ E499= 38          8
ROR HAZEL_WORKSPACE+&00        :\ E49A= 6E 00 DF    n._
LDA #&00         :\ E49D= A9 00       ).
TAX              :\ E49F= AA          *
JSR LEDC2        :\ E4A0= 20 C2 ED     Bm
.LE4A3
LDA #&05            :\
LDX &0285:JSR LEEB1 :\ *FX5,<current printer>
LDA &028D:BNE LE4BB :\ If not Soft Break, select default language
LDX &028C           :\ Get current language ROM
CPX #&10:BCC LE4C2  :\ <16, normal ROM number, use it
CPX #&1F:BEQ LE509  :\ 16+UTILS ROM, re-enter Supervisor or Tube CLI
.LE4BB
JSR LE590           :\ Page in ROM 15 - UTILS ROM
JSR L8E9C:TAX       :\ Read configured LANG
.LE4C2
CLC
.LE4C3
BIT &02A1,X:BVC LE516 :\ b6=0, error Not a language
PHP              :\ E4C8= 08          .
BCC LE4E1        :\ E4C9= 90 16       ..
JSR LE581        :\ E4CB= 20 81 E5     .e
LDA L8006        :\ E4CE= AD 06 80    -..
AND #&0D         :\ E4D1= 29 0D       ).
BEQ LE4DA        :\ E4D3= F0 05       p.
BIT &027A        :\ E4D5= 2C 7A 02    ,z.
BPL LE52E        :\ E4D8= 10 54       .T
.LE4DA
PHX              :\ E4DA= DA          Z
LDX #&2A:JSR LEE72        :\ E4DD= 20 72 EE     rn
PLX              :\ E4E0= FA          z
.LE4E1
STX &028C        :\ E4E1= 8E 8C 02    ...
JSR LE581        :\ E4E4= 20 81 E5     .e
LDA #&80         :\ E4E7= A9 80       ).
LDY #&08         :\ E4E9= A0 08        .
JSR LE7A3        :\ E4EB= 20 A3 E7     #g
STY &FD          :\ E4EE= 84 FD       .}
JSR OSNEWL       :\ E4F0= 20 E7 FF     g.
JSR OSNEWL       :\ E4F3= 20 E7 FF     g.
PLP              :\ E4F6= 28          (
LDA #&01         :\ E4F7= A9 01       ).
BIT &027A        :\ E4F9= 2C 7A 02    ,z.
BMI LE510        :\ E4FC= 30 12       0.
LDA L8006        :\ E4FE= AD 06 80    -..
AND #&0D         :\ E501= 29 0D       ).
BNE LE52E        :\ E503= D0 29       P)
INC A            :\ E505= 1A          .
JMP L8000        :\ E506= 4C 00 80    L..
 
.LE509
LDA #&00         :\ E509= A9 00       ).
BIT &027A        :\ E50B= 2C 7A 02    ,z.
BPL LE579        :\ E50E= 10 69       .i
.LE510
JMP &0400        :\ E510= 4C 00 04    L..
 
.LE513
AND #&43         :\ E513= 29 43       )C
PLP              :\ E515= 28          (
.LE516
BRK              :\ E516= 00          .
BRK              :\ E517= 00          .
EQUB &54         :\ E518= 54          T
PLA              :\ E519= 68          h
ADC #&73         :\ E51A= 69 73       is
JSR &7369        :\ E51C= 20 69 73     is
JSR &6F6E        :\ E51F= 20 6E 6F     no
STZ &20,X        :\ E522= 74 20       t 
ADC (&20,X)      :\ E524= 61 20       a 
JMP (&6E61)      :\ E526= 6C 61 6E    lan
 
EQUB &67         :\ E529= 67          g
ADC &61,X        :\ E52A= 75 61       ua
EQUB &67         :\ E52C= 67          g
\ADC &00          :\ E52D= 65 00       e.
EQUB &65
; BRK              :\ E52F= 00          .
; EOR #&20         :\ E530= 49 20       I 
; EQUB &63         :\ E532= 63          c
; ADC (&6E,X)      :\ E533= 61 6E       an
; ROR &746F        :\ E535= 6E 6F 74    not
; JSR &7572        :\ E538= 20 72 75     ru
; ROR &7420        :\ E53B= 6E 20 74    n t
; PLA              :\ E53E= 68          h
; ADC #&73         :\ E53F= 69 73       is
; JSR &6F63        :\ E541= 20 63 6F     co
; STZ &65          :\ E544= 64 65       de
; BRK              :\ E546= 00          .
.LE52E
brk
EQUB &00
EQUS "I cannot run this code":EQUB &00
.LE547
LDX #&03         :\ E547= A2 03       ".
LDY #&07         :\ E549= A0 07        .
LDA (&F0),Y      :\ E54B= B1 F0       1p
TAY              :\ E54D= A8          (
.LE54E
LDA (&F0),Y      :\ E54E= B1 F0       1p
CMP LE513,X      :\ E550= DD 13 E5    ].e
BNE LE564        :\ E553= D0 0F       P.
INY              :\ E555= C8          H
DEX              :\ E556= CA          J
BPL LE54E        :\ E557= 10 F5       .u
LDY #&06         :\ E559= A0 06        .
LDA (&F0),Y      :\ E55B= B1 F0       1p
ASL A            :\ E55D= 0A          .
BPL LE516        :\ E55E= 10 B6       .6
AND #&1A         :\ E560= 29 1A       ).
BNE LE52E        :\ E562= D0 CA       PJ
.LE564
RTS              :\ E564= 60          `
 
LDY #&00         :\ E565= A0 00        .
JSR LE7A7        :\ E567= 20 A7 E7     'g
JSR OSNEWL       :\ E56A= 20 E7 FF     g.
LDA &0267        :\ E56D= AD 67 02    -g.
ROR A            :\ E570= 6A          j
BCS LE579        :\ E571= B0 06       0.
JSR OSNEWL       :\ E573= 20 E7 FF     g.
JMP LE496        :\ E576= 4C 96 E4    L.d
 
.LE579
JSR LE590        :\ E579= 20 90 E5     .e
JMP L8661        :\ E57C= 4C 61 86    La.
 
.LE57F
LDX #&8F         :\ E57F= A2 8F       ".
.LE581
STX &F4          :\ E581= 86 F4       .t
STX ROMSEL        :\ E583= 8E 30 FE    .0~
RTS              :\ E586= 60          `
 
.LE587
PHY              :\ E587= 5A          Z
JSR LE3F7        :\ E588= 20 F7 E3     wc
JSR LE590        :\ E58B= 20 90 E5     .e
PLY              :\ E58E= 7A          z
RTS              :\ E58F= 60          `
 
.LE590
LDA #&0F         :\ E590= A9 0F       ).
.LE592
STA &F4          :\ E592= 85 F4       .t
STA ROMSEL        :\ E594= 8D 30 FE    .0~
RTS              :\ E597= 60          `
 
.LE598
PHX              :\ E598= DA          Z
JSR LE57F        :\ E599= 20 7F E5     .e
PLX              :\ E59C= FA          z
RTS              :\ E59D= 60          `

.LE59E
STA &FC          :\ E59E= 85 FC       .|
PLA              :\ E5A0= 68          h
PHA              :\ E5A1= 48          H
AND #&10         :\ E5A2= 29 10       ).
BNE LE5A9        :\ E5A4= D0 03       P.
JMP (&0204)      :\ E5A6= 6C 04 02    l..
 
.LE5A9
PHX              :\ E5A9= DA          Z
TSX              :\ E5AA= BA          :
LDA &0103,X      :\ E5AB= BD 03 01    =..
CLD              :\ E5AE= D8          X
SEC              :\ E5AF= 38          8
SBC #&01         :\ E5B0= E9 01       i.
STA &FD          :\ E5B2= 85 FD       .}
LDA &0104,X      :\ E5B4= BD 04 01    =..
SBC #&00         :\ E5B7= E9 00       i.
STA &FE          :\ E5B9= 85 FE       .~
LDA &F4          :\ E5BB= A5 F4       %t
STA &024A        :\ E5BD= 8D 4A 02    .J.
STX &F0          :\ E5C0= 86 F0       .p
LDX #&06:JSR LEE72        :\ E5C4= 20 72 EE     rn
LDX &028C        :\ E5C7= AE 8C 02    ...
JSR LE581        :\ E5CA= 20 81 E5     .e
PLX              :\ E5CD= FA          z
LDA &FC          :\ E5CE= A5 FC       %|
CLI              :\ E5D0= 58          X
JMP (&0202)      :\ E5D1= 6C 02 02    l..
 
.LE5D4
SEC              :\ E5D4= 38          8
ROR &024F        :\ E5D5= 6E 4F 02    nO.
BIT &0250        :\ E5D8= 2C 50 02    ,P.
BPL LE5E4        :\ E5DB= 10 07       ..
JSR LED27        :\ E5DD= 20 27 ED     'm
LDX #&00         :\ E5E0= A2 00       ".
BCS LE5E6        :\ E5E2= B0 02       0.
.LE5E4
LDX #&40         :\ E5E4= A2 40       "@
.LE5E6
JMP LE912        :\ E5E6= 4C 12 E9    L.i
 
.LE5E9
LDY LFE09        :\ E5E9= AC 09 FE    ,.~
AND #&3A         :\ E5EC= 29 3A       ):
BNE LE628        :\ E5EE= D0 38       P8
LDX &025C        :\ E5F0= AE 5C 02    .\.
BNE LE5FE        :\ E5F3= D0 09       P.
INX              :\ E5F5= E8          h
JSR LEA80        :\ E5F6= 20 80 EA     .j
JSR LED27        :\ E5F9= 20 27 ED     'm
BCC LE5E4        :\ E5FC= 90 E6       .f
.LE5FE
RTS              :\ E5FE= 60          `
 
LDA &FC          :\ E5FF= A5 FC       %|
PHA              :\ E601= 48          H
PHX              :\ E602= DA          Z
PHY              :\ E603= 5A          Z
CLV              :\ E604= B8          8
JSR LE60F        :\ E605= 20 0F E6     .f
PLY              :\ E608= 7A          z
PLX              :\ E609= FA          z
PLA              :\ E60A= 68          h
RTI              :\ E60B= 40          @
 
LDA &FC          :\ E60C= A5 FC       %|
RTI              :\ E60E= 40          @
 
.LE60F
LDA LFE08        :\ E60F= AD 08 FE    -.~
BVS LE616        :\ E612= 70 02       p.
BPL LE672        :\ E614= 10 5C       .\
.LE616
LDX &EA          :\ E616= A6 EA       &j
DEX              :\ E618= CA          J
BMI LE64E        :\ E619= 30 33       03
BVS LE64D        :\ E61B= 70 30       p0
JSR LF384        :\ E61D= 20 84 F3     .s
JMP LA45D        :\ E620= 4C 5D A4    L]$
 
.LE623
LDY LFE09        :\ E623= AC 09 FE    ,.~
ROL A            :\ E626= 2A          *
ASL A            :\ E627= 0A          .
.LE628
TAX              :\ E628= AA          *
TYA              :\ E629= 98          .
LDY #&07         :\ E62A= A0 07        .
JMP LEA28        :\ E62C= 4C 28 EA    L(j
 
.LE62F
LDX #&02         :\ E62F= A2 02       ".
JSR LE9F4        :\ E631= 20 F4 E9     ti
BCC LE646        :\ E634= 90 10       ..
LDA &0285        :\ E636= AD 85 02    -..
CMP #&02         :\ E639= C9 02       I.
BNE LE5D4        :\ E63B= D0 97       P.
INX              :\ E63D= E8          h
JSR LE9F4        :\ E63E= 20 F4 E9     ti
ROR &02D1        :\ E641= 6E D1 02    nQ.
BMI LE5D4        :\ E644= 30 8E       0.
.LE646
STA LFE09        :\ E646= 8D 09 FE    ..~
LDA #&E7         :\ E649= A9 E7       )g
STA &EA          :\ E64B= 85 EA       .j
.LE64D
RTS              :\ E64D= 60          `
 
.LE64E
AND &0278        :\ E64E= 2D 78 02    -x.
LSR A            :\ E651= 4A          J
BCC LE65B        :\ E652= 90 07       ..
BVS LE65B        :\ E654= 70 05       p.
LDY &0250        :\ E656= AC 50 02    ,P.
BMI LE5E9        :\ E659= 30 8E       0.
.LE65B
LSR A            :\ E65B= 4A          J
ROR A            :\ E65C= 6A          j
BCS LE623        :\ E65D= B0 C4       0D
BMI LE62F        :\ E65F= 30 CE       0N
BVS LE64D        :\ E661= 70 EA       pj
.LE663
LDX #&05:JSR LEE72        :\ E665= 20 72 EE     rn
BEQ LE64D        :\ E668= F0 E3       pc
PLA              :\ E66A= 68          h
PLA              :\ E66B= 68          h
PLY              :\ E66C= 7A          z
PLX              :\ E66D= FA          z
PLA              :\ E66E= 68          h
JMP (&0206)      :\ E66F= 6C 06 02    l..
 
.LE672
LDA SYSTEM_VIA+&D        :\ E672= AD 4D FE    -M~
BPL LE6B3        :\ E675= 10 3C       .<
AND &0279        :\ E677= 2D 79 02    -y.
AND SYSTEM_VIA+&E        :\ E67A= 2D 4E FE    -N~
BIT #&02         :\ E67D= 89 02       ..
BEQ LE6D5        :\ E67F= F0 54       pT
DEC &0240        :\ E681= CE 40 02    N@.
LDA &EA          :\ E684= A5 EA       %j
BPL LE68A        :\ E686= 10 02       ..
INC &EA          :\ E688= E6 EA       fj
.LE68A
LDA &0251        :\ E68A= AD 51 02    -Q.
BEQ LE6A9        :\ E68D= F0 1A       p.
DEC &0251        :\ E68F= CE 51 02    NQ.
BNE LE6A9        :\ E692= D0 15       P.
LDX &0252        :\ E694= AE 52 02    .R.
LDA &0248        :\ E697= AD 48 02    -H.
LSR A            :\ E69A= 4A          J
BCC LE6A0        :\ E69B= 90 03       ..
LDX &0253        :\ E69D= AE 53 02    .S.
.LE6A0
ROL A            :\ E6A0= 2A          *
EOR #&01         :\ E6A1= 49 01       I.
JSR LF250        :\ E6A3= 20 50 F2     Pr
STX &0251        :\ E6A6= 8E 51 02    .Q.
.LE6A9
LDY #&04         :\ E6A9= A0 04        .
JSR LEA28        :\ E6AB= 20 28 EA     (j
LDA #&02         :\ E6AE= A9 02       ).
JMP LE78A        :\ E6B0= 4C 8A E7    L.g
 
.LE6B3
LDA USER_VIA+&D        :\ E6B3= AD 6D FE    -m~
BPL LE663        :\ E6B6= 10 AB       .+
AND &0277        :\ E6B8= 2D 77 02    -w.
AND USER_VIA+&E        :\ E6BB= 2D 6E FE    -n~
ROR A            :\ E6BE= 6A          j
ROR A            :\ E6BF= 6A          j
BCC LE663        :\ E6C0= 90 A1       .!
LDY &0285        :\ E6C2= AC 85 02    ,..
DEY              :\ E6C5= 88          .
BNE LE663        :\ E6C6= D0 9B       P.
LDA #&02         :\ E6C8= A9 02       ).
STA USER_VIA+&D        :\ E6CA= 8D 6D FE    .m~
STA USER_VIA+&E        :\ E6CD= 8D 6E FE    .n~
LDX #&03         :\ E6D0= A2 03       ".
JMP LE8D5        :\ E6D2= 4C D5 E8    LUh
 
.LE6D5
BIT #&40         :\ E6D5= 89 40       .@
BEQ LE74E        :\ E6D7= F0 75       pu
LDA #&40         :\ E6D9= A9 40       )@
STA SYSTEM_VIA+&D        :\ E6DB= 8D 4D FE    .M~
LDA &0283        :\ E6DE= AD 83 02    -..
TAX              :\ E6E1= AA          *
EOR #&0F         :\ E6E2= 49 0F       I.
PHA              :\ E6E4= 48          H
TAY              :\ E6E5= A8          (
SEC              :\ E6E6= 38          8
.LE6E7
LDA &0291,X      :\ E6E7= BD 91 02    =..
ADC #&00         :\ E6EA= 69 00       i.
STA &0291,Y      :\ E6EC= 99 91 02    ...
DEX              :\ E6EF= CA          J
BEQ LE6F5        :\ E6F0= F0 03       p.
DEY              :\ E6F2= 88          .
BNE LE6E7        :\ E6F3= D0 F2       Pr
.LE6F5
PLA              :\ E6F5= 68          h
STA &0283        :\ E6F6= 8D 83 02    ...
LDX #&05         :\ E6F9= A2 05       ".
.LE6FB
INC &029B,X      :\ E6FB= FE 9B 02    ~..
BNE LE708        :\ E6FE= D0 08       P.
DEX              :\ E700= CA          J
BNE LE6FB        :\ E701= D0 F8       Px
LDY #&05         :\ E703= A0 05        .
JSR LEA28        :\ E705= 20 28 EA     (j
.LE708
LDA &02B1        :\ E708= AD B1 02    -1.
BNE LE715        :\ E70B= D0 08       P.
LDA &02B2        :\ E70D= AD B2 02    -2.
BEQ LE718        :\ E710= F0 06       p.
DEC &02B2        :\ E712= CE B2 02    N2.
.LE715
DEC &02B1        :\ E715= CE B1 02    N1.
.LE718
BIT &02CD        :\ E718= 2C CD 02    ,M.
BPL LE728        :\ E71B= 10 0B       ..
INC &02CD        :\ E71D= EE CD 02    nM.
CLI              :\ E720= 58          X
JSR LF416        :\ E721= 20 16 F4     .t
SEI              :\ E724= 78          x
DEC &02CD        :\ E725= CE CD 02    NM.
.LE728
BIT LE34E        :\ E728= 2C 4E E3    ,Nc
JSR LE60F        :\ E72B= 20 0F E6     .f
LDA &EC          :\ E72E= A5 EC       %l
ORA &ED          :\ E730= 05 ED       .m
AND &0242        :\ E732= 2D 42 02    -B.
BEQ LE73B        :\ E735= F0 04       p.
SEC              :\ E737= 38          8
JSR LF8FF        :\ E738= 20 FF F8     .x
.LE73B
JSR LE933        :\ E73B= 20 33 E9     3i
LDY &0243        :\ E73E= AC 43 02    ,C.
BEQ LE748        :\ E741= F0 05       p.
LDX #&15:JSR LEE72        :\ E745= 20 72 EE     rn
.LE748
BIT ADC+0        :\ E748= 2C 18 FE    ,.~
BVS LE752        :\ E74B= 70 05       p.
RTS              :\ E74D= 60          `
 
.LE74E
BIT #&10         :\ E74E= 89 10       ..
BEQ LE78E        :\ E750= F0 3C       p<
.LE752
LDX &024C        :\ E752= AE 4C 02    .L.
BEQ LE788        :\ E755= F0 31       p1
LDA ADC+2        :\ E757= AD 1A FE    -.~
STA &02B5,X      :\ E75A= 9D B5 02    .5.
LDA ADC+1        :\ E75D= AD 19 FE    -.~
STA &02B9,X      :\ E760= 9D B9 02    .9.
STX &02BE        :\ E763= 8E BE 02    .>.
LDY #&03         :\ E766= A0 03        .
JSR LEA28        :\ E768= 20 28 EA     (j
DEX              :\ E76B= CA          J
BNE LE771        :\ E76C= D0 03       P.
LDX &024D        :\ E76E= AE 4D 02    .M.
.LE771
CPX #&05         :\ E771= E0 05       `.
BCC LE777        :\ E773= 90 02       ..
LDX #&04         :\ E775= A2 04       ".
.LE777
STX &024C        :\ E777= 8E 4C 02    .L.
LDA &024E        :\ E77A= AD 4E 02    -N.
DEC A            :\ E77D= 3A          :
AND #&08         :\ E77E= 29 08       ).
CLC              :\ E780= 18          .
ADC &024C        :\ E781= 6D 4C 02    mL.
DEC A            :\ E784= 3A          :
STA ADC+0        :\ E785= 8D 18 FE    ..~
.LE788
LDA #&10         :\ E788= A9 10       ).
.LE78A
STA SYSTEM_VIA+&D        :\ E78A= 8D 4D FE    .M~
RTS              :\ E78D= 60          `
 
.LE78E
LSR A            :\ E78E= 4A          J
BCC LE799        :\ E78F= 90 08       ..
CLC              :\ E791= 18          .
JSR LF8FF        :\ E792= 20 FF F8     .x
LDA #&01         :\ E795= A9 01       ).
BRA LE78A        :\ E797= 80 F1       .q
 
.LE799
JMP LE663        :\ E799= 4C 63 E6    Lcf
 
.LE79C
STY &02BE        :\ E79C= 8C BE 02    .>.
BRA LE771        :\ E79F= 80 D0       .P
 
.LE7A1
LDA #&E0         :\ E7A1= A9 E0       )`
.LE7A3
STA &FE          :\ E7A3= 85 FE       .~
STZ &FD          :\ E7A5= 64 FD       d}
.LE7A7
INY              :\ E7A7= C8          H
LDA (&FD),Y      :\ E7A8= B1 FD       1}
JSR OSASCI       :\ E7AA= 20 E3 FF     c.
TAX              :\ E7AD= AA          *
BNE LE7A7        :\ E7AE= D0 F7       Pw
RTS              :\ E7B0= 60          `
 
.LE7B1
STX &02B1        :\ E7B1= 8E B1 02    .1.
STY &02B2        :\ E7B4= 8C B2 02    .2.
ROR &E6          :\ E7B7= 66 E6       ff
CLI              :\ E7B9= 58          X
BRA LE7BE        :\ E7BA= 80 02       ..
 
.LE7BC
STZ &E6          :\ E7BC= 64 E6       df
.LE7BE
PHX              :\ E7BE= DA          Z
PHY              :\ E7BF= 5A          Z
LDY &0256        :\ E7C0= AC 56 02    ,V.
BEQ LE7D7        :\ E7C3= F0 12       p.
SEC              :\ E7C5= 38          8
ROR &EB          :\ E7C6= 66 EB       fk
JSR OSBGET       :\ E7C8= 20 D7 FF     W.
STZ &EB          :\ E7CB= 64 EB       dk
BCC LE7F3        :\ E7CD= 90 24       .$
LDA #&00         :\ E7CF= A9 00       ).
STZ &0256        :\ E7D1= 9C 56 02    .V.
JSR OSFIND       :\ E7D4= 20 CE FF     N.
.LE7D7
LDA &FF          :\ E7D7= A5 FF       %.
ASL A            :\ E7D9= 0A          .
LDA #&1B         :\ E7DA= A9 1B       ).
BCS LE7F3        :\ E7DC= B0 15       0.
LDX &0241        :\ E7DE= AE 41 02    .A.
JSR LEAFD        :\ E7E1= 20 FD EA     }j
BCC LE7F3        :\ E7E4= 90 0D       ..
BIT &E6          :\ E7E6= 24 E6       $f
BPL LE7D7        :\ E7E8= 10 ED       .m
LDA &02B2        :\ E7EA= AD B2 02    -2.
ORA &02B1        :\ E7ED= 0D B1 02    .1.
BNE LE7D7        :\ E7F0= D0 E5       Pe
DEC A            :\ E7F2= 3A          :
.LE7F3
PLY              :\ E7F3= 7A          z
PLX              :\ E7F4= FA          z
RTS              :\ E7F5= 60          `

.LE7F6
LDA HAZEL_WORKSPACE+&01        :\ E7F6= AD 01 DF    -._
STA HAZEL_WORKSPACE+&02        :\ E7F9= 8D 02 DF    .._
RTS              :\ E7FC= 60          `

.LE7FD
STA TUBE+8        :\ E7FD= 8D E8 FE    .h~
.LE800
BRA LE800        :\ E800= 80 FE       .~
 
\ OSCLI
\ =====
JSR LEDBA        :\ E802= 20 BA ED     :m
STX &F2          :\ E805= 86 F2       .r
STY &F3          :\ E807= 84 F3       .s
LDY #&00         :\ E809= A0 00        .
.LE80B
LDA (&F2),Y      :\ E80B= B1 F2       1r
STA LDC00,Y      :\ E80D= 99 00 DC    ..\
CMP #&0D         :\ E810= C9 0D       I.
BEQ LE818        :\ E812= F0 04       p.
INY              :\ E814= C8          H
BNE LE80B        :\ E815= D0 F4       Pt
RTS              :\ E817= 60          `
 
.LE818
LDY #&DC         :\ E818= A0 DC        \
LDX #&00         :\ E81A= A2 00       ".
JSR LF384        :\ E81C= 20 84 F3     .s
JMP L84FF        :\ E81F= 4C FF 84    L..

; OSWRCH
; ======
.LE822
PHA              :\ E822= 48          H
PHX              :\ E823= DA          Z
PHY              :\ E824= 5A          Z
PHA              :\ E825= 48          H
BIT &0260        :\ E826= 2C 60 02    ,`.
BPL LE833        :\ E829= 10 08       ..
TAY              :\ E82B= A8          (
LDA #&04         :\ E82C= A9 04       ).
JSR LEB04        :\ E82E= 20 04 EB     .k
BCS LE8A5        :\ E831= B0 72       0r
.LE833
LDA #&02         :\ E833= A9 02       ).
BIT &027C        :\ E835= 2C 7C 02    ,|.
BNE LE862        :\ E838= D0 28       P(
PLA              :\ E83A= 68          h
PHA              :\ E83B= 48          H
TAX              :\ E83C= AA          *
LDA LFE34        :\ E83D= AD 34 FE    -4~
PHA              :\ E840= 48          H
LDA #&08         :\ E841= A9 08       ).
TRB LFE34        :\ E843= 1C 34 FE    .4~
LDA &F4          :\ E846= A5 F4       %t
PHA              :\ E848= 48          H
LDA #&8F         :\ E849= A9 8F       ).
STA &F4          :\ E84B= 85 F4       .t
STA ROMSEL        :\ E84D= 8D 30 FE    .0~
TXA              :\ E850= 8A          .
JSR LC027        :\ E851= 20 27 C0     '@
PLA              :\ E854= 68          h
STA &F4          :\ E855= 85 F4       .t
STA ROMSEL        :\ E857= 8D 30 FE    .0~
PLA              :\ E85A= 68          h
AND #&08         :\ E85B= 29 08       ).
TSB LFE34        :\ E85D= 0C 34 FE    .4~
BCS LE869        :\ E860= B0 07       0.
.LE862
LDA #&08         :\ E862= A9 08       ).
BIT &027C        :\ E864= 2C 7C 02    ,|.
BEQ LE86E        :\ E867= F0 05       p.
.LE869
PLA              :\ E869= 68          h
PHA              :\ E86A= 48          H
JSR LE8AA        :\ E86B= 20 AA E8     *h
.LE86E
LDA &027C        :\ E86E= AD 7C 02    -|.
ROR A            :\ E871= 6A          j
BCC LE88F        :\ E872= 90 1B       ..
LDY &EA          :\ E874= A4 EA       $j
DEY              :\ E876= 88          .
BPL LE88F        :\ E877= 10 16       ..
PLA              :\ E879= 68          h
PHA              :\ E87A= 48          H
PHP              :\ E87B= 08          .
SEI              :\ E87C= 78          x
LDX #&02         :\ E87D= A2 02       ".
PHA              :\ E87F= 48          H
JSR LE9EF        :\ E880= 20 EF E9     oi
BCC LE888        :\ E883= 90 03       ..
JSR LE908        :\ E885= 20 08 E9     .i
.LE888
PLA              :\ E888= 68          h
LDX #&02         :\ E889= A2 02       ".
JSR LE9A3        :\ E88B= 20 A3 E9     #i
PLP              :\ E88E= 28          (
.LE88F
LDA #&10         :\ E88F= A9 10       ).
BIT &027C        :\ E891= 2C 7C 02    ,|.
BNE LE8A5        :\ E894= D0 0F       P.
LDY &0257        :\ E896= AC 57 02    ,W.
BEQ LE8A5        :\ E899= F0 0A       p.
PLA              :\ E89B= 68          h
PHA              :\ E89C= 48          H
SEC              :\ E89D= 38          8
ROR &EB          :\ E89E= 66 EB       fk
JSR OSBPUT       :\ E8A0= 20 D4 FF     T.
LSR &EB          :\ E8A3= 46 EB       Fk
.LE8A5
PLA              :\ E8A5= 68          h
PLY              :\ E8A6= 7A          z
PLX              :\ E8A7= FA          z
PLA              :\ E8A8= 68          h
RTS              :\ E8A9= 60          `
 
.LE8AA
BIT &027C        :\ E8AA= 2C 7C 02    ,|.
BVS LE8D4        :\ E8AD= 70 25       p%
CMP &0286        :\ E8AF= CD 86 02    M..
BNE LE8B9        :\ E8B2= D0 05       P.
BIT &0246        :\ E8B4= 2C 46 02    ,F.
BPL LE8D4        :\ E8B7= 10 1B       ..
.LE8B9
PHP              :\ E8B9= 08          .
SEI              :\ E8BA= 78          x
TAX              :\ E8BB= AA          *
LDA #&04         :\ E8BC= A9 04       ).
BIT &027C        :\ E8BE= 2C 7C 02    ,|.
BNE LE8D3        :\ E8C1= D0 10       P.
TXA              :\ E8C3= 8A          .
LDX #&03         :\ E8C4= A2 03       ".
JSR LE9A3        :\ E8C6= 20 A3 E9     #i
BCS LE8D3        :\ E8C9= B0 08       0.
BIT &02D1        :\ E8CB= 2C D1 02    ,Q.
BPL LE8D3        :\ E8CE= 10 03       ..
JSR LE8D5        :\ E8D0= 20 D5 E8     Uh
.LE8D3
PLP              :\ E8D3= 28          (
.LE8D4
RTS              :\ E8D4= 60          `
 
.LE8D5
LDA &0285        :\ E8D5= AD 85 02    -..
BEQ LE959        :\ E8D8= F0 7F       p.
DEC A            :\ E8DA= 3A          :
BNE LE8FD        :\ E8DB= D0 20       P 
JSR LE9F4        :\ E8DD= 20 F4 E9     ti
ROR &02D1        :\ E8E0= 6E D1 02    nQ.
BMI LE928        :\ E8E3= 30 43       0C
LDY #&82         :\ E8E5= A0 82        .
STY USER_VIA+&E        :\ E8E7= 8C 6E FE    .n~
STA USER_VIA+&1        :\ E8EA= 8D 61 FE    .a~
LDA USER_VIA+&C        :\ E8ED= AD 6C FE    -l~
AND #&F1         :\ E8F0= 29 F1       )q
ORA #&0C         :\ E8F2= 09 0C       ..
STA USER_VIA+&C        :\ E8F4= 8D 6C FE    .l~
ORA #&0E         :\ E8F7= 09 0E       ..
STA USER_VIA+&C        :\ E8F9= 8D 6C FE    .l~
RTS              :\ E8FC= 60          `
 
.LE8FD
DEC A            :\ E8FD= 3A          :
BNE LE929        :\ E8FE= D0 29       P)
LDY &EA          :\ E900= A4 EA       $j
DEY              :\ E902= 88          .
BPL LE959        :\ E903= 10 54       .T
LSR &02D1        :\ E905= 4E D1 02    NQ.
.LE908
LSR &024F        :\ E908= 4E 4F 02    NO.
.LE90B
JSR LED27        :\ E90B= 20 27 ED     'm
BCC LE928        :\ E90E= 90 18       ..
LDX #&20         :\ E910= A2 20       " 
.LE912
LDY #&9F         :\ E912= A0 9F        .
.LE914
PHP              :\ E914= 08          .
SEI              :\ E915= 78          x
TYA              :\ E916= 98          .
STX &FA          :\ E917= 86 FA       .z
AND &0250        :\ E919= 2D 50 02    -P.
EOR &FA          :\ E91C= 45 FA       Ez
LDX &0250        :\ E91E= AE 50 02    .P.
.LE921
STA &0250        :\ E921= 8D 50 02    .P.
STA LFE08        :\ E924= 8D 08 FE    ..~
PLP              :\ E927= 28          (
.LE928
RTS              :\ E928= 60          `
 
.LE929
CLC              :\ E929= 18          .
LDA #&01         :\ E92A= A9 01       ).
JSR LE93A        :\ E92C= 20 3A E9     :i
.LE92F
ROR &02D1        :\ E92F= 6E D1 02    nQ.
.LE932
RTS              :\ E932= 60          `
 
.LE933
BIT &02D1        :\ E933= 2C D1 02    ,Q.
BMI LE932        :\ E936= 30 FA       0z
LDA #&00         :\ E938= A9 00       ).
.LE93A
LDX #&03         :\ E93A= A2 03       ".
.LE93C
LDY &0285        :\ E93C= AC 85 02    ,..
JSR LEB04        :\ E93F= 20 04 EB     .k
JMP (&0222)      :\ E942= 6C 22 02    l".

.LE945
BNE LE956        :\ E945= D0 0F       P.
.LE947
LDX #&08         :\ E947= A2 08       ".
.LE949
CLI              :\ E949= 58          X
SEI              :\ E94A= 78          x
JSR LE951        :\ E94B= 20 51 E9     Qi
DEX              :\ E94E= CA          J
BPL LE949        :\ E94F= 10 F8       .x
.LE951
CPX #&09         :\ E951= E0 09       `.
BCC LE959        :\ E953= 90 04       ..
RTS              :\ E955= 60          `
 
.LE956
LDX &0241        :\ E956= AE 41 02    .A.
.LE959
CLC              :\ E959= 18          .
.LE95A
PHA              :\ E95A= 48          H
PHP              :\ E95B= 08          .
SEI              :\ E95C= 78          x
BCS LE967        :\ E95D= B0 08       0.
TXA              :\ E95F= 8A          .
AND #&04         :\ E960= 29 04       ).
BEQ LE967        :\ E962= F0 03       p.
JSR LF55D        :\ E964= 20 5D F5     ]u
.LE967
SEC              :\ E967= 38          8
ROR &02CE,X      :\ E968= 7E CE 02    ~N.
CPX #&02         :\ E96B= E0 02       `.
BCS LE975        :\ E96D= B0 06       0.
STZ &0268        :\ E96F= 9C 68 02    .h.
STZ &026A        :\ E972= 9C 6A 02    .j.
.LE975
JSR LED21        :\ E975= 20 21 ED     !m
PLP              :\ E978= 28          (
PLA              :\ E979= 68          h
RTS              :\ E97A= 60          `
 
BVC LE984        :\ E97B= 50 07       P.
.LE97D
LDA &02D7,X      :\ E97D= BD D7 02    =W.
STA &02E0,X      :\ E980= 9D E0 02    .`.
RTS              :\ E983= 60          `
 
.LE984
PHP              :\ E984= 08          .
SEI              :\ E985= 78          x
PHP              :\ E986= 08          .
SEC              :\ E987= 38          8
LDA &02E0,X      :\ E988= BD E0 02    =`.
SBC &02D7,X      :\ E98B= FD D7 02    }W.
BCS LE994        :\ E98E= B0 04       0.
SEC              :\ E990= 38          8
SBC LE9DB,X      :\ E991= FD DB E9    }[i
.LE994
PLP              :\ E994= 28          (
BCC LE99D        :\ E995= 90 06       ..
CLC              :\ E997= 18          .
ADC LE9DB,X      :\ E998= 7D DB E9    }[i
EOR #&FF         :\ E99B= 49 FF       I.
.LE99D
LDY #&00         :\ E99D= A0 00        .
TAX              :\ E99F= AA          *
PLP              :\ E9A0= 28          (
.LE9A1
RTS              :\ E9A1= 60          `
 
.LE9A2
CLI              :\ E9A2= 58          X
.LE9A3
SEI              :\ E9A3= 78          x
.LE9A4
JSR LEA40        :\ E9A4= 20 40 EA     @j
BCC LE9A1        :\ E9A7= 90 F8       .x
JSR LF241        :\ E9A9= 20 41 F2     Ar
PHA              :\ E9AC= 48          H
JSR LF735        :\ E9AD= 20 35 F7     5w
ASL A            :\ E9B0= 0A          .
PLA              :\ E9B1= 68          h
BCC LE9A2        :\ E9B2= 90 EE       .n
RTS              :\ E9B4= 60          `

.LE9B5
JSR LF384        :\ E9B5= 20 84 F3     .s
JMP L9423        :\ E9B8= 4C 23 94    L#.
 
.LE9BB
LDA #&00         :\ E9BB= A9 00       ).
SEC              :\ E9BD= 38          8
LDX #&14         :\ E9BE= A2 14       ".
.LE9C0
ROL A            :\ E9C0= 2A          *
BNE LE9C5        :\ E9C1= D0 02       P.
INX              :\ E9C3= E8          h
ROL A            :\ E9C4= 2A          *
.LE9C5
DEY              :\ E9C5= 88          .
BPL LE9C0        :\ E9C6= 10 F8       .x
RTS              :\ E9C8= 60          `
 
.LE9C9
EQUB &03         :\ E9C9= 03          .
ASL A            :\ E9CA= 0A          .
PHP              :\ E9CB= 08          .
EQUB &07         :\ E9CC= 07          .
EQUB &07         :\ E9CD= 07          .
EQUB &07         :\ E9CE= 07          .
EQUB &07         :\ E9CF= 07          .
EQUB &07         :\ E9D0= 07          .
\ORA #&00         :\ E9D1= 09 00       ..
EQUB &09
.LE9D2
EQUB &00
BRK              :\ E9D3= 00          .
CPY #&C0         :\ E9D4= C0 C0       @@
BVC LEA38        :\ E9D6= 50 60       P`
BVS LE95A        :\ E9D8= 70 80       p.
BRK              :\ E9DA= 00          .
.LE9DB
CPX #&00         :\ E9DB= E0 00       `.
RTI              :\ E9DD= 40          @
 
CPY #&F0         :\ E9DE= C0 F0       @p
\BEQ LE9D2        :\ E9E0= F0 F0       pp
EQUB &F0
EQUB &F0
\BEQ LE9A4        :\ E9E2= F0 C0       p@
EQUB &F0
EQUB &C0
.LE9E4
LDA LE9D2,X      :\ E9E4= BD D2 E9    =Ri
STA &FA          :\ E9E7= 85 FA       .z
LDA LE9C9,X      :\ E9E9= BD C9 E9    =Ii
STA &FB          :\ E9EC= 85 FB       .{
RTS              :\ E9EE= 60          `
 
.LE9EF
BIT LE34E        :\ E9EF= 2C 4E E3    ,Nc
BRA LE9F5        :\ E9F2= 80 01       ..
 
.LE9F4
CLV              :\ E9F4= B8          8
.LE9F5
JMP (&022C)      :\ E9F5= 6C 2C 02    l,.
 
PHP              :\ E9F8= 08          .
SEI              :\ E9F9= 78          x
LDA &02D7,X      :\ E9FA= BD D7 02    =W.
CMP &02E0,X      :\ E9FD= DD E0 02    ]`.
BEQ LEA6E        :\ EA00= F0 6C       pl
TAY              :\ EA02= A8          (
JSR LE9E4        :\ EA03= 20 E4 E9     di
LDA (&FA),Y      :\ EA06= B1 FA       1z
BVS LEA24        :\ EA08= 70 1A       p.
PHA              :\ EA0A= 48          H
INY              :\ EA0B= C8          H
TYA              :\ EA0C= 98          .
BNE LEA12        :\ EA0D= D0 03       P.
LDA LE9DB,X      :\ EA0F= BD DB E9    =[i
.LEA12
STA &02D7,X      :\ EA12= 9D D7 02    .W.
CPX #&02         :\ EA15= E0 02       `.
BCC LEA23        :\ EA17= 90 0A       ..
CMP &02E0,X      :\ EA19= DD E0 02    ]`.
BNE LEA23        :\ EA1C= D0 05       P.
LDY #&00         :\ EA1E= A0 00        .
JSR LEA28        :\ EA20= 20 28 EA     (j
.LEA23
PLA              :\ EA23= 68          h
.LEA24
TAY              :\ EA24= A8          (
.LEA25
PLP              :\ EA25= 28          (
CLC              :\ EA26= 18          .
RTS              :\ EA27= 60          `
 
.LEA28
PHP              :\ EA28= 08          .
SEI              :\ EA29= 78          x
PHA              :\ EA2A= 48          H
LDA &02BF,Y      :\ EA2B= B9 BF 02    9?.
BEQ LEA6D        :\ EA2E= F0 3D       p=
TYA              :\ EA30= 98          .
PLY              :\ EA31= 7A          z
PHY              :\ EA32= 5A          Z
JSR LF8BF        :\ EA33= 20 BF F8     ?x
BRA LEA23        :\ EA36= 80 EB       .k
 
.LEA38
TYA              :\ EA38= 98          .
LDY #&02         :\ EA39= A0 02        .
JSR LEA28        :\ EA3B= 20 28 EA     (j
TAY              :\ EA3E= A8          (
.LEA3F
TYA              :\ EA3F= 98          .
.LEA40
JMP (&022A)      :\ EA40= 6C 2A 02    l*.
 
PHP              :\ EA43= 08          .
SEI              :\ EA44= 78          x
PHA              :\ EA45= 48          H
LDA &02E0,X      :\ EA46= BD E0 02    =`.
INC A            :\ EA49= 1A          .
BNE LEA4F        :\ EA4A= D0 03       P.
LDA LE9DB,X      :\ EA4C= BD DB E9    =[i
.LEA4F
CMP &02D7,X      :\ EA4F= DD D7 02    ]W.
BEQ LEA62        :\ EA52= F0 0E       p.
LDY &02E0,X      :\ EA54= BC E0 02    <`.
STA &02E0,X      :\ EA57= 9D E0 02    .`.
JSR LE9E4        :\ EA5A= 20 E4 E9     di
PLA              :\ EA5D= 68          h
STA (&FA),Y      :\ EA5E= 91 FA       .z
BRA LEA25        :\ EA60= 80 C3       .C
 
.LEA62
PLA              :\ EA62= 68          h
CPX #&02         :\ EA63= E0 02       `.
BCS LEA6E        :\ EA65= B0 07       0.
LDY #&01         :\ EA67= A0 01        .
JSR LEA28        :\ EA69= 20 28 EA     (j
PHA              :\ EA6C= 48          H
.LEA6D
PLA              :\ EA6D= 68          h
.LEA6E
PLP              :\ EA6E= 28          (
SEC              :\ EA6F= 38          8
RTS              :\ EA70= 60          `
 
.LEA71
PHA              :\ EA71= 48          H
AND #&DF         :\ EA72= 29 DF       )_
CMP #&5B         :\ EA74= C9 5B       I[
BCS LEA7C        :\ EA76= B0 04       0.
EOR #&FF         :\ EA78= 49 FF       I.
CMP #&BF         :\ EA7A= C9 BF       I?
.LEA7C
PLA              :\ EA7C= 68          h
RTS              :\ EA7D= 60          `
 
.LEA7E
LDX #&00         :\ EA7E= A2 00       ".
.LEA80
TXA              :\ EA80= 8A          .
AND &0245        :\ EA81= 2D 45 02    -E.
BNE LEA3F        :\ EA84= D0 B9       P9
TYA              :\ EA86= 98          .
EOR &026C        :\ EA87= 4D 6C 02    Ml.
ORA &0275        :\ EA8A= 0D 75 02    .u.
BNE LEA38        :\ EA8D= D0 A9       P)
LDA &0258        :\ EA8F= AD 58 02    -X.
ROR A            :\ EA92= 6A          j
TYA              :\ EA93= 98          .
BCS LEAA0        :\ EA94= B0 0A       0.
LDY #&06         :\ EA96= A0 06        .
JSR LEA28        :\ EA98= 20 28 EA     (j
BCC LEAA0        :\ EA9B= 90 03       ..
JSR LEC57        :\ EA9D= 20 57 EC     Wl
.LEAA0
CLC              :\ EAA0= 18          .
RTS              :\ EAA1= 60          `
 
.LEAA2
ROR A            :\ EAA2= 6A          j
PLA              :\ EAA3= 68          h
BCS LEABD        :\ EAA4= B0 17       0.
.LEAA6
TYA              :\ EAA6= 98          .
AND #&0F         :\ EAA7= 29 0F       ).
PHA              :\ EAA9= 48          H
TYA              :\ EAAA= 98          .
LSR A            :\ EAAB= 4A          J
LSR A            :\ EAAC= 4A          J
LSR A            :\ EAAD= 4A          J
LSR A            :\ EAAE= 4A          J
EOR #&04         :\ EAAF= 49 04       I.
TAY              :\ EAB1= A8          (
LDA &0265,Y      :\ EAB2= B9 65 02    9e.
LSR A            :\ EAB5= 4A          J
BEQ LEB32        :\ EAB6= F0 7A       pz
PLA              :\ EAB8= 68          h
CLC              :\ EAB9= 18          .
ADC &0265,Y      :\ EABA= 79 65 02    ye.
.LEABD
CLC              :\ EABD= 18          .
RTS              :\ EABE= 60          `
 
.LEABF
JSR LEFB6        :\ EABF= 20 B6 EF     6o
PLX              :\ EAC2= FA          z
.LEAC3
JSR LE9F4        :\ EAC3= 20 F4 E9     ti
BCS LEB28        :\ EAC6= B0 60       0`
PHA              :\ EAC8= 48          H
CPX #&01         :\ EAC9= E0 01       `.
BNE LEAD3        :\ EACB= D0 06       P.
JSR LE90B        :\ EACD= 20 0B E9     .i
SEC              :\ EAD0= 38          8
LDX #&01         :\ EAD1= A2 01       ".
.LEAD3
PLA              :\ EAD3= 68          h
BCC LEADB        :\ EAD4= 90 05       ..
LDY &0245        :\ EAD6= AC 45 02    ,E.
BNE LEB27        :\ EAD9= D0 4C       PL
.LEADB
TAY              :\ EADB= A8          (
BPL LEB27        :\ EADC= 10 49       .I
AND #&0F         :\ EADE= 29 0F       ).
CMP #&0B         :\ EAE0= C9 0B       I.
BCC LEAA6        :\ EAE2= 90 C2       .B
ADC #&7B         :\ EAE4= 69 7B       i{
PHA              :\ EAE6= 48          H
LDA &027D        :\ EAE7= AD 7D 02    -}.
BNE LEAA2        :\ EAEA= D0 B6       P6
LDA &027C        :\ EAEC= AD 7C 02    -|.
ROR A            :\ EAEF= 6A          j
ROR A            :\ EAF0= 6A          j
PLA              :\ EAF1= 68          h
BCS LEAC3        :\ EAF2= B0 CF       0O
CMP #&87         :\ EAF4= C9 87       I.
BEQ LEB29        :\ EAF6= F0 31       p1
PHX              :\ EAF8= DA          Z
JSR LEB5D        :\ EAF9= 20 5D EB     ]k
PLX              :\ EAFC= FA          z
.LEAFD
BIT &025F        :\ EAFD= 2C 5F 02    ,_.
BPL LEB07        :\ EB00= 10 05       ..
LDA #&06         :\ EB02= A9 06       ).
.LEB04
JMP (&0224)      :\ EB04= 6C 24 02    l$.
 
.LEB07
LDA &0268        :\ EB07= AD 68 02    -h.
BEQ LEAC3        :\ EB0A= F0 B7       p7
TXA              :\ EB0C= 8A          .
AND &0245        :\ EB0D= 2D 45 02    -E.
BNE LEAC3        :\ EB10= D0 B1       P1
LDA &F4          :\ EB12= A5 F4       %t
PHA              :\ EB14= 48          H
JSR LE598        :\ EB15= 20 98 E5     .e
LDA (&F8)        :\ EB18= B2 F8       2x
PLX              :\ EB1A= FA          z
JSR LE581        :\ EB1B= 20 81 E5     .e
DEC &0268        :\ EB1E= CE 68 02    Nh.
INC &F8          :\ EB21= E6 F8       fx
BNE LEB27        :\ EB23= D0 02       P.
INC &F9          :\ EB25= E6 F9       fy
.LEB27
CLC              :\ EB27= 18          .
.LEB28
RTS              :\ EB28= 60          `
 
.LEB29
PHX              :\ EB29= DA          Z
JSR LEB63        :\ EB2A= 20 63 EB     ck
BEQ LEABF        :\ EB2D= F0 90       p.
PLX              :\ EB2F= FA          z
CLC              :\ EB30= 18          .
RTS              :\ EB31= 60          `
 
.LEB32
PLY              :\ EB32= 7A          z
BCC LEAC3        :\ EB33= 90 8E       ..
TYA              :\ EB35= 98          .
STA &02C9        :\ EB36= 8D C9 02    .I.
LDA &F4          :\ EB39= A5 F4       %t
PHA              :\ EB3B= 48          H
JSR LE598        :\ EB3C= 20 98 E5     .e
JSR LEB55        :\ EB3F= 20 55 EB     Uk
STA &0268        :\ EB42= 8D 68 02    .h.
LDA L8000,Y      :\ EB45= B9 00 80    9..
STA &F8          :\ EB48= 85 F8       .x
LDA L8011,Y      :\ EB4A= B9 11 80    9..
STA &F9          :\ EB4D= 85 F9       .y
PLA              :\ EB4F= 68          h
JSR LE592        :\ EB50= 20 92 E5     .e
BRA LEAFD        :\ EB53= 80 A8       .(
 
.LEB55
LDA L8001,Y      :\ EB55= B9 01 80    9..
.LEB58
SEC              :\ EB58= 38          8
SBC L8000,Y      :\ EB59= F9 00 80    y..
RTS              :\ EB5C= 60          `
 
.LEB5D
JSR LF3AB        :\ EB5D= 20 AB F3     +s
JMP LDF78        :\ EB60= 4C 78 DF    Lx_
 
.LEB63
JSR LF3AB        :\ EB63= 20 AB F3     +s
JMP LDF5E        :\ EB66= 4C 5E DF    L^_
 
\ OSBYTE Dispatch Table
\ =====================
.LEB69
EQUW LEF6F       :\ EB69= 6F EF       o.
EQUW LF0CE       :\ EB6B= CE F0       ..
EQUW LECB4       :\ EB6D= B4 EC       ..
EQUW LF0A3       :\ EB6F= A3 F0       ..
EQUW LF0D6       :\ EB71= D6 F0       ..
EQUW LF0BC       :\ EB73= BC F0       ..
EQUW LF0B3       :\ EB75= B3 F0       ..
EQUW LEC6D       :\ EB77= 6D EC       m.
EQUW LEC6B       :\ EB79= 6B EC       k.
EQUW LEC92       :\ EB7B= 92 EC       ..
EQUW LEC94       :\ EB7D= 94 EC       ..
EQUW LF0D4       :\ EB7F= D4 F0       ..
EQUW LF0D2       :\ EB81= D2 F0       ..
EQUW LECDA       :\ EB83= DA EC       ..
EQUW LECDB       :\ EB85= DB EC       ..
EQUW LE945       :\ EB87= 45 E9       E.
EQUW LECE7       :\ EB89= E7 EC       ..
EQUW LE79C       :\ EB8B= 9C E7       ..
EQUW LF11A       :\ EB8D= 1A F1       ..
EQUW LF0F5       :\ EB8F= F5 F0       ..
EQUW LF21C       :\ EB91= 1C F2       ..
EQUW LE951       :\ EB93= 51 E9       Q.
EQUW LF228       :\ EB95= 28 F2       (.
EQUW LF22C       :\ EB97= 2C F2       ,.
EQUW LED84       :\ EB99= 84 ED       ..
EQUW LF222       :\ EB9B= 22 F2       ".
EQUW LEE9E       :\ EB9D= 9E EE       ..
EQUW LEEA2       :\ EB9F= A2 EE       ..
EQUW LF20F       :\ EBA1= 0F F2       ..
EQUW LED84       :\ EBA3= 84 ED       ..
EQUW LED84       :\ EBA5= 84 ED       ..
EQUW LED58       :\ EBA7= 58 ED       X.
EQUW LED68       :\ EBA9= 68 ED       h.
EQUW LF0B8       :\ EBAB= B8 F0       ..
EQUW LFFAA       :\ EBAD= AA FF       ..
EQUW LFFAA       :\ EBAF= AA FF       ..
EQUW LEFB3       :\ EBB1= B3 EF       ..
EQUW LF230       :\ EBB3= 30 F2       0.
EQUW LE9B5       :\ EBB5= B5 E9       ..
EQUW LF90B       :\ EBB7= 0B F9       ..
EQUW LF902       :\ EBB9= 02 F9       ..
EQUW LF910       :\ EBBB= 10 F9       ..
EQUW LE92F       :\ EBBD= 2F E9       /.
EQUW LEC56       :\ EBBF= 56 EC       V.
EQUW LEC57       :\ EBC1= 57 EC       W.
EQUW LEC3C       :\ EBC3= 3C EC       <.
EQUW LF1E3       :\ EBC5= E3 F1       ..
EQUW LED35       :\ EBC7= 35 ED       5.
EQUW LECF4       :\ EBC9= F4 EC       ..
EQUW LED0B       :\ EBCB= 0B ED       ..
EQUW LF905       :\ EBCD= 05 F9       ..
EQUW LF1BA       :\ EBCF= BA F1       ..
EQUW LF1D0       :\ EBD1= D0 F1       ..
EQUW LE269       :\ EBD3= 69 E2       i.
EQUW LF1DC       :\ EBD5= DC F1       ..
EQUW LEC37       :\ EBD7= 37 EC       7.
EQUW LEC61       :\ EBD9= 61 EC       a.
EQUW LEA3F       :\ EBDB= 3F EA       ?.
EQUW LF1E2       :\ EBDD= E2 F1       ..
EQUW LED9A       :\ EBDF= 9A ED       ..
EQUW LED9A       :\ EBE1= 9A ED       ..
EQUW LE4C3       :\ EBE3= C3 E4       ..
EQUW LEE03       :\ EBE5= 03 EE       ..
EQUW LF353       :\ EBE7= 53 F3       S.
EQUW LE9F4       :\ EBE9= F4 E9       ..
EQUW LF89E       :\ EBEB= 9E F8       ..
EQUW LF36E       :\ EBED= 6E F3       n.
EQUW LF8AE       :\ EBEF= AE F8       ..
EQUW LF364       :\ EBF1= 64 F3       d.
EQUW LFFAB       :\ EBF3= AB FF       ..
EQUW LF369       :\ EBF5= 69 F3       i.
EQUW LE9EF       :\ EBF7= EF E9       ..
EQUW LEA80       :\ EBF9= 80 EA       ..
EQUW LF24F       :\ EBFB= 4F F2       O.
EQUW LF260       :\ EBFD= 60 F2       `.
EQUW LE914       :\ EBFF= 14 E9       ..
EQUW LFFAF       :\ EC01= AF FF       ..
EQUW LED84       :\ EC03= 84 ED       ..
EQUW LED84       :\ EC05= 84 ED       ..
EQUW LF0FF       :\ EC07= FF F0       ..
EQUW LED8E       :\ EC09= 8E ED       ..
EQUW LED94       :\ EC0B= 94 ED       ..
EQUW LED84       :\ EC0D= 84 ED       ..
EQUW LE547       :\ EC0F= 47 E5       G.
EQUW LE23D       :\ EC11= 3D E2       =.
EQUW LF0DB       :\ EC13= DB F0       ..
EQUW LEC39       :\ EC15= 39 EC       9.\
\CPX LF02F        :\ EC16= EC 2F F0    l/p ; &F02F - OSWORD &00
EQUB &2F
EQUB &F0
EQUB &02         :\ EC19= 02          .
\BEQ LEC31        :\ EC1A= F0 15       p.
EQUB &F0
EQUB &15
.LEC1C
BEQ LEC1C        :\ EC1C= F0 FE       p~
EQUB &EF         :\ EC1E= EF          o
ORA (&F0),Y      :\ EC1F= 11 F0       .p
EOR (&EF),Y      :\ EC21= 51 EF       Qo
EOR &7BEF,Y      :\ EC23= 59 EF 7B    Yo{
EQUB &EF         :\ EC26= EF          o
EQUB &DC         :\ EC27= DC          \
EQUB &EF         :\ EC28= EF          o
BVC LEC1C        :\ EC29= 50 F1       Pq
ADC &F1,X        :\ EC2B= 75 F1       uq
EQUB &3F         :\ EC2D= 3F          ?
SBC (&8D),Y      :\ EC2E= F1 8D       q.
SBC (&9B),Y      :\ EC30= F1 9B       q.
SBC (&2F),Y      :\ EC32= F1 2F       q/
EQUB &EF         :\ EC34= EF          o
INX              :\ EC35= E8          h
\SBC (&A9),Y      :\ EC36= F1 A9       q)
EQUB &F1
.LEC37
LDA #&00

.LEC39
JMP (&0200)      :\ EC39= 6C 00 02    l..

.LEC3C
LDX #&00         :\ EC3C= A2 00       ".
BIT &FF          :\ EC3E= 24 FF       $.
BPL LEC56        :\ EC40= 10 14       ..
LDA &0276        :\ EC42= AD 76 02    -v.
BNE LEC54        :\ EC45= D0 0D       P.
CLI              :\ EC47= 58          X
STZ &0269        :\ EC48= 9C 69 02    .i.
JSR LF384        :\ EC4B= 20 84 F3     .s
JSR LA591        :\ EC4E= 20 91 A5     .%
JSR LE947        :\ EC51= 20 47 E9     Gi
.LEC54
LDX #&FF         :\ EC54= A2 FF       ".
.LEC56
CLC              :\ EC56= 18          .
.LEC57
ROR &FF          :\ EC57= 66 FF       f.
BIT &027A        :\ EC59= 2C 7A 02    ,z.
BPL LECD9        :\ EC5C= 10 7B       .{
JMP &0403        :\ EC5E= 4C 03 04    L..
 
.LEC61
LDA &0282        :\ EC61= AD 82 02    -..
TAY              :\ EC64= A8          (
ROL A            :\ EC65= 2A          *
CPX #&01         :\ EC66= E0 01       `.
ROR A            :\ EC68= 6A          j
BRA LEC89        :\ EC69= 80 1E       ..
 
.LEC6B
LDA #&38         :\ EC6B= A9 38       )8
.LEC6D
EOR #&3F         :\ EC6D= 49 3F       I?
STA &FA          :\ EC6F= 85 FA       .z
LDY &0282        :\ EC71= AC 82 02    ,..
CPX #&09         :\ EC74= E0 09       `.
BCS LEC8F        :\ EC76= B0 17       0.
AND LF0EC,X      :\ EC78= 3D EC F0    =lp
STA &FB          :\ EC7B= 85 FB       .{
TYA              :\ EC7D= 98          .
ORA &FA          :\ EC7E= 05 FA       .z
EOR &FA          :\ EC80= 45 FA       Ez
ORA &FB          :\ EC82= 05 FB       .{
ORA #&40         :\ EC84= 09 40       .@
EOR &025D        :\ EC86= 4D 5D 02    M].
.LEC89
STA &0282        :\ EC89= 8D 82 02    ...
STA LFE10        :\ EC8C= 8D 10 FE    ..~
.LEC8F
TYA              :\ EC8F= 98          .
.LEC90
TAX              :\ EC90= AA          *
RTS              :\ EC91= 60          `
 
.LEC92
INY              :\ EC92= C8          H
CLC              :\ EC93= 18          .
.LEC94
LDA &0252,Y      :\ EC94= B9 52 02    9R.
PHA              :\ EC97= 48          H
TXA              :\ EC98= 8A          .
STA &0252,Y      :\ EC99= 99 52 02    .R.
PLY              :\ EC9C= 7A          z
LDA &0251        :\ EC9D= AD 51 02    -Q.
BNE LEC8F        :\ ECA0= D0 ED       Pm
STX &0251        :\ ECA2= 8E 51 02    .Q.
LDA &0248        :\ ECA5= AD 48 02    -H.
PHP              :\ ECA8= 08          .
ROR A            :\ ECA9= 6A          j
PLP              :\ ECAA= 28          (
ROL A            :\ ECAB= 2A          *
STA &0248        :\ ECAC= 8D 48 02    .H.
STA VCONTROL        :\ ECAF= 8D 20 FE    . ~
BRA LEC8F        :\ ECB2= 80 DB       .[

.LECB4
TXA              :\ ECB4= 8A          .
AND #&01         :\ ECB5= 29 01       ).
PHA              :\ ECB7= 48          H
LDA &0250        :\ ECB8= AD 50 02    -P.
ROL A            :\ ECBB= 2A          *
CPX #&01         :\ ECBC= E0 01       `.
ROR A            :\ ECBE= 6A          j
CMP &0250        :\ ECBF= CD 50 02    MP.
PHP              :\ ECC2= 08          .
STA &0250        :\ ECC3= 8D 50 02    .P.
STA LFE08        :\ ECC6= 8D 08 FE    ..~
JSR LE90B        :\ ECC9= 20 0B E9     .i
PLP              :\ ECCC= 28          (
BEQ LECD2        :\ ECCD= F0 03       p.
BIT LFE09        :\ ECCF= 2C 09 FE    ,.~
.LECD2
LDX &0241        :\ ECD2= AE 41 02    .A.
PLA              :\ ECD5= 68          h
STA &0241        :\ ECD6= 8D 41 02    .A.
.LECD9
RTS              :\ ECD9= 60          `

.LECDA
TYA              :\ ECDA= 98          .
.LECDB
CPX #&0A         :\ ECDB= E0 0A       `.
BCS LEC90        :\ ECDD= B0 B1       01
LDY &02BF,X      :\ ECDF= BC BF 02    <?.
STA &02BF,X      :\ ECE2= 9D BF 02    .?.
BRA LEC8F        :\ ECE5= 80 A8       .(

.LECE7
BEQ LECEC        :\ ECE7= F0 03       p.
JSR LE79C        :\ ECE9= 20 9C E7     .g
.LECEC
LDA &024D        :\ ECEC= AD 4D 02    -M.
STX &024D        :\ ECEF= 8E 4D 02    .M.
TAX              :\ ECF2= AA          *
RTS              :\ ECF3= 60          `
 
.LECF4
TYA              :\ ECF4= 98          .
BMI LED01        :\ ECF5= 30 0A       0.
JSR LE7B1        :\ ECF7= 20 B1 E7     1g
BCS LECFF        :\ ECFA= B0 03       0.
TAX              :\ ECFC= AA          *
.LECFD
LDA #&00         :\ ECFD= A9 00       ).
.LECFF
TAY              :\ ECFF= A8          (
RTS              :\ ED00= 60          `
 
.LED01
TXA              :\ ED01= 8A          .
BEQ LED14        :\ ED02= F0 10       p.
EOR #&7F         :\ ED04= 49 7F       I.
TAX              :\ ED06= AA          *
JSR LF902        :\ ED07= 20 02 F9     .y
ROL A            :\ ED0A= 2A          *
.LED0B
LDX #&FF         :\ ED0B= A2 FF       ".
LDY #&FF         :\ ED0D= A0 FF        .
BCS LED13        :\ ED0F= B0 02       0.
INX              :\ ED11= E8          h
INY              :\ ED12= C8          H
.LED13
RTS              :\ ED13= 60          `
 
.LED14
LDX #&FD         :\ ED14= A2 FD       "}
BRA LECFD        :\ ED16= 80 E5       .e
 
.LED18
TXA              :\ ED18= 8A          .
EOR #&FF         :\ ED19= 49 FF       I.
TAX              :\ ED1B= AA          *
CPX #&02         :\ ED1C= E0 02       `.
.LED1E
CLV              :\ ED1E= B8          8
BRA LED24        :\ ED1F= 80 03       ..
 
.LED21
BIT LE34E        :\ ED21= 2C 4E E3    ,Nc
.LED24
JMP (&022E)      :\ ED24= 6C 2E 02    l..
 
.LED27
SEC              :\ ED27= 38          8
LDX #&01         :\ ED28= A2 01       ".
JSR LED1E        :\ ED2A= 20 1E ED     .m
CPY #&01         :\ ED2D= C0 01       @.
BCS LED34        :\ ED2F= B0 03       0.
CPX &025B        :\ ED31= EC 5B 02    l[.
.LED34
RTS              :\ ED34= 60          `

.LED35
BMI LED18        :\ ED35= 30 E1       0a
BEQ LED45        :\ ED37= F0 0C       p.
CPX #&05         :\ ED39= E0 05       `.
BCS LED0B        :\ ED3B= B0 CE       0N
LDY &02B9,X      :\ ED3D= BC B9 02    <9.
LDA &02B5,X      :\ ED40= BD B5 02    =5.
TAX              :\ ED43= AA          *
RTS              :\ ED44= 60          `
 
.LED45
LDA SYSTEM_VIA+&0        :\ ED45= AD 40 FE    -@~
ROR A            :\ ED48= 6A          j
ROR A            :\ ED49= 6A          j
ROR A            :\ ED4A= 6A          j
ROR A            :\ ED4B= 6A          j
EOR #&FF         :\ ED4C= 49 FF       I.
AND #&03         :\ ED4E= 29 03       ).
LDY &02BE        :\ ED50= AC BE 02    ,>.
STX &02BE        :\ ED53= 8E BE 02    .>.
TAX              :\ ED56= AA          *
RTS              :\ ED57= 60          `

.LED58
JSR LED70        :\ ED58= 20 70 ED     pm
ASL A            :\ ED5B= 0A          .
BEQ LED62        :\ ED5C= F0 04       p.
.LED5E
TSB LFE34        :\ ED5E= 0C 34 FE    .4~
RTS              :\ ED61= 60          `
 
.LED62
LDA #&02         :\ ED62= A9 02       ).
.LED64
TRB LFE34        :\ ED64= 1C 34 FE    .4~
RTS              :\ ED67= 60          `
 
.LED68
JSR LED70        :\ ED68= 20 70 ED     pm
BNE LED5E        :\ ED6B= D0 F1       Pq
INC A            :\ ED6D= 1A          .
BRA LED64        :\ ED6E= 80 F4       .t
 
.LED70
TAY              :\ ED70= A8          (
TXA              :\ ED71= 8A          .
STA &021A,Y      :\ ED72= 99 1A 02    ...
BNE LED80        :\ ED75= D0 09       P.
LDA &D0          :\ ED77= A5 D0       %P
AND #&10         :\ ED79= 29 10       ).
BEQ LED83        :\ ED7B= F0 06       p.
.LED7D
LDA #&01         :\ ED7D= A9 01       ).
RTS              :\ ED7F= 60          `
 
.LED80
DEC A            :\ ED80= 3A          :
BNE LED7D        :\ ED81= D0 FA       Pz
.LED83
RTS              :\ ED83= 60          `

\ OSBYTE &6E (110), &6F (111)
\ ===========================
\ Pass to sideways ROMs
.LED84
LDX #&07:JSR LEE72        :\ ED86= 20 72 EE     rn
LDX &F0          :\ ED89= A6 F0       &p
EOR #&00         :\ ED8B= 49 00       I.
RTS              :\ ED8D= 60          `

.LED8E
JSR LF384        :\ ED8E= 20 84 F3     .s
JMP L98B2        :\ ED91= 4C B2 98    L2.
 
.LED94
JSR LF384        :\ ED94= 20 84 F3     .s
JMP L98DC        :\ ED97= 4C DC 98    L\.

\ OSBYTE &8C (140) - Select TAPE
\ ==============================
.LED9A
JSR LEDC0
LDA LFE34:PHA       :\ Save ACCON register
JSR LEDBA           :\ Page Hazel workspace in
LDX HAZEL_WORKSPACE+&01:STX HAZEL_WORKSPACE+&00 :\
LDA #&0F:STA HAZEL_WORKSPACE+&03  :\ Set FS ROM = 15
PLA                 :\ Restore ACCON
.LEDB0
AND #&08:BNE LEDBC
LDA #&08:TRB LFE34
RTS
 
.LEDBA
LDA #&08         :\ EDBA= A9 08       ).
.LEDBC
TSB LFE34        :\ EDBC= 0C 34 FE    .4~
RTS              :\ EDBF= 60          `

\ Select ROM or TAPE
\ ==================
.LEDC0
EOR #&8C
.LEDC2
ASL A:STA &0247     :\ Set CFS/RFS swicth to 0=CFS or 2=RFS
BNE LEDCC           :\ Skip past if not RFS
LDA #&04:TRB &E2    :\ CFS, clear b2 of status
.LEDCC
CPX #&03:BRA LEDD6  :\ EQ=TAPE 300, NE=TAPE 1200
 
.LEDD0
JSR LEE64        :\ EDD0= 20 64 EE     dn
JSR LF1EE        :\ EDD3= 20 EE F1     nq
.LEDD6
PHP                 :\ Save baud flag in Carry
LDA #&06:JSR LF1E5  :\ Vectors about to change
LDA &0247:BNE LEDEE :\ Jump if RFS selected
LDX #&06            :\ Prepare baud=6 for TAPE300
PLP:BEQ LEDEB       :\ Skip past if TAPE300
LDA #&04:TSB &E2    :\ TAPE1200, set bit 2 of status
DEX                 :\ Change to baud=5 for TAPE1200
.LEDEB
STX &C6:PHP         :\ Store baud rate setting
.LEDEE
STZ &CE:PLP         :\ Clear byte (unused on BBC)
LDX #&0E            :\ Prepare to set 7 vectors
.LEDF3
LDA LE2E8,X:STA &0211,X  :\ Set filing system vectors to point to extended vectors
DEX:BNE LEDF3
JSR LF1EE           :\ Set extended vectors
STZ &C2             :\ Set Progress=idle
LDX #&0F            :\ Send service call &0F - vectors changed

\ Send a sideways ROM service call and check for filing system change
\ ===================================================================
.LEE03
PHY
PHX:JSR LEE72:PLX     :\ Send service call
CPX #&0F:BEQ LEE43    :\ If VectorsClaimed, hook FileSwitch back in
INC A:DEC A:BEQ LEE14 :\ If claimed, check FSSelect and UKCommand
.LEE11
PLX:TAX:RTS           :\ Return with result in X, EQ=Claimed
 
.LEE14
CPX #&12:BEQ LEE1C        :\ EE16= F0 04       p.
CPX #&04         :\ EE18= E0 04       `.
BNE LEE11        :\ EE1A= D0 F5       Pu
.LEE1C
PLY              :\ EE1C= 7A          z
PHA              :\ EE1D= 48          H
LDA LFE34        :\ EE1E= AD 34 FE    -4~
PHA              :\ EE21= 48          H
JSR LEDBA        :\ EE22= 20 BA ED     :m
SEC              :\ EE25= 38          8
ROR HAZEL_WORKSPACE+&00        :\ EE26= 6E 00 DF    n._
.LEE29
PHY              :\ EE29= 5A          Z
LDA #&00         :\ EE2A= A9 00       ).
TAY              :\ EE2C= A8          (
JSR LFA18        :\ EE2D= 20 18 FA     .z
STA HAZEL_WORKSPACE+&01        :\ EE30= 8D 01 DF    .._
BIT HAZEL_WORKSPACE+&00        :\ EE33= 2C 00 DF    ,._
BPL LEE3B        :\ EE36= 10 03       ..
JSR LF20F        :\ EE38= 20 0F F2     .r
.LEE3B
PLY              :\ EE3B= 7A          z
PLA              :\ EE3C= 68          h
JSR LEDB0        :\ EE3D= 20 B0 ED     0m
PLA              :\ EE40= 68          h
TAX              :\ EE41= AA          *
RTS              :\ EE42= 60          `
 
.LEE43
PLY              :\ EE43= 7A          z
PHA              :\ EE44= 48          H
LDA LFE34        :\ EE45= AD 34 FE    -4~
PHA              :\ EE48= 48          H
JSR LEDBA        :\ EE49= 20 BA ED     :m
LDA &021E        :\ Save FSC
STA HAZEL_WORKSPACE+&DA        :\ EE4F= 8D DA DF    .Z_
LDA &021F        :\ EE52= AD 1F 02    -..
STA HAZEL_WORKSPACE+&DB        :\ EE55= 8D DB DF    .[_
LDA #&69         :\ Hook FileSwitch FSC in
STA &021E        :\ EE5A= 8D 1E 02    ...
LDA #&FB         :\ EE5D= A9 FB       ){
STA &021F        :\ EE5F= 8D 1F 02    ...
BRA LEE29        :\ EE62= 80 C5       .E
 
.LEE64
LDA #&A1         :\ EE64= A9 A1       )!
STA &E3          :\ EE66= 85 E3       .c
LDA #&19         :\ EE68= A9 19       ).
STA &03D1        :\ EE6A= 8D D1 03    .Q.
LDA #&04         :\ EE6D= A9 04       ).
TSB &E2          :\ EE6F= 04 E2       .b
RTS              :\ EE71= 60          `
 

\ Pass service call around sideways ROMs
\ ======================================
\ On entry, X=service call number
\           Y=any parameters
\ On exit,  X=0 or preserved
\           Y=any returned parameters
\           EQ=call claimed if called directly
\
.LEE72
LDA &F4:PHA              :\ Save current ROM
LDA LFE34:PHA            :\ Save current paging state
JSR LEDBA                :\ Page in Hazel
TXA                      :\ Pass service call number to A
LDX #&0F:BRA LEE86       :\ Start at ROM 15, and always call ROM 15
.LEE81
BIT &02A1,X:BPL LEE91    :\ No service entry, step to next ROM
.LEE86
JSR LE581                :\ Page in ROM X
JSR L8003                :\ Call ROM service entry point
TAX:BEQ LEE94            :\ Exit if call claimed
LDX &F4                  :\ Get ROM number
.LEE91
DEX:BPL LEE81            :\ Step down to next ROM, loop until all done

.LEE94
PLA:JSR LEDB0            :\ Restore paging state
PLA:JSR LE592            :\ Restore current ROM
TXA:RTS                  :\ Pass claim/noclaim to A

 
\ OSBYTE &6B (107) - Select memory for direct access
\ ============================================== 
.LEE9E
LDY #&20:BRA LEEA4  :\ Y=&20 to change 1MHz bit

\ OSBYTE &6C (108) - Select memory for direct access
\ ============================================== 
.LEEA2
LDY #&04         :\ Y=&04 to change RAM bit
.LEEA4
TYA:TRB LFE34    :\ Clear RAM or 1MHz bit
TXA:BEQ LEEB0    :\ If X=0, exit with normal RAM/1MHz selected
LDA #&04         :\ BUG! This should be TYA
TSB LFE34        :\ Page in shadow RAM
.LEEB0
RTS              :\ X preserved, Y=&04 or &20


\ OSBYTE
\ ====== 
.LEEB1
PHA              :\ EEB1= 48          H
PHP              :\ EEB2= 08          .
SEI              :\ EEB3= 78          x
STA &EF          :\ EEB4= 85 EF       .o
STX &F0          :\ EEB6= 86 F0       .p
STY &F1          :\ EEB8= 84 F1       .q
LDX #&07         :\ EEBA= A2 07       ".
CMP #&6B         :\ EEBC= C9 6B       Ik
BCC LEF00        :\ EEBE= 90 40       .@
CMP #&A6         :\ EEC0= C9 A6       I&
BCC LEECD        :\ EEC2= 90 09       ..
CMP #&A6         :\ EEC4= C9 A6       I&
BCC LEF0C        :\ EEC6= 90 44       .D
CLC              :\ EEC8= 18          .
.LEEC9
LDA #&A6         :\ EEC9= A9 A6       )&
ADC #&00         :\ EECB= 69 00       i.
.LEECD
SBC #&50         :\ EECD= E9 50       iP
.LEECF
ASL A            :\ EECF= 0A          .
SEC              :\ EED0= 38          8
.LEED1
STY &F1          :\ EED1= 84 F1       .q
TAY              :\ EED3= A8          (
BIT &025E        :\ EED4= 2C 5E 02    ,^.
BPL LEEE0        :\ EED7= 10 07       ..
TXA              :\ EED9= 8A          .
CLV              :\ EEDA= B8          8
JSR LEB04        :\ EEDB= 20 04 EB     .k
BVS LEEFA        :\ EEDE= 70 1A       p.
.LEEE0
LDA LEB69+1,Y      :\ EEE0= B9 6A EB    9jk
STA &FB          :\ EEE3= 85 FB       .{
LDA LEB69,Y      :\ EEE5= B9 69 EB    9ik
STA &FA          :\ EEE8= 85 FA       .z
LDA &EF          :\ EEEA= A5 EF       %o
LDY &F1          :\ EEEC= A4 F1       $q
BCS LEEF4        :\ EEEE= B0 04       0.
LDY #&00         :\ EEF0= A0 00        .
LDA (&F0)        :\ EEF2= B2 F0       2p
.LEEF4
SEC              :\ EEF4= 38          8
LDX &F0          :\ EEF5= A6 F0       &p
JSR LF8DF        :\ EEF7= 20 DF F8     _x
.LEEFA
ROR A            :\ EEFA= 6A          j
PLP              :\ EEFB= 28          (
ROL A            :\ EEFC= 2A          *
PLA              :\ EEFD= 68          h
CLV              :\ EEFE= B8          8
RTS              :\ EEFF= 60          `
 
.LEF00
LDY #&00         :\ EF00= A0 00        .
CMP #&1A         :\ EF02= C9 1A       I.
BCC LEECF        :\ EF04= 90 C9       .I
BRA LEF0C        :\ EF06= 80 04       ..
 
.LEF08
LDX #&08         :\ EF08= A2 08       ".
PLA              :\ EF0A= 68          h
PLA              :\ EF0B= 68          h
.LEF0C
JSR LEE72        :\ EF0C= 20 72 EE     rn
BNE LEF15        :\ EF0F= D0 04       P.
LDX &F0          :\ EF11= A6 F0       &p
BRA LEEFA        :\ EF13= 80 E5       .e
 
.LEF15
PLP              :\ EF15= 28          (
PLA              :\ EF16= 68          h
BIT LE34E        :\ EF17= 2C 4E E3    ,Nc
RTS              :\ EF1A= 60          `
 
.LEF1B
LDA &EB          :\ EF1B= A5 EB       %k
BMI LEF60        :\ EF1D= 30 41       0A
LDA &0257        :\ EF1F= AD 57 02    -W.
BNE LEF60        :\ EF22= D0 3C       P<
LDA #&08         :\ EF24= A9 08       ).
AND &E2          :\ EF26= 25 E2       %b
BNE LEF2E        :\ EF28= D0 04       P.
LDA #&88         :\ EF2A= A9 88       ).
AND &BB          :\ EF2C= 25 BB       %;
.LEF2E
RTS              :\ EF2E= 60          `
 
CMP #&03         :\ EF2F= C9 03       I.
BCS LEF08        :\ EF31= B0 D5       0U
JSR LF384        :\ EF33= 20 84 F3     .s
JMP L97B4        :\ EF36= 4C B4 97    L4.
 
PHA              :\ EF39= 48          H
PHP              :\ EF3A= 08          .
SEI              :\ EF3B= 78          x
STA &EF          :\ EF3C= 85 EF       .o
STX &F0          :\ EF3E= 86 F0       .p
STY &F1          :\ EF40= 84 F1       .q
LDX #&08         :\ EF42= A2 08       ".
CMP #&E0         :\ EF44= C9 E0       I`
BCS LEEC9        :\ EF46= B0 81       0.
CMP #&10         :\ EF48= C9 10       I.
BCS LEF0C        :\ EF4A= B0 C0       0@
ADC #&57         :\ EF4C= 69 57       iW
ASL A            :\ EF4E= 0A          .
BRA LEED1        :\ EF4F= 80 80       ..
 
JSR LEF63        :\ EF51= 20 63 EF     co
LDA (&FA)        :\ EF54= B2 FA       2z
STA (&F0),Y      :\ EF56= 91 F0       .p
RTS              :\ EF58= 60          `
 
JSR LEF63        :\ EF59= 20 63 EF     co
LDA (&F0),Y      :\ EF5C= B1 F0       1p
STA (&FA)        :\ EF5E= 92 FA       .z
.LEF60
LDA #&00         :\ EF60= A9 00       ).
RTS              :\ EF62= 60          `
 
.LEF63
STA &FA          :\ EF63= 85 FA       .z
INY              :\ EF65= C8          H
LDA (&F0),Y      :\ EF66= B1 F0       1p
STA &FB          :\ EF68= 85 FB       .{
LDY #&04         :\ EF6A= A0 04        .
.LEF6C
LDX #&03         :\ EF6C= A2 03       ".
RTS              :\ EF6E= 60          `
 
\ OSBYTE &00
\ ==========
.LEF6F
BNE LEF6C        :\ EF6F= D0 FB       P{
BRK              :\ EF71= 00          .
EQUB &F7         :\ EF72= F7          w
EQUB &4F         :\ EF73= 4F          O
EQUB &53         :\ EF74= 53          S
JSR &2E33        :\ EF75= 20 33 2E     3.
AND (&30)        :\ EF78= 32 30       20
BRK              :\ EF7A= 00          .
INY              :\ EF7B= C8          H
LDA (&F0),Y      :\ EF7C= B1 F0       1p
CMP #&20         :\ EF7E= C9 20       I 
BCS LEF08        :\ EF80= B0 86       0.
DEY              :\ EF82= 88          .
JSR LEFF6        :\ EF83= 20 F6 EF     vo
ORA #&04         :\ EF86= 09 04       ..
TAX              :\ EF88= AA          *
BCC LEF90        :\ EF89= 90 05       ..
JSR LE95A        :\ EF8B= 20 5A E9     Zi
LDY #&01         :\ EF8E= A0 01        .
.LEF90
JSR LEFF6        :\ EF90= 20 F6 EF     vo
STA &FA          :\ EF93= 85 FA       .z
PHP              :\ EF95= 08          .
LDY #&06         :\ EF96= A0 06        .
LDA (&F0),Y      :\ EF98= B1 F0       1p
PHA              :\ EF9A= 48          H
LDY #&04         :\ EF9B= A0 04        .
LDA (&F0),Y      :\ EF9D= B1 F0       1p
PHA              :\ EF9F= 48          H
LDY #&02         :\ EFA0= A0 02        .
LDA (&F0),Y      :\ EFA2= B1 F0       1p
ROL A            :\ EFA4= 2A          *
DEC A            :\ EFA5= 3A          :
DEC A            :\ EFA6= 3A          :
ASL A            :\ EFA7= 0A          .
ASL A            :\ EFA8= 0A          .
ORA &FA          :\ EFA9= 05 FA       .z
JSR LE9A3        :\ EFAB= 20 A3 E9     #i
BCC LEFCE        :\ EFAE= 90 1E       ..
PLA              :\ EFB0= 68          h
PLA              :\ EFB1= 68          h
PLP              :\ EFB2= 28          (
.LEFB3
LDX &D0          :\ EFB3= A6 D0       &P
RTS              :\ EFB5= 60          `
 
.LEFB6
PHP              :\ EFB6= 08          .
SEI              :\ EFB7= 78          x
LDA &0263        :\ EFB8= AD 63 02    -c.
AND #&07         :\ EFBB= 29 07       ).
ORA #&04         :\ EFBD= 09 04       ..
TAX              :\ EFBF= AA          *
LDA &0264        :\ EFC0= AD 64 02    -d.
JSR LEA40        :\ EFC3= 20 40 EA     @j
LDA &0266        :\ EFC6= AD 66 02    -f.
PHA              :\ EFC9= 48          H
LDA &0265        :\ EFCA= AD 65 02    -e.
PHA              :\ EFCD= 48          H
.LEFCE
SEC              :\ EFCE= 38          8
ROR &0800,X      :\ EFCF= 7E 00 08    ~..
PLA              :\ EFD2= 68          h
JSR LEA40        :\ EFD3= 20 40 EA     @j
PLA              :\ EFD6= 68          h
JSR LEA40        :\ EFD7= 20 40 EA     @j
PLP              :\ EFDA= 28          (
RTS              :\ EFDB= 60          `
 
DEC A            :\ EFDC= 3A          :
ASL A            :\ EFDD= 0A          .
ASL A            :\ EFDE= 0A          .
ASL A            :\ EFDF= 0A          .
ASL A            :\ EFE0= 0A          .
ORA #&0F         :\ EFE1= 09 0F       ..
TAX              :\ EFE3= AA          *
LDA #&00         :\ EFE4= A9 00       ).
LDY #&10         :\ EFE6= A0 10        .
.LEFE8
CPY #&0E         :\ EFE8= C0 0E       @.
BCS LEFEE        :\ EFEA= B0 02       0.
LDA (&F0),Y      :\ EFEC= B1 F0       1p
.LEFEE
STA &08C0,X      :\ EFEE= 9D C0 08    .@.
DEX              :\ EFF1= CA          J
DEY              :\ EFF2= 88          .
BNE LEFE8        :\ EFF3= D0 F3       Ps
RTS              :\ EFF5= 60          `
 
.LEFF6
LDA (&F0),Y      :\ EFF6= B1 F0       1p
CMP #&10         :\ EFF8= C9 10       I.
AND #&03         :\ EFFA= 29 03       ).
INY              :\ EFFC= C8          H
RTS              :\ EFFD= 60          `
 
LDX #&0F         :\ EFFE= A2 0F       ".
BRA LF005        :\ F000= 80 03       ..
 
LDX &0283        :\ F002= AE 83 02    ...
.LF005
LDY #&04         :\ F005= A0 04        .
.LF007
LDA &028D,X      :\ F007= BD 8D 02    =..
STA (&F0),Y      :\ F00A= 91 F0       .p
INX              :\ F00C= E8          h
DEY              :\ F00D= 88          .
BPL LF007        :\ F00E= 10 F7       .w
.LF010
RTS              :\ F010= 60          `
 
LDA #&0F         :\ F011= A9 0F       ).
BRA LF01B        :\ F013= 80 06       ..
 
LDA &0283        :\ F015= AD 83 02    -..
EOR #&0F         :\ F018= 49 0F       I.
CLC              :\ F01A= 18          .
.LF01B
PHA              :\ F01B= 48          H
TAX              :\ F01C= AA          *
LDY #&04         :\ F01D= A0 04        .
.LF01F
LDA (&F0),Y      :\ F01F= B1 F0       1p
STA &028D,X      :\ F021= 9D 8D 02    ...
INX              :\ F024= E8          h
DEY              :\ F025= 88          .
BPL LF01F        :\ F026= 10 F7       .w
PLA              :\ F028= 68          h
BCS LF010        :\ F029= B0 E5       0e
STA &0283        :\ F02B= 8D 83 02    ...
RTS              :\ F02E= 60          `

\ OSWORD &00 - Read Line
\ ======================
.LF02F
LDY #&04         :\ F02F= A0 04        .
.LF031
LDA (&F0),Y      :\ F031= B1 F0       1p
STA &02B1,Y      :\ F033= 99 B1 02    .1.
DEY              :\ F036= 88          .
CPY #&02         :\ F037= C0 02       @.
BCS LF031        :\ F039= B0 F6       0v
LDA (&F0),Y      :\ F03B= B1 F0       1p
STA &E9          :\ F03D= 85 E9       .i
DEY              :\ F03F= 88          .
STZ &0269        :\ F040= 9C 69 02    .i.
LDA (&F0)        :\ F043= B2 F0       2p
STA &E8          :\ F045= 85 E8       .h
CLI              :\ F047= 58          X
BRA LF051        :\ F048= 80 07       ..
 
.LF04A
LDA #&07         :\ F04A= A9 07       ).
.LF04C
DEY              :\ F04C= 88          .
.LF04D
INY              :\ F04D= C8          H
.LF04E
JSR OSWRCH       :\ F04E= 20 EE FF     n.
.LF051
JSR OSRDCH       :\ F051= 20 E0 FF     `.
BCS LF09F        :\ F054= B0 49       0I
TAX              :\ F056= AA          *
LDA &027C        :\ F057= AD 7C 02    -|.
ROR A            :\ F05A= 6A          j
ROR A            :\ F05B= 6A          j
TXA              :\ F05C= 8A          .
BCS LF064        :\ F05D= B0 05       0.
LDX &026A        :\ F05F= AE 6A 02    .j.
BNE LF04E        :\ F062= D0 EA       Pj
.LF064
CMP #&7F         :\ F064= C9 7F       I.
BNE LF06F        :\ F066= D0 07       P.
CPY #&00         :\ F068= C0 00       @.
BEQ LF051        :\ F06A= F0 E5       pe
DEY              :\ F06C= 88          .
BRA LF04E        :\ F06D= 80 DF       ._
 
.LF06F
CMP #&15         :\ F06F= C9 15       I.
BNE LF080        :\ F071= D0 0D       P.
TYA              :\ F073= 98          .
BEQ LF051        :\ F074= F0 DB       p[
LDA #&7F         :\ F076= A9 7F       ).
.LF078
JSR OSWRCH       :\ F078= 20 EE FF     n.
DEY              :\ F07B= 88          .
BNE LF078        :\ F07C= D0 FA       Pz
BRA LF051        :\ F07E= 80 D1       .Q
 
.LF080
STA (&E8),Y      :\ F080= 91 E8       .h
CMP #&0D         :\ F082= C9 0D       I.
BEQ LF099        :\ F084= F0 13       p.
CPY &02B3        :\ F086= CC B3 02    L3.
BCS LF04A        :\ F089= B0 BF       0?
CMP &02B4        :\ F08B= CD B4 02    M4.
BCC LF04C        :\ F08E= 90 BC       .<
CMP &02B5        :\ F090= CD B5 02    M5.
BEQ LF04D        :\ F093= F0 B8       p8
BCC LF04D        :\ F095= 90 B6       .6
BRA LF04C        :\ F097= 80 B3       .3
 
.LF099
JSR OSNEWL       :\ F099= 20 E7 FF     g.
JSR LEB04        :\ F09C= 20 04 EB     .k
.LF09F
LDA &FF          :\ F09F= A5 FF       %.
ROL A            :\ F0A1= 2A          *
RTS              :\ F0A2= 60          `
 
.LF0A3
PHX              :\ F0A3= DA          Z
LDX &027C        :\ F0A4= AE 7C 02    .|.
LDA #&0A         :\ F0A7= A9 0A       ).
JSR LE93C        :\ F0A9= 20 3C E9     <i
PLX              :\ F0AC= FA          z
LDA #&03         :\ F0AD= A9 03       ).
LDY #&00         :\ F0AF= A0 00        .
BRA LF0D6        :\ F0B1= 80 23       .#

.LF0B3
LSR &0246        :\ F0B3= 4E 46 02    NF.
BRA LF0CE        :\ F0B6= 80 16       ..

.LF0B8
LDA #&1F         :\ F0B8= A9 1F       ).
BRA LF0CC        :\ F0BA= 80 10       ..
 
.LF0BC
CLI              :\ F0BC= 58          X
SEI              :\ F0BD= 78          x
BIT &FF          :\ F0BE= 24 FF       $.
BMI LF0EB        :\ F0C0= 30 29       0)
BIT &02D1        :\ F0C2= 2C D1 02    ,Q.
BPL LF0BC        :\ F0C5= 10 F5       .u
JSR LE93C        :\ F0C7= 20 3C E9     <i
LDY #&00         :\ F0CA= A0 00        .
.LF0CC
STZ &F1          :\ F0CC= 64 F1       dq
.LF0CE
EOR #&F0         :\ F0CE= 49 F0       Ip
BRA LF0D9        :\ F0D0= 80 07       ..

.LF0D2
BEQ LF107        :\ F0D2= F0 33       p3
.LF0D4
ADC #&CF         :\ F0D4= 69 CF       iO
.LF0D6
CLC              :\ F0D6= 18          .
ADC #&E9         :\ F0D7= 69 E9       ii
.LF0D9
STX &F0          :\ F0D9= 86 F0       .p
.LF0DB
TAY              :\ F0DB= A8          (
LDA &0190,Y      :\ F0DC= B9 90 01    9..
TAX              :\ F0DF= AA          *
AND &F1          :\ F0E0= 25 F1       %q
EOR &F0          :\ F0E2= 45 F0       Ep
STA &0190,Y      :\ F0E4= 99 90 01    ...
LDA &0191,Y      :\ F0E7= B9 91 01    9..
TAY              :\ F0EA= A8          (
.LF0EB
RTS              :\ F0EB= 60          `
 
.LF0EC
STZ &7F          :\ F0EC= 64 7F       d.
EQUB &5B         :\ F0EE= 5B          [
ADC &7649        :\ F0EF= 6D 49 76    mIv
EOR (&64)        :\ F0F2= 52 64       Rd
RTI              :\ F0F4= 40          @

.LF0F5
LDA &0240        :\ F0F5= AD 40 02    -@.
.LF0F8
CLI              :\ F0F8= 58          X
SEI              :\ F0F9= 78          x
CMP &0240        :\ F0FA= CD 40 02    M@.
BEQ LF0F8        :\ F0FD= F0 F9       py
.LF0FF
LDY &0301,X      :\ F0FF= BC 01 03    <..
LDA &0300,X      :\ F102= BD 00 03    =..
TAX              :\ F105= AA          *
RTS              :\ F106= 60          `
 
.LF107
JSR LF384        :\ F107= 20 84 F3     .s
JSR L8B3A        :\ F10A= 20 3A 8B     :.
STY &0254        :\ F10D= 8C 54 02    .T.
JSR L8B3F        :\ F110= 20 3F 8B     ?.
LDX &0255        :\ F113= AE 55 02    .U.
STY &0255        :\ F116= 8C 55 02    .U.
RTS              :\ F119= 60          `
 
.LF11A
SEC              :\ F11A= 38          8
ROR &0284        :\ F11B= 6E 84 02    n..
LDA &F4          :\ F11E= A5 F4       %t
PHA              :\ F120= 48          H
JSR LE57F        :\ F121= 20 7F E5     .e
LDX #&10         :\ F124= A2 10       ".
.LF126
LDA #&22         :\ F126= A9 22       )"
STA L8000,X      :\ F128= 9D 00 80    ...
LDA #&80         :\ F12B= A9 80       ).
STA L8011,X      :\ F12D= 9D 11 80    ...
DEX              :\ F130= CA          J
BPL LF126        :\ F131= 10 F3       .s
PLA              :\ F133= 68          h
JSR LE592        :\ F134= 20 92 E5     .e
STZ &0268        :\ F137= 9C 68 02    .h.
STZ &0284        :\ F13A= 9C 84 02    ...
INX              :\ F13D= E8          h
RTS              :\ F13E= 60          `
 
AND &0360        :\ F13F= 2D 60 03    -`.
TAX              :\ F142= AA          *
LDA &036F,X      :\ F143= BD 6F 03    =o.
.LF146
INY              :\ F146= C8          H
.LF147
STA (&F0),Y      :\ F147= 91 F0       .p
LDA #&00         :\ F149= A9 00       ).
CPY #&04         :\ F14B= C0 04       @.
BNE LF146        :\ F14D= D0 F7       Pw
RTS              :\ F14F= 60          `
 
JSR LF3AB        :\ F150= 20 AB F3     +s
LDY #&03         :\ F153= A0 03        .
.LF155
LDA (&F0),Y      :\ F155= B1 F0       1p
STA &0328,Y      :\ F157= 99 28 03    .(.
LDA &0310,Y      :\ F15A= B9 10 03    9..
PHA              :\ F15D= 48          H
DEY              :\ F15E= 88          .
BPL LF155        :\ F15F= 10 F4       .t
LDA #&28         :\ F161= A9 28       )(
JSR LDDB7        :\ F163= 20 B7 DD     7]
TAX              :\ F166= AA          *
LDY #&00         :\ F167= A0 00        .
.LF169
PLA              :\ F169= 68          h
STA &0310,Y      :\ F16A= 99 10 03    ...
INY              :\ F16D= C8          H
CPY #&04         :\ F16E= C0 04       @.
BNE LF169        :\ F170= D0 F7       Pw
TXA              :\ F172= 8A          .
BRA LF147        :\ F173= 80 D2       .R
 
JSR LE22C        :\ F175= 20 2C E2     ,b
LDY #&00         :\ F178= A0 00        .
LDA &F4          :\ F17A= A5 F4       %t
PHA              :\ F17C= 48          H
JSR LE57F        :\ F17D= 20 7F E5     .e
.LF180
LDA (&DE),Y      :\ F180= B1 DE       1^
INY              :\ F182= C8          H
STA (&F0),Y      :\ F183= 91 F0       .p
CPY #&08         :\ F185= C0 08       @.
BNE LF180        :\ F187= D0 F7       Pw
PLX              :\ F189= FA          z
JMP LE581        :\ F18A= 4C 81 E5    L.e
 
JSR LF3AB        :\ F18D= 20 AB F3     +s
PHP              :\ F190= 08          .
AND &0360        :\ F191= 2D 60 03    -`.
TAX              :\ F194= AA          *
INY              :\ F195= C8          H
LDA (&F0),Y      :\ F196= B1 F0       1p
JMP LC639        :\ F198= 4C 39 C6    L9F
 
JSR LF3AB        :\ F19B= 20 AB F3     +s
LDA #&03         :\ F19E= A9 03       ).
JSR LF1A5        :\ F1A0= 20 A5 F1     %q
LDA #&07         :\ F1A3= A9 07       ).
.LF1A5
PHA              :\ F1A5= 48          H
JSR LE2B6        :\ F1A6= 20 B6 E2     6b
JSR LC4DF        :\ F1A9= 20 DF C4     _D
LDX #&03         :\ F1AC= A2 03       ".
PLA              :\ F1AE= 68          h
TAY              :\ F1AF= A8          (
.LF1B0
LDA &0310,X      :\ F1B0= BD 10 03    =..
STA (&F0),Y      :\ F1B3= 91 F0       .p
DEY              :\ F1B5= 88          .
DEX              :\ F1B6= CA          J
BPL LF1B0        :\ F1B7= 10 F7       .w
RTS              :\ F1B9= 60          `

\ Read address of bottom of screen/top of user memory
\ ===================================================
.LF1BA 
LDA &D0            :\ Get VDU status
BIT #&10:BNE LF1D8 :\ If shadow screen, jump to return &8000
.LF1C0
LDA &0355          :\ Get current screen MODE

\ Return start of screen for non-shadow MODE in X
\ -----------------------------------------------
.LF1C3
AND #&07:TAY
LDX LE168,Y      :\ Get screen map for supplied MODE
LDA LE17E,X      :\ Get address top byte for this screen map
.LF1CC
LDX #&00:TAY     :\ Address=&xx00
RTS

\ Read address bottom of screen for MODE in X
\ ===========================================
.LF1D0
TXA:BMI LF1D8        :\ If MODE &80+n, return &8000
LDX &027F:BNE LF1C3  :\ If *SHADOW<>0, jump to return non-shadow address
.LF1D8
LDA #&80:BRA LF1CC   :\ Return &8000

.LF1DC
JSR LF3AB        :\ F1DC= 20 AB F3     +s
JMP LDDF8        :\ F1DF= 4C F8 DD    Lx]
 
.LF1E2
ASL A            :\ F1E2= 0A          .
.LF1E3
AND #&01         :\ F1E3= 29 01       ).
.LF1E5
JMP (&021E)      :\ F1E5= 6C 1E 02    l..

\ OSWORD &0F - Write to RTC
\ =========================
.LF1E8
JSR LF384        :\ Page in ROM 15
JMP L9656        :\ Jump to OSWORD &0F routine


\ Set TAPE/ROM extended vectors
\ =============================
.LF1EE
LDX #&15
.LF1F0
LDA LF1FA-1,X:STA &0DB9,X
DEX:BNE LF1F0
.LF1F9
RTS

\ TAPE/ROM extended vector values
\ -------------------------------
.LF1FA
EQUW LA08C:EQUB 15 :\ FILEV
EQUW L9F29:EQUB 15 :\ ARGSV
EQUW LA2EA:EQUB 15 :\ BPUTV
EQUW LA34B:EQUB 15 :\ BGETV
EQUW LA36D:EQUB 15 :\ GBPBV
EQUW LA1F9:EQUB 15 :\ FINDV
EQUW L9F8C:EQUB 15 :\ FSCV 

\ OSBYTE &6x - Make temporary FS permanant
\ ========================================
.LF20F
LDX HAZEL_WORKSPACE+&01:STX HAZEL_WORKSPACE+&00     :\ Copy active FS to current FS
LDA &0DBC:STA HAZEL_WORKSPACE+&03     :\ Copy XFILEV ROM to current FS ROM number
RTS

.LF21C
JSR LF384        :\ F21C= 20 84 F3     .s
JMP L92A4        :\ F21F= 4C A4 92    L$.
 
.LF222
JSR LF384        :\ F222= 20 84 F3     .s
JMP L92A8        :\ F225= 4C A8 92    L(.
 
\ OSBYTE &26 - Increment ROM polling semaphore
\ ========================================
.LF228
INC &0243        :\ F228= EE 43 02    nC.
RTS              :\ F22B= 60          `
 
\ OSBYTE &27 - Decrement ROM polling semaphore
\ ========================================
.LF22C
DEC &0243        :\ F22C= CE 43 02    NC.
RTS              :\ F22F= 60          `

\ OSBYTE &76 - Set LEDs to keyboard state
\ =======================================
.LF230
PHP:SEI              :\ Disable IRQs
LDA #&40:JSR LF241   :\ Turn on LEDs
BMI LF23E            :\ Exit if Escape pending
CLC:CLV:JSR LF902    :\ Call KEYV to read SHIFT and CTRL
\ Returns A.b7=CTRL, A.b6=SHIFT, MI=CTRL, VS=SHIFT
.LF23E
PLP                  :\ Restore IRQs
ROL A:RTS            :\ Set Carry from A bit 7 and return
\ Returns A.b7=SHIFT, CS=CTRL

\ Set keyboard LEDs
\ -----------------
.LF241
BCC LF24C            :\ Skip if not called from OSBYTE
LDY #&07:STY SYSTEM_VIA+&0   :\ Turn ShiftLock LED on
DEY:STY SYSTEM_VIA+&0        :\ Turn CapsLock LED on
.LF24C
BIT &FF:RTS          :\ Test Escape and return

.LF24F
TXA              :\ F24F= 8A          .
.LF250
PHP              :\ F250= 08          .
SEI              :\ F251= 78          x
STA &0248        :\ F252= 8D 48 02    .H.
STA VCONTROL        :\ F255= 8D 20 FE    . ~
LDA &0253        :\ F258= AD 53 02    -S.
STA &0251        :\ F25B= 8D 51 02    .Q.
PLP              :\ F25E= 28          (
RTS              :\ F25F= 60          `

.LF260
TXA              :\ F260= 8A          .
.LF261
EOR #&07         :\ F261= 49 07       I.
PHP              :\ F263= 08          .
SEI              :\ F264= 78          x
STA &0249        :\ F265= 8D 49 02    .I.
STA VPALETTE        :\ F268= 8D 21 FE    .!~
PLP              :\ F26B= 28          (
RTS              :\ F26C= 60          `
 
.LF26D
CLC              :\ F26D= 18          .
.LF26E
ROR &E4          :\ F26E= 66 E4       fd
JSR LF2FF        :\ F270= 20 FF F2     .r
INY              :\ F273= C8          H
CMP #&22         :\ F274= C9 22       I"
BEQ LF27A        :\ F276= F0 02       p.
DEY              :\ F278= 88          .
CLC              :\ F279= 18          .
.LF27A
ROR &E4          :\ F27A= 66 E4       fd
CMP #&0D         :\ F27C= C9 0D       I.
RTS              :\ F27E= 60          `
 
.LF27F
LDA #&01         :\ F27F= A9 01       ).
TSB &E4          :\ F281= 04 E4       .d
JSR LF29C        :\ F283= 20 9C F2     .r
PHP              :\ F286= 08          .
LSR &E4          :\ F287= 46 E4       Fd
BCC LF28F        :\ F289= 90 04       ..
ROL &E4          :\ F28B= 26 E4       &d
PLP              :\ F28D= 28          (
RTS              :\ F28E= 60          `
 
.LF28F
BRK              :\ F28F= 00          .
SBC &6142,X      :\ F290= FD 42 61    }Ba
STZ &20          :\ F293= 64 20       d 
EQUB &73         :\ F295= 73          s
STZ &72,X        :\ F296= 74 72       tr
ADC #&6E         :\ F298= 69 6E       in
EQUB &67         :\ F29A= 67          g
BRK              :\ F29B= 00          .
.LF29C
CLC              :\ F29C= 18          .
.LF29D
STZ &E5          :\ F29D= 64 E5       de
ROR &E5          :\ F29F= 66 E5       fe
LDA (&F2),Y      :\ F2A1= B1 F2       1r
CMP #&0D         :\ F2A3= C9 0D       I.
BNE LF2B0        :\ F2A5= D0 09       P.
BIT &E4          :\ F2A7= 24 E4       $d
BPL LF2CB        :\ F2A9= 10 20       . 
.LF2AB
LDA #&01         :\ F2AB= A9 01       ).
TRB &E4          :\ F2AD= 14 E4       .d
RTS              :\ F2AF= 60          `
 
.LF2B0
CMP #&20         :\ F2B0= C9 20       I 
BCC LF2AB        :\ F2B2= 90 F7       .w
BNE LF2BC        :\ F2B4= D0 06       P.
BIT &E4          :\ F2B6= 24 E4       $d
BMI LF2F8        :\ F2B8= 30 3E       0>
BVC LF2CB        :\ F2BA= 50 0F       P.
.LF2BC
CMP #&22         :\ F2BC= C9 22       I"
BNE LF2D0        :\ F2BE= D0 10       P.
BIT &E4          :\ F2C0= 24 E4       $d
BPL LF2F8        :\ F2C2= 10 34       .4
INY              :\ F2C4= C8          H
LDA (&F2),Y      :\ F2C5= B1 F2       1r
CMP #&22         :\ F2C7= C9 22       I"
BEQ LF2F8        :\ F2C9= F0 2D       p-
.LF2CB
JSR LF2FF        :\ F2CB= 20 FF F2     .r
SEC              :\ F2CE= 38          8
RTS              :\ F2CF= 60          `
 
.LF2D0
CMP #&7C         :\ F2D0= C9 7C       I|
BNE LF2F8        :\ F2D2= D0 24       P$
INY              :\ F2D4= C8          H
LDA (&F2),Y      :\ F2D5= B1 F2       1r
CMP #&7C         :\ F2D7= C9 7C       I|
BEQ LF2F8        :\ F2D9= F0 1D       p.
CMP #&22         :\ F2DB= C9 22       I"
BEQ LF2F8        :\ F2DD= F0 19       p.
CMP #&21         :\ F2DF= C9 21       I!
BNE LF2E6        :\ F2E1= D0 03       P.
INY              :\ F2E3= C8          H
BRA LF29D        :\ F2E4= 80 B7       .7
 
.LF2E6
CMP #&20         :\ F2E6= C9 20       I 
BCC LF2AB        :\ F2E8= 90 C1       .A
CMP #&3F         :\ F2EA= C9 3F       I?
BEQ LF2F6        :\ F2EC= F0 08       p.
JSR LF336        :\ F2EE= 20 36 F3     6s
BIT LE34E        :\ F2F1= 2C 4E E3    ,Nc
BRA LF2F9        :\ F2F4= 80 03       ..
 
.LF2F6
LDA #&7F         :\ F2F6= A9 7F       ).
.LF2F8
CLV              :\ F2F8= B8          8
.LF2F9
INY              :\ F2F9= C8          H
ORA &E5          :\ F2FA= 05 E5       .e
CLC              :\ F2FC= 18          .
RTS              :\ F2FD= 60          `
 
.LF2FE
INY              :\ F2FE= C8          H
.LF2FF
LDA (&F2),Y      :\ F2FF= B1 F2       1r
CMP #&20         :\ F301= C9 20       I 
BEQ LF2FE        :\ F303= F0 F9       py
.LF305
CMP #&0D         :\ F305= C9 0D       I.
RTS              :\ F307= 60          `
 
.LF308
BCC LF2FF        :\ F308= 90 F5       .u
.LF30A
JSR LF2FF        :\ F30A= 20 FF F2     .r
CMP #&2C         :\ F30D= C9 2C       I,
BNE LF305        :\ F30F= D0 F4       Pt
INY              :\ F311= C8          H
RTS              :\ F312= 60          `
 
.LF313
CMP #&30         :\ F313= C9 30       I0
BEQ LF335        :\ F315= F0 1E       p.
CMP #&40         :\ F317= C9 40       I@
BEQ LF335        :\ F319= F0 1A       p.
BCC LF32F        :\ F31B= 90 12       ..
CMP #&7F         :\ F31D= C9 7F       I.
BEQ LF335        :\ F31F= F0 14       p.
BCS LF333        :\ F321= B0 10       0.
.LF323
EOR #&30         :\ F323= 49 30       I0
CMP #&6F         :\ F325= C9 6F       Io
BEQ LF32D        :\ F327= F0 04       p.
CMP #&50         :\ F329= C9 50       IP
BNE LF32F        :\ F32B= D0 02       P.
.LF32D
EOR #&1F         :\ F32D= 49 1F       I.
.LF32F
CMP #&21         :\ F32F= C9 21       I!
BCC LF335        :\ F331= 90 02       ..
.LF333
EOR #&10         :\ F333= 49 10       I.
.LF335
RTS              :\ F335= 60          `
 
.LF336
CMP #&7F         :\ F336= C9 7F       I.
BEQ LF348        :\ F338= F0 0E       p.
BCS LF323        :\ F33A= B0 E7       0g
CMP #&60         :\ F33C= C9 60       I`
BNE LF342        :\ F33E= D0 02       P.
LDA #&5F         :\ F340= A9 5F       )_
.LF342
CMP #&40         :\ F342= C9 40       I@
BCC LF348        :\ F344= 90 02       ..
AND #&1F         :\ F346= 29 1F       ).
.LF348
RTS              :\ F348= 60          `
 
.LF349
LDA &0287        :\ F349= AD 87 02    -..
EOR #&4C         :\ F34C= 49 4C       IL
BNE LF363        :\ F34E= D0 13       P.
JMP &0287        :\ F350= 4C 87 02    L..
 
.LF353
LDA &0290        :\ F353= AD 90 02    -..
STX &0290        :\ F356= 8E 90 02    ...
TAX              :\ F359= AA          *
TYA              :\ F35A= 98          .
AND #&01         :\ F35B= 29 01       ).
LDY &0291        :\ F35D= AC 91 02    ,..
STA &0291        :\ F360= 8D 91 02    ...
.LF363
RTS              :\ F363= 60          `

.LF364
TYA              :\ F364= 98          .
STA &FD00,X      :\ F365= 9D 00 FD    ..}
RTS              :\ F368= 60          `

.LF369
TYA              :\ F369= 98          .
STA &FE00,X      :\ F36A= 9D 00 FE    ..~
RTS              :\ F36D= 60          `

.LF36E
TYA              :\ F36E= 98          .
STA &FC00,X      :\ F36F= 9D 00 FC    ..|
RTS              :\ F372= 60          `

.LF373
LDX #&26:JMP LEE72        :\ F375= 4C 72 EE    Lrn
 
PHP              :\ F378= 08          .
PHA              :\ F379= 48          H
PHX              :\ F37A= DA          Z
TSX              :\ F37B= BA          :
LDA &0104,X      :\ F37C= BD 04 01    =..
JSR LE592        :\ F37F= 20 92 E5     .e
BRA LF3E1        :\ F382= 80 5D       .]
 
.LF384
PHA              :\ F384= 48          H
PHA              :\ F385= 48          H
PHA              :\ F386= 48          H
PHP              :\ F387= 08          .
PHA              :\ F388= 48          H
PHX              :\ F389= DA          Z
TSX              :\ F38A= BA          :
LDA &0107,X      :\ F38B= BD 07 01    =..
STA &0104,X      :\ F38E= 9D 04 01    ...
LDA &0108,X      :\ F391= BD 08 01    =..
STA &0105,X      :\ F394= 9D 05 01    ...
LDA &F4          :\ F397= A5 F4       %t
STA &0108,X      :\ F399= 9D 08 01    ...
LDA #&F3         :\ F39C= A9 F3       )s
STA &0107,X      :\ F39E= 9D 07 01    ...
LDA #&77         :\ F3A1= A9 77       )w
STA &0106,X      :\ F3A3= 9D 06 01    ...
JSR LE590        :\ F3A6= 20 90 E5     .e
BRA LF3D3        :\ F3A9= 80 28       .(
 
.LF3AB
PHA              :\ F3AB= 48          H
PHA              :\ F3AC= 48          H
PHA              :\ F3AD= 48          H
PHP              :\ F3AE= 08          .
PHA              :\ F3AF= 48          H
PHX              :\ F3B0= DA          Z
TSX              :\ F3B1= BA          :
LDA &0108,X      :\ F3B2= BD 08 01    =..
STA &0105,X      :\ F3B5= 9D 05 01    ...
LDA &0107,X      :\ F3B8= BD 07 01    =..
STA &0104,X      :\ F3BB= 9D 04 01    ...
LDA #&F3         :\ F3BE= A9 F3       )s
STA &0107,X      :\ F3C0= 9D 07 01    ...
LDA #&D6         :\ F3C3= A9 D6       )V
STA &0106,X      :\ F3C5= 9D 06 01    ...
LDA LFE34        :\ F3C8= AD 34 FE    -4~
STA &0108,X      :\ F3CB= 9D 08 01    ...
LDA #&08         :\ F3CE= A9 08       ).
TRB LFE34        :\ F3D0= 1C 34 FE    .4~
.LF3D3
PLX              :\ F3D3= FA          z
PLA              :\ F3D4= 68          h
PLP              :\ F3D5= 28          (
RTS              :\ F3D6= 60          `
 
PHP              :\ F3D7= 08          .
PHA              :\ F3D8= 48          H
PHX              :\ F3D9= DA          Z
TSX              :\ F3DA= BA          :
LDA &0104,X      :\ F3DB= BD 04 01    =..
JSR LEDB0        :\ F3DE= 20 B0 ED     0m
.LF3E1
LDA &0103,X      :\ F3E1= BD 03 01    =..
STA &0104,X      :\ F3E4= 9D 04 01    ...
PLX              :\ F3E7= FA          z
PLA              :\ F3E8= 68          h
PLP              :\ F3E9= 28          (
PLP              :\ F3EA= 28          (
RTS              :\ F3EB= 60          `
 
.LF3EC
JSR LF3AB        :\ F3EC= 20 AB F3     +s
LDX &F4          :\ F3EF= A6 F4       &t
PHX              :\ F3F1= DA          Z
JSR LE57F        :\ F3F2= 20 7F E5     .e
JSR LC027        :\ F3F5= 20 27 C0     '@
PLX              :\ F3F8= FA          z
JMP LE581        :\ F3F9= 4C 81 E5    L.e
 
.LF3FC
JSR LF3AB        :\ F3FC= 20 AB F3     +s
JMP LC018        :\ F3FF= 4C 18 C0    L.@
 
.LF402
JSR LF3AB        :\ F402= 20 AB F3     +s
JMP LDB5F        :\ F405= 4C 5F DB    L_[
 
EQUB &2F         :\ F408= 2F          /
AND (&42,X)      :\ F409= 21 42       !B
.LF40B
EQUB &4F         :\ F40B= 4F          O
EQUB &4F         :\ F40C= 4F          O
EQUB &54         :\ F40D= 54          T
ORA LC0E0        :\ F40E= 0D E0 C0    .`@
LDY #&80         :\ F411= A0 80        .
.LF413
JMP LF520        :\ F413= 4C 20 F5    L u
 
.LF416
LDX #&00         :\ F416= A2 00       ".
LDA &0838        :\ F418= AD 38 08    -8.
BNE LF421        :\ F41B= D0 04       P.
INX              :\ F41D= E8          h
DEC &0838        :\ F41E= CE 38 08    N8.
.LF421
STX &083B        :\ F421= 8E 3B 08    .;.
LDX #&08         :\ F424= A2 08       ".
.LF426
DEX              :\ F426= CA          J
LDA &0800,X      :\ F427= BD 00 08    =..
BEQ LF413        :\ F42A= F0 E7       pg
LDA &02CE,X      :\ F42C= BD CE 02    =N.
BMI LF436        :\ F42F= 30 05       0.
LDA &0818,X      :\ F431= BD 18 08    =..
BNE LF43E        :\ F434= D0 08       P.
.LF436
JSR LF528        :\ F436= 20 28 F5     (u
LDA &0818,X      :\ F439= BD 18 08    =..
BEQ LF450        :\ F43C= F0 12       p.
.LF43E
INC A            :\ F43E= 1A          .
BEQ LF453        :\ F43F= F0 12       p.
DEC &081C,X      :\ F441= DE 1C 08    ^..
BNE LF453        :\ F444= D0 0D       P.
LDA #&05         :\ F446= A9 05       ).
STA &081C,X      :\ F448= 9D 1C 08    ...
DEC &0818,X      :\ F44B= DE 18 08    ^..
BNE LF453        :\ F44E= D0 03       P.
.LF450
JSR LF528        :\ F450= 20 28 F5     (u
.LF453
LDA &0824,X      :\ F453= BD 24 08    =$.
BEQ LF45D        :\ F456= F0 05       p.
DEC &0824,X      :\ F458= DE 24 08    ^$.
BNE LF413        :\ F45B= D0 B6       P6
.LF45D
LDY &0820,X      :\ F45D= BC 20 08    < .
CPY #&FF         :\ F460= C0 FF       @.
BEQ LF413        :\ F462= F0 AF       p/
LDA &08C0,Y      :\ F464= B9 C0 08    9@.
AND #&7F         :\ F467= 29 7F       ).
STA &0824,X      :\ F469= 9D 24 08    .$.
LDA &0808,X      :\ F46C= BD 08 08    =..
CMP #&04         :\ F46F= C9 04       I.
BEQ LF4D0        :\ F471= F0 5D       p]
CLC              :\ F473= 18          .
ADC &0820,X      :\ F474= 7D 20 08    } .
TAY              :\ F477= A8          (
LDA &08CB,Y      :\ F478= B9 CB 08    9K.
SEC              :\ F47B= 38          8
SBC #&3F         :\ F47C= E9 3F       i?
STA &083A        :\ F47E= 8D 3A 08    .:.
LDA &08C7,Y      :\ F481= B9 C7 08    9G.
STA &0839        :\ F484= 8D 39 08    .9.
LDA &0804,X      :\ F487= BD 04 08    =..
.LF48A
PHA              :\ F48A= 48          H
CLC              :\ F48B= 18          .
ADC &0839        :\ F48C= 6D 39 08    m9.
BVC LF498        :\ F48F= 50 07       P.
ROL A            :\ F491= 2A          *
LDA #&3F         :\ F492= A9 3F       )?
BCS LF498        :\ F494= B0 02       0.
EOR #&FF         :\ F496= 49 FF       I.
.LF498
STA &0804,X      :\ F498= 9D 04 08    ...
ROL A            :\ F49B= 2A          *
EOR &0804,X      :\ F49C= 5D 04 08    ]..
BPL LF4AA        :\ F49F= 10 09       ..
LDA #&3F         :\ F4A1= A9 3F       )?
BCC LF4A7        :\ F4A3= 90 02       ..
EOR #&FF         :\ F4A5= 49 FF       I.
.LF4A7
STA &0804,X      :\ F4A7= 9D 04 08    ...
.LF4AA
DEC &0839        :\ F4AA= CE 39 08    N9.
LDA &0804,X      :\ F4AD= BD 04 08    =..
SEC              :\ F4B0= 38          8
SBC &083A        :\ F4B1= ED 3A 08    m:.
EOR &0839        :\ F4B4= 4D 39 08    M9.
BMI LF4C2        :\ F4B7= 30 09       0.
LDA &083A        :\ F4B9= AD 3A 08    -:.
STA &0804,X      :\ F4BC= 9D 04 08    ...
INC &0808,X      :\ F4BF= FE 08 08    ~..
.LF4C2
PLA              :\ F4C2= 68          h
EOR &0804,X      :\ F4C3= 5D 04 08    ]..
AND #&F8         :\ F4C6= 29 F8       )x
BEQ LF4D0        :\ F4C8= F0 06       p.
LDA &0804,X      :\ F4CA= BD 04 08    =..
JSR LF599        :\ F4CD= 20 99 F5     .u
.LF4D0
LDA &0810,X      :\ F4D0= BD 10 08    =..
CMP #&03         :\ F4D3= C9 03       I.
BEQ LF520        :\ F4D5= F0 49       pI
LDA &0814,X      :\ F4D7= BD 14 08    =..
BNE LF504        :\ F4DA= D0 28       P(
INC &0810,X      :\ F4DC= FE 10 08    ~..
LDA &0810,X      :\ F4DF= BD 10 08    =..
CMP #&03         :\ F4E2= C9 03       I.
BNE LF4F4        :\ F4E4= D0 0E       P.
LDY &0820,X      :\ F4E6= BC 20 08    < .
LDA &08C0,Y      :\ F4E9= B9 C0 08    9@.
BMI LF520        :\ F4EC= 30 32       02
STZ &0830,X      :\ F4EE= 9E 30 08    .0.
STZ &0810,X      :\ F4F1= 9E 10 08    ...
.LF4F4
LDA &0810,X      :\ F4F4= BD 10 08    =..
CLC              :\ F4F7= 18          .
ADC &0820,X      :\ F4F8= 7D 20 08    } .
TAY              :\ F4FB= A8          (
LDA &08C4,Y      :\ F4FC= B9 C4 08    9D.
STA &0814,X      :\ F4FF= 9D 14 08    ...
BEQ LF520        :\ F502= F0 1C       p.
.LF504
DEC &0814,X      :\ F504= DE 14 08    ^..
LDA &0820,X      :\ F507= BD 20 08    = .
CLC              :\ F50A= 18          .
ADC &0810,X      :\ F50B= 7D 10 08    }..
TAY              :\ F50E= A8          (
LDA &08C1,Y      :\ F50F= B9 C1 08    9A.
CLC              :\ F512= 18          .
ADC &0830,X      :\ F513= 7D 30 08    }0.
STA &0830,X      :\ F516= 9D 30 08    .0.
CLC              :\ F519= 18          .
ADC &080C,X      :\ F51A= 7D 0C 08    }..
JSR LF5D5        :\ F51D= 20 D5 F5     Uu
.LF520
CPX #&04         :\ F520= E0 04       `.
BEQ LF527        :\ F522= F0 03       p.
JMP LF426        :\ F524= 4C 26 F4    L&t
 
.LF527
RTS              :\ F527= 60          `
 
.LF528
LDA &0808,X      :\ F528= BD 08 08    =..
CMP #&04         :\ F52B= C9 04       I.
BEQ LF534        :\ F52D= F0 05       p.
LDA #&03         :\ F52F= A9 03       ).
STA &0808,X      :\ F531= 9D 08 08    ...
.LF534
LDA &02CE,X      :\ F534= BD CE 02    =N.
BEQ LF54D        :\ F537= F0 14       p.
LDA #&00         :\ F539= A9 00       ).
STZ &02CE,X      :\ F53B= 9E CE 02    .N.
LDY #&04         :\ F53E= A0 04        .
.LF540
STA &082B,Y      :\ F540= 99 2B 08    .+.
DEY              :\ F543= 88          .
BNE LF540        :\ F544= D0 FA       Pz
STZ &0818,X      :\ F546= 9E 18 08    ...
DEY              :\ F549= 88          .
STY &0838        :\ F54A= 8C 38 08    .8.
.LF54D
LDA &0828,X      :\ F54D= BD 28 08    =(.
BEQ LF5B2        :\ F550= F0 60       p`
LDA &083B        :\ F552= AD 3B 08    -;.
BEQ LF58B        :\ F555= F0 34       p4
STZ &0828,X      :\ F557= 9E 28 08    .(.
.LF55A
JMP LF685        :\ F55A= 4C 85 F6    L.v
 
.LF55D
JSR LF592        :\ F55D= 20 92 F5     .u
TYA              :\ F560= 98          .
STZ &0818,X      :\ F561= 9E 18 08    ...
STZ &02CE,X      :\ F564= 9E CE 02    .N.
STZ &0800,X      :\ F567= 9E 00 08    ...
LDY #&03         :\ F56A= A0 03        .
.LF56C
STA &082C,Y      :\ F56C= 99 2C 08    .,.
DEY              :\ F56F= 88          .
BPL LF56C        :\ F570= 10 FA       .z
STY &0838        :\ F572= 8C 38 08    .8.
BRA LF5DA        :\ F575= 80 63       .c
 
.LF577
PHP              :\ F577= 08          .
SEI              :\ F578= 78          x
LDA &0808,X      :\ F579= BD 08 08    =..
CMP #&04         :\ F57C= C9 04       I.
BNE LF58A        :\ F57E= D0 0A       P.
JSR LE9EF        :\ F580= 20 EF E9     oi
BCC LF58A        :\ F583= 90 05       ..
LDA #&00         :\ F585= A9 00       ).
STZ &0800,X      :\ F587= 9E 00 08    ...
.LF58A
PLP              :\ F58A= 28          (
.LF58B
LDY &0820,X      :\ F58B= BC 20 08    < .
CPY #&FF         :\ F58E= C0 FF       @.
BNE LF604        :\ F590= D0 72       Pr
.LF592
LDA #&04         :\ F592= A9 04       ).
STA &0808,X      :\ F594= 9D 08 08    ...
LDA #&C0         :\ F597= A9 C0       )@
.LF599
STA &0804,X      :\ F599= 9D 04 08    ...
LDY &0262        :\ F59C= AC 62 02    ,b.
BEQ LF5A3        :\ F59F= F0 02       p.
LDA #&C0         :\ F5A1= A9 C0       )@
.LF5A3
SEC              :\ F5A3= 38          8
SBC #&40         :\ F5A4= E9 40       i@
LSR A            :\ F5A6= 4A          J
LSR A            :\ F5A7= 4A          J
LSR A            :\ F5A8= 4A          J
EOR #&0F         :\ F5A9= 49 0F       I.
ORA LF40B,X      :\ F5AB= 1D 0B F4    ..t
ORA #&10         :\ F5AE= 09 10       ..
BRA LF5E6        :\ F5B0= 80 34       .4
 
.LF5B2
JSR LE9EF        :\ F5B2= 20 EF E9     oi
BCS LF577        :\ F5B5= B0 C0       0@
AND #&03         :\ F5B7= 29 03       ).
BEQ LF55A        :\ F5B9= F0 9F       p.
LDA &0838        :\ F5BB= AD 38 08    -8.
BEQ LF58B        :\ F5BE= F0 CB       pK
INC &0828,X      :\ F5C0= FE 28 08    ~(.
TAY              :\ F5C3= A8          (
BPL LF5D0        :\ F5C4= 10 0A       ..
JSR LE9EF        :\ F5C6= 20 EF E9     oi
AND #&03         :\ F5C9= 29 03       ).
STA &0838        :\ F5CB= 8D 38 08    .8.
BRA LF58B        :\ F5CE= 80 BB       .;
 
.LF5D0
DEC &0838        :\ F5D0= CE 38 08    N8.
BRA LF58B        :\ F5D3= 80 B6       .6
 
.LF5D5
CMP &082C,X      :\ F5D5= DD 2C 08    ],.
BEQ LF604        :\ F5D8= F0 2A       p*
.LF5DA
STA &082C,X      :\ F5DA= 9D 2C 08    .,.
CPX #&04         :\ F5DD= E0 04       `.
BNE LF605        :\ F5DF= D0 24       P$
AND #&0F         :\ F5E1= 29 0F       ).
ORA LF40B,X      :\ F5E3= 1D 0B F4    ..t
.LF5E6
PHP              :\ F5E6= 08          .
.LF5E7
SEI              :\ F5E7= 78          x
LDY #&FF         :\ F5E8= A0 FF        .
STY SYSTEM_VIA+&3        :\ F5EA= 8C 43 FE    .C~
STA SYSTEM_VIA+&F        :\ F5ED= 8D 4F FE    .O~
INY              :\ F5F0= C8          H
STY SYSTEM_VIA+&0        :\ F5F1= 8C 40 FE    .@~
LDY #&02         :\ F5F4= A0 02        .
.LF5F6
DEY              :\ F5F6= 88          .
BNE LF5F6        :\ F5F7= D0 FD       P}
LDY #&08         :\ F5F9= A0 08        .
STY SYSTEM_VIA+&0        :\ F5FB= 8C 40 FE    .@~
LDY #&04         :\ F5FE= A0 04        .
.LF600
DEY              :\ F600= 88          .
BNE LF600        :\ F601= D0 FD       P}
PLP              :\ F603= 28          (
.LF604
RTS              :\ F604= 60          `
 
.LF605
PHA              :\ F605= 48          H
AND #&03         :\ F606= 29 03       ).
STA &083C        :\ F608= 8D 3C 08    .<.
STZ &083D        :\ F60B= 9C 3D 08    .=.
PLA              :\ F60E= 68          h
LSR A            :\ F60F= 4A          J
LSR A            :\ F610= 4A          J
.LF611
CMP #&0C         :\ F611= C9 0C       I.
BCC LF61C        :\ F613= 90 07       ..
INC &083D        :\ F615= EE 3D 08    n=.
SBC #&0C         :\ F618= E9 0C       i.
BNE LF611        :\ F61A= D0 F5       Pu
.LF61C
TAY              :\ F61C= A8          (
LDA &083D        :\ F61D= AD 3D 08    -=.
PHA              :\ F620= 48          H
LDA LF6E4,Y      :\ F621= B9 E4 F6    9dv
STA &083D        :\ F624= 8D 3D 08    .=.
LDA LF6F0,Y      :\ F627= B9 F0 F6    9pv
PHA              :\ F62A= 48          H
AND #&03         :\ F62B= 29 03       ).
STA &083E        :\ F62D= 8D 3E 08    .>.
PLA              :\ F630= 68          h
LSR A            :\ F631= 4A          J
LSR A            :\ F632= 4A          J
LSR A            :\ F633= 4A          J
LSR A            :\ F634= 4A          J
STA &083F        :\ F635= 8D 3F 08    .?.
LDA &083D        :\ F638= AD 3D 08    -=.
LDY &083C        :\ F63B= AC 3C 08    ,<.
BEQ LF64C        :\ F63E= F0 0C       p.
.LF640
SEC              :\ F640= 38          8
SBC &083F        :\ F641= ED 3F 08    m?.
BCS LF649        :\ F644= B0 03       0.
DEC &083E        :\ F646= CE 3E 08    N>.
.LF649
DEY              :\ F649= 88          .
BNE LF640        :\ F64A= D0 F4       Pt
.LF64C
STA &083D        :\ F64C= 8D 3D 08    .=.
PLA              :\ F64F= 68          h
TAY              :\ F650= A8          (
BEQ LF65C        :\ F651= F0 09       p.
.LF653
LSR &083E        :\ F653= 4E 3E 08    N>.
ROR &083D        :\ F656= 6E 3D 08    n=.
DEY              :\ F659= 88          .
BNE LF653        :\ F65A= D0 F7       Pw
.LF65C
LDA &083D        :\ F65C= AD 3D 08    -=.
CLC              :\ F65F= 18          .
ADC LE165,X      :\ F660= 7D 65 E1    }ea
STA &083D        :\ F663= 8D 3D 08    .=.
BCC LF66B        :\ F666= 90 03       ..
INC &083E        :\ F668= EE 3E 08    n>.
.LF66B
AND #&0F         :\ F66B= 29 0F       ).
ORA LF40B,X      :\ F66D= 1D 0B F4    ..t
PHP              :\ F670= 08          .
SEI              :\ F671= 78          x
JSR LF5E6        :\ F672= 20 E6 F5     fu
LDA &083D        :\ F675= AD 3D 08    -=.
LSR &083E        :\ F678= 4E 3E 08    N>.
ROR A            :\ F67B= 6A          j
LSR &083E        :\ F67C= 4E 3E 08    N>.
ROR A            :\ F67F= 6A          j
LSR A            :\ F680= 4A          J
LSR A            :\ F681= 4A          J
JMP LF5E7        :\ F682= 4C E7 F5    Lgu
 
.LF685
PHP              :\ F685= 08          .
SEI              :\ F686= 78          x
JSR LE9F4        :\ F687= 20 F4 E9     ti
PHA              :\ F68A= 48          H
AND #&04         :\ F68B= 29 04       ).
BEQ LF6A2        :\ F68D= F0 13       p.
PLA              :\ F68F= 68          h
LDY &0820,X      :\ F690= BC 20 08    < .
INY              :\ F693= C8          H
BNE LF699        :\ F694= D0 03       P.
JSR LF592        :\ F696= 20 92 F5     .u
.LF699
JSR LE9F4        :\ F699= 20 F4 E9     ti
JSR LE9F4        :\ F69C= 20 F4 E9     ti
PLP              :\ F69F= 28          (
BRA LF6E0        :\ F6A0= 80 3E       .>
 
.LF6A2
PLA              :\ F6A2= 68          h
AND #&F8         :\ F6A3= 29 F8       )x
ASL A            :\ F6A5= 0A          .
BCC LF6B3        :\ F6A6= 90 0B       ..
EOR #&FF         :\ F6A8= 49 FF       I.
LSR A            :\ F6AA= 4A          J
SEC              :\ F6AB= 38          8
SBC #&40         :\ F6AC= E9 40       i@
JSR LF599        :\ F6AE= 20 99 F5     .u
LDA #&FF         :\ F6B1= A9 FF       ).
.LF6B3
STA &0820,X      :\ F6B3= 9D 20 08    . .
LDA #&05         :\ F6B6= A9 05       ).
STA &081C,X      :\ F6B8= 9D 1C 08    ...
LDA #&01         :\ F6BB= A9 01       ).
STA &0824,X      :\ F6BD= 9D 24 08    .$.
STZ &0814,X      :\ F6C0= 9E 14 08    ...
STZ &0808,X      :\ F6C3= 9E 08 08    ...
STZ &0830,X      :\ F6C6= 9E 30 08    .0.
LDA #&FF         :\ F6C9= A9 FF       ).
STA &0810,X      :\ F6CB= 9D 10 08    ...
JSR LE9F4        :\ F6CE= 20 F4 E9     ti
STA &080C,X      :\ F6D1= 9D 0C 08    ...
JSR LE9F4        :\ F6D4= 20 F4 E9     ti
PLP              :\ F6D7= 28          (
PHA              :\ F6D8= 48          H
LDA &080C,X      :\ F6D9= BD 0C 08    =..
JSR LF5D5        :\ F6DC= 20 D5 F5     Uu
PLA              :\ F6DF= 68          h
.LF6E0
STA &0818,X      :\ F6E0= 9D 18 08    ...
RTS              :\ F6E3= 60          `
 
.LF6E4
\BEQ LF69D        :\ F6E4= F0 B7       p7
EQUB &F0
EQUB &B7
EQUB &82         :\ F6E6= 82          .
EQUB &4F         :\ F6E7= 4F          O
\JSR LC8F3        :\ F6E8= 20 F3 C8     sH
EQUB &20
EQUB &F3
EQUB &C8
LDY #&7B         :\ F6EB= A0 7B        {
EQUB &57         :\ F6ED= 57          W
AND &16,X        :\ F6EE= 35 16       5.
.LF6F0
EQUB &E7         :\ F6F0= E7          g
EQUB &D7         :\ F6F1= D7          W
EQUB &CB         :\ F6F2= CB          K
EQUB &C3         :\ F6F3= C3          C
EQUB &B7         :\ F6F4= B7          7
TAX              :\ F6F5= AA          *
LDX #&9A         :\ F6F6= A2 9A       ".
STA (&8A)        :\ F6F8= 92 8A       ..
EQUB &82         :\ F6FA= 82          .
PLY              :\ F6FB= 7A          z
.LF6FC
LDA #&FF         :\ F6FC= A9 FF       ).
STA &F5          :\ F6FE= 85 F5       .u
RTS              :\ F700= 60          `
 
.LF701
INC &F5          :\ F701= E6 F5       fu
LDY &F5          :\ F703= A4 F5       $u
LDX #&0D         :\ F705= A2 0D       ".
.LF707
PHP              :\ F707= 08          .
JSR LEE72        :\ F708= 20 72 EE     rn
PLP              :\ F70B= 28          (
CMP #&01         :\ F70C= C9 01       I.
TYA              :\ F70E= 98          .
RTS              :\ F70F= 60          `
 
.LF710
LDX #&0E         :\ F710= A2 0E       ".
LDY #&FF         :\ F712= A0 FF        .
JMP LF707        :\ F714= 4C 07 F7    L.w
 
.LF717
LDA &03CB        :\ F717= AD CB 03    -K.
STA &F6          :\ F71A= 85 F6       .v
LDA &03CC        :\ F71C= AD CC 03    -L.
STA &F7          :\ F71F= 85 F7       .w
LDA &F5          :\ F721= A5 F5       %u
RTS              :\ F723= 60          `
 
.LF724
LDX #&FF         :\ F724= A2 FF       ".
LDA &EC          :\ F726= A5 EC       %l
ORA &ED          :\ F728= 05 ED       .m
BNE LF732        :\ F72A= D0 06       P.
LDA #&81         :\ F72C= A9 81       ).
STA SYSTEM_VIA+&E        :\ F72E= 8D 4E FE    .N~
INX              :\ F731= E8          h
.LF732
STX &0242        :\ F732= 8E 42 02    .B.
.LF735
PHP              :\ F735= 08          .
LDA &025A        :\ F736= AD 5A 02    -Z.
LSR A            :\ F739= 4A          J
AND #&18         :\ F73A= 29 18       ).
ORA #&06         :\ F73C= 09 06       ..
STA SYSTEM_VIA+&0        :\ F73E= 8D 40 FE    .@~
LSR A            :\ F741= 4A          J
ORA #&07         :\ F742= 09 07       ..
STA SYSTEM_VIA+&0        :\ F744= 8D 40 FE    .@~
JSR LF91C        :\ F747= 20 1C F9     .y
PLA              :\ F74A= 68          h
RTS              :\ F74B= 60          `

\ KEYV handler
\ ============
BVC LF758        :\ F74C= 50 0A       P.
LDA #&01         :\ F74E= A9 01       ).
STA SYSTEM_VIA+&E        :\ F750= 8D 4E FE    .N~
BCS LF75D        :\ F753= B0 08       0.
JMP LF865        :\ F755= 4C 65 F8    Lex
 
.LF758
BCC LF760        :\ F758= 90 06       ..
JMP LF916        :\ F75A= 4C 16 F9    L.y
 
.LF75D
INC &0242        :\ F75D= EE 42 02    nB.

\ Test Shift & Ctrl keys
\ ----------------------
.LF760
LDA &025A        :\ F760= AD 5A 02    -Z.
AND #&B7         :\ F763= 29 B7       )7
LDX #&00         :\ F765= A2 00       ".
JSR LF880        :\ F767= 20 80 F8     .x
BCC LF76E        :\ F76A= 90 02       ..
STX &FA          :\ F76C= 86 FA       .z
.LF76E
CLV              :\ F76E= B8          8
BPL LF776        :\ F76F= 10 05       ..
BIT LE34E        :\ F771= 2C 4E E3    ,Nc
ORA #&08         :\ F774= 09 08       ..
.LF776
INX              :\ F776= E8          h
JSR LF880        :\ F777= 20 80 F8     .x
BCC LF735        :\ F77A= 90 B9       .9
BPL LF780        :\ F77C= 10 02       ..
ORA #&40         :\ F77E= 09 40       .@
.LF780
STA &025A        :\ F780= 8D 5A 02    .Z.
LDX &EC          :\ F783= A6 EC       &l
BEQ LF7D4        :\ F785= F0 4D       pM
JSR LF880        :\ F787= 20 80 F8     .x
BMI LF799        :\ F78A= 30 0D       0.
CPX &EC          :\ F78C= E4 EC       dl
.LF78E
STX &EC          :\ F78E= 86 EC       .l
BNE LF7D4        :\ F790= D0 42       PB
STZ &EC          :\ F792= 64 EC       dl
.LF794
JSR LF875        :\ F794= 20 75 F8     ux
BRA LF7D4        :\ F797= 80 3B       .;
 
.LF799
CPX &EC          :\ F799= E4 EC       dl
BNE LF78E        :\ F79B= D0 F1       Pq
LDA &E7          :\ F79D= A5 E7       %g
BEQ LF7D4        :\ F79F= F0 33       p3
DEC &E7          :\ F7A1= C6 E7       Fg
BNE LF7D4        :\ F7A3= D0 2F       P/
LDA &02CA        :\ F7A5= AD CA 02    -J.
STA &E7          :\ F7A8= 85 E7       .g
LDA &0255        :\ F7AA= AD 55 02    -U.
STA &02CA        :\ F7AD= 8D CA 02    .J.
LDA &025A        :\ F7B0= AD 5A 02    -Z.
LDX &EC          :\ F7B3= A6 EC       &l
CPX #&D0         :\ F7B5= E0 D0       `P
BEQ LF7CB        :\ F7B7= F0 12       p.
CPX #&C0         :\ F7B9= E0 C0       `@
BNE LF7D6        :\ F7BB= D0 19       P.
ORA #&A0         :\ F7BD= 09 A0       . 
BIT &FA          :\ F7BF= 24 FA       $z
BPL LF7C7        :\ F7C1= 10 04       ..
ORA #&10         :\ F7C3= 09 10       ..
EOR #&80         :\ F7C5= 49 80       I.
.LF7C7
EOR #&90         :\ F7C7= 49 90       I.
BRA LF7CF        :\ F7C9= 80 04       ..
 
.LF7CB
ORA #&90         :\ F7CB= 09 90       ..
EOR #&A0         :\ F7CD= 49 A0       I 
.LF7CF
STA &025A        :\ F7CF= 8D 5A 02    .Z.
STZ &E7          :\ F7D2= 64 E7       dg
.LF7D4
BRA LF845        :\ F7D4= 80 6F       .o
 
.LF7D6
LDA LF801+1,X      :\ F7D6= BD 02 F8    =.x ; ?????????
BEQ LF7E3        :\ F7D9= F0 08       p.
CMP #&9D         :\ F7DB= C9 9D       I.
BNE LF7E6        :\ F7DD= D0 07       P.
EOR #&10         :\ F7DF= 49 10       I.
BRA LF7EA        :\ F7E1= 80 07       ..
 
.LF7E3
LDA &026B        :\ F7E3= AD 6B 02    -k.
.LF7E6
CMP #&A0         :\ F7E6= C9 A0       I 
BCC LF7F6        :\ F7E8= 90 0C       ..
.LF7EA
SBC #&31         :\ F7EA= E9 31       i1
ADC &027E        :\ F7EC= 6D 7E 02    m~.
EOR #&80         :\ F7EF= 49 80       I.
LDX &028E        :\ F7F1= AE 8E 02    ...
BNE LF839        :\ F7F4= D0 43       PC
.LF7F6
LDX &025A        :\ F7F6= AE 5A 02    .Z.
STX &FA          :\ F7F9= 86 FA       .z
ROL &FA          :\ F7FB= 26 FA       &z
BPL LF806        :\ F7FD= 10 07       ..
LDX &ED          :\ F7FF= A6 ED       &m
.LF801
BNE LF794        :\ F801= D0 91       P.
JSR LF336        :\ F803= 20 36 F3     6s
.LF806
ROL &FA          :\ F806= 26 FA       &z
BMI LF811        :\ F808= 30 07       0.
JSR LF313        :\ F80A= 20 13 F3     .s
ROL &FA          :\ F80D= 26 FA       &z
BRA LF81D        :\ F80F= 80 0C       ..
 
.LF811
ROL &FA          :\ F811= 26 FA       &z
BMI LF822        :\ F813= 30 0D       0.
JSR LEA71        :\ F815= 20 71 EA     qj
BCS LF822        :\ F818= B0 08       0.
JSR LF313        :\ F81A= 20 13 F3     .s
.LF81D
LDX &025A        :\ F81D= AE 5A 02    .Z.
BPL LF82D        :\ F820= 10 0B       ..
.LF822
ROL &FA          :\ F822= 26 FA       &z
BPL LF82D        :\ F824= 10 07       ..
LDX &ED          :\ F826= A6 ED       &m
BNE LF801        :\ F828= D0 D7       PW
JSR LF313        :\ F82A= 20 13 F3     .s
.LF82D
CMP &026C        :\ F82D= CD 6C 02    Ml.
BNE LF839        :\ F830= D0 07       P.
LDX &0275        :\ F832= AE 75 02    .u.
BNE LF839        :\ F835= D0 02       P.
STZ &E7          :\ F837= 64 E7       dg
.LF839
TAY              :\ F839= A8          (
JSR LF9A6        :\ F83A= 20 A6 F9     &y
LDA &0259        :\ F83D= AD 59 02    -Y.
BNE LF845        :\ F840= D0 03       P.
JSR LEA7E        :\ F842= 20 7E EA     ~j
.LF845
LDX &ED          :\ F845= A6 ED       &m
BEQ LF852        :\ F847= F0 09       p.
JSR LF880        :\ F849= 20 80 F8     .x
STX &ED          :\ F84C= 86 ED       .m
BMI LF868        :\ F84E= 30 18       0.
STZ &ED          :\ F850= 64 ED       dm
.LF852
LDY #&EC         :\ F852= A0 EC        l
JSR LF96C        :\ F854= 20 6C F9     ly
BMI LF862        :\ F857= 30 09       0.
LDA &EC          :\ F859= A5 EC       %l
STA &ED          :\ F85B= 85 ED       .m
.LF85D
STX &EC          :\ F85D= 86 EC       .l
JSR LF875        :\ F85F= 20 75 F8     ux
.LF862
JMP LF724        :\ F862= 4C 24 F7    L$w
 
.LF865
JSR LF880        :\ F865= 20 80 F8     .x
.LF868
LDA &EC          :\ F868= A5 EC       %l
BNE LF862        :\ F86A= D0 F6       Pv
LDY #&ED         :\ F86C= A0 ED        m
JSR LF96C        :\ F86E= 20 6C F9     ly
BMI LF862        :\ F871= 30 EF       0o
BRA LF85D        :\ F873= 80 E8       .h
 
.LF875
LDX #&01         :\ F875= A2 01       ".
STX &E7          :\ F877= 86 E7       .g
LDX &0254        :\ F879= AE 54 02    .T.
STX &02CA        :\ F87C= 8E CA 02    .J.
RTS              :\ F87F= 60          `
 
.LF880
LDY #&03         :\ F880= A0 03        .
STY SYSTEM_VIA+&0        :\ F882= 8C 40 FE    .@~
LDY #&7F         :\ F885= A0 7F        .
STY SYSTEM_VIA+&3        :\ F887= 8C 43 FE    .C~
STX SYSTEM_VIA+&F        :\ F88A= 8E 4F FE    .O~
NOP              :\ F88D= EA          j
LDX SYSTEM_VIA+&F        :\ F88E= AE 4F FE    .O~
RTS              :\ F891= 60          `

\ Default keyboard table
\ ======================
.LF892
EQUS "q345":EQUB &84:EQUS "8":EQUB &87:EQUS "-^":EQUB &8C:EQUB &B6:EQUB &B7
\     q345        f4       8        f7       -^      Left       k6       k7
:
.LF89E
LDY &FC00,X:RTS
:
EQUB &80:EQUS "wet7i90_":EQUB &8E:EQUB &B8:EQUB &B9
\     f0       wet7i90_      Down       k8       k9
:
.LF8AE
LDY &FD00,X:RTS
:
EQUS "12dr6uop[":EQUB &8F:EQUB &AB:EQUB &AD:EQUB &9D
\     12dr6uop[        Up       k+       k-     kRet
:
.LF8BF
JMP (&0220)
:
EQUB 1:EQUS "axfyjk@:":EQUB &0D:EQUB &AF:EQUB &FF:EQUB &AE
\ caps       axfyjk@:       ret       k/     kDel       k.
:
.LF8CF
JMP (&FDFE)
:
EQUB 2:EQUS "scghnl;]":EQUB &7F:EQUB &A3:EQUB &AA:EQUB &AC
\ shlk       scghnl;]       del       k#       k*       k,
:
.LF8DF
JMP (&00FA)
:
EQUB 0:EQUS "z vbm,./":EQUB &8B:EQUB &B0:EQUB &B1:EQUB &B3
\  tab       z vbm,./      copy       k0       k1       k3
EQUB 0:EQUB 0:EQUB 0
EQUB 27:EQUB &81:EQUB &82:EQUB &83:EQUB &85:EQUB &86:EQUB &88:EQUB &89:EQUB &5C:EQUB &8D:EQUB &B4:EQUB &B5:EQUB &B2
\   esc       f1       f2       f3       f5       f6       f8       f9        \    right       k4       k5       k2
:
.LF8FF
BIT LE34E        :\ Set V
.LF902
JMP (&0228)      :\ Jump to KEYV
.LF905
LDY &0244        :\ F905= AC 44 02    ,D.
LDX #&00         :\ F908= A2 00       ".
.LF90A
RTS              :\ F90A= 60          `

.LF90B
STY &EC          :\ F90B= 84 EC       .l
STX &ED          :\ F90D= 86 ED       .m
RTS              :\ F90F= 60          `

.LF910
LDX #&10         :\ F910= A2 10       ".
CLV              :\ F912= B8          8
SEC              :\ F913= 38          8
BRA LF902        :\ F914= 80 EC       .l
 
.LF916
TXA              :\ F916= 8A          .
BPL LF923        :\ F917= 10 0A       ..
JSR LF880        :\ F919= 20 80 F8     .x
.LF91C
LDA #&0B         :\ F91C= A9 0B       ).
STA SYSTEM_VIA+&0        :\ F91E= 8D 40 FE    .@~
TXA              :\ F921= 8A          .
RTS              :\ F922= 60          `
 
.LF923
STX &02CB        :\ F923= 8E CB 02    .K.
LDA #&FF         :\ F926= A9 FF       ).
STA &02CC        :\ F928= 8D CC 02    .L.
LDX #&0C         :\ F92B= A2 0C       ".
LDA #&7F         :\ F92D= A9 7F       ).
STA SYSTEM_VIA+&3        :\ F92F= 8D 43 FE    .C~
LDA #&03         :\ F932= A9 03       ).
STA SYSTEM_VIA+&0        :\ F934= 8D 40 FE    .@~
.LF937
LDA #&0F         :\ F937= A9 0F       ).
STA SYSTEM_VIA+&F        :\ F939= 8D 4F FE    .O~
LDA #&01         :\ F93C= A9 01       ).
STA SYSTEM_VIA+&D        :\ F93E= 8D 4D FE    .M~
STX SYSTEM_VIA+&F        :\ F941= 8E 4F FE    .O~
BIT SYSTEM_VIA+&D        :\ F944= 2C 4D FE    ,M~
BEQ LF964        :\ F947= F0 1B       p.
TXA              :\ F949= 8A          .
.LF94A
CLC              :\ F94A= 18          .
ADC #&10         :\ F94B= 69 10       i.
BMI LF964        :\ F94D= 30 15       0.
STA SYSTEM_VIA+&F        :\ F94F= 8D 4F FE    .O~
BIT SYSTEM_VIA+&F        :\ F952= 2C 4F FE    ,O~
BPL LF94A        :\ F955= 10 F3       .s
CMP &02CB        :\ F957= CD CB 02    MK.
BCC LF94A        :\ F95A= 90 EE       .n
CMP &02CC        :\ F95C= CD CC 02    ML.
BCS LF94A        :\ F95F= B0 E9       0i
STA &02CC        :\ F961= 8D CC 02    .L.
.LF964
DEX              :\ F964= CA          J
BPL LF937        :\ F965= 10 D0       .P
LDX &02CC        :\ F967= AE CC 02    .L.
BRA LF91C        :\ F96A= 80 B0       .0
 
.LF96C
LDX #&0C         :\ F96C= A2 0C       ".
.LF96E
JSR LF9A6        :\ F96E= 20 A6 F9     &y
LDA #&7F         :\ F971= A9 7F       ).
STA SYSTEM_VIA+&3        :\ F973= 8D 43 FE    .C~
LDA #&03         :\ F976= A9 03       ).
STA SYSTEM_VIA+&0        :\ F978= 8D 40 FE    .@~
LDA #&0F         :\ F97B= A9 0F       ).
STA SYSTEM_VIA+&F        :\ F97D= 8D 4F FE    .O~
LDA #&01         :\ F980= A9 01       ).
STA SYSTEM_VIA+&D        :\ F982= 8D 4D FE    .M~
STX SYSTEM_VIA+&F        :\ F985= 8E 4F FE    .O~
BIT SYSTEM_VIA+&D        :\ F988= 2C 4D FE    ,M~
BEQ LF9AD        :\ F98B= F0 20       p 
TXA              :\ F98D= 8A          .
.LF98E
CLC              :\ F98E= 18          .
ADC #&10         :\ F98F= 69 10       i.
BMI LF9AD        :\ F991= 30 1A       0.
STA SYSTEM_VIA+&F        :\ F993= 8D 4F FE    .O~
BIT SYSTEM_VIA+&F        :\ F996= 2C 4F FE    ,O~
BPL LF98E        :\ F999= 10 F3       .s
PHA              :\ F99B= 48          H
.LF99C
EOR &0000,Y      :\ F99C= 59 00 00    Y..
ASL A            :\ F99F= 0A          .
CMP #&01         :\ F9A0= C9 01       I.
PLA              :\ F9A2= 68          h
BCC LF98E        :\ F9A3= 90 E9       .i
TAX              :\ F9A5= AA          *
.LF9A6
JSR LF91C        :\ F9A6= 20 1C F9     .y
CLI              :\ F9A9= 58          X
SEI              :\ F9AA= 78          x
TXA              :\ F9AB= 8A          .
RTS              :\ F9AC= 60          `
 
.LF9AD
DEX              :\ F9AD= CA          J
BPL LF96E        :\ F9AE= 10 BE       .>
BRA LF9A6        :\ F9B0= 80 F4       .t
 
.LF9B2
JSR LFA97        :\ F9B2= 20 97 FA     .z
JMP (&0218)      :\ F9B5= 6C 18 02    l..
 
.LF9B8
JSR LFA97        :\ F9B8= 20 97 FA     .z
JMP (&0216)      :\ F9BB= 6C 16 02    l..
 
.LF9BE
CMP #&05         :\ F9BE= C9 05       I.
BCS LF9D7        :\ F9C0= B0 15       0.
CMP #&00         :\ F9C2= C9 00       I.
BEQ LF9D7        :\ F9C4= F0 11       p.
PHY              :\ F9C6= 5A          Z
PHA              :\ F9C7= 48          H
STX &B0          :\ F9C8= 86 B0       .0
STY &B1          :\ F9CA= 84 B1       .1
LDA (&B0)        :\ F9CC= B2 B0       20
TAY              :\ F9CE= A8          (
PLA              :\ F9CF= 68          h
JSR LFA97        :\ F9D0= 20 97 FA     .z
.LF9D3
PLY              :\ F9D3= 7A          z
JMP (&021A)      :\ F9D4= 6C 1A 02    l..
 
.LF9D7
PHY              :\ F9D7= 5A          Z
PHX              :\ F9D8= DA          Z
PHA              :\ F9D9= 48          H
JSR LEDBA        :\ F9DA= 20 BA ED     :m
LDA HAZEL_WORKSPACE+&00        :\ F9DD= AD 00 DF    -._
JSR LFB4D        :\ F9E0= 20 4D FB     M{
PLA              :\ F9E3= 68          h
PLX              :\ F9E4= FA          z
BRA LF9D3        :\ F9E5= 80 EC       .l

\ FILESWITCH OSARGS HANDLER
\ ========================= 
.LF9E7
CPY #&00         :\ F9E7= C0 00       @.
BNE LFA15        :\ F9E9= D0 2A       P*
CMP #&04         :\ F9EB= C9 04       I.
BCS LFA15        :\ F9ED= B0 26       0&
PHA              :\ F9EF= 48          H
JSR LEDBA        :\ Page in Hazel
PLA              :\ F9F3= 68          h
BNE LF9FA        :\ Jump with A<>0
LDA HAZEL_WORKSPACE+&00        :\ OSARGS 0,0 - Read filing system number
RTS
 
.LF9FA
DEC A            :\ F9FA= 3A          :
BNE LFA0D        :\ F9FB= D0 10       P.
DEC A            :\ OSARGS 1,0 - Read command line address
STA &02,X        :\ F9FE= 95 02       ..
STA &03,X        :\ FA00= 95 03       ..
LDA HAZEL_WORKSPACE+&04        :\ FA02= AD 04 DF    -._
STA &00,X        :\ FA05= 95 00       ..
LDA HAZEL_WORKSPACE+&05        :\ FA07= AD 05 DF    -._
STA &01,X        :\ FA0A= 95 01       ..
RTS              :\ FA0C= 60          `
 
.LFA0D
CMP #&01         :\ FA0D= C9 01       I.
BEQ LFA14        :\ OSARGS 2,0 - Read OldNFS flag
LDA HAZEL_WORKSPACE+&02        :\ OSARGS 3,0 - Read libfs filing system number
.LFA14
RTS              :\ FA14= 60          `
 
.LFA15
JSR LFA97        :\ FA15= 20 97 FA     .z
.LFA18
JMP (&0214)      :\ FA18= 6C 14 02    l..
 
.LFA1B
ORA #&00         :\ FA1B= 09 00       ..
BEQ LFA24        :\ FA1D= F0 05       p.
JSR LFA6E        :\ FA1F= 20 6E FA     nz
BRA LFA27        :\ FA22= 80 03       ..
 
.LFA24
JSR LFA97        :\ FA24= 20 97 FA     .z
.LFA27
JMP (&021C)      :\ FA27= 6C 1C 02    l..
 
.LFA2A
PHX              :\ FA2A= DA          Z
PHY              :\ FA2B= 5A          Z
PHA              :\ FA2C= 48          H
STX &F2          :\ FA2D= 86 F2       .r
STY &F3          :\ FA2F= 84 F3       .s
LDY #&11         :\ FA31= A0 11        .
.LFA33
LDA (&F2),Y      :\ FA33= B1 F2       1r
STA &02ED,Y      :\ FA35= 99 ED 02    .m.
DEY              :\ FA38= 88          .
BPL LFA33        :\ FA39= 10 F8       .x
LDX &02ED        :\ FA3B= AE ED 02    .m.
LDY &02EE        :\ FA3E= AC EE 02    ,n.
JSR LFA6E        :\ FA41= 20 6E FA     nz
STX &02ED        :\ FA44= 8E ED 02    .m.
STY &02EE        :\ FA47= 8C EE 02    .n.
PLA              :\ FA4A= 68          h
LDX #&ED         :\ FA4B= A2 ED       "m
LDY #&02         :\ FA4D= A0 02        .
JSR LFA6B        :\ FA4F= 20 6B FA     kz
PLY              :\ FA52= 7A          z
STY &F3          :\ FA53= 84 F3       .s
PLX              :\ FA55= FA          z
STX &F2          :\ FA56= 86 F2       .r
PHA              :\ FA58= 48          H
LDY #&11         :\ FA59= A0 11        .
.LFA5B
LDA &02ED,Y      :\ FA5B= B9 ED 02    9m.
STA (&F2),Y      :\ FA5E= 91 F2       .r
DEY              :\ FA60= 88          .
CPY #&02         :\ FA61= C0 02       @.
BCS LFA5B        :\ FA63= B0 F6       0v
PLA              :\ FA65= 68          h
LDX &F2          :\ FA66= A6 F2       &r
LDY &F3          :\ FA68= A4 F3       $s
RTS              :\ FA6A= 60          `
 
.LFA6B
JMP (&0212)      :\ FA6B= 6C 12 02    l..
 
.LFA6E
PHA              :\ FA6E= 48          H
LDA &F2          :\ FA6F= A5 F2       %r
PHA              :\ FA71= 48          H
LDA &F3          :\ FA72= A5 F3       %s
PHA              :\ FA74= 48          H
JSR LEDBA        :\ FA75= 20 BA ED     :m
STX &F2          :\ FA78= 86 F2       .r
STY &F3          :\ FA7A= 84 F3       .s
LDY #&00         :\ FA7C= A0 00        .
JSR LFAA6        :\ FA7E= 20 A6 FA     &z
PHY              :\ FA81= 5A          Z
JSR LFB4D        :\ FA82= 20 4D FB     M{
PLA              :\ FA85= 68          h
CLC              :\ FA86= 18          .
ADC &F2          :\ FA87= 65 F2       er
TAX              :\ FA89= AA          *
LDY &F3          :\ FA8A= A4 F3       $s
BCC LFA8F        :\ FA8C= 90 01       ..
INY              :\ FA8E= C8          H
.LFA8F
PLA              :\ FA8F= 68          h
STA &F3          :\ FA90= 85 F3       .s
PLA              :\ FA92= 68          h
STA &F2          :\ FA93= 85 F2       .r
PLA              :\ FA95= 68          h
RTS              :\ FA96= 60          `
 
.LFA97
PHX              :\ FA97= DA          Z
PHA              :\ FA98= 48          H
JSR LEDBA        :\ FA99= 20 BA ED     :m
JSR LFB23        :\ FA9C= 20 23 FB     #{
TXA              :\ FA9F= 8A          .
JSR LFB4D        :\ FAA0= 20 4D FB     M{
PLA              :\ FAA3= 68          h
PLX              :\ FAA4= FA          z
RTS              :\ FAA5= 60          `
 
.LFAA6
LSR HAZEL_WORKSPACE+&C6        :\ FAA6= 4E C6 DF    NF_
JSR LF2FF        :\ FAA9= 20 FF F2     .r
LDA (&F2),Y      :\ FAAC= B1 F2       1r
CMP #&2D         :\ FAAE= C9 2D       I-
BEQ LFABE        :\ FAB0= F0 0C       p.
BIT HAZEL_WORKSPACE+&C6        :\ FAB2= 2C C6 DF    ,F_
LDA HAZEL_WORKSPACE+&00        :\ FAB5= AD 00 DF    -._
BVC LFABD        :\ FAB8= 50 03       P.
LDA HAZEL_WORKSPACE+&01        :\ FABA= AD 01 DF    -._
.LFABD
RTS              :\ FABD= 60          `
 
.LFABE
INY              :\ FABE= C8          H
LDX #&00         :\ FABF= A2 00       ".
.LFAC1
LDA HAZEL_WORKSPACE+&06,X      :\ FAC1= BD 06 DF    =._
BEQ LFB0A        :\ FAC4= F0 44       pD
TXA              :\ FAC6= 8A          .
CLC              :\ FAC7= 18          .
ADC #&08         :\ FAC8= 69 08       i.
STA &B0          :\ FACA= 85 B0       .0
PHY              :\ FACC= 5A          Z
.LFACD
LDA (&F2),Y      :\ FACD= B1 F2       1r
JSR LEA71        :\ FACF= 20 71 EA     qj
BCC LFADC        :\ FAD2= 90 08       ..
CMP #&30         :\ FAD4= C9 30       I0
BCC LFAF3        :\ FAD6= 90 1B       ..
CMP #&3A         :\ FAD8= C9 3A       I:
BCS LFAF3        :\ FADA= B0 17       0.
.LFADC
CPX &B0          :\ FADC= E4 B0       d0
BCS LFAEB        :\ FADE= B0 0B       0.
EOR HAZEL_WORKSPACE+&06,X      :\ FAE0= 5D 06 DF    ]._
AND #&DF         :\ FAE3= 29 DF       )_
BNE LFAEB        :\ FAE5= D0 04       P.
INX              :\ FAE7= E8          h
INY              :\ FAE8= C8          H
BRA LFACD        :\ FAE9= 80 E2       .b
 
.LFAEB
PLY              :\ FAEB= 7A          z
LDX &B0          :\ FAEC= A6 B0       &0
INX              :\ FAEE= E8          h
INX              :\ FAEF= E8          h
INX              :\ FAF0= E8          h
BRA LFAC1        :\ FAF1= 80 CE       .N
 
.LFAF3
CMP #&2D         :\ FAF3= C9 2D       I-
BNE LFB0A        :\ FAF5= D0 13       P.
INY              :\ FAF7= C8          H
CPX &B0          :\ FAF8= E4 B0       d0
BEQ LFB03        :\ FAFA= F0 07       p.
LDA HAZEL_WORKSPACE+&06,X      :\ FAFC= BD 06 DF    =._
CMP #&20         :\ FAFF= C9 20       I 
BNE LFAEB        :\ FB01= D0 E8       Ph
.LFB03
PLA              :\ FB03= 68          h
LDX &B0          :\ FB04= A6 B0       &0
LDA HAZEL_WORKSPACE+&08,X      :\ FB06= BD 08 DF    =._
RTS              :\ FB09= 60          `
 
.LFB0A
BRK              :\ FB0A= 00          .
SED              :\ FB0B= F8          x
EQUB &42         :\ FB0C= 42          B
ADC (&64,X)      :\ FB0D= 61 64       ad
JSR &6966        :\ FB0F= 20 66 69     fi
JMP (&6E69)      :\ FB12= 6C 69 6E    lin
 
EQUB &67         :\ FB15= 67          g
JSR &7973        :\ FB16= 20 73 79     sy
EQUB &73         :\ FB19= 73          s
STZ &65,X        :\ FB1A= 74 65       te
ADC &6E20        :\ FB1C= 6D 20 6E    m n
ADC (&6D,X)      :\ FB1F= 61 6D       am
ADC &00          :\ FB21= 65 00       e.
.LFB23
PHA              :\ FB23= 48          H
PHY              :\ FB24= 5A          Z
TYA              :\ FB25= 98          .
LDY #&00         :\ FB26= A0 00        .
.LFB28
LDX HAZEL_WORKSPACE+&06,Y      :\ FB28= BE 06 DF    >._
BEQ LFB42        :\ FB2B= F0 15       p.
CMP HAZEL_WORKSPACE+&0E,Y      :\ FB2D= D9 0E DF    Y._
BCC LFB39        :\ FB30= 90 07       ..
CMP HAZEL_WORKSPACE+&0F,Y      :\ FB32= D9 0F DF    Y._
BCC LFB47        :\ FB35= 90 10       ..
BEQ LFB47        :\ FB37= F0 0E       p.
.LFB39
PHA              :\ FB39= 48          H
TYA              :\ FB3A= 98          .
CLC              :\ FB3B= 18          .
ADC #&0B         :\ FB3C= 69 0B       i.
TAY              :\ FB3E= A8          (
PLA              :\ FB3F= 68          h
BRA LFB28        :\ FB40= 80 E6       .f
 
.LFB42
LDX HAZEL_WORKSPACE+&00        :\ FB42= AE 00 DF    .._
BRA LFB4A        :\ FB45= 80 03       ..
 
.LFB47
LDX HAZEL_WORKSPACE+&10,Y      :\ FB47= BE 10 DF    >._
.LFB4A
PLY              :\ FB4A= 7A          z
PLA              :\ FB4B= 68          h
RTS              :\ FB4C= 60          `
 
\ Select filing system in A
\ =========================
.LFB4D
CMP HAZEL_WORKSPACE+&01        :\ Check active fs
BEQ LFB68        :\ Already active fs, return
PHY              :\ FB52= 5A          Z
PHX              :\ FB53= DA          Z
TAY              :\ FB54= A8          (
DEC A            :\ FB55= 3A          :
BNE LFB5F        :\ FB56= D0 07       P.
LDA #&04         :\ FB58= A9 04       ).
BIT &E2          :\ FB5A= 24 E2       $b
BNE LFB5F        :\ FB5C= D0 01       P.
INY              :\ FB5E= C8          H
.LFB5F
PHY              :\ FB5F= 5A          Z
LDX #&12:JSR LEE72        :\ Service call &12 - Select filing system
PLA              :\ FB65= 68          h
PLX              :\ FB66= FA          z
PLY              :\ FB67= 7A          z
.LFB68
RTS              :\ FB68= 60          `
 
\ FileSwitch FSC
\ ==============
PHA              :\ FB69= 48          H
JSR LEDBA        :\ FB6A= 20 BA ED     :m
LSR HAZEL_WORKSPACE+&C6        :\ FB6D= 4E C6 DF    NF_
PLA              :\ FB70= 68          h
PHA              :\ FB71= 48          H
PHX              :\ FB72= DA          Z
ASL A            :\ FB73= 0A          .
TAX              :\ FB74= AA          *
CMP #&17         :\ FB75= C9 17       I.
BCS LFB7C        :\ FB77= B0 03       0.
JMP (LFB81,X)    :\ FB79= 7C 81 FB    |.{
 
\ Pass to filing system's FSC
\ ---------------------------
.LFB7C
PLX              :\ FB7C= FA          z
.LFB7D
PLA              :\ FB7D= 68          h
JMP (HAZEL_WORKSPACE+&DA)      :\ FB7E= 6C DA DF    lZ_
 
\ FileSwitch FSC table
\ --------------------
.LFB81
LDX &FB          :\ FB81= A6 FB       &{  &00 &FBA6 - *OPT
EQUB &9F         :\ FB83= 9F          .   &01 &FB9F - =EOF
EQUB &FB         :\ FB84= FB          {
EQUB &B3         :\ FB85= B3          3   &02 &FBB3 - */filename
EQUB &FB         :\ FB86= FB          {
STA LB3FB,Y      :\ FB87= 99 FB B3    .{3 &03 &FB99 - *command
EQUB &FB         :\ FB8A= FB          {   &04 &FBB3 - *RUN
CLV              :\ FB8B= B8          8   &05 &FBB8 - *CAT
EQUB &FB         :\ FB8C= FB          {
JMP (&7CFB,X)    :\ FB8D= 7C FB 7C    |{| &06 &FB7C - New fs taking over - pass to fs FSC
EQUB &FB         :\ FB90= FB          {   &07 &FB7C - Handle request     - pass to fs FSC
JMP (LB8FB,X)    :\ FB91= 7C FB B8    |{8 &08 &FC7C - Enable flag        - pass to fs FSC
EQUB &FB         :\ FB94= FB          {   &09 &FBB8 - *EX
CLV              :\ FB95= B8          8   &0A &FBB8 - *INFO
EQUB &FB         :\ FB96= FB          {
INX              :\ FB97= E8          h   &0B &FBE8 - *RUN from libfs
EQUB &FB         :\ FB98= FB          {

\ FSC 3 - *command
\ ================
PLX              :\ FB99= FA          z
JSR LFBC1        :\ FB9A= 20 C1 FB     A{
BRA LFB7D        :\ FB9D= 80 DE       .^

\ FSC 1 - =EOF
\ ============
.LFB9F
PLY              :\ FB9F= 7A          z
PHY              :\ FBA0= 5A          Z
JSR LFA97        :\ FBA1= 20 97 FA     .z
BRA LFB7C        :\ FBA4= 80 D6       .V

\ FSC 0 - *OPT
\ ============
.LFBA6
BIT HAZEL_WORKSPACE+&C6        :\ Check temporary fs flag
BVS LFB7C        :\ Pass to current filing system
LDA HAZEL_WORKSPACE+&00        :\ Get current filing system number
.LFBAE
JSR LFB4D        :\ Select filing system
BRA LFB7C        :\ Pass to filing system
 
\ FSC 2, 4 - *filename, *RUN filename
\ ===================================
PLX
JSR LFBC1        :\ Skip '*'s and spaces, set command line address
PHX              :\ Continue on to pass to filing system

\ FSC 5, 9, 10 - *CAT, *EX, *INFO
\ ===============================
PLX
ASL HAZEL_WORKSPACE+&C6        :\
JSR LFA6E        :\ ? Check for temporary fs ?
BRA LFB7D        :\ Pass to filing system's FSC
 
.LFBC1
STX &F2          :\ FBC1= 86 F2       .r
STY &F3          :\ FBC3= 84 F3       .s
LDY #&FF         :\ FBC5= A0 FF        .
.LFBC7
INY              :\ FBC7= C8          H
LDA (&F2),Y      :\ FBC8= B1 F2       1r
CMP #&0D         :\ FBCA= C9 0D       I.
BEQ LFBD2        :\ FBCC= F0 04       p.
.LFBCE
CMP #&20         :\ FBCE= C9 20       I 
BNE LFBC7        :\ FBD0= D0 F5       Pu
.LFBD2
JSR LF2FF        :\ FBD2= 20 FF F2     .r
TYA              :\ FBD5= 98          .
CLC              :\ FBD6= 18          .
ADC &F2          :\ FBD7= 65 F2       er
STA HAZEL_WORKSPACE+&04        :\ FBD9= 8D 04 DF    .._
LDA &F3          :\ FBDC= A5 F3       %s
ADC #&00         :\ FBDE= 69 00       i.
STA HAZEL_WORKSPACE+&05        :\ FBE0= 8D 05 DF    .._
LDY &F3          :\ FBE3= A4 F3       $s
LDX &F2          :\ FBE5= A6 F2       &r
RTS              :\ FBE7= 60          `
 
\ FSC 11 - RUN from libfs
\ =======================
LDA HAZEL_WORKSPACE+&02        :\ Is a libfs set?
BPL LFBAE        :\ Yes, jump to run from libfs
.LFBED
BRK:EQUB 254
EQUS "Bad command":BRK

EQUB &FF         :\ FBFB= FF          .
EQUB &FF         :\ FBFC= FF          .
EQUB &FF         :\ FBFD= FF          .
EQUB &FF         :\ FBFE= FF          .
EQUB &FF         :\ FBFF= FF          .
.LFC00
PLP              :\ FC00= 28          (
EQUB &43         :\ FC01= 43          C
AND #&20         :\ FC02= 29 20       ) 
AND (&39),Y      :\ FC04= 31 39       19
SEC              :\ FC06= 38          8
BIT &20,X        :\ FC07= 34 20       4 
EOR (&63,X)      :\ FC09= 41 63       Ac
EQUB &6F         :\ FC0B= 6F          o
ADC (&6E)        :\ FC0C= 72 6E       rn
JSR &6F43        :\ FC0E= 20 43 6F     Co
ADC &7570        :\ FC11= 6D 70 75    mpu
STZ &65,X        :\ FC14= 74 65       te
ADC (&73)        :\ FC16= 72 73       rs
JSR &744C        :\ FC18= 20 4C 74     Lt
STZ &2E          :\ FC1B= 64 2E       d.
EQUB &54         :\ FC1D= 54          T
PLA              :\ FC1E= 68          h
ADC (&6E,X)      :\ FC1F= 61 6E       an
EQUB &6B         :\ FC21= 6B          k
EQUB &73         :\ FC22= 73          s
JSR &7261        :\ FC23= 20 61 72     ar
ADC &20          :\ FC26= 65 20       e 
STZ &75          :\ FC28= 64 75       du
ADC &20          :\ FC2A= 65 20       e 
STZ &6F,X        :\ FC2C= 74 6F       to
JSR &6874        :\ FC2E= 20 74 68     th
ADC &20          :\ FC31= 65 20       e 
ROR &6F          :\ FC33= 66 6F       fo
JMP (&6F6C)      :\ FC35= 6C 6C 6F    llo
 
EQUB &77         :\ FC38= 77          w
ADC #&6E         :\ FC39= 69 6E       in
EQUB &67         :\ FC3B= 67          g
JSR &6F63        :\ FC3C= 20 63 6F     co
ROR &7274        :\ FC3F= 6E 74 72    ntr
ADC #&62         :\ FC42= 69 62       ib
ADC &74,X        :\ FC44= 75 74       ut
EQUB &6F         :\ FC46= 6F          o
ADC (&73)        :\ FC47= 72 73       rs
JSR &6F74        :\ FC49= 20 74 6F     to
JSR &6874        :\ FC4C= 20 74 68     th
ADC &20          :\ FC4F= 65 20       e 
EQUB &42         :\ FC51= 42          B
EQUB &42         :\ FC52= 42          B
EQUB &43         :\ FC53= 43          C
JSR &6F43        :\ FC54= 20 43 6F     Co
ADC &7570        :\ FC57= 6D 70 75    mpu
STZ &65,X        :\ FC5A= 74 65       te
ADC (&20)        :\ FC5C= 72 20       r 
PLP              :\ FC5E= 28          (
ADC (&6D,X)      :\ FC5F= 61 6D       am
EQUB &6F         :\ FC61= 6F          o
ROR &2067        :\ FC62= 6E 67 20    ng 
EQUB &6F         :\ FC65= 6F          o
STZ &68,X        :\ FC66= 74 68       th
ADC &72          :\ FC68= 65 72       er
EQUB &73         :\ FC6A= 73          s
JSR &6F74        :\ FC6B= 20 74 6F     to
EQUB &6F         :\ FC6E= 6F          o
JSR &756E        :\ FC6F= 20 6E 75     nu
ADC &7265        :\ FC72= 6D 65 72    mer
EQUB &6F         :\ FC75= 6F          o
ADC &73,X        :\ FC76= 75 73       us
JSR &6F74        :\ FC78= 20 74 6F     to
JSR &656D        :\ FC7B= 20 6D 65     me
ROR &6974        :\ FC7E= 6E 74 69    nti
EQUB &6F         :\ FC81= 6F          o
ROR &3A29        :\ FC82= 6E 29 3A    n):
AND &4420        :\ FC85= 2D 20 44    - D
ADC (&76,X)      :\ FC88= 61 76       av
ADC #&64         :\ FC8A= 69 64       id
JSR &6C41        :\ FC8C= 20 41 6C     Al
JMP (&6E65)      :\ FC8F= 6C 65 6E    len
 
BIT &6C43        :\ FC92= 2C 43 6C    ,Cl
ADC #&76         :\ FC95= 69 76       iv
ADC &20          :\ FC97= 65 20       e 
EOR (&6E,X)      :\ FC99= 41 6E       An
EQUB &67         :\ FC9B= 67          g
ADC &6C          :\ FC9C= 65 6C       el
BIT &6144        :\ FC9E= 2C 44 61    ,Da
ROR &69,X        :\ FCA1= 76 69       vi
STZ &20          :\ FCA3= 64 20       d 
EQUB &42         :\ FCA5= 42          B
ADC &6C          :\ FCA6= 65 6C       el
JMP (&502C)      :\ FCA8= 6C 2C 50    l,P
 
ADC (&75,X)      :\ FCAB= 61 75       au
JMP (&4220)      :\ FCAD= 6C 20 42    l B
 
EQUB &6F         :\ FCB0= 6F          o
ROR &2C64        :\ FCB1= 6E 64 2C    nd,
EOR (&6C,X)      :\ FCB4= 41 6C       Al
JMP (&6E65)      :\ FCB6= 6C 65 6E    len
 
JSR &6F42        :\ FCB9= 20 42 6F     Bo
EQUB &6F         :\ FCBC= 6F          o
STZ &68,X        :\ FCBD= 74 68       th
ADC (&6F)        :\ FCBF= 72 6F       ro
ADC &2C64,Y      :\ FCC1= 79 64 2C    yd,
LSR A            :\ FCC4= 4A          J
ADC &6C,X        :\ FCC5= 75 6C       ul
ADC #&61         :\ FCC7= 69 61       ia
ROR &4220        :\ FCC9= 6E 20 42    n B
ADC (&6F)        :\ FCCC= 72 6F       ro
EQUB &77         :\ FCCE= 77          w
ROR &542C        :\ FCCF= 6E 2C 54    n,T
ADC &64,X        :\ FCD2= 75 64       ud
EQUB &6F         :\ FCD4= 6F          o
ADC (&20)        :\ FCD5= 72 20       r 
EQUB &42         :\ FCD7= 42          B
ADC (&6F)        :\ FCD8= 72 6F       ro
EQUB &77         :\ FCDA= 77          w
ROR &422C        :\ FCDB= 6E 2C 42    n,B
ADC (&69)        :\ FCDE= 72 69       ri
ADC (&6E,X)      :\ FCE0= 61 6E       an
JSR &6F43        :\ FCE2= 20 43 6F     Co
EQUB &63         :\ FCE5= 63          c
EQUB &6B         :\ FCE6= 6B          k
EQUB &62         :\ FCE7= 62          b
ADC &72,X        :\ FCE8= 75 72       ur
ROR &502C        :\ FCEA= 6E 2C 50    n,P
ADC &74          :\ FCED= 65 74       et
ADC &20          :\ FCEF= 65 20       e 
EQUB &43         :\ FCF1= 43          C
EQUB &6F         :\ FCF2= 6F          o
EQUB &63         :\ FCF3= 63          c
EQUB &6B         :\ FCF4= 6B          k
ADC &72          :\ FCF5= 65 72       er
ADC &6C          :\ FCF7= 65 6C       el
JMP (&4D2C)      :\ FCF9= 6C 2C 4D    l,M
 
ADC (&72,X)      :\ FCFC= 61 72       ar
EQUB &6B         :\ FCFE= 6B          k
JSR &6F43        :\ FCFF= 20 43 6F     Co
JMP (&6F74)      :\ FD02= 6C 74 6F    lto
 
ROR &432C        :\ FD05= 6E 2C 43    n,C
PLA              :\ FD08= 68          h
ADC (&69)        :\ FD09= 72 69       ri
EQUB &73         :\ FD0B= 73          s
JSR &7543        :\ FD0C= 20 43 75     Cu
ADC (&72)        :\ FD0F= 72 72       rr
ADC &4A2C,Y      :\ FD11= 79 2C 4A    y,J
EQUB &6F         :\ FD14= 6F          o
ADC &20          :\ FD15= 65 20       e 
EQUB &44         :\ FD17= 44          D
ADC &6E,X        :\ FD18= 75 6E       un
ROR &502C        :\ FD1A= 6E 2C 50    n,P
ADC (&75,X)      :\ FD1D= 61 75       au
JMP (&4620)      :\ FD1F= 6C 20 46    l F
 
ADC (&65)        :\ FD22= 72 65       re
ADC (&6B,X)      :\ FD24= 61 6B       ak
JMP (&7965)      :\ FD26= 6C 65 79    ley
 
BIT &7453        :\ FD29= 2C 53 74    ,St
ADC &76          :\ FD2C= 65 76       ev
ADC &20          :\ FD2E= 65 20       e 
LSR &75          :\ FD30= 46 75       Fu
ADC (&62)        :\ FD32= 72 62       rb
ADC &72          :\ FD34= 65 72       er
BIT &614D        :\ FD36= 2C 4D 61    ,Ma
ADC (&74)        :\ FD39= 72 74       rt
ADC &206E,Y      :\ FD3B= 79 6E 20    yn 
EQUB &47         :\ FD3E= 47          G
ADC #&6C         :\ FD3F= 69 6C       il
EQUB &62         :\ FD41= 62          b
ADC &72          :\ FD42= 65 72       er
STZ &2C,X        :\ FD44= 74 2C       t,
LSR A            :\ FD46= 4A          J
EQUB &6F         :\ FD47= 6F          o
PLA              :\ FD48= 68          h
ROR &4820        :\ FD49= 6E 20 48    n H
ADC (&72,X)      :\ FD4C= 61 72       ar
ADC (&69)        :\ FD4E= 72 69       ri
EQUB &73         :\ FD50= 73          s
EQUB &6F         :\ FD51= 6F          o
ROR &482C        :\ FD52= 6E 2C 48    n,H
ADC &72          :\ FD55= 65 72       er
ADC &6E61        :\ FD57= 6D 61 6E    man
ROR &4820        :\ FD5A= 6E 20 48    n H
ADC (&75,X)      :\ FD5D= 61 75       au
EQUB &73         :\ FD5F= 73          s
ADC &72          :\ FD60= 65 72       er
BIT &694D        :\ FD62= 2C 4D 69    ,Mi
EQUB &6B         :\ FD65= 6B          k
ADC &20          :\ FD66= 65 20       e 
PHA              :\ FD68= 48          H
ADC #&6C         :\ FD69= 69 6C       il
JMP (&4A2C)      :\ FD6B= 6C 2C 4A    l,J
 
EQUB &6F         :\ FD6E= 6F          o
PLA              :\ FD6F= 68          h
ROR &4820        :\ FD70= 6E 20 48    n H
EQUB &6F         :\ FD73= 6F          o
ADC (&74)        :\ FD74= 72 74       rt
EQUB &6F         :\ FD76= 6F          o
ROR &4E2C        :\ FD77= 6E 2C 4E    n,N
ADC &69          :\ FD7A= 65 69       ei
JMP (&4A20)      :\ FD7C= 6C 20 4A    l J
 
EQUB &6F         :\ FD7F= 6F          o
PLA              :\ FD80= 68          h
ROR &6F73        :\ FD81= 6E 73 6F    nso
ROR &522C        :\ FD84= 6E 2C 52    n,R
ADC #&63         :\ FD87= 69 63       ic
PLA              :\ FD89= 68          h
ADC (&72,X)      :\ FD8A= 61 72       ar
STZ &20          :\ FD8C= 64 20       d 
EQUB &4B         :\ FD8E= 4B          K
ADC #&6E         :\ FD8F= 69 6E       in
EQUB &67         :\ FD91= 67          g
BIT &6144        :\ FD92= 2C 44 61    ,Da
ROR &69,X        :\ FD95= 76 69       vi
STZ &20          :\ FD97= 64 20       d 
EQUB &4B         :\ FD99= 4B          K
ADC #&74         :\ FD9A= 69 74       it
EQUB &73         :\ FD9C= 73          s
EQUB &6F         :\ FD9D= 6F          o
ROR &4A2C        :\ FD9E= 6E 2C 4A    n,J
ADC &6C,X        :\ FDA1= 75 6C       ul
ADC #&61         :\ FDA3= 69 61       ia
ROR &4C20        :\ FDA5= 6E 20 4C    n L
EQUB &6F         :\ FDA8= 6F          o
ADC &6562        :\ FDA9= 6D 62 65    mbe
ADC (&67)        :\ FDAC= 72 67       rg
BIT &6F52        :\ FDAE= 2C 52 6F    ,Ro
EQUB &62         :\ FDB1= 62          b
JSR &614D        :\ FDB2= 20 4D 61     Ma
EQUB &63         :\ FDB5= 63          c
ADC &6C69        :\ FDB6= 6D 69 6C    mil
JMP (&6E61)      :\ FDB9= 6C 61 6E    lan
 
BIT &6952        :\ FDBC= 2C 52 69    ,Ri
EQUB &63         :\ FDBF= 63          c
PLA              :\ FDC0= 68          h
ADC (&72,X)      :\ FDC1= 61 72       ar
STZ &20          :\ FDC3= 64 20       d 
EOR &6E61        :\ FDC5= 4D 61 6E    Man
EQUB &62         :\ FDC8= 62          b
ADC &502C,Y      :\ FDC9= 79 2C 50    y,P
ADC &74          :\ FDCC= 65 74       et
ADC &72          :\ FDCE= 65 72       er
JSR &634D        :\ FDD0= 20 4D 63     Mc
EQUB &4B         :\ FDD3= 4B          K
ADC &6E          :\ FDD4= 65 6E       en
ROR &2C61        :\ FDD6= 6E 61 2C    na,
EOR (&6E,X)      :\ FDD9= 41 6E       An
STZ &72          :\ FDDB= 64 72       dr
ADC &77          :\ FDDD= 65 77       ew
JSR &634D        :\ FDDF= 20 4D 63     Mc
EQUB &4B         :\ FDE2= 4B          K
ADC &72          :\ FDE3= 65 72       er
ROR &6E61        :\ FDE5= 6E 61 6E    nan
BIT &694D        :\ FDE8= 2C 4D 69    ,Mi
EQUB &63         :\ FDEB= 63          c
EQUB &6B         :\ FDEC= 6B          k
JSR &654E        :\ FDED= 20 4E 65     Ne
ADC #&6C         :\ FDF0= 69 6C       il
BIT &6149        :\ FDF2= 2C 49 61    ,Ia
ROR &4E20        :\ FDF5= 6E 20 4E    n N
ADC #&62         :\ FDF8= 69 62       ib
JMP (&636F)      :\ FDFA= 6C 6F 63    loc
 
EQUB &6B         :\ FDFD= 6B          k
BIT &6C47        :\ FDFE= 2C 47 6C    ,Gl
ADC &6E          :\ FE01= 65 6E       en
JSR &694E        :\ FE03= 20 4E 69     Ni
EQUB &63         :\ FE06= 63          c
PLA              :\ FE07= 68          h
.LFE08
EQUB &6F         :\ FE08= 6F          o
.LFE09
JMP (&736C)      :\ FE09= 6C 6C 73    lls
 
BIT &6F52        :\ FE0C= 2C 52 6F    ,Ro
EQUB &62         :\ FE0F= 62          b
.LFE10
ADC &72          :\ FE10= 65 72       er
STZ &20,X        :\ FE12= 74 20       t 
LSR &6B6F        :\ FE14= 4E 6F 6B    Nok
ADC &73          :\ FE17= 65 73       es
.LFE19
BIT &6952        :\ FE19= 2C 52 69    ,Ri
EQUB &63         :\ FE1C= 63          c
PLA              :\ FE1D= 68          h
ADC (&72,X)      :\ FE1E= 61 72       ar
STZ &20          :\ FE20= 64 20       d 
BVC LFE85        :\ FE22= 50 61       Pa
EQUB &67         :\ FE24= 67          g
ADC &2C          :\ FE25= 65 2C       e,
EQUB &53         :\ FE27= 53          S
STZ &65,X        :\ FE28= 74 65       te
ROR &65,X        :\ FE2A= 76 65       ve
JSR &6150        :\ FE2C= 20 50 61     Pa
ADC (&73)        :\ FE2F= 72 73       rs
EQUB &6F         :\ FE31= 6F          o
EQUS "ns"	 :\ FE32= 6E 73 2C    ns
.LFE34
EQUS ","	 :\ FE34= 2C          ,
EOR &64          :\ FE35= 45 64       Ed
JSR &6850        :\ FE37= 20 50 68     Ph
ADC #&70         :\ FE3A= 69 70       ip
BVS LFEB1        :\ FE3C= 70 73       ps
BIT &6F4A        :\ FE3E= 2C 4A 6F    ,Jo
PLA              :\ FE41= 68          h
.LFE42
ROR &5220        :\ FE42= 6E 20 52    n R
.LFE45
ADC (&64,X)      :\ FE45= 61 64       ad
.LFE47
EQUB &63         :\ FE47= 63          c
JMP (&6669)      :\ FE48= 6C 69 66    lif
 
.LFE4B
ROR &65          :\ FE4B= 66 65       fe
.LFE4D
EQUB &2C         :\ FE4D= 2C 52 69    ,Ri
.LFE4E
EQUB &52
EQUB &69
EQUB &63         :\ FE50= 63          c
EQUB &6B         :\ FE51= 6B          k
JSR &6152        :\ FE52= 20 52 61     Ra
ROR &2C64        :\ FE55= 6E 64 2C    nd,
EQUB &42         :\ FE58= 42          B
ADC (&69)        :\ FE59= 72 69       ri
ADC (&6E,X)      :\ FE5B= 61 6E       an
JSR &6F52        :\ FE5D= 20 52 6F     Ro
EQUB &62         :\ FE60= 62          b
.LFE61
ADC &72          :\ FE61= 65 72       er
.LFE63
STZ &73,X        :\ FE63= 74 73       ts
EQUB &6F         :\ FE65= 6F          o
ROR &522C        :\ FE66= 6E 2C 52    n,R
ADC #&63         :\ FE69= 69 63       ic
PLA              :\ FE6B= 68          h
.LFE6C
ADC (&72,X)      :\ FE6C= 61 72       ar
.LFE6E
STZ &20          :\ FE6E= 64 20       d 
EOR (&75)        :\ FE70= 52 75       Ru
EQUB &73         :\ FE72= 73          s
EQUB &73         :\ FE73= 73          s
ADC &6C          :\ FE74= 65 6C       el
JMP (&472C)      :\ FE76= 6C 2C 47    l,G
 
EQUB &6F         :\ FE79= 6F          o
ADC (&64)        :\ FE7A= 72 64       rd
EQUB &6F         :\ FE7C= 6F          o
ROR &5320        :\ FE7D= 6E 20 53    n S
ADC (&67,X)      :\ FE80= 61 67       ag
ADC &2C          :\ FE82= 65 2C       e,
EQUB &54         :\ FE84= 54          T
.LFE85
ADC &72          :\ FE85= 65 72       er
ADC (&79)        :\ FE87= 72 79       ry
JSR &6353        :\ FE89= 20 53 63     Sc
EQUB &6F         :\ FE8C= 6F          o
STZ &63,X        :\ FE8D= 74 63       tc
PLA              :\ FE8F= 68          h
ADC &72          :\ FE90= 65 72       er
BIT &6144        :\ FE92= 2C 44 61    ,Da
ROR &69,X        :\ FE95= 76 69       vi
STZ &20          :\ FE97= 64 20       d 
EQUB &53         :\ FE99= 53          S
ADC &61          :\ FE9A= 65 61       ea
JMP (&502C)      :\ FE9C= 6C 2C 50    l,P
 
ADC (&75,X)      :\ FE9F= 61 75       au
JMP (&5320)      :\ FEA1= 6C 20 53    l S
 
EQUB &77         :\ FEA4= 77          w
ADC #&6E         :\ FEA5= 69 6E       in
STZ &65          :\ FEA7= 64 65       de
JMP (&2C6C)      :\ FEA9= 6C 6C 2C    ll,
 
LSR A            :\ FEAC= 4A          J
EQUB &6F         :\ FEAD= 6F          o
ROR &5420        :\ FEAE= 6E 20 54    n T
.LFEB1
PLA              :\ FEB1= 68          h
ADC (&63,X)      :\ FEB2= 61 63       ac
EQUB &6B         :\ FEB4= 6B          k
ADC (&61)        :\ FEB5= 72 61       ra
ADC &482C,Y      :\ FEB7= 79 2C 48    y,H
ADC &67,X        :\ FEBA= 75 67       ug
EQUB &6F         :\ FEBC= 6F          o
JSR &7954        :\ FEBD= 20 54 79     Ty
EQUB &73         :\ FEC0= 73          s
EQUB &6F         :\ FEC1= 6F          o
ROR &412C        :\ FEC2= 6E 2C 41    n,A
STZ &72          :\ FEC5= 64 72       dr
ADC #&61         :\ FEC7= 69 61       ia
ROR &5720        :\ FEC9= 6E 20 57    n W
ADC (&72,X)      :\ FECC= 61 72       ar
ROR &7265        :\ FECE= 6E 65 72    ner
BIT &654A        :\ FED1= 2C 4A 65    ,Je
EQUB &73         :\ FED4= 73          s
EQUB &73         :\ FED5= 73          s
JSR &6957        :\ FED6= 20 57 69     Wi
JMP (&736C)      :\ FED9= 6C 6C 73    lls
 
BIT &6F52        :\ FEDC= 2C 52 6F    ,Ro
EQUB &67         :\ FEDF= 67          g
.LFEE0
ADC &72          :\ FEE0= 65 72       er
.LFEE2
JSR &6957        :\ FEE2= 20 57 69     Wi
.LFEE5
JMP (&6F73)      :\ FEE5= 6C 73 6F    lso
 
.LFEE8
ROR &472C        :\ FEE8= 6E 2C 47    n,G
ADC (&61)        :\ FEEB= 72 61       ra
PLA              :\ FEED= 68          h
ADC (&6D,X)      :\ FEEE= 61 6D       am
JSR &6957        :\ FEF0= 20 57 69     Wi
ROR &6574        :\ FEF3= 6E 74 65    nte
ADC (&66)        :\ FEF6= 72 66       rf
JMP (&6F6F)      :\ FEF8= 6C 6F 6F    loo
 
STZ &2E          :\ FEFB= 64 2E       d.
JSR &2020        :\ FEFD= 20 20 20       
.LFF00
JSR LFF51        :\ FF00= 20 51 FF     Q.
JSR LFF51        :\ FF03= 20 51 FF     Q.
JSR LFF51        :\ FF06= 20 51 FF     Q.
JSR LFF51        :\ FF09= 20 51 FF     Q.
JSR LFF51        :\ FF0C= 20 51 FF     Q.
JSR LFF51        :\ FF0F= 20 51 FF     Q.
JSR LFF51        :\ FF12= 20 51 FF     Q.
JSR LFF51        :\ FF15= 20 51 FF     Q.
JSR LFF51        :\ FF18= 20 51 FF     Q.
JSR LFF51        :\ FF1B= 20 51 FF     Q.
JSR LFF51        :\ FF1E= 20 51 FF     Q.
JSR LFF51        :\ FF21= 20 51 FF     Q.
JSR LFF51        :\ FF24= 20 51 FF     Q.
JSR LFF51        :\ FF27= 20 51 FF     Q.
JSR LFF51        :\ FF2A= 20 51 FF     Q.
JSR LFF51        :\ FF2D= 20 51 FF     Q.
JSR LFF51        :\ FF30= 20 51 FF     Q.
JSR LFF51        :\ FF33= 20 51 FF     Q.
JSR LFF51        :\ FF36= 20 51 FF     Q.
JSR LFF51        :\ FF39= 20 51 FF     Q.
JSR LFF51        :\ FF3C= 20 51 FF     Q.
JSR LFF51        :\ FF3F= 20 51 FF     Q.
JSR LFF51        :\ FF42= 20 51 FF     Q.
JSR LFF51        :\ FF45= 20 51 FF     Q.
JSR LFF51        :\ FF48= 20 51 FF     Q.
JSR LFF51        :\ FF4B= 20 51 FF     Q.
JSR LFF51        :\ FF4E= 20 51 FF     Q.
.LFF51
PHA              :\ FF51= 48          H
PHA              :\ FF52= 48          H
PHA              :\ FF53= 48          H
PHA              :\ FF54= 48          H
PHA              :\ FF55= 48          H
PHA              :\ FF56= 48          H
PHP              :\ FF57= 08          .
PHA              :\ FF58= 48          H
PHX              :\ FF59= DA          Z
PHY              :\ FF5A= 5A          Z
TSX              :\ FF5B= BA          :
LDA #&FF         :\ FF5C= A9 FF       ).
STA &0108,X      :\ FF5E= 9D 08 01    ...
LDA #&8C         :\ FF61= A9 8C       ).
STA &0107,X      :\ FF63= 9D 07 01    ...
LDY &010B,X      :\ FF66= BC 0B 01    <..
LDA &0D9D,Y      :\ FF69= B9 9D 0D    9..
STA &0105,X      :\ FF6C= 9D 05 01    ...
LDA &0D9E,Y      :\ FF6F= B9 9E 0D    9..
STA &0106,X      :\ FF72= 9D 06 01    ...
LDA &F4          :\ FF75= A5 F4       %t
STA &010A,X      :\ FF77= 9D 0A 01    ...
LDA LFE34        :\ FF7A= AD 34 FE    -4~
STA &0109,X      :\ FF7D= 9D 09 01    ...
JSR LEDBA        :\ FF80= 20 BA ED     :m
LDA &0D9F,Y      :\ FF83= B9 9F 0D    9..
JSR LE592        :\ FF86= 20 92 E5     .e
PLY              :\ FF89= 7A          z
PLX              :\ FF8A= FA          z
PLA              :\ FF8B= 68          h
RTI              :\ FF8C= 40          @
 
PHP              :\ FF8D= 08          .
PHA              :\ FF8E= 48          H
PHX              :\ FF8F= DA          Z
TSX              :\ FF90= BA          :
LDA &0102,X      :\ FF91= BD 02 01    =..
STA &0106,X      :\ FF94= 9D 06 01    ...
LDA &0103,X      :\ FF97= BD 03 01    =..
STA &0107,X      :\ FF9A= 9D 07 01    ...
PLX              :\ FF9D= FA          z
PLA              :\ FF9E= 68          h
PLA              :\ FF9F= 68          h
PLA              :\ FFA0= 68          h
JSR LEDB0        :\ FFA1= 20 B0 ED     0m
PLA              :\ FFA4= 68          h
JSR LE592        :\ FFA5= 20 92 E5     .e
PLA              :\ FFA8= 68          h
PLP              :\ FFA9= 28          (
.LFFAA
RTS              :\ FFAA= 60          `

.LFFAB
LDY CRTC+0,X:RTS
 
.LFFAF
TXA:BRA OSBPUT
 
BRK

.LFFB3
JMP LF402            :\ FFB3
EQUB &36:EQUW LE2D7  :\ FFB6
JMP LF3FC            :\ FFB9
JMP LF3EC            :\ FFBC
JMP LEA28            :\ FFBF
JMP LF26E            :\ FFC2
JMP LF27F            :\ FFC5
JMP LE7BC            :\ FFC8
JMP LE822            :\ FFCB
JMP LFA1B            :\ FFCE
JMP LF9BE            :\ FFD1
JMP LF9B2            :\ FFD4
JMP LF9B8            :\ FFD7
JMP LF9E7            :\ FFDA
JMP LFA2A            :\ FFDD
JMP (&0210)          :\ FFE0
CMP #&0D:BNE OSWRCH  :\ FFE5
LDA #&0A:JSR OSWRCH  :\ FFE9
LDA #&0D             :\ FFEC
JMP (&020E)          :\ FFEE
JMP (&020C)          :\ FFF1
JMP (&020A)          :\ FFF4
JMP (&0208)          :\ FFF7
 
.LFFFA:EQUW &0D00    :\ FFFA NMIV
.LFFFC:EQUW LE364    :\ FFFB RESETV
.LFFFE:EQUW LE59E    :\ FFFE IRQV
