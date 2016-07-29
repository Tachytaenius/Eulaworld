; Copyright	2016 Henry "wolfboyft" Fleminger Thomson.
; Licensed under the GNU General Public License ver. 3.
; Refer to file LICENSE for information on the GPL 3.

MainLoop::
	call GetAddressOfPlayerXYZ
	jr MainLoop

GetAddressOfPlayerXYZ::

	and COORD_X
	
	ret