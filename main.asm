.text
##################################################
.macro label (%str)
	li $v0, 4
	la $a0, %str
	syscall
.end_macro
.macro newLine
	li $a0, 10
	li $v0, 11
	syscall
.end_macro
.macro space
	li $a0, 20
	li $v0, 11
	syscall
.end_macro

.globl main
##################################################

main:
##################################################
#test m and f
##################################################
label(testHof)
newLine
li $a0, 3
jal F
move $t0, $v0

label(result)
move $a0, $t0
li $v0, 1
syscall 
newLine
##################################################
label(testHof)
newLine
li $a0, 3
jal M
move $t0, $v0

label(result)
move $a0, $t0
li $v0, 1
syscall 
newLine

####################################################
#test tak
####################################################
label(testTak)
newLine
li $a0, 5
li $a1, 3
li $a2, 5
jal tak

move $t0, $v0
label(result)
move $a0, $t0
li $v0, 1
syscall 
newLine

####################################################
#is solution
####################################################	
label(testIsSolution)
newLine
li $a0,8
li $a1,8
jal isSolution

move $t0, $v0
label(result)
move $a0, $t0
li $v0, 1
syscall 
newLine
####################################################
#print solution
####################################################
label(testPrintSolution)
newLine
la $a0, boardThree
jal printSolution 
####################################################
#grid set
####################################################
label(testGridSet)			####test
newLine
la $a0, boardThree
li $a1, 0
li $a2, 0
jal gridSet

move $a0, $v0
li $v0, 1
syscall

newLine
li $t9, 9
la $t0, gSet
loopTest:
	lb $a0, 0($t0)
	beqz $t9, exitLoopTest
	beqz $a0, exitLoopTest
	li $v0, 1
	syscall
	space
	addi $t9, $t9, -1
	addi $t0, $t0, 1
	b loopTest
exitLoopTest:
newLine
####################################################
#row set
####################################################
label(testRowSet)
newLine

la $a0, boardThree
li $a1, 0
jal rowSet

move $a0, $v0
li $v0, 1
syscall

newLine
addi $t1, $zero, 0
la $t0, rSet
loop:
	beq $t1, 9, imout
	lb $a0, 0($t0)
	li $v0, 1
	syscall
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j loop
imout:
newLine
####################################################
#col set
####################################################
label(testColSet)
newLine
la $a0, boardThree
li $a1, 0
jal colSet

move $a0, $v0
li $v0, 1
syscall

newLine
addi $t1, $zero, 0
la $t0, cSet
loop1:
	beq $t1, 9, imout1
	lb $a0, 0($t0)
	li $v0, 1
	syscall
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j loop1
imout1:
newLine
####################################################
#constructCandidates
####################################################
label(testConstructCandidates)
newLine
la $a0, boardThree
li $a1, 6
li $a2, 6
la $a3, candidates

jal constructCandidates

move $t0, $v0	
move $a0, $v0
li $v0, 1
syscall

la $t0, candidates
newLine
addi $t1, $zero, 0

loop2:
	beq $t1, 9, imout2
	lb $a0, 0($t0)
	li $v0, 1
	syscall
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j loop2
imout2:
newLine
#######################################################

la $a0, boardThree 
li $a1, 0
li $a2, -1
jal sudoku

######################################################
done:
li $v0, 10
syscall

.data

board: 	.byte 9:81
boardTwo: .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80
boardThree: .byte 0,0,6,8,0,0,5,0,0,0,8,0,0,6,1,0,2,0,5,0,0,0,3,0,0,0,7,0,4,0,3,1,7,0,0,5,0,9,8,4,0,6,3,7,0,7,0,0,2,9,8,0,4,0,8,0,0,0,4,0,0,0,9,0,3,0,6,2,0,0,1,0,0,0,5,0,0,9,6,0,0 
boardFour:  .byte 9,0,6,0,7,0,4,0,3,0,0,0,4,0,0,2,0,0,0,7,0,0,2,3,0,1,0,5,0,0,0,0,0,1,0,0,0,4,0,2,0,8,0,6,0,0,0,3,0,0,0,0,0,5,0,3,0,7,0,0,0,5,0,0,0,7,0,0,5,0,0,0,4,0,5,0,1,0,7,0,8
testHof: .asciiz "########################Hof Part One########################"
testTak: .asciiz "########################Tak Part Two########################"
testIsSolution: .asciiz "########################isSolution P3########################"
testPrintSolution: .asciiz "########################printSolution P3########################"
testConstructCandidates: .asciiz "########################constructCandidates P3########################"
testRowSet: .asciiz "########################rowSet P3########################"
testColSet: .asciiz "########################colSet P3########################"
testGridSet: .asciiz "########################gridSet P3########################"
testSudoku: .asciiz "########################sudoku########################"
result: .asciiz "Result: "
candidates: .byte 0:9
.include "hw4.asm"
