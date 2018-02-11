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
# T0 - Count					- Require: Once
# T1 - Address Map - 0x1000			- Require: Once
# T2 - Adress Array of Snake - 0x1001		- Require: Once
# T3 - Size of Snake				- Require: Once
# T4 - Parts of Snake				- Require: Once
# T5 - Address to save part of snake		- Require: Once
# T6 - Quantity of Pixels to Moviment
# T7 - Previous Moviment
# S0 - Black
# S1 - White
# S2 -  Gray
# S3 - Dark Red
 
#------------------------------------------------------------------------------#
#			Call the Functions				       #
.data
	sizeSnake: .word 4
	partsOfSnake: .word 13060, 13572, 14084, 14596


								       
.text
	jal setColors
	nop
	jal defineSettings
	nop
	jal defineMap
	nop
	jal createSnake
	nop
	jal createItem1
	nop
	jal readKeyPress
	nop
	
	j exit
	nop
#-----------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#			Function to set the colors			      #	
setColors:
	addi $s0, $0, 0x696969 # Black
	addi $s1, $0, 0xFFFFFF # White
	addi $s2, $0, 0xbfbfbf # Gray
	addi $s3, $0, 0x8B0000 # Dark Red
	jr $31 
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#		Function to define the Settings of Backgrund and Snake	       #
defineSettings:
	move $t0, $0		# Set Count = 0
	lui $t1, 0x1000 	# Set Address Map
	lui $t2, 0x1001		# Set Address Snake
	lw $t3, 0($t2)
	li $t7, 13060		# Snake's Born

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#			Function to define de Background		       #	
defineMap:
	beq $t0, 32764, endDefineMap
	nop
		sw $s2, 0($t1)    # Print with Gray Color
		addi $t1, $t1, 4  # Address Map +=4;
		addi $t0, $t0, 4  # Count +=4;
		j defineMap
		nop
endDefineMap:
	lui $t1, 0x1000	# Reset Address Map
	move $t0, $0 	# Reset Count of defineMap
#------------------------------------------------------------------------------#
defineBorderTop:
	beq $t0, 1532, endDefineBorderTop
	nop
		sw $s3, 0($t1)	  # Print with Gray Color
		addi $t1, $t1, 4  # Address Map +=4;
		addi $t0, $t0, 4  # Count +=4;
		j defineBorderTop
		nop
endDefineBorderTop:
	lui $t1, 0x1000	# Reset Address Map
	move $t0, $0 	# Reset Count of defineMap	
#------------------------------------------------------------------------------#
defineBorderBottom:
	beq $t0, 1536, endDefineBorderBottom
	nop
		sw $s3, 31228($t1)# Print with Gray Color
		addi $t1, $t1, 4  # Address Map +=4;
		addi $t0, $t0, 4  # Count +=4;
		j defineBorderBottom
		nop
endDefineBorderBottom:
	lui $t1, 0x1000	# Reset Address Map
	move $t0, $0 	# Reset Count of defineMap	
#------------------------------------------------------------------------------#
defineBorderLeft:	# Não coloca 129 se não buga no array!
	beq $t0, 128, endDefineBorderLeft #(64 rows + 64 rows + 1)
	nop
		sw $s3, 0($t1)     # Print with Gray Color
		sw $s3, 4($t1)	   # Print with Gray Color
		addi $t1, $t1, 512 # Address Map +=512;
		addi $t0, $t0, 1
		j defineBorderLeft
		nop
endDefineBorderLeft:
	lui $t1, 0x1000	# Reset Address Map
	move $t0, $0 	# Reset Count of defineMap
#------------------------------------------------------------------------------#
defineBorderRight:
	beq $t0, 128, endDefineBorderRight #(64 rows + 64 rows + 1)
	nop
		sw $s3, 504($t1)   # Print with Gray Color
		sw $s3, 508($t1)   # Print with Gray Color
		addi $t1, $t1, 512 # Address Map +=512;
		addi $t0, $t0, 1
		j defineBorderRight
		nop
endDefineBorderRight:
	lui $t1, 0x1000	# Reset Address Map
	move $t0, $0 	# Reset Count of defineMap
#------------------------------------------------------------------------------#
jr $31
nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
createSnake:	
	addi $t2, $t2, 4 # Jump	Position: Size of Snakee

bCreate:beq $t0, $t3, endCreate
	nop
		lw $t4, 0($t2)	  # Load Pixel - one part of snake
		add $t5, $t4, $t1 # Add Pixel Snake to Address Map
		sw $s1, 0($t5)    # Print with White Color
		add $t2, $t2, 4	  # Adress Array ++;
		addi $t0, $t0, 1
		j bCreate
		nop
endCreate:
	lui $t2, 0x1001		# Reset Addres of Array
	move $t0, $0		# Reset Count
	jr $31
	nop
#------------------------------------------------------------------------------#
createItem1:
	addi $t1, $t1, 5144
	sw $s1, 0($t1)
	lui $t1, 0x1000
	jr $31
	nop
#------------------------------------------------------------------------------#
createItem2:		
	addi $t1, $t1, 39204
	sw $s1, 0($t1)
	lui $t1, 0x1000
	j bItem
	nop

#------------------------------------------------------------------------------#
createItem3:
	addi $t1, $t1, 3208
	sw $s1, 0($t1)
	lui $t1, 0x1000
	j bItem
	nop

#------------------------------------------------------------------------------#
createItem4:
	addi $t1, $t1, 18560
	sw $s1, 0($t1)
	lui $t1, 0x1000
	j bItem
	nop

#------------------------------------------------------------------------------#
createItem5:
	addi $t1, $t1, 29204
	sw $s1, 0($t1)
	lui $t1, 0x1000
	j bItem
	nop

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
	beq $v0, 100, pressKeyD	# D - LowerCase
	nop
	beq $v0, 68, pressKeyD		# D - UpperCase
	nop
	beq $v0, 48, exit		# 0 - Exit
	nop
	j readKeyPress
	nop	
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
pressKeyW:
	li $t6, -512
	addi $t7, $t7, -512

	j checkBorderCollision	
	nop

W1:	j checkSnakeCollision
	nop

W2:	j checkItemCollision
	nop

W3:	j inputNewPosition
	nop

W4:	j recreateSnake
	nop
	
W5:	j readKeyPress
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
pressKeyS:
	li $t6, 512
	addi $t7, $t7, 512

	j checkBorderCollision	
	nop

S1:	j checkSnakeCollision
	nop

S2:	j checkItemCollision
	nop

S3:	j inputNewPosition
	nop

S4:	j recreateSnake
	nop
	
S5:	j readKeyPress
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
pressKeyA:
	li $t6, -4
	addi $t7, $t7, -4

	j checkBorderCollision	
	nop

A1:	j checkSnakeCollision
	nop

A2:	j checkItemCollision
	nop

A3:	j inputNewPosition
	nop

A4:	j recreateSnake
	nop
	
A5:	j readKeyPress
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
pressKeyD:
	li $t6, 4
	addi $t7, $t7, 4

	j checkBorderCollision	
	nop

D1:	j checkSnakeCollision
	nop

D2:	j checkItemCollision
	nop

D3:	j inputNewPosition
	nop

D4:	j recreateSnake
	nop
	
D5:	j readKeyPress
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
checkItemCollision:
	beq $t7, 5144, collisionOn
	nop
	beq $t7, 5656, collisionOn
	nop
	beq $t7, 3208, collisionOn
	nop
	beq $t7, 18560, collisionOn
	nop
	beq $t7, 29204, collisionOn
	nop
	j endCollisionOn
	nop

collisionOn:
	move $s7, $0		# Zera S7
	sll $s7, $t3, 2		# Get the offset to last position of array
	add $s7, $s7, $t2	# Get the address of last position
	lw $t9, 0($s7)
	addi $s7, $s7, -4	# Get the offset to last position - 1
	lw $t8, 0($s7)

	checkDirection:
		move $s7, $0 	# Reset S7
		addi $s7, $t8, 	512
		beq $t9, $s7, createUp
		nop

		move $s7, $0 	# Reset S7
		addi $s7, $t8, 	-512
		beq $t9, $s7, createDown
		nop

		move $s7, $0 	# Reset S7
		addi $s7, $t8, 	4
		beq $t9, $s7, createLeft
		nop

		move $s7, $0 	# Reset S7
		addi $s7, $t8, 	-4
		beq $t9, $s7, createRight
		nop

		createUp:
			move $s7,$0		# Reset S7
			addi $s7, $t9, -512	# Get a new position and new value to savee
			addi $t3, $t3, 1	# Size of Snake +	+
			sw $t3, 0($t2)		# Update Size of Snake
			sll $s6, $t3, 2
			add $s6, $t2, $s6
			sw $s7,0($s6)
			j endCollisionOn
			nop
		createDown:
			move $s7,$0		# Reset S7
			addi $s7, $t9, 512	# Get a new position and new value to savee
			addi $t3, $t3, 1	# Size of Snake +	+
			sw $t3, 0($t2)		# Update Size of Snake
			sll $s6, $t3, 2
			add $s6, $t2, $s6
			sw $s7,0($s6)
			j endCollisionOn
			nop

		createLeft:
			move $s7,$0		# Reset S7
			addi $s7, $t9, -4	# Get a new position and new value to savee
			addi $t3, $t3, 1	# Size of Snake +	+
			sw $t3, 0($t2)		# Update Size of Snake
			sll $s6, $t3, 2
			add $s6, $t2, $s6
			sw $s7,0($s6)
			j endCollisionOn
			nop

		createRight:
			move $s7,$0		# Reset S7
			addi $s7, $t9, 4	# Get a new position and new value to savee
			addi $t3, $t3, 1	# Size of Snake +	+
			sw $t3, 0($t2)		# Update Size of Snake
			sll $s6, $t3, 2
			add $s6, $t2, $s6
			sw $s7,0($s6)
			j endCollisionOn
			nop
endCollisionOn:

	beq $t3, 5, createItem2
	nop
	beq $t3, 6, createItem3
	nop
	beq $t3, 7, createItem4
	nop	
	beq $t3, 8, createItem5
	nop

		
bItem:	beq $t6, -512, W3
	nop
	beq $t6, 512, S3
	nop
	beq $t6, 4, D3
	nop
	beq $t6, -4, A3
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
inputNewPosition:
	addi $s6, $t3, -2	# Size of Snake Flexible to make a loop
	sll $s4, $t3, 2		# x = Size * 4	= Last Position
	addi $s5, $s4, -4	# y = x - 4	= Last Position - 1
	add $t9, $t2, $s4	# Load address of last position
	add $t8, $t2, $s5	# Load address of last position - 1
	lw $s7, 0($t8)		# Save lastPosition-1 into lastPosition
	lw $t5, 0($t9)
	add $t5, $t1, $t5
	sw $s2, 0($t5)
	sw $s7, 0($t9)
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
	sw $t7, 0($t8)
	beq $t6, -512, W4
	nop
	beq $t6, 512, S4
	nop
	beq $t6, 4, D4
	nop
	beq $t6, -4, A4
	nop
#------------------------------------------------------------------------------#		
#------------------------------------------------------------------------------#		
	
recreateSnake:
	addi $t2, $t2, 4 # Jump	Position: Size of Snakee

bRecreate:beq $t0, $t3, endRecreate
	nop
		lw $t4, 0($t2)	  # Load Pixel - one part of snake
		add $t5, $t4, $t1 # Add Pixel Snake to Address Map
		sw $s1, 0($t5)    # Print with White Color
		add $t2, $t2, 4	  # Adress Array ++;
		addi $t0, $t0, 1
		j bRecreate
		nop
endRecreate:
	lui $t2, 0x1001		# Reset Addres of Array
	move $t0, $0		# Reset Count
	beq $t6, -512, W5
	nop
	beq $t6, 512, S5
	nop
	beq $t6, 4, D5
	nop
	beq $t6, -4, A5
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#





#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
checkBorderCollision:
	# Check Border Top
	slti $t9, $t7, 1541	# If previous position < 151 = Red Field, gameOver
	bne $t9, $0, gameOver
	nop
	
	# Check Border Bottom
	slti $t9, $t7, 31221	# If previous position < 31220 = Red Field, gamOver
	beq $t9, $0, gameOver
	nop
	
	# Check Border Left
	addi $t0, $0, 1540
	
BL:	beq $t0, 31236, checkRight
	nop
		beq $t7, $t0, gameOver	# If t3 is equal to a one value of borderLeft
		nop
		addi $t0, $t0, 512
		j BL
		nop

checkRight:
	move $t0, $0
	addi $t0, $0, 1528

BR:	beq $t0, 31736, continue
	nop
		beq $t7, $t0, gameOver
		nop
		addi $t0, $t0, 512
		j BR
		nop

continue:
	move $t0, $0

	beq $t6, -512, W2
	nop
	beq $t6, 512, S2
	nop
	beq $t6, 4, D2
	nop
	beq $t6, -4, A2
	nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#		Function to check if Snake Collision itself		       #
checkSnakeCollision:
	addi $t2, $t2, 4 # Jump	Position: Size of Snakee
	move $t0, $0
	
bPartOfSnake:beq $t0, $t3, endCheckSnake
	     nop
	     	lw $t4, 0($t2)	  	# Load Pixel - one part of snake
		beq $t4, $t7, gameOver  # If previous moviment is equal to a part of Snake game over
		nop	
		addi $t2, $t2, 4
		addi $t0, $t0, 1
		j bPartOfSnake
		nop
endCheckSnake:
	lui $t2, 0x1001
	move $t0, $0
	
	beq $t6, -512, W3
	nop
	beq $t6, 512, S3
	nop
	beq $t6, 4, D3
	nop
	beq $t6, -4, A3
	nop

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#			Game Over Screen				       #
gameOver:
	beq $t0, 32764, endgameOver
	nop
		sw $s0, 0($t1)
		addi $t1, $t1, 4  # Address +=4;
		addi $t0, $t0, 4  # Count +=4;
		j gameOver
		nop
endgameOver:
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#		 Exit Function						       #
exit:
	li $v0, 10
	syscall
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
