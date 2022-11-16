assume cs:code,ss:stack,ds:data

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    ;以上是表示21年的21个字符串

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ;以上是表示21年公司总收入的21个dword型数据

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
    ;以上是表示21年公司雇员人数的21个word型数据
data ends

string segment
    db 10 dup (0)
string ends

table segment
    db 21 dup ('year summ ne ?? ')
table ends

stack segment
    dw 16 dup (0)
stack ends

code segment
start:
    mov ax,data
    mov ds,ax

    mov ax,table
    mov es,ax

    mov ax,stack
    mov ss,ax
    mov sp,32

    mov bx,0
    mov bp,0
    mov cx,21
    s0:
        push cx

        push bx
        add bx,bx

        ;年份
        mov si,0
        mov cx,4
        s: 
            mov al,[bx].0h[si]
            mov es:[bp].0h[si],al
            inc si
            loop s

        ;收入
        mov ax,[bx].84
        mov dx,[bx].86
        mov es:[bp].5h,ax
        mov es:[bp].7h,dx
        
        pop bx

        ;人均收入
        div word ptr [bx].168
        mov es:[bp].0dh,ax

        ;雇员数
        mov ax,[bx].168
        mov es:[bp].0ah,ax

        add bx,2
        add bp,10h
        pop cx
        loop s0

    ;打印数据
    mov ax,table
    mov ds,ax
    mov si,0
    mov bx,0
    mov dh,2    ;行号
    mov cx,21
    s1:
        push cx
        mov cl,00000111B
        call show_table
        inc dh
        add si,10H
        pop cx
        loop s1

    mov ax,4c00h
    int 21h


;说明：将table中一行的数据显示到屏幕上
;参数：(dh)=行号, (cl)=颜色, ds:si指向table数据首地址
show_table:
    push ax
    push dx
    push es
    push si

    ;打印年份
    mov ax,string
    mov es,ax
    mov ax,[si]
    mov es:[0],ax
    mov ax,[si+2]
    mov es:[2],ax
    mov byte ptr es:[4],0
    
    mov dl,20
    push ds
    push si
    mov ax,es
    mov ds,ax
    mov si,0
    call show_str
    pop si
    pop ds

    ;打印收入
    mov bh,dh   ;bh暂存行号
    mov ax,[si].5
    mov dx,[si].7
    push ds
    push si
    push bx
    mov bx,es
    mov ds,bx
    mov si,0
    call dtoc
    
    pop dx      ;行号出栈
    mov dl,30
    call show_str
    pop si
    pop ds

    ;打印雇员数
    mov bh,dh   ;bh暂存行号
    mov ax,[si].0ah
    mov dx,0
    push ds
    push si
    push bx
    mov bx,es
    mov ds,bx
    mov si,0
    call dtoc
    
    pop dx      ;行号出栈
    mov dl,40
    call show_str
    pop si
    pop ds

    ;打印人均收入
    mov bh,dh   ;bh暂存行号
    mov ax,[si].0dh
    mov dx,0
    push ds
    push si
    push bx
    mov bx,es
    mov ds,bx
    mov si,0
    call dtoc
    
    pop dx      ;行号出栈
    mov dl,50
    call show_str
    pop si
    pop ds

    pop si
    pop es
    pop dx
    pop ax
    ret


;说明：将dword型数据转变为表示十进制数的字符串，字符串以0为结尾符
;参数：(ax)=dword型数据的低16位
;     (dx)=dword型数据的高16位
;     ds:si指向字符串的首地址
dtoc:
    push ax
    push bx
    push cx
    push dx
    push si

    mov bx,0
    digit:
        mov cx,10
        call divdw  ;不需要特别处理ax,dx
        push cx     ;余数压栈，便于逆序
        inc bx      ;记录位数
        mov cx,ax   ;商的低16位
        or cx,dx    ;或上商的高16位，即ax与dx必须同时为零才跳出循环
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
    show_str_s:
        mov cl,[si]
        mov ch,0
        jcxz show_str_ok

        mov al,[si]
        mov es:[bx+di],ax

        inc si
        add di,2
        jmp short show_str_s

    show_str_ok:
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
