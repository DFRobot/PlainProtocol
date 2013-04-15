
  PlainProtocol
  Project
  ----------------------------------
  Developed with embedXcode

  Project PlainProtocol
  Created by qiao on 13-4-2
  Copyright © 2013年 qiao
  Licence CC = BY SA NC


  References
  ----------------------------------
  This is a plain protocol for DFRobot
  
                                    PlainProtocol Frame
 |----------------------------------------------------------|-------------------------------|
 |  <Command>Content;                                       | <speed>100;                   |
 |----------------------------------------------------------|-------------------------------|
 |  <Command>Content1,Content2;                             | <speed>100,200;               |
 |----------------------------------------------------------|-------------------------------|
 |  <Command1>Content1;<Command2>Content2;                  | <speed>100; <direction>100;   |
 |----------------------------------------------------------|-------------------------------|
 |  #Address<Command>Content;                               | #1<speed>100;                 |
 |----------------------------------------------------------|-------------------------------|
 |  #Address<Command>Content1,Content2;                     | #1<speed>100,200;             |
 |----------------------------------------------------------|-------------------------------|
 |  #Address1<Command1>Content1;#Address2<Command2>Content2;| #1<speed>100;#2<direction>100;|
 |----------------------------------------------------------|-------------------------------|


  for more details please view the example file: PlainProtocol.ino
  It will show how to use this library.

  embedXcode
  ----------------------------------
  Embedded Computing Template on Xcode 4
  Copyright © Rei VILO, 2010-2013
  Licence CC = BY NC SA
  http://embedXcode.weebly.com/


  

  