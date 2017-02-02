# p -> $t0
# pultimo -> $t1
# *p -> $t2
# soma -> $t3
	
	.data
	.eqv SIZE,4
	.eqv print_int10,1
array:	.word 7692,23,5,234

	.text
	.globl main
main:
	li $t3,0		# soma = 0;
	li $t4,SIZE
	sll $t4,$t4,2
	la $t0,array		# p = array;
	addu $t1,$t0,$t4	# pultimo = array+SIZE
while0:				# 
	bgeu $t0,$t1,endwhile0	# while(p<ultimo){	
	lw $t2,0($t0)		#	
	add $t3,$t3,$t2		#	
	addu $t0,$t0,4		# p++
	j while0		#} 
endwhile0:	
	move $a0,$t3		#
	li $v0,print_int10	#
	syscall
	jr $ra