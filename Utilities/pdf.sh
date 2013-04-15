#!/bin/bash

export PATH=$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin 
export PATH=$PATH:/usr/local/texlive/2012/bin/x86_64-darwin
cd Utilities/latex 
make
cd ../..