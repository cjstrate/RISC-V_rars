.macro print_string(%reg) # print string register
	addi a7, zero, 4
	add a0, zero, %reg
	ecall
.end_macro

.macro input_char(%int)
	addi a7, zero, 12
	ecall
	sb a0, %int(a5) # load inputed value into appropraite index
	
	addi a7, zero, 4 # print a newline
	add a0, zero, a3
	ecall
.end_macro

.data
	chars: .space 6 # char array
	output: .string "\nPrinted String: " 
	prompt: .string "Hello, please enter 5 chars:\n"
	newline: .string "\n"
.text
	
	la a5, chars
	la a1, prompt
	la a2, output
	la a3, newline # probably a better way to do this
	
	print_string(a1) # prompt user
	
	input_char(0) # input 5 chars
	input_char(1)
	input_char(2)
	input_char(3)
	input_char(4)
	
	print_string(a2) # print output message
	print_string(a5) # print string (char array)
	
	addi a7, zero, 10 # exit
	ecall