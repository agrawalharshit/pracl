%include 'macro.h'
extern fname,fd,cha
global calculate

calculate:
section .data
msg5 db 10,"Space Count: ",10
len5 equ $-msg5
msg6 db 10,"NewLine Count: ",10
len6 equ $-msg6
msg7 db 10,"Character Count: ",10
len7 equ $-msg7

section .bss
	scnt resq 1
	ncnt resq 1
	ccnt resq 1
	x resb 1
	char_buff resb 16

section .text
mov qword[ccnt],0
mov qword[scnt],0
mov qword[ncnt],0

	up:
		read [fd],x,01
		CMP rax,00H
		JE next
		CMP byte[x],0AH
			JNE l1
				inc qword[ncnt]
	JMP up
		l1:
			CMP byte[x],20H
			JNE l2
				inc qword[scnt]
	JMP up
		l2:
			mov bl,byte[cha]
			CMP byte[x],bl
			JNE up
				inc qword[ccnt]
	JMP up


ret

next:
	write msg5,len5
	mov rbx,qword[scnt]
		call display

	write msg6,len6
	mov rbx,qword[ncnt]
		call display

	write msg7,len7
	mov rbx,qword[ccnt]
		call display
	ret

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



