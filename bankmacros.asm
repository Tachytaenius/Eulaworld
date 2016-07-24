farcall: MACRO
	ld a, BANK(\1)
	ld hl, \1
	rst FarCall
	ENDM