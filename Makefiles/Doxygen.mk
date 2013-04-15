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
# www.doxygen.org
# 	© 1997-2012 by Dimitri van Heesch
# 	GNU General Public License
# 	Documents produced by doxygen are derivative works derived from the input used in their production.
# 	They are not affected by this license.
#

# Doxygen parameters
# ----------------------------------
# Edit ./Documents/doxyfile for options
#


DOXYGEN_PATH = /Applications/Doxygen.app/Contents/Resources/doxygen
ifeq ($(wildcard $(DOXYGEN_PATH)),)
    $(error Error: application doxygen not found)
endif

DOCUMENTS_PATH = $(CURDIR)/Utilities
DOXYFILE       = $(DOCUMENTS_PATH)/doxyfile
ifeq ($(wildcard $(DOXYFILE)),)
    $(error Error: configuration file doxyfile not found)
endif


GENERATE_HTML   = $(strip $(shell grep 'GENERATE_HTML *=' $(DOXYFILE) | cut -d = -f 2 ))
GENERATE_PDF    = $(strip $(shell grep 'GENERATE_LATEX *=' $(DOXYFILE) | cut -d = -f 2 ))
GENERATE_DOCSET = $(strip $(shell grep 'GENERATE_DOCSET *=' $(DOXYFILE) | cut -d = -f 2 ))

BUNDLE_ID       = $(strip $(shell grep 'DOCSET_BUNDLE_ID *=' $(DOXYFILE) | cut -d = -f 2 ))
DOCSET_PATH     = $(USER_PATH)/Library/Developer/Shared/Documentation/DocSets/$(BUNDLE_ID).docset
LOAD_UTIL_PATH  = $(UTILITIES_PATH)/loadDocSet.scpt

PDF_PATH        = $(DOCUMENTS_PATH)/latex/refman.pdf
TEX_PATH        = $(DOCUMENTS_PATH)/latex/refman.tex

$(info ---- info ----)
$(info Doxygen)
$(info .    html       	$(GENERATE_HTML))
$(info .    pdf        	$(GENERATE_PDF))
$(info .    docset  	$(GENERATE_DOCSET))
$(info .    bundle id  	$(BUNDLE_ID))


ifeq ($(GENERATE_HTML),YES)
ifeq ($(wildcard $(DOXYGEN_PATH)),)
    $(error Error: application doxygen not found)
endif
endif

#embed1
#echo $VAR | tr '[:upper:]' '[:lower:]' | sed 's/ //g'


# Doxygen rules
# ----------------------------------
#
document0:
		@echo "--- doxygen reset ---"
		@if [ -d $(DOXYFILE)/html ];  then $(REMOVE) $(DOXYFILE)/html; fi
		@if [ -d $(DOXYFILE)/latex ]; then $(REMOVE) $(DOXYFILE)/latex; fi
		@if [ -d $(DOXYFILE)/xml ];   then $(REMOVE) $(DOXYFILE)/xml; fi

		@if [ -f $(LOAD_UTIL_PATH) ]; then $(REMOVE) $(LOAD_UTIL_PATH); fi
		@if [ -f $(DOCSET_PATH) ]; then $(REMOVE) $(DOCSET_PATH); fi
		@echo "tell application \"Xcode\"" > $(LOAD_UTIL_PATH)
		@echo "load documentation set with path \"$(DOCSET_PATH)\"" >> $(LOAD_UTIL_PATH)
		@echo "end tell" >> $(LOAD_UTIL_PATH)

document1:
		@echo "--- doxygen warnings ---"
		$(DOXYGEN_PATH) $(DOXYFILE)
		@echo "---- docset generated ----"

document2:
ifeq ($(GENERATE_PDF),YES)
		@if [ -f $(TEX_PATH) ]; then Utilities/pdf.sh > Utilities/pdf.log; echo "---- pdf created ---- "; fi
endif

document3:
ifeq ($(GENERATE_DOCSET),YES)
		@if [ -f $(DOCSET_PATH) ]; then if [ $(shell osascript '$(LOAD_UTIL_PATH)') = true ]; then echo "---- docset loaded ---- "; else echo "---- docset not loaded ---- "; fi; fi;
endif

document4:
ifeq ($(GENERATE_DOCSET),YES)
		make -C $(DOCUMENTS_PATH)/html install > ./Utilities/docset.log
		@echo "---- docset installed ----"
endif

document:	message_document document0 document1 document2 document3 document4
		@echo "==== document done ==== "


