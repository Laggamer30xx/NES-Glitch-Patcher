; NES Patch ROM
; Disables blinking light and white screen

  .inesprg 1   ; 1x 16KB PRG ROM
  .ineschr 1   ; 1x 8KB CHR ROM
  .inesmir 1   ; Vertical mirroring
  .inesmap 0   ; NROM mapper

  .bank 0
  .org $C000

Reset:
  SEI          ; Disable interrupts
  CLD          ; Clear decimal mode

  ; Wait for PPU warm-up (3 frames)
  BIT $2002
  LDX #3
WaitVBlank:
  LDA $2002
  BPL WaitVBlank
  DEX
  BNE WaitVBlank

  ; Initialize PPU
  LDA #$00
  STA $2000    ; Disable NMI
  STA $2001    ; Disable rendering
  STA $4010    ; Disable DMC IRQs

  ; Initialize APU
  LDX #$40
  STX $4017    ; Disable APU frame IRQ
  LDA #$0F
  STA $4015    ; Enable all channels

  ; Clear RAM (more thorough)
  LDX #$00
  LDA #$00
ClearRAM:
  STA $0000,X
  STA $0100,X
  STA $0200,X
  STA $0300,X
  STA $0400,X
  STA $0500,X
  STA $0600,X
  STA $0700,X
  INX
  BNE ClearRAM

  ; Set stack pointer
  LDX #$FF
  TXS

  ; Enable NMI
  LDA #$80
  STA $2000

  ; More robust infinite loop
  CLI          ; Enable interrupts
Forever:
  NOP
  JMP Forever

  .org $FFFA
  .dw 0        ; NMI vector (disabled)
  .dw Reset    ; Reset vector
  .dw 0        ; IRQ vector (disabled)
