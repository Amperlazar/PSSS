.data
.align 4
# =========testcase1===========
#arr: .word 5, 4, 3
#n: .word 3
#str: .string "output: "
#space: .string " "
# output: 12 9 8 5 7 4 3 0
# ==============================

# =========testcase2===========
arr: .word 2, 3
n: .word 2
str: .string "output: "
space: .string " "
# output: 5 2 3 0
# ==============================

.text
.global _start

_start:
    # Print delimiter string (output:) by setting ecall argument to 4
    la a0, str
    li a7, 4
    ecall
    
    # set arguments (sum, r, l, base addr. of arr)
    addi a0, zero, 0  #a0 = sum = 0
    la t0, n  #t0 = base addr. of n
    lw t1, 0(t0) #t1 = n
    addi a2, zero, 0  #a2 = l
    addi a1, t1, -1  #a1 = r = n-1
    la a3, arr  #a3 = base addr. of arr
    
    jal ra, subsetSums
    j end

subsetSums:
    addi sp, sp, -20  #allocate 5 words of stack space
    sw ra, 0(sp)  #save return address
    sw a0, 4(sp)  #save current sum
    sw a1, 8(sp)  #save r
    sw a2, 12(sp)  #save current l
    sw a3, 16(sp)  #save the base address of arr

    bge a1, a2, L1  #go to L1 if l <= r
    
    #Print sum (in a0) by setting ecall argument to 1
    li a7, 1
    ecall
    #Print delimiter string by setting ecall argument to 4
    la a0, space
    li a7, 4
    ecall

    addi sp, sp, 20  #Pop 5 words from the stack
    jalr zero, 0(ra)  #return

L1: # Subset including arr[l]
    slli t0, a2, 2  #t0 = 4*l
    add t1, a3, t0  #t1 = (base address of arr(in a3)) + 4*l
    lw t2, 0(t1)  #t2 = arr[l]
    add a0, a0, t2  #a0 = sum + arr[l]
    addi a2, a2, 1  #a2 = l+1
    jal ra, subsetSums

    # Subset excluding arr[l]
    lw a0, 4(sp)  #restore argument sum
    jal ra, subsetSums
    lw ra, 0(sp)  #restore return address
    lw a0, 4(sp)  #restore sum
    lw a1, 8(sp)  #restore r
    lw a2, 12(sp)  #restore l
    lw a3, 16(sp)  #restore the base address of arr
    addi sp, sp, 20 
    jalr zero, 0(ra)  #return

end:nop
