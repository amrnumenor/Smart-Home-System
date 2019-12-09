# # # # # # # # # # # # # # # # # # #
# Project Title : Smart Home System #
# # # # # # # # # # # # # # # # # # #
#       CSC 3402 SECTION 2	    #
# Muhammad Amiruddin 1711905	    #
# Muhammad Nuqman 1719301 	    #	
# Muhammad Akmal 1712883            #
# Mohamad Nor Idlan 1712021         #
# # # # # # # # # # # # # # # # # # # 

.include "login.asm"
.data
	msg_Menu: .asciiz "\n\nSelect one menu ?\n 1) Door\n 2) Light\n 3) Fan\n 4) Show Status\n 5) Exit Program\n \n>Enter your choice: "
	msg_Error: .asciiz "\nInvalid input !\n\n"
	debug_door: .asciiz "Door OK\n"
	debug_light: .asciiz "Light OK\n"
	debug_fan: .asciiz "Fan OK\n"
	msg_Door: .asciiz "+---------------+\n| ~DOOR~        |\n|1) Unlock Door |\n|2) Lock Door   |\n+---------------+\n>Enter input: "
	msg_DoorYes: .asciiz "\nThe door is now unlocked\n\n"
	msg_DoorNo: .asciiz "\nThe door is now locked\n\n"
	msg_Fan: .asciiz "+---------------+\n| ~FAN~         |\n|1) Turn On Fan |\n|2) Turn Off Fan|\n+---------------+\n>Enter input: "
	msg_FanYes: .asciiz "\nThe fan is turned on\n\n"
	msg_FanNo: .asciiz "\nThe fan is turned off\n\n"
	msg_Lamp: .asciiz  "+--------------------+\n| ~LIGHTS~           |\n|1) Switch On Lights |\n|2) Switch Off Lights|\n+--------------------+\n>Enter input: "
	msg_LampYes: .asciiz "\nThe light is switched on\n\n"
	msg_LampNo: .asciiz "\nThe light is switched off\n\n"
	status_header: .asciiz "\nSTATUS\n------"
	on: .asciiz "ON\n"
	off: .asciiz "OFF\n"
	unlock: .asciiz "UNLOCKED"
	lock: .asciiz "LOCKED  "
	statDoor: .asciiz "\nDOOR: "
	statLight: .asciiz "\nLAMP: "
	statFan: .asciiz "FANS: "
.text

# main driver
main:
	# initialize actuators default status
	li $t5, 2
	li $t6, 2
	li $t7, 2
	login # call login macro (user authentification)

menu:
        # menu windows
        print_str(msg_Menu)
        
        # input
        read_int
        
        move $t2, $v0
        
        beq $t2, 1, door 
        beq $t2, 2, light 
        beq $t2, 3, fan 
        beq $t2, 4, status 
        beq $t2, 5, exit 
        
        # invalid input error handler
        print_str(msg_Error)
        j menu

door:
	# print_str(debug_door)
	print_str(msg_Door)
	read_int	# sensor input (RFID scan)
	move $t2, $v0

        beq $t2, 1, door_open 
        beq $t2, 2, door_close 
        print_str(msg_Error) # error handler
        j  door
        
               
door_open: # actuator (unlock door)
	move $t5, $v0 # send signal to actuator
	print_str(msg_DoorYes)
	j menu
        
door_close: # actuator (lock door)
	move $t5, $v0
	print_str(msg_DoorNo)
	j menu
        
light:
	print_str(msg_Lamp)
	read_int	#sensor input (LDR / IR)
	move $t2, $v0
        
        beq $t2, 1, lamp_open 
        beq $t2, 2, lamp_close 
        print_str(msg_Error)
        j light
               
lamp_open: # actuator (turn on the lights)
	move $t6, $v0
	print_str(msg_LampYes)
	j menu
        
lamp_close: # actuator (turn off the lights)
	move $t6, $v0
	print_str(msg_LampNo)
	j menu
        
fan:
	#print_str(debug_fan)
	print_str(msg_Fan)
	read_int # sensor (thermostat measure temp)
	move $t2, $v0
        
        beq $t2, 1, fan_open
        beq $t2, 2, fan_close 
        print_str(msg_Error)
        j fan
               
fan_open: # actuator (turn on the fan)
	move $t7, $v0
	print_str(msg_FanYes)
	j menu
        
fan_close: # actuator (turn off the fan)
	move $t7, $v0
	print_str(msg_FanNo)
	j menu
	
status:
	# display status windows
	print_str(status_header)
	print_str(statDoor)
	jal doorstat
	print_str(statLight)
	jal lightstat
	print_str(statFan)
	jal fanstat
	j menu

doorstat:
	# use signal receive from sensor to update status
	beq $t5, 1, display_unlock
	beq $t5, 2, display_lock
	
display_unlock:
	print_str(unlock)
	jr $ra

display_lock:
	print_str(lock)
	jr $ra
	
lightstat:
	beq $t6,1, display_on
	beq $t6,2, display_off
	
display_on:
	print_str(on)
	jr $ra

display_off:
	print_str(off)
	jr $ra

fanstat:
	beq $t7, 1, display_on
	beq $t7, 2, display_off
# terminate program
exit: 
	exit_
