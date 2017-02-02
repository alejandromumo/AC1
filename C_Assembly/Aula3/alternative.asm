#Mapa de registos
# $t0 - value
# $t1 - bit
# $t2 - i
	.data
	
str1: 	.asciiz "Introduza um numero: "
str2: 	.asciiz "\n O valor em binario e': "
	.eqv print_string,4
	.eqv read_int,5
	.eqv print_char,11 
	.text

main:
	.eqv value,$t0
	.eqv i,$t1
	.eqv tmp,$t9
	la $a0,str1
	li $v0,print_string
	syscall
	li $v0,read_int
	syscall
	move value,$v0
	la $a0,str2
	li $v0,print_string
	syscall
for0:	li i,0
test0:	bge i,32,end0
body0:
if1:	beqz i,end1
	andi tmp,i,3
	bnez tmp,end1
then1:	li $a0,' '
	li $v0,print_char
	syscall
end1:
	sra tmp,value,31 # value >> 31
	li $a0,'0'
	sub $a0,$a0,tmp
	li $v0,print_char
	syscall
	sll value,value,1
next0:  addi i,i,1
	j test0
end0:	li $a0,'\n'
	li $v0,print_char
	syscall
	jr $ra
