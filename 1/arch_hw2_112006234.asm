.data
pBase: .asciiz "base: "
pExponent: .asciiz "exponent: "
pZero: .asciiz "Both base and exponent are zero. Exiting."
pError: .asciiz "Error: Exponent cannot be negative."
pNewline: .asciiz "\n"
pNewlines: .asciiz "\n\n"
pResult: .asciiz "result: "
pHamming: .asciiz "hamming weight: "

.text
Loop:
    # print prompt base
    la   $a0, pBase # load address of string pBase to a0
    addi $v0, $zero, 4 # v0 4 print_string
    syscall

    # read base
    addi $v0, $zero, 5 # v0 5 read_int
    syscall
    add $t0, $v0, $zero # store input from v0 to t0

    # print exponent
    la   $a0, pExponent
    addi $v0, $zero, 4
    syscall

    # read exponent
    addi $v0, $zero, 5
    syscall
    add $t1, $v0, $zero  

    # if base == 0 && exponent == 0
    or $t3, $t0, $t1
    bne $t3, $zero, checkLT
    la $a0, pZero
    addi $v0, $zero, 4
    syscall
    
    # newline
    la   $a0, pNewline
    addi $v0, $zero, 4
    syscall
    j Exit
    
# if exponent < 0
checkLT:
    slti $t4, $t1, 0
    bne $t4, $zero, Negative
    j binaryAlgo

Negative:
    la   $a0, pError
    addi $v0, $zero, 4
    syscall
    
    la   $a0, pNewlines
    addi $v0, $zero, 4
    syscall
    j loopAgain

binaryAlgo:
    addi $t5, $zero, 1 # power_result = 1
    add $t6, $t0, $zero # temp_base = base
    add $t7, $t1, $zero # temp_exponent = exponent

binaryLoop:
    # while temp_exponent > 0
    slti $t8, $t7, 1 
    bne $t8, $zero, printPower
    
    # if temp_exponent & 1
    andi $t9, $t7, 1
    beq  $t9, $zero, skipIF
    mul  $t5, $t5, $t6 # power_result *= temp_base

skipIF:
    mul  $t6, $t6, $t6 # temp_base *= temp_base
    srl  $t7, $t7, 1 # temp_exponent >>= 1
    j binaryLoop

printPower:
    la   $a0, pResult
    addi $v0, $zero, 4
    syscall

    add $a0, $t5, $zero
    addi $v0, $zero, 1 # v0 1 print signed int
    syscall

    la   $a0, pNewline
    addi $v0, $zero, 4
    syscall

hamming:
    addi $t4, $zero, 0 # weight_count = 0
    addi $t8, $zero, 0 # i = 0
    addi $t2, $zero, 1 # 1 for masking
hammingLoop:
    slti $t3, $t8, 32
    beq  $t3, $zero, printHamming
    
    # if power_result>>i & 1
    and $t1, $t5, $t2 #masking 1 dri kanan ke kiri
    beq  $t1, $zero, skipIf
    addi $t4, $t4, 1 #weight_count++
    
skipIf:
    sll $t2, $t2, 1 #shift 1 ke kiri bwt masking
    addi $t8, $t8, 1 #i++
    j hammingLoop

printHamming:
    la   $a0, pHamming
    addi $v0, $zero, 4
    syscall

    add $a0, $t4, $zero
    addi $v0, $zero, 1
    syscall

    la   $a0, pNewlines
    addi $v0, $zero, 4
    syscall

loopAgain:
    j Loop
    
Exit:
    addi $v0, $zero, 10 # exit v0 10
    syscall
