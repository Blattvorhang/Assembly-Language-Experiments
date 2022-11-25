assume cs:code
code segment
start:
    ;install do0
    mov ax,code
    mov ds,ax
    mov si,offset do0

    mov ax,0
    mov es,ax
    mov di,200h

    mov cx,offset do0end - offset do0
    cld
    rep movsb

    ;set interrupt vector table
    mov ax,0
    mov es,ax
    mov word ptr es:[0],200h
    mov word ptr es:[2],0

    mov ax,4c00h
    int 21h

do0:
    jmp short do0start
    db 'divide error!',0

do0start:
    mov ax,0
    mov ds,ax
    mov si,202h

    mov ax,0b800h
    mov es,ax
    mov di,12 * 160 + 36 * 2

    s:
        mov al,ds:[si]
        mov ah,0
        mov cx,ax
        jcxz ok
        mov es:[di],al
        inc si
        add di,2
        jmp short s
    
    ok:
    mov ax,4c00h
    int 21h

do0end:
    nop

code ends
end start