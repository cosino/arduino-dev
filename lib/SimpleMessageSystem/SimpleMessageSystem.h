/* 

Made by Thomas Ouellet Fredericks
Comments and questions: tof@danslchamp.org
Use as you like.
Orignal version: 27th of June 2006.
Approximative library size: 500 bytes.


SimpleMessageSystem is a library for Arduino. It facilitates communication with terminals 
or message based programs like Pure Data or Max/Msp.

*/


#ifndef SimpleMessageSystem_h
#define SimpleMessageSystem_h

/*
 * Enable/disable echo of user input
 */
void setEcho(bool status);

	// If the message has been terminated, returns the size of the message including spaces.
	// WARNING: if you make a call to messageBuild() it will discard any previous message!
	int messageBuild();
	
	// If a word is available, returns it as a char. If no word is available it will return 0.
	// WARNING: if you send something like "foo", it will return 'f' and discard "oo".
	char messageGetChar();
	
	// If a word is available, returns it as an integer. If no word is available it will return 0.
	 int messageGetInt();
#endif
