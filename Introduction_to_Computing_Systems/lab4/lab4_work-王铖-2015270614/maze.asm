


;R1地址栈指针;指向上一个空位
;R2当前地址指针
;R6系统栈指针


            .ORIG          x3000

             LD               R6,SYSSTACK
             LD               R1,STACK
             JSR              GET_ADDRESS
             JSR              MAZE    





MAZE         JSR             MARK
             JSR             PUSH
             JSR             EXIT

             JSR             WESTDOOR
             JSR             SOUTHDOOR
             JSR             EASTDOOR
             JSR             NORTHDOOR
             JSR             POP

;RECOVER
            ADD              R6,R6,-1

            LD               R3,SYSBOTTOM
            ADD              R3,R3,R6
            BRz              L10

            LDR              R7,R6,0
            ADD              R6,R6,-1
            LDR              R2,R6,0
            ADD              R6,R6,-1
            LDR              R1,R6,0        

;EMPTY
L10         LD               R3,BOTTOM
            ADD              R3,R3,R1
            BRp              L5

            LEA             R0,NO
            PUTS
            HALT

L5          RET             



GET_ADDRESS LDI              R3,ADDRESSI     ;i;turn i,j into address
            LDI              R4,ADDRESSJ     ;j
            LD               R2,ADDRESSI     ;R2=x4000
            ADD              R2,R2,2   
            ADD              R2,R3,R2        ;
            ADD              R2,R3,R2    
            ADD              R2,R3,R2    
            ADD              R2,R3,R2    
            ADD              R2,R3,R2    
            ADD              R2,R3,R2    
            ADD              R2,R3,R2    
            ADD              R2,R3,R2    
            ADD              R2,R2,R4   
            RET




       
PUSH        STR              R2,R1,0
            ADD              R1,R1,1
            RET

POP         ADD              R1,R1,-1
            RET

EXIT        LD               R3,MASK_EXIT    ;is this address the exit
            LDR              R4,R2,0
            AND              R4,R3,R4
            BRnz             L6
            JSR              TRANSRESULT
L6          RET

STORE       STR              R1,R6,0
            ADD              R6,R6,1
            STR              R2,R6,0
            ADD              R6,R6,1
            STR              R7,R6,0
            ADD              R6,R6,1
            RET





MARK        LD               R3,MASK_MARK
            NOT              R3,R3
            LDR              R4,R2,0
            NOT              R4,R4
            AND              R3,R4,R3
            NOT              R3,R3
            STR              R3,R2,0
            RET

WESTDOOR     LD              R3,MASK_WEST
             LDR             R4,R2,0
             AND             R3,R4,R3       
             BRz             L11

             LD              R3,MASK_MARK
             ADD             R2,R2,-1
             LDR             R4,R2,0
             AND             R3,R3,R4
             BRp             L1

             JSR             STORE
             JSR             MAZE
L1           ADD             R2,R2,1
L11          RET

SOUTHDOOR    LD              R3,MASK_SOUTH
             LDR             R4,R2,0
             AND             R3,R4,R3       
             BRz             L12

             LD              R3,MASK_MARK
             ADD             R2,R2,+8
             LDR             R4,R2,0
             AND             R3,R3,R4
             BRp             L2

             JSR             STORE
             JSR             MAZE
L2           ADD             R2,R2,-8
L12          RET

EASTDOOR     LD              R3,MASK_EAST
             LDR             R4,R2,0
             AND             R3,R4,R3       
             BRz             L13

             LD              R3,MASK_MARK

             ADD             R2,R2,1
             LDR             R4,R2,0
             AND             R3,R3,R4

             BRp             L3


             JSR             STORE
             JSR             MAZE
L3           ADD             R2,R2,-1
L13          RET

NORTHDOOR    LD              R3,MASK_NORTH
             LDR             R4,R2,0
             AND             R3,R4,R3       
             BRz             L14

             LD              R3,MASK_MARK
             ADD             R2,R2,-8
             LDR             R4,R2,0
             AND             R3,R3,R4
             BRp             L4

             JSR             STORE
             JSR             MAZE
L4           ADD             R2,R2,8
L14          RET

TRANSRESULT  LD              R4,ADDRESSI          ;将结果转换，并存到x7000，并输出
             ADD             R4,R4,2
             NOT             R4,R4
             ADD             R4,R4,1              ;减去起始地址
             LD              R5,STACK             ;栈指针

             LD              R6,RESULT
           

L8           LDR             R3,R5,0              ;栈指针内容
             BRz             L9
             AND             R2,R2,0             
             AND             R1,R1,0
             ADD             R3,R4,R3

L7           ADD             R3,R3,-8

             BRzp            L20

             ADD             R2,R3,8
             BRnzp           L21

L20          ADD             R1,R1,1             
             BRnzp           L7


L21          LD              R0,ASCII
             ADD             R1,R1,R0
             STR             R1,R6,0
             ADD             R6,R6,1

             ADD             R2,R2,R0
             STR             R2,R6,0
             ADD             R6,R6,1

             LD              R1,SPACE
             STR             R1,R6,0
             ADD             R6,R6,1
             ADD             R5,R5,1


             BRnzp           L8
   
L9           LD              R0,RESULT
             PUTS
             HALT



ASCII        .FILL          x0030
SPACE        .FILL          x0020
BOTTOM       .FILL          x9FFF   
SYSBOTTOM    .FILL          xB001
ADDRESSI     .FILL          x4000
ADDRESSJ     .FILL          x4001
STACK        .FILL          x6000
SYSSTACK     .FILL          x5000
RESULT       .FILL          x7000
MASK_MARK    .FILL          x4000
MASK_WEST    .FILL          x0001
MASK_SOUTH   .FILL          x0002
MASK_EAST    .FILL          x0004
MASK_NORTH   .FILL          x0008
MASK_EXIT    .FILL          x0010
NO           .STRINGZ       "No path"
             
             .END