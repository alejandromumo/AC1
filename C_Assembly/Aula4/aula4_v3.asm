# $t0 - p 
# $t1 - pultimo
# $t2 - *p
# $t3 - soma


	.data
array:	.word 7692,23,5,234
	.eqv SIZE,4
 	.eqv print_int10,1
	.text
	.globl main
main:	
					#
	li $t4,SIZE			#
	sll $t4,$t4,2			#
	li $t3,0			# 
	la $t0,array			#
	addu $t1,$t0,$t4		# la $t1,array+16  (16 pq é SIZE*4)
while0:					#
	bgeu $t0,$t1,endwhile0		#
	lw $t2,0($t0)			#
	add $t3,$t3,$t2			#
	addu $t0,$t0,4			#
	j while0
endwhile0:				#
	move $a0,$t3			#
	li $v0,print_int10		#
	syscall
	
	
	
	 
