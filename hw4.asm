#######################################################
# HOMEWORK #4
# NAME: SALVATORE TERMINE
#######################################################

.text
	# New line
	.macro newline
		li $v0, 4
		la $a0, nl
		syscall
	.end_macro
	# Print Decimal Value
	.macro printDecvalue(%x)
		li $v0, 1
		move $a0,%x
		syscall
	.end_macro
	.macro printCoord(%a, %b)
		li $v0, 4		
		la $a0, pSudoku1
		syscall
	
		li $v0, 1
		move $a0, $a1
		syscall
	
		li $v0, 4		
		la $a0, pSudoku2
		syscall
	
		li $v0, 1
		move $a0, $a2
		syscall
	
		li $v0, 4		
		la $a0, pSudoku3
		syscall
		newline
	.end_macro
	.macro printSpace
		li $v0, 4		
		la $a0, sp1
		syscall
	.end_macro
#######################################################
# Computes the Nth number of the Hofsadter Female Sequence
# public int F (int n)
#######################################################

F:	addi $sp, $sp, -8		# Make room on stack
	sw $s0, 0($sp)			# Preserve S register
	sw $ra, 4($sp) 			# Save ra
	
	move $s0, $a0			# Move argument n to $s0
	
	li $v0, 4			# Print String
	la $a0, hfMsg			# Message "F: "
	syscall
	
	li $v0, 1			# Print String
	move $a0, $s0			# Message "n "
	syscall	
	newline				# New Line
	
# If base case
	beqz $s0, Fbase			# Base Case n = 0
	
# Else
	addi $t0, $s0, -1		# Subtract 1 from n
	move $a0, $t0	
	jal F				# Call M
	
	move $t1, $v0			# Move $v0 to $t1
	move $a0, $t1			# Move $t1 to $a0
	jal M				# Call F
	
	sub $v0, $s0, $v0		# n - F(M(n-1)
	lw $s0, 0($sp)			# load n
	lw $ra, 4($sp)			# load $ra
	addi $sp, $sp, 8		# Restore stack
	jr $ra
	
	Fbase: 
		lw $s0, 0($sp)		# Load original values back
		lw $ra, 4($sp)
		addi $sp, $sp, 8	# Reset stack
		li $v0, 1		# Return 1
		jr $ra			# Back to after 

#######################################################
# Computes the Nth number of the Hofsadter Male Sequence
# public int M (int n)
#######################################################	
M:
	addi $sp, $sp, -8		# Make room on stack
	sw $s0, 0($sp)			# Preserve s register
	sw $ra, 4($sp) 			# Preserve ra
	
	move $s0, $a0			# Move argument n to $s0
	
	li $v0, 4			# Print String
	la $a0, hmMsg			# Message "M: "
	syscall
	
	li $v0, 1			# Print String
	move $a0, $s0			# Message "n "
	syscall	
	newline				# New Line
	
# If base case
	beqz $s0, Mbase			# Base Case n = 0
	
# Else
	addi $t0, $s0, -1		# Subtract 1 from n
	move $a0, $t0	
	jal M				# Call M
	
	move $t1, $v0			# move $v0 to $a0
	move $a0, $t1
	jal F				# Call F
	
	sub $v0, $s0, $v0		# n - F(M(n-1)
	lw $s0, 0($sp)			# load n
	lw $ra, 4($sp)			# load $ra
	addi $sp, $sp, 8		# Restore stack
	jr $ra
	
	Mbase: 
		lw $s0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		li $v0, 0		# Return 0
		jr $ra			# Back to after  

#####################################################
# Tak Function
# public int tak (int x, int y, int z)
#####################################################
tak:
	addi $sp, $sp, -28 		# Make room on stack
	sw $s0, 0($sp)			# Save s registers
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $a0, 12($sp)			# Original X Value
	sw $a1, 16($sp)			# Original Y Value
	sw $a2, 20($sp)			# Original Z Value
	sw $ra, 24($sp) 		# Preserve ra
	
	# If Base Case
	bge $a1, $a0, Tbase		
	
	# Else 
	addi $a0, $a0, -1
	jal tak
	move $s0, $v0
	
	lw $a0, 16($sp)		# X
	lw $a1, 20($sp)		# Y
	lw $a2, 12($sp)		# Z
	addi $a0, $a0, -1
	jal tak
	
	move $s1, $v0
	
	lw $a0, 20($sp)		# X
	lw $a1, 12($sp)		# Y
	lw $a2, 16($sp)		# Z
	addi $a0, $a0, -1
	
	jal tak
	move $s2, $v0
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal tak
	move $v0, $a2
	j TakPop
	
	Tbase: 
		move $v0, $a2
	TakPop:
		lw $s0, 0($sp)		# Preserve s register
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $a0, 12($sp)
		lw $a1, 16($sp)
		lw $a2, 20($sp)
		lw $ra, 24($sp)
		addi $sp, $sp, 28 	# Make room on stack
		jr $ra

############################################################
# Helper function for solving sudoku
# public boolean isSolution (int row, int col)
############################################################
isSolution:
	
	beq $a0, 8, checkCol
	j notSolution
	checkCol:
		beq $a1, 8, solution
		j notSolution
	solution:
		li $v0, 1
		jr $ra
	notSolution:
		li $v0, 0
		jr $ra
		
############################################################
# Helper function for solving sudoku
# public void printSolution (byte[][] board)
############################################################
printSolution:
	
	move $t0, $a0			# Move base address of array to $t0
	addi $t1, $zero, 0		# I
	addi $t2, $zero, 0		# J
	li $t3, 9			# Number of rows and cols
	
	li $v0, 4			# Print String
	la $a0, pSolution		# Message "Solution: "
	syscall
	newline
	
	j loopj
	
	loopi:
		newline
		addi $t1,$t1,1		# Add 1 to i
		addi $t2,$zero, 0	# Reset j = 0
		bne $t1,$t3, loopj	# if i = 9 exit otherwise go to loopj
		j finished
	# Row major order base address + (i * 9 * 1) + (j * 1)
	loopj:
		mul $t4, $t3, $t1	# multiply i x columns
		add $t4, $t4,$t2	# add (i * 9) + j
		add $t5, $t0, $t4	# add to base address
		lb $t5, 0($t5)
		printDecvalue($t5)
		printSpace
		addi $t2, $t2, 1
		beq $t2, $t3, loopi
		j loopj
	finished:
		jr $ra

############################################################
# Helper function for solving sudoku
# public (byte [], int) gridSet (byte[][] board, int row, int col)
############################################################
gridSet:				
	addi $sp, $sp, -16
	sw $a0, 0($sp)			# Base Address Board
	sw $a1, 4($sp)			# Row
	sw $a2, 8($sp)			# Column
	sw $ra, 12($sp)			# Return Address
	
	li $t9, 3			# division / multiplication
	li $t8, 9
	
	addi $t0, $zero, 0 		# Counter
	
	move $t1, $a1			# r_start
	div $t1,$t9			# div 3
	mflo $t1			# move to t1
	mul $t1, $t1, $t9		# mul by 3
	
	move $t2, $a2			# c_start
	div $t2,$t9
	mflo $t2
	mul $t2, $t2, $t9
	
	move $t7, $t2
	
	add $t3, $t1, $t9		# r_start MAX
	add $t4, $t2, $t9		# c_start MAX
	j jLoop	
iLoop:
	addi $t1, $t1, 1		# add 1 to row
	beq $t1, $t3, gridDone		# if row = max exit
	move $t2, $t7			# reset c_start
jLoop:			
	beq $t2, $t4, iLoop
	mul $t5, $t1, $t8		# row * 9
	add $t5, $t5, $t2		# add column
	add $t5, $t5, $a0		# add base address
	lb $t6, 0($t5)
	bgtz $t6, addToGset
	addi $t2, $t2, 1
	j jLoop
addToGset:
	la $t9, gSet
	add $t9, $t9, $t0
	sb $t6, 0($t9)
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	j jLoop
gridDone:
	move $v0, $t0
	lw $a0, 0($sp)			# Base Address Board
	lw $a1, 4($sp)			# Row
	lw $a2, 8($sp)			# Column
	lw $ra, 12($sp)			# Return Address
	addi $sp, $sp, 16
	jr $ra

############################################################
# Helper function for solving sudoku
# public (byte [], int) colSet (byte[][] board, int col)
############################################################	
colSet:
	move $t0, $a0			# Board Address
	move $t1, $a1			# Column Number
	addi $t2, $zero, 0		# Counter
	addi $t8, $zero, 0		# Elements Added to cSet
	li $t3, 9			# Max Rows
	la $t4, cSet			# Address of cSet
	addi $t7, $zero, 0
colLoop:
	beq $t2, $t3, colDone		# If row = 9 exit
	mul $t5, $t2, $t3		# Multiply row * 9
	add $t5, $t1, $t5		# Add it to column (counter)
	add $t6, $t0, $t5		# Add it to base address
	lb $t7, 0($t6)			# Load whats at that address
	bgtz $t7, addToCset		# if greater then zero add to rset		SALLLLL
	addi $t2, $t2, 1		# otherwise add 1 to counter and loop
	j colLoop
addToCset:
	add $t9, $t4, $t8
	sb $t7, 0($t9)
	addi $t2, $t2, 1		# 
	addi $t8, $t8, 1
	j colLoop
colDone:
	move $v0, $t8
	jr $ra

############################################################
# Helper function for solving sudoku
# public (byte [], int) rowSet (byte[][] board, int row)
############################################################

				
rowSet:
	move $t0, $a0			# Board Address  
	move $t1, $a1			# Row Number
	addi $t2, $zero, 0		# Counter c0lumn
	addi $t8, $zero, 0		# elements added to array
	li $t3, 9		
	la $t4, rSet			# Address of rSet
	addi $t7,$zero, 0
rowLoop:	
	beq $t2, $t3, rowDone		# If column = 9 exit
	mul $t5, $t1, $t3		# Multiply row * 9
	add $t5, $t2, $t5		# Add it to column (counter)
	add $t6, $t0, $t5		# Add it to base address
	lb $t7, 0($t6)			# Load whats at that address
	bgtz $t7, addToRset		# if greater then zero add to rset		SALLLLL
	addi $t2, $t2, 1		# otherwise add 1 to counter and loop
	j rowLoop
addToRset:
	add $t9, $t4, $t8		# add counter to base address of rset
	sb $t7, 0($t9)			# store what is in row to rowset
	addi $t2, $t2, 1		# add 1 to counter and loop
	addi $t8, $t8, 1
	j rowLoop
rowDone:
	move $v0, $t8
	jr $ra

############################################################
# Helper function for solving sudoku
# public (byte [], int) colSet (byte[][] board, int row, int col)
############################################################			
constructCandidates:
	addi $sp, $sp, -36 		# Save arguments to stack
	sw $a0, 0($sp)			# Base Address for board		
	sw $a1, 4($sp)			# Row
	sw $a2, 8($sp)			# Column
	sw $a3, 12($sp)			# Base Address for candidates
	sw $s0, 16($sp)
	sw $s1, 20($sp)
	sw $s2, 24($sp)
	sw $s3, 28($sp)
	sw $ra, 32($sp)			# Save ra

	addi $s0, $zero, 1		# Counter for loop
	addi $s1, $zero, 0		# r_length
	addi $s2, $zero, 0		# c_length
	addi $s3, $zero, 0		# g_length
	
	
	jal rowSet
	move $s1, $v0			# Move row count to s1
	
	lw $a1, 8($sp)			# Move column to a1
	jal colSet
	move $s2, $v0			# Move colcount to s2
	
	lw $a1, 4($sp)			# Move row to a1
	lw $a2, 8($sp)			# Move col to a2
	jal gridSet
	move $s3, $v0			# Move gridcount to s3
	
	############################################################
	# MOVE THE ADDRESS FOR CANDIDTATES
	lw $a3, 12($sp)	
	move $t2, $a3		# Load address of candidates
	############################################################
	
	addi $t4, $zero, 0
forLoop:
	addi $t3, $zero, 0		# candidates counter
	bgt $s0, 9, conDone		# If greater then 9 leave 
	la $t0, rSet			# Load Address of rset
	rloop:	
	     bgt $t3, $s1, cnext	# Not in row go to cloop
	     lb $t1, 0($t0)		# Load that byte
	     beq $t1, $s0, checkNext	# Compare, if equal exit OW go to cloop
	     addi $t0, $t0, 1		# Add 1 to rset
	     addi $t3, $t3, 1		# Add 1 to offset
	     j rloop
       cnext:
	     addi $t3, $zero, 0		# Zero out offset
	     la $t0, cSet		# Load Address of cset
       cloop:
	     bgt $t3, $s2, gnext	# Not in column go to gloop
	     lb $t1, 0($t0)		# Load that byte
	     beq $t1, $s0, checkNext	# Compare, if equal exit OW go to gloop
	     addi $t0, $t0, 1		# Add 1 to cset
	     addi $t3, $t3, 1		# Add 1 to offset
	     j cloop
       gnext:
       	     addi $t3, $zero, 0
       	     la $t0, gSet		# Load Address of gset
       gloop:
	     lb $t1, 0($t0)		# Load that byte
	     beq $t1, $s0, checkNext      # Compare, if equal exit OW continue
	     addi $t0, $t0, 1		# Add 1 to gset
	     addi $t3, $t3, 1		# Add 1 to offset
	     bgt $t3, $s3, addToCan
	     j gloop
    addToCan:
    	     sb $s0, 0($t2)
    	     addi $t2, $t2, 1
    	     addi $s0, $s0, 1
    	     addi $t4, $t4, 1
    	     j forLoop
    checkNext:
    	     addi $s0, $s0, 1
    	     j forLoop
conDone:
	move $v0, $t4
	lw $a0, 0($sp)			# Restore stack
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $s0, 16($sp)
	lw $s1, 20($sp)
	lw $s2, 24($sp)
	lw $s3, 28($sp)
	lw $ra, 32($sp)					
	addi $sp, $sp, 36 		
	jr $ra

############################################################
# sudoku solver function
# public (byte [], int) colSet (byte[][] board, int x, int y)
############################################################		
sudoku:
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	
	move $fp, $sp

	sw $zero, 0($sp)
	sw $zero, 4($sp)
	sw $zero, 8($sp)
	sw $zero, 12($sp)
	
	addi $sp, $sp, -20
	sw $s0, 0($sp)			# Address of Board
	sw $s1, 4($sp)			# Row
	sw $s2, 8($sp)			# Column
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	
	move $s0, $a0			# Address of Board
	move $s1, $a1			# Row
	move $s2, $a2			# Column
	addi $s4, $zero, 0		# Counter
	
	printCoord($s1,$s2)		# Print the coordinates
	
	###################### CHECK IF SOLUTION ######################
	move $a0, $s1			# Load row into a0
	move $a1, $s2			# Load column into a1
	jal isSolution			# Check if its a solution
	
	###############################################################
	
	###################### Else branch to solved ##################
	beq $v0, 1, solved		# If solution then go to solved
	###############################################################
	
	###################### Add one to column ######################
	addi $s2, $s2, 1 		# Add 1 to Column
	bgt $s2, 8, nextRow		# If at the end of the row
	j checkCell
	###############################################################
	
	###################### Go to next row #########################
	nextRow:
		addi $s1, $s1, 1	# Add 1 to the row
		li $s2, 0		# Reset column to 0
	###############################################################
		
	###################### CHECK THE CELL #########################
	checkCell:
		li $t1, 9
		mul $t1, $t0, $s1 
		add $t0, $s2, $t1 
		add $t0, $s0, $t0 
		lb $t2, 0($t0) 
		beqz $t2, getCandidates	
	
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		jal sudoku
		j constantExit
	################################################################
	getCandidates:
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		move $a3, $fp
		jal constructCandidates
		
		move $s0, $a0
		move $s1, $a1
		move $s2, $a2
		
		sw $v0, 12($fp)
		li $s3, 0 	
		lw $t1, 12($fp)
	
		solveLoop:
			lw $t1, 12($fp)
			blt $s3, $t1,addToBoard
			j constantExit
			addToBoard:
				  li $t0, 9 
				  mul $t1, $t0, $s1 
	 			  add $t0, $s2, $t1 
				  add $t0, $s0, $t0 
				  add $t2, $fp, $s3  
				  sb $t2, 0($t0)
			callSudoku:
				move $a0, $s0
				move $a1, $s1
				move $a2, $s2
				jal sudoku
			backtrack:
				li $t1, 9
				mul $t0, $s1, $t1	# multiply row by 9
				add $t2, $t0, $s2	# ( i * 9) + (j * 1)
				add $t3, $t2, $s0	# Add to base address
				sb $zero, 0($t3) 
				lb $t7, FINISHED
				beq $t7, 1, constantExit
				addi $s3, $s3, 1
				j solveLoop
	############### SOLVED ################################
	solved:
		move $a0, $s0
		jal printSolution
		li $t0, 1
		sb $t0, FINISHED
	#######################################################
	constantExit:
		lw $ra, 20($fp)
		lw $fp, 16($fp)
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp) 
		lw $s3, 12($sp)
		addi $sp, $sp, 44
		jr $ra
	#######################################################
.data

rSet: 		.byte 0:9
cSet: 		.byte 0:9
gSet: 		.byte 0:9
FINISHED: 	.byte 0
hfMsg: .asciiz "F: "
hmMsg: .asciiz "M: "
pSolution: .asciiz "Solution: "
pSudoku1: .asciiz "Sudoku ["
pSudoku2: .asciiz "]["
pSudoku3: .asciiz "]"
start: .asciiz "START"
insideIfNotBlank: .asciiz "insideIfNotBlank"
beforePlacing: .asciiz "beforePlacing"
backtracking: .asciiz "backtracking"
placed: .asciiz "placed"
nl: .asciiz "\n"
sp1: .asciiz " "
