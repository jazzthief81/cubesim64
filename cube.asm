clrcube	ldx #0
clrcbl	lda #WHITE
	sta U,x
	lda #YELLOW
	sta D,x
	lda #GREEN
	sta F,x
	lda #BLUE
	sta B,x
	lda #RED
	sta R,x
	lda #ORANGE
	sta L,x
	cpx #8
	beq clrcbe
	inx
	jmp clrcbl
clrcbe	rts

chkslv	ldx #0
chkslvl	lda U,x
	cmp U+5
	bne notslvd
	lda D,x
        cmp D+5
        bne notslvd
        lda F,x
        cmp F+5
        bne notslvd
        lda B,x
        cmp B+5
        bne notslvd
        lda R,x
        cmp R+5
        bne notslvd
        lda L,x
        cmp L+5
        bne notslvd
        cpx #8
        beq slvd
        inx
        jmp chkslvl
slvd	lda #1
        rts
notslvd lda #0
        rts

        ; outer layer moves

moveu   lda #5
	ldx <#moveut
	ldy >#moveut
	jsr perm
	jmp setmov

moveui  lda #5
	ldx <#moveuit
	ldy >#moveuit
	jsr perm
	jmp setmov

moveu2  jsr moveu
	jmp moveu

movef   lda #5
	ldx <#moveft
	ldy >#moveft
	jsr perm
	jmp setmov

movefi  lda #5
	ldx <#movefit
	ldy >#movefit
	jsr perm
	jmp setmov

movef2  jsr movef
	jmp movef

mover   lda #5
	ldx <#movert
	ldy >#movert
	jsr perm
	jmp setmov

moveri  lda #5
	ldx <#moverit
	ldy >#moverit
	jsr perm
	jmp setmov

mover2  jsr mover
	jmp mover
                 
moved   lda #5
	ldx <#movedt
	ldy >#movedt
	jsr perm
	jmp setmov

movedi  lda #5
	ldx <#movedit
	ldy >#movedit
	jsr perm
	jmp setmov

moved2  jsr moved
	jmp moved

moveb   lda #5
	ldx <#movebt
	ldy >#movebt
	jsr perm
	jmp setmov

movebi  lda #5
	ldx <#movebit
	ldy >#movebit
	jsr perm
	jmp setmov

moveb2  jsr moveb
	jmp moveb

movel   lda #5
	ldx <#movelt
	ldy >#movelt
	jsr perm
	jmp setmov

moveli  lda #5
	ldx <#movelit
	ldy >#movelit
	jsr perm
	jmp setmov

movel2  jsr movel
	jmp movel

	; slice moves

movem   lda #3
	ldx <#movemt
	ldy >#movemt
	jsr perm
	jmp setmov

movemi  lda #3
	ldx <#movemit
	ldy >#movemit
	jsr perm
	jmp setmov

movem2  jsr movem
	jmp movem

movee   lda #3
	ldx <#moveet
	ldy >#moveet
	jsr perm
	jmp setmov

moveei  lda #3
	ldx <#moveeit
	ldy >#moveeit
	jsr perm
	jmp setmov

movee2  jsr movee
	jmp movee

moves   lda #3
	ldx <#movest
	ldy >#movest
	jsr perm
	jmp setmov

movesi  lda #3
	ldx <#movesit
	ldy >#movesit
	jsr perm
	jmp setmov

moves2  jsr moves
	jmp moves

	; double layer moves

move2r  jsr mover
	jmp movemi

move2ri jsr moveri
	jmp movem

move2f	jsr movef
	jmp moves

move2fi	jsr movefi
	jmp movesi

move2u	jsr moveu
	jmp moveei

move2ui	jsr moveui
	jmp movee

move2l	jsr movel
	jmp movem

move2li	jsr moveli
	jmp movemi

move2b	jsr moveb
	jmp movesi

move2bi	jsr movebi
	jmp moves

move2d	jsr moved
	jmp movee

move2di	jsr movedi
	jmp moveei

	; cube rotations

movex	jsr mover
	jsr movemi
	jsr moveli
	jmp clrmov

movexi	jsr moveri
	jsr movem
	jsr movel
	jmp clrmov

movex2	jsr mover2
	jsr movem2
	jsr movel2
	jmp clrmov

movey	jsr moveu
	jsr moveei
	jsr movedi
	jmp clrmov

moveyi	jsr moveui
	jsr movee
	jsr moved
	jmp clrmov

movey2	jsr moveu2
	jsr movee2
	jsr moved2
	jmp clrmov

movez	jsr movef
	jsr moves
	jsr movebi
	jmp clrmov

movezi	jsr movefi
	jsr movesi
	jsr moveb
	jmp clrmov

movez2	jsr movef2
	jsr moves2
	jsr moveb2
	jmp clrmov

perm	sta $fc
        stx $fd
        sty $fe
        ldy #0
perml	lda ($fd),y
	tax
	lda 0,x
	pha
	iny
	iny
	iny
	lda ($fd),y
	tax
	lda 0,x
	pha
	dey
	dey
	dey
        lda ($fd),y
        tax
        pla
        sta 0,x
        iny
        iny
	lda ($fd),y
	tax
	lda 0,x
	pha
        iny
        lda ($fd),y
        tax
        pla
        sta 0,x
        dey
        dey
	lda ($fd),y
	tax
	lda 0,x
	pha
        iny
        lda ($fd),y
        tax
        pla
        sta 0,x
        dey
        lda ($fd),y
        tax
        pla
        sta 0,x

        dec $fc
        beq permend
        iny
        iny
        iny
        jmp perml

permend rts

setmov	lda #1
	sta CUB_MVD
	rts

clrmov	lda #0
	sta CUB_MVD
	rts

moveut	dc.b UL,UB,UR,UF
	dc.b LU,BU,RU,FU
	dc.b ULB,UBR,URF,UFL
	dc.b LBU,BRU,RFU,FLU
	dc.b BUL,RUB,FUR,LUF

moveuit	dc.b UR,UB,UL,UF
	dc.b RU,BU,LU,FU
	dc.b URF,UBR,ULB,UFL
	dc.b RFU,BRU,LBU,FLU
	dc.b FUR,RUB,BUL,LUF

moveft	dc.b FU,FR,FD,FL
	dc.b UF,RF,DF,LF
	dc.b FUR,FRD,FDL,FLU
	dc.b URF,RDF,DLF,LUF
	dc.b RFU,DFR,LFD,UFL

movefit	dc.b FU,FL,FD,FR
	dc.b UF,LF,DF,RF
	dc.b FUR,FLU,FDL,FRD
	dc.b URF,LUF,DLF,RDF
	dc.b RFU,UFL,LFD,DFR

movert	dc.b RF,RU,RB,RD
	dc.b FR,UR,BR,DR
	dc.b RFU,RUB,RBD,RDF
	dc.b FUR,UBR,BDR,DFR
	dc.b URF,BRU,DRB,FRD

moverit	dc.b RF,RD,RB,RU
	dc.b FR,DR,BR,UR
	dc.b RFU,RDF,RBD,RUB
	dc.b FUR,DFR,BDR,UBR
	dc.b URF,FRD,DRB,BRU

movedt	dc.b DR,DB,DL,DF
	dc.b RD,BD,LD,FD
	dc.b DFR,DRB,DBL,DLF
	dc.b FRD,RBD,BLD,LFD
	dc.b RDF,BDR,LDB,FDL

movedit	dc.b DL,DB,DR,DF
	dc.b LD,BD,RD,FD
	dc.b DBL,DRB,DFR,DLF
	dc.b BLD,RBD,FRD,LFD
	dc.b LDB,BDR,RDF,FDL

movebt	dc.b BU,BL,BD,BR
	dc.b UB,LB,DB,RB
	dc.b BRU,BUL,BLD,BDR
	dc.b RUB,ULB,LDB,DRB
	dc.b UBR,LBU,DBL,RBD

movebit	dc.b BU,BR,BD,BL
	dc.b UB,RB,DB,LB
	dc.b BRU,BDR,BLD,BUL
	dc.b RUB,DRB,LDB,ULB
	dc.b UBR,RBD,DBL,LBU

movelt	dc.b LF,LD,LB,LU
	dc.b FL,DL,BL,UL
	dc.b LUF,LFD,LDB,LBU
	dc.b UFL,FDL,DBL,BUL
	dc.b FLU,DLF,BLD,ULB

movelit	dc.b LF,LU,LB,LD
	dc.b FL,UL,BL,DL
	dc.b LUF,LBU,LDB,LFD
	dc.b UFL,BUL,DBL,FDL
	dc.b FLU,ULB,BLD,DLF

movemt  dc.b UF,FD,DB,BU
        dc.b FU,DF,BD,UB
        dc.b F,D,B,U

movemit dc.b UF,BU,DB,FD
        dc.b FU,UB,BD,DF
        dc.b F,U,B,D

moveet  dc.b FR,RB,BL,LF
        dc.b RF,BR,LB,FL
        dc.b F,R,B,L

moveeit dc.b FR,LF,BL,RB
	dc.b RF,FL,LB,BR
	dc.b F,L,B,R

movest  dc.b UR,RD,DL,LU
	dc.b RU,DR,LD,UL
	dc.b U,R,D,L

movesit dc.b UR,LU,DL,RD
	dc.b RU,UL,LD,DR
	dc.b U,L,D,R
