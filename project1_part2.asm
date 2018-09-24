.data 
	T: .word 0xFFFFFFFF
	best_matching_score: .word -1  # best score = ? within [0, 32] 
	best_matching_count: .word -1  # how many patterns achieve the best score? 
	Pattern_Array: .word  0
.text
	lw $s0, 0x2000($0) #s1 = T
	#addi $s1, $0, 0x2004 #s1 becomes best matching score
	#addi $s2, $0, 0x2008 #s2 becomes best matching count
	addi $t0, $0, 0x200c #t0 becomes the register that goes through the pattern array
	addi $t1, $0, 1 #becomes a counter that will count down until = 0 so it knows when pattern array is done

loop:	
	beq $t1, $0, done 
	lw $t2, 0($t0) #loads the desired value in pattern array
	add $s5, $0, $0 #sets s3 to 0 everytime
	addi $t5, $0, 32 #counter
	
	xor $t3, $s0, $t2 #the number of 0's in t3 is = to how many bits match
	xori $t3, $t3, 0xffffffff # essentially NOT's t3 so that the 0's become 1's
	matcher:
		andi $s4, $t3, 1 #if s4 = 1 then increment the matching score counter
		add $s5, $s5, $s4 #s5 = matching score counter
		srl $t3, $t3, 1 #shifts right by 1 bit so the next most significant bit can be ANDed with 1
		addi $t5, $t5, -1 #counts down from 32 to know when to exit loop
		bne $t5, $0, matcher 
	lw $t6, 0x2004($0) #loads the current best matching score
	addi $t1, $t1, -1 #deducts 1 from the pattern array counter 
	addi $t0, $t0, 4
	beq  $t6, $s5, match
	slt $t7, $t6, $s5
	beq $t7, $0, loop
	sw $s5, 0x2004($0)
	addi $s6, $0, 1 #resets the number of best matching count to 1 if a new highest value is found.
	j loop
	
	match:
		addi $s6, $s6, 1
		sw $s6, 0x2008($0)
		j loop
done:
	beq $s5, $0, no_match
	j done
		
		
		
	
	
