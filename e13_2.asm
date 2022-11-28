assume cs:code
code segment
start:
    ;install
    mov ax,code
    mov ds,ax
    mov si,offset lp
    mov ax,0
    mov es,ax
    mov di,200h

    mov cx,offset lpend - offset lp
    cld
    rep movsb

    ;set
    mov ax,0
    mov es,ax
    mov word ptr es:[7ch*4],200h
    mov word ptr es:[7ch*4+2],0

    mov ax,4c00h
    int 21h

;参数：(cx)=循环次数, (bx)=位移
lp:
    push bp
    dec cx
    jcxz lpret
    mov bp,sp
    add [bp+2],bx
lpret:
    pop bp
    iret
lpend:
    nop
code ends
end start