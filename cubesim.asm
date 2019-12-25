	processor 6502
	org $0800

DEBUG	EQU 0

	include "spritesymbols.asm"	
	include "cubesymbols.asm"
	include "vicsymbols.asm"
	include "gamesymbols.asm"
	include "keysymbols.asm"

	; basic launcher
	hex 00 0c 08 de  07 9e 20 32  30 36 32 00  00 00

	; setup
	include "setup.asm"
	
loop	jmp loop

	; irq handler
	include "irqhandler.asm"

	; key handler
	include "keyhandler.asm"

	; cube routines
	include "cube.asm"

	; game control
	include "gamecontrol.asm"

	; statistics
	include "stats.asm"

	; text data
	include "textdata.asm"

	; sprite data
sprites	include "spritedata.asm"
	; background data
cubebg	incbin "CubeBackgroundMonoShifted.prg"	