; Copyleft 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

LCDBlank::
	push af
	ld a, [rSTAT]
	bit 2, a
	jr z, .skip
.loop
	halt
	nop
	ld a, [rSTAT]
	and %00000011
	jr nz, .loop
	ld a, [rLCDC]
	set 4, a
	ld [rLCDC], a
.skip
	pop af
	reti

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

ControlLCD::
	; load d into rLCDC when appropriate
	ld a, [rLCDC]
	rlca
	jr nc, .skip
.wait
	ld a, [rLY]
	cp 144
	jr c, .wait
.skip
	ld a, d
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

ExtendedTilesOn::
	ld a, [Flags]
	set 2, a
	ld [Flags], a
	
	ld a, [rSTAT]
	set 6, a
	set 3, a
	ld [rSTAT], a
	ld a, [rLCDC]
	res 4, a
	ld [rLCDC], a
	ret

ExtendedTilesOff::
	ld a, [Flags]
	res 2, a
	ld [Flags], a
	
	ld a, [rSTAT]
	res 6, a
	res 3, a
	ld [rSTAT], a
	ld a, [rLCDC]
	set 4, a
	ld [rLCDC], a
	ret

VBlank::
	push af
	push hl
	push bc
	push de
	ld a, [Flags]
	bit 2, a
	jr z, .skip
	ld a, [rLCDC]
	res 4, a
	ld [rLCDC], a
.skip
	ld a, $C0
	call WaitDMADoneDestination
	ld a, [Flags]
	bit 1, a
	jr z, .skip2
	call UpdateBackground
	call UpdateBackground
.skip2
	pop de
	pop bc
	pop hl
	pop af
	reti

ShiftLineUp::
	ld a, [Flags]
	bit 7, a
	jr nz, .skip
	ld a, [ScrollCount]
	inc a
	ld [ScrollCount], a
	cp 18
	call z, .wait
.skip
	ld hl, BGTransferDataGutter
	ld de, BGTransferData
	ld bc, BGTransferDataEnd - BGTransferData
	call CopyForwards
	ld de, 0
	ld bc, 20
	ld hl, BGTransferDataEnd - 20
	jp SetForwards

.wait
	call WaitUpdateBackground
	xor a
	ld [ScrollCount], a
	ld a, 8
	ld [rSCY], a
	call WaitForStart
	xor a
	ld [rSCY], a
	ret

ClearScreen::
	ld d, " "
	ld bc, BGTransferDataEnd - BGTransferData
	ld hl, BGTransferData
	call SetForwards
	jp WaitUpdateBackground

PrintText::
	ld a, [CursorPos]
	ld h, a
	ld a, [CursorPos + 1]
	ld l, a
	xor a
	ld [ScrollCount], a
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
	cp TXT_NEWLINE
	jr nz, .not_newline
.newline
	push de
	call ShiftLineUp
	pop de
	ld hl, $C208
	jr .loop
.not_newline
	cp TXT_DONE
	jr z, .done
	cp TXT_SKIP
	jr z, .skip
	ld [hli], a
	jr .loop

.done
	ld a, h
	ld [CursorPos], a
	ld a, l
	ld [CursorPos + 1], a
	ld hl, Flags
	bit 4, [hl]
	jp z, WaitUpdateBackground
	ret