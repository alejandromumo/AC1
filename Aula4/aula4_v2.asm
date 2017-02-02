# Mapa de registos
# num: $t0
# p: $t1
#*p: $t2
	.data
	.eqv SIZE,20
	.eqv read_string,8
	.eqv print_int10,1
str:	.space SIZE
	.text
	.globl main
main:	la $t1,str		# p = str
	li $a1,SIZE		# $a1 = SIZE
	li $v0,read_string	#
	move $a0,$t1
	syscall			# readstring(str,SIZE)
	li $t0,0 		#num=0
				#while(*p!='\0')
while_1:	
	lb $t2,0($t1) 		#
	beqz $t2,end_while_1	#		
if1:	blt $t2,'0',end_if_1	#	if(str[i] >= '0' && str[i] <= '9'	
	bgt $t2,'9',end_if_1	#
	addi $t0,$t0,1		#		num++
end_if_1:	addu $t1,$t1,1		#	p++
	j while_1		#
end_while_1:			#print_int10(num)
	li $v0,print_int10	#
	move $a0,$t0		#
	syscall			#
	jr $ra
