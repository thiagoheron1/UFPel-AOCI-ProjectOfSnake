#			 Registers:					      	
# T0 - Count					
# T0(Border Collision)	- the values of column(left or right)
# T1 - Address Map - 0x1000			
# T2 - Adress Array of Snake - 0x1001		
# T3 - Size of Snake				
# T4 - Parts of Snake				
# T5 - Address to save part of snake		
# T6 - Quantity of Pixels to Moviment
# T7 - Snake's Born /  Possible Moviment

# T8 - Item Collision - The valeu of last position-1 of array
# T9 - Border Collision - Flag to Slti
# T9 - Border Collision - The values of column(left or right)
# T9 - Item Collision   - The value of last position of array




# S0 - Black
# S1 - White
# S2 - Gray
# S3 - Dark Red
# S3 - Dark Red

# Item Collision

# S4 - 
# S6 - New offset with a new tail
# S6 - Calculate a last postion of address array(Adress array + offset)
# S7 - Offset of last position array 
# S7 - Adress of last position (offset + address array(t2))
# S7 - Offset of last position - 1 array
# S7 - Reset S7 and Load the next moviment(T8 + (512,-512,4,-)
# S7 - Value of new part of snake

# T8 - Item Collision - The valeu of last position-1 of array
# T9 - Item Collision   - The value of last position of array

