.macro print_stringl(%label) # print string from label
	addi a7, zero, 4
	la a0, %label
	ecall
.end_macro

.data
	prompt: .asciz "Enter the TFN to check: "
	valid: .asciz "\nHooray! The TFN is valid!"
	invalid: .asciz "\nInvalid TFN: Checksum Failed"
	format: .asciz "Invalid TFN: Format Incorrect"
	array: .space 9

.text
	addi s2, zero, 0 # set product = 0
	addi s5, zero, 9
	print_stringl(prompt) # prompt user
	
	addi a1, zero, 10 # set maximum chars to add including null character
	addi a7, zero, 8
	ecall
	
	lb s1, 0(a0) # load the first digit
	addi t6, s1, -58
	bgtz t6, iformat
	addi s1, s1, -48
	bltz, s1, iformat
	addi t3, zero, 1
	mul t1, s1, t3 # multiply it by 1
	add s2, s2, t1 # add value to product
	
	lb s1, 1(a0) # load the second digit
	addi t6, s1, -58
	bgtz t6, iformat
	addi s1, s1, -48
	bltz, s1, iformat
	addi t3, zero, 4
	mul t1, s1, t3 # multiply it by 4
	add s2, s2, t1 # add value to product
	
	lb s1, 2(a0) # load the third digit
	addi t6, s1, -58
	bgtz t6, iformat
	addi s1, s1, -48
	bltz, s1, iformat
	addi t3, zero, 3
	mul t1, s1, t3 # multiply it by 3
	add s2, s2, t1 # add value to product
	
	lb s1, 3(a0) # load the fourth digit
	addi t6, s1, -58
	bgtz t6, iformat
	addi s1, s1, -48
	bltz, s1, iformat
	addi t3, zero, 7
	mul t1, s1, t3 # multiply it by 7
	add s2, s2, t1 # add value to product
	
	lb s1, 4(a0) # load the fifth digit
	addi t6, s1, -58
	bgtz t6, iformat
	addi s1, s1, -48
	bltz, s1, iformat
	addi t3, zero, 5
	mul t1, s1, t3 # multiply it by 5
	add s2, s2, t1 # add value to product
	
	lb s1, 5(a0) # load the sixth digit
	addi t6, s1, -58
	bgtz t6, iformat
	addi s1, s1, -48
	bltz, s1, iformat
	addi t3, zero, 8
	mul t1, s1, t3 # multiply it by 8
	add s2, s2, t1 # add value to product
	
	lb s1, 6(a0) # load the seventh digit
	addi t6, s1, -58
	bgtz t6, iformat
	addi s1, s1, -48
	bltz, s1, iformat
	addi t3, zero, 6
	mul t1, s1, t3 # multiply it by 6
	add s2, s2, t1 # add value to product
	
	lb s1, 7(a0) # load the eighth digit
	addi t6, s1, -58
	bgtz t6, iformat
	addi s1, s1, -48
	bltz, s1, iformat
	addi t3, zero, 9
	mul t1, s1, t3 # multiply it by 9
	add s2, s2, t1 # add value to product
	
	lb s1, 8(a0) # load the ninth digit
	addi t6, s1, -58
	bgtz t6, iformat
	addi s1, s1, -48
	bltz, s1, iformat
	addi t3, zero, 10
	
	mul t1, s1, t3 # multiply it by 10
	add s2, s2, t1 # add value to product

	addi t2, zero, 11
	rem s3, s2, t2 # find s2 % 11
	beq s3, zero, validB # if divisible by 11 jump to valid
	bne s3, zero, invalidB # else jump to invalid
	
	validB: 
		print_stringl(valid)
		beq s3, zero, exit
	invalidB: 
		print_stringl(invalid)
		bne s3, zero, exit
	iformat:
		print_stringl(format)
	exit:
		addi a7, zero, 10
		ecall