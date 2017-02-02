.text
.globl main
main: 	ori $8,$0,2 	# $8 = x; x = 10
	ori $t2,$0,8 	# $t2 = 8;
	add $9,$8,$8	# $9 = $8 + $8 (=) y =  x + x = 2*x
	sub $9,$9,$t2	# $9 = $9 + $t2 (=) y = y + 8
	#jr $ra		# fim do programa