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
	A: .space 44
	B: .space 44
	C: .space 84
	U: .space 84
	Aprompt: .asciz "Enter the legnth of your first array: "
	Bprompt: .asciz "Enter the length of you second array: "
	NumPrompt: .asciz "Enter you numbers below:\n"
	int: .asciz "Intersection: "
	union: .asciz "Union: "
	Obracket: .asciz "["
	Cbracket: .asciz "]\n"
	comma: .asciz ","
.text
	la s0, A
	la s1, B
	la s2, C
	la s3, U
	print_stringl(Aprompt)# yaa
	read_int(s4)
	print_stringl(NumPrompt)# yaa
	beq s4, zero, Bpart
	addi t0, s0, 0
	addi t1, zero, 0
	addi t5, s3, 0# yaaa
	LoopA:
		read_int(t2)
		sw t2, 0(t0)
		sw t2, 0(t5)
		addi t0, t0, 4# comments
		addi t5, t5, 4
		addi t1, t1, 1
		bne t1, s4, LoopA
	Bpart:
	print_stringl(Bprompt)
	read_int(s5)
	print_stringl(NumPrompt)
	addi s8, s4, 0
	beq s5, zero, EndPrompt# yaa
	addi t0, s1, 0
	addi t1, zero, 0
	LoopB:
		read_int(t2)
		sw t2, 0(t0)# wooo
		jal ra, checkInA
		beq a2, zero, In 
		sw t2, 0(t5)
		addi s8, s8, 1
		addi t5, t5, 4
		addi t0, t0, 4
		addi t1, t1, 1
		bne t1, s5, LoopB
		beq t1, s5, EndPrompt# yaaa
		In:
			addi t0, t0, 4
			addi t1, t1, 1
			bne t1, s5, LoopB
	EndPrompt:
		addi t0, s2, 0
		addi a7, s0, 0
		addi a6, s1, 0
		addi t1, zero, 0
		beq s4, zero, Zero
		beq s5, zero, Zero
		loop:
			lw t2, 0(a6)
			jal ra, checkInA
			bne a2, zero, skip# good stuff
			sw t2, 0(t0)
			addi t0, t0, 4
			addi s7, s7, 1
			skip:
			addi t1, t1, 1
			addi a6, a6, 4
			bne t1, s5, loop
			jal ra, Exitloop
		Zero:
			addi s7, zero, 0
		Exitloop:
		print_stringl(int)# thats right
		jal ra, printIntersect
		print_stringl(union)
		jal ra, printUnion
		addi a7, zero 10
		ecall
	checkInA:
		addi a2, zero, 0
		addi t4, s0, 0
		addi t6, zero, 0
		Loop:
			lw t3, 0(t4)
			addi t4, t4, 4
			addi t6, t6, 1
			bne t3, t2, good
			addi a2, zero, 0
			beq t3, t3, ExitLoop
			good:
				addi a2, zero, 1
				bne t6, s4, Loop
			ExitLoop:
			jalr zero, ra, 0
	printUnion:
		addi t1, zero, 0
		addi t3, s3, 0
		print_stringl(Obracket)
		beq s8, zero, end
		Uloop:
			lw t4, 0(t3)
			print_int(t4)
			addi t1, t1, 1
			addi t3, t3, 4
			beq t1, s8, ncomma
			print_stringl(comma)
			ncomma:
			bne t1, s8, Uloop
			end:
			print_stringl(Cbracket)
		jalr zero, ra, 0
	printIntersect:
		addi t1, zero, 0
		addi t3, s2, 0
		print_stringl(Obracket)
		beq s7, zero, End
		Iloop:
			lw t4, 0(t3)
			print_int(t4)
			addi t1, t1, 1
			addi t3, t3, 4
			beq t1, s7, Ncomma
			print_stringl(comma)
			Ncomma:
			bne t1, s7, Iloop
			End:
			print_stringl(Cbracket)
		jalr zero, ra, 0
		