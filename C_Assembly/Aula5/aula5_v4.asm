# Mapa dos registos
#	houve_troca: $t4
#	p: $t5
#	ultimo: $t6
	
	.data
	.eqv SIZE,10
	.eqv TRUE,1
	.eqv FALSE,0
	.eqv print_string,4
	.eqv read_int,5
	.eqv print_int10,1
str3:	.asciiz ";"
str2:	.asciiz "\nConteudo do array: \n"
str1:	.asciiz "\nIntroduza um numero: "
	.align 2
lista:	.space 40
	.text
	.globl main
main:
	li $t0,0# i = 0
#we read ints to array
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
#sort begins
	la $t5,lista # $t5 -> &lista[0]
	li $t8,SIZE  
	subu $t8,$t8,1
	sll $t8,$t8,2 #$t8 -> (SIZE-1)*4
	addu $t6,$t5,$t8 # $t6 -> pultimo = lista{0] + (SIZE-1)
do1:	li $t4,FALSE
for2:	la $t5,lista
test2:	bgeu $t5,$t6,endfor2
	lw $t0,0($t5) # $t0 -> *p
	lw $t1,4($t5) # $t1 -> *(p+1)
if3:	bleu $t0,$t1,endif3
then3:	sw $t1,0($t5)
	sw $t0,4($t5)
	li $t4,TRUE
endif3:
next2:	addu $t5,$t5,4
	j test2
endfor2:
while1: beq $t4,TRUE,do1
#sort ends
	la $a0,str2
	li $v0,print_string
	syscall
	la $t0,lista # $t0 = lista[0]
	li $t2,SIZE
	sll $t2,$t2,2
	addu $t2,$t2,$t0 # limite supeerior
while4:
	bge $t0,$t2,endwhile4
	lw $t1,0($t0)
	move $a0,$t1
	li $v0,print_int10
	syscall
	la $a0,str3
	li $v0,print_string
	syscall
	addiu $t0,$t0,4
	j while4
endwhile4:
jr $ra#
	
