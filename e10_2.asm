assume cs:code,ss:stack
stack segment
    dw 8 dup(0)
stack ends

code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,16

    mov ax,4240H
    mov dx,000FH
    mov cx,0AH
    call divdw

    mov ax,4c00h
    int 21h


;功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型。
;参数：(ax)=dword型数据的低16位
;     (dx)=dword型数据的高16位
;     (cx)=除数
;返回：(dx)=结果的高16位，(ax)=结果的低16位
;     (cx)=余数
divdw:
    push bx

    mov bx,ax   ;低16位存bx
    mov ax,dx
    mov dx,0
    div cx      ;H/N
    
    push ax     ;int(H/N)压栈
    mov ax,bx   ;(dx:ax) = rem(H/N)*65536+L
    div cx
    mov cx,dx   ;余数存cx
    pop dx      ;int(H/N)出栈

    pop bx
    ret

code ends
end start