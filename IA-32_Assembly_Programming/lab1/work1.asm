         jmp near start
	
 message db 'wangcheng21141601 '
        
 start:
         mov ax,0x7c0           ;�������ݶεĶλ���ַ 
         mov ds,ax

         mov ax,0xb800          ;���ø��Ӷλ�ַ����ʾ������
         mov es,ax

         ;������ʾ�ַ��� 
         mov si,message          
         mov di,0
         mov cx,start-message
     @g:
         mov al,[si]
         mov [es:di],al
         inc di
         mov byte [es:di],0x07
         inc di
         inc si
         loop @g

         ;���¼���ASCII��ĺ� 
         xor ax,ax
         mov cx,start-message
	 mov si,message
     @f:
	 mov bl,[si]
         add ax,bx
         inc si
	 dec cx
         cmp cx,0
         jg @f
         
         sub ax,32              ;��ȥ�ո��ASCII��ֵ 

         ;���¼����ۼӺ͵�ÿ����λ 
         xor cx,cx              ;���ö�ջ�εĶλ���ַ
         mov ss,cx
         mov sp,cx

         mov bx,10
         xor cx,cx
     @d:
         inc cx
         xor dx,dx
         div bx
         or dl,0x30
         push dx
         cmp ax,0
         jne @d

         ;������ʾ������λ 
     @a:
         pop dx
         mov [es:di],dl
         inc di
         mov byte [es:di],0x07
         inc di
         loop @a
       
         jmp near $ 
       

times 510-($-$$) db 0
                 db 0x55,0xaa