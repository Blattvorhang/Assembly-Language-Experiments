assume cs:code

data segment
    db 10 dup (0)
data ends

stack segment
    dw 16 dup (0)
stack ends

code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,32

    mov ax,12666
    mov bx,data
    mov ds,bx
    mov si,0
    call dtoc

    mov dh,8
    mov dl,3
    mov cl,2
    call show_str

    mov ax,4c00h
    int 21h


;说明：将word型数据转变为表示十进制数的字符串，字符串以0为结尾符
;参数：(ax)=word型数据
;     ds:si指向字符串的首地址
dtoc:
    push ax
    push bx
    push cx
    push dx
    push si

    mov bx,0
    digit:
        mov dx,0
        mov cx,10
        div cx      ;不需要特别处理ax
        push dx     ;余数压栈，便于逆序
        inc bx      ;记录位数
        mov cx,ax   ;商
        jcxz dtoc_ok
        jmp short digit

    dtoc_ok:
    mov cx,bx
    dtoc_s:
        pop ax
        add ax,30H
        mov [si],al
        inc si
        loop dtoc_s
    mov byte ptr [si],0 ;以0为结尾符

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret


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