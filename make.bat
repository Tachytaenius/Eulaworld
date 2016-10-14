rgbasm -o home.o home.asm
rgbasm -o bank1.o bank1.asm
rgbasm -o bank2.o bank2.asm
rgbasm -o bank3.o bank3.asm
rgblink -n eulaworld.sym -m eulaworld.map -o eulaworld.gbc home.o bank1.o bank2.o bank3.o
rgbfix -v -C -p 255 -t EULAWORLD eulaworld.gbc