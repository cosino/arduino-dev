/* 
 * Mega 2560 control ternimal - v. 1.0.0
 * Copyright (C) 2013   Rodolfo Giometti <giometti@linux.com>
 * All rights reserved
 *
 * Redistribution and use in source and binary forms are permitted
 * provided that the above copyright notice and this paragraph are
 * duplicated in all such forms and that any documentation,
 * advertising materials, and other materials related to such
 * distribution and use acknowledge that the software was developed
 * by the <organization>.  The name of the
 * <organization> may not be used to endorse or promote products derived
 * from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 * 
 * Based on a previous job by Thomas Ouellet Fredericks & Alexandre Quessy 
 * 
 */

#include <SimpleMessageSystem.h>
#include <PWM.h>
#include <LED.h>

#define DIGITAL_COUNT	70
#define ANALOG_COUNT	16

/*
 * Define the following to disable led blinking during user commands inputs
 * for best commands execution perdormance
 */
#undef DISABLE_BLINK	1

/*
 * Define the following to disable "help" command. It saves space...
 */
#undef DISABLE_HELP	1

/*
 * Setup
 */

void setup()
{
	Serial.begin(115200);

	/* initialize all timers except for 0, to save time keeping functions */
	InitTimersSafe();
}

/*
 * Functions
 */

#ifndef DISABLE_HELP
void help()
{
	Serial.println("Mega 2560 control ternimal - v. 1.0.0");
	Serial.println("commands are:");
	Serial.println("e <status>		: set echo mode on(1)/off(0)");
	Serial.println("w p <pin> <freq>	: set PWM <pin> ro <freq>");
	Serial.println("r A			: read all analog pins");
	Serial.println("r a <pin>		: get analog <pin> status");
	Serial.println("w a <pin> <value>	: set analog <pin> to <value>");
	Serial.println("r D			: read all digital pins");
	Serial.println("r d <pin>		: get digital <pin> status");
	Serial.println("w d <pin> <value>	: set digital <pin> to <value>");
}
#endif /* DISABLE_HELP */

int read_cmd()
{
	int pin;

	switch (messageGetChar()) {
	case 'D':
		for (int i = 2; i < DIGITAL_COUNT; i++) {
			Serial.print(i);
			Serial.print("=");
			Serial.println(digitalRead(i));
		}

		break;

	case 'd':
		pin = messageGetInt();

		Serial.print(pin);
		Serial.print("=");
		Serial.println(digitalRead(pin));

		break;

	case 'A':
		for (int i = 0; i < ANALOG_COUNT; i++) {
			Serial.print(i);
			Serial.print("=");
			Serial.println(analogRead(i));
		}

		break;

	case 'a':
		pin = messageGetInt();

		Serial.print(pin);
		Serial.print("=");
		Serial.println(analogRead(pin));

		break;

	default:
		return -1;
	}

	return 0;
}

int write_cmd()
{
	int pin;
	int state;
	int freq;
	bool success;

	switch (messageGetChar()) {
	case 'p':
		pin = messageGetInt();
		freq = messageGetInt();

		success = SetPinFrequencySafe(pin, freq);
		if (!success)
			return -1;
		pwmWrite(pin, 128);

		break;

	case 'a':
		pin = messageGetInt();
		state = messageGetInt();

		pinMode(pin, OUTPUT);
		analogWrite(pin, state);

		break;

	case 'd':
		pin = messageGetInt();
		state = messageGetInt();

		pinMode(pin, OUTPUT);
		digitalWrite(pin, state);

		break;

	default:
		return -1;
	}

	return 0;
}

/*
 * Loop
 */

LED LED13(13);			/* The only LED we can blink! */

void loop()
{
	int l;
	int v;
	int ret;

	l = messageBuild();
	if (l > 0) {
		switch (messageGetChar()) {
#ifndef DISABLE_HELP
		case 'h':
			help();
			ret = 0;
			break;
#endif /* DISABLE_HELP */

		case 'e':
			setEcho(messageGetInt());
			ret = 0;
			break;

		case 'r':
			ret = read_cmd();
			break;

		case 'w':
			ret = write_cmd();
			break;

		default:
			ret = -1;;
		}
		Serial.println(ret == 0 ? "ok" : "ko" "\n");

#ifndef DISABLE_BLINK
		LED13.blink(10, 1);
#endif /* DISABLE_BLINK */
	}
}
