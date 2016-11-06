; Copyright 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

PreMainLoop::
	call GetXYZAddressInHLAndChangeBank
	call DescribeSector
	call Time_NoClock
	call WaitUpdateBackground
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
	jp nz, .MoveEast
	ld a, [PressedJoypad]
	and JOY_A
	call nz, PrintPositionAndTime
	ld a, [PressedJoypad]
	and JOY_B
	call nz, .ThisButtonDoesNothingYet
	ld a, [PressedJoypad]
	and JOY_SELECT
	jp nz, .ToggleDepth
	ld a, [PressedJoypad]
	and JOY_START
	jr z, MainLoop
	call Help
	jr MainLoop

.ThisButtonDoesNothingYet
	ld de, Text_ThisButtonDoesNothingYet
	call PrintText
	jp WaitUpdateBackground

.MoveNorth
	ld a, [XYZ]
	and COORD_Z ; a is no longer garuanteed to be XYZ, so we reload it after the conditional jump.
	jp z, .end
	ld a, [XYZ]
	sub %00000001
	ld [XYZ], a
	ld de, Text_North
	call PrintText
	ld bc, 14
	call ForwardTime
	call TickWorld
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
	ld bc, 14
	call ForwardTime
	call TickWorld
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
	ld bc, 14
	call ForwardTime
	call TickWorld
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
	ld bc, 14
	call ForwardTime
	call TickWorld
	jp PreMainLoop

.end
	ld de, Text_WorldEnd
	call PrintText
	call WaitUpdateBackground
	jp MainLoop

.ToggleDepth
	call GetXYZAddressInHLAndChangeBank
	inc hl
	inc hl
	ld a, [XYZ]
	bit 7, a
	jr nz, .underground
	bit 0, [hl]
	jr nz, .yes_overground
;.no_overground
	ld de, Text_NoSurface
	call PrintText
	call WaitUpdateBackground
	jp MainLoop

.yes_overground
	ld de, Text_YesSurface
	call PrintText
	ld a, [XYZ]
	set 7, a
	ld [XYZ], a
	ld bc, 5
	call ForwardTime
	call TickWorld
	jp PreMainLoop

.underground
	ld a, [WRAMBank]
	push af
	dec a
	dec a
	ld [rSVBK], a
	bit 0, [hl]
	jr nz, .yes_underground
;no_underground
	push af
	ld [rSVBK], a
	ld de, Text_NoUnderground
	call PrintText
	call WaitUpdateBackground
	jp MainLoop

.yes_underground
	push af
	ld [rSVBK], a
	ld de, Text_YesUnderground
	call PrintText
	ld a, [XYZ]
	res 7, a
	ld [XYZ], a
	ld bc, 6
	call ForwardTime
	call TickWorld
	jp PreMainLoop

Text_NoSurface::
	text "There is no way"
	line "to go underground"
	line "here."
	linedone

Text_YesSurface::
	text "You descend into the"
	text "depths..."
	linedone

Text_NoUnderground
	text "There is no way"
	line "to return to the"
	line "surface here."
	linedone

Text_YesUnderground::
	text "You return to the"
	line "surface."
	linedone

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

ForwardTime::
	; Amount to forward in bc.
	ld a, b
	or c
	ld a, [Time]
	ret z
	inc a
	cp 0
	call z, .inc_date
	dec bc
	ld [Time], a
	jr ForwardTime

.inc_date
	ld hl, Date
	inc [hl]
	ret

Time_NoClock::
	ld a, [XYZ]
	bit 7, a
	ret nz

	ld a, [Time]
	cp 64
	jr c, .night
	cp 128
	jr c, .morning
	cp 192
	jr c, .afternoon
.night
	ld de, Text_Night
	jp PrintText

.morning
	ld de, Text_Morning
	jp PrintText

.afternoon
	ld de, Text_Afternoon
	jp PrintText

Text_Night::
	text "It is night-time."
	linedone

Text_Morning::
	text "It is the morning."
	linedone

Text_Afternoon::
	text "It is the afternoon."
	done

Time_Clock::
	ld de, .text1
	call PrintText
	ld a, TXT_DONE
	ld [Buffer + 5], a
	ld a, [Time]
	and TIME_HOUR
	rlca
	rlca
	rlca
	ld de, Buffer
	call ConvertNumberA
	ld de, Buffer + 4
	call PrintText
	ld de, .text2
	call PrintText
	ld a, [Time]
	and TIME_MINUTE
	ld de, Buffer
	call ConvertNumberA
	ld de, Buffer + 3
	call PrintText
	ld de, .text3
	call PrintText
	jp WaitUpdateBackground

.text1
	text "The time is "
	done

.text2
	text ":"
	done

.text3
	text "."
	linedone

PrintPositionAndTime::
	ld a, TXT_DONE
	ld [Buffer + 5], a
	ld a, [XYZ]
	and COORD_X
	rlca
	rlca
	rlca
	rlca
	ld de, Buffer
	call ConvertNumberA
	ld de, .text1
	call PrintText
	ld de, Buffer + 4
	call PrintText
	ld a, [XYZ]
	and COORD_Z
	ld de, Buffer
	call ConvertNumberA
	ld de, .text2
	call PrintText
	ld a, [XYZ]
	and COORD_Z
	cp 10
	jr nc, .double_figures
	ld de, Buffer + 4
	call PrintText
	ld de, .text3
	call PrintText
	jr .not_double_figures

.double_figures
	ld de, Buffer + 3
	call PrintText
	ld de, .text3
	call PrintText

.not_double_figures
	ld a, [XYZ]
	and COORD_Y
	jr z, .surface
;.underground
	ld de, .text4a
	call PrintText
	jp WaitUpdateBackground

.surface
	ld de, .text4b
	call PrintText
	call Time_Clock
	jp WaitUpdateBackground

.text1
	text "X = "
	done

.text2
	text ", Z = "
	done

.text3
	text "."
	linedone

.text4a
	text "Underground."
	linedone

.text4b
	text "Above ground."
	linedone

Text_ThisButtonDoesNothingYet::
	text "This button does"
	line "nothing yet."
	linedone

TickWorld::
	ret

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
	jr z, HelpLoop
	call ClearScreen
	call GetXYZAddressInHLAndChangeBank
	call DescribeSector
	call Time_NoClock
	jp WaitUpdateBackground

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
	call WaitUpdateBackground
	jr HelpLoop

BasicPlay::
	call ClearScreen
	ld de, Text_BasicPlay
	call PrintText
	call WaitUpdateBackground
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
	call WaitUpdateBackground
	jr HelpLoop

DescribeSector::
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
	dw .mesa
	dw .jungle
	dw .heaven
	dw .diorite
	dw .limestone
	dw .obsidian
	dw .ice_
	dw .granite
	dw .swamp
	dw .andesite
	dw .hell

.plains
	ld de, Text_Plains
	call PrintText
	jp .cont

.forest
	ld de, Text_Forest
	call PrintText
	jr .cont

.sand
	ld de, Text_Sand
	call PrintText
	jr .cont

.ice
	ld de, Text_Ice
	call PrintText
	jr .cont

.savanna
	ld de, Text_Savanna
	call PrintText
	jr .cont

.mesa
	ld de, Text_Mesa
	call PrintText
	jr .cont

.jungle
	ld de, Text_Jungle
	call PrintText
	jr .cont

.heaven
	ld de, Text_Heaven
	call PrintText
	jr .cont

.diorite
	ld de, Text_Diorite
	call PrintText
	jr .cont

.limestone
	ld de, Text_Limestone
	call PrintText
	jr .cont

.obsidian
	ld de, Text_Obsidian
	call PrintText
	jr .cont

.ice_
	ld de, Text_Ice_
	call PrintText
	jr .cont

.granite
	ld de, Text_Granite
	call PrintText
	jr .cont

.swamp
	ld de, Text_Swamp
	call PrintText
	jr .cont

.andesite
	ld de, Text_Andesite
	call PrintText
	jr .cont

.hell
	ld de, Text_Hell
	call PrintText

.cont
	pop hl

	; Dealing with the house
	inc hl
	ld a, [hl]
	and %00000011
	push hl
	cp 1
	jr z, .wood
	cp 2
	jr z, .brick
	cp 3
	jr z, .stone

;.no_house
	jr .cont2

.wood
	ld de, Text_Wood
	jr .cont_house

.stone
	ld de, Text_Stone
	jr .cont_house

.brick
	ld de, Text_Brick
	
.cont_house
	call PrintText
	ld a, [Flags]
	bit 5, a
	jr z, .cont2
	ld de, Text_Inside
	call PrintText
	ld a, TXT_DONE
	ld [Buffer + 6], a
	ld a, [hl]
	push hl
	ld hl, Buffer
	bit 2, a
	jr z, .next
	ld a, "["
	ld [hl], a
	inc hl
.next
	bit 3, a
	jr z, .next2
	ld a, "]"
	ld [hl], a
	inc hl
.next2
	bit 4, a
	jr z, .next3
	ld a, "↓"
	ld [hl], a
	inc hl
.next3
	bit 5, a
	jr z, .next4
	ld a, "×"
	ld [hl], a
	inc hl
.next4
	bit 6, a
	jr z, .next5
	ld a, "╬"
	ld [hl], a
	inc hl
.next5
	bit 7, a
	jr z, .finish
	ld a, "±"
	ld [hl], a
	inc hl
.finish
	ld a, TXT_DONE
	ld [hl], a
	ld de, Text_Icons
	call PrintText
	ld de, Buffer
	call PrintText
	pop hl

.cont2
	pop hl

	; Dealing with the Flags
	inc hl
	ld a, [XYZ]
	bit 7, a
	jr nz, .check_underground
	bit 0, [hl]
	call nz, .hole
.cont3
	ret

.check_underground
	ld a, [WRAMBank]
	push af
	dec a
	dec a
	ld [rSVBK], a
	bit 0, [hl]
	call nz, .hole
	pop af
	ld [rSVBK], a
	jr .cont3

.hole
	push hl
	ld de, Text_Hole
	call PrintText
	pop hl
	ret

Text_Hole::
	text "There's a hole here."
	done

Text_Icons::
	text "This house contains:"
	done

Text_Inside::
	text "You are inside the"
	line "house."
	linedone

Text_Wood::
	text "There is a wooden"
	line "house here."
	linedone

Text_Brick::
	text "There is a brick 'n'"
	text "mortar house here."
	linedone

Text_Stone::
	text "There is a stone"
	line "house here."
	linedone

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

Text_Mesa::
	text "a mesa."
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
	text "one cave."
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

Text_Swamp::
	text "an under-"
	text "ground swamp."
	linedone

Text_Andesite::
	text "an andes-"
	text "ite cave."
	linedone

Text_Hell::
	text "a nether"
	line "biome."
	linedone