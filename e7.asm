assume cs:codesg,ss:stacksg,ds:data

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

table segment
    db 21 dup ('year summ ne ?? ')
table ends

stacksg segment
    dw 8 dup (0)
stacksg ends

codesg segment
start:  mov ax,data
        mov ds,ax

        mov ax,table
        mov es,ax

        mov ax,stacksg
        mov ss,ax
        mov sp,16

        mov bx,0
        mov bp,0
        mov cx,21
    s0: push cx

        push bx
        add bx,bx

        ;年份
        mov si,0
        mov cx,4
    s:  mov al,[bx].0h[si]
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

        mov ax,4c00h
        int 21h
codesg ends

end start
