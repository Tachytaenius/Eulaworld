;****************************************************************************************************************************************************
;*	Blank Simple Source File
;*
;****************************************************************************************************************************************************
;*
;*
;****************************************************************************************************************************************************

;****************************************************************************************************************************************************
;*	Includes
;****************************************************************************************************************************************************
	; system includes
	INCLUDE	"hardware.inc"
	; project includes
	INCLUDE "rst.asm"
	INCLUDE "bankmacros.asm"
	INCLUDE "charmap.asm"
	INCLUDE "textmacros.asm"

;****************************************************************************************************************************************************
;*	user data (constants)
;****************************************************************************************************************************************************


;****************************************************************************************************************************************************
;*	equates
;****************************************************************************************************************************************************


;****************************************************************************************************************************************************
;*	cartridge header
;****************************************************************************************************************************************************

	SECTION	"Org $00",HOME[$00]
RST_00:
	ld [Buffer], a
	jp Farcall

	SECTION	"Org $08",HOME[$08]
RST_08: 
	ld [ROMBank], a
	ld [$2000], a
	ret
	; no need for anything along the lines of jp Bankswitch, it's all here

	SECTION	"Org $10",HOME[$10]
RST_10:
	jp	$100

	SECTION	"Org $18",HOME[$18]
RST_18:
	jp	$100

	SECTION	"Org $20",HOME[$20]
RST_20:
	jp	$100

	SECTION	"Org $28",HOME[$28]
RST_28:
	jp	$100

	SECTION	"Org $30",HOME[$30]
RST_30:
	jp	$100

	SECTION	"Org $38",HOME[$38]
RST_38:
	jp	$100

	SECTION	"V-Blank IRQ Vector",HOME[$40]
VBL_VECT:
	jp VBlank
	
	SECTION	"LCD IRQ Vector",HOME[$48]
LCD_VECT:
	reti

	SECTION	"Timer IRQ Vector",HOME[$50]
TIMER_VECT:
	reti

	SECTION	"Serial IRQ Vector",HOME[$58]
SERIAL_VECT:
	reti

	SECTION	"Joypad IRQ Vector",HOME[$60]
JOYPAD_VECT:
	reti

	SECTION	"Start",HOME[$100]
	nop
	jp	Start

	; $0104-$0133 (Nintendo logo - do _not_ modify the logo data here or the GB will not run the program)
	NINTENDO_LOGO

	; $0134-$013E (Game title - up to 11 upper case ASCII characters; pad with $00)
	ds 11
		;0123456789A

	; $013F-$0142 (Product code - 4 ASCII characters, assigned by Nintendo, just leave blank)
	DB	"    "
		;0123

	; $0143 (Color GameBoy compatibility code)
	DB	$00	; $00 - DMG 
			; $80 - DMG/GBC
			; $C0 - GBC Only cartridge

	; $0144 (High-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0145 (Low-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0146 (GameBoy/Super GameBoy indicator)
	DB	$00	; $00 - GameBoy

	; $0147 (Cartridge type - all Color GameBoy cartridges are at least $19)
	DB	$19	; $19 - ROM + MBC5

	; $0148 (ROM size)
	DB	$01	; $01 - 512Kbit = 64Kbyte = 4 banks

	; $0149 (RAM size)
	DB	$00	; $00 - None

	; $014A (Destination code)
	DB	$00	; $01 - All others
			; $00 - Japan

	; $014B (Licensee code - this _must_ be $33)
	DB	$33	; $33 - Check $0144/$0145 for Licensee code.

	; $014C (Mask ROM version - handled by RGBFIX)
	DB	$00

	; $014D (Complement check - handled by RGBFIX)
	DB	$00

	; $014E-$014F (Cartridge checksum - handled by RGBFIX)
	DW	$00


;****************************************************************************************************************************************************
;*	Program Start
;****************************************************************************************************************************************************

SECTION "Program Start",HOME[$0150]

Farcall::
; Call a:hl.
; Preserves other registers.
; The true start of the routine is at RST_00.
	ld a, [ROMBank]
	push af
	ld a, [Buffer]
	rst BankSwitch
	call JumpHL
	ld a, b
	ld [Buffer], a
	ld a, c
	ld [Buffer + 1], a
	pop bc
	ld a, b
	rst BankSwitch
	ld a, [Buffer]
	ld b, a
	ld a, [Buffer + 1]
	ld c, a
	ret
JumpHL::
	jp hl

Start::
	di
	ld bc, $2000
	ld hl, $C000
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
	ld de, Text_HelloWorld
	ld hl, $9800+3+(SCRN_VY_B*7)
	ld bc, Text_HelloWorldEnd - Text_HelloWorld
	call CopyForwards
	call StartLCD
	xor a
	ld [rIF], a
	ld a, 1 ; VBlank
	ld [rIE], a
	ei

MainLoop::
	halt
	nop
	jp MainLoop

PrintText::
	; Text stack address, preferably TextStack, in bc.
	; Text to write in de.
	ld a, [de]
	
	ret

Text_HelloWorld::
	db ""
Text_HelloWorldEnd::

SetForwards::
	;set bc bytes forward from hl to d
	ld a, b
	or c
	ret z
	ld a, d
	ld [hli], a
	dec bc
	jr SetForwards

CopyForwards::
	;copy bc bytes forward from de to hl
	ld a, b
	or c
	ret z
	ld a, [de]
	inc de
	ld [hli], a
	dec bc
	jr CopyForwards
	
CopyDoubleForwards::
	;copy bc bytes forward from de to hl, twice for each byte
	ld a, b
	or c
	ret z
	ld a, [de]
	inc de
	ld [hli], a
	ld [hli], a
	dec bc
	jr CopyDoubleForwards

;	CopyBackwards::
;		;copy bc bytes backward from hl to de
;		ld a, b
;		or c
;		ret z
;		ld a, [hld]
;		ld [de], a
;		dec de
;		inc bc
;		jr CopyBackwards

StopLCD::
	ld a, [rLCDC]
	rlca
	ret nc
.wait
	ld a, [rLY]
	cp 144
	jr c, .wait
	ld a, [rLCDC]
	res 7, a
	ld [rLCDC], a
	ret

StartLCD::
	ld a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ16|LCDCF_OBJOFF
	ld [rLCDC], a
	ret

WaitDMADoneSource::
	ld [$FF46], a
	ld a, $28
.wait
	dec a
	jr nz, .wait
	ret
WaitDMADoneSourceEnd::

VBlank::
	push af
	push hl
	push bc
	push de
	ld a, $C0
	call WaitDMADoneDestination
	ld de, BGTransferData
	pop de
	pop bc
	pop hl
	pop af
	reti
VBlankEnd::

Font::
	INCBIN "font.1bpp"
FontEnd::
;*** End Of File ***