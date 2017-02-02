#Mapa de registos
# $t0 - value
# $t1 - bit
# $t2 - i
.data
str1: .asciiz "Introduza um numero: "
str2: .asciiz "\n O valor em binario e': "
.eqv print_string,4
.eqv read_int,5
.eqv print_char,11 
.text
main:
la $a0,str1
li $v0,print_string	
syscall			#print_string("Introduza um numero:")
li $v0,read_int
syscall
move $t0,$v0
li $t2,0		#i = 0
for:bge $t2,32,endfor	#while(i<32){
andi $t1,$t0,0x80000000	#bit = value & 0x80000000;
#srl $t3,$t0,31		#bit = (value>>31) & 0x00000001;  
#andi $t1,$t3,0x01	#print_char(0x30 + bit)
rem $t3,$t2,4
if_1: bne $t3,0,endif_1	#if(i%4)==0               if((i&3)==0), ver se os 2 bits menos sig. são 0 (2^n, n = 2 neste caso)
li $v0,print_char 	#	
li $a0,' '		#
syscall			#	print_char(' ');
endif_1:
if_2:bne $t1,0,else_2	#	if(bit==0){
li $v0,print_char	#
li $a0,'0'		#
syscall			#		print_char('0');
j endif_2
else_2:			#	else
li $a0,'1'		#		
syscall			#		print_char('1');
endif_2:
sll $t0,$t0,1		#	value = value <<1;
add $t2,$t2,1		#	i++;
j for			#}
endfor:			#
jr $ra			#fim do programa
