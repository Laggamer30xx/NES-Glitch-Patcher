@echo off
set PATH=%PATH%;C:\cc65\bin
ca65 patch.asm -o patch.o
ld65 -C nes.cfg -o patch.nes patch.o nes.lib
