.port leds, 0
.port buttons, 0x11
.const button_mask, 0b00000010

main: 
	LOAD s0, 0xCC
	LOAD s1, 0x33

loop: 
	IN s2, buttons
	TEST s2, button_mask
	CALL Z, on
	CALL NZ, off
	JUMP loop

on:
	OUT s0, leds
	RET

off:
	OUT s1, leds
	RET