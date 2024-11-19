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

; Set the background colors
; First
    LDA #$C6
    STA $83
; Second
    LDA #$86
    STA $82
; Third
    LDA #$66
    STA $81

; Main loop
MAIN:
    JSR SYNC
    JSR TOP
    LDA #0
    STA VBLANK

    JSR FRAME

    LDA #2
    STA VBLANK
    JSR BOTTOM
    JMP MAIN

; Syncronize the program with the TV (vertical sync)
SYNC:
    LDA #2
    STA VSYNC
    STA WSYNC
    STA WSYNC
    STA WSYNC
    LDA #0
    STA VSYNC
    RTS

; Render the black top part of the screen
TOP:
    LDX #37
TOP_LOOP: 
    STA WSYNC
    DEX
    BNE TOP_LOOP    
    RTS

FRAME:
    LDY #3
LOAD_NEW_COLOR:
    LDA $80,Y
    STA COLUBK
    LDX #192/3
RENDER_COLOR:
    STA WSYNC
    DEX
    BNE RENDER_COLOR
    DEY
    BNE LOAD_NEW_COLOR 
    RTS

BOTTOM:
    LDX #30
BOTTOM_LOOP:
    STA WSYNC
    DEX
    BNE BOTTOM_LOOP
    RTS

    ORG $FFFC
    .word SETUP
    .word SETUP