.port uart, 0x60
.port status, 0x61
.reg s0, s
.reg s1, d
.reg s2, ptr
.reg s3, v

.DSEG
var:	.DB	"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut venenatis mi. Sed odio nulla, vestibulum quis viverra eu, volutpat bibendum metus. Vivamus pellentesque aliquam tellus, sed consequat dui scelerisque quis. Maecenas sem mauris, semper id."

.CSEG
load ptr, var

loop: 
fetch d, ptr
comp d, 0
jump Z, inf
call check_busy
out d, uart
add ptr, 1
jump loop

check_busy:
in s, status
test s, 1<<2
jump NZ, check_busy
ret

inf: jump inf
