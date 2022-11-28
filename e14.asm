assume cs:code,ds:data
data segment
    db 9,8,7,4,2,0
    db '  /  /     :  :  ','$'
data ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov si,0
    mov di,6

    mov cx,6
    s:
        push cx
        mov al,[si]
        out 70h,al
        in al,71h

        mov ah,al
        mov cl,4
        shr ah,cl
        and al,00001111B
        
        add ah,30h
        add al,30h

        mov [di],ah
        mov [di+1],al

        inc si
        add di,3
        pop cx
        loop s

    ;set cursor
    mov ah,2
    mov bh,0
    mov dh,12
    mov dl,30
    int 10h

    ;print string
    mov dx,6
    mov ah,9
    int 21h

    mov ax,4c00h
    int 21h
code ends
end start