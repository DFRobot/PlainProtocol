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


# Arduino specifics
# ----------------------------------
# Automatic 0023 or 1. selection based on version.txt
#
ifneq ($(shell grep 1. $(ARDUINO_PATH)/lib/version.txt),)
    include $(MAKEFILE_PATH)/Arduino1.mk	
else
    include $(MAKEFILE_PATH)/Arduino23.mk	
endif

