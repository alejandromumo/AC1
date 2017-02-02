	.data
	
	.text
	.globl strrev

strrev: 	subu $sp,$sp,16
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	move $s0,$a0 # Salva-guardamos o registo a0 que nos foi passado
	move $s1,$a0 # p1 = str . $s1 -> p1
	move $s2,$a0 # p2 = str   $s2 -> p2
while1:	lb $t0,0($s2)
	beq $t0,'\0',endwhile1
	addiu $s2,$s2,1
	j while1
endwhile1:
	subiu $s2,$s2,1
while2:	bgeu $s1,$s2,endwhile2
	jal exchange# chama sub rotina exchange(p1,p2)
	addiu $s1,$s1,1
	subiu $s2,$s2,1
	j while2 
endwhile2:
	move $v0,$s0
	lw $s2,12($sp)
	lw $s1,8($sp)
	lw $s0,4($sp)
	lw $ra,0($sp)
	addu $sp,$sp,16
	jr $ra
exchange:
	lb $t0,0($s1)
	lb $t1,0($s2)
	sb $t0,0($s2)
	sb $t1,0($s1)	
	jr $ra