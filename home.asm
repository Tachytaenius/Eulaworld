INCLUDE	"hardware.asm"
INCLUDE "rst.asm"
INCLUDE "bankmacros.asm"
INCLUDE "charmap.asm"
INCLUDE "textmacros.asm"
INCLUDE "constants.asm"

SECTION	"Org $00", HOME[$00]
RST_00:
	ld [Buffer], a
	jp Farcall

SECTION	"Org $08", HOME[$08]
RST_08:
	ld [ROMBank], a
	ld [$2000], a
	ret
	; no need for anything along the lines of jp Bankswitch, it's all here

SECTION	"Org $10", HOME[$10]
RST_10:
	push de
	ld e, a
	ld d, 0
rept 2
	add hl, de
endr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	jp hl

;	SECTION	"Org $18", HOME[$18]
;RST_18:
;	jp	$100

SECTION	"Org $20", HOME[$20]
RST_20:
	push de
	ld e, a
	ld d, 0
rept 2
	add hl, de
endr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ret

;	SECTION	"Org $28", HOME[$28]
;RST_28:
;	jp	$100
;
SECTION	"Org $30", HOME[$30]
RST_30:
	jp	$100

SECTION	"Org $38", HOME[$38]
RST_38:
	jp	$100

SECTION	"V-Blank IRQ Vector", HOME[$40]
VBL_VECT:
	jp VBlank

SECTION	"LCD IRQ Vector", HOME[$48]
LCD_VECT:
	reti

SECTION	"Timer IRQ Vector", HOME[$50]
TIMER_VECT:
	reti

SECTION	"Serial IRQ Vector", HOME[$58]
SERIAL_VECT:
	reti

SECTION	"Joypad IRQ Vector", HOME[$60]
JOYPAD_VECT:
	reti

SECTION	"Start", HOME[$100]
	nop
	jp	Start

	; $0104-$0133 (Nintendo logo - do _not_ modify the logo data here or the GB will not run the program)
	NINTENDO_LOGO

	; $0134-$013E (Game title - up to 11 upper case ASCII characters; pad with $00)
	ds 11
		;0123456789A

	; $013F-$0142 (Product code - 4 ASCII characters, assigned by Nintendo, just leave blank)
	db	"    "
		;0123

	; $0143 (Color GameBoy compatibility code)
	db	$00	; $00 - DMG
			; $80 - DMG/GBC
			; $C0 - GBC Only cartridge

	; $0144 (High-nibble of license code - normally $00 if $014B != $33)
	db	$00

	; $0145 (Low-nibble of license code - normally $00 if $014B != $33)
	db	$00

	; $0146 (GameBoy/Super GameBoy indicator)
	db	$00	; $00 - GameBoy

	; $0147 (Cartridge type - all Color GameBoy cartridges are at least $19)
	db	$1B ; $1B - ROM + MBC5 + RAM + BATT

	; $0148 (ROM size)
	db	$01	; $01 - 512Kbit = 64Kbyte = 4 banks

	; $0149 (RAM size)
	db	$04 ;4 -   1MBit =128kB =16 banks

	; $014A (Destination code)
	db	$01	; $01 - All others
			; $00 - Japan

	; $014B (Licensee code - this _must_ be $33)
	db	$33	; $33 - Check $0144/$0145 for Licensee code.

	; $014C (Mask ROM version - handled by RGBFIX)
	db	$00

	; $014D (Complement check - handled by RGBFIX)
	db	$00

	; $014E-$014F (Cartridge checksum - handled by RGBFIX)
	dw	$00

SECTION "Program Start", HOME[$0150]
Start::
	di
	ld bc, $2000
	ld hl, $C000
	ld de, 0
EmbeddedSetForwards::
	ld a, b
	or c
	jr z, .done
	ld a, d
	ld [hli], a
	dec bc
	jr EmbeddedSetForwards
.done
	ld a, 1
	ld [$2000], a
	ld sp, StackStart
	call StopLCD
	xor a
	ld d, a
	ld bc, $FFFE - $FF80 + 1
	ld hl, $FF80
	call SetForwards
	ld de, WaitDMADoneSource
	ld hl, $FF80
	ld bc, WaitDMADoneSourceEnd - WaitDMADoneSource
	call CopyForwards
	xor a
	ld d, a
	ld bc, $FE9F - $FE00 + 1
	ld hl, $FE00
	call SetForwards
	ld bc, $9FFF - $8000 + 1
	ld hl, $8000
	call SetForwards
	ld a, $e4
	ld [rBGP], a
	xor a
	ld [rSCX], a
	ld [rSCY], a
	ld de, Font
	ld hl, _VRAM
	ld bc, FontEnd - Font
	call CopyDoubleForwards
	call StartLCD
	xor a
	ld [rIF], a
	ld a, 1 ; VBlank
	ld [rIE], a
	ld hl, $C208
	ld a, h
	ld [CursorPos], a
	ld a, l
	ld [CursorPos + 1], a
	ei
	ld de, Text_Eulaworld
	call PrintText
	xor a
	cpl
	ld [DownJoypad], a
	call WaitForStart

Random::
	push bc

	ld a, [rDIV]
	ld b, a
	ld a, [RandomAdd]
	adc b
	ld [RandomAdd], a

	ld a, [rDIV]
	ld b, a
	ld a, [RandomSub]
	sbc b
	ld [RandomSub], a

	pop bc
	ret

Error::
	; Work-in-progress.
	halt
	nop
	jr Error

INCLUDE "farcall.asm"
INCLUDE "joypad.asm"
INCLUDE "update.asm"
INCLUDE "data.asm"
INCLUDE "video.asm"
INCLUDE "misc.asm"
INCLUDE "text.asm"

INCLUDE "memory.asm" ; memory.asm needs to know what RAM type our cartridge has. Said information lies within home.asm.
;*** End Of File ***