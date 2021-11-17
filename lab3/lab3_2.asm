.port uart, 0x60
.port uart_int_mask, 0x62
.port buttons_int_mask, 0x12
.port int_status, 0xE0
.port int_mask, 0xE1
.reg s0, s
.reg s1, d
.reg s2, ptr

.DSEG
var:	.DB	"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut venenatis mi. Sed odio nulla, vestibulum quis viverra eu, volutpat bibendum metus. Vivamus pellentesque aliquam tellus, sed consequat dui scelerisque quis. Maecenas sem mauris, semper id."

.CSEG
load ptr, var

LOAD s, 0
OUT s, uart_int_mask
LOAD s, 0b10000001
OUT s, buttons_int_mask
LOAD s, 0b101
OUT s, int_mask
EINT

petla: jump petla

reset_status:
LOAD s, 0
OUT s, uart_int_mask
JUMP end_int


u:
fetch d, ptr
comp d, 0
jump Z, reset_status
out d, uart
add ptr, 1
RET

b:
load ptr, var
LOAD s, 1
OUT s, uart_int_mask
RET
	
int:
in s, int_status
TEST s, 1
CALL NZ, b
TEST s, 1<<2
CALL NZ, u
end_int:
LOAD s, 0
out s, int_status
RETI

.CSEG 0x3FF
jump int