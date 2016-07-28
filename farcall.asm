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
JumpHL::
	jp hl