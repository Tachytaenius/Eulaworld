text EQUS "db "
line EQUS "db $60, "
done EQUS "db $61"
wait EQUS "db $62"
linedone EQUS "db $60, $61"
linewait EQUS "db $60, $62"
waitdone EQUS "db $62, $61"

txtram1: MACRO
	db $64
	dw \1
	ENDM

txtram2: MACRO
	db $65
	db BANK(\1)
	dw \1
	ENDM