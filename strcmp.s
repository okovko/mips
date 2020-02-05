.data
welcome:    .asciiz    "\nThis program tests a MIPS strcmp.
To test a NULL string, type NULL.\n"
prompt1:    .asciiz    "\nEnter str1: "
prompt2:    .asciiz    "\nEnter str2: "
output:     .asciiz    "\nstrcmp: "
newline:    .asciiz    "\n"
nullstr:    .asciiz    "NULL\n"
    
.text
.globl main
.globl strcmp
    
main:
                 li $v0, 4
                 la $a0, welcome
                 syscall

                 # li $v0, 4
                 la $a0, prompt1
                 syscall

                 li $v0, 8
                 syscall

                 la $a1, nullstr
                 jal strcmp

                 # if1
                 bne $v0, $0, if1_false
               # if1_true:
                     li $t0, 0
                     j if1_exit
                 if1_false:
                     move $s0, $a0
                 if1_exit:

                 li $v0, 4
                 la $a0, prompt2
                 syscall

                 li $v0, 8
                 syscall

                 la $a1, nullstr
                 jal strcmp

                 # if2
                 bne $v0, $0, if2_false
               # if2_true:
                     li $a1, 0
                     j if2_exit
                 if2_false:
                     move $a1, $a0
                 if2_exit:

                 move $a0, $s0

                 jal strcmp
                 move $t0, $v0

                 li $v0, 4
                 la $a0, output
                 syscall

                 li $v0, 1
                 move $a0, $t0
                 syscall

                 li $v0, 4
                 la $a0, newline
                 syscall
    
                 li $v0, 10
                 syscall

###############################################################################################
strcmp:
                 li $v0, 0                  # cmp = 0
                 beq $a0, $a1, exit_cmp     # same string (maybe both null) => goto exit_cmp
                 and $t0, $a0, $a1          # t0 = 0 when one string is null
                 beq $t0, $0, exit_null     # t0 = 0 => goto exit_null

                                            # otherwise, loop over bytes
                 move $t0, $a0              # put args in temps
                 move $t1, $a1

repeat:
                 lb $t2, 0($t0)             # str1 byte
                 lb $t3, 0($t1)             # str2 byte

                 sub $v0, $t2, $t3          # cmp = b1 - b2
                 bne $v0, $0, exit_cmp      # v0 != 0 => goto exit_cmp
                 beq $t2, $0, exit_cmp      # t2 = 0 => goto exit_cmp
                 addi $t0, $t0, 1           # str1++
                 addi $t1, $t1, 1           # str2++
                 j repeat                   # goto repeat

exit_null:
                 or $t0, $a0, $a1           # t0 = addr of non-null string
                 lb $v0, 0($t0)             # first byte of non-null string
                 beq $a0, $0, negate        # a0 null => goto negate
                 j exit_cmp                 # otherwise, ready to return
negate:
                 neg $v0, $v0               # preserve arg order semantic by negating
exit_cmp:
                 jr $ra                     # return
###############################################################################################
