	.data
	.eqv print_int16,34
	.eqv print_char,11
	.text
	.globl main
	main: 	li $t0,0xAAAAAAAA
		andi $a0,$t0,0xF000
		srl $a0,$a0,12
		ori $v0,$0,print_int16
		syscall
		ori $v0,$0,print_char
		ori $a0,$0,' '
		syscall
		jr $ra