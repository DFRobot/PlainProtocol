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


# chipKIT MPIDE specifics
# ----------------------------------
#
PLATFORM         := MPIDE
PLATFORM_TAG     := MPIDE=23
APPLICATION_PATH := /Applications/Mpide.app/Contents/Resources/Java

APP_TOOLS_PATH   := $(APPLICATION_PATH)/hardware/pic32/compiler/pic32-tools/bin
CORE_LIB_PATH    := $(APPLICATION_PATH)/hardware/pic32/cores/pic32
APP_LIB_PATH     := $(APPLICATION_PATH)/hardware/pic32/libraries
BOARDS_TXT       := $(APPLICATION_PATH)/hardware/pic32/boards.txt

# Sketchbook/Libraries path
# wildcard required for ~ management
# ?ibraries required for libraries and Libraries
#
ifeq ($(wildcard $(USER_PATH)/Library/Mpide/preferences.txt),)
    $(error Error: run Mpide once and define sketchbook path)
endif

ifeq ($(wildcard $(SKETCHBOOK_DIR)),)
    SKETCHBOOK_DIR = $(shell grep sketchbook.path $(USER_PATH)/Library/Mpide/preferences.txt | cut -d = -f 2)
endif
ifeq ($(wildcard $(SKETCHBOOK_DIR)),)
    $(error Error: sketchbook path not found)
endif
USER_LIB_PATH  = $(wildcard $(SKETCHBOOK_DIR)/?ibraries)


# Rules for making a c++ file from the main sketch (.pde)
#
PDEHEADER      = \\\#include \"WProgram.h\"  


# Tool-chain names
#
CC      = $(APP_TOOLS_PATH)/pic32-gcc
CXX     = $(APP_TOOLS_PATH)/pic32-g++
AR      = $(APP_TOOLS_PATH)/pic32-ar
OBJDUMP = $(APP_TOOLS_PATH)/pic32-objdump
OBJCOPY = $(APP_TOOLS_PATH)/pic32-objcopy
SIZE    = $(APP_TOOLS_PATH)/pic32-size
NM      = $(APP_TOOLS_PATH)/pic32-nm


BOARD    = $(call PARSE_BOARD,$(BOARD_TAG),board)
LDSCRIPT = $(call PARSE_BOARD,$(BOARD_TAG),ldscript)
VARIANT  = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
VARIANT_PATH = $(APPLICATION_PATH)/hardware/pic32/variants/$(VARIANT)

MCU_FLAG_NAME  = mprocessor
EXTRA_LDFLAGS  = -T$(CORE_LIB_PATH)/$(LDSCRIPT)
EXTRA_CPPFLAGS = -O2 -mno-smart-io -G1024 -D$(PLATFORM_TAG) -D$(BOARD) -I$(VARIANT_PATH)

