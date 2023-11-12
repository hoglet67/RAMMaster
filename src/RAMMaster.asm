       ORG    &8000

incmod  = TRUE

incepr  = TRUE

oswrch  = &FFEE
osnewl  = &FFE7
gsini   = &FFC2
gsread  = &FFC5
osbyte  = &FFF4
osrdrm  = &FFB9
osfile  = &FFDD
osrdch  = &FFE0
osasci  = &FFE3
osword  = &FFF1
oscli   = &FFF7

        IF     incepr
erablo  = &8C
erabhi  = &8D
eratlo  = &8E
erathi  = &8F
bufflo  = &90
buffhi  = &91
type    = &92
drv     = &93
bits    = &94
nerrs   = &95
ssss    = &96
eeee    = &98
mmmm    = &9A
oldx    = &9C
oldy    = &9D
ltemp   = &9E
        ENDIF

seed    = &A0
memend  = &A8
count   = &AA
ptr     = &AC
oshwm   = &AE
fspbuf  = &640

temp    = &80     ; CHANGEME TO &96
tempa   = &A0
tempx   = &A1
tempy   = &A2
commno  = &A3
comadd  = &A4
tabptr  = &A4
mesadd  = &A4
lobyte  = &A6
hibyte  = &A7
addlo   = &A8
addhi   = &A9
rbpt    = &AA
len     = &AC
val     = &AD
romlen  = &AD
trom    = &AE
esc     = &AF
romlo   = &F6
romhi   = &F7
romno   = &F8
errpt   = &FD
errmem  = &104
brkvec  = &202
intvec  = &206
bgetv   = &216
romtab  = &2A1
temtab  = &39F
errvec  = &3A1
tintvc  = &3A3
ssflag  = &3A5
stbuff  = &600
parmem  = &680
wrrom   = &900
pws     = &DF0
rombuf  = &3C00
orirb   = &FE60
ddrb    = &FE62
pcr     = &FE6C
ifr     = &FE6D
ier     = &FE6E

.romst  JMP    lang
        JMP    servic
        EQUB   &C2
        EQUB   copri-romst
        EQUB   &00
.brmes  EQUS   "RAM Master"
        EQUB   &00
        EQUS   "1.01"
.copri  EQUB   &00
        EQUS   "(C) David Banks 1985"
        EQUB   &00

.servic PHP
        PHA
        TXA
        PHA
        TYA
        PHA
        TSX
        LDA    &103,X
        CMP    #&10
        BEQ    shpbk
        LDX    &F4
        LDA    pws,X
        BMI    exit
        TSX
        LDA    &103,X
        CMP    #&03
        BEQ    sbkmes
        CMP    #&04
        BEQ    sstrcm
        CMP    #&06
        BEQ    sbrker
        CMP    #&09
        BEQ    shelp

.exit   JSR    sershw
        PLA
        TAY
        PLA
        TAX
        PLA
        PLP
        RTS

.exit1  JSR    sershw
        PLA
        TAY
        PLA
        TAX
        PLA
        LDA    #&00
        PLP
        RTS

.sbkmes JMP    bkmess
.sstrcm JMP    strcom
.sbrker JMP    brkerr
.shelp  JMP    help
.shpbk  JMP    hpbk

.sershw LDX    &F4
        LDA    pws,X
        BMI    noss
        LDA    ssflag
        CMP    #&01
        BNE    noss
        JSR    mesage
        EQUB   &0A, &0D
        EQUS   "Service with"
        EQUB   &0A, &0D
        EQUS   "On Entry  A="
        EQUB   &00
        TSX
        LDA    &105,X
        JSR    hexout
        JSR    mesage
        EQUS   " Y="
        EQUB   &00
        TSX
        LDA    &103,X
        JSR    hexout
        JSR    osnewl
        JSR    osnewl
.noss   RTS

.bkmess JSR    mesage
        EQUS   "RAM Master"
        EQUB   &0A, &0A, &0D, &00
        LDA    #&90
        JSR    osbyte
        LDY    #&01
        JSR    osbyte
        JMP    exit

.brkerr LDY    #&00
        LDA    (errpt),Y
        CMP    #&C5
        BEQ    drvflt
        CMP    #&C7
        BEQ    drvflt
.brkexi JMP    exit

.drvflt INY
.drvlp1 INY
        LDA    (errpt),Y
        JSR    hexcon
        BCS    drvlp1
        ASL    A
        ASL    A
        ASL    A
        ASL    A
        STA    tempa
        INY
        LDA    (errpt),Y
        JSR    hexcon
        BCS    brkexi
        CLC
        ADC    tempa
        LSR    A
        TAX
        LDA    detab,X
        TAX
.drvlp2 INY
        LDA    (errpt),Y
        BNE    drvlp2
.drvlp3 LDA    err0,X
        STA    (errpt),Y
        BEQ    brkexi
        INX
        INY
        BNE    drvlp3

.detab  EQUB   err0-err0
        EQUB   err1-err0
        EQUB   err2-err0
        EQUB   err3-err0
        EQUB   err4-err0
        EQUB   err5-err0
        EQUB   err6-err0
        EQUB   err7-err0
        EQUB   err8-err0
        EQUB   err9-err0
        EQUB   errA-err0
        EQUB   errB-err0
        EQUB   errC-err0
        EQUB   errD-err0
        EQUB   errE-err0
        EQUB   errF-err0
        EQUB   errG-err0

.err0   EQUB   &0A, &0D
        EQUS   "No error"
        EQUB   &00
.err1   EQUB   &0A, &0D
        EQUS   "Scan met not equal"
        EQUB   &00
.err2   EQUB   &0A, &0D
        EQUS   "Scan met equal"
        EQUB   &00
.err3   EQUB   &0A, &0D
        EQUS   "----"
        EQUB   &00
.err4   EQUB   &0A, &0D
        EQUS   "Clock error"
        EQUB   &00
.err5   EQUB   &0A, &0D
        EQUS   "Late DMA"
        EQUB   &00
.err6   EQUB   &0A, &0D
        EQUS   "ID CRC error"
        EQUB   &00
.err7   EQUB   &0A, &0D
        EQUS   "Data CRC error"
        EQUB   &00
.err8   EQUB   &0A, &0D
        EQUS   "Drive not ready"
        EQUB   &00
.err9   EQUB   &0A, &0D
        EQUS   "Write protect"
        EQUB   &00
.errA   EQUB   &0A, &0D
        EQUS   "Track 0 not found"
        EQUB   &00
.errB   EQUB   &0A, &0D
        EQUS   "Write fault"
        EQUB   &00
.errC   EQUB   &0A, &0D
        EQUS   "Sector not found"
        EQUB   &00
.errD   EQUB   &0A, &0D
        EQUS   "----"
        EQUB   &00
.errE   EQUB   &0A, &0D
        EQUS   "----"
        EQUB   &00
.errF   EQUB   &0A, &0D
        EQUS   "----"
        EQUB   &00
.errG   EQUB   &0A, &0D
        EQUS   "Deleted data found"
        EQUB   &00

.strcom LDA    #<comtab
        STA    tabptr
        LDA    #>comtab
        STA    tabptr+1
        JSR    search
        BCC    goto
        JMP    exit
.goto   ASL    A
        TAX
        LDA    jumtab,X
        STA    comadd
        LDA    jumtab+1,X
        STA    comadd+1
        JSR    gotcom
        JMP    exit1
.gotcom JMP    (comadd)

.jumtab EQUW   disc
        EQUW   ex
        EQUW   cli
        EQUW   rmast
        EQUW   rmcl
        EQUW   romdmp
        EQUW   romon
        EQUW   romoff
        EQUW   all
        EQUW   rload
        EQUW   reset
        EQUW   rmove
        EQUW   sshow
        EQUW   stand
        EQUW   roms
        EQUW   ascii
        EQUW   protct

        IF     incmod
        EQUW   online
        EQUW   ofline
        EQUW   dial
        EQUW   carier
        EQUW   answer
        EQUW   conect
        ENDIF

        IF     incepr
        EQUW   eprom
        ENDIF

.help   LDA    #<hlptab
        STA    tabptr
        LDA    #>hlptab
        STA    tabptr+1
        JSR    search
        BCS    hlpout
        CMP    #&00
        BEQ    hhgenl
        CMP    #&01
        BEQ    hhbk
        CMP    #&02
        BEQ    hhram

        IF     incmod
        CMP    #&03
        BEQ    hhmod
        ENDIF

        IF     incepr
        CMP    #&04
        BEQ    hhepr
        ENDIF

.hlpout JMP    exit

.hhgenl JMP    hgenl
.hhbk   JMP    hbk
.hhram  JMP    hram

        IF     incmod
.hhmod  JMP    hmod
        ENDIF

        IF     incepr
.hhepr  JMP    hepr
        ENDIF

.hgenl  JSR    mesage
        EQUB   &0A
        EQUS   "RAM Master 1.01"
        EQUB   &0A, &0D
        EQUS   "  BREAK"
        EQUB   &0A, &0D

        IF     incepr
        EQUS   "  EPROM"
        EQUB   &0A, &0D
        ENDIF

        IF     incmod
        EQUS   "  MODEM"
        EQUB   &0A, &0D
        ENDIF

        EQUS   "  RAM"
        EQUB   &0A, &0D, &00
        JMP    exit

.hbk    JSR    mesage
        EQUB   &0A
        EQUS   "RAM Master 1.01"
        EQUB   &0A, &0A, &0D
        EQUS   "Special Break Options"
        EQUB   &0A, &0A, &0D
        EQUS   "  <@ Break> ..... *ROMS"
        EQUB   &0A, &0D
        EQUS   "  <R Break> ..... *ALLROMS ON"
        EQUB   &0A, &0D
        EQUS   "  <S Break> ..... *STANDARD"
        EQUB   &0A, &0D
        EQUS   "  <f0 Break> .... *CAT 0"
        EQUB   &0A, &0D
        EQUS   "  <f1 Break> .... *CAT 1"
        EQUB   &0A, &0D
        EQUS   "  <f2 Break> .... *CAT 2"
        EQUB   &0A, &0D
        EQUS   "  <f3 Break> .... *CAT 3"
        EQUB   &0A, &0A, &0D, &00
        JMP    exit

.hram   JSR    mesage
        EQUB   &0A
        EQUS   "RAM Master 1.01"
        EQUB   &0A, &0A, &0D
        EQUS   "Sideways ROM/RAM Utilities"
        EQUB   &0A, &0A, &0D
        EQUS   "  ASCII   (<str>)"
        EQUB   &0A, &0D
        EQUS   "  ALLROMS <on/off>"
        EQUB   &0A, &0D
        EQUS   "  CLI"
        EQUB   &0A, &0D
        EQUS   "  DISC"
        EQUB   &0A, &0D
        EQUS   "  EX      <drive>"
        EQUB   &0A, &0D
        EQUS   "  NOMAST"
        EQUB   &0A, &0D
        EQUS   "  PROTECT <fsp> <password>"
        EQUB   &0A, &0D
        EQUS   "  RAMCL   <id> (<len>)"
        EQUB   &0A, &0D
        EQUS   "  RESET"
        EQUB   &0A, &0D
        EQUS   "  RLOAD   <id> <fsp>"
        EQUB   &0A, &0D
        EQUS   "  RMOVE   <start> <end> <to> (<romno>)"
        EQUB   &0A, &0D
        EQUS   "  ROMDUMP"
        EQUB   &0A, &0D
        EQUS   "  ROMOFF  <id>"
        EQUB   &0A, &0D
        EQUS   "  ROMON   <id>"
        EQUB   &0A, &0D
        EQUS   "  ROMS"
        EQUB   &0A, &0D
        EQUS   "  SSHOW   <on/off>"
        EQUB   &0A, &0D
        EQUS   "  STANDARD"
        EQUB   &0A, &0A, &0D, &00
        JMP    exit

        IF     incmod
.hmod   JSR    mesage
        EQUB   &0A
        EQUS   "RAM Master 1.01"
        EQUB   &0A, &0A, &0D
        EQUS   "Modem Controlling Commands"
        EQUB   &0A, &0A, &0D
        EQUS   "  ANSWER"
        EQUB   &0A, &0D
        EQUS   "  CARRIER"
        EQUB   &0A, &0D
        EQUS   "  CONNECT <on/off>"
        EQUB   &0A, &0D
        EQUS   "  DIAL    <number>"
        EQUB   &0A, &0D
        EQUS   "  OFFLINE"
        EQUB   &0A, &0D
        EQUS   "  ONLINE"
        EQUB   &0A, &0A, &0D
        EQUS   "Errors produced"
        EQUB   &0A, &0A, &0D
        EQUS   "  104 ... No Carrier"
        EQUB   &0A, &0D
        EQUS   "  105 ... Carrier Lost"
        EQUB   &0A, &0A, &0D, &00
        JMP    exit
        ENDIF

        IF     incepr
.hepr   JSR    mesage
        EQUB   &0A
        EQUS   "RAM Master 1.01"
        EQUB   &0A, &0A, &0D
        EQUS   "Eprom Programmer Commands"
        EQUB   &0A, &0A, &0D
        EQUS   "  EPROM"
        EQUB   &0A, &0A, &0D, &00
        JMP    exit
        ENDIF

.search DEY
.sloop0 INY
        LDA    (&F2),Y
        CMP    #&20
        BEQ    sloop0
        DEY
        STY    tempy
        LDX    #&FF
        STX    commno
        INX
.sloop1 LDY    tempy
        INC    commno
.sloop2 INY
        JSR    inptr
        LDA    (tabptr,X)
        BMI    snone
        BEQ    sfound
        LDA    (&F2),Y
        AND    #&DF
        CMP    (tabptr,X)
        BEQ    sloop2
        CMP    #&0E
        BEQ    sabbr
.snext  JSR    inptr
        LDA    (tabptr,X)
        BNE    snext
        BEQ    sloop1
.sabbr  INY
.sfound LDA    commno
        CLC
        RTS
.snone  SEC
        RTS

.inptr  INC    tabptr
        BNE    intexi
        INC    tabptr+1
.intexi RTS

.comtab EQUB   &00
        EQUS   "DISC"
        EQUB   &00
        EQUS   "EX"
        EQUB   &00
        EQUS   "CLI"
        EQUB   &00
        EQUS   "NOMAST"
        EQUB   &00
        EQUS   "RAMCL"
        EQUB   &00
        EQUS   "ROMDUMP"
        EQUB   &00
        EQUS   "ROMON"
        EQUB   &00
        EQUS   "ROMOFF"
        EQUB   &00
        EQUS   "ALLROMS"
        EQUB   &00
        EQUS   "RLOAD"
        EQUB   &00
        EQUS   "RESET"
        EQUB   &00
        EQUS   "RMOVE"
        EQUB   &00
        EQUS   "SSHOW"
        EQUB   &00
        EQUS   "STANDARD"
        EQUB   &00
        EQUS   "ROMS"
        EQUB   &00
        EQUS   "ASCII"
        EQUB   &00
        EQUS   "PROTECT"
        EQUB   &00

        IF     incmod
        EQUS   "ONLINE"
        EQUB   &00
        EQUS   "OFFLINE"
        EQUB   &00
        EQUS   "DIAL"
        EQUB   &00
        EQUS   "CARRIER"
        EQUB   &00
        EQUS   "ANSWER"
        EQUB   &00
        EQUS   "CONNECT"
        EQUB   &00
        ENDIF

        IF     incepr
        EQUS   "EPROM"
        EQUB   &00
        ENDIF

        EQUB   &FF

.hlptab EQUB   &00
        EQUB   &0D
        EQUB   &00
        EQUS   "BREAK"
        EQUB   &00
        EQUS   "RAM"
        EQUB   &00
        IF     incmod
        EQUS   "MODEM"
        EQUB   &00
        ENDIF

        IF     incepr
        EQUS   "EPROM"
        EQUB   &00
        ENDIF

        EQUB   &FF

.hpbk   LDA    #&FD
        LDX    #&00
        LDY    #&FF
        JSR    osbyte
        CPX    #&01
        BNE    hpbk1
        JSR    romini
        LDA    #&00
        LDX    &F4
        STA    pws,X
.hpbk1  LDA    #&7A
        JSR    osbyte
        CPX    #&42   ; X
        BEQ    domenu
        LDY    &F4
        LDA    pws,Y
        BMI    hpbk2
        JSR    romcop
        CPX    #&33   ; R
        BEQ    brrest
        CPX    #&20   ; f0
        BEQ    brcat
        CPX    #&71   ; f1
        BEQ    brcat
        CPX    #&72   ; f2
        BEQ    brcat
        CPX    #&73   ; f3
        BEQ    brcat
        CPX    #&47   ; @
        BEQ    brrom
        CPX    #&51   ; S
        BEQ    brstan
.hpbk2  JMP    exit

.brrest JSR    romini
        JMP    bk

.brcat  TXA
        AND    #&03
        ORA    #&30
        PHA
        JSR    keyrel
        LDA    #'*'
        JSR    intokb
        LDA    #'C'
        JSR    intokb
        LDA    #'A'
        JSR    intokb
        LDA    #'T'
        JSR    intokb
        LDA    #' '
        JSR    intokb
        PLA
        JSR    intokb
        LDA    #&0D
        JSR    intokb
        JMP    exit
.intokb TAY
        LDA    #&8A
        LDX    #&00
        JMP    osbyte

.brrom  CLI
        JSR    clrkbd
        JSR    roms
        JMP    bk

.brstan JSR    stand
        JMP    bk

.domenu JSR    clrkbd
        JSR    romcop
        LDA    #&00
        LDX    &F4
        STA    pws,X
        JSR    mesage
        EQUB   &0C, &0A
        EQUS   "RAM Master"
        EQUB   &0A, &0D
        EQUS   "___ ______"
        EQUB   &0A, &0A, &0D
        EQUS   "  (A) ... Abort"
        EQUB   &0A, &0D
        EQUS   "  (D) ... Disable Sideways Ram"
        EQUB   &0A, &0D
        EQUS   "  (P) ... Power Up Break"
        EQUB   &0A, &0D
        EQUS   "  (R) ... Restore Roms"
        EQUB   &0A, &0D
        EQUS   "  (S) ... Standard"
        EQUB   &0A, &0D
        EQUS   "  (W) ... Wipe Sideways Ram"
        EQUB   &0A, &0D
        EQUS   "  (@) ... Turn Roms On / Off"
        EQUB   &0A, &0D
        EQUS   "  (*) ... OS Command"
        EQUB   &0A, &0A, &0D
        EQUS   "Enter Choice : "
        EQUB   &00
.mlp1   JSR    eink
        BCS    mlp1
        TXA
        CMP    #'A'
        BEQ    xabort
        CMP    #'W'
        BEQ    xwipe
        CMP    #'P'
        BEQ    xpubrk
        CMP    #'R'
        BEQ    xrsrom
        CMP    #'D'
        BEQ    xrdis
        CMP    #'S'
        BEQ    xbstan
        CMP    #'@'
        BEQ    xbrrom
        CMP    #'*'
        BEQ    xbstar
        BNE    mlp1

.xabort JMP    abort
.xwipe  JMP    wipe
.xpubrk JMP    pubrk
.xrsrom JMP    resrom
.xrdis  JMP    rdis
.xbstan JMP    brstan
.xbrrom JMP    brrom
.xbstar JMP    bstar

.abort  JSR    oswrch
        JSR    keyrel
        JMP    bk

.wipe   JSR    oswrch
        JSR    keyrel
        JSR    mesage
        EQUB   &0A, &0D
        EQUS   "Which RAM slot to Wipe ? "
        EQUB   &00
        JSR    rmslot
        LDA    #&00
        STA    romlo
        LDA    #&80
        STA    romhi
        LDA    #&40
        STA    len
        LDA    #&00
        STA    val
        JSR    fill1
        JMP    bk

.pubrk  JSR    oswrch
        LDA    #&97
        LDX    #&4E
        LDY    #&7F
        JSR    osbyte
.bk     JSR    keyrel
        JMP    (&FFFC)

.resrom JSR    oswrch
        JSR    keyrel
        JSR    romini
        JMP    bk

.rdis   JSR    oswrch
        JSR    keyrel
        JSR    mesage
        EQUB   &0A, &0D
        EQUS   "Which RAM slot to disable ? "
        EQUB   &00
        JSR    rmslot
        LDY    romno
        LDA    #&07
        STA    romlo
        LDA    #&80
        STA    romhi
        JSR    osrdrm
        CLC
        ADC    #&02
        STA    romlo
        LDA    #&63
        LDY    romno
        JSR    wrrom
        JMP    bk

.bstar  JSR    mesage
        EQUB   &0A, &0A, &0D, &2A, &20, &00
        LDA    #&00
        LDX    #<oswpar
        LDY    #>oswpar
        JSR    osword
        LDX    #<stbuff
        LDY    #>stbuff
        JSR    oscli
        JSR    mesage
        EQUB   &0A, &0D
        EQUS   "Press any Key to continue"
        EQUB   &00
        JSR    keyrel
.skeypr LDA    #&7A
        JSR    osbyte
        CPX    #&FF
        BEQ    skeypr
        JSR    keyrel
        JMP    domenu

.oswpar EQUW   stbuff
        EQUB   &27, &20, &7F

.keyrel PHA
.key1   LDA    #&7A
        JSR    osbyte
        CPX    #&FF
        BNE    key1
        JSR    clrkbd
        PLA
        RTS

.clrkbd LDA    #15
        LDX    #1
        LDY    #0
        JMP    osbyte

.rmslot JSR    asswrt
        JSR    keyrel
.wlp    JSR    eink
        TXA
        JSR    hexcon
        BCS    wlp
        STA    romno
        TXA
        JSR    oswrch
        JSR    keyrel
        JSR    osnewl
        JSR    rmwrt
        RTS

.romini LDA    #&00
        STA    temtab
        STA    temtab+1
        RTS

.romcop TXA
        PHA
        LDA    temtab
        STA    hibyte
        LDA    temtab+1
        STA    lobyte
        LDA    #&00
        STA    romno
.rclp   ROL    lobyte
        ROL    hibyte
        BCC    incrom
        LDA    #&00
        LDX    romno
        STA    romtab,X
.incrom INC    romno
        LDA    romno
        CMP    #&10
        BNE    rclp
        PLA
        TAX
        RTS

.eink   LDA    #&81
        LDX    #&00
        LDY    #&00
        JSR    osbyte
        PHP
        LDA    #&7C
        JSR    osbyte
        PLP
        RTS

.mesage PLA
        STA    mesadd
        PLA
        STA    mesadd+1
        LDY    #&00
.meslp  JSR    inmesa
        LDA    (mesadd),Y
        BEQ    mesout
        JSR    oswrch
        BNE    meslp
.mesout JSR    inmesa
        JMP    (mesadd)

.inmesa INC    mesadd
        BNE    mesnc
        INC    mesadd+1
.mesnc  RTS

.getadd LDA    #&00
        STA    addlo
        STA    addhi
        SEC
        JSR    gsini
        BEQ    nperr
        CLC
        JSR    gsini
.glp    JSR    gsread
        BCS    gconv
        JSR    hexcon
        BCS    bherr
        ASL    A
        ASL    A
        ASL    A
        ASL    A
        LDX    #&04
.glp1   ASL    A
        ROL    addlo
        ROL    addhi
        DEX
        BNE    glp1
        BEQ    glp
.gconv  RTS
.bherr  LDX    #&00
        JMP    error
.nperr  LDX    #&01
        JMP    error

.hexcon CMP    #&30
        BCC    badhex
        CMP    #&3A
        BCC    godhex
        CMP    #&41
        BCC    badhex
        CMP    #&47
        BCS    badhex
        SEC
        SBC    #&07
.godhex SEC
        SBC    #&30
        CLC
        RTS
.badhex SEC
        RTS

.getfsp CLC
        JSR    gsini
        LDX    #&00
        STX    tempx
.fsplp  JSR    gsread
        BCS    fspend
        LDX    tempx
        STA    stbuff,X
        INC    tempx
        BNE    fsplp
.fspend PHA
        LDA    #&0D
        LDX    tempx
        STA    stbuff,X
        PLA
        RTS

.geton  SEC
        JSR    gsini
        CLC
        JSR    gsini
        JSR    gsread
        BCS    badpar
        AND    #&DF
        CMP    #'O'
        BNE    badpar
        JSR    gsread
        BCS    badpar
        AND    #&DF
        CMP    #'N'
        BEQ    doon
        CMP    #'F'
        BEQ    dooff
.badpar LDX    #&07
        JMP    error
.doon   CLC
        RTS
.dooff  SEC
        RTS

.hexout PHA
        AND    #&F0
        LSR    A
        LSR    A
        LSR    A
        LSR    A
        JSR    hex1
        PLA
        AND    #&0F
.hex1   ADC    #&30
        CMP    #&3A
        BCC    hex2
        ADC    #&06
.hex2   JMP    oswrch

.decout LDX    #&02
.declp1 LDY    #&30
.declp2 CMP    decdat,X
        BCC    decpr
        SBC    decdat,X
        INY
        BNE    declp2
.decpr  PHA
        TYA
        JSR    oswrch
        PLA
        DEX
        BPL    declp1
        RTS

.decdat EQUB   1,10,100

.prtab  STA    tempa
.tablp  LDA    #&20
        JSR    oswrch
        LDA    #134
        JSR    osbyte
        CPX    tempa
        BNE    tablp
        RTS

.error  LDA    #<errtab
        STA    tabptr
        LDA    #>errtab
        STA    tabptr+1
        LDY    #&00
.errlp  CPX    #&00
        BEQ    errmov
.errlp1 INC    tabptr
        BNE    errnc0
        INC    tabptr+1
.errnc0 LDA    (tabptr),Y
        BNE    errlp1
        DEX
        BNE    errlp
        INY
.errmov LDX    #&00
        STX    errmem
.errlp2 LDA    (tabptr),Y
        STA    errmem+1,X
        BEQ    goterr
        INX
        INY
        BNE    errlp2
.goterr JMP    errmem

.errtab EQUB   100
        EQUS   "Bad Hex"
        EQUB   &00
        EQUB   101
        EQUS   "Missing Parameter"
        EQUB   &00
        EQUB   102
        EQUS   "Bad Rom"
        EQUB   &00
        EQUB   17
        EQUS   "Escape"
        EQUB   &00
        EQUB   103
        EQUS   "Bad Number"
        EQUB   &00
        EQUB   104
        EQUS   "No Carrier"
        EQUB   &00
        EQUB   105
        EQUS   "Carrier Lost"
        EQUB   &00
        EQUB   106
        EQUS   "Parameter not ON or OFF"
        EQUB   &00
        EQUB   107
        EQUS   "Incorrect Password"
        EQUB   &00

.rmast  LDA    #&80
        LDX    &F4
        STA    pws,X
        JMP    bk

.asswrt LDX    #&00
.asslp  LDA    code,X
        STA    wrrom,X
        INX
        CMP    #&60
        BNE    asslp
.assout RTS
.code   LDX    &F4
        STY    &F4
        STY    &FE30
        LDY    #&00
        STA    (romlo),Y
        STX    &F4
        STX    &FE30
        RTS

.rmcl   JSR    asswrt
        JSR    getadd
        TAX
        LDA    addlo
        AND    #&0F
        STA    romno
        LDA    #&00
        STA    romlo
        LDA    #&80
        STA    romhi
        LDA    #&40
        STA    len
        LDA    #&00
        STA    val
        CPX    #&0D
        BEQ    fillrm
        JSR    getadd
        LDA    addhi
        STA    len
.fillrm JSR    rmwrt
.fill1  LDA    val
        LDY    romno
        JSR    wrrom
        INC    romlo
        BNE    fill1
        INC    romhi
        DEC    len
        BNE    fill1
        RTS

.romdmp LDA    #&00
        STA    romno
.romlp  LDA    romno
        JSR    hexout
        JSR    onoff
        JSR    romtst
        BCC    romttl
        JSR    osnewl
        JMP    nxtrom
.romttl JSR    prttl
        JSR    serlan
        JSR    l0816
.nxtrom INC    romno
        LDA    romno
        CMP    #&10
        BNE    romlp
        RTS

.onoff  LDX    romno
        LDA    romtab,X
        BEQ    inact
        JSR    mesage
        EQUS   " ] "
        EQUB   &00
        RTS
.inact  JSR    mesage
        EQUS   " : "
        EQUB   &00

.romtst LDA    #&07
        STA    romlo
        LDA    #&80
        STA    romhi
        LDY    romno
        JSR    osrdrm
        STA    romlen
        STA    romlo
        LDY    romno
        JSR    osrdrm
        CMP    #&00
        BNE    rombad
        INC    romlo
        INC    romlo
        LDY    romno
        JSR    osrdrm
        CMP    #&43
        BEQ    romok
.rombad SEC
        RTS
.romok  CLC
        RTS

.prttl  LDA    #&12
        STA    len
        LDA    #&09
        STA    romlo
        LDA    #&80
        STA    romhi
.romlp1 LDY    romno
        JSR    osrdrm
        CMP    #&00
        BEQ    versun
        JSR    print
        INC    romlo
        DEC    len
        BNE    romlp1
.find00 LDY    romno
        JSR    osrdrm
        CMP    #&00
        BEQ    versun
        INC    romlo
        BNE    find00
.versun LDA    romlo
        CMP    romlen
        BEQ    prrout
.spcskp INC    romlo
        LDY    romno
        JSR    osrdrm
        CMP    #&20
        BEQ    spcskp
        LDA    #&18
        JSR    prtab
        LDA    #&04
        STA    len
.romlp2 LDY    romno
        JSR    osrdrm
        JSR    print
        INC    romlo
        DEC    len
        BNE    romlp2
.prrout RTS

.print  CMP    #&20
        BCC    npri
        CMP    #&7F
        BCS    npri
        JSR    oswrch
.npri   RTS

.serlan LDA    #30
        JSR    prtab
        LDA    #&06
        STA    romlo
        LDY    romno
        JSR    osrdrm
        ASL    A
        TAX
        LDA    #' '
        BCC    notser
        LDA    #'S'
.notser JSR    oswrch
        TXA
        ASL    A
        LDA    #' '
        BCC    notlan
        LDA    #'L'
.notlan JSR    oswrch
        RTS

.l0816  LDA    #34
        JSR    prtab
        LDA    #&05
        JSR    romcom
        BNE    len16
        LDA    #&06
        JSR    romcom
        BNE    len16
        LDA    #&07
        JSR    romcom
        BNE    len16
        LDA    #&08
        BNE    prlen
.len16  LDA    #&16
.prlen  JSR    hexout
        JSR    mesage
        EQUS   " K"
        EQUB   &0A, &0D, &00
        RTS

.romcom STA    romlo
        LDA    #&80
        STA    romhi
        LDY    romno
        JSR    osrdrm
        STA    romlen
        LDA    #&A0
        STA    romhi
        LDY    romno
        JSR    osrdrm
        CMP    romlen
        RTS

.stand  JSR    aloff
        LDA    #&FC
        LDX    #&00
        LDY    #&FF
        JSR    osbyte
        TXA
        JSR    ron
        LDA    #&0F
        STA    romno
.stloop LDA    #&08
        STA    romlo
        LDA    #&80
        STA    romhi
        JSR    rdrm
        CMP    #'D'
        BNE    stne
        JSR    rdrm
        CMP    #'F'
        BNE    stne
        JSR    rdrm
        CMP    #'S'
        BNE    stne
        LDA    romno
        JSR    ron
.stout  RTS

.stne   DEC    romno
        LDA    romno
        BPL    stloop
        RTS

.rdrm   INC    romlo
        LDY    romno
        JSR    osrdrm
        RTS

.romoff JSR    getadd
        LDA    addlo
        AND    #&0F
.roff   STA    romno
        TAX
        LDA    #&00
        STA    romtab,X
        SEC
        JSR    chbit
        RTS

.romon  JSR    getadd
        LDA    addlo
        AND    #&0F
.ron    STA    romno
        JSR    romtst
        BCS    bdrom
.ron1   LDY    romno
        LDA    #&06
        STA    romlo
        LDA    #&80
        STA    romhi
        JSR    osrdrm
        LDX    romno
        STA    romtab,X
        CLC
        JSR    chbit
        RTS
.bdrom  LDX    #&02
        JMP    error

.chbit  PHP
        LDA    romno
        LSR    A
        LSR    A
        LSR    A
        AND    #&01
        TAX
        LDA    romno
        AND    #&07
        TAY
        LDA    bitpt,Y
        PLP
        BCC    clbit
        ORA    temtab,X
        STA    temtab,X
        RTS
.clbit  EOR    #&FF
        AND    temtab,X
        STA    temtab,X
        RTS

.bitpt  EQUB   &80
        EQUB   &40
        EQUB   &20
        EQUB   &10
        EQUB   &08
        EQUB   &04
        EQUB   &02
        EQUB   &01

.all    JSR    geton
        BCC    alon
.aloff  LDX    #&0F
        LDA    #&00
.aloff1 STA    romtab,X
        DEX
        BPL    aloff1
        LDA    #&FF
        STA    temtab
        STA    temtab+1
        RTS
.alon   LDA    #&00
        STA    romno
.alon1  JSR    romtst
        BCS    alon2
        JSR    ron1
.alon2  INC    romno
        LDA    romno
        CMP    #&10
        BNE    alon1
        RTS

.cli    LDA    #&8E
        LDX    &F4
        JMP    osbyte

.lang   CMP    #&01
        BEQ    lang1
        RTS
.lang1  LDX    #&FF
        TXS
        CLI
        LDA    #<clierr
        STA    brkvec
        LDA    #>clierr
        STA    brkvec+1
        JSR    mesage
        EQUS   "Command Line Interpreter"
        EQUB   &0A, &0A, &0D, &00
.lang2  LDA    #'*'
        JSR    oswrch
        LDA    #&00
        LDX    #<oswpar
        LDY    #>oswpar
        JSR    osword
        BCS    lang3
        CPY    #&00
        BEQ    lang2
        JSR    docmd
.lang3  LDA    #&7E
        JSR    osbyte
        JSR    osnewl
        JMP    lang2

.clierr LDY    #&00
.clier1 INY
        LDA    (errpt),Y
        BEQ    lang3
        JSR    oswrch
        BNE    clier1

.disc   LDX    #disk-cmd
        JSR    cocmd
        JMP    docmd

.ex     JSR    getadd
        JSR    mesage
        EQUS   "Filename      Load   Exec   Length Sec"
        EQUB   &0A, &0D, &00
        LDX    #info-cmd
        JSR    cocmd
        LDA    addlo
        AND    #&03
        ORA    #&30
        STA    stbuff+6
        JMP    docmd

.cocmd  LDY    #&00
.coclp  LDA    cmd,X
        STA    stbuff,Y
        INX
        INY
        CMP    #&0D
        BNE    coclp
        RTS

.docmd  LDX    #<stbuff
        LDY    #>stbuff
        JMP    oscli
.cmd

.disk   EQUS   "DISK"
        EQUB   &0D

.info   EQUS   "INFO :0.*.*"
        EQUB   &0D

.rload  JSR    lpcop
        JSR    getadd
        LDA    addlo
        AND    #&0F
        STA    romno
        TAX
        LDA    #&00
        STA    romtab,X
        JSR    getfsp
        JSR    rmswp
        JSR    newerr
        LDA    #&FF
        LDX    #<parmem
        LDY    #>parmem
        JSR    osfile
        JSR    rmswp
        JSR    olderr
        RTS

.rmswp  JSR    rmwrt
        JSR    asswrt
        LDA    #&00
        STA    romlo
        LDA    #&80
        STA    romhi
        LDA    #<rombuf
        STA    rbpt
        LDA    #>rombuf
        STA    rbpt+1
.swplp  LDY    #&00
        LDA    (rbpt),Y
        PHA
        LDY    romno
        JSR    osrdrm
        LDY    #&00
        STA    (rbpt),Y
        PLA
        LDY    romno
        JSR    wrrom
        INC    romlo
        BNE    swpnc
        INC    romhi
.swpnc  INC    rbpt
        BNE    swpnc1
        INC    rbpt+1
.swpnc1 LDA    romhi
        CMP    #&C0
        BNE    swplp
        RTS

.rmwrt  JSR    asswrt
        LDA    #&00
        STA    romlo
        LDA    #&80
        STA    romhi
        LDY    romno
        JSR    osrdrm
        STA    trom
        JSR    rmtst
        BCC    rmok
        JSR    mesage
        EQUB   &0A, &0D
        EQUS   "RAM read only"
        EQUB   &0A, &0D
        EQUS   "Please alter switch"
        EQUB   &0A, &0D, &00
.wrtlp  JSR    rmtst
        BCS    wrtlp
        LDY    #&10
.del    LDX    #&FF
.del1   DEX
        BNE    del1
        DEY
        BNE    del
.rmok   LDA    trom
        LDY    romno
        JSR    wrrom
        RTS
.rmtst  LDY    romno
        JSR    osrdrm
        EOR    #&FF
        STA    tempa
        LDY    romno
        JSR    wrrom
        LDY    romno
        JSR    osrdrm
        CMP    tempa
        BNE    readon
        CLC
        RTS
.readon SEC
        RTS


.lpcop  LDX    #&00
        TYA
        PHA
        LDY    #&00
.doclp  LDA    para,X
        STA    parmem,Y
        INX
        INY
        CPY    #&12
        BNE    doclp
        PLA
        TAY
        RTS

.para   EQUW   stbuff
        EQUW   rombuf
        EQUW   &0000
        EQUD   &00000000
        EQUD   &00000000
        EQUD   &00000000

.newerr LDA    brkvec
        STA    errvec
        LDA    brkvec+1
        STA    errvec+1
        LDA    #&03
        STA    brkvec
        LDA    #&FF
        STA    brkvec+1
        LDA    #&A8
        LDX    #&00
        LDY    #&FF
        JSR    osbyte
        INX
        INX
        INX
        STX    temp
        STY    temp+1
        LDY    #&00
        LDA    #<errhan
        STA    (temp),Y
        INY
        LDA    #>errhan
        STA    (temp),Y
        INY
        LDA    &F4
        STA    (temp),Y
        RTS
.olderr LDA    errvec
        STA    brkvec
        LDA    errvec+1
        STA    brkvec+1
        RTS
.errhan JSR    olderr
        JSR    rmswp
        SEC
        LDA    errpt
        SBC    #&01
        STA    errpt
        LDA    errpt+1
        SBC    #&00
        STA    errpt+1
        JMP    (errpt)


.reset  JSR    keyrel
        JSR    mesage
        EQUS   "Are you sure (Y/N) ? "
        EQUB   &00
.reset1 JSR    eink
        BCS    reset1
        TXA
        AND    #&DF
        CMP    #'Y'
        BEQ    reset2
        JSR    mesage
        EQUS   "No"
        EQUB   &0A, &0D, &00
        JSR    keyrel
        RTS
.reset2 JSR    mesage
        EQUS   "Yes"
        EQUB   &0A, &0D, &00
        JSR    keyrel
        LDA    #151
        LDX    #78
        LDY    #127
        JSR    osbyte
        JMP    (&FFFC)


.rmove  JSR    asswrt
        LDX    #&0F
        STX    romno
        JSR    getadd
        LDX    addlo
        STX    temp+0
        LDX    addhi
        STX    temp+1
        JSR    getadd
        LDX    addlo
        STX    temp+2
        LDX    addhi
        STX    temp+3
        JSR    getadd
        LDX    addlo
        STX    temp+4
        LDX    addhi
        STX    temp+5
        CMP    #&0D
        BEQ    normno
        JSR    getadd
        LDA    addlo
        AND    #&0F
        STA    romno
.normno SEC
        LDA    temp+2
        SBC    temp+0
        STA    temp+6
        LDA    temp+3
        SBC    temp+1
        STA    temp+7
        LDX    #temp+4
        LDY    #temp+0
        JSR    dcomp
        BCC    for
        LDX    #temp+2
        LDY    #temp+4
        JSR    dcomp
        BCC    for
.back   CLC
        LDA    temp+4
        ADC    temp+6
        STA    temp+4
        LDA    temp+5
        ADC    temp+7
        STA    temp+5
.backlp LDX    temp+2
        STX    romlo
        LDX    temp+3
        STX    romhi
        LDY    romno
        JSR    osrdrm
        LDX    temp+4
        STX    romlo
        LDX    temp+5
        STX    romhi
        LDY    romno
        JSR    wrrom
        LDX    #temp+2
        JSR    dec
        LDX    #temp+4
        JSR    dec
        LDX    #temp+6
        JSR    dec
        BCS    backlp
        RTS
.for    LDX    temp+0
        STX    romlo
        LDX    temp+1
        STX    romhi
        LDY    romno
        JSR    osrdrm
        LDX    temp+4
        STX    romlo
        LDX    temp+5
        STX    romhi
        LDY    romno
        JSR    wrrom
        LDX    #temp+0
        JSR    inc
        LDX    #temp+4
        JSR    inc
        LDX    #temp+6
        JSR    dec
        BCS    for
        RTS
.inc    CLC
        LDA    &00,X
        ADC    #&01
        STA    &00,X
        LDA    &01,X
        ADC    #&00
        STA    &01,X
        RTS
.dec    SEC
        LDA    &00,X
        SBC    #&01
        STA    &00,X
        LDA    &01,X
        SBC    #&00
        STA    &01,X
        RTS
.dcomp  LDA    &01,X
        CMP    &01,Y
        BCC    dc2
        BNE    dc1
        LDA    &00,X
        CMP    &00,Y
        BCC    dc2
.dc1    SEC
        RTS
.dc2    CLC
        RTS

.roms   JSR    mesage
        EQUB   &16, &07, &0A, &0A, &00
        JSR    curoff
.roms0  LDA    #&1E
        JSR    oswrch
        JSR    mesage
        EQUB   &1F, &0B, &01, &81, &8D
        EQUS   "Sideways ROMs"
        EQUB   &1F, &0B, &02, &81, &8D
        EQUS   "Sideways ROMs"
        EQUB   &0A, &0A, &0D, &00
        JSR    romdmp
        JSR    mesage
        EQUB   &0A, &0D
        EQUS   "<0]F> ... Toggle ROM  <Ret> ... Allon"
        EQUB   &0A, &0D
        EQUS   "<Esc> ... Abort       <Del> ... Alloff"
        EQUB   &0A, &0D
        EQUS   "<S> ..... Standard"
        EQUB   &00
        JSR    osnewl
.roms1  JSR    osrdch
        BCS    romout
        CMP    #&0D
        BEQ    ralon
        CMP    #&7F
        BEQ    raloff
        CMP    #'S'
        BEQ    rstand
        JSR    hexcon
        BCS    roms1
        TAX
        LDA    romtab,X
        BNE    romson
        TXA
        STA    romno
        JSR    romtst
        BCS    roms1
        LDA    romno
        JSR    ron
        JMP    roms0
.romson TXA
        JSR    roff
        JMP    roms0
.ralon  JSR    alon
        JMP    roms0
.raloff JSR    aloff
        JMP    roms0
.rstand JSR    stand
        JMP    roms0
.romout JSR    curon
        LDA    #&7E
        JMP    osbyte

.curon  LDX    #&01
        BNE    cur
.curoff LDX    #&00
.cur    LDA    #&17
        JSR    oswrch
        LDA    #&01
        JSR    oswrch
        TXA
        JSR    oswrch
        LDX    #&07
        LDA    #&00
.curlp  JSR    oswrch
        DEX
        BNE    curlp
        RTS

.ascii  JSR    getfsp
        CPX    #&00
        BEQ    asctab
        STX    temp
        LDY    #&00
.asclp  LDA    stbuff,Y
        JSR    ascout
        JSR    osnewl
        INY
        CPY    temp
        BNE    asclp
        RTS
.asctab LDY    #&20
.atablp TYA
        JSR    ascout
        INY
        CPY    #&7F
        BNE    atablp
        JMP    osnewl
.ascout STY    temp+1
        PHA
        CMP    #&20
        BCC    ccod
        CMP    #&7F
        BCC    pasc
.ccod   LDA    #'.'
.pasc   JSR    oswrch
        LDA    #&20
        JSR    oswrch
        PLA
        PHA
        JSR    hexout
        LDA    #&20
        JSR    oswrch
        PLA
        JSR    decout
        LDA    #&20
        JSR    oswrch
        JSR    oswrch
        LDY    temp+1
        RTS

.sshow  JSR    geton
        BCC    sson
        LDA    #&00
        STA    ssflag
        RTS
.sson   LDA    #&01
        STA    ssflag
        RTS

.protct JSR    getfsp
        LDX    #&00
.copplp LDA    stbuff,X
        STA    fspbuf,X
        INX
        CMP    #&0D
        BNE    copplp
        JSR    getfsp

        LDA    #&83
        JSR    osbyte
        STX    oshwm
        STY    oshwm+1

        JSR    coppar
        LDA    #&FF
        LDX    #<parmem
        LDY    #>parmem
        JSR    osfile

        CLC
        LDA    oshwm
        ADC    parmem+&0A
        STA    memend
        LDA    oshwm+1
        ADC    parmem+&0B
        STA    memend+1

        JSR    isasci
        BCC    asci
        JSR    encrpt
        JSR    isasci
        BCC    sav
        LDX    #&08
        JMP    error

.asci   JSR    encrpt
.sav    LDA    oshwm
        STA    parmem+&0A
        LDA    oshwm+1
        STA    parmem+&0B
        LDA    memend
        STA    parmem+&0E
        LDA    memend+1
        STA    parmem+&0F
        LDA    #&00
        LDX    #<parmem
        LDY    #>parmem
        JMP    osfile

.isasci LDA    #&00
        STA    count
        STA    count+1
        LDA    oshwm
        STA    ptr
        LDA    oshwm+1
        STA    ptr+1
        LDY    #&00
.isaslp LDA    (ptr),Y
        BPL    noc1
        INC    count
        BNE    noc1
        INC    count+1
.noc1   INC    ptr
        BNE    noc2
        INC    ptr+1
.noc2   LDA    ptr
        CMP    memend
        BNE    isaslp
        LDA    ptr+1
        CMP    memend+1
        BNE    isaslp
        LSR    parmem+&0B
        ROR    parmem+&0A
        LSR    parmem+&0B
        ROR    parmem+&0A
        LSR    parmem+&0B
        ROR    parmem+&0A
        SEC
        LDA    count
        SBC    parmem+&0A
        LDA    count+1
        SBC    parmem+&0B
        RTS

.encrpt LDX    #&00
        STX    seed
        STX    seed+1
        STX    seed+2
        STX    seed+3
        STX    seed+4
.enclp1 LDA    stbuff,X
        CMP    #&0D
        BEQ    doencr
        SEC
        SBC    #&40
        LDY    #&05
.enclp2 ROR    A
        ROL    seed
        ROL    seed+1
        ROL    seed+2
        ROL    seed+3
        ROL    seed+4
        DEY
        BNE    enclp2
        INX
        BNE    enclp1
.doencr LDA    oshwm
        STA    ptr
        LDA    oshwm+1
        STA    ptr+1
.enclp3 JSR    rnd
        LDY    #&00
        EOR    (ptr),Y
        STA    (ptr),Y
        INC    ptr
        BNE    enoc1
        INC    ptr+1
.enoc1  LDA    ptr
        CMP    memend
        BNE    enclp3
        LDA    ptr+1
        CMP    memend+1
        BNE    enclp3
        RTS

.rnd    LDY    #&08
.rndlp  LDA    seed+2
        LSR    A
        LSR    A
        LSR    A
        EOR    seed+4
        ROR    A
        ROL    seed
        ROL    seed+1
        ROL    seed+2
        ROL    seed+3
        ROL    seed+4
        DEY
        BNE    rndlp
        RTS

.coppar LDX    #&11
.coplp  LDA    osfblk,X
        STA    parmem,X
        DEX
        BPL    coplp
        LDA    oshwm
        STA    parmem+&02
        LDA    oshwm+1
        STA    parmem+&03
        RTS

.osfblk EQUW   fspbuf
        EQUD   &00000000
        EQUD   &00000000
        EQUD   &00000000
        EQUD   &00000000

        IF     incmod

.ofline LDA    #&01
        STA    ddrb
        LDA    orirb
        AND    #&FE
        STA    orirb
        RTS

.online LDA    #&01
        STA    ddrb
        LDA    orirb
        ORA    #&01
        STA    orirb
        RTS

.dilend JMP    osnewl
.dilerr PHA
        JSR    ofline
        PLA
        CMP    #&0D
        BNE    bnerr
        LDX    #&01
        JMP    error
.bnerr  LDX    #&04
        JMP    error
.dial   DEY
.diallp INY
        LDA    (&F2),Y
        CMP    #&20
        BEQ    diallp
        CMP    #&30
        BCC    dilerr
        CMP    #&3A
        BCS    dilerr
        STY    temp+8
        JSR    mesage
        EQUS   "Dialling ... "
        EQUB   &00
        JSR    online
        LDX    #100
        JSR    ddelay
.dmloop LDY    temp+8
        LDA    (&F2),Y
        CMP    #&0D
        BEQ    dilend
        CMP    #&20
        BEQ    dpause
        CMP    #'-'
        BEQ    dpause
        CMP    #&30
        BCC    dilerr
        CMP    #&3A
        BCS    dilerr
        JSR    oswrch
        SEC
        SBC    #&30
        BNE    nota0
        LDA    #&0A
.nota0  STA    temp+1
.loop01 JSR    ofline
        LDX    #&03
        JSR    ddelay
        JSR    online
        LDX    #&02
        JSR    ddelay
        DEC    temp+1
        BNE    loop01
.dilinc LDX    #40
        JSR    ddelay
        INC    temp+8
        JMP    dmloop
.dpause JSR    oswrch
        LDX    #40
        JSR    ddelay
        JMP    dilinc
.tzero  LDX    #&04
        LDA    #&00
.tz     STA    temp+3,X
        DEX
        BPL    tz
        LDA    #&04
        LDX    #<(temp+3)
        LDY    #>(temp+3)
        JMP    osword
.ddelay STX    temp+2
.ddel   JSR    tzero
.dp1    JSR    esctst
        LDA    #&03
        LDX    #<(temp+3)
        LDY    #>(temp+3)
        JSR    osword
        LDA    temp+3
        CMP    #&02
        BNE    dp1
        DEC    temp+2
        BNE    ddel
        RTS

.carier JSR    tzero
        LDA    #&01
        STA    ddrb
.cloop  JSR    esctst
        LDA    orirb
        AND    #&02
        BEQ    cardet
        LDA    #&03
        LDX    #<(temp+3)
        LDY    #>(temp+3)
        JSR    osword
        LDA    temp+4
        CMP    #&08
        BCC    cloop
        LDX    #&05
        JMP    error
.cardet LDA    #&03
        LDX    #<(temp+3)
        LDY    #>(temp+3)
        JSR    osword
        CLC
        LDA    temp+3
        ADC    #100
        STA    temp
        LDA    temp+4
        ADC    #&00
        STA    temp+1
.cardlp JSR    esctst
        LDA    orirb
        AND    #&02
        BNE    cloop
        LDA    #&03
        LDX    #<(temp+3)
        LDY    #>(temp+3)
        JSR    osword
        SEC
        LDA    temp
        SBC    temp+3
        LDA    temp+1
        SBC    temp+4
        BCS    cardlp
        RTS

.answer LDA    #&01
        STA    ddrb
.anslp  JSR    esctst
        LDA    orirb
        AND    #&04
        BEQ    ansout
        LDA    #&81
        LDX    #&9F
        LDY    #&FF
        JSR    osbyte
        CPX    #&FF
        BNE    anslp
        JSR    osrdch
.ansout RTS

.esctst LDA    &FF
        BMI    epr
        RTS
.epr    LDA    #&7E
        JSR    osbyte
        JSR    ofline
        LDX    #&03
        JMP    error

.conect JSR    geton
        BCS    discon
        JSR    chint
        BCC    norevc
.reveci LDA    intvec
        STA    tintvc
        LDA    intvec+1
        STA    tintvc+1
        LDA    #&09
        STA    intvec
        LDA    #&FF
        STA    intvec+1
        LDA    #&A8
        LDX    #&00
        LDY    #&FF
        JSR    osbyte
        STX    temp
        STY    temp+1
        LDY    #&09
        LDA    #<nintvc
        STA    (temp),Y
        INY
        LDA    #>nintvc
        STA    (temp),Y
        INY
        LDA    &F4
        STA    (temp),Y
.norevc LDA    #&1E
        STA    pcr
        LDA    #&6F
        STA    ier
        LDA    #&90
        STA    ifr
        STA    ier
        CLI
        RTS

.discon SEI
        LDA    #&0E
        STA    pcr
        LDA    #&7F
        STA    ier
        JSR    chint
        BCS    disout
        LDA    tintvc
        STA    intvec
        LDA    tintvc+1
        STA    intvec+1
.disout CLI
        RTS

.nintvc LDA    &FC
        PHA
        TXA
        PHA
        TYA
        PHA
        LDA    ifr
        AND    #&90
        CMP    #&90
        BNE    ntours
        LDA    orirb
        JSR    discon
        LDX    #&06
        JMP    error
.ntours PLA
        TAY
        PLA
        TAX
        PLA
        STA    &FC
        JMP    (tintvc)

.chint  LDA    intvec
        CMP    #&09
        BNE    ddia
        LDA    intvec+1
        CMP    #&FF
        BNE    ddia
        CLC
        RTS
.ddia   SEC
        RTS

        ENDIF

        IF     incepr

.eprom  LDX    #&FF
        TXS
        LDA    #&03
        STA    brkvec
        LDA    #&FF
        STA    brkvec+1
        LDA    #&A8
        LDX    #&00
        LDY    #&FF
        JSR    osbyte
        STX    temp
        STY    temp+1
        LDY    #&03
        LDA    #<eperrh
        STA    (temp),Y
        INY
        LDA    #>eperrh
        STA    (temp),Y
        INY
        LDA    &F4
        STA    (temp),Y
        LDX    #&00
        STX    bufflo
        LDA    #&30
        STA    buffhi
        LDA    #&20
        STA    type
        JSR    setran
        LDA    #'0'
        STA    drv
        JSR    init
.olang1 JSR    screen
.getin  JSR    wind3
        LDX    #'A'
        LDY    #'J'
        JSR    choice
        BCS    escape
        SEC
        SBC    #&41
        ASL    A
        TAX
        LDA    opttab,X
        STA    temp
        LDA    opttab+1,X
        STA    temp+1
        JSR    wind1
        LDA    #&0C
        JSR    oswrch
        JSR    doit
.renter LDA    #&7E
        JSR    osbyte
        JSR    keyrel
        JMP    olang1
.doit   JMP    (temp)

.escape LDA    #&7E
        JSR    osbyte
        LDA    #&76
        JSR    osbyte
        TXA
        BPL    olang1
        JSR    mesage
        EQUB   &16, &07, &0A, &0A, &00
        LDA    #&BB
        LDX    #&00
        LDY    #&FF
        JSR    osbyte
        LDA    #&8E
        LDY    #&00
        JMP    osbyte

.eperrh LDX    #&FF
        TXS
        LDA    errpt
        STA    romlo
        LDA    errpt+1
        STA    romhi
        LDA    #&BA
        LDX    #&00
        LDY    #&FF
        JSR    osbyte
        STX    romno
        JSR    wind1
        JSR    mesage
        EQUB   &0C, &0A, &0A
        EQUS   "An error has occurred"
        EQUB   &0A, &0A, &0D, &00
.errlop INC    romlo
        BNE    errnc
        INC    romhi
.errnc  LDY    romno
        JSR    osrdrm
        CMP    #&00
        BEQ    errend
        JSR    oswrch
        JMP    errlop
.errend JSR    osnewl
        JSR    mpress
        JMP    renter

.seltyp JSR    mesage
        EQUB   &0A
        EQUS   "Select Eprom Type"
        EQUB   &0A, &0A, &0D
        EQUS   " (1) ... 2764  (8K)"
        EQUB   &0A, &0D
        EQUS   " (2) ... 27128 (16K)"
        EQUB   &0A, &0A, &0D, &00
        JSR    stocur
.sellp  LDX    #'1'
        LDY    #'2'
        JSR    choice
        BCS    selret
        CMP    #&31
        BEQ    sel64
        LDA    #&40
        BNE    sttype
.sel64  LDA    #&20
.sttype STA    type
        JSR    setran
        JSR    status
        JSR    rescur
        LDA    type
        CMP    #&20
        BEQ    pr64
        JSR    mesage
        EQUS   "27128"
        EQUB   &00
        JMP    prtexi
.pr64   JSR    mesage
        EQUS   "2764"
        EQUB   &00
.prtexi JSR    osnewl
        JSR    mpress
.selret RTS

.loddis JSR    setdrv
        JSR    wind1
        JSR    mesage
        EQUB   &0C, &0A
        EQUS   "Load Buffer from Disc"
        EQUB   &0A, &0A, &0D
        EQUS   "Enter Filename"
        EQUB   &0A, &0A, &0D
        EQUS   "<Return> for a catalogue"
        EQUB   &0A, &0D, &00
        JSR    stocur
        JSR    wind3
        JSR    mesage
        EQUB   &0C
        EQUS   " Filename or (Ret> : "
        EQUB   &00
.loddl  JSR    clrkbd
        LDA    #&00
        LDX    #<wrdpar
        LDY    #>wrdpar
        JSR    osword
        BCS    lodesc
        CPY    #&00
        BNE    load
        JSR    catalg
        BCS    lodesc
        JMP    loddis
.load   JSR    lpcopy
        LDA    #&FF
        LDX    #<parmem
        LDY    #>parmem
        JSR    osfile
        LDA    #&05
        LDX    #<parmem
        LDY    #>parmem
        JSR    osfile
        LDA    parmem+&0B
        CMP    #&21
        BCC    type20
        LDA    #&40
        BNE    ty20
.type20 LDA    #&20
.ty20   STA    type
        JSR    wind1
        JSR    rescur
        JSR    setran
        JSR    mpress
.lodesc RTS
.catalg JSR    wind4
        LDA    #&0C
        JSR    oswrch
        JSR    wind5
        JSR    docat
        JSR    press
        BCS    catesc
        JSR    screen
        CLC
.catesc RTS

.lodepr JSR    mesage
        EQUB   &0A
        EQUS   "Load Buffer from Eprom"
        EQUB   &0A, 00
        JSR    apress
        BCS    ldeout
        JSR    epcopy
        LDA    #&00
        STA    bits
        JSR    rd
        JSR    escpre
        BCS    ldeout
        JSR    mesage
        EQUB   &0A, &0D
        EQUS   "Buffer Loaded"
        EQUB   &0A, &0D, &00
        JSR    mpress
.ldeout RTS

.lodrom JSR    mesage
        EQUB   &0C, &0A
        EQUS   "Load buffer from Sideways ROM"
        EQUB   &0A, &0A, &0D
        EQUS   "After loading please ensure"
        EQUB   &0A, &0D
        EQUS   "ROM type is correctly set"
        EQUB   &0A, &0A, &0D
        EQUS   "Enter ROM ID"
        EQUB   &0A, &0A, &0D
        EQUS   "<Return> for a Romdump"
        EQUB   &0A, &0D, &00
        JSR    stocur
        JSR    wind3
        JSR    mesage
        EQUB   &0C
        EQUS   " Enter ROM ID (0-F) or <Ret> : "
        EQUB   &00
.lrlp   JSR    clrkbd
        JSR    osrdch
        BCS    lresc
        CMP    #&0D
        BEQ    romdum
        PHA
        JSR    hexcon
        PLA
        BCS    lrlp
        JSR    oswrch
        JSR    hexcon
        STA    temp+2
        LDA    bufflo
        STA    temp
        LDA    buffhi
        STA    temp+1
        LDA    #&00
        STA    romlo
        LDA    #&80
        STA    romhi
.lrlp1  LDY    temp+2
        JSR    osrdrm
        LDY    #&00
        STA    (temp),Y
        INC    temp
        INC    romlo
        BNE    lrlp1
        INC    temp+1
        INC    romhi
        LDA    romhi
        CMP    #&C0
        BNE    lrlp1
        JSR    wind1
        JSR    rescur
        JSR    mpress
.lresc  RTS
.romdum JSR    wind4
        LDA    #&0C
        JSR    oswrch
        JSR    wind5
        JSR    romdmp
        JSR    press
        BCS    lresc
        JSR    screen
        JMP    lodrom

.savdis JSR    setdrv
        JSR    wind1
        JSR    mesage
        EQUB   &0C, &0A
        EQUS   "Save Buffer onto Disc"
        EQUB   &0A, &0A, &0D
        EQUS   "Enter Filename"
        EQUB   &0A, &0A, &0D
        EQUS   "<Return> for a catalogue"
        EQUB   &0A, &0D, &00
        JSR    stocur
        JSR    wind3
        JSR    mesage
        EQUB   &0C
        EQUS   " Filename or <Ret> : "
        EQUB   &00
.savdl  JSR    clrkbd
        LDA    #&00
        LDX    #<wrdpar
        LDY    #>wrdpar
        JSR    osword
        BCS    savesc
        CPY    #&00
        BNE    save
        JSR    catalg
        BCS    savesc
        JMP    savdis
.save   JSR    spcopy
        LDA    #&00
        LDX    #<parmem
        LDY    #>parmem
        JSR    osfile
        JSR    wind1
        JSR    rescur
        JMP    mpress
.savesc RTS

.checlr JSR    mesage
        EQUB   &0A
        EQUS   "Check Eprom is Clear"
        EQUB   &0A, &00
        JSR    apress
        BCS    chlout
        JSR    epcopy
        LDA    #&02
        STA    bits
        JSR    rd
        JSR    escpre
        BCS    chlout
        JSR    mpress
.chlout RTS

.progrm JSR    mesage
        EQUB   &0A
        EQUS   "Program Eprom from Buffer"
        EQUB   &0A, &00
        JSR    apress
        BCS    preout
        JSR    wind6
        LDA    #&0C
        JSR    oswrch
        JSR    wind7
        JSR    epcopy
        JSR    prgrm
        JSR    escpre
        BCS    preout
        JSR    mpress
.preout RTS

.verify JSR    mesage
        EQUB   &0A
        EQUS   "Verify Eprom with Buffer"
        EQUB   &0A, &00
        JSR    apress
        BCS    vereot
        JSR    epcopy
        LDA    #&01
        STA    bits
        JSR    rd
        JSR    escpre
        BCS    vereot
        JSR    mpress
.vereot RTS

.editbf JSR    mesage
        EQUB   &0A
        EQUS   "Edit / Examine Buffer"
        EQUB   &0A, &0A, &0D
        EQUS   " (1) ... MZAP Buffer"
        EQUB   &0A, &0D
        EQUS   " (2) ... Fill Buffer with number"
        EQUB   &0A, &0A, &0D, &00
        JSR    stocur
        JSR    wind3
        LDX    #'1'
        LDY    #'2'
        JSR    choice
        BCS    edesc
        CMP    #'1'
        BEQ    emzapb
        CMP    #'2'
        BEQ    efillb
.edesc  RTS
.efillb JMP    fillb
.emzapb JMP    mzapb

.fillb  JSR    wind1
        JSR    rescur
        JSR    mesage
        EQUS   "Fill Buffer with Number"
        EQUB   &0A, &0A, &0D
        EQUS   "Enter Range and Value"
        EQUB   &0A, &0D, &00
        JSR    stocur
        JSR    wind3
        JSR    mesage
        EQUB   &0C
        EQUS   " Enter range : "
        EQUB   &00
        LDX    #ssss
        JSR    addgin
        BCC    fb2
.fb1    RTS
.fb2    LDA    #']'
        JSR    oswrch
        LDX    #eeee
        JSR    addgin
        BCS    fb1
        JSR    mesage
        EQUB   &0C
        EQUS   "Enter value to fill with : "
        EQUB   &00
        LDX    #mmmm
        JSR    bytgin
        BCS    fb1
        JSR    wind1
        JSR    rescur
        JSR    osnewl
        LDX    #ssss
        JSR    dhex
        LDA    #']'
        JSR    oswrch
        LDX    #eeee
        JSR    dhex
        LDA    #','
        JSR    oswrch
        LDA    mmmm
        JSR    hexout
        JSR    osnewl
        JSR    apress
        BCS    fb1
        CLC
        LDA    ssss
        ADC    bufflo
        STA    ssss
        LDA    ssss+1
        ADC    buffhi
        STA    ssss+1
        CLC
        LDA    eeee
        ADC    bufflo
        STA    eeee
        LDA    eeee+1
        ADC    buffhi
        STA    eeee+1
        LDY    #&00
.filllp LDA    mmmm
        STA    (ssss),Y
        INC    ssss
        BNE    filnc
        INC    ssss+1
.filnc  LDA    ssss+1
        CMP    eeee+1
        BCC    filllp
        BNE    filout
        LDA    ssss
        CMP    eeee
        BCC    filllp
        BEQ    filllp
.filout JMP    mpress

.mzapb  LDX    #&09
.mzaplp LDA    mzap,X
        STA    stbuff,X
        DEX
        BPL    mzaplp
        LDA    buffhi
        LDX    #&05
        JSR    addput
        LDA    bufflo
        JSR    addput
        LDX    #<stbuff
        LDY    #>stbuff
        JSR    oscli
        RTS

.selopt JSR    wind1
        JSR    mesage
        EQUB   &0A
        EQUS   "Select Options"
        EQUB   &0A, &0A, &0D
        EQUS   " (1) ... Change buffer address"
        EQUB   &0A, &0D
        EQUS   " (2) ... Change eprom range"
        EQUB   &0A, &0D
        EQUS   " (3) ... Change drive number"
        EQUB   &0A, &0A, &0D, &00
        JSR    stocur
        JSR    wind3
        LDX    #'1'
        LDY    #'3'
        JSR    choice
        BCS    selout
        PHA
        JSR    wind1
        JSR    rescur
        PLA
        CMP    #'1'
        BEQ    ccbuf
        CMP    #'2'
        BEQ    ccran
        CMP    #'3'
        BEQ    ccdrv
.selout RTS
.ccbuf  JMP    chbuf
.ccran  JMP    chran
.ccdrv  JMP    chdrv

.chbuf  JSR    mesage
        EQUS   "Enter Buffer Address"
        EQUB   &0A, &0D, &00
        JSR    stocur
        JSR    wind3
        JSR    mesage
        EQUB   &0C
        EQUS   " Buffer Address (1100-3C00) : "
        EQUB   &00
        LDX    #bufflo
        JSR    addgin
        JMP    soret

.chran  JSR    mesage
        EQUS   "Enter Eprom Range"
        EQUB   &0A, &0D, &00
        JSR    stocur
        JSR    wind3
        JSR    mesage
        EQUB   &0C
        EQUS   " Eprom Range : "
        EQUB   &00
        LDX    #erablo
        JSR    addgin
        BCS    chresc
        LDA    #']'
        JSR    oswrch
        LDX    #eratlo
        JSR    addgin
        JMP    soret
.chresc RTS

.chdrv  JSR    mesage
        EQUS   "Enter Drive Number"
        EQUB   &0A, &0D, &00
        JSR    stocur
        JSR    wind3
        JSR    mesage
        EQUB   &0C
        EQUS   " Drive (0-3) : "
        EQUB   &00
.drive  JSR    osrdch
        BCS    drvout
        CMP    #&30
        BCC    drive
        CMP    #&34
        BCS    drive
        STA    drv
        JSR    oswrch
        JMP    soret
.drvout RTS

.soret  JSR    status
        JSR    wind1
        JSR    rescur
        JMP    mpress

.setran LDA    #&00
        STA    erablo
        STA    erabhi
        LDA    #&FF
        STA    eratlo
        LDA    type
        SEC
        SBC    #&01
        STA    erathi
        RTS

.screen LDA    #&13
        JSR    osbyte
        LDA    #&16
        JSR    oswrch
        LDA    #&07
        JSR    oswrch
        LDX    #&00
.sclp   LDA    eprscr+&000,X
        STA    &7C00,X
        LDA    eprscr+&100,X
        STA    &7D00,X
        LDA    eprscr+&200,X
        STA    &7E00,X
        LDA    eprscr+&300,X
        STA    &7F00,X
        INX
        BNE    sclp
        JSR    status
        RTS

.wind1  LDX    #&00
        BEQ    wind
.wind2  LDX    #&04
        BNE    wind
.wind3  LDX    #&08
        BNE    wind
.wind4  LDX    #&0C
        BNE    wind
.wind5  LDX    #&10
        BNE    wind
.wind6  LDX    #&14
        BNE    wind
.wind7  LDA    #&18
.wind   LDA    #&1C
        JSR    oswrch
        LDY    #&04
.wilp   LDA    wintab,X
        JSR    oswrch
        INX
        DEY
        BNE    wilp
        RTS

.status JSR    wind2
        JSR    mesage
        EQUS   " B       R    ]       E       D"
        EQUB   &00
        LDX    #&02
        JSR    newtab
        LDX    #bufflo
        JSR    dhex
        LDX    #&0A
        JSR    newtab
        LDX    #erablo
        JSR    dhex
        LDX    #&0F
        JSR    newtab
        LDX    #eratlo
        JSR    dhex
        LDX    #&17
        JSR    newtab
        LDA    type
        CMP    #&20
        BNE    E27128
        JSR    mesage
        EQUS   "2764"
        EQUB   &00
        JMP    stadr
.E27128 JSR    mesage
        EQUS   "27128"
        EQUB   &00
.stadr  LDX    #&1F
        JSR    newtab
        LDA    drv
        JSR    oswrch
        JMP    wind1

.newtab LDA    #&1F
        JSR    oswrch
        TXA
        JSR    oswrch
        LDA    #&00
        JMP    oswrch

.choice STX    temp+2
        STY    temp+3
        JSR    wind3
        JSR    mesage
        EQUB   &0C
        EQUS   " Enter Choice ("
        EQUB   &00
        LDA    temp+2
        JSR    oswrch
        LDA    #'-'
        JSR    oswrch
        LDA    temp+3
        JSR    oswrch
        JSR    mesage
        EQUS   ") : "
        EQUB   &00
.clp    JSR    clrkbd
        JSR    osrdch
        BCS    chesc
        CMP    #'*'
        BEQ    star
        CMP    temp+2
        BCC    clp
        CMP    temp+3
        BEQ    cret
        BCS    clp
.cret   JSR    oswrch
        PHA
        JSR    keyrel
        PLA
        CLC
        RTS
.chesc  JSR    keyrel
        SEC
        RTS
.star   JSR    mesage
        EQUS   " *"
        EQUB   &00
        LDA    #&00
        LDX    #<wrdpar
        LDY    #>wrdpar
        JSR    osword
        JSR    wind4
        LDA    #&0C
        JSR    oswrch
        JSR    wind5
        LDX    #<stbuff
        LDY    #>stbuff
        JSR    oscli
        JSR    mpress
        SEC
        RTS

.mpress JSR    mesage
        EQUB   &0A, &0D
        EQUS   "Press any key for menu"
        EQUB   &00
        JMP    pr1
.press  JSR    mesage
        EQUB   &0A, &0D
        EQUS   "Press any key to continue"
        EQUB   &00
.pr1    JSR    wind3
        JSR    mesage
        EQUB   &0C
        EQUS   " Press any key"
        EQUB   &00
        JSR    clrkbd
        JSR    osrdch
        RTS

.apress JSR    mesage
        EQUB   &0A, &0D
        EQUS   "Press <space>  to continue"
        EQUB   &0A, &0D
        EQUS   "      <Escape> to abort"
        EQUB   &0A, &0D, &00
        JSR    stocur
        JSR    wind3
        JSR    mesage
        EQUB   &0C
        EQUS   " Press <Spc> or <Esc> : "
        EQUB   &00
.ap1g   JSR    clrkbd
        JSR    osrdch
        CMP    #&20
        BEQ    aplp1
        CMP    #&1B
        BNE    ap1g
        SEC
        RTS
.aplp1  LDA    #&0C
        JSR    oswrch
        JSR    wind1
        JSR    rescur
        CLC
        RTS

.stocur LDA    #&86
        JSR    osbyte
        STX    oldx
        STY    oldy
        RTS

.rescur LDA    #&1F
        JSR    oswrch
        LDA    oldx
        JSR    oswrch
        LDA    oldy
        JSR    oswrch
        RTS

.dhex   LDA    &01,X
        JSR    hexout
        LDA    &00,X
        JMP    hexout

.docat  LDX    #&03
.catlop LDA    cat,X
        STA    stbuff,X
        DEX
        BPL    catlop
        LDX    #<stbuff
        LDY    #>stbuff
        JMP    oscli

.setdrv LDX    #&07
.drlp   LDA    drve,X
        STA    stbuff,X
        DEX
        BPL    drlp
        LDA    drv
        STA    stbuff+6
        LDX    #<stbuff
        LDY    #>stbuff
        JMP    oscli

.addput PHA
        LSR    A
        LSR    A
        LSR    A
        LSR    A
        JSR    add1
        PLA
.add1   AND    #&0F
        ORA    #&30
        CMP    #&3A
        BCC    add2
        ADC    #&06
.add2   STA    stbuff,X
        INX
        RTS

.bytgin LDY    #&02
        BNE    addhin
.addgin LDY    #&04
.addhin LDA    #&00
        STA    temp
        STA    temp+1
.addglp JSR    osrdch
        BCS    addout
        PHA
        JSR    hexcon
        PLA
        BCS    addglp
        JSR    oswrch
        JSR    hexcon
        ASL    A
        ASL    A
        ASL    A
        ASL    A
        ASL    A
        ROL    temp
        ROL    temp+1
        ASL    A
        ROL    temp
        ROL    temp+1
        ASL    A
        ROL    temp
        ROL    temp+1
        ASL    A
        ROL    temp
        ROL    temp+1
        DEY
        BNE    addglp
        LDA    temp
        STA    &00,X
        LDA    temp+1
        STA    &01,X
        CLC
        RTS
.addout SEC
        RTS

.lpcopy LDX    #&12
.lplp   LDA    ldpara,X
        STA    parmem,X
        DEX
        BPL    lplp
        LDA    bufflo
        STA    parmem+2
        LDA    buffhi
        STA    parmem+3
        RTS

.spcopy LDX    #&12
.splp   LDA    sapara,X
        STA    parmem,X
        DEX
        BPL    splp
        LDA    bufflo
        STA    parmem+10
        STA    parmem+14
        LDA    buffhi
        STA    parmem+11
        CLC
        ADC    type
        STA    parmem+15
        RTS

.init   LDA    #&00
        JSR    latch
        LDA    #&00
        STA    &FE62
        RTS

.epcopy LDA    erablo
        STA    ssss
        LDA    erabhi
        STA    ssss+1
        LDA    eratlo
        STA    eeee
        LDA    erathi
        STA    eeee+1
        CLC
        LDA    bufflo
        ADC    erablo
        STA    mmmm
        LDA    buffhi
        ADC    erabhi
        STA    mmmm+1
        RTS

.escpre LDA    &FF
        BPL    nobpre
        LDA    #&7E
        JSR    osbyte
        JSR    mesage
        EQUB   &0A, &0D
        EQUS   "You pressed Escape"
        EQUB   &0A, &0D, &00
        JSR    mpress
        SEC
        RTS
.nobpre CLC
        RTS

.rd     STA    bits
        LDA    #&00
        STA    nerrs
        JSR    skpbeg
.r1     LDA    #&10
        JSR    latch
        LDA    #&00
        STA    &FE62
        LDA    bits
        CMP    #&01
        BEQ    ver
        CMP    #&02
        BEQ    clr
        LDY    #&00
        LDA    &FE60
        STA    (mmmm),Y
        JMP    rina
.ver    LDY    #&00
        LDA    &FE60
        CMP    (mmmm),Y
        BEQ    rina
        JSR    nogo
        JMP    rina
.clr    LDA    &FE60
        CMP    #&FF
        BEQ    rina
        JSR    nogo
.rina   LDA    #&52
        JSR    latch
        LDA    &FF
        BMI    rout
        JSR    inadd
        BCC    r1
        LDA    nerrs
        BNE    rout
        LDA    bits
        BEQ    rout
        CMP    #&01
        BNE    ecmes0
        JSR    mesage
        EQUB   &0A, &0D
        EQUS   "Eprom has been Verified"
        EQUB   &0A, &0D, &00
        RTS
.ecmes0 JSR    mesage
        EQUB   &0A, &0D
        EQUS   "Eprom is Clear"
        EQUB   &0A, &0D, &00
.rout   RTS

.nogo   LDA    nerrs
        BNE    nogo1
        JSR    osnewl
.nogo1  INC    nerrs
        LDA    bits
        CMP    #&01
        BNE    ecmes1
        JSR    mesage
        EQUS   "Verify error at "
        EQUB   &00
        JMP    nogo2
.ecmes1 JSR    mesage
        EQUS   "Eprom not clear at "
        EQUB   &00
.nogo2  LDA    ssss+1
        JSR    hexout
        LDA    ssss
        JSR    hexout
        LDA    #&20
        JSR    oswrch
        LDA    &FE60
        JSR    hexout
        LDA    bits
        CMP    #&02
        BEQ    ngret
        LDA    #&20
        JSR    oswrch
        LDY    #&00
        LDA    (mmmm),Y
        JSR    hexout
.ngret  JMP    osnewl

.prgrm  JSR    tinit
        JSR    skpbeg
        LDA    #&C8
        JSR    latch
        LDA    #129
        LDX    #70
        LDY    #0
        JSR    osbyte
        SEI
        LDA    #&CE
        STA    &FE6C
.bu     JSR    adout
        LDY    #&00
        LDA    (mmmm),Y
        LDX    #&00
        LDY    #&08
.bu1    ASL    A
        BCS    bu2
        INX
.bu2    DEY
        BNE    bu1
        CPX    #&00
        BEQ    bu5
.bu3    LDY    #&20
.bu3a   NOP
        DEY
        BNE    bu3a
        LDA    #&D8
        JSR    latch
        LDY    #&00
        LDA    (mmmm),Y
        STA    &FE60
        LDA    #&10
.bu4    BIT    &FE6D
        BEQ    bu4
        NOP
        NOP
        DEX
        BEQ    bu5
        LDA    #&C8
        JSR    latch
        JMP    bu3
.bu5    LDA    #&CE
        STA    &FE6C
        LDA    #&C8
        JSR    latch
        LDA    #&C2
        JSR    latch
        CLI
        LDA    &FF
        BMI    bu6
        SEI
        JSR    inadd
        BCC    bu
        LDA    ssss
        AND    #&07
        BEQ    bu6
        JSR    ado1
.bu6    CLI
        LDA    #&50
        JSR    latch
        RTS

.adout  LDA    ssss
        AND    #&07
        TAX
        LDY    #&00
        LDA    (mmmm),Y
        STA    stbuff,X
        CPX    #&07
        BEQ    ado1
        RTS
.ado1   LDA    ssss+1
        JSR    hexout
        LDA    ssss
        AND    #&F8
        JSR    hexout
        LDA    #&20
        JSR    oswrch
        LDX    #&00
.ado2   LDA    stbuff,X
        JSR    hexout
        LDA    #&20
        JSR    oswrch
        INX
        CPX    #&08
        BNE    ado2
        LDX    #&00
.ado3   LDA    stbuff,X
        JSR    charot
        INX
        CPX    #&08
        BNE    ado3
        JSR    tinit
        JMP    osnewl
.charot CMP    #&20
        BCC    dot
        CMP    #&7F
        BCS    dot
        JMP    oswrch
.dot    LDA    #'.'
        JMP    oswrch
.tinit  LDX    #&07
        LDA    #&00
.tinlp  STA    stbuff,X
        DEX
        BPL    tinlp
        RTS

.inadd  INC    ssss
        BNE    in1
        INC    ssss+1
.in1    INC    mmmm
        BNE    in2
        INC    mmmm+1
.in2    LDA    ssss+1
        CMP    eeee+1
        BCC    in5
        BNE    in4
        LDA    ssss
        CMP    eeee
        BCC    in5
        BEQ    in5
.in4    SEC
        RTS
.in5    CLC
        RTS

.latch  STA    ltemp
        LDA    #&FF
        STA    &FE62
        LDA    ssss+1
        AND    #&10
        LSR    A
        LSR    A
        LSR    A
        LSR    A
        ORA    ltemp
        STA    ltemp
        LDA    ssss+1
        AND    #&20
        ORA    ltemp
        STA    &FE60
        LDA    #&DE
        STA    &FE6C
        LDA    #&FE
        STA    &FE6C
        RTS
.skpbeg LDA    #&50
        JSR    latch
        LDA    #&54
        JSR    latch
        LDA    #&50
        JSR    latch
        LDA    ssss
        ORA    ssss+1
        BEQ    skpret
        LDA    #&00
        STA    temp
        STA    temp+1
.skplp  LDA    #&52
        JSR    latch
        LDA    #&50
        JSR    latch
        INC    temp
        BNE    skpnc
        INC    temp+1
.skpnc  LDA    temp
        CMP    ssss
        BNE    skplp
        LDA    temp+1
        CMP    ssss+1
        BNE    skplp
.skpret RTS


.opttab EQUW   seltyp
        EQUW   loddis
        EQUW   lodepr
        EQUW   lodrom
        EQUW   savdis
        EQUW   checlr
        EQUW   progrm
        EQUW   verify
        EQUW   editbf
        EQUW   selopt

.wintab EQUB   3
        EQUB   19
        EQUB   36
        EQUB   4
        EQUB   3
        EQUB   21
        EQUB   38
        EQUB   21
        EQUB   3
        EQUB   23
        EQUB   38
        EQUB   23
        EQUB   0
        EQUB   21
        EQUB   39
        EQUB   4
        EQUB   1
        EQUB   21
        EQUB   39
        EQUB   4
        EQUB   0
        EQUB   19
        EQUB   39
        EQUB   4
        EQUB   1
        EQUB   18
        EQUB   39
        EQUB   5

.wrdpar EQUW   stbuff
        EQUB   &20
        EQUB   &20
        EQUB   &7F

.ldpara EQUW   stbuff
        EQUD   &00000000
        EQUD   &00000000
        EQUD   &00000000
        EQUD   &00000000

.sapara EQUW   stbuff
        EQUD   &00008000
        EQUD   &00008000
        EQUD   &00000000
        EQUD   &00000000

.cat    EQUS   "CAT"
        EQUB   &0D
.mzap   EQUS   "MZAP 3000"
        EQUB   &0D
.drve   EQUS   "DRIVE 0"
        EQUB   &0D

.eprscr EQUB   &94, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3
        EQUB   &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &20
        EQUB   &86, &9D, &84, &8D, &20, &20, &20, &20, &20, &20, &20, &20, &45, &50, &52, &4F, &4D, &20, &50, &72
        EQUB   &6F, &67, &72, &61, &6D, &6D, &65, &72, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &9C
        EQUB   &86, &9D, &84, &8D, &20, &20, &20, &20, &20, &20, &20, &20, &45, &50, &52, &4F, &4D, &20, &50, &72
        EQUB   &6F, &67, &72, &61, &6D, &6D, &65, &72, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &9C
        EQUB   &94, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3
        EQUB   &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &20
        EQUB   &94, &B5, &87, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20
        EQUB   &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &28, &41, &29, &20, &2E, &2E, &2E, &20, &53, &65, &6C, &65, &63, &74, &20, &45
        EQUB   &70, &72, &6F, &6D, &20, &74, &79, &70, &65, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20
        EQUB   &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &28, &42, &29, &20, &2E, &2E, &2E, &20, &4C, &6F, &61, &64, &20, &66, &72, &6F
        EQUB   &6D, &20, &44, &69, &73, &6B, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &28, &43, &29, &20, &2E, &2E, &2E, &20, &4C, &6F, &61, &64, &20, &66, &72, &6F
        EQUB   &6D, &20, &45, &70, &72, &6F, &6D, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &28, &44, &29, &20, &2E, &2E, &2E, &20, &4C, &6F, &61, &64, &20, &66, &72, &6F
        EQUB   &6D, &20, &53, &69, &64, &65, &77, &61, &79, &73, &20, &52, &6F, &6D, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20
        EQUB   &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &28, &45, &29, &20, &2E, &2E, &2E, &20, &53, &61, &76, &65, &20, &6F, &6E, &74
        EQUB   &6F, &20, &44, &69, &73, &6B, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20
        EQUB   &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &28, &46, &29, &20, &2E, &2E, &2E, &20, &43, &68, &65, &63, &6B, &20, &20, &20
        EQUB   &45, &70, &72, &6F, &6D, &20, &69, &73, &20, &63, &6C, &65, &61, &72, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &28, &47, &29, &20, &2E, &2E, &2E, &20, &50, &72, &6F, &67, &72, &61, &6D, &20
        EQUB   &45, &70, &72, &6F, &6D, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &28, &48, &29, &20, &2E, &2E, &2E, &20, &56, &65, &72, &69, &66, &79, &20, &20
        EQUB   &45, &70, &72, &6F, &6D, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20
        EQUB   &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &28, &49, &29, &20, &2E, &2E, &2E, &20, &45, &78, &61, &6D, &69, &6E, &65, &20
        EQUB   &2F, &20, &45, &64, &69, &74, &20, &62, &75, &66, &66, &65, &72, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &28, &4A, &29, &20, &2E, &2E, &2E, &20, &53, &65, &6C, &65, &63, &74, &20, &73
        EQUB   &70, &65, &63, &69, &61, &6C, &20, &6F, &70, &74, &69, &6F, &6E, &73, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &B5, &87, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20
        EQUB   &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &EA, &20
        EQUB   &94, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3
        EQUB   &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &20
        EQUB   &86, &9D, &84, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20
        EQUB   &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &94, &20, &9C
        EQUB   &94, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3
        EQUB   &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &20
        EQUB   &86, &9D, &84, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20
        EQUB   &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &20, &9C
        EQUB   &94, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3
        EQUB   &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &F3, &20

        ENDIF

.romend

        SAVE   romst, romend
