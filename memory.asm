; Copyleft 2016 Henry "wolfboyft" Fleminger Thomson.
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
Player::
PlayerIdentity::
	ds 1
PlayerFlags::
	ds 1
PlayerData::
	ds 1
PlayerHits::
	ds 1
PlayerEnergy::
	ds 1
PlayerMana::
	ds 1
PlayerChakra::
	ds 1
PlayerEquipment::
	ds 1

; StackStart EQU $D000

SECTION "HRAM", HRAM
WaitDMADoneDestination::
	ds 9
WaitDMADoneDestinationEnd::
CursorPos::
	ds 2
Buffer::
	ds 8
Input::
	ds 1
CurrentLoop::
	ds 1
ROMBank::
	ds 1
WRAMBank::
	ds 1
Flags:: ; 7 = Don't worry about scroll prompts while using PrintText? 6 = Done call SeedRandom2_? 5 = Inside sector building? 4 = Don't update screen after PrintText call? 3 = Not running game on a Game Boy Colour? 2 = Top 12 lines of screen uses 8800 to 97FF? 1 = Update Background? 0 = Initialized joypad?
	ds 1
DownJoypad::;;;;;;7 START
	ds 1         ;6 SELECT
ReleasedJoypad::;;5 B
	ds 1         ;4 A
PressedJoypad::;;;3 DOWN
	ds 1         ;2 UP
NextDrawLine::   ;1 LEFT
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
SeedB::
	ds 1
SeedC::
	ds 1
SeedD::
	ds 1
SeedE::
	ds 1
SeedH::
	ds 1
ScrollCount::
	ds 1
Face::
	ds 1