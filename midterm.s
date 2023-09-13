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
	A: .space 80
	Element: .asciz "Element "
	Colon: .asciz ": "
	Prompt: .asciz "Enter the size of the sorted array: "
	FindPrompt: .asciz "Enter the number to search for: "
	ErrorEnd: .asciz "The number is nowhere to be found!"
	End: .asciz "The number is at index "
	
.text
	print_stringl(Prompt)
	read_int(s1) # size of array is s1
	addi a2, zero, 0
	la s0, A # address of array is s0
	addi t0, s0, 0
	Loop:
		jal ra, GetElement # call Get Element
		sw a0, 0(t0) # save retrived element into the array
		addi t0, t0, 4 # iterate the pointer
		addi a2, a2, 1 # iterated the number of loops we have done
		bne a2, s1, Loop # loop if the number of loops we have done does not equal the number of loops needed
	
	addi a1, zero, 0# set begining = 0 (a1)
	addi a2, s1, -1 # set end = last index (a2)
	print_stringl(FindPrompt)
	read_int(a3) # set number we are looking for to a3
	addi a0, s0, 0 # set a0 to address of array
	jal ra, BIN_SEARCH # call search
	addi t0, a0, 0 
	blt a0, zero, NotFound # if returned -1 then not found
	print_stringl(End)
	print_int(t0)
	beq zero, zero, Exit
	NotFound:
		print_stringl(ErrorEnd)
	Exit:
		addi a7, zero, 10 # exit
		ecall
GetElement:
	print_stringl(Element)
	print_int(a2)
	print_stringl(Colon)
	read_int(a0)
	jalr zero, ra, 0

BIN_SEARCH:
	addi sp, sp, -4 # set stack and save return address (pretty sure its the only value that needs saving)
	sw ra, 0(sp)

	# Base case
	bne t0, a3, NOT_FOUND # if (arr[mid] == x) return mid.
	add a0, x0, t2
	jalr x0, ra, 0

	NOT_FOUND:
		# first bit of C code to check for bad bounds
		blt a2, a1, INCORRECT_BOUNDS # if (r < l) return -1.

		# find the new middle to recurse off of
		sub t0, a2, a1
		srai t1, t0, 1
		add t2, t1, a1

		# Get the middle vlaue of the array
		slli t3, t2, 2 # mid * sizeof(int)
		add t3, t3, a0 # pointer to arr[mid].
		lw t0, 0(t3)   # get value at arr[mid].
		
		# check if middle is the value we are looking for
		bne t0, a3, NOT_EQ # if (arr[mid] == x) return mid.
		add a0, x0, t2
		jalr x0, ra, 0

	NOT_EQ:
		# chek if the value is greater than or less than our middle value
		bge a3, t0, GREATER_THAN
		addi a2, t2, -1
		jal ra, BIN_SEARCH # recurse with the less than part of the array

	GREATER_THAN:
		addi a1, t2, 1
		jal ra, BIN_SEARCH # recurse with the greater than part of the array

	RET:
		# retrive the return address and pop the stack
		lw ra, 0(sp)
		addi sp, sp, 4
		jalr x0, ra, 0 # return

	INCORRECT_BOUNDS:
		# if bounds are bad return -1
		addi a0, x0, -1
		lw ra, 0(sp)
		addi sp, sp, 4
		jalr x0, ra, 0