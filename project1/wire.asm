.cseg
measure_temp:
CALL reset
CALL presence
CALL skip_rom
CALL delay_1u

CALL convert_t
LOAD delay_counter, 200
CALL delay_m
LOAD delay_counter, 200
CALL delay_m
LOAD delay_counter, 200
CALL delay_m
LOAD delay_counter, 150
CALL delay_m

CALL reset
CALL presence
CALL skip_rom
CALL delay_1u

CALL read_scratchpad

CALL read_temperature
RET

reset:
LOAD tmp, 1
OUT tmp, gpio_B_dir
LOAD tmp, 0
OUT tmp, gpio_B
LOAD delay_counter, 240
CALL delay_u
LOAD delay_counter, 240
CALL delay_u
RET

presence:
LOAD tmp, 0
OUT tmp, gpio_B_dir
LOAD delay_counter, 60
CALL delay_u
IN tmp, gpio_B
LOAD delay_counter, 240
CALL delay_u
RET

send_0:
LOAD tmp, 1
OUT tmp, gpio_B_dir
LOAD tmp, 0
OUT tmp, gpio_B
LOAD delay_counter, 60
CALL delay_u
LOAD tmp, 0
OUT tmp, gpio_B_dir
CALL delay_1u
RET

send_1:
LOAD tmp, 1
OUT tmp, gpio_B_dir
LOAD tmp, 0
OUT tmp, gpio_B
LOAD delay_counter, 10
CALL delay_u
LOAD tmp, 0
OUT tmp, gpio_B_dir
LOAD delay_counter, 50
CALL delay_u
CALL delay_1u
RET

skip_rom:
CALL send_1
CALL send_1
CALL send_0
CALL send_0
CALL send_1
CALL send_1
CALL send_0
CALL send_0
RET

convert_t:
CALL send_0
CALL send_1
CALL send_0
CALL send_0
CALL send_0
CALL send_1
CALL send_0
CALL send_0
RET

read_scratchpad:
CALL send_1
CALL send_0
CALL send_1
CALL send_1
CALL send_1
CALL send_1
CALL send_1
CALL send_0
RET

read_one_bit_from_thermometer:
LOAD tmp, 1
OUT tmp, gpio_B_dir
LOAD tmp, 0
OUT tmp, gpio_B
LOAD delay_counter, 1
CALL delay_u
LOAD tmp, 0
OUT tmp, gpio_B_dir
LOAD delay_counter, 5
CALL delay_u
IN temp_bit, gpio_B
LOAD delay_counter, 55
CALL delay_u
RET

read_from_thermometer_LSB:
LOAD temp_LSB, 0
LOAD counter, 0
loop_read_LSB: 
CALL read_one_bit_from_thermometer
TEST temp_bit, 1
JUMP Z, continue_LSB
LOAD tmp, counter
shift_loop_LSB:
COMP tmp, 0
JUMP Z, continue_LSB
SL0 temp_bit
SUB tmp, 1
JUMP shift_loop_LSB
continue_LSB:
OR temp_LSB, temp_bit
ADD counter, 1
COMP counter, 8
JUMP NZ, loop_read_LSB
RET

read_from_thermometer_MSB:
LOAD temp_MSB, 0
LOAD counter, 0
loop_read_MSB: 
CALL read_one_bit_from_thermometer
TEST temp_bit, 1
JUMP Z, continue_MSB
LOAD tmp, counter
shift_loop_MSB:
COMP tmp, 0
JUMP Z, continue_MSB
SL0 temp_bit
SUB tmp, 1
JUMP shift_loop_MSB
continue_MSB:
OR temp_MSB, temp_bit
ADD counter, 1
COMP counter, 8
JUMP NZ, loop_read_MSB
RET

read_temperature:
CALL read_from_thermometer_LSB
CALL read_from_thermometer_MSB
RET