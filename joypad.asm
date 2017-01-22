; Copyleft 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

GetJoypad::
	ld a, %00100000
	ld [rP1], a
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	and $0F
	swap a
	ld b, a
	ld a, %00010000
	ld [rP1], a
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	ld a, [rP1]
	and $0F
	or b
	cpl

	ld d, a

	ld b, a
	ld a, [DownJoypad]
	cpl
	and b
	ld [PressedJoypad], a

	ld a, [DownJoypad]
	ld b, a
	ld a, d
	cpl
	and b
	ld a, b
	ld [ReleasedJoypad], a
	ld a, d
	ld [DownJoypad], a
	ret

WaitForInput::
	call WaitForAllButtonsToBeReleased
.loop
	halt
	nop
	call GetJoypad
	ld a, [PressedJoypad]
	and $FF
	jr z, .loop
	jp Random

WaitForStart::
	halt
	nop
	call GetJoypad
	ld a, [ReleasedJoypad]
	and JOY_START
	jr z, WaitForStart
.loop
	halt
	nop
	call GetJoypad
	ld a, [PressedJoypad]
	and JOY_START
	jr z, .loop
	jp Random

WaitForAllButtonsToBeReleased::
	halt
	nop
	call GetJoypad
	ld a, [DownJoypad]
	and a
	jr nz, WaitForAllButtonsToBeReleased
	jp Random