WaitUpdateBackground1::
	push hl
rept 9
	ld hl, Flags
	set 1, [hl]
	halt
	nop
	halt
	nop
endr
	pop hl
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
