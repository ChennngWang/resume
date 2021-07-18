       .ORIG    x3000

       LEA      R0,PROMPT
       TRAP     x22        ;PUTS  

       LEA      R2,INPUT
LP1    TRAP     x20        ;GETC
       TRAP     x21        ;OUT
       STR      R0,R2,0
       ADD      R2,R2,1
       LD       R1,NENTER  ;ENTER+NENTER=0
       ADD      R0,R0,R1
       BRnp     LP1      
       
       LD       R1,PTR
       LDR      R1,R1,0
LP6    BRz      EXIT

       ADD      R2,R1,1
       LDR      R3,R2,0    ;R3链表数据地址
       LEA      R4,INPUT   ;R4存储数据地址

       LDR      R5,R3,0    ;R5链表数据
       LDR      R6,R4,0    ;R6存储数据

LP2    NOT      R7,R5    ;链表数据取反
       ADD      R7,R7,1    ;R7负链表数据

       ADD      R6,R7,R6   ;两数据相减

       BRnp     LP5

       AND      R0,R0,0

       ADD      R3,R3,1    ;R3链表数据地址增一
       LDR      R5,R3,0    ;R5链表数据
       BRnp     LP3
       ADD      R0,R0,1
LP3    ADD      R4,R4,1 
       LDR      R6,R4,0  

       LD       R7,NENTER
       ADD      R7,R7,R6

       BRnp     LP4

       ADD      R0,R0,1

LP4    ADD      R0,R0,#-1

       BRz      LP5
       BRn      LP2

       ADD      R2,R2,1
         
       LDR      R0,R2,0

       TRAP     x22
       BRnzp    EXIT2
   
LP5    LDR      R1,R1,0
       BRnzp    LP6

EXIT   LEA      R0,NE
       TRAP     x22        ;PUTS  

EXIT2  TRAP     x25        ;HALT machine


PTR    .FILL    x3300 
INPUT  .BLKW    16

NENTER .FILL    xFFF6
PROMPT .STRINGZ "Type a room number and press Enter:"
NE     .STRINGZ "No Entry"
       .END