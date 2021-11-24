.cseg
delay_1u: 
	LOAD delay_reg1u, 23
wait_1u: 
	SUB delay_reg1u, 1
	JUMP NZ, wait_1u
	LOAD delay_reg1u, delay_reg1u 
	LOAD delay_reg1u, delay_reg1u 
	RET

delay_40u: 
	LOAD delay_reg40u, 38
wait_40u: 
	CALL delay_1u
	SUB delay_reg40u, 1
	JUMP NZ, wait_40u
	RET

delay_1m: 
	LOAD delay_reg1m, 25
wait_1m: 
	CALL delay_40u
	SUB delay_reg1m, 1
	JUMP NZ, wait_1m
	RET

delay_m: 
	CALL delay_1m
	SUB delay_counter, 1
	JUMP NZ, delay_m
	RET

delay_u: 
	CALL delay_1u
	SUB delay_counter, 1
	JUMP NZ, delay_u
	RET