.port uart, 0x60
.port status, 0x61
.port lc, 0x31
.port lv, 0x30
.reg s0, s
.reg s1, d
.reg s2, zero 
.reg s3, one
.reg s4, val
.reg s5, rs
load zero, 0
load one, 1
load rs, 0

call init

loop: 
in s, status
TEST s, 1<<4
CALL NZ, print
jump loop

print:
in d, uart
out d, lv
call impulse
call second
ret

init:
load val, 0x38

out val, lv
call impulse
call second

out val, lv
call impulse
call second

out val, lv
call impulse
call second

out val, lv
call impulse
call second

load val, 0x6
out val, lv
call impulse
call second

load val, 0xe
out val, lv
call impulse
call second

load val, 0x1
out val, lv
call impulse
call second

load rs, 0b10
out rs, lc

ret

second:
	LOAD sE, 255
	CALL loop2
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

impulse:
or one, rs
out one, lc
load one, 1
load one, one
or zero, rs
out zero, lc
load zero, 0
ret
