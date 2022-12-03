assume cs:code
code segment
start:
    ;install
    mov ax,code
    mov ds,ax
    mov si,offset logic_sector
    mov ax,0
    mov es,ax
    mov di,200h

    mov cx,offset logic_sector_end - offset logic_sector
    cld
    rep movsb

    ;set
    mov word ptr es:[7ch*4],200h
    mov word ptr es:[7ch*4+2],0

    mov ax,4c00h
    int 21h


;(ah)=功能号(0读1写), (dx)=逻辑扇区号, es:bx->数据内存区
logic_sector:
    cmp ah,1
    ja lret

    push cx
    push dx

    push ax
    push bx
    mov ax,dx
    mov dx,0
    mov bx,1440
    div bx
    mov bx,dx   ;bx暂存余数
    mov dh,al   ;面号
    
    mov ax,bx
    mov bl,18
    div bl
    mov ch,al   ;磁道号
    mov cl,ah
    inc cl      ;扇区号

    mov dl,0    ;驱动器号

    pop bx     ;恢复内存区
    pop ax      ;恢复功能号
    add ah,2    ;功能号
    int 13h

    pop dx
    pop cx
    lret:
    iret

logic_sector_end:
    nop

code ends
end start
