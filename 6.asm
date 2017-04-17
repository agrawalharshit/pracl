6
section .data

msg1 db "Real mode is activated",10
msg1_len equ $-msg1

msg2 db "Protected mod is activated::",10
msg2_len equ $-msg2

msg3 db "Status of GDTR",10
msg3_len equ $-msg3

msg4 db "Status of IDTR",10
msg4_len equ $-msg4

msg5 db "Status of LDTR",10
msg5_len equ $-msg5

msg6 db "Status of TR",10
msg6_len equ $-msg6

msg_space db" ",10
msg_space_len equ $-msg_space

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

section .bss
GDT resd 1    ; Size of GDTR IS 48
     resw 1

IDT resd 1    ; Size  of IDTR IS 48
     resw 1

LDT resw 1   ; Size of LDTR is 16

TR  resw 1  ;  Size of TR is 16

msw resd 1  ; Size of MSW is 32 

CR0_data resd 1 ; Size of CR0 is 32

buff resq 1

 




section .text

global _start
_start:

smsw eax
mov [CR0_data],eax
and eax,01
cmp eax,01
je pro
jmp l1
l1: write msg1,msg1_len
pro:write msg2,msg2_len

SGDT [GDT]
SIDT [IDT]
SLDT [LDT]
STR  [TR]

mov rbx,[GDT]
write msg3,msg3_len
call disp
write msg_space,msg_space_len

mov rbx,[IDT]
write msg4,msg4_len
call disp
write msg_space,msg_space_len

mov rbx,[LDT]
write msg5,msg5_len
call disp
write msg_space,msg_space_len

mov rbx,[TR]
write msg6,msg6_len
call disp
write msg_space,msg_space_len



mov rax,60
mov rdi,0
syscall



disp:  

mov rsi,buff
mov rcx,16
mov rdx,00
up2:
rol rbx,04
mov dl,bl
and dl,0fh
cmp dl,09
jbe mc
add dl,07h
mc:
add dl,30h
mov [rsi],dl
inc rsi
dec rcx
jnz up2
write buff,16
ret

OUTPUT

Protected mod is activated::
Status of GDTR
0FFF72144000007F 
Status of IDTR
000081E140000FFF 
Status of LDTR
0000000000400000 
Status of TR
003B000000000040 

