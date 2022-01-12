#include "1_Wire.h"
#include "Time.h"

#define LOW (LPC_GPIO0->FIODIR = LPC_GPIO0->FIODIR | (1<<15))
#define HIGH (LPC_GPIO0->FIODIR = LPC_GPIO0->FIODIR ^ (1<<15))

void send0(void)
{
	LOW;
	sleep_us(65);
	HIGH;
	sleep_us(61);
}

void send1(void)
{
	LOW;
	sleep_us(10);
	HIGH;
	sleep_us(61);
}

void init_gpio(void)
{
	LPC_GPIO0->FIOCLR = (1<<15);
}

void reset(void)
{
	LOW;
	sleep_us(480);
}

void presence(void)
{
	HIGH;
	sleep_us(480);
}
	
void skip_rom(void)
{
	send0();
	send0();
	send1();
	send1();
	send0();
	send0();
	send1();
	send1();
}

void convert_t(void)
{
	send0();
	send0();
	send1();
	send0();
	send0();
	send0();
	send1();
	send0();
}

void read_scratchpad(void)
{
	send0();
	send1();
	send1();
	send1();
	send1();
	send1();
	send0();
	send1();
}

void read_bit(uint16_t *res, uint8_t pos)
{
	LOW;
	sleep_us(2);
	HIGH;
	sleep_us(11);
	uint16_t tmp = (LPC_GPIO0->FIOPIN & (1<<15));
	*res = *res | ((tmp>>15) << pos);
	sleep_us(48);
}

uint16_t read_temp(void)
{
	reset();
	presence();
	skip_rom();
	sleep_us(1);
	convert_t();
	sleep_ms(750);
	
	reset();
	presence();
	skip_rom();
	sleep_us(1);
	read_scratchpad();
	
	uint16_t res = 0;
	for (uint8_t i=0; i < 16; ++i)
	{
		read_bit(&res, i);
	}
	return res;
}
