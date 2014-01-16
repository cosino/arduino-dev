#include <LED.h>

/*
 * Objects
 */

LED LED13(13);			/* The only LED we can blink! */

/*
 * Setup
 */

void setup()
{
	delay(500);
	Serial.begin(115200);

	delay(500);

	Serial.println("Blink testing program - ver. 1.00");
	Serial.println("Cosino Mega 2560 extension");
	Serial.println("Rodolfo Giometti <giometti@enneenne.com>");
	delay(500);
}

/*
 * Loop
 */

void loop()
{
	LED13.blink(300, 4);
	delay(500);
	LED13.blink(300, 2);
}
