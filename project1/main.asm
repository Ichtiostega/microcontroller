.port lcd_lc, 0x31
.port lcd_lv, 0x30
.port gpio_B, 0x21
.port gpio_B_dir, 0x29

.reg s0, zero 
.reg s1, one
.reg s2, rs

.reg s3, val
.reg s4, tmp
.reg s5, char
.reg s6, dec2

.reg s7, temp_lsb
.reg s8, temp_msb
.reg s9, temp_bit

.reg sA, float
.reg sB, bit_counter
.reg sC, delay_counter
.reg sD, delay_reg1u
.reg sE, delay_reg40u
.reg sF, delay_reg1m

load zero, 0
load one, 1

call init_lcd

main:
	call measure_temp

	call unset_rs
	call clear_lcd
	call set_cursor
	call set_rs

	call temp_to_val

	call val_to_dec1_char
	call write_char_to_lcd

	call val_to_dec2_char
	call write_char_to_lcd

	load char, '.'
	call write_char_to_lcd

	call float_to_char
	call write_char_to_lcd

	load char, ' '
	call write_char_to_lcd

	load char, 'C'
	call write_char_to_lcd

	jump main

.incl "time.asm"
.incl "wire.asm"
.incl "lcd.asm"
.incl "conversion.asm"
