	sei

	; switch off basic and kernal ROM, enable character generator ROM
	lda #25
	sta $1

	; copy character generator ROM to RAM at $c000
	lda #<$d000
	sta $fb
	lda #>$d000
	sta $fc
	lda #<$c000
	sta $fd
	lda #>$c000
	sta $fe
cpchars	ldy #$ff
cpchar	lda ($fb),y
        sta ($fd),y
        dey
        cpy #$ff
        bne cpchar
        inc $fc
        lda $fc
        cmp #$e0
        beq endcpc
        inc $fe
        jmp cpchars
endcpc

	; disable character generator ROM, enable I/O
	lda #29
	sta $1

	; disable NMI
        lda #<nmih
        sta $fffa
        lda #>nmih
        sta $fffb
	lda #$00        ; stop Timer A
	sta $dd0e       ;
	sta $dd04       ; set Timer A to 0, after starting
	sta $dd05       ; NMI will occur immediately
	lda #$81        ;
	sta $dd0d       ; set Timer A as source for NMI
	lda #$01        ;
	sta $dd0e       ; start Timer A -> NMI

	; clear raster memory
	lda #<$4000
	sta $fb
	lda #>$4000
	sta $fc

	lda #0
clrasts	ldy #0
clrast	sta ($fb),y
	iny
	bne clrast
	ldx $fc
	cpx #$5f
	beq cpbgs
	inx
	stx $fc
	jmp clrasts

	; copy background to right place in raster memory
cpbgs	lda #<cubebg
	sta $fb
	lda #>cubebg
	sta $fc
	lda #<$4650
	sta $fd
	lda #>$4650
	sta $fe

cpbgsl	ldy #0  ; copy 144 bytes (18 characters)
cpbg	lda ($fb),y
	sta ($fd),y
	iny
	cpy #144
	bne cpbg

	lda $fb ; increase source pointer with 144
	clc
	adc #144
	sta $fb
	bcc intptr
	inc $fc

intptr	inc $fe ; increase target pointer with 320
	lda $fd
	clc
	adc #$40
	sta $fd
	bcc endtptr
	inc $fe

endtptr	lda $fe ; are we at the end?
	cmp #$5b
	beq clcols
	jmp cpbgsl

	; clear color ram
clcols	lda #$0f
	ldx #$00
clcol	sta $6000,x
	sta $6100,x
	sta $6200,x
	sta $6300,x
	inx
	bne clcol

	; copy sprite data
	lda #<sprites
	sta $fb
	lda #>sprites
	sta $fc
	lda #<SPR_B
	sta $fd
	lda #>SPR_B
	sta $fe

cpsprs	ldy #$00
cpspr	lda ($fb),y
	sta ($fd),y
	iny
	bne cpspr
	inc $fe
	lda $fe
	cmp #>SPR_E
	beq intcube
	inc $fc
	jmp cpsprs

	; clear cube
intcube	jsr clrcube

	; set initial game state
        lda #FREE_ST
        sta STATE
        lda #0
        sta CUB_MVD
        sta NB_CUBH
        sta NB_CUBL
        sta NS_CUBH
        sta NS_CUBL
        sta NBC_THD
        sta NBC_HDT
        sta NBC_TEN
        sta NBC_ONE
        sta NBS_THD
        sta NBS_HDT
        sta NBS_TEN
        sta NBS_ONE
        sta SUM_BT3
        sta SUM_BT2
        sta SUM_BT1
        sta SUM_BT0

        lda #<$8000
        sta TSTACKL
        lda #>$8000
        sta TSTACKH

        ; initialize key scan table
        lda #$ff
        ldx #7
initkey	sta TOPROW0,x
        sta BOTROW0,x
        sta LSTROW0,x
        dex
        bpl initkey

	; set up I/O
	lda #$ff
	sta $dc02
	lda #$00
	sta $dc03

	; display fixed labels
	lda #<timeslb ; times
	sta $f8
	lda #>timeslb
	sta $f9
	lda #5
	sta $fa
	lda #<$4240
	sta $fd
	lda #>$4240
        sta $fe
        jsr prchars

	lda #<statslb ; stats
	sta $f8
	lda #>statslb
	sta $f9
	lda #5
	sta $fa
	lda #<$5500
	sta $fd
	lda #>$5500
        sta $fe
        jsr prchars

        lda #<nbcublb ; number
	sta $f8
	lda #>nbcublb
	sta $f9
	lda #13
	sta $fa
	lda #<$5738
	sta $fd
	lda #>$5738
        sta $fe
        jsr prchars

        lda #<bestlb  ; best
	sta $f8
	lda #>bestlb
	sta $f9
	lda #11
	sta $fa
	lda #<$5888
	sta $fd
	lda #>$5888
        sta $fe
        jsr prchars

        lda #<worstlb  ; worst
	sta $f8
	lda #>worstlb
	sta $f9
	lda #12
	sta $fa
	lda #<$59c0
	sta $fd
	lda #>$59c0
        sta $fe
        jsr prchars

        lda #<avg5lb  ; average of 5
	sta $f8
	lda #>avg5lb
	sta $f9
	lda #12
	sta $fa
	lda #<$5b00
	sta $fd
	lda #>$5b00
        sta $fe
        jsr prchars

        lda #<avg12lb  ; average of 12
	sta $f8
	lda #>avg12lb
	sta $f9
	lda #13
	sta $fa
	lda #<$5c38
	sta $fd
	lda #>$5c38
        sta $fe
        jsr prchars

        lda #<meanlb  ; mean
	sta $f8
	lda #>meanlb
	sta $f9
	lda #11
	sta $fa
	lda #<$5d88
	sta $fd
	lda #>$5d88
        sta $fe
        jsr prchars

        lda #<f1lb    ; f1
	sta $f8
	lda #>f1lb
	sta $f9
	lda #8
	sta $fa
	lda #<$5cc8
	sta $fd
	lda #>$5cc8
        sta $fe
        jsr prchars

        lda #<f3lb    ; f3
	sta $f8
	lda #>f3lb
	sta $f9
	lda #11
	sta $fa
	lda #<$5d10
	sta $fd
	lda #>$5d10
        sta $fe
        jsr prchars

	; set up VIC
setvic	lda $d011 ; enable bitmap mode
	ora #$20
	sta $d011

	lda $dd00 ; switch to bank no. 2
	and #$fc
	ora #$02
	sta $dd00

	lda #$80  ; set base addresses
	sta $d018

	IF DEBUG
	ELSE
	lda #$0b  ; border color
	sta $d020
        ENDIF

	lda #$ff
	sta $d015 ; enable all sprites
	sta $d017 ; expand all sprites in Y-direction
	sta $d01b ; put all sprites behind background

	lda #%11001111
	sta $d01d ; expand all sprites except sprites 4 and 5 in X-direction

	; set up random number generator
        lda #$ff  ; frequency
        sta $d40e
        sta $d40f
        lda #$81  ; noise waveform
        sta $d412
        lda #$0f  ; attack & decay
        sta $d413
        lda #$ff  ; sustain & release
        sta $d414
        lda #$00  ; volume
        sta $d418

	; switch off timer
	lda #$7f
	sta $dc0d
	lda $dc0d

	; set raster interrupt
	lda #$7f
	and $d011
	sta $d011
	lda #IRQ_S1
	sta $d012
	lda #%00000001
	sta $d01a

	; set irq hanlder
	lda #<s1irqh
	sta $fffe
	lda #>s1irqh
	sta $ffff

	asl $d019

end	cli