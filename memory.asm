; Copyright 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

SECTION "WRAM 0", WRAM0
OAMTransferData::
	ds $A0
OAMTransferDataEnd::
BGTransferDataGutter::
	ds $14
BGTransferData::
	ds $168
BGTransferDataEnd::
BGTransferData2::
	ds 80
BGTransferData2End::
Player::
	ds 1 
; StackStart EQU $D000

SECTION "HRAM", HRAM
WaitDMADoneDestination::
	ds 9
WaitDMADoneDestinationEnd::
CursorPos::
	ds 2
MiniBuffer::
	ds 1
Buffer::
	ds 2
Buffer2::
	ds 2
MiniBuffer2::
	ds 1
ROMBank::
	ds 1
WRAMBank::
	ds 1
Flags:: ; 4 = Update screen after PrintText call? 3 = Not running game on a Game Boy Colour? 2 = Update Background 1? 1 = Update Background 1? 0 = Initialized joypad?
	ds 1
DownJoypad::;;;;;;7 START
	ds 1         ;6 SELECT
ReleasedJoypad::;;5 B
	ds 1         ;4 A
PressedJoypad::;;;3 DOWN
	ds 1         ;2 UP
NextDrawLine:    ;1 LEFT
	ds 1         ;0 RIGHT
NextWriteLine::
	ds 1
RandomAdd::
	ds 1
RandomSub::
	ds 1
MenuSelection::
	ds 1
Time::
	ds 1
Date::
	ds 1
XYZ::
	ds 1
Skippable::
	ds 1