%macro WRITE 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro EXIT 0
mov rax,60
mov rdi,0
syscall
%endmacro

section .data
arr dq 8123400000000000H,125H,0A123000000001111H,75H,0F123456780000000H
msg1 db "The count of +ve no: ",10,13
len1 equ $-msg1
msg2 db "The count of -ve no: ",10,13
len2 equ $-msg2

section .bss
pcnt resq 1
ncnt resq 1
char_buff resb 16

section .text
global _start
_start:
mov qword[pcnt],0
mov qword[ncnt],0
mov rcx,05H
mov rsi,arr
mov rbx,01
shl rbx,63

up:AND qword[rsi],rbx
JNZ incncnt
inc qword[pcnt]
jmp SKIP
incncnt: inc qword[ncnt]
SKIP: add rsi,08H
dec rcx
jnz up

WRITE msg1,len1
mov rbx,qword[pcnt]
mov rcx,16
mov rsi,char_buff

up1: rol rbx,04
mov dl,bl
AND dl,0FH
CMP dl,09H
jbe add30
add dl,07H
add30:add dl,30H

mov byte[rsi],dl
inc rsi
dec rcx
JNZ up1

WRITE char_buff,16

WRITE msg1,len1
mov rbx,qword[ncnt]
mov rcx,16
mov rsi,char_buff

up2: rol rbx,04
mov dl,bl
AND dl,0FH
CMP dl,09H
jbe add30a
add dl,07H
add30a:add dl,30H

mov byte[rsi],dl
inc rsi
dec rcx
JNZ up2

WRITE char_buff,16

mov rax,60
mov rdi,0
syscall
