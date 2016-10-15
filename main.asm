; Copyright 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

PreMainLoop::
	call GetXYZAddressInHLAndChangeBank
	call DescribeSector
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
	jr z, MainLoop
	call Help
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
	jp PreMainLoop

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
	ld hl, Flags
	set 4, [hl]
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

	ld a, [XYZ]
	and COORD_Z
	cp 10
	jr nc, .double_figures
	ld de, Buffer2 + 1
	call PrintText
	ld hl, Flags
	res 4, [hl]
	ld de, .text3
	jp PrintText

.double_figures
	ld de, Buffer2
	call PrintText
	ld hl, Flags
	res 4, [hl]
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
	call .common
	ld a, 4
	ld [WRAMBank], a
	ld [rSVBK], a
	ret

.first_quarter
	ld h, 0
	ld l, a
	call .common
	ld a, 1
	ld [WRAMBank], a
	ld [rSVBK], a
	ret

.second_quarter
	sub 64
	ld h, 0
	ld l, a
	call .common
	ld a, 2
	ld [WRAMBank], a
	ld [rSVBK], a
	ret

.third_quarter
	sub 128
	ld h, 0
	ld l, a
	call .common
	ld a, 3
	ld [WRAMBank], a
	ld [rSVBK], a
	ret

.common
REPT 6
	add hl, hl ; Multiply by 64 by shifting left 6 times.
ENDR
	ld bc, $D000
	add hl, bc
	ret

HelpTable:: ; 0 - 13
	dw HelpIndex
	dw BasicPlay
	dw Inventory
	dw Resources
	dw Building
	dw Combat
	dw Exploring
	dw Crafting
	dw TheAbyss
	dw Bestiary
	dw Villages
	dw Occupation
	dw MiscTips
	dw StoryPlay

Help::
	xor a
	ld [MenuSelection], a
	jr HelpIndex

HelpLoop::
	call WaitForInput
	ld a, [PressedJoypad]
	and JOY_LEFT
	jr nz, .left
	ld a, [PressedJoypad]
	and JOY_RIGHT
	jr nz, .right
	ld a, [PressedJoypad]
	and JOY_B
	jr nz, .quit
	jr HelpLoop

.quit
	call ClearScreen
	call GetXYZAddressInHLAndChangeBank
	jp DescribeSector

.left
	ld a, [MenuSelection]
	cp 0
	jr z, .wrapToEnd
	dec a
	jr .do

.wrapToEnd
	ld a, 13
	jr .do

.wrapToStart
	ld a, 0
	jr .do

.right
	ld a, [MenuSelection]
	cp 13
	jr z, .wrapToStart
	inc a

.do
	ld [MenuSelection], a
	ld hl, HelpTable
	jp JumpTable

HelpIndex::
	call ClearScreen
	ld de, Text_HelpIndex
	call PrintText
	jr HelpLoop

BasicPlay::
	call ClearScreen
	ld de, Text_BasicPlay
	call PrintText
	jr HelpLoop

Inventory::
Resources::
Building::
Combat::
Exploring::
Crafting::
TheAbyss::
Bestiary::
Villages::
Occupation::
MiscTips::
StoryPlay::
	call ClearScreen
	ld de, Text_StoryPlay
	call PrintText
	jr HelpLoop

DescribeSector::
	ld a, [Flags]
	set 4, a
	ld [Flags], a

	; Dealing with the biome.
	ld a, [XYZ]
	bit 7, a
	ld a, [hl]
	jr z, .skip
	or %00001000
.skip
	push hl
	push af
	ld de, Text_YouAreIn
	call PrintText
	pop af
	ld hl, .biome_table
	jp JumpTable ; HL is popped later.

.biome_table
	dw .plains
	dw .forest
	dw .sand
	dw .ice
	dw .savanna
	dw .ocean
	dw .jungle
	dw .heaven
	dw .diorite
	dw .limestone
	dw .obsidian
	dw .ice_
	dw .granite
	dw .ocean_
	dw .andesite
	dw .hell

.plains
	pop hl
	ld de, Text_Plains
	call PrintText
	jp .cont

.forest
	pop hl
	ld de, Text_Forest
	call PrintText
	jr .cont

.sand
	pop hl
	ld de, Text_Sand
	call PrintText
	jr .cont

.ice
	pop hl
	ld de, Text_Ice
	call PrintText
	jr .cont

.savanna
	pop hl
	ld de, Text_Savanna
	call PrintText
	jr .cont

.ocean
	pop hl
	ld de, Text_Ocean
	call PrintText
	jr .cont

.jungle
	pop hl
	ld de, Text_Jungle
	call PrintText
	jr .cont

.heaven
	pop hl
	ld de, Text_Heaven
	call PrintText
	jr .cont

.diorite
	pop hl
	ld de, Text_Diorite
	call PrintText
	jr .cont

.limestone
	pop hl
	ld de, Text_Limestone
	call PrintText
	jr .cont

.obsidian
	pop hl
	ld de, Text_Obsidian
	call PrintText
	jr .cont

.ice_
	pop hl
	ld de, Text_Ice_
	call PrintText
	jr .cont

.granite
	pop hl
	ld de, Text_Granite
	call PrintText
	jr .cont

.ocean_
	pop hl
	ld de, Text_Ocean_
	call PrintText
	jr .cont

.andesite
	pop hl
	ld de, Text_Andesite
	call PrintText
	jr .cont

.hell
	pop hl
	ld de, Text_Hell
	call PrintText

.cont
	ld a, [Flags]
	res 4, a
	ld [Flags], a
	call WaitUpdateBackground
	ret

Text_YouAreIn::
	text "You are in "
	done

Text_Plains::
	text "a field."
	linedone

Text_Forest::
	text "a forest."
	done

Text_Sand::
	text "a sandy"
	line "desert."
	linedone

Text_Ice::
	text "an icy"
	line "desert."
	linedone

Text_Savanna::
	text "a dry"
	line "savanna."
	linedone

Text_Ocean::
	text "the sea."
	linedone

Text_Jungle::
	text "a jungle."
	done

Text_Heaven::
	text "an aether"
	text "biome."
	linedone

Text_Diorite::
	text "a diorite"
	text "cave."
	linedone

Text_Limestone::
	text "a limest-"
	line "one cave."
	linedone

Text_Obsidian::
	text "an obsid-"
	text "ian cave."
	linedone

Text_Ice_::
	text "an ice"
	line "cave."
	linedone

Text_Granite::
	text "a granite"
	text "cave."
	linedone

Text_Ocean_::
	text "the deep"
	line "ocean."
	linedone

Text_Andesite::
	text "an andes-"
	text "ite cave."
	linedone

Text_Hell::
	text "a nether"
	line "biome."
	linedone