; Stable Image Test Atari 2600
; Author Niclas Johansson
; Date 2024-11-17
; Version 1.0
; -------------------------------------------------------------------------------------------------
; COMPILER METADATA 
; Import the VCS header file and set the origin for all memory adressing
; -------------------------------------------------------------------------------------------------
    PROCESSOR 6502
    INCLUDE "vcs.h"
    ORG $F000


; -------------------------------------------------------------------------------------------------
; SETUP
; First disable interrupts. This is completly unneccessary but good practice apparently 🤷‍♂️
; Then clear decimal mode
; Set the stack pointer to FF
; Finally, clear memory
; -------------------------------------------------------------------------------------------------
SETUP:
    SEI 
    CLD 
    LDX #$FF 
    TXS 
    LDA #$00
CLEAR:
    STA 0,X
    DEX
    BNE CLEAR


; -------------------------------------------------------------------------------------------------
; BACKGROUND COLORS
; Set the three background colors to use
; The order of the registries used are reversed due to counting down when picking colors
; -------------------------------------------------------------------------------------------------
; First
    LDA #$C6
    STA $83
; Second
    LDA #$86
    STA $82
; Third
    LDA #$66
    STA $81


; -------------------------------------------------------------------------------------------------
; MAIN LOOP
; The main loop of the program
; -------------------------------------------------------------------------------------------------
MAIN:
    JSR SYNC
    JSR PRELOAD_BACKGROUND_COLOR
    JSR TOP
    JSR TURN_OFF_VBLANK
    JSR SHOW_FRAME
    JSR TURN_ON_VBLANK
    JSR BOTTOM
    JMP MAIN


; -------------------------------------------------------------------------------------------------
; VETICAL SYNC
; Syncronize the program with the TV (vertical sync)
; -------------------------------------------------------------------------------------------------
SYNC:
    LDA #2
    STA VSYNC
    STA WSYNC
    STA WSYNC
    STA WSYNC
    LDA #0
    STA VSYNC
    RTS


; -------------------------------------------------------------------------------------------------
; RENDERING BLACK TOP
; Render the black top part of the screen
; -------------------------------------------------------------------------------------------------
TOP:
    LDX #37
TOP_LOOP: 
    STA WSYNC
    DEX
    BNE TOP_LOOP    
    RTS


; -------------------------------------------------------------------------------------------------
; RENDERING FRAME
; Render the colors on the screen
; -------------------------------------------------------------------------------------------------
SHOW_FRAME:
    LDY #3
PREPARE_NEXT_COLOR:
    LDX #192/3
RENDER_COLOR_LINE:
    STA WSYNC
    DEX
    BNE RENDER_COLOR_LINE
    DEY
    LDA $80,Y
    STA COLUBK
    BNE PREPARE_NEXT_COLOR 
    RTS


; -------------------------------------------------------------------------------------------------
; RENDERING BLACK BOTTOM
; Render the black bottom part of the screen
; -------------------------------------------------------------------------------------------------
BOTTOM:
    LDX #30
BOTTOM_LOOP:
    STA WSYNC
    DEX
    BNE BOTTOM_LOOP
    RTS


; -------------------------------------------------------------------------------------------------
; TURN OFF AND ON VBLANK
; -------------------------------------------------------------------------------------------------
TURN_OFF_VBLANK:
    LDA #0
    STA VBLANK
    RTS

TURN_ON_VBLANK:
    LDA #2
    STA VBLANK
    RTS

; -------------------------------------------------------------------------------------------------
; PRELOAD BACKGROUND COLOR
; Set the background color to the first color again
; This is to avoid a small line of the last color on the first line of the screen
; -------------------------------------------------------------------------------------------------
PRELOAD_BACKGROUND_COLOR:
    LDA $83
    STA COLUBK
    RTS
; -------------------------------------------------------------------------------------------------


; -------------------------------------------------------------------------------------------------
; Set the startup point of the program
; -------------------------------------------------------------------------------------------------
    ORG $FFFC
    .word SETUP
    .word SETUP
; -------------------------------------------------------------------------------------------------