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

	INCLUDE	"hardware.asm"
	INCLUDE "rst.asm"
	INCLUDE "bankmacros.asm"
	INCLUDE "charmap.asm"
	INCLUDE "textmacros.asm"
	INCLUDE "constants.asm"

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
	jp [hl]

;	SECTION	"Org $18",HOME[$18]
;RST_18:
;	jp	$100

	SECTION	"Org $20",HOME[$20]
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

;	SECTION	"Org $28",HOME[$28]
;RST_28:
;	jp	$100
;
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
	DB	$1B ; $1B - ROM + MBC5 + RAM + BATT

	; $0148 (ROM size)
	DB	$01	; $01 - 512Kbit = 64Kbyte = 4 banks

	; $0149 (RAM size)
	DB	$04 ;4 -   1MBit =128kB =16 banks

	; $014A (Destination code)
	DB	$01	; $01 - All others
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
MainLoop::
	ld de, Text_HelloWorld1
	call PrintText
	call WaitForA
	ld de, Text_HelloWorld2
	call PrintText
	call WaitForA
	ld de, Text_HelloWorld3
	call PrintText
.Finished
	halt
	nop
	jp .Finished

WaitForA::
	call GetJoypad
	ld a, [ReleasedJoypad]
	and JOY_A
	jr z, WaitForA
.loop
	call GetJoypad
	ld a, [PressedJoypad]
	and JOY_A
	jr z, .loop
	ret

UpdateBackground1::
	ld bc, SCRN_X_B
	ld hl, .table
	ld a, [NextDrawLine]
	rst JumpTable
	ret
.one
	ld hl, $9800 + (SCRN_X_B * 0) + (12 * 0)
	ld de, BGTransferData + (SCRN_X_B * 0)
	call CopyForwards
	ld a, 1
	ld [NextDrawLine], a
	ret
.two
	ld hl, $9800 + (SCRN_X_B * 1) + (12 * 1)
	ld de, BGTransferData + (SCRN_X_B * 1)
	call CopyForwards
	ld a, 2
	ld [NextDrawLine], a
	ret
.three
	ld hl, $9800 + (SCRN_X_B * 2) + (12 * 2)
	ld de, BGTransferData + (SCRN_X_B * 2)
	call CopyForwards
	ld a, 3
	ld [NextDrawLine], a
	ret
.four
	ld hl, $9800 + (SCRN_X_B * 3) + (12 * 3)
	ld de, BGTransferData + (SCRN_X_B * 3)
	call CopyForwards
	ld a, 4
	ld [NextDrawLine], a
	ret
.five
	ld hl, $9800 + (SCRN_X_B * 4) + (12 * 4)
	ld de, BGTransferData + (SCRN_X_B * 4)
	call CopyForwards
	ld a, 5
	ld [NextDrawLine], a
	ret
.six
	ld hl, $9800 + (SCRN_X_B * 5) + (12 * 5)
	ld de, BGTransferData + (SCRN_X_B * 5)
	call CopyForwards
	ld a, 6
	ld [NextDrawLine], a
	ret
.seven
	ld hl, $9800 + (SCRN_X_B * 6) + (12 * 6)
	ld de, BGTransferData + (SCRN_X_B * 6)
	call CopyForwards
	ld a, 7
	ld [NextDrawLine], a
	ret
.eight
	ld hl, $9800 + (SCRN_X_B * 7) + (12 * 7)
	ld de, BGTransferData + (SCRN_X_B * 7)
	call CopyForwards
	ld a, 8
	ld [NextDrawLine], a
	ret
.nine
	ld hl, $9800 + (SCRN_X_B * 8) + (12 * 8)
	ld de, BGTransferData + (SCRN_X_B * 8)
	call CopyForwards
	ld a, 9
	ld [NextDrawLine], a
	ret
.ten
	ld hl, $9800 + (SCRN_X_B * 9) + (12 * 9)
	ld de, BGTransferData + (SCRN_X_B * 9)
	call CopyForwards
	ld a, 10
	ld [NextDrawLine], a
	ret
.eleven
	ld hl, $9800 + (SCRN_X_B * 10) + (12 * 10)
	ld de, BGTransferData + (SCRN_X_B * 10)
	call CopyForwards
	ld a, 11
	ld [NextDrawLine], a
	ret
.twelve
	ld hl, $9800 + (SCRN_X_B * 11) + (12 * 11)
	ld de, BGTransferData + (SCRN_X_B * 11)
	call CopyForwards
	ld a, 12
	ld [NextDrawLine], a
	ret
.thirteen
	ld hl, $9800 + (SCRN_X_B * 12) + (12 * 12)
	ld de, BGTransferData + (SCRN_X_B * 12)
	call CopyForwards
	ld a, 13
	ld [NextDrawLine], a
	ret
.fourteen
	ld hl, $9800 + (SCRN_X_B * 13) + (12 * 13)
	ld de, BGTransferData + (SCRN_X_B * 13)
	call CopyForwards
	ld a, 14
	ld [NextDrawLine], a
	ret
.fifteen
	ld hl, $9800 + (SCRN_X_B * 14) + (12 * 14)
	ld de, BGTransferData + (SCRN_X_B * 14)
	call CopyForwards
	ld a, 15
	ld [NextDrawLine], a
	ret
.sixteen
	ld hl, $9800 + (SCRN_X_B * 15) + (12 * 15)
	ld de, BGTransferData + (SCRN_X_B * 15)
	call CopyForwards
	ld a, 16
	ld [NextDrawLine], a
	ret
.seventeen
	ld hl, $9800 + (SCRN_X_B * 16) + (12 * 16)
	ld de, BGTransferData + (SCRN_X_B * 16)
	call CopyForwards
	ld a, 17
	ld [NextDrawLine], a
	ret
.eighteen
	ld hl, $9800 + (SCRN_X_B * 17) + (12 * 17)
	ld de, BGTransferData + (SCRN_X_B * 17)
	call CopyForwards
	ld a, 0
	ld [NextDrawLine], a
	ret

.table
	dw .one
	dw .two
	dw .three
	dw .four
	dw .five
	dw .six
	dw .seven
	dw .eight
	dw .nine
	dw .ten
	dw .eleven
	dw .twelve
	dw .thirteen
	dw .fourteen
	dw .fifteen
	dw .sixteen
	dw .seventeen
	dw .eighteen

Error::
	; Work-in-progress.
	halt
	nop
	jr Error

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
	call UpdateBackground1
	pop de
	pop bc
	pop hl
	pop af
	reti
VBlankEnd::

Font::
	INCBIN "font.1bpp"
FontEnd::

GetJoypad::
	ld a, %00100000
	ld [rP1], a
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	and $0F
	swap a
	ld b, a
	ld a, %00010000
	ld [rP1], a
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	and $0F
	or b
	cpl
	
	ld d, a
	
	ld b, a
	ld a, [DownJoypad]
	cpl
	and b
	ld [PressedJoypad], a
	
	ld hl, Flags
	bit 0, [hl]
	jr z, .skip
	
	ld a, [DownJoypad]
	ld b, a
	ld a, d
	cpl
	and b
	ld a, b
	ld [ReleasedJoypad], a
	ld a, d
	ld [DownJoypad], a
	ret

.skip
	set 0, [hl]
	ld a, $FF
	ld [ReleasedJoypad], a
	ret

PrintText::
	ld a, [CursorPos]
	ld h, a
	ld a, [CursorPos + 1]
	ld l, a
.loop
	ld a, h
	cp $C2
	jr nz, .skip
	ld a, l
	cp $1C
	jr z, .newline
.skip
	ld a, [de]
	inc de
	cp $60
	jr nz, .not_newline
.newline
	push de
	call ShiftLineUp
	pop de
	ld hl, $C208
	jr .loop
.not_newline
	cp $61
	jr z, .done
	ld [hli], a
	jr .loop

.done
	ld a, h
	ld [CursorPos], a
	ld a, l
	ld [CursorPos + 1], a
	ret

ShiftLineUp::
	ld hl, BGTransferDataGutter
	ld de, BGTransferData
	ld bc, BGTransferDataEnd - BGTransferData
	call CopyForwards
	ld de, 0
	ld bc, 20
	ld hl, BGTransferDataEnd - 20
	jp SetForwards

INCLUDE "text.asm"

INCLUDE "memory.asm" ; This file needs to know what RAM type our cartridge has.
;*** End Of File ***