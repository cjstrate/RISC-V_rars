.macro read_int(%reg) # get an integer from user
	addi a7, zero, 5
	ecall # get the number
	add %reg, zero, a0 # store value in given register
.end_macro

.macro print_int(%reg) # print int register
	addi a7, zero, 1
	add a0, zero, %reg
	ecall
.end_macro

.macro print_string(%reg) # print string register
	addi a7, zero, 4
	add a0, zero, %reg
	ecall
.end_macro

.data
	num_prompt: .asciz "Please enter a number as input: "
	index1_prompt: .asciz "Please enter the index of first bit to be swapped: "
	index2_prompt: .asciz "Please enter the index of second bit to be swapped: "
	output_diff: .asciz "The two numbers produced are: "
	output_same: .asciz "The two numbers are identical."
	newline: .asciz "\n"
	comma: .asciz ", "
.text
	la a1, newline # load all needed strings for I/O formatting
	la a2, num_prompt
	la a3, index1_prompt
	la a4, index2_prompt
	la a5, output_diff
	la a6, output_same
	la s6, comma # for some reason using a7 did not work so s6 will have to do
	
	print_string(a2) # get number (s0)
	read_int(s0)
	
	print_string(a3) # get first index (s1)
	read_int(s1)
	
	print_string(a4) # get second index (s2)
	read_int(s2)
	
	srl t1, s0, s1 # shift index 1 to the far right
	srl t2, s0, s2 # shift index 2 to the far right
	
	andi t1, t1, 1 # mask all other values except the value of index 1
	andi t2, t2, 1 # mask all values other than the value of index 2
	
	xor t0, t1, t2 # XOR the value retrieved
	
	sll t3, t0, s1 # shift the xor back to its correct places
	sll t4, t0, s2
	or t0, t3, t4
	
	xor s3, t0, s0 # swap number (s3)
	
	beq s3, s0, Same # check if the values are the same
	bne s3, s0, Diff # check if the values are different
	
	Diff:   sub t0, s3, s0 # subtract New - Old
		srli t1, t0, 31 # shift the most significant value all the way to the right
		beq t1, zero, OlessN # if it is 0 then New - Old is positive thus New > Old
		bne t1, zero, NlessO # if it is 1 then New - Old is negative thus New < Old
	
	Same:   print_string(a6) # if the values are the same say so
		beq s3, s0, Finish
	
	OlessN: print_string(a5) # if the orignal is less than the new then output in that order
		print_int(s0)
		print_string(s6)
		print_int(s3)
		beq t1, zero, Finish
	
	NlessO: print_string(a5) # if the new is less than the original then output in that order 
		print_int(s3)
		print_string(s6)
		print_int(s0)
		bne t1, zero, Finish
		
	Finish: addi a7, zero, 10 # exit
		ecall