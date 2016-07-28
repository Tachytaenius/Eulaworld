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
	ds 1 ;Flags
	Entity
	Entity
	Entity
	Entity
	Entity
	Entity
	Entity
	ENDM

Contents: MACRO
	; The sector we want.
	ds 1 * FINAL_SECTORS ; XYZ
	; The memory address of it.
	ds 1 * FINAL_SECTORS ; Bank
	ds 2 * FINAL_SECTORS ; Address
	; Who is the player?
	ds 1 ; Bank
	ds 2 ; Address
	ENDM
