	.data
	.globl itoa
	.text
# $a0 -> n
# $a1 -> b
# $a2 -> *s  = &array[0]
#$v0 -> return = s
# $s0 -> n
# $s1 -> b
# $s2 -> *s
# $s3 ->p
# $t9 -> digit
itoa:	addu $sp,$sp,20
	sw $ra,0($sp) # salvaguardar $ra na stack
	sw $s0,4($sp) # salvaguardar $s0 na stack
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	move $s0,$a0
	move $s1,$a1
	move $s2,$a2
	move $s3,$a2
do0:	rem $t9,$s0,$s1
	div $s0,$s0,$s1
	move $a0,
	


while0: #salto condicional
	
	
toascii:
		
	