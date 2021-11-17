.port uart, 0x60
.port uart_int_mask, 0x62
.port buttons_int_mask, 0x12
.port int_status, 0xE0
.port int_mask, 0xE1
.reg s0, s
.reg s1, d

LOAD s, 1<<4
OUT s, uart_int_mask
LOAD s, 0b10000001
OUT s, buttons_int_mask
LOAD s, 0b101
OUT s, int_mask
EINT

petla: jump petla

u:
in d, uart
add d, 1
out d, uart
RET

b:
load d, '#'
out d, uart
RET
	
int:
in s, int_status
TEST s, 1<<2
CALL NZ, u
TEST s, 1
CALL NZ, b
LOAD s, 0
out s, int_status
RETI

.CSEG 0x3FF
jump int