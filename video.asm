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
	ld a, [Flags]
	bit 1, a
	jr z, .skip
	push af
	call UpdateBackground1
	call UpdateBackground1
	pop af
	ld hl, Flags
	res 1, [hl]
.skip
	pop de
	pop bc
	pop hl
	pop af
	reti

ShiftLineUp::
	ld hl, BGTransferDataGutter
	ld de, BGTransferData
	ld bc, BGTransferDataEnd - BGTransferData
	call CopyForwards
	ld de, 0
	ld bc, 20
	ld hl, BGTransferDataEnd - 20
	jp SetForwards

ClearScreen::
	ld d, " "
	ld bc, BGTransferDataEnd - BGTransferData
	ld hl, BGTransferData
	jp SetForwards

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
	jp WaitUpdateBackground1