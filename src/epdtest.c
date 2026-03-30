/*
	File:		epdtest.c

	Contains:	Initial test 

	Version:	1.0

	Copyright:	(c) 2021-2026 by George Kyriazis, all rights reserved.

 */

#include "Config/DEV_Config.h"
#include "e-Paper/EPD_2in7_V2.h"

int 
epdtest(void)
{
    printf("init\n");
    if (DEV_Module_Init()) {
	return -1;
    }
    EPD_2IN7_V2_Init();

    printf("clear\n");
    EPD_2IN7_V2_Clear();
}

int
main(int argc, char **argv)
{
    return epdtest();
}

