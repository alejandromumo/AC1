# $v0 -> return -> len
# $a0 -> *s
#
#
	.data
str1:	.asciiz "Arquitetura de Computadores I"
	.eqv print_int10,1
	.eqv print_string,4
	.text
	.globl main
	.globl strlen
	.globl strrev
	.globl exchange
main:	la $a0,str1	# $a0 -> &str[0]
	subu $sp,$sp,4
	sw $ra,0($sp)
	jal strrev
	move $a0,$v0
	li $v0,print_string
	syscall
	lw $ra,0($sp)
	addu $sp,$sp,4
	jr $ra

strlen:	li $t0,0	# $t0 fica o len 
while0:	lb $t1,0($a0)	# $t1 fica o byte correspondente ao endereço armazenado em $a0
	addiu $a0,$a0,1	# atualiza-se o $a0 para  a seguinte posição (1 byte acima)
	beq $t1,0,endwhile0	#Se o conteúdo lido é igual a '\0' , acabou a string. Não se conta mais
	addi $t0,$t0,1		#Ainda não terminou a string logo somamos 1 ao len
	j while0
endwhile0:
	move $v0,$t0
	jr $ra
	
# char strrev(char *str) 
# devolve em $v0
# recebe argumento em $a0 
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
