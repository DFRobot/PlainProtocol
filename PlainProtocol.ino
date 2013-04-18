/// 
/// @mainpage	PlainProtocol 
///
/// @details	DFRobot PlainProtocol for arduino
/// @n 
/// @n 
/// @n @a	Developed with [embedXcode](http://embedXcode.weebly.com)
/// 
/// @author	qiao
/// @author	qiao
/// @date	13-4-2 上午9:17
/// @version	1.0
/// 
/// @copyright	© qiao, 2013年
/// @copyright	CC = BY NC SA
///
/// @see	ReadMe.txt for references
///


///
/// @file	PlainProtocol.ino 
/// @brief	Main sketch
///
/// @details	test program for PlainProtocol
/// @n @a	Developed with [embedXcode](http://embedXcode.weebly.com)
/// 
/// @author	qiao
/// @author	qiao
/// @date	13-4-2 上午9:17
/// @version	1.0
/// 
/// @copyright	© qiao, 2013年
/// @copyright	CC = BY NC SA
///
/// @see	ReadMe.txt for references
/// @n
///

#ifndef ARDUINO
#define ARDUINO 103
#endif

// Core library for code-sense
#if defined(WIRING) // Wiring specific
#include "Wiring.h"
#elif defined(MAPLE_IDE) // Maple specific
#include "WProgram.h"   
#elif defined(MPIDE) // chipKIT specific
#include "WProgram.h"
#elif defined(DIGISPARK) // Digispark specific
#include "Arduino.h"
#elif defined(ENERGIA) // LaunchPad, FraunchPad and StellarPad specific
#include "Energia.h"
#elif defined(CORE_TEENSY) // Teensy specific
#include "WProgram.h"
#elif defined(ARDUINO) && (ARDUINO >= 100) // Arduino 1.0 and 1.5 specific
#include "Arduino.h"
#elif defined(ARDUINO) && (ARDUINO < 100) // Arduino 23 specific
#include "WProgram.h"
#else // error
#error Platform not defined
#endif

// Include application, user and local libraries
#include "PlainProtocol.h"


PlainProtocol mytest;



void setup() {
  mytest.init();
}


void loop() {
  
  //Receive frame from serial. This function should be put in the loop and called periodically as following:
  if (mytest.receiveFrame()) {
    //if the received command is "speed", do the "speed" process. 
    if (mytest.receivedCommand=="speed") {
      //the "speed" process
      //the received command, the type is "Class String"
      Serial1.println(mytest.receivedCommand);
      //the Lenth of received Content 
      Serial1.println(mytest.receivedContentLenth);
      for (int i=0; i<mytest.receivedContentLenth; i++) {
        //the received content in an array
        Serial1.println(mytest.receivedContent[i]);
      }
      Serial1.println();
    }
    else if (mytest.receivedCommand=="torque"){
      //torque process
      //the same as above
      Serial1.println(mytest.receivedCommand);
      Serial1.println(mytest.receivedContentLenth);
      for (int i=0; i<mytest.receivedContentLenth; i++) {
        Serial1.println(mytest.receivedContent[i]);
      }
      Serial1.println();

    }
    else{
      //no matching command
      Serial1.println("command not available");
    }
  }
  

  
  
  
  static unsigned long loopTimer=millis();
  //send the frame
  if (millis()-loopTimer>100) {
    loopTimer=millis();
    
    //the following two function do the same thing
    mytest.sendFrame("<speed>,56,93,812;");
    mytest.sendFrame("speed"/*sendingCommand*/,3/*sendingContentLenth*/,56,93,812/*three sendingContent, int only*/);

    
    //the following two function do the same thing
    mytest.sendFrame("#3<speed>,56,93;");
    mytest.sendFrame(3/*sendingAddress*/,"speed"/*sendingCommand*/,2/*sendingContentLenth*/,56,93/*two sendingContent, int only*/);
    
    //the following three function do the same thing
    mytest.sendFrame("<speed>;");
    mytest.sendFrame("speed"/*sendingCommand*/);//the string without ';' will deal with command without content
    mytest.sendFrame("speed"/*sendingCommand*/,0/*sendingContentLenth*/);
  }
  
  
  
  
  
  
}
