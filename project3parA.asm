#Project 3 Part A
#Linear Co-factor convolution 

######## Register Table ########

# t0 - is for loop counter "i"
# a1 - Vector index variable "j"
# a2 - Vector index variable "k"
# a3 - difference between k and j for proper indexing of k
# s0 - Contains the base memory address of vector_A 
# s1 - Contains the base memory address of vector_B
# s2 - Contains the base memory address of the resultant vector
# ...

######## Coprocessors ########

# f0 = vector_1[j]
# f1 = vector_1[k]
# f2 = vector_2[j]
# f3 = vector_2[k]
#...

.data
#Vectors A and B with xyz components on the 3D plane
vector_A: .float 5.2, 7.1, 2.0		
vector_B: .float 15.4, 3.5, 11.5	
eight: .float .8
	
#Result vector containing the product between A x B
result: .float 0.0, 0.0, 0.0

.text
li $t0, 0	#initialize i
la $s2, result	#equivalent to *s0=&result[0]; in C


######################## your code begins here ##########################################
#GENERAL TIP: s0, s1, and s2 initially store the address of the first float in the array.
#A float is 4 Bytes so to iterate to the next number in the array, increment the address stored in s_ accordingly.
##################################################################################
#write code to load each element from array vector_B, scale by Co-factor= 0.8,   #
# and then store back at the corresponding original memory adresses of vector_B  #
##################################################################################

# has the address of vector B 
la $s6, vector_B
la $s5, eight
li $t1, 1

l.s $f8, 0($s5) # loading .8

looop:
bge $t3, 3, done
# reaching what is in vector_B

l.s $f9, 0($s6)	# loading the B[] into $f0

# multiply whats in there by .8
mul.s $f9, $f9, $f8
s.s $f9, 0($s6) 


# moving over 4 
# sll $t1, $t1, 2
addi $s6, $s6, 4 # mult 4 to vector_ B adddress

addi $t3, $t3, 1 # incrementing counter by 1 


j looop
done: 
sub $t3, $t3, $t3
sub $t1, $t1, $t1



##########################################################################
loop:
		###################################################
la $s0, vector_A	#load starting address of array vector_A into s0 #
la $s1, vector_B	#load starting address of array vector_B into s1 #
		###################################################  

bge $t0, 3, print # end case for the loop 

#STEP 1:
#implement if statements


# set new registers to 1 if the i == the right value 
seq $t1, $t0, 0		# $t1 == 1 if i == 0 
seq $t2, $t0, 1		# $t2 == 1 if i == 1 
seq $t3, $t0, 2		# $t3 == 1 if i == 2


# set j and k to their right values if the new registers equal 1

bne $t1, 1, next1  # branch if i != 0 
li $a1, 1    # set j = 1
li $a2, 2	   # set k = 2
j next3

next1: 
bne $t2, 1, next2  # branch if i != 1
li $a1,  0   # set j = 0
li $a2, 2	   # set k = 2
j next3

next2: 
bne $t3, 1, next3  # branch if i ! = 2 
li $a1, 0	   # set j = 0
li $a2, 1	   # set k=1

next3: 
# all js and ks have been set 

#STEP 2:
#load the two numbers from arrays vector_A and vector_B into coprocessors (i.e. floating point registers)


#first subtract k from j for proper indexing of arrays
sub $a3, $a2, $a1 #use this as k index says k - j 
sll $a3, $a3, 2
sll $a1, $a1, 2

add $s0, $s0, $a1 # adding j to vector_ A
l.s $f0, 0($s0)		# loading the A[j] into $f0

add $s0, $s0, $a3 # adding k to vector_A
l.s $f1, 0($s0)		# laoding A[k] into $f1

#do previous 4 instructions again but for $s1 (array_B)

add $s1, $s1, $a1 # adding j to vector_ B
l.s $f2, 0($s1)		# loading the B[j] into $f2

add $s1, $s1, $a3 # adding k to vector_B
l.s $f3, 0($s1)		# laoding B[k] into $f3


#STEP 3:
#perform the math
mul.s $f5, $f0, $f3
mul.s $f6, $f2, $f1
sub.s $f7, $f5, $f6

#FINAL STEP:
#store the results into the results array
s.s $f7, 0($s2)
addi $s2, $s2, 4 #increment results register to the next index

########################## end of your code #####################################

addi, $t0, $t0, 1
# reset js and ks 

j loop

#Print Values in Result Array (you can COPY/PASTE this part onward for use in part B)
print:
li $t8, 0
mtc1 $t8, $f14		#move 0 into f14

#invert y component and store back into vector array
la $s2, result		#s2 = & result[0]
addi $s2, $s2, 4	#index s2 by 4 so it is pointing to 2nd element in array
l.s $f6, 0($s2)		#load 2nd element into f6
sub.s $f6, $f14, $f6	#f6 = 0.0 - f6
s.s $f6, 0($s2)		#store inverted y into array
subi $s2, $s2, 4	#set pointer back to base address of vector

########### print x component ##########
l.s $f6, 0($s2) 	#f6 = result[0];

li $v0, 2		#Print x
add.s $f12, $f6, $f14	
syscall
li $v0, 11		#Print New Line
li $a0, 10
syscall	

########### print y component ##########
addi $s2, $s2, 4	#increment address to next element
l.s $f6, 0($s2)		#load 2nd element into f6

li $v0, 2		#Print y
add.s $f12, $f6, $f14
syscall
li $v0, 11		#Prints New Line
li $a0, 10
syscall	

########### print z component ##########
addi $s2, $s2, 4	#increment address to next element
l.s $f6, 0($s2)		#load 3rd element into f6

li $v0, 2		#Print z
add.s $f12, $f6, $f14
syscall
li $v0, 11		#Prints New Line
li $a0, 10
syscall	

li $v0, 10	#end
syscall
