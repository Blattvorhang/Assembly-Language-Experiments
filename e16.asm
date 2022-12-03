assume cs:code
stack segment
    db 128 dup (0)
stack ends

code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,128

    ;install
    mov ax,code
    mov ds,ax
    mov si,offset setscreen
    mov ax,0
    mov es,ax
    mov di,200h

    mov cx,offset setscreen_end - offset setscreen
    cld
    rep movsb

    ;set
    mov word ptr es:[7ch*4],200h
    mov word ptr es:[7ch*4+2],0

    mov ax,4c00h
    int 21h

;(ah)=功能号，(al)=颜色值(0~7)
;(1) 清屏
;(2) 设置前景色
;(3) 设置背景色
;(4) 向上滚动一行
setscreen:
    jmp short set
    table dw sub1 - setscreen + 200h
          dw sub2 - setscreen + 200h
          dw sub3 - setscreen + 200h
          dw sub4 - setscreen + 200h
    
set:
    push bx
    cmp ah,3
    ja sret
    mov bl,ah
    mov bh,0
    add bx,bx
    call word ptr cs:[bx+202h]  ;the address of table

sret:
    pop bx
    iret

    sub1:
        push bx
        push cx
        push es
        mov bx,0b800h
        mov es,bx
        mov bx,0
        mov cx,2000
        sub1s:
            mov byte ptr es:[bx],' '
            add bx,2
            loop sub1s
        
        pop es
        pop cx
        pop bx
        ret
    
    sub2:
        push bx
        push cx
        push es
        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
        sub2s:
            and byte ptr es:[bx],11111000B
            or es:[bx],al
            add bx,2
            loop sub2s
        
        pop es
        pop cx
        pop bx
        ret
    
    sub3:
        push bx
        push cx
        push es
        mov cl,4
        shl al,cl
        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
        sub3s:
            and byte ptr es:[bx],10001111B
            or es:[bx],al
            add bx,2
            loop sub3s
        
        pop es
        pop cx
        pop bx
        ret

    sub4:
        push cx
        push si
        push di
        push ds
        push es

        mov si,0b800h
        mov es,si
        mov ds,si
        mov si,160
        mov di,0
        cld
        mov cx,24
        sub4s:
            push cx
            mov cx,160
            rep movsb
            pop cx
            loop sub4s
        
        mov cx,80
        sub4s1:
            mov byte ptr es:[di],' '
            add di,2
            loop sub4s1
        
        pop es
        pop ds
        pop di
        pop si
        pop cx
        ret

setscreen_end:
    nop

code ends
end start
