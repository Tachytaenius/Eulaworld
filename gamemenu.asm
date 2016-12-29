; Copyleft 2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

GameMenu::
	
	jp MainLoop

.Action
	call ForwardTime
	call TickWorld
	jp PreMainLoop