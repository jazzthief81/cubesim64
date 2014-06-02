IRQ_S1	EQU $40
IRQ_S2	EQU IRQ_S1 + 1
IRQ_OS	EQU $fb

s1irqh	lda $d012   ; are we on the right line?
	cmp #IRQ_S1
	beq setirq2

	asl $d019   ; if not, wait for next interrupt

	rti

setirq2	lda #IRQ_S2 ; set interrupt for next line
	sta $d012

	lda <#s2irqh
	sta $fffe
	lda >#s2irqh
	sta $ffff

	asl $d019
	cli

	ds.b 11,$ea ; wait to be interrupted
	rti         ; make sure to return from interrupt after returning from second interrupt routine


s2irqh	ds.b 25,$ea
	lda $d012
	cmp #IRQ_S2
	beq stabler

stabler lda #M3_PV
	sta SPR1_PA
	lda #M3_X
	sta SPR1_X
	lda #M3_Y
	sta SPR1_Y

	lda #M1_PV  ; set sprite pointers for zone 1
	sta SPR0_PA
	lda #LB1_PV
	sta SPR2_PA
	lda #RB1_PV
	sta SPR3_PA
	lda #LL1_PV
	sta SPR4_PA
	lda #RR1_PV
	sta SPR5_PA
	lda #LF1_PV
	sta SPR6_PA
	lda #RF1_PV
	sta SPR7_PA

	lda #M1_X   ; set sprite positions for zone 1
	sta SPR0_X
	lda #M1_Y
	sta SPR0_Y
	lda #LB1_X
	sta SPR2_X
	lda #LB1_Y
	sta SPR2_Y
	lda #RB1_X
	sta SPR3_X
	lda #RB1_Y
	sta SPR3_Y
	lda #LL1_X
	sta SPR4_X
	lda #LL1_Y
	sta SPR4_Y
	lda #RR1_X
	sta SPR5_X
	lda #RR1_Y
	sta SPR5_Y
	lda #LF1_X
	sta SPR6_X
	lda #LF1_Y
	sta SPR6_Y
	lda #RF1_X
	sta SPR7_X
	lda #RF1_Y
	sta SPR7_Y

	lda UB      ; set sprite colors for zone 1
	sta SPR0_CL
	lda BUL
	sta SPR2_CL
	lda BRU
	sta SPR3_CL
	lda LBU
	sta SPR4_CL
	lda RUB
	sta SPR5_CL
	lda ULB
	sta SPR6_CL
	lda UBR
	sta SPR7_CL

	ds.b 211,$ea ; wait until start of line $5f

	ds.b 11,$ea  ; wait until a few cycles into the line

	lda #%11111110 ; scan keyboard
	sta $dc00
	lda $dc01
	sta TOPROW0

	lda #%11111101
	sta $dc00
	lda $dc01
	sta TOPROW1

        lda #%11111011
        sta $dc00
        lda $dc01
        sta TOPROW2

        lda #%11110111
        sta $dc00
        lda $dc01
        sta TOPROW3

	lda #%11101111
	sta $dc00
	lda $dc01
	sta TOPROW4

	lda #%11011111
	sta $dc00
	lda $dc01
	sta TOPROW5

        lda #%10111111
        sta $dc00
        lda $dc01
        sta TOPROW6

        lda #%01111111
        sta $dc00
        lda $dc01
        sta TOPROW7

	ds.b 458,$ea ; wait until start of zone 2

	lda BU       ; set sprite colors for zone 2
	sta SPR0_CL

	ds.b 36,$ea  ; wait until start of zone 3

	lda LU       ; set sprite colors for zone 3
	sta SPR4_CL
	lda UL
	sta SPR6_CL
	lda U
	sta SPR0_CL
	lda UR
	sta SPR7_CL
	lda RU
	sta SPR5_CL

	ds.b 113,$ea  ; wait until start of zone 4

	lda #LL2_PV   ; set sprite pointers for left and right faces of zone 4
	sta SPR4_PA
	lda #RR2_PV
	sta SPR5_PA

	lda #LL2_X    ; set sprite positions for left and right faces of zone 4
	sta SPR4_X
	lda #LL2_Y
	sta SPR4_Y
	lda #RR2_X
	sta SPR5_X
	lda #RR2_Y
	sta SPR5_Y

	lda #M2_Y     ; set sprite positions for top face of zone 4
	sta SPR0_Y
	lda #LF2_X
	sta SPR6_X
	lda #LF2_Y
	sta SPR6_Y
	lda #RF2_X
	sta SPR7_X
	lda #RF2_Y
	sta SPR7_Y
	lda #M2_X
	sta SPR0_X

	lda #M2_PV   ; set sprite pointers for top face of zone 4
	sta SPR0_PA
	lda #LF2_PV
	sta SPR6_PA
	lda #RF2_PV
	sta SPR7_PA

	lda #LB2_PV  ; set sprite pointers for zone 5
	sta SPR2_PA
	lda #RB2_PV
	sta SPR3_PA

	lda #LB2_X   ; set sprite positions for zone 5
	sta SPR2_X
	lda #LB2_Y
	sta SPR2_Y
	lda #RB2_X
	sta SPR3_X
	lda #RB2_Y
	sta SPR3_Y

	lda BL       ; set sprite colors for zone 5
	sta SPR2_CL
	lda BR
	sta SPR3_CL

	ds.b 131,$ea ; wait until start of zone 6

	lda LBU      ; set sprite colors for zone 6
	sta SPR6_CL
	lda B
	sta SPR0_CL
	lda RUB
	sta SPR7_CL

	lda LB       ; first row of pixels of zone 6
	sta SPR2_CL

	lda BL

	ds.b 10,$ea
	ldx $ff

	sta SPR2_CL

	lda RB

	ldx $ff

	sta SPR3_CL

	lda BR       ; second row of pixels of zone 6
	sta SPR3_CL

	lda LB
	sta SPR2_CL

	lda BL

	ldx $ff
	ds.b 5,$ea

	sta SPR2_CL

	lda RB

	ldx $ff

	sta SPR3_CL

	lda BR       ; third row of pixels of zone 6
	sta SPR3_CL

	lda LB
	sta SPR2_CL

	lda BL

	ldx $ff
	ds.b 5,$ea

	sta SPR2_CL

	lda RB

	ldx $ff

	sta SPR3_CL

	lda UFL      ; set sprite colors for zone 7
	sta SPR6_CL
	lda UF
	sta SPR0_CL
	lda URF
	sta SPR7_CL
	lda BR
	sta SPR3_CL
	lda LUF
	sta SPR4_CL
	lda RFU
	sta SPR5_CL

	ds.b 120,$ea ; wait until start of zone 8

	lda BLD      ; set sprite colors for zone 9
	sta SPR2_CL
	lda BDR
	sta SPR3_CL

	ds.b 308,$ea ; wait until start of zone 10
	ldx $ff

	lda L        ; set sprite colors for zone 10
	sta SPR6_CL
	lda R
	sta SPR7_CL
	lda BD
	sta SPR0_CL
	lda LDB
	sta SPR2_CL

	lda BLD
	ldx $ff
	ldx RBD
	ds.b 3,$ea
	sta SPR2_CL

	ds.b 2,$ea
	stx SPR3_CL

	lda LDB       ; set sprite colors for left face of zone 11
	sta SPR2_CL
	ds.b 51,$ea   ; wait until start of zone 12

	lda #LL3_Y    ; set sprite positions for left and right faces of zone 12
	sta SPR4_Y
	lda #RR3_Y
	sta SPR5_Y
	lda #LL3_X
	sta SPR4_X
	lda #RR3_X
	sta SPR5_X

	lda #LL3_PV   ; set sprite pointers for left and right faces of zone 12
	sta SPR4_PA
	lda #RR3_PV
	sta SPR5_PA

	ldy RBD       ; set sprite colors for zone 12
	lda DB
	sta SPR0_CL
	lda DRB
	sta SPR3_CL
	lda DBL
	sta SPR2_CL
	ds.b 2,$ea
	sty SPR3_CL
	lda DRB
	sta SPR3_CL

	lda #LF3_Y    ; set sprite positions for front face of zone 13
	sta SPR6_Y
	;lda #RF3_Y
	sta SPR7_Y

	;lda #LF3_X
        ;sta SPR6_X
        ;lda #RF3_X
        ;sta SPR7_X

	lda #LF3_PV   ; set sprite pointers for front face of zone 13
	sta SPR6_PA
        lda #RF3_PV
	sta SPR7_PA

	lda #LB3_Y    ; set sprite positions for D face of zone 13
	sta SPR2_Y
	;lda #RB3_Y
	sta SPR3_Y

	;lda #LB3_X
	;sta SPR2_X
	;lda #RB3_X
	;sta SPR3_X

	lda #LB3_PV   ; set sprite pointers for D face of zone 13
        sta SPR2_PA
        lda #RB3_PV
        sta SPR3_PA

        lda FLU       ; set sprite colors for front face of zone 13
        sta SPR6_CL
        lda FU
      	sta SPR1_CL
        lda FUR
        sta SPR7_CL

        ds.b 230,$ea ; wait for start of zone 14

        lda DL       ; set sprite colors for zone 15
        sta SPR2_CL
        lda DR
        sta SPR3_CL

        ds.b 200,$ea ; wait for start of zone 16

	lda LF       ; set sprite colors for zone 16
	sta SPR4_CL
	lda D
	sta SPR1_CL
	lda RF
	sta SPR5_CL
	lda LFD
	sta SPR6_CL
	lda RDF
	sta SPR7_CL

	lda LD       ; first row of pixels of zone 16
	sta SPR2_CL
	ds.b 7,$ea
	ldx RD
	lda DL
	sta SPR2_CL
	ds.b 3,$ea
        stx SPR3_CL

	lda LD       ; second row of pixels of zone 16
	sta SPR2_CL
	lda DR
	sta SPR3_CL
	ds.b 6,$ea
	ldx RD
	lda DL
	sta SPR2_CL
	ds.b 3,$ea
        stx SPR3_CL

	lda LD       ; third row of pixels of zone 16
	sta SPR2_CL
	lda DR
	sta SPR3_CL
	ds.b 6,$ea
	ldx RD
	lda DL
	sta SPR2_CL
	ds.b 3,$ea
        stx SPR3_CL

        lda DR       ; set sprite colors for zone 17
	sta SPR3_CL
	lda FL
	sta SPR6_CL
	lda F
	sta SPR1_CL
	lda FR
	sta SPR7_CL

	lda #M4_Y     ; set sprite positions for zone 18
	sta SPR0_Y
	lda #M4_X
	sta SPR0_X

	lda #M4_PV    ; set sprite pointers for zone 18
	sta SPR0_PA

	lda F         ; set sprite colors for zone 18
	sta SPR0_CL

        ds.b 130,$ea  ; wait for start of zone 18

	lda DLF       ; set sprite colors for zone 19
	sta SPR2_CL
	lda DFR
	sta SPR3_CL

        ds.b 130,$ea  ; wait for start of zone 19

	lda #LF4_Y    ; set sprite positions for start of zone 19
        sta SPR6_Y
        lda #RF4_Y
        sta SPR7_Y

	lda #LF4_PV   ; set sprite pointers for start of zone 19
	sta SPR6_PA
	lda #RF4_PV
        sta SPR7_PA

        ;lda #LF4_X
        ;sta SPR6_X
        ;lda #RF4_X
        ;sta SPR7_X

	lda #LB4_Y    ; set sprite positions for end of zone 19
        sta SPR2_Y
        lda #RB4_Y
        sta SPR3_Y

	lda #LB4_PV   ; set sprite pointers for end of zone 19
	sta SPR2_PA
	lda #RB4_PV
        sta SPR3_PA

	lda #LL4_Y    ; set sprite positions for zone 20
        sta SPR4_Y
        lda #RR4_Y
        sta SPR5_Y

        lda #LL4_X
        sta SPR4_X
        lda #RR4_X
        sta SPR5_X

	lda #LL4_PV   ; set sprite pointers for zone 20
	sta SPR4_PA
	lda #RR4_PV
        sta SPR5_PA

	lda LFD       ; set sprite colors for zone 20
	sta SPR4_CL
	lda RDF
	sta SPR5_CL
	lda DF
	sta SPR0_CL

        ds.b 60,$ea   ; wait for start of zone 21

	lda FDL       ; set sprite colors for zone 21
	sta SPR6_CL
	lda FRD
	sta SPR7_CL
	lda FD
	sta SPR0_CL

irqh2e	lda #IRQ_OS       ; set interrupt back to top of screen
	sta $d012

	lda <#osirqh
	sta $fffe
	lda >#osirqh
	sta $ffff

	asl $d019

	rti


osirqh	IF DEBUG
	inc $d020
	;ldx TOPROW0
	;stx $4000
	;ldx TOPROW1
	;stx $4001
	;ldx TOPROW2
	;stx $4002
	;ldx TOPROW3
	;stx $4003
	;ldx TOPROW4
	;stx $4004
	;ldx TOPROW5
	;stx $4005
	;ldx TOPROW6
	;stx $4006
        ;ldx TOPROW7
        ;stx $4007
	ENDIF

	ldx #%11111110 ; scan keyboard
	stx $dc00
	ldx $dc01
	stx BOTROW0

	ldx #%11111101
	stx $dc00
	ldx $dc01
	stx BOTROW1

        ldx #%11111011
        stx $dc00
        ldx $dc01
        stx BOTROW2

        ldx #%11110111
        stx $dc00
        ldx $dc01
        stx BOTROW3

	ldx #%11101111
	stx $dc00
	ldx $dc01
	stx BOTROW4

	ldx #%11011111
	stx $dc00
	ldx $dc01
	stx BOTROW5

        ldx #%10111111
        stx $dc00
        ldx $dc01
        stx BOTROW6

        ldx #%01111111
        stx $dc00
        ldx $dc01
        stx BOTROW7

        jsr advgame ; advance game with key pressed in top half of frame

	ldx #7      ; advance game with key pressed in bottom half of frame
cpytkey	lda TOPROW0,x
	sta LSTROW0,x
	lda BOTROW0,x
	sta TOPROW0,x
	dex
	bpl cpytkey

        jsr advgame

	ldx #7      ; keep track of last key pressed
cpybkey	lda BOTROW0,x
	sta LSTROW0,x
	dex
	bpl cpybkey

setirq1	lda #IRQ_S1 ; set interrupt for rendering cube
	sta $d012

	lda <#s1irqh
	sta $fffe
	lda >#s1irqh
	sta $ffff

	asl $d019

	IF DEBUG
	lda STATE
        sta $d020
	ENDIF

	rti

advgame	lda STATE
	cmp #FREE_ST
        bne chkscrm
        jsr free
        jmp endtirq
chkscrm	cmp #SCRM_ST
        bne chkprei
        jsr scrambl
        jmp endtirq
chkprei cmp #PREI_ST
	bne chksolv
        jsr preinsp
        jmp endtirq
chksolv	cmp #SOLV_ST
	bne endtirq
	jsr solve
endtirq	jsr hndlkey
	rts

nmih	rti