#
# embedXcode
# ----------------------------------
# Embedded Computing on Xcode 4
#
# Copyright © Rei VILO, 2010-2013
# Licence CC = BY NC SA
#

# References and contribution
# ----------------------------------
# See About folder
# 


# Sketch unicity test and extension
# ----------------------------------
#

ifndef SKETCH_EXTENSION
    ifeq ($(words $(wildcard *.pde) $(wildcard *.ino)), 0)
        $(error No pde or ino sketch)
    endif

    ifneq ($(words $(wildcard *.pde) $(wildcard *.ino)), 1)
        $(error More than 1 pde or ino sketch)
    endif

    ifneq ($(wildcard *.pde),)
        SKETCH_EXTENSION := pde
    else ifneq ($(wildcard *.ino),)
        SKETCH_EXTENSION := ino
    else
        $(error Extension error)
    endif
endif


ifneq ($(SKETCH_EXTENSION),cpp)
    ifeq ($(words $(wildcard *.$(SKETCH_EXTENSION))), 0)
        $(error No $(SKETCH_EXTENSION) sketch)
    endif

    ifneq ($(words $(wildcard *.$(SKETCH_EXTENSION))), 1)
        $(error More than one $(SKETCH_EXTENSION) sketch)
    endif
endif


# Board selection
# ----------------------------------
# Board specifics defined in .xconfig file
# BOARD_TAG and AVRDUDE_PORT 
#
ifneq ($(MAKECMDGOALS),boards)
    ifneq ($(MAKECMDGOALS),clean)
        ifndef BOARD_TAG
            $(error BOARD_TAG not defined)
        endif
    endif
endif

ifndef BOARD_PORT
    BOARD_PORT = /dev/tty.usb*
endif


# Arduino.app Mpide.app Wiring.app Energia.app paths
#
ARDUINO_APP   = /Applications/Arduino.app
MPIDE_APP     = /Applications/Mpide.app
WIRING_APP    = /Applications/Wiring.app
ENERGIA_APP   = /Applications/Energia.app
MAPLE_APP     = /Applications/MapleIDE.app
TEENSY_APP    = /Applications/Arduino.app
DIGISPARK_APP = /Applications/Arduino.app

ifeq ($(wildcard $(ARDUINO_APP)),)
    ifeq ($(wildcard $(MPIDE_APP)),)
        ifeq ($(wildcard $(WIRING_APP)),)
            ifeq ($(wildcard $(ENERGIA_APP)),)
                ifeq ($(wildcard $(MAPLE_APP)),)
                    ifeq ($(wildcard $(TEENSY_APP)),)
                        ifeq ($(wildcard $(DIGISPARK_APP)),)
                            $(error Error: no application found)
                        endif
                    endif
                endif
            endif
        endif
    endif
endif

ARDUINO_PATH   = $(ARDUINO_APP)/Contents/Resources/Java
MPIDE_PATH     = $(MPIDE_APP)/Contents/Resources/Java
WIRING_PATH    = $(WIRING_APP)/Contents/Resources/Java
ENERGIA_PATH   = $(ENERGIA_APP)/Contents/Resources/Java
MAPLE_PATH     = $(MAPLE_APP)/Contents/Resources/Java
TEENSY_PATH    = $(TEENSY_APP)/Contents/Resources/Java
DIGISPARK_PATH = $(DIGISPARK_APP)/Contents/Resources/Java

# Miscellaneous
# ----------------------------------
# Variables
#
TARGET       = embeddedcomputing
USER_PATH   := $(wildcard ~)

# main.cpp selection
# = 1 takes local main.cpp
#
NO_CORE_MAIN_FUNCTION := 1

# Builds directory
#
OBJDIR  = Builds

# Function PARSE_BOARD data retrieval from boards.txt
# result = $(call PARSE_BOARD 'boardname','parameter')
#
PARSE_BOARD = $(shell if [ -f $(BOARDS_TXT) ]; then grep ^$(1).$(2)= $(BOARDS_TXT) | cut -d = -f 2; fi; )

# Function PARSE_FILE data retrieval from specified file
# result = $(call PARSE_FILE 'boardname','parameter','filename')
#
PARSE_FILE = $(shell if [ -f $(3) ]; then grep ^$(1).$(2) $(3) | cut -d = -f 2; fi; )


# Clean if new BOARD_TAG
# ----------------------------------
#
NEW_TAG := $(strip $(OBJDIR)/$(BOARD_TAG)-TAG) #
OLD_TAG := $(strip $(wildcard $(OBJDIR)/*-TAG)) # */

ifneq ($(OLD_TAG),$(NEW_TAG))
    CHANGE_FLAG := 1
else
    CHANGE_FLAG := 0
endif


# Identification and switch
# ----------------------------------
# Look if BOARD_TAG is listed as a Arduino/Arduino board
# Look if BOARD_TAG is listed as a Arduino/Arduino/avr board *1.5
# Look if BOARD_TAG is listed as a Arduino/Arduino/sam board *1.5
# Look if BOARD_TAG is listed as a Mpide/PIC32 board
# Look if BOARD_TAG is listed as a Wiring/Wiring board
# Look if BOARD_TAG is listed as a Energia/MPS430 board
# Look if BOARD_TAG is listed as a MapleIDE/LeafLabs board
# Look if BOARD_TAG is listed as a Teensy/Teensy board
# Look if BOARD_TAG is listed as a Digispark/Digispark board
# Order matters!
#

ifneq ($(MAKECMDGOALS),boards)
    ifneq ($(MAKECMDGOALS),clean)
        ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ARDUINO_PATH)/hardware/arduino/boards.txt),)
            include $(MAKEFILE_PATH)/Arduino.mk
        else ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ARDUINO_PATH)/hardware/arduino/avr/boards.txt),)
            include $(MAKEFILE_PATH)/Arduino15avr.mk
        else ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ARDUINO_PATH)/hardware/arduino/sam/boards.txt),)
            include $(MAKEFILE_PATH)/Arduino15sam.mk
        else ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ARDUINO_PATH)/hardware/arduino/boards.txt),)
            include $(MAKEFILE_PATH)/Arduino.mk
        else ifneq ($(shell grep ^$(BOARD_TAG).name $(MPIDE_PATH)/hardware/pic32/boards.txt),)
            include $(MAKEFILE_PATH)/Mpide.mk
        else ifneq ($(shell grep ^$(BOARD_TAG).name $(WIRING_PATH)/hardware/Wiring/boards.txt),)
            include $(MAKEFILE_PATH)/Wiring.mk
        else ifneq ($(shell grep ^$(BOARD_TAG).name $(ENERGIA_PATH)/hardware/msp430/boards.txt),)
            include $(MAKEFILE_PATH)/Energia430.mk
        else ifneq ($(shell grep ^$(BOARD_TAG).name $(ENERGIA_PATH)/hardware/lm4f/boards.txt),)
            include $(MAKEFILE_PATH)/EnergiaLM4F.mk
        else ifneq ($(shell grep ^$(BOARD_TAG).name $(MAPLE_PATH)/hardware/leaflabs/boards.txt),)
            include $(MAKEFILE_PATH)/MapleIDE.mk
        else ifneq ($(shell grep ^$(BOARD_TAG).name $(TEENSY_PATH)/hardware/teensy/boards.txt),)
            include $(MAKEFILE_PATH)/Teensy.mk
        else ifneq ($(shell grep ^$(BOARD_TAG).name $(DIGISPARK_PATH)/hardware/tiny-digispark/boards.txt),)
            include $(MAKEFILE_PATH)/Digispark.mk
        else
            $(error $(BOARD_TAG) is unknown)
        endif
    endif
endif


# List of sub-paths to be excluded
#
EXCLUDE_NAMES  = Example example Examples examples Archive archive Archives archives Documentation documentation Reference reference
EXCLUDE_NAMES += ArduinoTestSuite
EXCLUDE_NAMES += $(EXCLUDE_LIBS)
EXCLUDE_LIST   = $(addprefix %,$(EXCLUDE_NAMES))

# Step 2
#
include $(MAKEFILE_PATH)/Step2.mk
