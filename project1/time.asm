.cseg
delay_1u: 
	load delay_reg1u, 23
wait_1u: 
	sub delay_reg1u, 1
	jump nz, wait_1u
	load delay_reg1u, delay_reg1u 
	load delay_reg1u, delay_reg1u 
	ret

delay_40u: 
	load delay_reg40u, 38
wait_40u: 
	call delay_1u
	sub delay_reg40u, 1
	jump nz, wait_40u
	ret

delay_1m: 
	load delay_reg1m, 25
wait_1m: 
	call delay_40u
	sub delay_reg1m, 1
	jump nz, wait_1m
	ret

delay_m: 
	call delay_1m
	sub delay_counter, 1
	jump nz, delay_m
	ret

delay_u: 
	call delay_1u
	sub delay_counter, 1
	jump nz, delay_u
	ret