#include "Board_LED.h"                  // ::Board Support:LED
#include "Board_Joystick.h"             // ::Board Support:Joystick

#include "LPC17xx.h"
  
volatile uint32_t msTicks = 0;                              /* Variable to store millisecond ticks */
  
void SysTick_Handler(void)  {                               /* SysTick interrupt Handler. */
  msTicks++;                                                /* See startup file startup_LPC17xx.s for SysTick vector */ 
}

void delay(uint32_t ms) {
	uint32_t now = msTicks;
	while(msTicks < now + ms);
}

int main(int argc, char ** argv)
{
	SysTick_Config(SystemCoreClock / 1000);
	LED_Initialize();
	Joystick_Initialize();
	uint8_t i = 0;
	uint32_t prev_state = Joystick_GetState();
	while(1)
	{
		delay(10);
		uint32_t state = Joystick_GetState();
		if(state == prev_state)
			continue;
		prev_state = state;
		if(state == JOYSTICK_DOWN)
			i -= 10;
		if(state == JOYSTICK_UP)
			i += 10;
		if(state == JOYSTICK_LEFT)
			i--;
		if(state == JOYSTICK_RIGHT)
			i++;
		LED_SetOut(i);
	}
	
	/*
	LPC_UART0->LCR = 1 | (1<<1) | (1<<2) | (1<<7);
	LPC_UART0->DLL = 10;
	LPC_UART0->DLM = 0;
	LPC_UART0->FDR = 5 | (14<<4);
	LPC_UART0->LCR ^= (1<<7);
	LPC_PINCON->PINSEL0 = (1<<4) | (1<<6);
	
	char * str = "Ala ma kota, a kot ma Ale ";
	char * ptr = str;
	while(*ptr != '\0')
	{
		if((LPC_UART0->LSR & (1<<5)) == (1<<5))
		{
			LPC_UART0->THR = *ptr;
			ptr++;
		}
	}
	while(1)
	{
		if((LPC_UART0->LSR & 1 ) == 1)
			LPC_UART0->THR = LPC_UART0->RBR + 1;
	}
	
	*/
	for(;;)
	{
		LED_SetOut(5+16+64);
		delay(1000);
		LED_SetOut(10+32+128);
		delay(1000);
	}
}
