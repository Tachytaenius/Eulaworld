; Copyleft 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

INCLUDE "macros.asm"

SECTION "bank3", ROMX, BANK[$3]
INCLUDE "DevSound/DevSound.asm"
INCLUDE "DevSound/DevSound_Consts.asm"
INCLUDE "DevSound/DevSound_Macros.asm"
INCLUDE "DevSound/DevSound_SongData.asm"
INCLUDE "DevSound/DevSound_Vars.asm"