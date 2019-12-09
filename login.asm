.include "macros.asm"
.data
	login_header: .asciiz "USER LOGIN\n----------\n" 
	userID: .asciiz "ihome\n"
	input_ID: .space 10
	msg_ID: .asciiz "Please enter your ID: "
	userPsw: .asciiz "myhome1234\n"
	input_Psw: .space 12
	msg_Psw: .asciiz "Please enter your password: "
	login_Error: .asciiz "You have entered invalid user details\n"
	success_msg: .asciiz "\nYou've Logged In Successfully"
	
.text
	
.macro login
    header:
    	print_str(login_header)    
 
    check_user:        
        la $s2, input_ID
        la $s3, userID
        li $t8, 0 
        move $t1, $s2 

        # prompt windows (userID)
	print_str(msg_ID)

        # username input
        move $a0, $t1 # load address 
        li $a1, 10
        li $v0, 8
        syscall
        jal strcmp # proceed to compare function


check_pass:
        la $s2, input_Psw
        la $s3, userPsw
        li $t8, 1
        move $t1, $s2

        # prompt windows (userPassword)
	print_str(msg_Psw)

        # read password
        move $a0, $t1 # load address
        li $a1, 12
        li $v0, 8
        syscall
        jal strcmp # proceed to compare function

    # compare strings ($s2, $s3) for verifivation purpose
    strcmp:
        lb $t2,($s2)
        lb $t3,($s3)
        bne $t2, $t3,cmpne # if not equal
        beq $t2, $zero, cmpeq # if equal
        addi $s2, $s2,1 # point to next char
        addi $s3, $s3,1 # point to next char
        j strcmp

    # if equal
    cmpeq:
        # if the caller is the username function check password next
        beq $t8, $zero, check_pass
        # if pass is correct that means both are correct so start option1
        beq $t8, 1, continuez

    # if not equal
    cmpne:
	print_str(login_error)
        syscall
        beq $t8, $zero, check_user # if caller is username function
        beq $t8, 1, check_pass # if the caller is pass label ask for pass again

   # successful login proceed into the program
   continuez:
	la $a0, success_msg
        li $v0, 4
        syscall
.end_macro
