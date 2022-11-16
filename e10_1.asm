assume cs:code
data segment
    db 'Welcome to masm!',0
data ends

stack segment
    dw 8 dup(0)
stack ends

code segment
start:
    mov dh,8
    mov dl,3
    mov cl,2
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,16
    mov si,0
    call show_str

    mov ax,4c00h
    int 21h


;说明：在指定位置，用指定颜色，显示一个用0结束的字符串
;参数：(dh)=行号, (dl)=列号, (cl)=颜色, ds:si指向字符串首地址
show_str:
    push ax
    push bx
    push cx
    push dx
    push es
    push si
    push di

    mov ax,0b800h   ;显存段
    mov es,ax

    ;计算屏幕位置，存在bx中
    ;bx = dh * 160 + dl * 2
    mov al,dh
    mov bl,160  ;一行的字节数
    mul bl
    mov dh,0    ;与ax相加的是dl，要保证dh为0
    add ax,dx
    add ax,dx
    mov bx,ax

    mov ah,cl   ;color
    mov di,0
    s:
        mov cl,[si]
        mov ch,0
        jcxz ok

        mov al,[si]
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
    ret

code ends
end start