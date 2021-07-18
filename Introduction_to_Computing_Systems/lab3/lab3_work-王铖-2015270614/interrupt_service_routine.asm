             .ORIG x2000 

             ST       R0,SAVER0
             ST       R1,SAVER1
             ST       R2,SAVER2
             ST       R4,SAVER4    
   
             ST       R3,FLAG1   
             ;ST       R2,PJ1      
             LD       R2,COUNTER
START        LDI      R1,KBSR
             BRzp     START
             LDI      R0,KBDR
ECHO         LDI      R1,DSR
             BRzp     ECHO
             STI      R0,DDR
             ADD      R2,R2,1
             BRn      ECHO
             LD       R0,ENTER
ECHO1        LDI      R1,DSR
             BRzp     ECHO1
             STI      R0,DDR

             LDI      R4,FLAG1

             BRp      L1
             BRn      L2

L1           ADD      R4,R4,-2
             STI      R4,FLAG1
             ;LD       R5,DIS

             ;ADD      R0,R0,R5
             BRnzp    EXIT


L2           ADD      R4,R4,2
             STI      R4,FLAG1
             ;LD       R5,NEGDIS

             ;ADD      R0,R0,R5
             BRnzp    EXIT


EXIT         LD       R0,SAVER0
             LD       R1,SAVER1
             LD       R2,SAVER2
             LD       R4,SAVER4

             RTI 

FLAG1        .FILL    x0000
;PJ1          .FILL    x0000
SAVER0       .BLKW    1
SAVER1       .BLKW    1
SAVER2       .BLKW    1
SAVER4       .BLKW    1
KBSR         .FILL    xFE00
KBDR         .FILL    xFE02
DSR          .FILL    xFE04
DDR          .FILL    xFE06
COUNTER      .FILL    xFFF6
ENTER        .FILL    x000A

             .END