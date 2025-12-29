#texts
.data

firstString: .asciiz "Enter n values (enter -1 to exit) : \n"
inputnString: .asciiz "Input n: "
invalidInputString: .asciiz "Invalid input! Please enter a non-negative integer or -1 to exit.\n"
progTermString: .asciiz "Program terminated.\n"
printFibone: .asciiz "fib["
printFibtwo: .asciiz "] = "
printFibthree: .asciiz "\n"
lastStringone: .asciiz "1s count in 32 LSBs of fib["
lastStringtwo: .asciiz "]: "
lastStringthree: .asciiz "\n\n"

# store input safely (so recursion doesn’t overwrite it)
savedN: .word 0

# main function

#declaring matrix trans[2][2] = {{1,1},{1,0}};
.align 2
trans: .word 1,1,1,0
.align 2
result: .space 16   # reserve 4 words (2x2 matrix)

.text
.globl main

main:
#printing first
li $v0, 4                  # syscall code to print string
la $a0, firstString        # Load the address of firstString into $a0
syscall                    # print the string
j WhileLoop

WhileLoop:
#printf("Input n: ")
li $v0, 4
la $a0, inputnString
syscall

#get input for n scanf
li $v0, 5                  # syscall code to read int
syscall                    # read int and put it inside $v0
move $t0, $v0              # store into t0 == n

#check for exit condition if (n == -1)
addi $t1, $zero, -1
beq $t0, $t1, ExitLoop     # if it is equal jump to exit

#check for valid input if n < 0
slti $t2, $t0, 0           # t2 == 1 if n < 0
bne $t2, $zero, InvalidInput

# load address of result matrix (word-aligned)
la $t2, result             # $t2 contains &result[0][0]

# save n safely in memory before recursion
sw $t0, savedN

#calling mat_fast_power_recursive(trans, (unsigned)n, result)
la $a0, trans              # load address of trans to a0
addi $a1, $t0, -1 #exponent = n-1
move $a2, $t2              # pointer to result[0][0]
jal mat_fast_power_recursive  # jump and link

# restore n after recursion
lw $t0, savedN

# reload result pointer to ensure alignment (some calls may disturb stack)
la $t2, result

#result is at t2
#fib_n = result[0][1]
lw $t3, 4($t2)             # t3 = fib_n

#bit_count = count_bits(fib_n)
move $a0, $t3
jal count_bits
move $t4, $v0              # t4 = bit count

# print "fib["
li $v0, 4
la $a0, printFibone
syscall

#print n
li $v0, 1
move $a0, $t0
syscall

li $v0, 4
la $a0, printFibtwo
syscall

li $v0, 1
move $a0, $t3 # print fib_n
syscall

li $v0, 4
la $a0, printFibthree
syscall

li $v0, 4
la $a0, lastStringone
syscall

li $v0, 1
move $a0, $t0
syscall

li $v0, 4
la $a0, lastStringtwo
syscall

li $v0, 1
move $a0, $t4              # print bit_count
syscall

li $v0, 4
la $a0, lastStringthree
syscall

#freeing the result and loop
j WhileLoop


#====================================
# Recursive bit counter
#====================================
count_bits:
beq $a0, $zero, ReturntoZero
addi $sp, $sp, -8
sw $ra, 4($sp)
sw $a0, 0($sp)

srl $a0, $a0, 1
jal count_bits
move $t0, $v0

lw $a0, 0($sp)
andi $t1, $a0, 1
add $v0, $t0, $t1

lw $ra, 4($sp)
addi $sp, $sp, 8
jr $ra
nop

ReturntoZero:
li $v0, 0
jr $ra
nop


#====================================
# Recursive matrix fast power
#====================================
mat_fast_power_recursive:
#a0 = &trans = &base[0][0] , a1 = n (exponent), a2 = &result[0][0]
beq $a1, $zero, ExpZero
li $t0, 1
beq $a1, $t0, ExpOne

# allocate space
addi $sp, $sp, -48
sw $ra, 44($sp)
sw $s0, 40($sp)
sw $s1, 36($sp)
sw $s2, 32($sp)
sw $s3, 28($sp)

move $s0, $a0          # base
move $s1, $a1          # exp
move $s2, $a2          # result

addi $s3, $sp, 0       # temp[0][0]
move $a0, $s0
srl $a1, $s1, 1
move $a2, $s3
jal mat_fast_power_recursive

# mat_mul(temp, temp, result)
move $a0, $s3
move $a1, $s3
move $a2, $s2
jal mat_mul

# if(exp %2 == 1)
andi $t1, $s1, 1
beq $t1, $zero, mfprDone

# odd case: res = res * base
addi $t2, $sp, 16
lw $t3, 0($s2)
lw $t4, 4($s2)
lw $t5, 8($s2)
lw $t6, 12($s2)
sw $t3, 0($t2)
sw $t4, 4($t2)
sw $t5, 8($t2)
sw $t6, 12($t2)

move $a0, $t2
move $a1, $s0
move $a2, $s2
jal mat_mul

mfprDone:
lw $s3, 28($sp)
lw $s2, 32($sp)
lw $s1, 36($sp)
lw $s0, 40($sp)
lw $ra, 44($sp)
addi $sp, $sp, 48
jr $ra


#====================================
# Matrix multiplication (2x2)
#====================================
mat_mul:
    addiu $sp, $sp, -52 # 4 (ra) + 32 (s0 - s7) + 16 (a[2][2], b[2][2]) = 52
    sw $ra, 48($sp)
    sw $s0, 44($sp) # i
    sw $s1, 40($sp) # j
    sw $s2, 36($sp) # k
    sw $s3, 32($sp) # addr of 'a'
    sw $s4, 28($sp) # addr of 'b'
    sw $s5, 24($sp) # addr of 'res'
    sw $s6, 20($sp) # addr of 'tmp'
    sw $s7, 16($sp) # to hold computed addr of tmp[i][j]

    addiu $s6, $sp, 0 # matrix tmp is at frame's base
    add $s3, $a0, $zero # a0 matrix a
    add $s4, $a1, $zero # a1 matrix b
    add $s5, $a2, $zero # a2 matrix res

    # initialize tmp[2][2]
    sw $zero, 0($s6)
    sw $zero, 4($s6)
    sw $zero, 8($s6)
    sw $zero, 12($s6)

    # for loops
    addi $s0, $zero, 0 # i = 0
forI:
    addi $s1, $zero, 0 # j = 0
forJ:
    addi $s2, $zero, 0 # k = 0
forK:
    # addr of a[i][k] = base_a + (i*2 + k)*4
    sll $t0, $s0, 1 # i * 2
    addu $t0, $t0, $s2 # i*2 + k
    sll $t0, $t0, 2 # (i*2 + k) * 4
    addu $t1, $s3, $t0 # &a[i][k]
    lw $t2, 0($t1) # a[i][k]

    # addr of b[k][j] = base_b + (k*2 + j)*4
    sll $t0, $s2, 1 # k * 2
    addu $t0, $t0, $s1 # k*2 + j
    sll $t0, $t0, 2 # (k*2 + j) * 4
    addu $t1, $s4, $t0 # &b[k][j]
    lw $t3, 0($t1) # b[k][j]

    mul $t4, $t2, $t3 # a[i][k] * b[k][j]

    # addr of tmp[i][j] = base_tmp + (i*2 + j)*4
    sll $t0, $s0, 1     # i * 2
    addu $t0, $t0, $s1  # i*2 + j
    sll $t0, $t0, 2     # (i*2 + j) * 4
    addu $s7, $s6, $t0  # &tmp[i][j]
    
    # add to tmp[i][j]
    lw $t5, 0($s7)
    addu $t5, $t5, $t4
    sw $t5, 0($s7)

    # end of k loop
    addiu $s2, $s2, 1
    blt $s2, 2, forK

    # end of j loop
    addiu $s1, $s1, 1
    blt $s1, 2, forJ

    # end of i loop
    addiu $s0, $s0, 1
    blt $s0, 2, forI

    # memcpy(res, tmp, 16 bytes)
    lw $t0, 0($s6)
    sw $t0, 0($s5)
    lw $t0, 4($s6)
    sw $t0, 4($s5)
    lw $t0, 8($s6)
    sw $t0, 8($s5)
    lw $t0, 12($s6)
    sw $t0, 12($s5)

    # restore stack, return
    lw $ra, 48($sp)
    lw $s0, 44($sp)
    lw $s1, 40($sp)
    lw $s2, 36($sp)
    lw $s3, 32($sp)
    lw $s4, 28($sp)
    lw $s5, 24($sp)
    lw $s6, 20($sp)
    lw $s7, 16($sp)
    addiu $sp, $sp, 52
    jr $ra

countBits:
    addiu $sp, $sp, -8
    sw $ra, 4($sp)
    sw $a0, 0($sp) # n

    # if (n == 0)
    bne $a0, $zero, count_bits
    addi $v0, $zero, 0 # return 0
    j countReturn
countReturn:
    # restore stack, return
    lw $ra, 4($sp)
    addiu $sp, $sp, 8
    jr $ra


ExpZero:
li $t0, 1
sw $t0, 0($a2)
sw $zero, 4($a2)
sw $zero, 8($a2)
sw $t0, 12($a2)
jr $ra

ExpOne:
lw $t0, 0($a0)
sw $t0, 0($a2)
lw $t0, 4($a0)
sw $t0, 4($a2)
lw $t0, 8($a0)
sw $t0, 8($a2)
lw $t0, 12($a0)
sw $t0, 12($a2)
jr $ra

InvalidInput:
li $v0, 4
la $a0, invalidInputString
syscall
j WhileLoop

ExitLoop:
li $v0, 4
la $a0, progTermString
syscall
li $v0, 10
syscall
