SECTION header vstart=0                     ;�����û�����ͷ���� 
    program_length  dd program_end          ;�����ܳ���[0x00]
    
    ;�û�������ڵ�
    code_entry      dw start                ;ƫ�Ƶ�ַ[0x04]
                    dd section.code_1.start ;�ε�ַ[0x06] 
    
    realloc_tbl_len dw (header_end-code_1_segment)/4
                                            ;���ض�λ�������[0x0a]
    
    ;���ض�λ��           
    code_1_segment  dd section.code_1.start ;[0x0c]
    code_2_segment  dd section.code_2.start ;[0x10]
    data_1_segment  dd section.data_1.start ;[0x14]
    data_2_segment  dd section.data_2.start ;[0x18]
    stack_segment   dd section.stack.start  ;[0x1c]
    
    header_end:                
    
;===============================================================================
SECTION code_1 align=16 vstart=0         ;��������1��16�ֽڶ��룩 
put_string:                              ;��ʾ��(0��β)��
                                         ;���룺DS:BX=����ַ
                             

         mov cl,[bx]
         or cl,cl                        ;cl=0 ?
         jz .exit                        ;�ǵģ����������� 
         call put_char
         inc bx                          ;��һ���ַ� 
         jmp put_string

   .exit:
         ret

;-------------------------------------------------------------------------------
put_char:                                ;��ʾһ���ַ�
                                         ;���룺cl=�ַ�ascii
         push ax
         push bx
         push cx
         push dx
         push ds
         push es

         ;����ȡ��ǰ���λ��
         mov dx,0x3d4
         mov al,0x0e
         out dx,al
         mov dx,0x3d5
         in al,dx                        ;��8λ 
         mov ah,al

         mov dx,0x3d4
         mov al,0x0f
         out dx,al
         mov dx,0x3d5
         in al,dx                        ;��8λ 
         mov bx,ax                       ;BX=�������λ�õ�16λ��

         cmp cl,0x0d                     ;�س�����
         jnz .put_0a                     ;���ǡ������ǲ��ǻ��е��ַ� 
         ;mov ax,bx                       �˾����Զ��࣬��ȥ���󻹵ø��飬�鷳 
         mov bl,80                       
         div bl
         mul bl
         mov bx,ax
         jmp .set_cursor

 .put_0a:
         cmp cl,0x0a                     ;���з���
         jnz .put_other                  ;���ǣ��Ǿ�������ʾ�ַ� 
         add bx,80
         jmp .roll_screen

 .put_other:                             ;������ʾ�ַ�
         mov ax,0xb800
         mov es,ax
         shl bx,1
         mov [es:bx],cl

         ;���½����λ���ƽ�һ���ַ�
         shr bx,1
         add bx,1

 .roll_screen:
         cmp bx,2000                     ;��곬����Ļ������
         jl .set_cursor

         mov ax,0xb800
         mov ds,ax
         mov es,ax
         cld
         mov si,0xa0
         mov di,0x00
         mov cx,1920
         rep movsw
         mov bx,3840                     ;�����Ļ���һ��
         mov cx,80
 .cls:
         mov word[es:bx],0x0720
         add bx,2
         loop .cls

         mov bx,1920

 .set_cursor:
         mov dx,0x3d4
         mov al,0x0e
         out dx,al
         mov dx,0x3d5
         mov al,bh
         out dx,al
         mov dx,0x3d4
         mov al,0x0f
         out dx,al
         mov dx,0x3d5
         mov al,bl
         out dx,al

         pop es
         pop ds
         pop dx
         pop cx
         pop bx
         pop ax

         ret

;-------------------------------------------------------------------------------
  start:
         ;��ʼִ��ʱ��DS��ESָ���û�����ͷ����
         mov ax,[stack_segment]           ;���õ��û������Լ��Ķ�ջ 
         mov ss,ax
         mov sp,stack_end
         
         mov ax,[data_1_segment]          ;���õ��û������Լ������ݶ�
         mov ds,ax

         mov bx,msg0
         call put_string                  ;��ʾ��һ����Ϣ 

         push word [es:code_2_segment]
         mov ax,begin
         push ax                          ;����ֱ��push begin,80386+
         
         retf                             ;ת�Ƶ������2ִ�� 
         
  continue:
         mov ax,[es:data_2_segment]       ;�μĴ���DS�л������ݶ�2 
         mov ds,ax
         mov bx,[ds:msg1]

         ;�����������Ļ����
         push bx
         mov bx,0x03e8
         mov dx,0x3d4
         mov al,0x0e
         out dx,al
         mov dx,0x3d5
         mov al,bh
         out dx,al
         mov dx,0x3d4
         mov al,0x0f
         out dx,al
         mov dx,0x3d5
         mov al,bl
         out dx,al
         pop bx
         
         call put_string                  ;��ʾ�ڶ�����Ϣ 

         jmp $ 

;===============================================================================
SECTION code_2 align=16 vstart=0          ;��������2��16�ֽڶ��룩

  begin:
	 ;���¼����ۼӺ�
	 xor dx,dx
         xor ax,ax
         xor cx,cx
  @@:
         inc cx
         add ax,cx
         adc dx,0
         cmp cx,1000
         jl @@


	;���¼����ۼӺ͵�ÿ����λ���浽��ջ
         mov bx,10
         xor cx,cx
         inc cx
         div bx
         or dl,0x30
         push dx
     @d:
         inc cx
         xor dx,dx
         div bx
         or dl,0x30
         push dx
         cmp ax,0
         jne @d	 

	 ;�Ѷ�ջ�е����浽msg1
	 mov ax,[es:data_2_segment]
	 mov ds,ax
	 mov si,[ds:msg1]
     @b:
	 pop dx
	 mov [ds:si],dl
	 inc si
	 loop @b
	 
         push word [es:code_1_segment]
         mov ax,continue
         push ax                          ;����ֱ��push continue,80386+
         
         retf                             ;ת�Ƶ������1����ִ�� 
         
;===============================================================================
SECTION data_1 align=16 vstart=0

    msg0 db '1+2+...+1000= '
         db 0

;===============================================================================
SECTION data_2 align=16 vstart=0

    msg1 db '        '
         db 0

;===============================================================================
SECTION stack align=16 vstart=0
           
         resb 256

stack_end:  

;===============================================================================
SECTION trail align=16
program_end: