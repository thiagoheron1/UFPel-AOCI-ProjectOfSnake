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
#  T0 - Count								       
#  20 - Black				       	
#  21 - White				       				
#  22 - Gray							       	
#  23 - D. Red 								       
.text
	jal setColors
	nop
	jal defineSettings
	nop
	jal defineMap
	nop



#-----------------------------------------------------------------------------#
#			Function to set the colors			      #	
setColors:
	addi $20, $0, 0x696969 # Black
	addi $21, $0, 0xFFFFFF # White
	addi $22, $0, 0xbfbfbf # Gray
	addi $23, $0, 0x8B0000 # Dark Red
	jr $31 
	nop
#------------------------------------------------------------------------------#
#		Function to define the Settings of Backgrund		       #
defineSettings:
	addi $9, $0, 8122  # (512x256) / (4x4)
	add $10, $0, $9    # Pixels to map
	lui $10, 0x1001
	jr $31
	nop	

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
#			Function to define de Background		       #	
defineMap:
	beq $t0, 31224, endDefineMap
	nop
		sw $22, 0($10)
		addi $10, $10, 4  # Address +=4;
		addi $t0, $t0, 4  # Count +=4;
		j defineMap
		nop
endDefineMap:
	lui $10, 0x1001	# Reset Address
	move $t0, $0 	# Reset Count of defineMap	

#------------------------------------------------------------------------------#
defineBorderTop:
	beq $t0, 1536, endDefineBorderTop
	nop
		sw $23, 0($10)
		addi $10, $10, 4  # Address +=4;
		addi $t0, $t0, 4  # Count +=4;
		j defineBorderTop
		nop
endDefineBorderTop:
	lui $10, 0x1001	# Reset Address
	move $t0, $0 	# Reset Count of defineMap	
#------------------------------------------------------------------------------#
defineBorderBottom:
	beq $t0, 1536, endDefineBorderBottom
	nop
		sw $23, 31232($10)
		addi $10, $10, 4  # Address +=4;
		addi $t0, $t0, 4  # Count +=4;
		j defineBorderBottom
		nop
endDefineBorderBottom:
	lui $10, 0x1001	# Reset Address
	move $t0, $0 	# Reset Count of defineMap	
#------------------------------------------------------------------------------#
defineBorderLeft:
	beq $t0, 129, endDefineBorderLeft #(64 rows + 64 rows + 1)
	nop
		sw $23, 0($10)
		sw $23, 4($10)
		addi $10, $10, 512 # Address +512;
		addi $t0, $t0, 1
		j defineBorderLeft
		nop
endDefineBorderLeft:
	lui $10, 0x1001	# Reset Address
	move $t0, $0 	# Reset Count of defineMap
#------------------------------------------------------------------------------#
defineBorderRight:
	beq $t0, 129, endDefineBorderRight #(64 rows + 64 rows + 1)
	nop
		sw $23, 504($10)
		sw $23, 508($10)
		addi $10, $10, 512 # Address +512;
		addi $t0, $t0, 1
		j defineBorderRight
		nop
endDefineBorderRight:
	lui $10, 0x1001	# Reset Address
	move $t0, $0 	# Reset Count of defineMap
#------------------------------------------------------------------------------#
jr $31 	# End defineMap
nop
#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
	

	