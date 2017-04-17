%macro write 2
	mov rax, 1	;Input system call
	mov rdi, 1	;File descriptor, 1 for keyboard
	mov rsi, %1	;Source index points to destination
	mov rdx, %2 	;The memory required my the message
	syscall
%endmacro

%macro exit 0
	mov rax, 60
	mov rdi, 0
	syscall
%endmacro

section .data 
msg1 db "Factorial", 10
len1 equ $-msg1

er1 db "Parameter missing", 10
lener1 equ $-er1

er2 db "Too many parameters", 10
lener2 equ $-er2


section .bss
char_buff 	resb 16
actl 		resb 8


section .txt
global _start
_start:
	pop rcx			;pop top of the stack and store in rcx	
	cmp rcx, 02		;compare contents rcx to 02
	jl err1			;If lesser, print missing parameters
	jg err2
	pop rcx
	pop rcx
	mov rdx, 0
	mov byte[actl], 0
again:	
	mov bl, byte[rcx + rdx]
	cmp bl, 00h
	je next
	mov [char_buff + rdx], bl
	inc rdx
	inc byte[actl]
	jmp again

next:	call convert

fact: 	push rbx
	call factorial
	mov rbx, rax
	call display
	jmp end

factorial:
	push rbp		;Push rbp onto the stack
	mov rbp, rsp		;Give rbp the value of rsp
	mov rax, [rbp + 16]	;Put the next value in rax
	cmp rax, 1
	je end_factorial
	dec rax 
	push rax 	
	call factorial
	mov rbx, [rbp + 16]
	imul rax, rbx
	
end_factorial:
	mov rsp, rbp
	pop rbp
	ret

convert:
	mov rsi, char_buff
	mov rdx, 00
	mov rbx, 00
up1:
	shl rbx, 04
	mov dl, byte[rsi]
	cmp dl, 39h
	jbe sub30
	sub dl, 07h
sub30:
	sub dl, 30h
	add rbx, rdx
	inc rsi
	dec byte[actl]
	jnz up1
	ret

display:
	mov rsi, char_buff
	mov rcx, 16
up:
	rol rbx, 04
	mov dl, bl
	and dl, 0fh
	cmp dl, 09h
	jbe add30
	add dl, 07h
add30:
	add dl, 30h
	mov [rsi], dl
	inc rsi
	dec rcx 
	jnz up
	write char_buff, 16
	ret

end: 	exit

err1:	write er1, lener1
	jmp end

err2:	write er2, lener2
	jmp end	








OUTPUT::

yolo-aspire-v5-573g:~/ASM$ ./faco
Parameter missing
yolo-aspire-v5-573g:~/ASM$ ./faco 2 3
Too many parameters
yolo-aspire-v5-573g:~/ASM$ ./faco 4
0000000000000018
