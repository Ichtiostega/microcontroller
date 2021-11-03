.port lc, 0x31
.port lv, 0x30
.reg s0, zero 
.reg s1, one
.reg s2, val
.reg s3, rs
load zero, 0
load one, 1
load rs, 0

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

load val, 0xcc
out val, lv
call impulse
call second

load rs, 0b10
out rs, lc

load val, 0x39
out val, lv
call impulse
call second

load val, 0x35
out val, lv
call impulse
call second

load val, 0x33
out val, lv
call impulse
call second

load val, 0x31
out val, lv
call impulse
call second

inf: jump inf

second:
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

impulse:
or one, rs
out one, lc
load one, 1
load one, one
or zero, rs
out zero, lc
load zero, 0
ret