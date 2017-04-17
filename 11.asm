extern scanf
extern printf
%macro printfloat 2
push rbp
mov rax,1
mov rdi,%1
movsd xmm0,%2
call printf
pop rbp
%endmacro

%macro scan 2
mov rax,0
mov rdi,%1
mov rsi,%2
call scanf
%endmacro

%macro print 2
mov rax,0
mov rdi,%1
mov rsi,%2
call printf
%endmacro

section .data
msg1 db "enter a,b,c",10,0
mmsg db "mean is ",0
fstr db "%s",0

ffloat db "%lf",0
nl db 10,0

vmsg db "variance is ",0
sdmsg db "standard deviation is ",0
section .bss
a resb 8
b resb 8
c resb 8
n resq 1
temp resd 8
mean resq 1
sd resq 1
addition resq 1
t1 resq 1
t2 resq 1
t3 resq 1
var resq 1
section .text
global main

main:
print fstr,msg1
scan ffloat,a
scan ffloat,b
scan ffloat,c

finit

printfloat ffloat,[a]
print fstr,nl
printfloat ffloat,[b]
print fstr,nl
printfloat ffloat,[c]
print fstr,nl
fld qword[a]
fadd qword[b]
fadd qword[c] 
fst qword[addition]    ;a+b+c
mov dword[temp],3
fidiv dword[temp]
fstp qword[mean]
print fstr,mmsg
printfloat ffloat,[mean]
fld qword[a]
fsub qword[mean]      ;a-mean
fmul st0,st0           ;(a-mean)^2
fstp qword[t1]      ;t1=(a-mean)^2
fld qword[b]
fsub qword[mean]      ;b-mean
fmul st0,st0           ;(b-mean)^2
fstp qword[t2]      ;t2=(b-mean)^2
fld qword[c]
fsub qword[mean]      ;c-mean
fmul st0,st0           ;(c-mean)^2
fstp qword[t3]      ;t3=(c-mean)^2
fld qword[t1]
fadd qword[t2]
fadd qword[t3]
fidiv dword[temp]
fstp qword[var]
print fstr,nl
print fstr,vmsg
printfloat ffloat,[var]

fld qword[var]
fabs
fsqrt 
fstp qword[sd]
print fstr,nl
print fstr,sdmsg
printfloat ffloat,[sd]

%ifdef
output

enter a,b,c
2
3
4
2.000000
3.000000
4.000000
mean is 3.000000
variance is 0.666667
standard deviation is 0.816497
%endif


