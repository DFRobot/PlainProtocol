#!/bin/bash

if [ ! -d ../Distribution ]; then mkdir ../Distribution; fi
rm -fr ../Distribution/*
echo 'Copying .h files'
for h in *.h; do if [ -f $h ]; then cat $h | sed "25,$ s/\/\/\/.*//" | sed "s/[ ]*$//" | grep -v ^$ > ../Distribution/$h; fi; done
mkdir ../Distribution/$@; 
if [ -f *.pde ]; then echo "Copying .pde file"; cp *.pde ../Distribution/$@/; fi
if [ -f *.ino ]; then echo "Copying .ino file"; cp *.ino ../Distribution/$@/; fi
echo 'Copying .cpp files'
for h in *.cpp; do cp $h ../Distribution/; done
echo 'Copying .txt files'
for h in *.txt; do cp $h ../Distribution/; done
if [ -f ../Distribution/main.cpp ]; then rm ../Distribution/main.cpp; fi
if [ -f Utilities/latex/refman.pdf ]; then echo 'Copying .pdf files'; else echo "no pdf"; fi
if [ -f Utilities/latex/refman.pdf ]; then cp Utilities/latex/refman.pdf ../Distribution/$@' - Reference Manual.pdf'; fi
echo '---- List ----'
ls -lRh ../Distribution/ | awk 'NF-2 {$1=$2=$3=$4="";$6="\t\t";$7=$8="";print}' | sed "s/[ ]//g" | grep -v ^'\t\t'$
