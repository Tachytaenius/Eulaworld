; Copyleft 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

; Useful constant definitions taken from pokecrystal by pret. I love those guys.
const_def: MACRO
const_value = 0
ENDM

const: MACRO
\1 EQU const_value
const_value = const_value + 1
ENDM

shift_const: MACRO
\1 EQU (1 << const_value)
const_value = const_value + 1
ENDM

; What bits are used for the X, Y and Z positions?
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
TXT_SKIP		EQU $FD
TXT_NEWLINE		EQU	$FE
TXT_DONE		EQU $FF

; Time constants.
TIME_HOUR		EQU %11100000
TIME_MINUTE		EQU %00011111

; Entitiy constants.
	const_def
	const NOTHING
	const HUMAN
	const WOLF
	const FOX
	const CAT
	const ELF
	const AMAACIINU
	const AMAACIKITSUNE
	const AMAACINEKO
	const GREENSLIME
	const MANCUBUS
	const REVENANT
	const PINKY
	const REDSLIME
	const BLUESLIME
	const STONEGOLEM
	const IRONGOLEM
	const ROTWORM
	const BLOODWORM
	const PIG
	const COW
	const SHEEP
	const CHICKEN
	const DWARF
	const DROW
	const GNOME
	const CACODEMON
	const IMP
	const BEHOLDER
	const KUOTOA
	const HORSE
	const UNICORN