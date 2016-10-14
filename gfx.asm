; Copyright 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

RGBSet: MACRO
	dw ((\3 >> 3) << 10) + ((\2 >> 3) << 5) + (\1 >> 3)
ENDM