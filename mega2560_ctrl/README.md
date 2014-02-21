Mega 2560 control terminal
==========================

Simple control terminal implementation for Mega 2560 based system such
as Cosino with Mega 2560 extension (http://www.cosino.it) or Arduino
Mega 2560.

Installation
------------

Just compile the source with "make" command (or by using the Arduino
suite), then upload the HEX file into Mega 2560 CPU (for Cosino users
see http://www.cosino.it/cosino-documentation/extensions/mega-2560.html).

Note: All my tests run under Ubuntu (a GNU/Linux system) but you can use
this tool with every OS who can communicate through a serial port!

Functioning
-----------

Theory of operation is quite simple, the user provides a command and the
system will answer with a string as the following:

* 'ok\n': for success, or

* 'ko\n': in case of error.

All lines into answering messages are separated by '\r' chars.

Quick&dirty trick to get access to the this tool from bash is:

    $ stty -F /dev/ttyS3 '406:0:18b2:8a30:3:1c:7f:8:4:2:64:0:11:13:1a:0:12:f:17:16:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0'
    stty: /dev/ttyS3: unable to perform all requested operations
    $ cat /dev/ttyS3 &
    [1] 2373

Note: On Cosino with Mega 2560 extension the Mega 2560 CPU is
connected to the serial port /dev/ttyS3, so you should change this
name accordingly to your system configuration.

Now enter the "help" command to get a list of available commands:

    $ echo 'h' > /dev/ttyS3 
    root@cosino:~# h
    Mega 2560 control ternimal - v. 1.0.0
    commands are:
    e <status>		: set echo mode on(1)/off(0)
    w p <pin> <freq>	: set PWM <pin> ro <freq>
    r A			: read all analog pins
    r a <pin>		: get analog <pin> status
    w a <pin> <value>	: set analog <pin> to <value>
    r D			: read all digital pins
    r d <pin>		: get digital <pin> status
    w d <pin> <value>	: set digital <pin> to <value>
    ok

So, for instance, to set GPIO 52 to 1 you can use command:

    echo 'w d 52 1' > /dev/ttyS3 
    $ w d 52 1
    ok

Note that this trick doesn't manage message handshaking with the
control terminal... so you cannot send multiple commands at time (you
must wait for 'ok\n' or 'ko\n' sequence before issuing a new commnd)!

Usage examples: Screen & PHP
----------------------------

If you don't want use stty and other bash tools you may wish using
"screen" from a terminal for a quick access without other settings
as follow:

    $ screen /dev/ttyS3 115200

Now you are connected with the control terminal! Just hit the
command "h" followed by the ENTER key to get the help screen shoot
as above:

    h
    Mega 2560 control ternimal - v. 1.0.0
    commands are:
    e <status>              : set echo mode on(1)/off(0)
    w p <pin> <freq>        : set PWM <pin> ro <freq>
    r A                     : read all analog pins
    r a <pin>               : get analog <pin> status
    w a <pin> <value>       : set analog <pin> to <value>
    r D                     : read all digital pins
    r d <pin>               : get digital <pin> status
    w d <pin> <value>       : set digital <pin> to <value>
    ok

Again, to set GPIO 52 to 1 you can use command:

    w d 52 1
    ok

On the other hand if you wish communicate with this tool from a program
you can use a function as the following (PHP code):

    function mega2560_cmd($f, $cmd)
    {
        fwrite($f, $cmd . chr(13));
      
        $ans = "";
        while (1) {
            $data = trim(fgets($f, 128), "\n\r");
            if ($data == "ok" || $data == "ko")
                break;
     
            $ans .= $data . "\n";
        }
     
        return $ans;
    }

So, the well-known command to set GPIO 52 to 1 can be called by using:

    $out = mega2560_cmd($fp, "w d 52 1");

In the "out" variable you can find the control terminal answer.

[Note: see directory "php" for a complete WEB example]

Enjoy! :)
