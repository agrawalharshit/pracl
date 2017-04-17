%macro write 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro exit 0
mov rax,60
mov rdi,0
syscall
%endmacro

section .data
menu db "***MENU***",10
     db "1. Non-overlaped without String op.",10
     db "2. Overlaped without String op. ",10
     db "3. Non-overlaped with String op. ",10
     db "4. Overlaped with String op. ",10
     db "Enter your choice",10
menul equ $-menu
msg1 db "enter the source string",10
len1 equ $-msg1
msg2 db "the result is",10
len2 equ $-msg2

section .bss
src resb 05
dest resb 05
choice resb 02
len resq 1

section .text
global _start
_start:
write msg1,len1
read src,06
dec rax
mov qword[len],rax
menulbl:
write menu,menul
read choice,02
CMP byte[choice],31h
je l1
CMP byte[choice],32h
je l2
CMP byte[choice],33h
je l3
CMP byte[choice],34h
je l4
exit

l1:
mov rsi,src
mov rdi,dest
mov rcx,qword[len]
up1: mov dl,byte[rsi]
mov byte[rdi],dl
inc rsi
inc rdi
dec rcx
JNZ up1
write msg2,len2
write src,10
JMP menulbl

l2:
mov rsi,src
mov rdi,dest
add rsi,qword[len]
dec rsi
add rdi,02
mov rcx,05
up2: mov dl,byte[rsi]
mov byte[rdi],dl
inc rsi
inc rdi
dec rcx
JNZ up2
write msg2,len2
write src,8
JMP menulbl

l3: 
mov rsi,src
mov rdi,dest
mov rcx,05
cld
rep movsb
write msg2,len2
write src,10
JMP menulbl

l4:
mov rsi,src
mov rdi,dest
add rsi,qword[len]
dec rsi
add rdi,02
mov rcx,05
std
rep movsb
cld
write msg2,len2
write src,8
JMP menulbl
