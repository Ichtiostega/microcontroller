.dseg
v1: .db "0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999"
v2: .db "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"

.cseg
val_to_chars:
	load tmp, v1
	add tmp, val
	fetch dec1, tmp
	load tmp, v2
	add tmp, val
	fetch dec2, tmp
	ret

temp_to_val:
	sr0 temp_lsb
	sr0 temp_lsb
	sr0 temp_lsb
	sr0 temp_lsb

	sl0 temp_msb
	sl0 temp_msb
	sl0 temp_msb
	and temp_msb, 0b01111111 ;we have only 7 bits of decimal part, so always 0 at msb

	load val, temp_lsb
	or val, temp_msb
	ret