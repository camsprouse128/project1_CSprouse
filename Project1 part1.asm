#author Cameron Sprouse 
.data
	.word 1200 # P
	.word -1 # R
.text
	addi $s1, $0, 6 #s1 = 6
	addi $s2, $0, 17 #s2 = 17
	addi $s3, $0, 1 #needed for subtraction of the counter and can be used if p = 0; x^0 = 1
	addi $s4, $0, 0x2000 # easier to refer to p
	addi $s5, $0, 0x2004 # easier to store R
	
	lw $t1, 0($s4) #this creates t1 as a counter so the loop knows when to exit
	beq $t1, $0, zero #if p = 0 go to zero
	beq $t1, $s3, one
	
power:	beq $t1, $s3, done
	addu $s1, $s1, $s1# x*2
	addu $t2, $s1, $0# x=y
	addu $s1, $s1, $s1 #x*4
	addu $s1, $s1, $t2
	sub $t1, $t1, $s3 # i--
	
mod:	sub $t3,$s1,$s2			# $t3 = X - Y
	slt $s0, $t3,$0			# If X-Y < 0 , then we should stop
	bne $s0,$0, power
	add $s1,$t3,$0
	#sw $s1, 0($s5)
	j mod
	
zero:	sw $s3, 0($s5) #saves 1 into 0x2004
	j exit
one:	sw $s1, 0($s5) #saves 1 into 0x2004
	j exit
done: 	sw $s1, 0($s5)
	j exit
	
	
	
exit: 	j exit #dead loop