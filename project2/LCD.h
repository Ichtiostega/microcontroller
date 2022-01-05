#ifndef __LCD_H__
#define __LCD_H__

#include "LPC17xx.h"
#include "LCD_ILI9325.h"
#include "Open1768_LCD.h"

void init_lcd(void);

void fill_bg(uint16_t color);

void print_char(uint16_t x, uint16_t y, unsigned char s, uint16_t color);

void print_str(uint16_t x, uint16_t y, char * str, uint16_t color);

void print_temp(uint16_t temp, uint16_t color, uint16_t bg_color);

#endif
