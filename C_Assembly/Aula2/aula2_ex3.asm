.data
str1: .asciiz "So para chatear"
str2: .asciiz "AC1 - Aulas praticas"
.eqv print_string,4
.text
.globl main
main:
la $a0,str1
ori $v0,$0,print_string
syscall
jr $ra