#
# embedXcode
# ----------------------------------
# Embedded Computing on Xcode 4
#
# Copyright © Rei VILO, 2010-2013
# Licence CC = BY NC SA
#


# Parameters
# ----------------------------------
# Xcode takes BOARD_TAG and BOARD_PORT from the .xcconfig file
# For other IDEs than Xcode,

# BOARD_TAG is required
# If not defined, error BOARD_TAG not defined
#
#BOARD_TAG  = mega2560

# BOARD_PORT is optional
# If not defined, BOARD_PORT = /dev/tty.usb* (default)
#
#BOARD_PORT = /dev/tty.usbmodem*

# Xcode takes SKETCHBOOK_DIR from preferences.txt 
# If not defined, each IDE has its own SKETCHBOOK_DIR (default)
# To share the same SKETCHBOOK_DIR along all IDEs, define
# 
#SKETCHBOOK_DIR =

# SERIAL_BAUDRATE for the serial console, 9600 by default
# Uncomment and specify another speed
#
#SERIAL_BAUDRATE = 19200


# Libraries
# ----------------------------------
# Declare application Arduino/chipKIT/Energia/Maple/Teensy/Wiring and users libraries used 
# Short-listing libraries speeds-up building
# Typing = 0 takes none
# Otherwise, leaving empty considers all (default)

# List Arduino/chipKIT/Energia/Maple/Teensy/Wiring libraries here 
#
APP_LIBS_LIST =

# List the libraries to be excluded
# For example, WiFi may crash on Arduino 1.0.2
# For example, Esplora may crash on Arduino 1.0.3
# For example, Firmata may crash on Teensy 3.0
# For example, OneWire may crash on MPIDE 0023
#
EXCLUDE_LIBS = Firmata WiFi Esplora OneWire

# List users libraries here 
#
USER_LIBS_LIST =


MAKEFILE_PATH  = $(CURDIR)/Makefiles
UTILITIES_PATH = $(CURDIR)/Utilities

include $(MAKEFILE_PATH)/Step1.mk
