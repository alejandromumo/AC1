# i -> $t0
# lista -> $t1
# lista +i -> $t2

	.data
	.eqv SIZE,5
	.eqv print_string,4
	.eqv read_int,5
str1:	.asciiz "\nIntroduza um numero: "
	.align 2
lista:	.space 20
	.text
	.globl main
main:
	li $t0,0# i = 0
while0:	bge $t0,SIZE,endwhile0 	# while(i<SIZE)
	la $a0,str1
	li $v0,print_string
	syscall
	li $v0,read_int
	syscall
	la $t3,lista
	sll $t2,$t0,2
	addu $t2,$t2,$t3
	sw $v0,0($t2)
	addi $t0,$t0,1
	j while0
endwhile0:
	jr $ra#
