# SAMPLE RISC-V Program for making function calls

.data
    prompt_mcand: .asciz "Enter multiplicand:"
    prompt_mplier: .asciz "Enter muliplier:"
    NL: .asciz "\n"

.text
main:

    addi a7, zero, 4    # display prompt
    la a0, prompt_mcand
    ecall

    addi a7, zero, 5    # get a number from user
    ecall
    add s1, a0, zero    #store the number in s1 (j)

    addi a7, zero, 4    # display prompt
    la a0, prompt_mplier
    ecall

    addi a7, zero, 5    # get a number from user
    ecall
    add s2, a0, zero    #store the number in s2 (k)

# i, j, k, m: s0 - s3
# i= mult(j,k); m=mult(i,i);

	addi a0,s1,0     # arg0 = j
    addi a1,s2,0     # arg1 = k
    jal ra, mult    # call mult (j,k)
    
    addi s0, a0, 0  # i = mult (j,k)
    
	addi a7, zero, 1
	ecall
	
	la a0, NL
	addi a7, zero, 4
	ecall
	
	addi a0, s0, 0 
    addi a1, s0, 0
    jal ra, mult    # call mult (i,i)
    addi s3, a0, 0
	addi a7, zero, 1
	ecall
	
    addi a7, zero,10
    ecall

#function: int mult (int mcand, int mlier)
# product = 0
# while (mlier>0) {
# product += mcand;
# mlier -=1;
# return product
mult:									
    addi t0, zero, 0  # prod = 0

loop:
    bge zero, a1, Fin      # if mlr <=0, goto Fin
    add t0, t0, a0      # prod += mc
    addi a1,a1, -1      # mlr --
    jal zero, loop

Fin:
    addi a0, t0, 0
    jalr zero, ra, 0


