; Copyright	2016 Henry "wolfboyft" Fleminger Thomson.
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

;	CopyBackwards::
;		;copy bc bytes backward from hl to de
;		ld a, b
;		or c
;		ret z
;		ld a, [hld]
;		ld [de], a
;		dec de
;		inc bc
;		jr CopyBackwards

ConvertNumberHLPoint::
	ld a, [hl]
ConvertNumberA::
	ld d, 0
	ld e, a
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
	push bc
	push af
	ld a, b
	cpl
	ld b, a
	ld a, c
	cpl
	ld c, a
	inc bc
	call c, .carry
	pop af
	add hl, bc
	pop bc
	ld [de], a
	inc de
	ret

.carry
	inc bc
	ret