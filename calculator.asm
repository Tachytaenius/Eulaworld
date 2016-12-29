; Copyleft 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

Sine::
	; Get the sine value of a in hl.
	ld hl, SineTable
	push de
	sla a
	ld e, a
	ld d, 0
	jr nc, .skip
	inc d

.skip
rept 2
	add hl, de
endr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ret