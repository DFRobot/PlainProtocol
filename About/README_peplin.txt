# Arduino.mk

This is a versioned history of the work done by Martin Oldfield on an Arduino
Makefile. He releases tarballs on his website, so this version might be a bit
easier if you want to track your modifications.

The various released versions (0.3, 0.4, etc) are tagged in this repository.

The original blog post: http://mjo.tc/atelier/2009/02/arduino-cli.html

A blog post on the addition of chipKIT support:
http://christopherpeplin.com/2011/12/chipkit-arduino-makefile/

This Makefile current does *not* support Arduino 1.0. It shouldn't take too long
to update, however - pull requests are welcome!

## chipKIT Support

This version adds support for the Digilent chipKIT Uno32 and Max32, both
Arduino-compatible microcontrollers. To use this Makefile with one of those,
include `chipKIT.mk` instead of `Arduino.mk` at the bottom of your Makefile.

    include /path/to/chipKIT.mk

You can adjust the same variables as described by Martin for `Arduino.mk`, but
point to an MPIDE installation (which includes the chipKIT toolchain) instead of
the Arduino IDE.

There is one important change in the chipKIT Makefile - the path for extra
libraries requires the `ARDUINO_SKETCHBOOK` environment variable. At some point
this will be merged with the Arduino Makefile's approach of looking for
libraries in the IDE's directory.

## Example

To compile the basic blink example sketch, set the `ARDUINO_MAKEFILE_HOME`
variable to point to where you clone this repository and use this for your
Makefile:

    TARGET       = blink
    BOARD_TAG    = mega_pic32

    ARDUINO_PORT = /dev/ttyUSB*

    include $(ARDUINO_MAKEFILE_HOME)/chipKIT.mk
