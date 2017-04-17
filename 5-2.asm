%include 'macro.h'
global fname,fd,cha
extern calculate

section .data
msg1 db 10,"Enter Filename ",10
len1 equ $-msg1
msg2 db 10,"Enter character to be searched: ",10
len2 equ $-msg2
msg3 db 10,"File Open Succesfully ",10
len3 equ $-msg3
msg4 db 10,"File Open Unsuccesful ",10
len4 equ $-msg4

section .bss
	fname resb 50
	fd resq 1
	cha resb 02
	x resb 1
	char_buff resb 16

section .text
global _start
_start:
write msg1,len1
read 0,fname,50
dec rax
mov byte[fname+rax],0
fopen fname
CMP rax,0H
JL err
mov qword[fd],rax
write msg3,len3
write msg2,len2
read 0,cha,02
call calculate

err: write msg4,len4
fclose [fd]
exit





