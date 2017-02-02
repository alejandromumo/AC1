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
do1:			#do{
	li $t4,FALSE 	# houveTroca= FALSE
for2:	li $t5,0	# i fica em $t5
	li $t8,SIZE	#SIZE-1 fica em $t8
	subi $t8,$t8,1
test2:	bge $t5,$t8,endfor2
if3:	la $t6,lista	#lista[0] fica em $t6
	sll $t9,$t5,2	# 4*i
	addu $t6,$t6,$t9# lista[i] em $t6
	lw $t9,0($t6) # aux em $t9
	lw $t0,4($t6) # lista[i+1] fica em $t0
	ble $t9,$t0,endif3
then3:	sw $t0,0($t6)
	sw $t9,4($t6)
	li $t4,TRUE
endif3: 
next2:	addi $t5,$t5,1
	j test2
endfor2: 
while1: beq $t4,TRUE,do1			#while(houvertroca==TRUE)
end1:
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
	
