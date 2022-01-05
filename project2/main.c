#include "LCD.h"
#include "Time.h"

#include "LPC17xx.h"

#include <stdio.h>

void init()
{
	init_sys_tick();
	init_lcd();
}

int main(int argc, char ** argv)
{
	init();
	
	fill_bg(LCDBlack);
	
	uint8_t i = 0;
	while(1) {
		sleep_ms(1000);
		i++;
		print_temp(i, LCDGreen, LCDBlack);
	}
}
