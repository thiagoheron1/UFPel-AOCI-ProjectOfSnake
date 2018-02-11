################################################################################
#			SNAKE`S GAME					       #
#	Names: Gregory Sedrez, Thiago Heron Avila                              # 
#------------------------------------------------------------------------------#
#			Settings of Bitmap Display:                            #
#		  Unit Width: 4       Display Width: 512                       #
#		  Unit Height: 4      Display Height: 256		       #
#------------------------------------------------------------------------------#		  	
#			 Others informations:				       #						  	
# (+4)BorderTop Pixels:     0 - 508 / 512 - 1020 / 1024 - 1532                 #
# (+4)BorderBottom Pixels:  31232 - 31740 /  31744 - 32252 / 32256 - 32764     #	
# (+512)BorderLeft Pixels:  0- 32256 / 4 - 32260			       #	
# (+512)BorderRight Pixels: 504- 32760 / 508 - 32764	                       #
#									       #
#------------------------------------------------------------------------------#
#			 Registers:					      	
# T0 - Count					

# T9 - Border Collision - the values of column(left or right)
# S0 - Black
# S1 - White
# S2 - Gray
# S3 - Dark Red

# sizeSnake = +0
# offsetSnake +4...
# currentItem = +124
# offsetItem = +128...
#------------------------------------------------------------------------------#
#			Call the Functions				       #
.data
	sizeSnake:     .word 4
	partsofSnake:  .word 13060, 13572, 14084, 14596
	offsetSnake:   .space 104
	currentItem:   .word 1
	offsetItens:   .word 5144, 24600, 29748, 15460, 6240,, 8832, 27272,  27800, 8348, 10824, 23104, 20572, 3544, 8996, 2792, 30444, 29004, 7068, 18888, 16852, 11740, 26076, 26012, 6620, 14252, 18932, 24544, 25052, 11716, 10208, 9700
		
								       
.text
	jal setColors
	nop
	jal defineSettings
	nop
	jal defineMap
	nop
	jal createSnake
	nop
	jal createFirstItem
	nop
	jal readKeyPress
	nop
	j exit
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#			Function to set the colors			       #	
setColors:
	addi $s0, $0, 0x696969 # Black
	addi $s1, $0, 0xFFFFFF # White
	addi $s2, $0, 0xbfbfbf # Gray
	addi $s3, $0, 0x8B0000 # Dark Red
	jr $31 
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#		Function to define the Settings of Backgrund and Snake	       #
defineSettings:
	move $t0, $0		# Set Count = 0
	lui $t1, 0x1000 	# Set Address Map
	lui $t2, 0x1001		# Set Address Snake
	lw $t3, 0($t2)		# Size of Snake
	lw $t4, 124($t2)	# CurrentItem
	li $t7, 13060		# Snake's Born
	
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#			Function to define de Background		       #	
defineMap:
	beq $t0, 32764, endDefineMap	# Count ? 32764; 
	nop
		sw $s2, 0($t1)    	# Print with Gray Color
		addi $t1, $t1, 4  	# Address Map +=4;
		addi $t0, $t0, 4  	# Count +=4;
		j defineMap
		nop
endDefineMap:
	lui $t1, 0x1000			# Reset Address Map
	move $t0, $0 			# Reset Count of defineMap
#------------------------------------------------------------------------------#
defineBorderTop:
	beq $t0, 1532, endDefineBorderTop# Count ? 1532;
	nop
		sw $s3, 0($t1)	 	 # Print with dark red color
		addi $t1, $t1, 4  	 # Address Map +=4;
		addi $t0, $t0, 4  	 # Count +=4;
		j defineBorderTop
		nop
endDefineBorderTop:
	lui $t1, 0x1000			 # Reset Address Map
	move $t0, $0 			 # Reset Count of defineMap	
#------------------------------------------------------------------------------#
defineBorderBottom:
	beq $t0, 1536, endDefineBorderBottom	# Count ? 1536;
	nop
		sw $s3, 31228($t1)		# Print with dark red color
		addi $t1, $t1, 4 		# Address Map +=4;
		addi $t0, $t0, 4   		# Count +=4;
		j defineBorderBottom
		nop
endDefineBorderBottom:
	lui $t1, 0x1000				# Reset Address Map
	move $t0, $0 				# Reset Count of defineMap	
#------------------------------------------------------------------------------#
defineBorderLeft:			  # Don't put the value 129!
	beq $t0, 128, endDefineBorderLeft #(64 rows + 64 rows + 1)
	nop
		sw $s3, 0($t1)    	   # Print with dark red color the first column
		sw $s3, 4($t1)	   	   # Print with dark red color the second column
		addi $t1, $t1, 512 	   # Address Map +=512;
		addi $t0, $t0, 1	   # Count +=1;
		j defineBorderLeft	
		nop
endDefineBorderLeft:
	lui $t1, 0x1000			   # Reset Address Map
	move $t0, $0 			   # Reset Count of defineMap
#------------------------------------------------------------------------------#
defineBorderRight:		           # Don't put the value 129!
	beq $t0, 128, endDefineBorderRight #(64 rows + 64 rows + 1)
	nop
		sw $s3, 504($t1)   	   # Print with dark red color the first column
		sw $s3, 508($t1)           # Print with dark red color the second column
		addi $t1, $t1, 512         # Address Map +=512;
		addi $t0, $t0, 1	   # Count +=1;
		j defineBorderRight
		nop
endDefineBorderRight:
	lui $t1, 0x1000			   # Reset Address Map
	move $t0, $0 			   # Reset Count of defineMap
#------------------------------------------------------------------------------#
jr $31					  # Return
nop	
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
createSnake:	
	addi $t2, $t2, 4 	  # Jump to the second position of address array

bCreate:beq $t0, $t3, endCreate	  # Count ? Parts of Snake
	nop
		lw $t5, 0($t2)	  # Load Pixel - one part of snake
		add $t1, $t1, $t5 # Add Pixel Snake to Address Map
		sw $s1, 0($t1)    # Print with White Color
		add $t2, $t2, 4	  # Adress Array += 4;
		addi $t0, $t0, 1  # Count += 1;
		lui $t1, 0x1000   # Reset Addres of Map
		j bCreate
		nop
endCreate:
	lui $t1, 0x1000		  # Reset Addres of Map
	lui $t2, 0x1001		  # Reset Address of Array
	move $t0, $0		  # Reset Count
	jr $31			  # Return
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#	 Function to Control the Snake: W,A,S,D or 0 to Exit		       #		  		
readKeyPress:	
	li $v0, 12			# Read a Caracter: W,A,S,D or 0  to Exit
	syscall	

	beq $v0, 119, pressKeyW 	# W - LowerCase
	nop		
	beq $v0, 82, pressKeyW		# W - UpperCase
	nop
	beq $v0, 115, pressKeyS		# S - LowerCase
	nop
	beq $v0, 83, pressKeyS		# S - UpperCase
	nop
	beq $v0, 97, pressKeyA		# A - LowerCase
	nop
	beq $v0, 65, pressKeyA		# A - UpperCase
	nop,
	beq $v0, 100, pressKeyD		# D - LowerCase
	nop
	beq $v0, 68, pressKeyD		# D - UpperCase
	nop
	beq $v0, 48, exit		# 0 - Exit
	nop
	j readKeyPress
	nop	
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
pressKeyW:
	li $t6, -512
	addi $t7, $t7, -512
	j goCheck
	nop

pressKeyD:
	li $t6, 4
	addi $t7, $t7, 4
	j goCheck
	nop

pressKeyS:
	li $t6, 512
	addi $t7, $t7, 512
	j goCheck
	nop	

pressKeyA:
	li $t6, -4
	addi $t7, $t7, -4
	j goCheck
	nop

goCheck:j checkBorderCollision	
	nop

gC1:	j checkSnakeCollision
	nop

gC2:	j checkItemCollision
	nop

gC3:	j inputNewPosition
	nop

gC4:	j recreateSnake
	nop
	
gC5:	j readKeyPress
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#		Function to check if have Border Collision			#
checkBorderCollision:			#
	# Check Border Top
	slti $t9, $t7, 1541	# T9(Flag) - If possible position(T7) < 1541 = Border Top, gameOver
	bne $t9, $0, gameOver
	nop
	
	# Check Border Bottom
	slti $t9, $t7, 31221	# T9(Flag) - If possible position(T7) >(bne) 31221 = Border Bottom, gameOver
	beq $t9, $0, gameOver
	nop
	
	# Check Border Left
	addi $t9, $0, 1540		# T9 the values of Left Column
cBorderL:	beq $t9, 31236, checkRight	# If T9 is equal a last value of left column, go checkRight
	nop
		beq $t7, $t9, gameOver	# If the Previous Moviment is equal a one value of Left Column, gameOver
		nop
		addi $t9, $t9, 512	# T9 - Go to the next value of column
		j cBorderL	        # Return loop
		nop

	# Check Border Right
checkRight:
	move $t9, $0			# Reset T9

	addi $t9, $0, 1528		# T9 the values of Right Column
cBorderR:beq $t9, 31736, continue	# If T9 is equal a last value of right column, go tag continue
	nop
		beq $t7, $t9, gameOver	# If Previous moviment is equal a one value of Right Column, gameOver
		nop
		addi $t9, $t9, 512	# T9 - Go to the next value of column	
		j cBorderR	        # Return loop
		nop


	# No collision, so continue
continue:
	lui $t1, 0x1000
	lui $t2, 0x1001
	move $t9, $0			# Reset T9
	j gC1				# Return
	nop

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#		Function to check if Snake Collision itself		       #
checkSnakeCollision:
	addi $t2, $t2, 4 		# Jump to the second position of array
	move $t0, $0			# Reset the Count
	
bPartOfSnake:
	beq $t0, $t3, endCheckSnake	# If Size of Snake is qual Count, go endCheckSnake	
	nop
	     	lw $t5, 0($t2)	  	# Load offset of one part of snake
		beq $t5, $t7, gameOver  # If possible moviment is equal to a part of Snake gam
		nop	
		addi $t2, $t2, 4	# Array++;
		addi $t0, $t0, 1	# Count++;
		j bPartOfSnake
		nop
endCheckSnake:
	lui $t1, 0x1000
	lui $t2, 0x1001			# Reset address array
	move $t0, $0			# Reset Count
	j gC2  				# Return 
	nop


#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
# 			Check Item Collision				       #
checkItemCollision:			# Check if the next moviment of snake gonna collision with item
	beq $t7, $k1, collisionOn	# If collision, go collisionOn to check where gonna create a new part of snake: up, down, left, right
	nop
	j bItem
	nop

collisionOn:
	li $k0, 999
	move $s7, $0		# Zera S7
	sll $s7, $t3, 2		# S7 - Get the offset to last position of array
	add $s7, $s7, $t2	# S7 - Get the address of last position (Address Array + Offset)
	lw $t9, 0($s7)	 	# T9 - Load de last value of array
	addi $s7, $s7, -4	# S7 - Get the offset to last position - 1 of array
	lw $t8, 0($s7)		# T8 - Load the last value -1 of array

	checkDirection: 
		move $s7, $0 		  # Reset S7
		addi $s7, $t8, 	512	  # (LastPostion-1) + 512 = Check if create a tail on Up
		li $s4, 512		  # Load the S4 the pixels
		beq $t9, $s7, createTail  # Check if (LastPosition-1)+512 is equal to Last Position, so create a tail on Up
		nop	

		move $s7, $0 		  # Reset S7
		addi $s7, $t8, 	-512	  # (LastPostion-1) - 512 = Check if create a tail on Down
		li $s4, -512		  # Load the S4 the pixels
		beq $t9, $s7, createTail  # Check if (LastPosition-1)-512 is equal to Last Position, so create a tail on Down
		nop

		move $s7, $0 		  # Reset S7
		addi $s7, $t8, 	4	  # (LastPostion-1) + 4 = Check if create a tail on Left
		li $s4, 4		  # Load the S4 the pixels
		beq $t9, $s7, createTail  # Check if (LastPosition-1)+4 is equal to Last Position, so create a tail on Left
		nop

		move $s7, $0 		  # Reset S7
		addi $s7, $t8, 	-4	  # (LastPostion-1) - 4 = Check if create a tail on Right
		li $s4, -4		  # Load the S4 the pixels
		beq $t9, $s7, createTail  # Check if (LastPosition-1)-4 is equal to Last Position, so create a tail on Right
		nop
		
		j endCollisionOn	# It's not necessary, but its more secure haha
		nop
	
		createTail:			# We already have de position, need calculate a value of a new tail
			move $s7,$0		# Reset S7	
			add $s7, $t9, $s4	# S7 - Value o new part
			addi $t3, $t3, 1	# Size Snake ++;
			sw $t3, 0($t2)		# Update Size of Snake
			addi $t4, $t4, 1	# currentItem ++;
			beq $t4, 25, Vitoria
			nop
			sw $t4, 124($t2)	# Update currentItem;
			sll $s6, $t3, 2	 	# S6 - New offset of new tail
			add $s6, $t2, $s6	# S6 - Calculate a last postion of address array(Adress array + offset)
			sw $s7,0($s6)		# S7 - Save a part of snae(s7) into last position of array
			j endCollisionOn	
			nop
endCollisionOn:
	j createItens
	nop
	

	
bItem:	
	lui $t1, 0x1000			# Reset address map
	lui $t2, 0x1001			# Reset address array
	move $t0, $0			# Reset Count
	j gC3				# Return 
	nop



#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
inputNewPosition:
	sll $s4, $t3, 2		# x = Size * 4	= Last Position
	add $t9, $t2, $s4	# Load address of last position

	addi $s5, $s4, -4	# y = x - 4	= Last Position - 1
	add $t8, $t2, $s5	# Load address of last position - 1
	
	lw $s7, 0($t8)		# Load offset of last position -1
	lw $t5, 0($t9)		# Load offset of last position
	add $t5, $t1, $t5	# Add offset of last position to address map to transform to gray color
	sw $s2, 0($t5)		# Gray color
	sw $s7, 0($t9)		# Change the offset the lastpostion-1 into lastposition to make a illusion to snake walk

	addi $s6, $t3, -2	# Size of Snake Flexible to make a loop
	bInput:	beq $t0, $s6, endInput	
		nop	
			addi $t8, $t8, -4
				addi $t9, $t9, -4
			lw $s7, 0($t8)
			sw $s7, 0($t9)
			addi $t0, $t0, 1
			j bInput
			nop
	endInput: 
	move $t0, $0
	move $t5, $0

	sw $t7, 0($t8)			# Save new moviment in last
	lui $t2, 0x1001			# Reset address array
	move $t0, $0			# Reset Count
	j gC4				# Return 
	nop

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#		
#------------------------------------------------------------------------------#		
#			reCreate Snake					       #
recreateSnake:
	lui $t2, 0x1001
	addi $t2, $t2, 4 # Jump	Position: Size of Snakee

bRecreate:beq $t0, $t3, endRecreate
	  nop
		lw $t5, 0($t2)	  # Load offset - one part of snake
		add $t5, $t5, $t1 # Add ofsset to Address Map
		sw $s1, 0($t5)    # Print with White Color
		add $t2, $t2, 4	  # Adress Array ++;
		addi $t0, $t0, 1  # Count++;
		j bRecreate
		nop
endRecreate:
	lui $t2, 0x1001		# Reset Addres of Array
	move $t0, $0		# Reset Count
	lui $t2, 0x1001			# Reset address array
	move $t0, $0			# Reset Count
	j gC5				# Return 
	nop

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#				Create Itens				       #
createFirstItem:
	addi $t2, $t2, 124	# Addres to Current item
	lw $t4, 0($t2)		# Load CurrentItem
	sll $s7, $t4, 2		# Multiply number of current item * 4 to get the offset
	add $t2, $t2, $s7
	lw $t9, 0($t2)		# Load the offset item
	add $t1, $t1, $t9	# Get address map + offset
	move $k1, $t9		# Pass to $k1 to check if can collision
	sw $s1, 0($t1)		# Color the map
	lui $t1, 0x1000		# Reset Map Adress
	lui $t2, 0x1001
	jr $31		       	# Return
	nop


createItens:
	addi $t2, $t2, 124	# Addres to Current item
	lw $t4, 0($t2)		# Load CurrentItem
	sll $s7, $t4, 2		# Multiply number of current item * 4 to get the offset
	add $t2, $t2, $s7
	lw $t9, 0($t2)		# Load the offset item
	add $t1, $t1, $t9	# Get address map + offset
	move $k1, $t9		# Pass to $k1 to check if can collision
	sw $s1, 0($t1)		# Color the map
	lui $t1, 0x1000		# Reset Map Adress
	lui $t2, 0x1001
	j bItem		       	# Return
	nop





	
Vitoria:
	beq $t0, 32764, exit
	nop
		sw $s1, 0($t1)
		addi $t1, $t1, 4  # Address +=4;
		addi $t0, $t0, 4  # Count +=4;
		j Vitoria
		nop

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#			Game Over Screen				       #
	move $t0, $0
gameOver:
	beq $t0, 32764, exit
	nop
		sw $s0, 0($t1)
		addi $t1, $t1, 4  # Address +=4;
		addi $t0, $t0, 4  # Count +=4;
		j gameOver
		nop



#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#		 Exit Game						       #
exit:
	li $v0, 10
	syscall
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#: