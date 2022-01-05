#ifndef __1_WIRE_H__
#define __1_WIRE_H__

#include "LPC17xx.h"

void init_gpio(void);

// 3.3V red, GND black, P0_15
// use bit 15
// manipulate only FIO0DIR
// clear bit 15 only once

#endif
