hndlkey	lda #0       ; check for shift down
        sta LSHIFT
        sta RSHIFT
        sta SHIFT
	lda TOPROW1
	and #%10000000
        cmp #0
        bne chkrshf
	lda #1
	sta LSHIFT
	sta SHIFT
chkrshf lda TOPROW6
        and #%00010000
      	cmp #0
      	bne endshf
	lda #1
	sta RSHIFT
	sta SHIFT
endshf	lda STATE    ; delegate to handler depending on current state
 	cmp #FREE_ST
	bne *+5
	jmp keyfree
 	cmp #PREI_ST
	bne *+5
	jmp keyprei
 	cmp #SOLV_ST
	bne *+5
	jmp keysolv
	rts

keyfree lda #0
        sta CUB_MVD
        jsr keyfunc
	lda CUB_MVD
	beq keyfren
	jsr clrtime
keyfren	rts

keyprei lda #0
	sta CUB_MVD
	jsr keyfunc
        lda CUB_MVD
        beq notmvd
        jsr gotoslv
        jsr chkslv
        beq notmvd
        lda #1
        sta CUB_SLV
        jmp addresl
notmvd  rts

keysolv lda #0
	sta CUB_MVD
	jsr keyfunc
        lda CUB_MVD
        beq notmvds
        jsr chkslv
        beq notmvds
        lda #1
        sta CUB_SLV
        jsr addresl
        jmp gotofre
notmvds rts

gotoslv	lda #SOLV_ST ; transition to solve state
	sta STATE
	lda #0       ; reset clock
	sta INT_CLL
	sta INT_CLH
	sta NXT_SKP
	sta TIM_HDT
	sta TIM_TNT
	sta TIM_SEC
	sta TIM_TSC
	sta TIM_MIN
	rts

keyfunc lda TOPROW0
	eor #$ff
	and LSTROW0
	cmp #0
	beq nofunc
	sta CURROW
        and #%00010000
        bne resetcb
	lda CURROW
        and #%00100000
        bne gotoscr
        rts
nofunc  jmp keymvc

resetcb jsr clrcube
	jsr clrtime
	lda STATE
	cmp #SOLV_ST
	beq resetar
	cmp #PREI_ST
	bne resetce
resetar	lda #0
	sta CUB_SLV
	jsr addresl
resetce	jmp gotofre

addresl	jsr prctimh
	jsr updstat
	jsr prltime
	rts

gotofre	lda #FREE_ST ; transition to solve state
	sta STATE
	rts

rescram	lda STATE
	cmp #FREE_ST
        bne norescr
        jsr noreslt
norescr	rts

gotoscr	lda STATE
	cmp #SOLV_ST
	beq scrar
	cmp #PREI_ST
	bne noreslt
scrar	lda #0
	sta CUB_SLV
	jsr addresl
noreslt	lda #SCRM_ST ; transition to scramble state
	sta STATE
	lda #75
	sta SCR_MVS
	lda #4
	sta SCR_CTD
	jsr clrtime
	rts

keymvc	lda #0
	sta KEY_CNT
	lda SHIFT
	beq keyunsh
       	jmp keyshf

keyunsh
keyrow1 lda TOPROW1
	eor #$ff
	and LSTROW1
	cmp #0
	beq keyrow2
	sta CURROW
	and #%00000001
	beq *+5
	jsr key3
	lda CURROW
	and #%00000010
	beq *+5
	jsr keyw
	lda CURROW
	and #%00000100
	beq *+5
	jsr keya
	lda CURROW
	and #%00001000
	beq *+5
	jsr key4
	lda CURROW
	and #%00010000
	beq *+5
	jsr keyz
	lda CURROW
	and #%00100000
	beq *+5
	jsr keys
	lda CURROW
	and #%01000000
	beq *+5
	jsr keye

keyrow2 lda TOPROW2
        eor #$ff
        and LSTROW2
        cmp #0
        beq keyrow3
	sta CURROW
	and #%00000001
	beq *+5
	jsr key5
	lda CURROW
	and #%00000010
	beq *+5
	jsr keyr
	lda CURROW
	and #%00000100
	beq *+5
	jsr keyd
	lda CURROW
	and #%00001000
	beq *+5
	jsr key6
	lda CURROW
	and #%00010000
	beq *+5
	jsr keyc
	lda CURROW
	and #%00100000
	beq *+5
	jsr keyf
	lda CURROW
	and #%01000000
	beq *+5
	jsr keyt
	lda CURROW
	and #%10000000
	beq *+5
	jsr keyx

keyrow3 lda TOPROW3
	eor #$ff
	and LSTROW3
	cmp #0
	beq keyrow4
	sta CURROW
	and #%00000001
	beq *+5
	jsr key7
	lda CURROW
	and #%00000010
	beq *+5
	jsr keyy
	lda CURROW
	and #%00000100
	beq *+5
	jsr keyg
	lda CURROW
	and #%00001000
	beq *+5
	jsr key8
	lda CURROW
	and #%00010000
	beq *+5
	jsr keyb
	lda CURROW
	and #%00100000
	beq *+5
	jsr keyh
	lda CURROW
	and #%01000000
	beq *+5
	jsr keyu
	lda CURROW
	and #%10000000
	beq *+5
	jsr keyv

keyrow4	lda TOPROW4
	eor #$ff
	and LSTROW4
	cmp #0
	beq keyrow5
	sta CURROW
	and #%00000001
	beq *+5
	jsr key9
	lda CURROW
	and #%00000010
	beq *+5
	jsr keyi
	lda CURROW
	and #%00000100
	beq *+5
	jsr keyj
	lda CURROW
	and #%00001000
	beq *+5
	jsr key0
	lda CURROW
	and #%00010000
	beq *+5
	jsr keym
	lda CURROW
	and #%00100000
	beq *+5
	jsr keyk
	lda CURROW
	and #%01000000
	beq *+5
	jsr keyo
	lda CURROW
	and #%10000000
	beq *+5
	jsr keyn

keyrow5 lda TOPROW5
	eor #$ff
	and LSTROW5
	cmp #0
	beq keyrow6
	sta CURROW
	and #%00000001
	beq *+5
	jsr keypl
	lda CURROW
	and #%00000010
	beq *+5
	jsr keyp
	lda CURROW
	and #%00000100
	beq *+5
	jsr keyl
	lda CURROW
	and #%00001000
	beq *+5
	jsr keymn
	lda CURROW
	and #%00010000
	beq *+5
	jsr keydot
	lda CURROW
	and #%00100000
	beq *+5
	jsr keycol
	lda CURROW
	and #%01000000
	beq *+5
	jsr keyat
	lda CURROW
	and #%10000000
	beq *+5
	jsr keycom
keyrow6 lda TOPROW6
        eor #$ff
        and LSTROW6
        cmp #0
        beq keyrow7
keyrow7 lda TOPROW7
	eor #$ff
	and LSTROW7
	cmp #0
	beq nokey
	sta CURROW
	and #%00000001
	beq *+5
	jsr key1
	lda CURROW
	and #%00000010
	beq *+5
	jsr keydown
	lda CURROW
	and #%00001000
	beq *+5
	jsr key2
	lda CURROW
	and #%00010000
	beq *+5
	jsr keyspac
	lda CURROW
	and #%01000000
	beq *+5
	jsr keyq
nokey	rts
	
keyshf
shfrow1 lda TOPROW1
	eor #$ff
	and LSTROW1
	cmp #0
	beq shfrow2
	sta CURROW
	and #%00000001
	beq *+5
	jsr shf3
	lda CURROW
	and #%00000010
	beq *+5
	jsr shfw
	lda CURROW
	and #%00000100
	beq *+5
	jsr shfa
	lda CURROW
	and #%00001000
	beq *+5
	jsr shf4
	lda CURROW
	and #%00010000
	beq *+5
	jsr shfz
	lda CURROW
	and #%00100000
	beq *+5
	jsr shfs
	lda CURROW
	and #%01000000
	beq *+5
	jsr shfe

shfrow2 lda TOPROW2
	eor #$ff
	and LSTROW2
	cmp #0
	beq shfrow3
	sta CURROW
	and #%00000001
	beq *+5
	jsr shf5
	lda CURROW
	and #%00000010
	beq *+5
	jsr shfr
	lda CURROW
	and #%00000100
	beq *+5
	jsr shfd
	lda CURROW
	and #%00001000
	beq *+5
	jsr shf6
	lda CURROW
	and #%00010000
	beq *+5
	jsr shfc
	lda CURROW
	and #%00100000
	beq *+5
	jsr shff
	lda CURROW
	and #%01000000
	beq *+5
	jsr shft
	lda CURROW
	and #%10000000
	beq *+5
	jsr shfx

shfrow3 lda TOPROW3
	eor #$ff
	and LSTROW3
	cmp #0
	beq shfrow4
	sta CURROW
	and #%00000001
	beq *+5
	jsr shf7
	lda CURROW
	and #%00000010
	beq *+5
	jsr shfy
	lda CURROW
	and #%00000100
	beq *+5
	jsr shfg
	lda CURROW
	and #%00001000
	beq *+5
	jsr shf8
	lda CURROW
	and #%00010000
	beq *+5
	jsr shfb
	lda CURROW
	and #%00100000
	beq *+5
	jsr shfh
	lda CURROW
	and #%01000000
	beq *+5
	jsr shfu
	lda CURROW
	and #%10000000
	beq *+5
	jsr shfv

shfrow4	lda TOPROW4
	eor #$ff
	and LSTROW4
	cmp #0
	beq shfrow5
	sta CURROW
	and #%00000001
	beq *+5
	jsr shf9
	lda CURROW
	and #%00000010
	beq *+5
	jsr shfi
	lda CURROW
	and #%00000100
	beq *+5
	jsr shfj
	lda CURROW
	and #%00001000
	beq *+5
	jsr shf0
	lda CURROW
	and #%00010000
	beq *+5
	jsr shfm
	lda CURROW
	and #%00100000
	beq *+5
	jsr shfk
	lda CURROW
	and #%01000000
	beq *+5
	jsr shfo
	lda CURROW
	and #%10000000
	beq *+5
	jsr shfn

shfrow5 lda TOPROW5
	eor #$ff
	and LSTROW5
	cmp #0
	beq shfrow6
	sta CURROW
	and #%00000001
	beq *+5
	jsr shfpl
	lda CURROW
	and #%00000010
	beq *+5
	jsr shfp
	lda CURROW
	and #%00000100
	beq *+5
	jsr shfl
	lda CURROW
	and #%00001000
	beq *+5
	jsr shfmn
	lda CURROW
	and #%00010000
	beq *+5
	jsr shfdot
	lda CURROW
	and #%00100000
	beq *+5
	jsr shfcol
	lda CURROW
	and #%01000000
	beq *+5
	jsr shfat
	lda CURROW
	and #%10000000
	beq *+5
	jsr shfcom
shfrow6
	rts

maxkey	inc KEY_CNT
	lda KEY_CNT
	cmp #2
	bne nextkey
	pla
	pla
nextkey	rts
	
	; unshifted keys

key1	rts
key2	rts
key3	jsr movel2
	jmp maxkey
key4	jsr movel2
	jmp maxkey
key5	rts
key6	rts
key7	jsr mover2
	jmp maxkey
key8	jsr mover2
	jmp maxkey
key9	rts
key0	rts
keypl	rts
keymn	rts

keyctrl	rts
keyq	jsr movezi
	jmp maxkey
keyw	jsr moveb
	jmp maxkey
keye	jsr moveli
	jmp maxkey
keyr	jsr move2li
	jmp maxkey
keyt	jsr movex
	jmp maxkey
keyy	jsr movex
	jmp maxkey
keyu	jsr move2r
	jmp maxkey
keyi	jsr mover
	jmp maxkey
keyo	jsr movebi
	jmp maxkey
keyp	jsr movez
	jmp maxkey
keyat	rts

keya	jsr moveyi
	jmp maxkey
keys	jsr moved
	jmp maxkey
keyd	jsr movel
	jmp maxkey
keyf	jsr moveui
	jmp maxkey
keyg	jsr movefi
	jmp maxkey
keyh	jsr movef
	jmp maxkey
keyj	jsr moveu
	jmp maxkey
keyk	jsr moveri
	jmp maxkey
keyl	jsr movedi
	jmp maxkey
keycol  jsr movey
	jmp maxkey
keysc	rts
keyeq	rts
keyret  rts

keycmd	rts
keyz	rts
keyx	rts
keyc	rts
keyv	jsr move2l
	jmp maxkey
keyb	jsr movexi
	jmp maxkey
keyn	jsr movexi
	jmp maxkey
keym	jsr move2ri
	jmp maxkey
keycom	rts
keydot  rts
keyslsh	rts
keyrsh	rts
keydown rts
keyrght	rts

keyspac	jmp rescram

	; shifted keys

shf1	rts
shf2	rts
shf3	rts
shf4	rts
shf5	rts
shf6	rts
shf7	rts
shf8	rts
shf9	rts
shf0	rts
shfpl	rts
shfmn	rts

shfq	rts
shfw	jsr move2b
	jmp maxkey
shfe	jsr move2li
	jmp maxkey
shfr	rts
shft	rts
shfy	rts
shfu	rts
shfi	jsr move2r
	jmp maxkey
shfo	jsr move2bi
	jmp maxkey
shfp	rts
shfat	rts

shfa	rts
shfs	jsr move2d
	jmp maxkey
shfd	jsr move2l
	jmp maxkey
shff	jsr move2ui
	jmp maxkey
shfg	jsr move2fi
	jmp maxkey
shfh	jsr move2f
	jmp maxkey
shfj	jsr move2u
	jmp maxkey
shfk	jsr move2ri
	jmp maxkey
shfl	jsr move2di
	jmp maxkey
shfcol  rts

shfz	rts
shfx	rts
shfc	rts
shfv	rts
shfb	rts
shfn	rts
shfm	rts
shfcom	rts
shfdot  rts