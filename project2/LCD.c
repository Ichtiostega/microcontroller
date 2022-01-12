#include "LCD.h"

#include "asciiLib.h"

#include <stdio.h>
#include <string.h>

uint8_t padding = 2;

void init_lcd(void) {
	lcdConfiguration();
	init_ILI9325();
}

void fill_bg(uint16_t color)
{
	lcdSetCursor(0,0);
	for(int i=0; i < 240 * 320; i++)
		lcdWriteReg(DATA_RAM, color);
}

void print_char(uint16_t x, uint16_t y, unsigned char c, uint16_t color)
{
	uint8_t char_buf[16];
	GetASCIICode(0, char_buf, c);
	for(int j=0; j<16; j++)
	{
		for(int i=0; i<8; i++)
		{
			if((char_buf[j] & (1<<i)) > 0)
			{
				lcdSetCursor(x + 8 - i, y + j);
				lcdWriteReg(DATA_RAM, color);
			}
		}
	}
}

void print_str(uint16_t x, uint16_t y, char * str, uint16_t color)
{
	int i = 0;
	char * ptr = str;
	while(*ptr != '\0')
	{
		print_char(x + i * 8 + i * padding, y, *ptr, color);
		i++;
		ptr++;
	}
}

uint16_t convert_temp_dec(uint16_t temp)
{
	temp = (temp>>4);
	return temp & 127;
}

uint16_t convert_temp_float(uint16_t temp)
{
	return temp & 15;
}

char get_sign(uint16_t temp)
{
	if((temp & (1<<16)) > 0)
		return '-';
	return ' ';
}

void print_temp(uint16_t temp, uint16_t color, uint16_t bg_color) 
{
	char str_buf[16];
	sprintf(str_buf, "%c%d.%d C", 
		get_sign(temp),
		convert_temp_dec(temp), 
		convert_temp_float(temp)
	);
	
	lcdSetCursor(0, 5);
	for(int i=0; i < 16 * 240; i++)
		lcdWriteReg(DATA_RAM, bg_color);

	print_str(5, 5, str_buf, color);
}
