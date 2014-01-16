/* 

See SimpleMessageSystem.h for more information.

*/


// the size of the incomming message buffer (Arduino 0004 has a serial in buffer of 64 bytes)
#define MESSAGE_BUFFER_SIZE 64
#define MESSAGE_BUFFER_LAST_ELEMENT 63

//ADDED FOR COMPATIBILITY WITH WIRING
extern "C" {
  #include <stdlib.h>
}
//ADDED END

#include "Arduino.h"
#include "HardwareSerial.h" //ADDED FOR COMPATIBILITY WITH WIRING
#include "SimpleMessageSystem.h"




// local variables
char messageState = 0;
char messageBufferSerialByte;
int messageBufferIndex = 0;
char messageBuffer[MESSAGE_BUFFER_SIZE];
char *messageBufferLast;
char *messageBufferWord;

bool messageEcho = 1;	/* Echo is enabled by default */



// local function prototype
char messageNext();
void messageSpacer();


// INPUT MESSAGES CODE

void setEcho(bool status)
{
	messageEcho = status;
}

int messageGetInt() {

    if (messageNext()) return atoi(messageBufferWord);

  return 0;

}

char messageNext() {

  char * temppointer= NULL;
  switch (messageState) {
  case 0:
    return 0;
  case 1:
    temppointer = messageBuffer;
    messageState = 2;
  default:
    messageBufferWord = strtok_r(temppointer," ",&messageBufferLast);
    if (messageBufferWord != NULL) return 1;
  }
  return 0;
}

char messageGetChar() {

 
    if (messageNext()) return messageBufferWord[0];
  return 0;

}

int messageBuild() {

  int size = 0;
  messageState = 0;
  while (Serial.available() > 0) {
    messageBufferSerialByte = Serial.read();

    switch (messageBufferSerialByte) {
    case 10:
    case 13:
      size = messageBufferIndex;
      messageBuffer[messageBufferIndex]=0;
      messageBufferIndex=0;
      messageState = 1;

	if (messageEcho)
		Serial.print("\n\r");
      break;
    default:
      messageBuffer[messageBufferIndex]=messageBufferSerialByte;
      messageBufferIndex = messageBufferIndex + 1;

	if (messageEcho)
		Serial.print(messageBufferSerialByte);
    }
    if (messageBufferIndex >= MESSAGE_BUFFER_LAST_ELEMENT) messageBufferIndex=0;
  }
  
  
  
  return size;
}
