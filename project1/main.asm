.port lcd_lc, 0x31
.port lcd_lv, 0x30
.port gpio_B, 0x21
.port gpio_B_dir, 0x29

.reg s0, zero 
.reg s1, one
.reg s2, rs

.reg s3, val
.reg s4, tmp
.reg s5, dec1
.reg s6, dec2

.reg s7, temp_lsb
.reg s8, temp_msb
.reg s9, temp_bit

.reg sB, counter
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

	;test conversion
	;load temp_lsb, 0b10100000
	;load temp_msb, 0
	call temp_to_val
	call val_to_chars

	;eg. 12 C
	load val, dec1
	call write_val_to_lcd
	load val, dec2
	call write_val_to_lcd
	load val, 0x20
	call write_val_to_lcd
	load val, 0x43
	call write_val_to_lcd

	jump main

.incl "time.asm"
.incl "wire.asm"
.incl "lcd.asm"
.incl "conversion.asm"
