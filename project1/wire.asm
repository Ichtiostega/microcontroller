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
  load delay_counter, 180
	call delay_u
	ret

send_0:
	load tmp, 1
	out tmp, gpio_B_dir
	load tmp, 0
	out tmp, gpio_B
	load delay_counter, 65
	call delay_u
	load tmp, 0
	out tmp, gpio_B_dir
	load delay_counter, 5
	call delay_u
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
	load delay_counter, 60
	call delay_u
	call delay_1u
	ret

skip_rom:
	call send_0
	call send_0
	call send_1
	call send_1
	call send_0
	call send_0
	call send_1
	call send_1
	ret

convert_t:
	call send_0
	call send_0
  call send_1
  call send_0
	call send_0
	call send_0
	call send_1
	call send_0
	ret

read_scratchpad:
	call send_0
	call send_1
	call send_1
	call send_1
	call send_1
	call send_1
	call send_0
	call send_1
	ret

;1011 1110 1000 0000

read_one_temperature_bit:
	load tmp, 1
	out tmp, gpio_B_dir
	load tmp, 0
	out tmp, gpio_B
	load delay_counter, 2
	call delay_u
	load tmp, 0
	out tmp, gpio_B_dir
	load delay_counter, 11
	call delay_u
	in temp_bit, gpio_B
	and temp_bit, 1
	load delay_counter, 48
	call delay_u
	ret

rtl:
	load temp_lsb, 0
	load counter, 8
loop_rtl:
	call read_one_temperature_bit
	or temp_lsb, temp_bit
	rr temp_lsb
	sub counter, 1
	jump nz, loop_rtl
	ret

rtm:
	load temp_msb, 0
	load counter, 8
loop_rtm:
	call read_one_temperature_bit
	or temp_msb, temp_bit
	rr temp_msb
	sub counter, 1
	jump nz, loop_rtm
	ret


read_temperature:
	call rtl
	call rtm
	ret