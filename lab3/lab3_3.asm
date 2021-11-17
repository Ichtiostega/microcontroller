.port leds, 0
.port ct_lbyte, 0xC0
.port ct_OCR0_H, 0xC2
.port int_mask, 0xE1
.port ct_config0, 0xC1
.port int_status, 0xE0
.port ct_status, 0xC9
.port ct_int_mask, 0xCA

.reg s0, all_led
.reg s1, config_b
.reg s2, status

LOAD config_b, 1
OUT config_b, ct_int_mask
LOAD config_b, 99
OUT config_b, ct_lbyte
LOAD config_b, 0
OUT config_b, ct_OCR0_H
LOAD config_b, 1<<5
OUT config_b, int_mask
LOAD config_b, 0b101101
OUT config_b, ct_config0
EINT

main: JUMP main

blink:
	LOAD all_led, 255
	OUT all_led, leds
	CALL wait
	LOAD all_led, 0
	OUT all_led, leds
	RET

wait:
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
	SUB sE, 1
	JUMP NZ, loop2
	RET

int:
	CALL blink
	LOAD status, 0
	OUT status, int_status
	OUT status, ct_status
	RETI

.CSEG 0x3FF
	JUMP int