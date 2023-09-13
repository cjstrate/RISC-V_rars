# sample code to demonstrate how RISC-V works on bitwise operations
# set s0 to the value contained in bits 15 to 10 of s1.

.data
NL: .asciz "\n"

.text
.globl	main

main: 

    # load and shift each byte so s1 = 0xAABBCCDD
    addi s1, zero, 0x000000AA
    slli s1, s1, 8
    ori s1, s1, 0x000000BB
    slli s1, s1, 8
    ori s1, s1, 0x000000CC
    slli s1, s1, 8
    ori s1, s1, 0x000000DD
    
    # print s1 in hex
    add a0, s1, zero
    addi a7, zero, 34
    ecall

    la a0, NL
    addi a7, zero, 4
    ecall

####solution 1:
	srli  t0, s1, 10
	andi s0, t0, 0x3F
	
    # print s0 in hex
    add a0, s0, zero
    addi a7, zero, 34
    ecall

    la a0, NL
    addi a7, zero, 4
    ecall

#### solution 2:
    # isolate bits 15-10 of s1, put in t0
    addi t0, zero, 0xFC
    slli t0, t0, 8  # create mask 0xFC00
    and t0, s1, t0

    # put those bits into bits 5-0 in s0
    srli s0, t0, 10

    # print s0 in hex
    add a0, s0, zero
    addi a7, zero, 34
    ecall

    la a0, NL
    addi a7, zero, 4
    ecall

#### solution 3:
    slli t0, s1, 16  # x = y <<16
    srli s0, t0, 26 # x = x >> 26

    # print s0 in hex
    add a0, s0, zero
    addi a7, zero, 34
    ecall


#exit
    addi a7, zero, 10
    ecall

