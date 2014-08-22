MODBUS RTU slave
================

Simple MODBUS RTU slave implementation for Mega 2560 based system such
as Cosino with Mega 2560 extension (http://www.cosino.it) or Arduino
Mega 2560.

Installation
------------

Just compile the source with "make" command (or by using the Arduino
suite), then upload the HEX file into Mega 2560 CPU (for Cosino users
see http://www.cosino.io/products/oem-computers/cosino-mega-2560).

Note: All my tests run under Ubuntu (a GNU/Linux system) but you can use
this tool with every OS who can communicate through a serial port!

Functioning
-----------

Theory of operation is quite simple, the code implement a silly MODBUS
RTU slave which the Cosino's CPU can talk to by using MODBUS RTU
protocol.

The code implements a slave with the following holding registers:

    Reg	  Function           Action
    0x0000  No Op              Null
    0x0001  Led on GPIO 53     0 = led off     - 1 = led on
    0x0002  Switch on GPIO 52  0 = switch open - 1 = switch close

You can get access to these registers by using the modbus utils
available here:

   https://github.com/cosino/modbus-utils

(or by using an equivalent tool).

The testing system
------------------

In order to test the code you need to put a led at GPIO 53 and a
switch (I just used a cable to connect or not to 5V) at GPIO 52, then
load the code. If everything works well you should see the led turned
on. Also using the modbus-dump utility you should get:

    # ./modbus-dump -d rtu:/dev/ttyS3,115200,8N1 1 1 2
    modbus-dump: reg[1]=1/0x0001
    modbus-dump: reg[2]=0/0x0000

[Note that on Cosino Mega 2560 the Serial0 is connected with Cosino serial
port /dev/ttyS3]

Now if you close the switch (just connect cable on GPIO 52 to 5V) and
rerun the above command you should see that register 0x0001 changes
from value 0x0000 to 0x0001:

    # ./modbus-dump -d rtu:/dev/ttyS3,115200,8N1 1 1 2
    modbus-dump: reg[1]=1/0x0001
    modbus-dump: reg[2]=1/0x0001

To turn off the led just use command:

    # ./modbus-set -d rtu:/dev/ttyS3,115200,8N1 1 1 0

Debugging
---------

If you wish enabling some debugging message on Arduino's Serial1 port you
just need to enable the DEBUG define.

Note also that you can change the Serial0/Serial1 functioning just
redefing the DEBUG_PORT and MODBUS_PORT defines.

Enjoy! :)
