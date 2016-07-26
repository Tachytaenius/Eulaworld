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
BGTransferDataGutter::
	ds $14
BGTransferData::
	ds $168
BGTransferDataEnd::
	ds $DE4
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
DownJoypad::
	ds 1
PressedJoypad:: ;7 START
	ds 1        ;6 SELECT
NextDrawLine::  ;5 B
	ds 1        ;4 A
	            ;3 DOWN
	            ;2 UP
	            ;1 LEFT
	            ;0 RIGHT
NextWriteLine::
	ds 1