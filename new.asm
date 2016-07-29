; Copyright	2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

NewGame::
	ld de, Predefined
	ld hl, Sectors
	ld bc, CHUNK_SIZE
.loop
	jr .loop

.skip
	
	jp MainLoop

Predefined::
	db $96
	db $2b
	db $76
	db $e0
	db $01
	db $b6
	db $2c
	db $67
	db $9b
	db $09
	db $4a
	db $3c
	db $36
	db $22
	db $f6
	db $33
	db $f3
	db $54
	db $ce
	db $3c
	db $39
	db $4a
	db $a2
	db $c9
	db $bd
	db $ae
	db $b4
	db $d5
	db $cd
	db $a4