#include <xc.inc>

config FOSC = INTRCIO
config WDTE = OFF
config PWRTE = OFF
config MCLRE = OFF
config CP = OFF
config CPD = OFF
config BOREN = OFF
config IESO = OFF
config FCMEN = OFF

analog SET 0x20
delay SET 0x21
delay2 SET 0x22
lights SET 0x23

ORG 0

PSECT code
main:
    BANKSEL TRISC
    CLRF    TRISC
    BANKSEL TRISB
    MOVLW   0b00100000
    MOVWF   TRISB
    BANKSEL PORTC
    CLRF    PORTC
    MOVLW   0b00101101
    MOVWF   ADCON0
    MOVLW   0
    MOVWF   analog

    GOTO sample

delays:
    MOVLW 125
    MOVWF delay
    MOVWF delay2

    restart:
    DECFSZ delay
    GOTO restart
    DECFSZ delay2
    GOTO restart
    GOTO continue

sample:
    GOTO delays
    continue:
    BSF     ADCON0, 1
    wait:
    BTFSC   ADCON0, 1
    GOTO    wait

    MOVF    ADRESH, W
    MOVWF   analog

    GOTO    process

process:
    MOVLW   128
    SUBWF   analog, F
    BTFSC   analog, 7
    GOTO    raise
    MOVLW   128
    ADDWF   analog,F
    GOTO    scale

raise:
    MOVLW   128
    ADDWF   analog,F
    MOVF    analog, W
    SUBLW   128
    ADDLW   128
    MOVWF   analog
    GOTO    scale

scale:
    MOVLW   128
    SUBWF   analog
    MOVF    analog, W
    ADDWF   analog, W
    ADDWF   analog, W
    MOVWF   analog
    GOTO    format

format:
    ;MOVF    analog, W
    ;MOVWF   lights
    ;GOTO display
    MOVLW   4
    SUBWF   analog, F
    BTFSC   analog, 7
    GOTO    zero

    MOVLW   7
    SUBWF   analog, F
    BTFSC   analog, 7
    GOTO    one

    MOVLW   10
    SUBWF   analog, F
    BTFSC   analog, 7
    GOTO    two
    
    MOVLW   14
    SUBWF   analog, F
    BTFSC   analog, 7
    GOTO    three

    MOVLW   17
    SUBWF   analog, F
    BTFSC   analog, 7
    GOTO    four

    MOVLW   21
    SUBWF   analog, F
    BTFSC   analog, 7
    GOTO    five

    MOVLW   24
    SUBWF   analog, F
    BTFSC   analog, 7
    GOTO    six

    MOVLW   28
    SUBWF   analog, F
    BTFSC   analog, 7
    GOTO    seven

    MOVLW   0
    MOVWF   lights
    GOTO    display

zero:
    MOVLW   0b00000001
    MOVWF   lights
    GOTO    display

one:
    MOVLW   0b00000011
    MOVWF   lights
    GOTO    display

two:
    MOVLW   0b00000111
    MOVWF   lights
    GOTO    display

three:
    MOVLW   0b00001111
    MOVWF   lights
    GOTO    display

four:
    MOVLW   0b00011111
    MOVWF   lights
    GOTO    display

five:
    MOVLW   0b00111111
    MOVWF   lights
    GOTO    display

six:
    MOVLW   0b01111111
    MOVWF   lights
    GOTO    display

seven:
    MOVLW   0b11111111
    MOVWF   lights
    GOTO    display

display:
    MOVF    lights, W
    MOVWF   PORTC
    GOTO    sample

GOTO $
END
