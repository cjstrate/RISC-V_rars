.macro read_int(%reg) # get an integer from user
	addi a7, zero, 5
	ecall # get the number
	add %reg, zero, a0 # store value in given register
.end_macro

.macro print_stringl(%label) # print string from label
	addi a7, zero, 4
	la a0, %label
	ecall
.end_macro

.macro print_int(%reg) # print int register
	addi a7, zero, 1
	add a0, zero, %reg
	ecall
.end_macro

.data
	prompt1: .asciz "How many objects can you choose from: "
	prompt2: .asciz "How many objects will you be choosing from: "
	errorPrompt: .asciz "Error: Negative value entered."
	endPrompt1: .asciz "The result of C("
	endPrompt2: .asciz ") is "
	comma: .asciz ","
.text
	print_stringl(prompt1) # get n
	read_int(a2)
	print_stringl(prompt2) # get k
	read_int(a3)
	sub a4, a2, a3 # set a4 to n-k for later use
	blt a2, zero, ErrorExit # if n is negative exit with error
	blt a3, zero, ErrorExit # if k is begative exit with error
	blt a4, zero, EarlyExit # if n-k is negative go to exit as the answer is 0
	addi a0, a2, 0 # set a0 to n for function
	jal ra, factorial # get n!
	addi s0, a0, 0 # set s0 to n!
	addi a0, a3, 0 # set a0 to k
	jal ra, factorial # get k!
	addi s1, a0, 0 # set s1 to k!
	addi a0, a4, 0 # set a0 to n-k
	jal ra, factorial # get (n-k)!
	addi s2, a0, 0 # set s2 to (n-k)!
	mul t0, s1, s2 # find k!(n-k)!
	div s3, s0, t0 # find n!/k!(n-k)!
	beq zero, zero, Exit
	ErrorExit:
	print_stringl(errorPrompt)
	beq zero, zero, Finish
	EarlyExit:
	addi s3, zero 0 # set final answer to 0
	Exit:
	print_stringl(endPrompt1)
	print_int(a2)
	print_stringl(comma)
	print_int(a3)
	print_stringl(endPrompt2)
	print_int(s3)
	Finish:
	addi a7, zero, 10 # exit program
	ecall
factorial:
    addi sp, sp, -8  # make space on stack
    sw   ra, 4(sp)   # save return address 
    sw   a0, 0(sp)   # save n

    addi t0, zero, 1 # 1 for comparing
    blt  t0, a0, L1  # if 1 < n need to recurse

    addi a0, zero, 1 # otherwise return 1
    addi sp, sp, 8   # release stack
    jalr zero, ra, 0 # return to caller

L1: addi a0, a0, -1  # compute n-1
    jal ra, factorial  # recurse fact(n-1)
	                 # (n-1)! is in a0

    lw t0, 0(sp)     # recover n
    lw ra, 4(sp)     # restore ra
    addi sp, sp, 8   # release stack
    mul a0, t0, a0   # compute n * fact(n-1)
    jalr zero, ra, 0 # return to caller
