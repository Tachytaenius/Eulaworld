; Copyright 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

NULL			EQU %00000000

; What bits are used for the X, Y an Z positions?
COORD_X			EQU %01110000
COORD_Y			EQU %10000000
COORD_Z			EQU %00001111

; Where is the stack supposed to start?
StackStart		EQU $D000

; Joypad constants.
JOY_DOWN		EQU %10000000
JOY_UP			EQU %01000000
JOY_LEFT		EQU %00100000
JOY_RIGHT		EQU %00010000
JOY_START		EQU %00001000
JOY_SELECT		EQU %00000100
JOY_B			EQU %00000010
JOY_A			EQU %00000001

; Text constants.
TXT_NEWLINE		EQU	$FE
TXT_DONE		EQU $FF

; Time constants.
TIME_HOUR		EQU %11100000
TIME_MINUTE		EQU %00011111