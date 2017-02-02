#p: $t0
#*p: $t1
#lista+SIZE: $t2

	.data
str1:	.asciiz ";"
str2:	.asciiz "\nConteudo do array: \n"
lista:	.word 8,-4,3,5,124,-15,87,9,27,15
	.eqv print_int10,1
	.eqv print_string,4
	.eqv SIZE,10
	.text
	.globl main
main:	
	la $a0,str2
	li $v0,print_string
	syscall
	la $t0,lista # $t0 = lista[0]
	li $t2,SIZE
	sll $t2,$t2,2
	addu $t2,$t2,$t0 # limite supeerior
while0:
	bge $t0,$t2,endwhile0
	lw $t1,0($t0)
	move $a0,$t1
	li $v0,print_int10
	syscall
	la $a0,str1
	li $v0,print_string
	syscall
	addiu $t0,$t0,4
	j while0
endwhile0:
	jr $ra
