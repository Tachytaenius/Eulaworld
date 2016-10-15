; Copyright 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

NewGame::
	ld bc, $1000
	ld de, TestMap
	ld hl, $D000
	call CopyForwards
	call ClearScreen
	ld a, 7 | (3 << 4)
	ld [XYZ], a
	ld de, Text_GameStart
	call PrintText
	jp PreMainLoop

Text_GameStart::
	text "Push start for help."
	done

TestMap::
REPT 64
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
ENDR