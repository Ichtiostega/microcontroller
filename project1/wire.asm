.cseg
measure_temp:
	call reset
	call presence
	call skip_rom
	call delay_1u
	call convert_t
	load delay_counter, 200
	call delay_m
	load delay_counter, 200
	call delay_m
	load delay_counter, 200
	call delay_m
	load delay_counter, 150
	call delay_m

	call reset
	call presence
	call skip_rom
	call delay_1u
	call read_scratchpad

	call read_temperature
	ret

reset:
	load tmp, 1
	out tmp, gpio_B_dir
	load tmp, 0
	out tmp, gpio_B
	load delay_counter, 240
	call delay_u
	load delay_counter, 240
	call delay_u
	ret

presence:
	load tmp, 0
	out tmp, gpio_B_dir
	load delay_counter, 60
	call delay_u
	in tmp, gpio_B
	load delay_counter, 240
	call delay_u
	ret

send_0:
	load tmp, 1
	out tmp, gpio_B_dir
	load tmp, 0
	out tmp, gpio_B
	load delay_counter, 60
	call delay_u
	load tmp, 0
	out tmp, gpio_B_dir
	call delay_1u
	ret

send_1:
	load tmp, 1
	out tmp, gpio_B_dir
	load tmp, 0
	out tmp, gpio_B
	load delay_counter, 10
	call delay_u
	load tmp, 0
	out tmp, gpio_B_dir
	load delay_counter, 50
	call delay_u
	call delay_1u
	ret

skip_rom:
	call send_1
	call send_1
	call send_0
	call send_0
	call send_1
	call send_1
	call send_0
	call send_0
	ret

convert_t:
	call send_0
	call send_1
	call send_0
	call send_0
	call send_0
	call send_1
	call send_0
	call send_0
	ret

read_scratchpad:
	call send_1
	call send_0
	call send_1
	call send_1
	call send_1
	call send_1
	call send_1
	call send_0
	ret

read_one_temperature_bit:
	load tmp, 1
	out tmp, gpio_B_dir
	load tmp, 0
	out tmp, gpio_B
	load delay_counter, 1
	call delay_u
	load tmp, 0
	out tmp, gpio_B_dir
	load delay_counter, 5
	call delay_u
	in temp_bit, gpio_B
	load delay_counter, 55
	call delay_u
	ret

read_temperature_lsb:
	load temp_lsb, 0
	load counter, 0
loop_read_lsb: 
	call read_one_temperature_bit
	test temp_bit, 1
	jump z, continue_lsb
	load tmp, counter
shift_loop_lsb:
	comp tmp, 0
	jump z, continue_lsb
	sl0 temp_bit
	sub tmp, 1
	jump shift_loop_lsb
continue_lsb:
	or temp_lsb, temp_bit
	add counter, 1
	comp counter, 8
	jump nz, loop_read_lsb
	ret

read_temperature_msb:
	load temp_msb, 0
	load counter, 0
loop_read_msb: 
	call read_one_temperature_bit
	test temp_bit, 1
	jump z, continue_msb
	load tmp, counter
shift_loop_msb:
	comp tmp, 0
	jump z, continue_msb
	sl0 temp_bit
	sub tmp, 1
	jump shift_loop_msb
continue_msb:
	or temp_msb, temp_bit
	add counter, 1
	comp counter, 8
	jump nz, loop_read_msb
	ret

read_temperature:
	call read_temperature_lsb
	call read_temperature_msb
	ret