assume cs:code
code segment
start:
    mov ax,0b800h
    mov es,ax
    mov bx,0

    mov ah,1
    mov dx,1439
    int 7ch

    mov ax,4c00h
    int 21h
code ends
end start
