	; adds the current time to the stats
updstat jsr updncub
	lda CUB_SLV
	beq nocbslv
	jsr updscub
	jsr pshresl
	jsr updbsws
	jsr updavg5
	jsr updav12
	jsr updmean
	rts
nocbslv	jsr pshresl
	jsr updavg5
	jsr updav12
	rts

updncub inc NB_CUBL
	bne updncud
        inc NB_CUBH
updncud	ldx #3
updncul	inc NBC_THD,x
        lda NBC_THD,x
        cmp #10
        bne updncue
	lda #0
	sta NBC_THD,x
        dex
        jmp updncul
updncue	lda <#$5798
	sta $fd
	lda >#$5798
	sta $fe
	ldx #0
skipdgc	lda NBC_THD,x
	bne prncul
	inx
	jmp skipdgc
prncul	lda NBC_THD,x
	jsr prdigit
	jsr currght
	inx
	cpx #4
	beq prncue
	jmp prncul
prncue	rts

updscub inc NS_CUBL
	bne updscud
	inc NS_CUBH
updscud	ldx #3
updscul	inc NBS_THD,x
        lda NBS_THD,x
        cmp #10
        bne updscue
	lda #0
	sta NBS_THD,x
        dex
        jmp updscul
updscue	lda NS_CUBL
	ora NS_CUBH
	beq nocubes
	lda <#$5770
        sta $fd
        lda >#$5770
	sta $fe
	ldx #0
skipdgs	lda NBS_THD,x
	bne prncusl
	inx
	jsr currght
	jmp skipdgs
prncusl	lda NBS_THD,x
	jsr prdigit
	inx
	cpx #4
	beq nocubes
	jsr currght
	jmp prncusl
nocubes	rts

	; adds the current time to the stack
pshresl lda CUB_SLV
	bne caltime
        lda #$ff
        sta TIMEH
        sta TIMEL
        jmp phtime

caltime	lda #0        ; add minutes
	sta TIMEH
	lda TIM_MIN
	sta TIMEL

	jsr mul6tim   ; multiply by 6

	ldx TIM_TSC   ; add ten seconds
	jsr addstim

	jsr mul10ti   ; multiply by 10

	ldx TIM_SEC   ; add seconds
	jsr addstim

	jsr mul10ti   ; multiply by 10

	ldx TIM_TNT   ; add tenths
	jsr addstim

	jsr mul10ti   ; multiply by 10

	ldx TIM_HDT   ; add hundredths
	jsr addstim

phtime	lda TIMEH
	ldy #0
	sta (TSTACKL),y
	inc TSTACKL
	lda TIMEL
	sta (TSTACKL),y
	inc TSTACKL
	bne pshtien
	inc TSTACKH
pshtien	rts

updbsws lda NS_CUBH
	bne cmpbsws
	lda NS_CUBL
	cmp #1
	bne cmpbsws
	lda TIMEH
	sta BST_TIH
	sta WST_TIH
	lda TIMEL
	sta BST_TIL
	sta WST_TIL
	jsr prtbst
	jsr prtwst
	rts
cmpbsws lda TIMEH
	cmp BST_TIH
        bpl cmpws
        bmi updbs
        lda TIMEL
        cmp BST_TIL
        bcc cmpws
updbs	sta BST_TIL
	lda TIMEH
	sta BST_TIH
	jsr prtbst
cmpws   lda TIMEH
	cmp WST_TIH
	bmi nouws
	bpl updws
        lda TIMEL
        cmp WST_TIL
        bcs nouws
updws	sta WST_TIL
	lda TIMEH
	sta WST_TIH
        jsr prtwst
nouws	rts

prtbst	ldx <#$58e8
        stx $fd
        ldx >#$58e8
        stx $fe
        ldx #TIM_HDT
        stx $f7
        jsr prtimeh
	rts

prtwst  ldx <#$5a28
        stx $fd
        ldx >#$5a28
        stx $fe
        ldx #TIM_HDT
        stx $f7
        jsr prtimeh
	rts

	; muliplies time by 6
mul6tim	jsr sltime
 	jsr ldtime
 	jsr sltime
 	jsr addtime
 	rts

	; muliplies time by 10
mul10ti	jsr sltime
 	jsr ldtime
 	jsr sltime
 	jsr sltime
 	jsr addtime
 	rts

	; muliplies time by 2
sltime  asl TIMEL
	rol TIMEH
	rts

	; loads time in X and Y
ldtime  ldx TIMEL
	ldy TIMEH
	rts

	; adds X and Y to time
addtime txa
	clc
	adc TIMEL
	sta TIMEL
        bcc addtih
        inc TIMEH
addtih	tya
	clc
	adc TIMEH
	sta TIMEH
	rts

	; adds X to time
addstim txa
	clc
        adc TIMEL
        sta TIMEL
        bcc addstie
        inc TIMEH
addstie	rts

updavg5 lda #0
        cmp NB_CUBH
        bcc avg5
        lda NB_CUBL
        cmp #5
        bcs avg5
        rts

avg5	lda CUB_SLV
	pha

	lda #5
	sta $f3
	jsr calavg
	bne avg5fin

	lda #0
	sta CUB_SLV
	jmp prtavg5

avg5fin	jsr qttodec
	lda #1
	sta CUB_SLV

prtavg5	ldx <#$5b68
        stx $fd
        ldx >#$5b68
        stx $fe
        ldx #QTN_HDT
        stx $f7
	jsr prtimeh

	pla
	sta CUB_SLV

	rts

updav12	lda #0
        cmp NB_CUBH
        bcc avg12
        lda NB_CUBL
        cmp #12
        bcs avg12
        rts

avg12	lda CUB_SLV
	pha

	lda #12
	sta $f3
	jsr calavg
	bne av12fin

	lda #0
	sta CUB_SLV
	jmp prtav12

av12fin	jsr qttodec
 	lda #1
 	sta CUB_SLV

prtav12	ldx <#$5ca8
        stx $fd
        ldx >#$5ca8
        stx $fe
        ldx #QTN_HDT
        stx $f7
	jsr prtimeh

	pla
	sta CUB_SLV

	rts

calavg	asl $f3
	lda TSTACKL
	sec
	sbc $f3
	sta $f0
	lda TSTACKH
	sbc #0
	sta $f1
	lsr $f3
        lda #0
        sta $f2     ; #DNF's
        sta MAX_TIH
        sta MAX_TIL
	sta REM_BT0
	sta REM_BT1
	sta REM_BT2
	sta REM_BT3
	sta DIV_BT1
	sta DIV_BT2
	sta DIV_BT3
        sta DIV_H
        lda #$ff
        sta MIN_TIH
        sta MIN_TIL
        lda $f3
        sec
        sbc #2
        sta DIV_BT0
        sta DIV_L

calavgl	ldy #0
        lda ($f0),y
        cmp #$ff
        bne noidnf
        ldy #1
        lda ($f0),y
        cmp #$ff
        bne noidnf
	inc $f2

noidnf	ldy #1       ; add time to sum
        lda ($f0),y
        clc
        adc REM_BT0
        sta REM_BT0
        lda REM_BT1
        ldy #0
        adc ($f0),y
        sta REM_BT1
        lda REM_BT2
        adc #0
        sta REM_BT2
        lda REM_BT3
        adc #0
        sta REM_BT3

	jsr updmnmx

	lda $f0      ; advance pointer
        clc
        adc #2
        sta $f0
        lda $f1
        adc #0
        sta $f1

        lda $f0      ; have we reached the end?
        cmp TSTACKL
        bne calavgl
        lda $f1
        cmp TSTACKH
        bne calavgl

	lda $f2      ; too many DNF's
        cmp #2
        bcs avgdnf

	lda REM_BT0  ; subtract minimum
	sec
	sbc MIN_TIL
	sta REM_BT0
        lda REM_BT1
        sbc MIN_TIH
        sta REM_BT1
        lda REM_BT2
        sbc #0
        sta REM_BT2
        lda REM_BT3
        sbc #0
        sta REM_BT3

	lda REM_BT0 ; subtract maximum
	sec
	sbc MAX_TIL
	sta REM_BT0
        lda REM_BT1
        sbc MAX_TIH
        sta REM_BT1
        lda REM_BT2
        sbc #0
        sta REM_BT2
        lda REM_BT3
        sbc #0
        sta REM_BT3

        jsr divide
	jsr rndqtn

	lda #1
        rts

avgdnf  lda #0
	rts

updmnmx	ldy #0      ; update min
        lda ($f0),y
        cmp MIN_TIH
        bcc newmin
        bne updmax
	ldy #1
	lda ($f0),y
        cmp MIN_TIL
        bcc newmin
        jmp updmax
newmin	ldy #0
	lda ($f0),y
	sta MIN_TIH
	ldy #1
	lda ($f0),y
	sta MIN_TIL

updmax  ldy #0      ; update max
        lda MAX_TIH
        cmp ($f0),y
        bcc newmax
        bne nonwmax
        ldy #1
        lda MAX_TIL
        cmp ($f0),y
        bcc newmax
        jmp nonwmax
newmax	ldy #0
        lda ($f0),y
        sta MAX_TIH
        ldy #1
        lda ($f0),y
        sta MAX_TIL

nonwmax	rts

updmean lda SUM_BT0 ; add last time to sum
	clc
	adc TIMEL
        sta SUM_BT0
        sta REM_BT0
        lda SUM_BT1
        adc TIMEH
        sta SUM_BT1
        sta REM_BT1
        lda SUM_BT2
        adc #0
        sta SUM_BT2
        sta REM_BT2
        lda SUM_BT3
        adc #0
        sta SUM_BT3
        sta REM_BT3

        lda NS_CUBH ; divide sum by number of solved cubes
        sta DIV_BT1
        sta DIV_H
        lda NS_CUBL
        sta DIV_BT0
        sta DIV_L

        lda #0
        sta DIV_BT3
        sta DIV_BT2

	jsr divide
	jsr rndqtn
        jsr qttodec
        jsr prtmean

        rts

rndqtn	jsr shlrem ; round to nearest hundredth of a second
        jsr cmprem
        lda QTN_BT0
        adc #0
        sta QTN_BT0
        lda QTN_BT1
        adc #0
        sta QTN_BT1

	rts

qttodec	lda QTN_BT1
	sta REM_BT1
	lda QTN_BT0
	sta REM_BT0

	lda #0
	sta QTN_BT0
	sta QTN_BT1
	sta REM_BT2
	sta DIV_BT2
	sta REM_BT3
	sta DIV_BT3

	lda #>6000
	sta DIV_BT1
	lda #<6000
	sta DIV_BT0

        jsr divide

	lda QTN_BT0
	sta QTN_MIN

	lda #>1000
	sta DIV_BT1
	lda #<1000
	sta DIV_BT0

	jsr divide

	lda QTN_BT0
	sta QTN_TSC

	lda #>100
	sta DIV_BT1
	lda #<100
	sta DIV_BT0

	jsr divide

	lda QTN_BT0
	sta QTN_SEC

	lda #>10
	sta DIV_BT1
	lda #<10
	sta DIV_BT0

	jsr divide

	lda QTN_BT0
	sta QTN_TNT

	lda REM_BT0
	sta QTN_HDT

	rts

divide  lda #0
	sta QTN_BT0
	sta QTN_BT1
        sta FAC_BT1
        lda #1
        sta FAC_BT0
shldvl	jsr cmpdiv ; shift divisor left until it is big enough
        bcc dividl
        jsr shldiv
        jmp shldvl
dividl  jsr shrdiv ; shift divisor right until it fits in remainder
	jsr cmpfac
	beq divend
	jsr cmpdiv
	bcc dividl
        jsr subdiv ; subtract remainder from divisor
        jsr addqtn ; add factor to quotient
        jmp dividl
divend	rts

cmpdiv  lda REM_BT3
	cmp DIV_BT3
	bne cmpdive
        lda REM_BT2
        cmp DIV_BT2
        bne cmpdive
        lda REM_BT1
        cmp DIV_BT1
        bne cmpdive
        lda REM_BT0
        cmp DIV_BT0
cmpdive	rts

cmpfac	lda FAC_BT1
	cmp #0
	bne cmpface
	lda FAC_BT0
	cmp #0
cmpface	rts

cmprem  lda REM_BT1
	cmp DIV_H
	bne cmpree
	lda REM_BT0
	cmp DIV_L
cmpree	rts

shldiv  asl DIV_BT0
	rol DIV_BT1
	rol DIV_BT2
	rol DIV_BT3
	asl FAC_BT0
	rol FAC_BT1
	rts

shrdiv  lsr DIV_BT3
	ror DIV_BT2
	ror DIV_BT1
	ror DIV_BT0
	lsr FAC_BT1
	ror FAC_BT0
	rts

shlrem  asl REM_BT0
	rol REM_BT1
	rol REM_BT2
	rol REM_BT3
	rts

subdiv  lda REM_BT0
	sec
	sbc DIV_BT0
	sta REM_BT0
        lda REM_BT1
        sbc DIV_BT1
        sta REM_BT1
        lda REM_BT2
        sbc DIV_BT2
        sta REM_BT2
        lda REM_BT3
        sbc DIV_BT3
        sta REM_BT3
	rts

addqtn  lda FAC_BT0
	clc
	adc QTN_BT0
	sta QTN_BT0
	lda FAC_BT1
	adc QTN_BT1
	sta QTN_BT1
	rts

prtmean	ldx <#$5de8
	stx $fd
        ldx >#$5de8
        stx $fe
        ldx #QTN_HDT
	stx $f7
        jsr prtimeh
	rts