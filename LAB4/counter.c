/*
 * counter.c
 *
 *  Created on: Oct 1, 2021
 *      Author: jurado-garciaj
 */

#include "altera_avalon_pio_regs.h"
#include "system.h"
#include <stdio.h>
#include <unistd.h>

int convert(alt_u8 c);
int shift_4bits(alt_u8 b);
int clear_MS4B(alt_u8 a);

int main(){
	printf("My counter program!\n");
	alt_u8 count = 0; //up to 0xff
	alt_u16 resultt = 0b0000000000000000;
	alt_u8 sw;
	alt_u16 output = 0b0000000000000000;

while(1){
	//output the count to hex0, hex1
	IOWR_ALTERA_AVALON_PIO_DATA(SEVEN_SEG_PIO_BASE, resultt);

	//output the sw value to hex1, hex2
	IOWR_ALTERA_AVALON_PIO_DATA(SEVEN_SEG_PIO2_BASE, output);

	//read for the switches
	sw = IORD_ALTERA_AVALON_PIO_DATA(SW_PIO_BASE);

	//place-holder value
	alt_u8 x,y;

	if(sw >= 0){
		printf("switch value: %2X,", sw);
		x = shift_4bits(sw); 		//make x equal to sw
		x = convert(x); //convert to 7-seg value
		y = clear_MS4B(sw);
		y = convert(y);
		output = x<<8;
		output = output + y;
		printf("converted switch value %2X, ", output);
	} //end if
	if(count == 0xFF){
		count = 0x00;
	}
				x = shift_4bits(count); 		//make x equal to sw
				x = convert(x); //convert to 7-seg value
				y = clear_MS4B(count);
				y = convert(y);
			resultt = x<<8;
			resultt = resultt + y;
			usleep(600000); //sleep for 3 second
			count++;
}//end while loop
return 0;
}//end main

int shift_4bits(alt_u8 b){
	alt_u8 x = b;
	x = x>>4;
	return x;
}//end function

int clear_MS4B(alt_u8 a){
	alt_u8 x = a;
	x &= 0x0F;
	return x;
}//end function

/*function returning the count value from decimal to hex value */
int convert(alt_u8 c){
		alt_u8 result;
		int LEDarray[] = {0x40,0x79,0x24,0x30,0x19,0x12,0x02,0xD8,0x00,0x18,0x08,0x83,0x46,0xA1,0x06,0x0E};
		    switch(c){
		    case 0:
		       result = (LEDarray[0]);
		        break;
		    case 1:
		    	result = (LEDarray[1]);
		        break;
		    case 2:
		    	result = (LEDarray[2]);
		        break;
		    case 3:
		    	result = (LEDarray[3]);
		        break;
		    case 4:
		        result = LEDarray[4];
		        break;
		    case 5:
		    	result = (LEDarray[5]);
		        break;
		    case 6:
		    	result = (LEDarray[6]);
		        break;
		    case 7:
		    	result = (LEDarray[7]);
		        break;
		    case 8:
		    	result = (LEDarray[8]);
		    	break;
		    case 9:
		    	result = (LEDarray[9]);
		        break;
		    case 10:
		    	result = (LEDarray[10]);
		        break;
		    case 11:
		    	result = (LEDarray[11]);
		        break;
		    case 12:
		    	result = (LEDarray[12]);
		        break;
		    case 13:
		    	result = (LEDarray[13]);
		        break;
		    case 14:
		    	result = (LEDarray[14]);
		        break;
		    case 15:
		    	result = (LEDarray[15]);
		        break;
		    }//end switch statement
		    return result;
}//end function
