# Mapa de registos
# num: $t0
# i: $t1
# str: $t2
# str+i: $t3
# str[i]: $t4
	.data
	.eqv SIZE,20
	.eqv read_string,8
	.eqv print_int10,1
str:	.space SIZE
	.text
	.globl main
main:	la $a0,str		# $a0 = &str[0]
	li $a1,SIZE		# $a1 = SIZE
	li $v0,read_string	#
	syscall			# readstring(str,SIZE)
	li $t0,0 		#num=0
	li $t1,0		#i=0
				#while(str[i] != '\0'             , $t8 = str + i = &str[i]
	la $t2,str		#	$t2 = str ou &str
while_1:	
	addu $t3,$t2,$t1	#	$t3=str+i ou &str[i]
	lb $t4,0($t3) 		#	$t4= str[i]
	beqz $t4,end_while_1	#		
if1:	blt $t4,'0',end_if_1	#	if(str[i] >= '0' && str[i] <= '9'	
	bgt $t4,'9',end_if_1	#
	addi $t0,$t0,1		#		num++
end_if_1:	addi $t1,$t1,1		#	i++
	j while_1		#
end_while_1:			#print_int10(num)
	li $v0,print_int10	#
	move $a0,$t0		#
	syscall			#
jr $ra
