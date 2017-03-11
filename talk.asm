; Copyleft 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

; A0: Whether xor not to print the text at DE.
; A1: Whether xor not the eyes are closed.
; A2 with A3:
;	00: Closed mouth (frame 1.)
;	01: Mouth frame 2.
;	10: Mouth frame 3.
;	11: Mouth frame 4.
; A4: Whether xor not to print the whole face.
; A6 with A7: ID of talker.

TalkATextDE::
	ld a, [Face]
	bit 0, a
	jr z, .skip
	ld bc, $168
	ld hl, BGTransferData
	push af
	call CopyForwards
	pop af
.skip
	push af
	and TLK_ID
	rlca
	rlca
	ld b, 0
	ld c, a
	ld de, 2688 ; that's how big a 'face bank' is-- we're also clear from having to worry about de at this point
	ld hl, Faces
	push af
.loop
	ld a, b
	or c
	jr z, .done
	add hl, de
	dec bc
	jr .loop
.done
	ld a, 3 ; perfect placement!!
	ld [rIE], a
	pop af
	call SwapHlDe
	pop af
	bit 4, a
	ret z
	push af
	call StopLCD
	ld hl, $8800
	ld bc, 2304
	call CopyForwards
	ld hl, BGTransferData
	ld bc, 240
	ld d, $34
	call SetForwards
	ld bc, FaceDataEnd - FaceData
	ld de, FaceData
	ld hl, BGTransferData
	call CopyForwards
	ld a, [rLCDC]
	res 4, a
	ld [rLCDC], a
	call StartLCD
	call WaitUpdateBackground
	call ExtendedTilesOn
	pop af
	ret

FaceData:: ; i hope you've got word wrap on or a really, really big screen/tiny font.
	db  128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, $34, $34, $34, $34, $34, $34, $34, $34, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, $34, $34, $34, $34, $34, $34, $34, $34, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, $34, $34, $34, $34, $34, $34, $34, $34, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, $34, $34, $34, $34, $34, $34, $34, $34, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, $34, $34, $34, $34, $34, $34, $34, $34, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, $34, $34, $34, $34, $34, $34, $34, $34, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, $34, $34, $34, $34, $34, $34, $34, $34, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, $34, $34, $34, $34, $34, $34, $34, $34, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, $34, $34, $34, $34, $34, $34, $34, $34, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, $34, $34, $34, $34, $34, $34, $34, $34, 248, 249, 250, 251, 252, 253, 254, 255, 0, 1, 2, 3, $34, $34, $34, $34, $34, $34, $34, $34, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, $34, $34, $34, $34, $34, $34, $34, $34, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, $34, $34, $34, $34, $34, $34, $34, $34, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, $34, $34, $34, $34, $34, $34, $34, $34, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51
FaceDataEnd::