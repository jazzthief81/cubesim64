free
	rts

scrambl lda SCR_MVS
	beq endscr
	dec SCR_CTD
	lda SCR_CTD
	beq rndmov
	rts
rndmov	lda $d41b
nxtrnd	clc
	cmp #(rndmovte-rndmovt)/3
	bcc rndnum
        sec
        sbc #(rndmovte-rndmovt)/3
        jmp nxtrnd
rndnum  ldx #<rndmovt
advjmp	cmp #0
	beq endrnd
        inx
        inx
        inx
        sec
        sbc #1
        jmp advjmp
endrnd	stx rndjmp+1
	ldx #>rndmovt
	stx rndjmp+2
rndjmp	jsr rndmovt  ; will be changed by random entry
	lda #4
	sta SCR_CTD
	dec SCR_MVS
	rts

endscr	lda #PREI_ST
	sta STATE
	lda #0       ; reset internal clock
	sta INT_CLL
	sta INT_CLH
	sta NXT_SKP
	sta TIM_HDT  ; set preinspection time
	sta TIM_TNT
	sta TIM_MIN
	lda #1
	sta TIM_TSC
	lda #5
	sta TIM_SEC
	rts

	align $100

rndmovt	jmp mover
	jmp moveri
	jmp mover2
	jmp moveu
	jmp moveui
	jmp moveu2
	jmp movef
	jmp movefi
	jmp movef2
	jmp movel
        jmp moveli
        jmp movel2
        jmp moved
        jmp movedi
        jmp moved2
        jmp moveb
        jmp movebi
        jmp moveb2
        jmp move2r
        jmp move2ri
        jmp move2u
        jmp move2ui
        jmp move2f
        jmp move2fi
        jmp move2l
        jmp move2li
        jmp move2d
        jmp move2di
        jmp move2b
        jmp move2bi
rndmovte

preinsp	jsr advclc
	jsr chkskp
	bne noadvcd
	jsr ctdtim
	jsr prctd
noadvcd	rts

solve   jsr advclc
	jsr chkskp
	bne noadvtm
	jsr advtim
noadvtm	rts

advclc	inc INT_CLL ; advance internal clock
	bne chkwrp
	inc INT_CLH
	jmp advcle
chkwrp	lda INT_CLH ; wrap around at 6842 ticks
	cmp #>6842
	bne advcle
	lda INT_CLL
	cmp #<6842
	bne advcle
	lda #0
	sta INT_CLL
	sta INT_CLH
advcle	rts

skptcks dc.w 1
	dc.w 403
	dc.w 805
	dc.w 1208
	dc.w 1610
	dc.w 2013
	dc.w 2415
	dc.w 2818
	dc.w 3220
	dc.w 3623
	dc.w 4025
	dc.w 4428
	dc.w 4830
	dc.w 5233
	dc.w 5635
	dc.w 6038
	dc.w 6440

chkskp  ldx NXT_SKP
	lda skptcks,x
        cmp INT_CLL
        bne advnosk
	lda skptcks+1,x
	cmp INT_CLH
	beq advskip
advnosk lda #0
	rts
advskip inx
	inx
	cpx #34
	bne rtnskip
	ldx #0
rtnskip	stx NXT_SKP
	lda #1
	rts

advtim  inc TIM_HDT ; update time
	lda TIM_HDT
	cmp #10
	bne advtime
	lda #0
	sta TIM_HDT
	inc TIM_TNT
	lda TIM_TNT
	cmp #10
	bne advtime
	lda #0
	sta TIM_TNT
	inc TIM_SEC
	lda TIM_SEC
	cmp #10
	bne advtime
	lda #0
	sta TIM_SEC
	inc TIM_TSC
	lda TIM_TSC
	cmp #6
	bne advtime
	lda #0
	sta TIM_TSC
	inc TIM_MIN
	lda TIM_MIN
	cmp #10
	bne advtime
	lda #0      ; out of time -> DNF
	sta CUB_SLV
	jsr addresl
	jsr gotofre
	rts
advtime	jsr prctimt
	rts

ctdtim	dec TIM_HDT ; update time
	bpl ctdtime
	lda #9
	sta TIM_HDT
	dec TIM_TNT
	bpl ctdtime
	lda #9
	sta TIM_TNT
	dec TIM_SEC
	bpl ctdtime
	lda #9
	sta TIM_SEC
	dec TIM_TSC
	bpl ctdtime
	lda #5
	sta TIM_TSC
	dec TIM_MIN
	bpl ctdtime
	jsr gotoslv
ctdtime	rts

	; prints the current time up to 0.01s
prctimh	ldx <#$42f0
	stx $fd
	ldx >#$42f0
	stx $fe
	ldx #TIM_HDT
	stx $f7
	jsr prtimeh
	rts

	; prints the current time up to 0.1s
prctimt	ldx <#$42e8
	stx $fd
	ldx >#$42e8
	stx $fe
	ldx #TIM_HDT
	stx $f7
	jsr prtimet
	rts

	; prints the last time in the list up to 0.01s
prltime	lda NB_CUBH
	bne prldown
	lda NB_CUBL
	cmp #13
	bpl prldown
	tay
	ldx <#$44e8
        stx $fd
        ldx >#$44e8
        stx $fe
	ldx #TIM_HDT
	stx $f7
prltiml	dey
	beq prltiel
	jsr curdown
	jmp prltiml
prltiel	jsr prtimeh
	rts
prldown jsr cpytims ; move previous times up
	ldx <#$52a8 ; print last time
	stx $fd
	ldx >#$52a8
	stx $fe
	ldx #TIM_HDT
	stx $f7
	jsr prtimeh
	rts

prtimeh	lda CUB_SLV
	bne prtfint
	lda #<dnflb ; print DNF
	sta $f8
	lda #>dnflb
	sta $f9
	lda #7
	sta $fa
	jsr prrchrs
	rts

prtfint	ldx $f7     ; display time up to 0.01s
	lda 0,x
        jsr prdigit
	jsr curleft

prtimet	dec $f7     ; display time up to 0.1s
	ldx $f7
	lda 0,x
        jsr prdigit
	jsr curleft

        lda <#$c170
        sta $fb
        lda >#$c170
        sta $fc
        jsr prchar
	jsr curleft

	dec $f7
        ldx $f7
        lda 0,x
        jsr prdigit
	jsr curleft

	dec $f7
        ldx $f7
        lda 0,x
        jsr prdigit
	jsr curleft

        lda <#$c1d0
        sta $fb
        lda >#$c1d0
        sta $fc
        jsr prchar
	jsr curleft

        dec $f7
        ldx $f7
        lda 0,x
        jsr prdigit

	rts

prctd	lda TIM_SEC ; display countdown by rounding up to the nearest second
	ldy TIM_TSC
        ldx TIM_HDT
        bne roundup
        ldx TIM_TNT
        bne roundup
        jmp rounde
roundup	clc
	adc #1
        cmp #10
        bne rounde
        lda #0
	iny
rounde	sty CTD_TSC
	ldx <#$42d8
        stx $fd
        ldx >#$42d8
        stx $fe
        jsr prdigit

        lda CTD_TSC
	ldx <#$42d0
        stx $fd
        ldx >#$42d0
        stx $fe
        jsr prdigit
        rts

clrtime	ldx <#$42c0
	stx $fd
        ldx >#$42c0
        stx $fe
        ldy #0
        lda #0
clrtch	sta ($fd),y
        iny
        cpy #56
        bne clrtch
        rts

cpytime ldy #0
cpytch	lda ($fb),y
	sta ($fd),y
        iny
        cpy #56
        bne cpytch
        rts

	; copy all times one row up
cpytims lda <#$45f8
	sta $fb
	lda >#$45f8
	sta $fc
	lda <#$44b8
	sta $fd
	lda >#$44b8
	sta $fe
	ldx #0
cpytmsl	jsr cpytime
	inx
	cpx #11
	beq cpytmse
	lda $fb
	sta $fd
	lda $fc
	sta $fe
	jsr curdown
        lda $fb
        ldy $fd
        sty $fb
        sta $fd
        lda $fc
        ldy $fe
        sty $fc
        sta $fe
	jmp cpytmsl
cpytmse	rts

prdigit	ldy #$c0
	clc
	adc #48
	asl
	asl
	asl
	bcc ncrry
	iny
ncrry	sta $fb
	sty $fc
prchar	ldy #0
cpdigit lda ($fb),y
        sta ($fd),y
        iny
        cpy #8
        bne cpdigit
	rts

prchars	ldx #0
prcharl cpx $fa
	beq prchare
	txa
	asl
	tay
        lda ($f8),y
        sta $fb
        iny
        lda ($f8),y
        sta $fc
        jsr prchar
        inx
        jsr currght
        jmp prcharl
prchare	rts

prrchrs	ldx $fa
prrchrl cpx #0
	beq prrchre
	txa
	sec
	sbc #1
	asl
	tay
        lda ($f8),y
        sta $fb
        iny
        lda ($f8),y
        sta $fc
        jsr prchar
        dex
        jsr curleft
        jmp prrchrl
prrchre	rts

curleft	lda $fd
	sec
	sbc #8
	sta $fd
	bcs curlefe
	dec $fe
curlefe	rts

currght	lda $fd
	clc
	adc #8
	sta $fd
	bcc curlefe
	inc $fe
currghe	rts

curdown	lda #$40
	clc
	adc $fd
	sta $fd
	bcc curdowh
	inc $fe
curdowh	inc $fe
	rts