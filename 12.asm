.model small
.stack 100h
.data
 msg db "1. Sin ",10,13
     db "2. Cos ",10,13
     db "3. Sinc ",10,13
     db "Enter your choice:",10,13
 x dd 0.0
 x1 dw 0
 x2 dd 0.0
 x3 dw 0
 x4 dd -960.0
 x5 dw 0
 xad dd 3.0
 one80 dd 180.00
 scale dd 30.0
 scale1 dd 1500.0


 fifty dd 50.0
 ycursor dt 0.0
 count dw 640
.code
.386
main:
   mov ax,@data
   mov ds,ax

 menu:   mov ah,09h
   lea dx,msg
   int 21h

   mov ah,01h
   int 21H

   cmp al,31h
   je case1
   cmp al,32h
   je ca2
   cmp al,33h
   je ca3
   mov ah,4ch
   int 21h

   case1:
        mov ah,00h
        mov al,06h
        int 10h
        mov count,420
        up:
                finit
                fldpi
                fdiv one80
                fmul x
                fsin
                fmul scale
                fld fifty
                fsub st,st(1)
                fbstp ycursor
                lea esi,ycursor
                mov ah,0ch
                mov al,01h
                mov bh,00
                mov cx,x1
                mov dx,[esi]
                int 10h
                inc x1
                fld x
                fadd xad
                fstp x
                dec count
                jnz up
                mov ah,00
                int 16h
                mov ah,00
                mov al,03h
                int 10h
                jmp menu
                
   ca2:
        mov ah,00h
        mov al,06h
        int 10h
        mov count,420
        up1:
                finit
                fldpi
                fdiv one80
                fmul x2
                fcos
                fmul scale
                fld fifty
                fsub st,st(1)
                fbstp ycursor
                lea esi,ycursor
                mov ah,0ch
                mov al,01h
                mov bh,00
                mov cx,x3
                mov dx,[esi]
                int 10h
                inc x3
                fld x2
                fadd xad
                fstp x2
                dec count
                jnz up1
                mov ah,00
                int 16h
                mov ah,00
                mov al,03h
                int 10h
                jmp menu
                
ca3:
        mov ah,00h
        mov al,06h
        int 10h
        mov count,640
        up5:
                finit
                fldpi
                fdiv one80
                fmul x4
                fsin
                fdiv x4
                fmul scale1
                fld fifty
                fsub st,st(1)
                fbstp ycursor
                lea esi,ycursor
                mov ah,0ch
                mov al,01h
                mov bh,00
                mov cx,x5
                mov dx,[esi]
                int 10h
                inc x5
                fld x4
                fadd xad
                fstp x4
                dec count
                jnz up5
                mov ah,00
                int 16h
                mov ah,00
                mov al,03h
                int 10h
                jmp menu

end main