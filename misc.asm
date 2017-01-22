; Copyleft 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

Font::
	INCBIN "font.1bpp"
FontEnd::

DualMenu::
	xor a
	ld [MenuSelection], a
	ld a, "▶"
	ld [BGTransferData + (SCRN_X_B * 13) + 3], a
	call WaitUpdateBackground
	ld a, h
	ld [Buffer + 3], a
	ld a, l
	ld [Buffer + 4], a
.loop
	call WaitForInput
	ld a, [Flags]
	bit 6, a
	jr nz, .skip
	call SeedRandom2_
	ld a, [Flags]
	set 7, a
	ld [Flags], a

.skip
	ld a, [PressedJoypad]
	and JOY_SELECT
	jr nz, .change
	ld a, [PressedJoypad]
	and JOY_START
	jr z, .loop
	ld a, [Buffer + 3]
	ld h, a
	ld a, [Buffer + 4]
	ld l, a
	ld a, [MenuSelection]
	jp JumpTable

.change
	ld hl, MenuSelection
	bit 0, [hl]
	jr nz, .toggleOff
	set 0, [hl]
	ld a, "▶"
	ld [BGTransferData + (SCRN_X_B * 14) + 3], a
	xor a ; ld a, " "
	ld [BGTransferData + (SCRN_X_B * 13) + 3], a
	call WaitUpdateBackground
	jr .loop

.toggleOff
	res 0, [hl]
	ld a, "▶"
	ld [BGTransferData + (SCRN_X_B * 13) + 3], a
	xor a ; ld a, " "
	ld [BGTransferData + (SCRN_X_B * 14) + 3], a
	call WaitUpdateBackground
	jr .loop

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

Dead::
	ld de, Text_GameOver
	call PrintText
Error::
	; Work-in-progress.
	halt
	nop
	jr Error

Text_GameOver::
	text "Game over!"
	linedone

SbcHlBc::
	push bc
	push af
	ld a, b
	cpl
	ld b, a
	ld a, c
	cpl
	ld c, a
	inc bc
	call c, .carry
	pop af
	add hl, bc
	pop bc
	ret

.carry
	inc bc
	ret

Random2::
; Based off the following C/C++ routine found at https://en.wikipedia.org/wiki/Xorshift#Example_implementation
;
; #include <stdint.h>
; 
; /* These state variables must be initialized so that they are not all zero. */
; uint32_t x, y, z, w;
; 
; uint32_t xorshift128(void) {
;     uint32_t t = x;
;     t ^= t << 11;
;     t ^= t >> 8;
;     x = y; y = z; z = w;
;     w ^= w >> 19;
;     w ^= t;
;     return w;
; }
;
; Where:
; t is b
; x is c
; y is d
; z is e
; w is h
;
; and the amount of shifting is less.
	; Backup all registers.
	push af
	push bc
	push de
	push hl
	
	; Load values.
	ld a, [SeedB]
	ld b, a
	ld a, [SeedC]
	ld c, a
	ld a, [SeedD]
	ld d, a
	ld a, [SeedE]
	ld e, a
	ld a, [SeedH]
	ld h, a

	; t = x
	ld b, c

	; t = t ^ (t << 11)
	ld a, b
	sla a
	sla a
	sla a
	sla a
	xor b
	ld b, a

	; t = t ^ (t >> 8)
;	ld a, b
	srl a
	srl a
	srl a
	xor b
	ld b, a

	; x = y
	ld c, d

	; y = z
	ld d, e

	; z = w
	ld e, h

	; w ^= w >> 19
	ld a, h
	sla a
	sla a
	sla a
	sla a
	sla a
	xor h
	ld h, a

	; w ^= t
	ld a, b
	xor h
	ld h, a

	; Save values.
	ld a, b
	ld [SeedB], a
	ld a, c
	ld [SeedC], a
	ld a, d
	ld [SeedD], a
	ld a, e
	ld [SeedE], a
	ld a, h
	ld [SeedH], a
	
	; Retrieve register backups.
	pop hl
	pop de
	pop bc
	pop af
	ret