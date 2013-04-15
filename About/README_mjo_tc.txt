#
# See http://mjo.tc/atelier/2009/02/arduino-cli.html
#
########################################################################
# 
# Arduino command line tools Makefile
# System part (i.e. project independent)
#
# Copyright (C) 2010 Martin Oldfield <m@mjo.tc>, based on work that is
# Copyright Nicholas Zambetti, David A. Mellis & Hernando Barragan
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
#
# Adapted from Arduino 0011 Makefile by M J Oldfield
#
# Original Arduino adaptation by mellis, eighthave, oli.keller
#
# Modified by Christopher Peplin for chipKIT.
#
# Version 0.1  17.ii.2009  M J Oldfield
#
#         0.2  22.ii.2009  M J Oldfield
#                          - fixes so that the Makefile actually works!
#                          - support for uploading via ISP
#                          - orthogonal choices of using the Arduino for
#                            tools, libraries and uploading
#
#         0.3  21.v.2010   M J Oldfield
#                          - added proper license statement
#                          - added code from Philip Hands to reset
#                            Arduino prior to upload
#
#         0.4  25.v.2010   M J Oldfield
#                          - tweaked reset target on Philip Hands' advice
#
#         0.5  23.iii.2011 Stefan Tomanek
#                          - added ad-hoc library building
#              17.v.2011   M J Oldfield
#                          - grabbed said version from Ubuntu
#
#         0.6  22.vi.2011  M J Oldfield
#                          - added ard-parse-boards supports
#                          - added -lc to linker opts,
#                            on Fabien Le Lez's advice
#
#              Development changes, Chris Peplin,
#
#              			   - converted ard-parse-boards to a Makefile function
#              			   so Perl/YAML aren't required (thanks to avenue33 on
#              			   the chipKIT forums)
#
########################################################################
#
# STANDARD ARDUINO WORKFLOW
#
# Given a normal sketch directory, all you need to do is to create
# a small Makefile which defines a few things, and then includes this one.
#
# For example:
#
#       ARDUINO_DIR  = /Applications/arduino-0013
#
#       TARGET       = CLItest
#       ARDUINO_LIBS_LIST = LiquidCrystal
#
#       BOARD_TAG    = uno
#       SERIAL_PORT = /dev/cu.usb*
#
#       include /usr/local/share/Arduino.mk
#
# Hopefully these will be self-explanatory but in case they're not:
#
#    ARDUINO_DIR  - Where the Arduino software has been unpacked
#    TARGET       - The basename used for the final files. Canonically
#                   this would match the .pde file, but it's not needed
#                   here: you could always set it to xx if you wanted!
#    ARDUINO_LIBS_LIST - A list of any libraries used by the sketch (we assume
#                   these are in $(ARDUINO_DIR)/hardware/libraries
#    ARDUINO_PORT - The port where the Arduino can be found (only needed
#                   when uploading
#    BOARD_TAG    - The ard-parse-boards tag for the board e.g. uno or mega
#                   'make show_boards' shows a list
#
# You might also want to specify these, but normally they'll be read from the
# boards.txt file i.e. implied by BOARD_TAG
#
#    MCU,F_CPU    - The target processor description
#
# Once this file has been created the typical workflow is just
#
#   $ make upload
#
# All of the object files are created in the build-cli subdirectory
# All sources should be in the current directory and can include:
#  - at most one .pde file which will be treated as C++ after the standard
#    Arduino header and footer have been affixed.
#  - any number of .c, .cpp, .s and .h files
#
# Included libraries are built in the build-cli/libs subdirectory.
#
# Besides make upload you can also
#   make             - no upload
#   make clean       - remove all our dependencies
#   make depends     - update dependencies
#   make reset       - reset the Arduino by tickling DTR on the serial port
#   make raw_upload  - upload without first resetting
#   make show_boards - list all the boards defined in boards.txt
#
########################################################################
#
# ARDUINO WITH OTHER TOOLS
#
# If the tools aren't in the Arduino distribution, then you need to
# specify their location:
#
#    AVR_TOOLS_PATH = /usr/bin
#    AVRDUDE_CONF   = /etc/avrdude/avrdude.conf
#
########################################################################
#
# ARDUINO WITH ISP
#
# You need to specify some details of your ISP programmer and might
# also need to specify the fuse values:
#
#     ISP_PROG	   = -c stk500v2
#     ISP_PORT     = /dev/ttyACM0
#
# You might also need to set the fuse bits, but typically they'll be
# read from boards.txt, based on the BOARD_TAG variable:
#
#     ISP_LOCK_FUSE_PRE  = 0x3f
#     ISP_LOCK_FUSE_POST = 0xcf
#     ISP_HIGH_FUSE      = 0xdf
#     ISP_LOW_FUSE       = 0xff
#     ISP_EXT_FUSE       = 0x01
#
# I think the fuses here are fine for uploading to the ATmega168
# without bootloader.
#
# To actually do this upload use the ispload target:
#
#    make ispload
#
#
########################################################################
