assume cs:codesg,ss:stacksg

datasg segment
    db "Beginner's All-purpose Symbolic Instruction Code.",0
datasg ends

stacksg segment
    dw 8 dup (0)
stacksg ends

codesg segment
begin:
    mov ax,stacksg
    mov ss,ax
    mov sp,16

    mov ax,datasg
    mov ds,ax
    mov si,0
    call letterc

    mov ax,4c00h
    int 21h


;功能：将以0结尾的字符串中的小写字母转变成大写字母
;参数：ds:si指向字符串首地址
letterc:
    push ax
    push cx
    push si

    s:
        mov al,[si]
        mov ah,0
        mov cx,ax
        jcxz ok
        cmp al,'a'
        jb next
        cmp al,'z'
        ja next
        xor al,00100000B
        mov [si],al

        next:
        inc si
        jmp s

    ok:
    pop si
    pop cx
    pop ax
    ret

codesg ends
end begin