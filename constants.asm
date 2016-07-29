; Copyright	2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

NULL			EQU %00000000

; What bits are used for the X, Y an Z positions?
COORD_X			EQU %11100000
COORD_Y			EQU %00011000
COORD_Z			EQU %00000111

; Where is the stack supposed to start?
StackStart		EQU $D000

; Joypad constants
JOY_DOWN		EQU %10000000
JOY_UP			EQU %01000000
JOY_LEFT		EQU %00100000
JOY_RIGHT		EQU %00010000
JOY_START		EQU %00001000
JOY_SELECT		EQU %00000100
JOY_B			EQU %00000010
JOY_A			EQU %00000001

; The dimensions of a WRAM bank in sectors.
MAX_BANK_X		EQU 3
MAX_BANK_Y		EQU 2
MAX_BANK_Z		EQU 5

; The actual number of sectors in a chunk.
CHUNK_SIZE		EQU MAX_BANK_X * MAX_BANK_Y * MAX_BANK_Z

; The dimensions of the game world in WRAM banks, or chunks.
MAX_CHUNK_X		EQU 3
MAX_CHUNK_Y		EQU 1
MAX_CHUNK_Z		EQU 2

; The dimensions of the game world in sectors.
MAX_TOTAL_X		EQU MAX_BANK_X * MAX_CHUNK_X
MAX_TOTAL_Y		EQU MAX_BANK_Y * MAX_CHUNK_Y
MAX_TOTAL_Z		EQU MAX_BANK_Z * MAX_CHUNK_Z

; The actual number of sectors in the game world.
FINAL_SECTORS	EQU MAX_TOTAL_X * MAX_TOTAL_Y * MAX_TOTAL_Z

; How big is an entity?
ENTITY_SIZE		EQU 16

; How big is a sector?
SECTOR_SIZE		EQU (ENTITY_SIZE * 7) + 2