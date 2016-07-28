; Copyright	2016 Henry "wolfboyft" Fleminger Thomson.
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
	call WaitUpdateBackground1
	ld a, h
	ld [Buffer2], a
	ld a, l
	ld [Buffer2 + 1], a
.loop
	call WaitForInput
	ld a, [PressedJoypad]
	and JOY_SELECT
	jr nz, .change
	ld a, [PressedJoypad]
	and JOY_START
	jr z, .loop
	ld a, [Buffer2]
	ld h, a
	ld a, [Buffer2 + 1]
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
	call WaitUpdateBackground1
	jr .loop

.toggleOff
	res 0, [hl]
	ld a, "▶"
	ld [BGTransferData + (SCRN_X_B * 13) + 3], a
	xor a ; ld a, " "
	ld [BGTransferData + (SCRN_X_B * 14) + 3], a
	call WaitUpdateBackground1
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

Error::
	; Work-in-progress.
	halt
	nop
	jr Error