.port leds, 0
.port switches, 0x10

main: 
	LOAD s0, 0xCC
;	LOAD s1, 0x33

loop: 
	IN s1, switches
	OUT s0, leds
	CALL delay
	OUT s1, leds
	CALL delay
	JUMP loop

delay:
	LOAD sD, 255
	CALL loop3
	RET

loop3:
  LOAD sE, 255
	CALL loop2
	SUB sD, 1
	JUMP NZ, loop3
	RET

loop2:
  LOAD sF, 255
	CALL loop1
	SUB sE, 1
	JUMP NZ, loop2
	RET
	
loop1:
	SUB sF, 1
	JUMP NZ, loop1
	RET

