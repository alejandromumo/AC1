.data
str1: .asciiz "Introduza dois numeros:"
str2: .asciiz "Soma:"
.eqv print_string,4
.eqv print_int,1
.eqv read_int,5
.text
.globl main
main:
la $a0,str1
ori $v0,$0,print_string #print_string("Introduza 2 números:");
syscall			#
ori $v0,$0,read_int	#$v0 = read_int(); a
syscall
move $t1,$v0		#a -> $t1
ori $v0,$0,read_int	#$t0 = read_int(); b
syscall
move $t2,$v0		#a-> $t2
la $a0,str2
ori $v0,$0,print_string #print_string("Soma:")
syscall
add $a0,$t1,$t2	#$a0 = $t1 + $t2 (x = a+b)
ori $v0,$0,print_int
syscall
jr $ra
