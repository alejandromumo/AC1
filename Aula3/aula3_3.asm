#Mapa de registos
# $t0 - value
# $t1 - bit
# $t2 - i
# $t3 - flag
.data
str1: .asciiz "Introduza um numero: "
str2: .asciiz "\n O valor em binario e': "
.eqv print_string,4
.eqv read_int,5
.eqv print_char,11 
.text
main:
.eqv value,$t0
.eqv bit,$t1
.eqv i,$t2
.eqv flag,$t3
la $a0,str1
li $v0,print_string	
syscall			#print_string("Introduza um numero:")
li $v0,read_int
syscall
move $t0,$v0
li i,0			#i = 0
li flag,0		#flag = 0
for:bge i,32,endfor	#while(i<32){
srl bit,value,31	#bit = (value>>31) & 0x00000001;   
beq flag,1,if_1    	#if(flag == 1 || bit != 0)
beq bit,0,endif_1	#
if_1: li flag,1 		#	flag = 1 ;
rem $t4,i,4		#		
if_2: bne $t4,0,endif_2	#	if(i%4)==0	
li $v0,print_char 	#		print_char(' ');
li $a0,' '		#
syscall			# 	
endif_2:			#
li $v0,print_char	#	print_char( 0x30 + bit);
addi $a0,bit,0x30	#
syscall			#
endif_1:			#
sll value,value,1	#	value = value <<1;
add i,i,1		#	i++;
j for			#}
endfor:			#
jr $ra			#fim do programa
