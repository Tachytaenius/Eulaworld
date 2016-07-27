INCLUDE "memorymacros.asm"

SECTION "WRAM 0", WRAM0
OAMTransferData::
	ds $A0
OAMTransferDataEnd::
BGTransferDataGutter::
	ds $14
BGTransferData::
	ds $168
BGTransferDataEnd::
W_Contents::
	Contents
W0_Remaining::
	ds $B11
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
Flags:: ; 0 = Initialized joypad?
	ds 1
DownJoypad::;;;;;;7 START
	ds 1         ;6 SELECT
ReleasedJoypad::;;5 B
	ds 1         ;4 A
PressedJoypad::;;;3 DOWN
	ds 1         ;2 UP
NextDrawLine::;;;;1 LEFT
	ds 1         ;0 RIGHT
NextWriteLine::
	ds 1