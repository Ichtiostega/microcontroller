#ifndef __Time_H__
#define __Time_H__

#include "LPC17xx.h"

void init_sys_tick(void);

void SysTick_Handler(void);

void sleep_us(uint32_t us);

void sleep_ms(uint32_t ms);

#endif
