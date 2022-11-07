assume cs:codesg,ds:datasg,ss:stacksg

datasg segment
    db 'welcome to masm!' ;16 bytes
    db 00000010B,00100100B,01110001B ;properties
datasg ends

stacksg segment
    dw 8 dup(0)
stacksg ends

codesg segment

start:
    mov ax,0b870h
    mov es,ax
    mov ax,datasg
    mov ds,ax
    mov ax,stacksg
    mov ss,ax
    mov sp,16

    mov di,0
    mov si,0
    mov cx,3
s0:
    push cx

    mov bx,0
    mov cx,16
    s:
        mov al,[bx]  ;char
        mov ah,10h[di]
        mov es:20h[si],ax

        inc bx
        add si,2
        loop s
    
    inc di
    add si,80h  ;next line: 160 - 32 = 128 = 80h
    pop cx
    loop s0

    mov ax,4c00h
    int 21h

codesg ends

end start
