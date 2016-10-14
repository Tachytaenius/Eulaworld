; Copyright 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

Farcall::
; Call a:hl.
; Preserves other registers.
; The true start of the routine is at RST_00.
	ld a, [ROMBank]
	push af
	ld a, [Buffer]
	rst BankSwitch
	call JumpHL
	ld a, b
	ld [Buffer], a
	ld a, c
	ld [Buffer + 1], a
	pop bc
	ld a, b
	rst BankSwitch
	ld a, [Buffer]
	ld b, a
	ld a, [Buffer + 1]
	ld c, a
	ret

Farjump::
; Jump to a:hl.
; Preserves other registers.
; The true start of the routine is at RST_00.
	rst BankSwitch

JumpHL::
	jp hl