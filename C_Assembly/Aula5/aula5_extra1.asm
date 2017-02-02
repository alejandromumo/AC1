# Mapa dos registos
#	houve_troca: $t4
#	i: #t5
#	lista: $t6
#	lista+i: $t7
	
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
for1:	li $t5,0	#$t5 -> i
	li $t4,SIZE	#$t4 -> SIZE
	subi $t6,$t4,1 #$t6 -> SIZE-1
test1:	bge $t5,$t6,endfor1
	la $t9,lista	#$t4 -> &lista[0]
body1:
for2:	addi $t7,$t5,1 # $t7 = i +1 = j
test2:	bge $t7,$t4,endfor2
body2:	sll $t3,$t5,2 	# $t3 = i*4
	addu $t3,$t3,$t9 # $t3 = (i*4)+lista[0]
	lw $t0,0($t3) #$t0 -> lista[i]
	sll $t2,$t7,2	# $t2 = j*4
	addu $t2,$t2,$t9 #$t2 = (j*4)+lista[0]
	lw $t1,0($t2) #$t1 -> lista[j]
if3:	ble $t0,$t1,endif3
then3:	sw $t1,0($t3)
	sw $t0,0($t2)
endif3:
next2:	addi $t7,$t7,1
	j test2
endfor2:
next1:	addi $t5,$t5,1
	j test1
endfor1:
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
	
