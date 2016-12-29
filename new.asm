; Copyleft 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

NewGame::
	call GenerateWorld
	call ClearScreen
	ld a, 7 | (3 << 4)
	ld [XYZ], a
	ld de, Text_GameStart
	call PrintText
	ld a, 1
	ld [WRAMBank], a
	ld [rSVBK], a
	ld a, 64
	ld [Time], a
	ld hl, Flags
	set 4, [hl]
	jp PreMainLoop

Text_GameStart::
	text "Push start for help."
	done

GenerateWorld::
	ld a, 1
	ld [WRAMBank], a
	ld [rSVBK], a
	call GenerateBank
	ld a, 2
	ld [WRAMBank], a
	ld [rSVBK], a
	call GenerateBank
	ld a, 3
	ld [WRAMBank], a
	ld [rSVBK], a
	call GenerateBank
	ld a, 4
	ld [WRAMBank], a
	ld [rSVBK], a
	jp GenerateBank

GenerateBank::
	ld d, 0
	ld hl, $D000
	ld bc, $1000
	call SetForwards
	ld de, 64
	ld bc, 64
	ld hl, $D000
	call RandomFillForwardsSkipChunk_DivideBy8
	ld bc, 64
	ld hl, $D002
	call RandomSetBit0ForwardsSkipChunk_Threshold10
	ld de, 64
	ld bc, 64
	ld hl, $D003
	call RandomFillForwardsSkipChunk_DivideBy8
	ld de, 64
	ld bc, 65
	ld hl, $D004
	call RandomFillForwardsSkipChunk
	ld de, 64
	ld bc, 64
	ld hl, $D005
	call RandomFillForwardsSkipChunk_DivideBy8
	ld de, 64
	ld bc, 65
	ld hl, $D006
	jp RandomFillForwardsSkipChunk