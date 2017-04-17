%macro fopen 2
	mov rax,2
	mov rdi,%1
	mov rsi,%2
	mov rdx,0777o
	syscall
%endmacro

%macro fclose 1
	mov rax,3
	mov rdi,%1
	syscall
%endmacro

%macro write 3
	mov rax,1
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
	syscall
%endmacro

%macro read 3
	mov rax,0
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
	syscall
%endmacro

%macro exit 0
	mov rax,60
	mov rdi,0
	syscall
%endmacro

%macro del 1
	mov rax,87
	mov rdi,%1
	syscall
%endmacro

section .data
	menu db "1. type",10
	     db "2. copy",10 
	     db "3. delete",10
	     db "4. Exit",10
	len equ $-menu
	msg1 db "src could not be opened",10
	len1 equ $-msg1
	msg2 db "des could not be opened",10
	len2 equ $-msg2
	msg3 db "file copied succesfully",10
	len3 equ $-msg3
	msg4 db "file deleted succesfully",10
	len4 equ $-msg4
	msg5 db "parameter missing",10
	len5 equ $-msg5
	msg6 db "too many parameter",10
	len6 equ $-msg6

section .bss
	sname resb 50
	dname resb 50
	fds resq 1
	fdd resq 1
	buff resb 50
	char resb 01
	act1 resq 01
	choice resb 02
	argc resq 1

section .text
global _start
_start:
	pop rcx
	mov qword[argc],rcx
	cmp qword[argc],03H
	JL err1
	JG err2
	pop rcx
	pop rcx
	mov rsi,sname
	mov rdx,00H
	up:
		cmp byte[rcx+rdx],0
		JE skip
		mov bl,byte[rcx+rdx]
		mov byte[rsi+rdx],bl
		inc rdx
	jmp up
		skip: mov byte[rsi+rdx],0
		pop rcx
		mov rsi,dname
		mov rdx,00H
		up1:
			cmp byte[rcx+rdx],0
			JE skip1
			mov bl,byte[rcx+rdx]
			mov byte[rsi+rdx],bl
			inc rdx
		jmp up1
		skip1: mov byte[rsi+rdx],0

		menulbl : write 1,menu,len
		read 0,choice,02
		cmp byte[choice],31h
		JE case1
		cmp byte[choice],32h
		JE case2
		cmp byte[choice],33h
		JE case3
		cmp byte[choice],34h
		JE case4
		JMP menulbl

case1:
fopen sname,00H
cmp rax,00H
JL err3
mov [fds],rax
l1:
	read [fds],buff,50
	cmp rax,00
	JE next1
	mov [act1],rax
	write 1,buff,[act1]
jmp l1
next1: fclose [fds] 
JMP menulbl

case2:
fopen sname,00H
cmp rax,001
JL err3
mov [fds],rax
fopen dname,0101
cmp rax,00
jl err4
mov [fdd],rax
l2:
read [fds],buff,50
cmp rax,00
JE next2
mov [act1],rax
write [fdd],buff,[act1]
jmp l2
next2:
write 1,msg3,len3
fclose [fds] 
fclose [fdd]
JMP menulbl

case3:
del sname
jmp menulbl

case4:
exit

err1:
write 1,msg5,len5
exit

err2:
write 1,msg6,len6
exit

err3:
write 1,msg1,len1
exit

err4:
write 1,msg2,len2
exit








