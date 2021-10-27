.port leds, 0
.port buttons, 0x11
.const button_mask, 0b00000010
.reg sF, prev
.reg sE, current
.reg s1, count

main: 
	LOAD count, 0
	LOAD prev, 0
	LOAD current, 0

loop:
	IN current, buttons
	CALL delay
	COMP prev, current
	CALL C, sum
	LOAD prev, current
	OUT count, leds
	JUMP loop

sum:
	ADD count, 1
	RET

delay:
	LOAD sD, 255
	CALL loop2
	RET
	
loop2:
  LOAD sC, 255
	CALL loop1
	SUB sD, 1
	JUMP NZ, loop2
	RET

loop1:
	SUB sC, 1
	JUMP NZ, loop1
	RET