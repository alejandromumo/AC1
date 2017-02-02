	.data
	
	.eqv print_int10,1
array:	.byte '2','0','1','6','e','2','0','2','0'
	.globl main
	.globl atoi
	.text
	
main:	la $a0,array	# $a0 -> &array[0] para ser passado com o arg para atoi
	subu $sp,$sp,4	# atualizamos o stack pointer
	sw $ra,0($sp)	# armazenamos $ra na stack
	jal atoi 	# atoi($a0)
	move $a0,$v0	#atoi devolve em $v0 , movemos para $a0 (para ser printado)
	li $v0,print_int10 #print(return de atoi)
	syscall
	lw $ra,0($sp)	#repomos o valor de $ra
	addu $sp,$sp,4
	jr $ra

# $v0 -> return = res
# $t0 -> digit
# $a0 -> &s[0]
# $t0 -> *s
atoi:	subu $sp,$sp,4	#
	sw $ra,0($sp)	# salvaguardar $ra
	li $v0,0	# res = 0
while0:	lb $t1,0($a0)
	blt $t1,'0',endwhile0
	bgt $t1,'9',endwhile0
	lb $t9,0($a0)
	addiu $a0,$a0,1
	subi $t0,$t9,'0'
	li $t7,10
	mult $v0,$t7
	mflo $t8
	add $v0,$t8,$t0
	j while0
endwhile0:
	lw $ra,0($sp)
	addu $sp,$sp,4
	jr $ra
	
		
	