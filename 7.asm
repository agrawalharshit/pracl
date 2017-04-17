%macro fopen 2
	push rsi
	push rdi
	mov rax,2
	mov rdi,%1
	mov rsi,%2
	mov rdx,0777o
syscall
	pop rdi
	pop rsi
	
%endmacro

%macro fclose 1
	mov rax,3
	mov rdi,%1
syscall	
%endmacro

%macro write 3
	push rsi
	push rdi
	mov rax,1
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
syscall
	pop rdi
	pop rsi
	
%endmacro

%macro read 3
	push rsi
	push rdi
	mov rax,0
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
syscall
	pop rdi
	pop rsi
	
%endmacro

%macro exit 0
	mov rax,60
	mov rdi,0
	syscall
%endmacro

section .data
	nl db 10
	msg1 db "file could not be opened",10
	len1 equ $-msg1
	msg2 db "file opened succesfully",10
	len2 equ $-msg2
	msg3 db "Enter File Name: ",10
	len3 equ $-msg3
msg4 db "testing ",10
len4 equ $-msg4

section .bss
	fname resb 50
	fd resq 1
	x resq 1
	arr resq 10
	n resb 10
	char_buff resb 16
	actl resq 1

section .text
global _start
_start:
	write 1,msg3,len3
	read 0,fname,50
	dec rax
	mov byte[fname+rax],0
	fopen fname,00
	cmp rax,0
	JL err
        mov [fd],rax
	write 1,msg2,len2
	
	mov byte[n],0
        mov rdi,arr
	
	l2:
	
		mov rsi,char_buff
		mov qword[actl],0
		
		l1:
			read [fd],x,01

			cmp rax,00H
				JE next
			cmp byte[x],0AH
				JE nextnum
			mov bl,byte[x]
			mov byte[rsi],bl
			inc rsi
			inc qword[actl]
		JMP l1
		nextnum: call convert
		mov [rdi],rbx
		add rdi,08
		inc byte[n]
	JMP l2

	next: fclose [fd]
	mov ch,byte[n]
	dec ch
	outer:
		mov rsi,arr
		mov cl,byte[n]
		dec cl
		inner:
			mov rbx,qword[rsi]
			cmp qword[rsi+8],rbx
			JG skip
				mov rbx,qword[rsi]
				mov rax,qword[rsi+8]
				mov qword[rsi],rax
				mov qword[rsi+8],rbx
			skip:
				add rsi,8
				dec cl
		JNZ inner
		dec ch
	JNZ outer

	fopen fname,01
	cmp rax,00
	JL err
	mov [fd],rax
	mov rsi,arr
	print:
		mov rbx,qword[rsi]
		call display
		write [fd],char_buff,16
		write [fd],nl,01
		add rsi,8
		dec byte[n]
	JNZ print
	fclose [fd]
exit

convert:
	
	mov rbp,char_buff
	mov rbx,0
	mov rdx,0
	up1:
		shl rbx,04
		mov dl,byte[rbp]
		cmp dl,39H
		JBE sub30
			sub dl,07H
		sub30: sub dl,30H
		add rbx,rdx
		inc rbp
		dec qword[actl]
	JNZ up1
	
ret

display:
	push rsi
	mov rcx,16
	mov rsi,char_buff
	again:
		rol rbx,04
		mov dl,bl
                and dl,0FH
		cmp dl,09H
		JBE add30
		add dl,07H
		add30: add dl,30H
		mov byte[rsi],dl
		inc rsi
		dec rcx
	JNZ again
	pop rsi
ret

err: write 1,msg1,len1
exit

***OUTPUT***

harshit@harsh:~$ nasm -f elf64 sorted.asm
harshit@harsh:~$ ld -o sorted sorted.o
harshit@harsh:~$ ./sorted
Enter File Name: 
sorted.txt
file opened succesfully
harshit@harsh:~$ cat sorted.txt
0000000000000101
0000000000000112
0000000000000123
0000000000000205
0000000000000231
0000000000000405
0000000000000456
0000000000000777
0000000000000786
0000000000000999

**********
