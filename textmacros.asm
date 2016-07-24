newline EQUS "db $60, "
return1 EQUS "db $61"
return2 EQUS "db $62"

txtram1: MACRO
	db $63
	dw \1
	ENDM

txtram2: MACRO
	db $64
	db BANK(\1)
	dw \1
	ENDM