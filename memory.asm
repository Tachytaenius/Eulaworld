Entity: MACRO
	ds 1 ; ID
	ds 2 ; HP
	ds 1 ; EP
	ds 1 ; MP
	ds 1 ; CP
	ds 8 ; Inventory
	ds 1 ; Abilities
	ds 1 ; Flags
	ENDM

Sector: MACRO
	ds 1 ;1XYZ
	ds 1 ;Flags
	Entity
	Entity
	Entity
	Entity
	Entity
	Entity
	Entity
	ENDM

SECTION "WRAM 0", WRAM0
OAMTransferData::
	ds $A0
OAMTransferDataEnd::
BGTransferData::
	ds $168
BGTransferDataEnd::
	ds $DF8
StackStart::
SECTION "WRAM 1", WRAMX
	REPT 10
	Sector
	Sector
	Sector
	ENDR

SECTION "HRAM", HRAM
WaitDMADoneDestination::
	ds 9
WaitDMADoneDestinationEnd::
CursorPos::
	ds 2
Buffer::
	ds 2
ROMBank::
	ds 1
WRAMBank::
	ds 1