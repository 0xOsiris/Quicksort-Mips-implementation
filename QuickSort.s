#Quick Sort Algorithm
#Author: 0xOsiris
.data 
array: .word 8 2 7 10 5 6 3 4 9 3 1
		

.text
.globl main

main:
	la $a0, array			#load the address of array into $a0
	addi $a1, $zero, 0		#set $a1 to low
	li $a2, 10			#set $a2 to high
	jal quicksort			#jump and link quicksort
	
	li $v0, 10
	syscall

swap:
	addi $sp, $sp, -12		#Make stack of 3 bytes
	sw $a0, 0($sp)			#Store $a0
	sw $a1, 4($sp)			#Store $a1
	sw $a2, 8($sp)			#Store $a2
	
	lw $t6, 0($a1)			#$t6=array[left]
	lw $t7, 0($a2)			#$t7=array[right]
	sw $t6, 0($a2)			#array[right]=$t6
	sw $t7, 0($a1)			#array[left]=$t7
	
	
	
	addi $sp,$sp,12			#restore stack
	jr $ra				#return to $ra
	

partition:
	addi $sp, $sp, -16
	sw $a0, 0($sp)			#address of array
	sw $a1, 4($sp)			#low
	sw $a2, 8($sp)			#high
	sw $ra, 12($sp)			#Return address
	mul $t0, $a1, 4			#$t0 = 4*low
	add $t1, $t0, $a0		#$t1 = address of array plus $t0
	move $s0, $a1			#left = low
	move $s1, $a2			#right = high
	lw $s3, 0($t1)			#pivot =array[low]
	lw $t3, 0($sp)			#$t3 = address of array
	
	while:
		bge $s0, $s1, endwhile
		while1:
			mul $t2, $s1, 4			#$t2= right *4
			add $s6, $t2, $t3		#$t3= $t2+array address
			lw $s4, 0($s6)			#$s4 = array[right]
			ble $s4,$s3, endwhile1		#end while1 if array[right]<= pivot
			subi $s1,$s1,1			#right = right -1
			j while1
		endwhile1:
		
		while2:
			mul $t4, $s0, 4			#$t4 = left*4
			add $s7, $t4, $t3		#$t5= $t4+array address
			lw $s5, 0($s7)			#$s5=array[left]
			bge $s0, $s1, endwhile2		#branch if left>=right to endwhile2
			bgt $s5, $s3, endwhile2		#branch if aray[left]>pivot to endwhile2
			addi $s0,$s0,1			#left = left+1
			j while2
		endwhile2:
		
		if:
			bge $s0, $s1, end_if		#if left>=right branch to end_if
			move $a0, $t3			#move $t3 to $a0
			move $a1, $s7			#move array[left] into $a1
			move $a2, $s6			#move array[right] into $a2
			jal swap			#jump and link swap
			
			
		end_if:
		
		j while
		
	endwhile:	
	
		lw $s5, 0($s7)				#set $s5 to array[left]
		lw $s4, 0($s6)				#set $s4 to array[right]
		sw $s4 0($t1)				#array[low]=array[right]
		sw $s3, 0($s6)				#array[right]=pivot
		
		
		move $v0, $s1				#set $v0 to right
		
	lw $ra 12($sp)					#restore $ra
	addi $sp, $sp,16				#restore stack
	jr $ra						#return to $ra
	
quicksort:				

	addi $sp, $sp, -16		# Create stack for 4 bytes

	sw $a0, 0($sp)			#store address in stack
	sw $a1, 4($sp)			#store low in stack	
	sw $a2, 8($sp)			#store high in stack
	sw $ra, 12($sp)			#store return address in stack

	move $t0, $a2			#saving high in t0
	
	checkCond:
		slt $t1, $a1, $t0		# t1=1 if low < high, else 0
		beq $t1, $zero, end_check		# if low >= high, endcheck

		jal partition			# call partition 
		move $s0, $v0			# pivot, s0= v0

		lw $a1, 4($sp)			#a1 = low
		addi $a2, $s0, -1		#a2 = pi -1
		jal quicksort			#call quicksort

		addi $a1, $s0, 1		#a1 = pi + 1
		lw $a2, 8($sp)			#a2 = high
		jal quicksort			#call quicksort
		
	end_check:
	lw $a0, 0($sp)			#restore a0
 	lw $a1, 4($sp)			#restore a1
 	lw $a2, 8($sp)			#restore $a2
	lw $ra 12($sp)			#load return adress into ra
	addi $sp, $sp, 16		#restore stack
	jr $ra				#return to $ra
