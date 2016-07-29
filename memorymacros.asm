; Copyright	2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

Entity: MACRO
	ds 1 ; Identity
	ds 2 ; Health
	ds 1 ; Energy
	ds 1 ; Mana
	ds 1 ; Chakra
	ds 8 ; Inventory
	ds 1 ; Abilities
	ds 1 ; Flags
	ENDM

Sector: MACRO
	ds 1 ;XYZ
	ds 1 ;Biome
	Entity
	Entity
	Entity
	Entity
	Entity
	Entity
	Entity
	ENDM

Contents: MACRO
	; Where is the player?
	ds 1 ; XYZ
	; The sector we want.
	ds 1 * FINAL_SECTORS ; XYZ
	; The memory address of it.
	ds 1 * FINAL_SECTORS ; Bank
	ds 2 * FINAL_SECTORS ; Address
	ENDM