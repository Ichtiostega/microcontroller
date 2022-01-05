#include "Time.h"

volatile uint32_t msTicks = 0;

void init_sys_tick(void)
{
	SysTick_Config(SystemCoreClock / 1000000); // Sys Tick in ms
}

void SysTick_Handler(void) 
{
  msTicks++;
}

void sleep_us(uint32_t us)
{
	uint32_t now = msTicks;
	while(msTicks < now + us);
}

void sleep_ms(uint32_t ms) 
{
	sleep_us(ms * 1000);
}
