.cseg
init_lcd:
	;reset
	load tmp, 0x38

	out tmp, lcd_lv
	call lcd_impulse

	out tmp, lcd_lv
	call lcd_impulse

	out tmp, lcd_lv
	call lcd_impulse

	out tmp, lcd_lv
	call lcd_impulse

	;entry mode
	load tmp, 0x6
	out tmp, lcd_lv
	call lcd_impulse

	;display on
	load tmp, 0xe
	out tmp, lcd_lv
	call lcd_impulse

clear_lcd:
	load tmp, 0x1
	out tmp, lcd_lv
	call lcd_impulse
	ret

set_cursor:
	load tmp, 0xcc
	out tmp, lcd_lv
	call lcd_impulse
	ret

set_rs:
	load rs, 0b10
	out rs, lcd_lc
	ret

unset_rs:
	load rs, 0
	out rs, lcd_lc
	ret

write_val_to_lcd:
	out val, lcd_lv
	call lcd_impulse
	ret

lcd_impulse:
	or one, rs
	out one, lcd_lc
	load one, 1
	load one, one
	or zero, rs
	out zero, lcd_lc
	load zero, 0
	load delay_counter, 5
	call delay_m
	ret