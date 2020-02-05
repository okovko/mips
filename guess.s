.data
secret:    .word      70
welcome:   .asciiz    "\nYou have 10 tries to guess a secret number."
prompt:    .asciiz    "\nGuess: "
small:     .asciiz    "\nYour guess was too small."
large:     .asciiz    "\nYour guess was too large."
found:     .asciiz    "\nYou've guessed the secret number.\nFailed attempts: "
mystery:   .asciiz    "\nYou've run out of guesses.\n"
newline:   .asciiz    "\n"

.text
.globl     main
main:      li $t0, 0                 # initialize loop counter
           li $t1, 10                # initialize loop maximum
           lw $t2, secret($0)        # initialize secret

           li $v0, 4                 # print the welcome text
           la $a0, welcome
           syscall

repeat:    li $v0, 4                 # print the prompt
           la $a0, prompt
           syscall
           li $v0, 5                 # read the guess
           syscall
           move $t3, $v0             # store the guess

           # move $a0, $t3           # debug: print the guess
           # li $v0, 1
           # syscall
           # move $a0, $t2           # debug: print the secret
           # li $v0, 1
           # syscall

           beq $t2, $t3, success     # goto success if guess correct

           # if
           blt $t1, $t2, if_true     # if guess is less than secret
         # if_false:
               la $a0, large         # otherwise, print that guess is too large
               j if_exit
           if_true:
               la $a0, small         # then print that guess is too small
           if_exit:
           li $v0, 4
           syscall

           addi $t0, $t0, 1          # increment loop counter
           blt $t0, $t1, repeat      # repeat loop

           j failure                 # reached end of loop, secret was not guessed

success:   li $v0, 4                 # secret was guessed, print the found prompt
           la $a0, found
           syscall
           li $v0, 1                 # also print the failed attempts
           move $a0, $t0
           syscall
           li $v0, 4                 # and a newline
           la $a0, newline
           syscall
           j exit

failure:   li $v0, 4                 # secret was not guessed, print the mystery prompt
           la $a0, mystery
           syscall

exit:      li $v0, 10                # terminate the program
           syscall
