assume cs:code
code segment
start:
    ;install
    mov ax,code
    mov ds,ax
    mov si,offset show_str

    mov ax,0
    mov es,ax
    mov di,200h

    mov cx,offset show_str_end - offset show_str
    cld
    rep movsb

    ;set
    mov ax,0
    mov es,ax
    mov word ptr es:[7ch*4],200h
    mov word ptr es:[7ch*4+2],0

    mov ax,4c00h
    int 21h

;参数: (dh)=行号, (dl)=列号, (cl)=颜色, ds:si指向字符串首地址
show_str:
    push ax
    push bx
    push cx
    push dx
    push es
    push si
    push di

    mov ax,0b800h
    mov es,ax

    ;bx = dh * 160 + dl * 2
    mov al,dh
    mov bl,160
    mul bl
    mov dh,0
    add ax,dx
    add ax,dx
    mov bx,ax

    mov ah,cl
    mov di,0
    s:
        mov cl,[si]
        mov ch,0
        jcxz ok

        mov al,cl
        mov es:[bx+di],ax

        inc si
        add di,2
        jmp short s
    
    ok:
    pop di
    pop si
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    iret

show_str_end:
    nop

code ends
end start