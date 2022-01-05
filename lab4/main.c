#include "Board_LED.h"                  // ::Board Support:LED
#include "Board_Joystick.h"             // ::Board Support:Joystick
#include "LPC17xx.h"
#include "Open1768_LCD.h"
#include "LCD_ILI9325.h"
#include "asciiLib.h"
#include "TP_Open1768.h"

#include "stdio.h"

uint8_t char_buf[16];
uint8_t padding = 2;

volatile uint32_t msTicks = 0;                              /* Variable to store millisecond ticks */

void delay(uint32_t ms) {
	uint32_t now = msTicks;
	while(msTicks < now + ms);
}
  
void initialize()
{
	SysTick_Config(SystemCoreClock / 1000);
	LED_Initialize();
	lcdConfiguration();
	init_ILI9325();
	
	LPC_UART0->LCR = 1 | (1<<1) | (1<<2) | (1<<7);
	LPC_UART0->DLL = 10;
	LPC_UART0->DLM = 0;
	LPC_UART0->FDR = 5 | (14<<4);
	LPC_UART0->LCR ^= (1<<7);
	LPC_PINCON->PINSEL0 = (1<<4) | (1<<6);
	
	LPC_PINCON->PINSEL4 = (1<<20);
	LPC_SC->EXTMODE = 1;
	LPC_SC->EXTPOLAR = 1;
	LPC_SC->EXTINT = 1;
	NVIC_EnableIRQ(EINT0_IRQn);
	
	LPC_GPIOINT->IO0IntEnF = (1<<19);
	NVIC_EnableIRQ(EINT3_IRQn);
}

void print_uart(char * str)
{
	char * ptr = str;
	while(*ptr != '\0')
	{
		if((LPC_UART0->LSR & (1<<5)) == (1<<5))
		{
			LPC_UART0->THR = *ptr;
			ptr++;
		}
	}
}

void print_device_id()
{
	uint16_t device_id = lcdReadReg(OSCIL_ON);
	char buffer[16];
	sprintf(buffer, " 0x%x", device_id);
	
	print_uart(buffer);
}

void fill_bg(uint16_t color)
{
	lcdSetCursor(0,0);
	for(int i=0; i<240*320; i++)
		lcdWriteReg(DATA_RAM, color);
}

void print_char(uint16_t x, uint16_t y, unsigned char c, uint16_t color)
{
	GetASCIICode(0, char_buf, c);
	for(int j=0; j<16; j++)
	{
		for(int i=0; i<8; i++)
		{
			if((char_buf[j] & (1<<i)) > 0)
			{
				lcdSetCursor(x+8-i,y+j);
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
		print_char(x+i*8+i*padding, y, *ptr, color);
		i++;
		ptr++;
	}
}

void print_coords()
{
	int x, y;
	touchpanelGetXY(&x, &y);
	char buf[15];
	sprintf(buf, "(%d, %d)\r\n", x, y);
	print_uart(buf);
}

void SysTick_Handler(void) {                                /* SysTick interrupt Handler. */
  msTicks++;                                                /* See startup file startup_LPC17xx.s for SysTick vector */ 
}

void EINT0_IRQHandler(void) {
	print_device_id();
	LPC_SC->EXTINT = 1;
}

void EINT3_IRQHandler(void) {
	print_uart("ASDF ");
	LPC_GPIOINT->IO0IntClr = (1<<19);
}

uint32_t i = 1;

void TIMER0_IRQHandler(void) {
	LPC_TIM0->IR = 1;
	
	lcdSetCursor(0,0);
	for(int i=0; i<21*240; i++)
		lcdWriteReg(DATA_RAM, LCDBlack);
	
	char buf[15];
	sprintf(buf, "%d", i);
	print_str(5, 5, buf, LCDGreen);
	i++;
}

int main(int argc, char ** argv)
{
	initialize();
	fill_bg(LCDBlack);
	
	// print_device_id();
	// print_char(5,5,'a', LCDGreen);
	// print_str(5, 23, "Ala ma kota ", LCDGreen);
	// touchpanelInit();
	
	LPC_TIM0->PR = 0;
	LPC_TIM0->MR0 = 12500000;
	LPC_TIM0->MCR = (1 << 1) | (1 << 0);
	LPC_TIM0->TCR = 1;
	NVIC_EnableIRQ(TIMER0_IRQn);
	
	while(1)
	{
		//print_coords();
	}
}
