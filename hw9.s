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
	D1: .asciz "Divisor: "
	D2: .asciz "Dividend: "
	S: .asciz " / "
	E: .asciz " = "
	R: .asciz " R "
	
.text
	addi t5, zero, 0
	addi t6, zero, 0
	print_stringl(D1) # get divisor
	read_int(a1)
	print_stringl(D2) # get dividend
	read_int(a2)
	
	blt zero, a2, check2
	sub a2, zero, a2
	addi t5, zero, 1
	
	check2:
	blt zero, a1, Begin
	sub a1, zero, a1
	addi t6, zero, 1
	
	Begin:
	jal ra, divide # jump to division function
	
	beq t5, zero, check3
	sub a2, zero, a2
	
	check3:
	beq t6, zero, check4
	sub a1, zero, a1
	
	check4:
	beq t5, t6, End
	sub a4, zero, a4
	sub a5, zero, a5
	
	End:
	print_int(a2) # print output
	print_stringl(S)
	print_int(a1)
	print_stringl(E)
	print_int(a4)
	print_stringl(R)
	print_int(a5)
	
	addi a7, zero, 10 # exit
	ecall

shift:
	add t0, zero, a4 # set t0 = a4
	slli t0, t0, 1
	srli t0, t0, 1
	bne t0, a4, OverFlow # if t0 is no longer equal to a4 then it overflowed
	slli a4, a4, 1 # if it did not overflow shift normally
	slli a5, a5, 1
	jalr zero, ra, 0
	OverFlow:
		slli a4, a4, 1 # if it did overflow then set the least significant bit of a5 to 1
		slli a5, a5, 1
		ori a5, a5, 1
	jalr zero, ra, 0

divide:
	addi a5, zero, 0 # set left side to 0
	add a4, zero, a2 # place dividend in remainder
	addi t3, zero, 0
	addi t1, zero, 32
	
	addi sp, sp, -4
	sw ra, 0(sp)
	jal ra, shift # shift the remainder 1 to the left
	Loop:
		sub a5, a5, a1 # subtract remL = remL - Div
		blt a5, zero, LT
		jal ra, shift # shift remainder 1 to the left
		ori a4, a4, 1 # set least significant bit to 1
		beq zero, zero, check
		LT:
			add a5, a5, a1 # reset left side
			jal ra, shift # shift 1 the the left
		check:
			addi t3, t3 ,1 # if 32nd loop then continue
			bne t3, t1, Loop
	srli a5, a5, 1 # shift left side one to the right
	lw ra, 0(sp) # restore return address and return
	addi sp, sp, 4
	jalr zero, ra, 0