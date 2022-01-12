#include "LCD.h"
#include "Time.h"
#include "1_Wire.h"

#include "LPC17xx.h"

#include <stdio.h>

void init()
{
	init_gpio();
	init_sys_tick();
	init_lcd();
}

int main(int argc, char ** argv)
{
	init();
	
	fill_bg(LCDBlack);
	
	while(1) {
		uint16_t temp = read_temp();
		sleep_ms(1000/60);
		print_temp(temp, LCDGreen, LCDBlack);
	}
}
