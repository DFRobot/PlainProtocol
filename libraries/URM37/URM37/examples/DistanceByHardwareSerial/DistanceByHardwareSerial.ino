// # 
// # Editor     : Lauren from DFRobot
// # Date       : 08.05.2012

// # Product name: URM V3.2 ultrasonic sensor TTL connection with Arduino
// # Product SKU : SEN0001
// # Version     : 1.0
// # Update the library to make it compatible with the Arduino IDE 1.0 or the latest version

// # Description:
// # The sketch for using the URM37 from DFRobot to read values (0-300) from an ultrasound sensor (3m sensor)
// #   and writes the values to the serialport

// # Connection:
// #       Pin12 (Arduino) -> Pin 1 VCC (URM V3.2)
// #       GND (Arduino)   -> Pin 2 GND (URM V3.2)
// #       Pin 0 (Arduino) -> Pin 9 TXD (URM V3.2)
// #       Pin 1 (Arduino) -> Pin 8 RXD (URM V3.2)
// #


int URPower = 12; // Ultrasound power pin
int val = 0;
int USValue = 0;
int timecount = 0; // Echo counter
boolean flag=true;
uint8_t DMcmd[4] = { 
  0x22, 0x00, 0x00, 0x22}; //distance measure command

void setup() {
  Serial.begin(9600);                  // Sets the baud rate to 9600
  Serial.println("Init the sensor");
  pinMode(URPower, OUTPUT);
  digitalWrite(URPower, HIGH); // Set to High
  delay(200); //Give sensor some time to start up --Added By crystal  from Singapo, Thanks Crystal.
}

void loop()
{
  flag = true;
  //Sending distance measure command :  0x22, 0x00, 0x00, 0x22 ;

  for(int i=0;i<4;i++)
  {
    Serial.write(DMcmd[i]);
  }

  delay(40); //delay for 75 ms
  unsigned long timer = millis();
  while(millis() - timer < 30)
  {
    if(Serial.available()>0)
    {
      int header=Serial.read(); //0x22
      int highbyte=Serial.read();
      int lowbyte=Serial.read();
      int sum=Serial.read();//sum

      if(header == 0x22){
        if(highbyte==255)
        {
          USValue=65525;  //if highbyte =255 , the reading is invalid.
        }
        else
        {
          USValue = highbyte*255+lowbyte;
        }

        Serial.print("Distance=");
        Serial.println(USValue);

        flag=false;
      }
      else{
        while(Serial.available())  byte bufferClear = Serial.read();
        break;
      }
    }
  }
  delay(20);
}



