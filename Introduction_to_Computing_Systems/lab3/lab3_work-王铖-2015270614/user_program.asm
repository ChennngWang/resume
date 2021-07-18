             .ORIG x3000 

; initialize the stack pointer 

             LD        R6,STACK

; set up the keyboard interrupt vector table entry 

             ADD       R4,R4,0
             ADD       R5,R5,0
             LD        R4,KV
             LD        R5,SA
             STR       R5,R4,0

; enable keyboard interrupts 

             JSR       ENABLE

; start of actual user program to print the checkerboard 

             LEA       R3,FLAG

PJ           LD        R5,FLAG        ;Print Judger

             BRp       LP1
             BRn       LP2

LP1          LEA       R0,CB1

             JSR       DISABLE

             PUTS    
             LD        R0,ENTER
             OUT
             JSR       ENABLE
             JSR       DELAY
   
             LD        R5,FLAG
             BRn       PJ

             LEA       R0,CB2
             JSR       DISABLE
             PUTS
             LD        R0,ENTER
             OUT
             JSR       ENABLE
             JSR       DELAY
             BRnzp     PJ


LP2          LEA       R0,CB3
             JSR       DISABLE
             PUTS    
             LD        R0,ENTER
             OUT
             JSR       ENABLE
             JSR       DELAY

             LD        R5,FLAG
             BRp       PJ

             LEA       R0,CB4
             JSR       DISABLE
             PUTS
             LD        R0,ENTER
             OUT
             JSR       ENABLE
             JSR       DELAY
             BRnzp     PJ

DELAY        ST        R1,SaveR1 
             LD        R1,COUNT 
REP          ADD       R1,R1,-1 
             BRp       REP 
             LD        R1,SaveR1 
             RET 

ENABLE       ADD       R4,R4,0
             ADD       R5,R5,0
             LDI       R4,KBSR
             LD        R5,MASK
             NOT       R4,R4
             NOT       R5,R5
             AND       R4,R4,R5
             NOT       R4,R4
             STI       R4,KBSR
             RET


DISABLE      ADD       R4,R4,0
             ADD       R5,R5,0
             LDI       R4,KBSR
             LD        R5,MASK2
             AND       R4,R4,R5
             STI       R4,KBSR
             RET



FLAG         .FILL     x0001
COUNT        .FILL     #2500 
SaveR0       .BLKW     1
SaveR1       .BLKW     1   

ENTER        .FILL     x000A 
CB1          .STRINGZ  "**    **    **    **    **    **    **    **"
CB2          .STRINGZ  "   **    **    **    **    **    **    **   "
CB3          .STRINGZ  "##    ##    ##    ##    ##    ##    ##    ##"
CB4          .STRINGZ  "   ##    ##    ##    ##    ##    ##    ##   "
STACK        .FILL     x3000
KV           .FILL     x0180           ;Keyboard Vector
SA           .FILL     x2000           ;Starting Address
KBSR         .FILL     xFE00
MASK         .FILL     x4000
MASK2        .FILL     xBFFF
             .END