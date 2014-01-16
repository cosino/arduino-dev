Arduino development tools
=========================

The Arduino development tools is a simple command line suite to build
your Arduino programs. It can be a replacement of the standard Arduino
suite for developers whose prefere a command line interface instead of
a graphical one.


Prerequisites
-------------

Let's install needed programs first!

    # aptitude install arduino scons make git-core

The arduino package holds all needed software to compile your programs
(it holds the standard GUI too!), while scons and make are the command
line tools whose will help us in doing the trick.


Adding a simple program
-----------------------

Adding a new project is quite easy, just take a look at the blink
directory which holds a simple example.

    # cd blink
    # ls
    Makefile  blink.pde

As you can see you have only two files: Makefile and blink.pde. The
former is just the makefile of our project while the latter holds our
Mega 2560 application (note that for all projects the PDE file has the
same name of the holding directory. This is mandatory!). Well, let's
see blink.pde:

    # cat blink.pde
    #include <LED.h>

    /*
     * Objects
     */

    LED LED13(13);                  /* The only LED we can blink! */

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

As you can see there are no changes from the standard Arduino program,
so you can write your application normally and then build it by using
the command line! In fact you just need the command make to build your
application:

    # make
    scons -f ../SConstruct ARDUINO_BOARD=mega2560 \
                    EXTRA_LIB=../lib/ -Q
    maximum size for hex file: 258048 bytes
    scons: building associated VariantDir targets: build
    fnProcessing(["build/blink.cpp"], ["build/blink.pde"])
    avr-g++ -o build/blink.o -c -ffunction-sections -fdata-sections -fno-exceptions -
    funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -Os -mmcu=atmega2
    560 -DARDUINO=22 -DF_CPU=16000000L -I. -Ibuild/core -Ibuild/variants -Ibuild/lib_
    00/LED build/blink.cpp
    ...
    avr-gcc -mmcu=atmega2560 -Os -Wl,--gc-sections -o blink.elf build/blink.o build/l
    ib_00/LED/LED.o build/core/wiring.o build/core/wiring_analog.o build/core/wiring_
    pulse.o build/core/wiring_shift.o build/core/WInterrupts.o build/core/wiring_digi
    tal.o build/core/Print.o build/core/Stream.o build/core/HID.o build/core/Hardware
    Serial.o build/core/CDC.o build/core/Tone.o build/core/WString.o build/core/new.o
     build/core/IPAddress.o build/core/USBCore.o build/core/WMath.o -lm
    avr-objcopy -O ihex -R .eeprom blink.elf blink.hex
    avr-size --target=ihex blink.hex
       text    data     bss     dec     hex filename
          0    5914       0    5914    171a blink.hex

That's all!
