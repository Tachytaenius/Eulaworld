; Copyright 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

PreMainLoop::
	call GetXYZAddressInHLAndChangeBank
MainLoop::
	call WaitForInput
	ld a, [PressedJoypad]
	and JOY_UP
	jr nz, .MoveNorth
	ld a, [PressedJoypad]
	and JOY_DOWN
	jr nz, .MoveSouth
	ld a, [PressedJoypad]
	and JOY_LEFT
	jr nz, .MoveWest
	ld a, [PressedJoypad]
	and JOY_RIGHT
	jr nz, .MoveEast
	ld a, [PressedJoypad]
	and JOY_A
	call nz, PrintPosition
	ld a, [PressedJoypad]
	and JOY_B
	call nz, .ThisButtonDoesNothingYet
	ld a, [PressedJoypad]
	and JOY_SELECT
	call nz, .ThisButtonDoesNothingYet
	ld a, [PressedJoypad]
	and JOY_START
	call nz, .ThisButtonDoesNothingYet
	jr MainLoop

.ThisButtonDoesNothingYet	
	ld de, Text_ThisButtonDoesNothingYet
	jp PrintText

.MoveNorth
	ld a, [XYZ]
	and COORD_Z ; a is no longer garuanteed to be XYZ, so we reload it after the conditional jump.
	jr z, .end
	ld a, [XYZ]
	sub %00000001
	ld [XYZ], a
	ld de, Text_North
	call PrintText
	jr PreMainLoop

.MoveSouth
	ld a, [XYZ]
	and COORD_Z ; a is no longer garuanteed to be XYZ, so we reload it after the conditional jump.
	cp COORD_Z
	jr z, .end
	ld a, [XYZ]
	add %00000001
	ld [XYZ], a
	ld de, Text_South
	call PrintText
	jr PreMainLoop

.MoveWest
	ld a, [XYZ]
	and COORD_X ; a is no longer garuanteed to be XYZ, so we reload it after the conditional jump.
	jr z, .end
	ld a, [XYZ]
	sub %00010000
	ld [XYZ], a
	ld de, Text_West
	call PrintText
	jp PreMainLoop

.MoveEast
	ld a, [XYZ]
	and COORD_X ; a is no longer garuanteed to be XYZ, so we reload it after the conditional jump.
	cp COORD_X
	jr z, .end
	ld a, [XYZ]
	add %00010000
	ld [XYZ], a
	ld de, Text_East
	call PrintText
	jp PreMainLoop

.end
	ld de, Text_WorldEnd
	call PrintText
	jp PreMainLoop

Text_North::
	text "You move north."
	linedone

Text_South::
	text "You move south."
	linedone

Text_West::
	text "You move west."
	linedone

Text_East::
	text "You move east."
	linedone

Text_WorldEnd::
	text "You cannot go any"
	line "further."
	linedone

PrintPosition::
	ld a, $61
	ld [MiniBuffer2], a
	ld a, [XYZ]
	and COORD_X
	rlca
	rlca
	rlca
	rlca
	ld de, MiniBuffer
	call ConvertNumberA
	ld de, .text1
	call PrintText
	ld de, Buffer2 + 1
	call PrintText
	ld a, [XYZ]
	and COORD_Z
	ld de, MiniBuffer
	call ConvertNumberA
	ld de, .text2
	call PrintText
	ld de, Buffer2
	call PrintText
	ld de, .text3
	jp PrintText

.text1
	text "X = "
	done

.text2
	text ", Z = "
	done

.text3
	text "."
	linedone

Text_ThisButtonDoesNothingYet::
	text "This button does"
	line "nothing yet."
	linedone

GetXYZAddressInHLAndChangeBank::
	ld a, [XYZ]
	cp 64
	jr c, .first_quarter
	cp 128
	jr c, .second_quarter
	cp 192
	jr c, .third_quarter

;.fourth_quarter
	sub 192
	ld h, 0
	ld l, a
REPT 6
	add hl, hl ; Multiply by 64 by shifting left 6 times.
ENDR
	ld bc, $D000
	add hl, bc
	ld a, 4
	ld [WRAMBank], a
	ld [rSVBK], a
	ret

.first_quarter
	ld h, 0
	ld l, a
REPT 6
	add hl, hl ; Multiply by 64 by shifting left 6 times.
ENDR
	ld bc, $D000
	add hl, bc
	ld a, 1
	ld [WRAMBank], a
	ld [rSVBK], a
	ret

.second_quarter
	sub 64
	ld h, 0
	ld l, a
REPT 6
	add hl, hl ; Multiply by 64 by shifting left 6 times.
ENDR
	ld bc, $D000
	add hl, bc
	ld a, 2
	ld [WRAMBank], a
	ld [rSVBK], a
	ret

.third_quarter
	sub 128
	ld h, 0
	ld l, a
REPT 6
	add hl, hl ; Multiply by 64 by shifting left 6 times.
ENDR
	ld bc, $D000
	add hl, bc
	ld a, 3
	ld [WRAMBank], a
	ld [rSVBK], a
	ret