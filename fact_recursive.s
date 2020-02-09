###############################################################################################
# MIPS R2000 (no macros)
###############################################################################################
    
.data
welcome:    .asciiz    "\nEnter a number 0-12 (> 12 overflows) \
to calculate its factorial (recursive)."
prompt:     .asciiz    "\nNumber: "
output:     .asciiz    "\nFactorial: "
newline:    .asciiz    "\n"
    
.text
.globl main
.globl fact

###############################################################################################
# self explanatory driver for SPIM to command line test fact
###############################################################################################
main:
          li $v0, 4
          la $a0, welcome
          syscall
          la $a0, prompt
          syscall
          li $v0, 5
          syscall
          move $a0, $v0
          jal fact
          move $t0, $v0
          li $v0, 4
          la $a0, output
          syscall
          move $a0, $t0
          li $v0, 1
          syscall
          li $v0, 4
          la $a0, newline
          syscall
          li $v0, 10
          syscall

###############################################################################################
# typical factorial function exercise
# recursive function
#
# values > 12 will overflow the 32 bit return register
# mainly interesting to demonstrate recursion
###############################################################################################
fact:
          bne $a0, $0, nonzero    # 0! = 1
          li $v0, 1
          j exit
nonzero:
          move $v0, $a0           # 1! = 1, 2! = 2
          li $t0, 2
          ble $a0, $t0, exit
wind:
          addi $a0, $a0, -1       # first arg already in v0
          addi $sp, $sp, -8       # push a0-1 and ra on stack
          sw $ra, 4($sp)
          sw $a0, 0($sp)
          beq $a0, $t0, unwind    # push until a0 = 2
          jal wind
unwind:
          lw $a0, 0($sp)          # load a0-1 and ra
          lw $ra, 4($sp)
          addi $sp, $sp, 8
          mul $v0, $v0, $a0       # v0 = v0 * a0-1
exit:
          jr $ra
###############################################################################################
