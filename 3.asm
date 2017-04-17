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
	     db "1. HEX to BCD ",10
	     db "2. BCD to HEX ",10
	     db "Enter your choice",10
	menul equ $-menu
	msg1 db "Result: ",10
	len1 equ $-msg1

section .bss
	char_buff resb 17
	nlen resq 1
	x resb 1
	y resb 1
	cnt resb 1
	cho resb 2
	result resb 1

section .text
global _start
_start:

	write menu,menul
	read cho,02
	CMP byte[cho],31H
	jmp l1
	CMP byte[cho],32H
	jmp l2
	exit

	l1:
		call convert
		mov qword[result],rbx
		mov byte[cnt],0h
		mov rax,qword[result]
		mov rbx,0Ah
		continue:
			mov rdx,0h
			div rbx
			push rdx
			inc byte[cnt]
			cmp rax,0h
		jnz continue
		up:
			pop rdx
			add dl,30h
			mov byte[x],dl
			write x,01
			dec byte[cnt]
		jnz up
	JMP menu	

	l2:
		read char_buff,17
		dec rax
		mov qword[nlen],rax
		mov byte[y],0
		mov rsi,char_buff
		mov rbx,0AH
		mov rax,0
		up1:
			mov rdx,0
			mul rbx
			mov dl,byte[rsi]
			sub dl,30H
			add rax,rdx
			inc rsi
			inc byte[y]
			dec byte[nlen]
		JNZ up1
		write msg1,len1
		write rax,y
	JMP menu

	convert:
		read char_buff,17
		dec rax
		mov qword[nlen],rax
		mov rsi,char_buff
		mov rbx,0
		mov rdx,00h
		up2:
			shl rbx,04
			mov dl,byte[rsi]
			cmp dl,39h
			jbe sub30
			sub dl,07h
			sub30: sub dl,30h
			add rbx,rdx
			inc rsi
			dec qword[nlen]
		jnz up2
		ret






