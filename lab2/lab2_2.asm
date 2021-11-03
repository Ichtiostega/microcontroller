.port uart, 0x60
.port status, 0x61
.reg s0, s
.reg s1, d

petla: in s, status
TEST s, 1<<4
CALL NZ, read
jump petla

read:
in d, uart
add d, 1
out d, uart
RET