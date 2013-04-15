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


# Energia LaunchPad MSP430 and FraunchPad specifics
# ----------------------------------
#
PLATFORM         := Energia
PLATFORM_TAG     := ENERGIA=8 ARDUINO=101
APPLICATION_PATH := /Applications/Energia.app/Contents/Resources/Java

UPLOADER          = mspdebug
MSPDEBUG_PATH     = $(APPLICATION_PATH)/hardware/tools
MSPDEBUG          = $(MSPDEBUG_PATH)/msp430/mspdebug/mspdebug
MSPDEBUG_OPTS     = rf2500 --force-reset

# FraunchPad MSP430FR5739 requires a specific command
#
ifeq ($(BOARD_TAG), lpmsp430fr5739)
    MSPDEBUG_COMMAND = load
else
    MSPDEBUG_COMMAND = prog
endif

APP_TOOLS_PATH   := $(APPLICATION_PATH)/hardware/tools/msp430/bin
CORE_LIB_PATH    := $(APPLICATION_PATH)/hardware/msp430/cores/msp430
APP_LIB_PATH     := $(APPLICATION_PATH)/hardware/msp430/libraries
BOARDS_TXT       := $(APPLICATION_PATH)/hardware/msp430/boards.txt

# Sketchbook/Libraries path
# wildcard required for ~ management
# ?ibraries required for libraries and Libraries
#
ifeq ($(USER_PATH)/Library/Energia/preferences.txt,)
    $(error Error: run Energia once and define sketchbook path)
endif

ifeq ($(wildcard $(SKETCHBOOK_DIR)),)
    SKETCHBOOK_DIR = $(shell grep sketchbook.path $(wildcard ~/Library/Energia/preferences.txt) | cut -d = -f 2)
endif
ifeq ($(wildcard $(SKETCHBOOK_DIR)),)
    $(error Error: sketchbook path not found)
endif
USER_LIB_PATH  = $(wildcard $(SKETCHBOOK_DIR)/?ibraries)


# Rules for making a c++ file from the main sketch (.pde)
#
PDEHEADER      = \\\#include \"Energia.h\"  


# Tool-chain names
#
CC      = $(APP_TOOLS_PATH)/msp430-gcc
CXX     = $(APP_TOOLS_PATH)/msp430-g++
AR      = $(APP_TOOLS_PATH)/msp430-ar
OBJDUMP = $(APP_TOOLS_PATH)/msp430-objdump
OBJCOPY = $(APP_TOOLS_PATH)/msp430-objcopy
SIZE    = $(APP_TOOLS_PATH)/msp430-size
NM      = $(APP_TOOLS_PATH)/msp430-nm


BOARD    = $(call PARSE_BOARD,$(BOARD_TAG),board)
#LDSCRIPT = $(call PARSE_BOARD,$(BOARD_TAG),ldscript)
VARIANT  = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
VARIANT_PATH = $(APPLICATION_PATH)/hardware/msp430/variants/$(VARIANT)

MCU_FLAG_NAME  = mmcu
EXTRA_LDFLAGS  =
#EXTRA_LDFLAGS = -T$(CORE_LIB_PATH)/$(LDSCRIPT)
EXTRA_CPPFLAGS = $(addprefix -D, $(PLATFORM_TAG)) -I$(VARIANT_PATH)

