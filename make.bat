rgbasm -o home.o home.asm
rgbasm -o bank1.o bank1.asm
rgbasm -o bank2.o bank2.asm
rgbasm -o bank3.o bank3.asm
rgbasm -o memory.o memory.asm
rgbasm -o charmap.o charmap.asm
rgblink -n adventure.sym -m adventure.map -o adventure.gbc home.o bank1.o bank2.o bank3.o memory.o charmap.o
rgbfix -v -p 255 -t EULAWORLD adventure.gbc