; Copyleft 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

WashingMashineJoke::
	ld de, Text_On
	call PrintText
	halt
	nop
	ld de, Text_Off
	call PrintText
	halt
	nop
	jr WashingMashineJoke

Text_On::
	text "                    "
	text " ┌~~~~~~~~~┐        "
	text " | ┌~~~┐ # |        "
	text " | |   |   |        "
	text " | |   |   |        "
	text " | |   | + |        "
	text " | └~~~┘   |        "
	text " |         |        "
	text " └~~~~~~~~~┘        "
	text "                    "
	text "                    "
	text "                    "
	text " HELLO, DAVID!      "
	text "                    "
	text " I AM A WASHING     "
	text " MACHINE!           "
	text "                    "
	text "                    "
	done

Text_Off::
	text "                    "
	text "                    "
	text "                    "
	text "                    "
	text "                    "
	text "                    "
	text "                    "
	text "                    "
	text "                    "
	text "                    "
	text "                    "
	text "                    "
	text " HELLO, DAVID!      "
	text "                    "
	text " I AM A WASHING     "
	text " MACHINE!           "
	text "                    "
	text "                    "
	done