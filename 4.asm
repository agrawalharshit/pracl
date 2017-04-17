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
     db "1. Multiplication by Successive Addition ",10
     db "2. Multiplication by Shift Method ",10
     db "Enter your choice",10
menul equ $-menu
msg1 db "Result: ",10
len1 equ $-msg1
msg2 db "Enter Multiplier: ",10
len2 equ $-msg2
msg3 db "Enter Multiplicand: ",10
len3 equ $-msg3

section .bss

	; n3 resq 16
	cho resb 02
	nlen resq 01
	char_buff resb 17
	b resq 1
	q resq 1
	a resq 1

section .text
global _start
_start:

menulbl:
	write msg2,len2
		read char_buff,17
		dec rax
		mov qword[nlen],rax
		call convert
		mov qword[b],rbx

	write msg3,len3
		read char_buff,17
		dec rax
		mov qword[nlen],rax
		call convert
		mov qword[q],rbx

	write menu,menul
		read cho,02
		cmp byte[cho],31H
		JE m1
		cmp byte[cho],32H
		JE m2
		exit
	m1:
		mov rbx,00H
		mov rcx,qword[q]
		up: 
			add rbx,qword[b]
			dec rcx
		JNZ up
		call display
		JMP menulbl

	m2:
		mov qword[a],0
		mov rcx,64
		up1:
			mov rbx,qword[q]
			mov dl,bl
			AND dl,01
			CMP dl,00
			JE shiftr
				mov rax,qword[a]
				add rax,qword[b]
				mov qword[a],rax
			shiftr: 
				mov rbx,qword[a]
				mov dl,bl
				AND dl,01
				CMP dl,01
				JE add1
					shr rbx,1
					mov qword[a],rbx
					mov rbx,qword[q]
					shr rbx,1
					mov qword[q],rbx
				        jmp skip

				add1:
					shr rbx,1
					mov qword[a],rbx
					mov rbx,qword[q]
					shr rbx,1
					mov rdx,1
					shl rdx,63
					add rbx,rdx
					mov qword[q],rbx
				skip:
					dec rcx
		JNZ up1
		write msg1,len1
		mov rbx,qword[a]
		call display
		mov rbx,qword[q]
		call display
JMP menulbl

display:
	mov rsi,char_buff
	mov rcx,16
	up2:
		rol rbx,04H
		mov dl,bl
		AND dl,0FH
		CMP dl,09H
		JBE add30
			add dl,07H
		add30: add dl,30H
		mov byte[rsi],dl
		inc rsi
		dec rcx
	JNZ up2
	write char_buff,16
	RET

convert:
	mov rsi,char_buff
	mov rbx,00H
	mov rdx,00H
	up4:
		shl rbx,04
		mov dl,byte[rsi]
		CMP dl,39H
		JBE sub30
			sub dl,07H
		sub30:
			sub dl,30H
			add rbx,rdx
			inc rsi
			dec qword[nlen]
	JNZ up4
	RET

























