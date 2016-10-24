; Copyright 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

SetForwards::
	;set bc bytes forward from hl to d
	ld a, b
	or c
	ret z
	ld a, d
	ld [hli], a
	dec bc
	jr SetForwards

RandomFillForwards::
	;set bc bytes forward from hl to a completely random value
	ld a, b
	or c
	ret z
	call Random2
	ld a, [SeedH]
	ld [hli], a
	dec bc
	jr RandomFillForwards

RandomFillForwardsSkipChunk_DivideBy8::
	;set the first byte of bc chunks of de size forward from hl to a completely random value
	ld a, b
	or c
	ret z
	call Random2
	
	ld a, [SeedH]
	srl a
	srl a
	srl a
	srl a
	srl a
	ld [hl], a
	add hl, de
	dec bc
	jr RandomFillForwardsSkipChunk_DivideBy8

RandomSetBit0ForwardsSkipChunk_Threshold10::
	;set the first byte of bc chunks of de size forward from hl to have bit 0 set if the random value created is less than eleven
	ld a, b
	or c
	ret z
	call Random2
	ld a, [SeedH]
	cp 11
	jr nc, .skip; If I am equal to or greater than 11, skip. If I am less than eleven, set bit 7 of [hl].
	set 0, [hl]
.skip
	add hl, de
	dec bc
	jr RandomSetBit0ForwardsSkipChunk_Threshold10

CopyForwards::
	;copy bc bytes forward from de to hl
	ld a, b
	or c
	ret z
	ld a, [de]
	inc de
	ld [hli], a
	dec bc
	jr CopyForwards

CopyDoubleForwards::
	;copy bc bytes forward from de to hl, twice for each byte
	ld a, b
	or c
	ret z
	ld a, [de]
	inc de
	ld [hli], a
	ld [hli], a
	dec bc
	jr CopyDoubleForwards

;CopyBackwards::
;	;copy bc bytes backward from hl to de
;	ld a, b
;	or c
;	ret z
;	ld a, [hld]
;	ld [de], a
;	dec de
;	inc bc
;	jr CopyBackwards

CopyForwardsSkip::
	;copy bc bytes forward from de to hl skipping a byte if it's equal to [Skippable]
	ld a, b
	or c
	ret z

	push bc
	ld a, [de]
	inc de ; This has to happen after ld a, [de], of course.
	ld b, a
	ld a, [Skippable]
	cp b
	pop bc
	dec bc ; Don't forget to decrement the counter!!
	jr nz, CopyForwardsSkip
	ld [hli], a ; Wait... do I want to not move hl?
	jr CopyForwardsSkip

ConvertNumberHLPoint::
	ld a, [hl]
ConvertNumberA::
	ld h, 0
	ld l, a
ConvertNumberHL::
	; Get the number in hl as text in de
	ld bc, -10000
	call .one
	ld bc, -1000
	call .one
	ld bc, -100
	call .one
	ld bc, -10
	call .one
	ld c, -1
.one
	ld a, "0"-1
.two
	inc a
	add hl, bc
	jr c, .two
	call SbcHlBc
	ld [de], a
	inc de
	ret