// # Editor     : WYC from DFRobot
// # Date       : 20.06.2012

// # Product name: URM V3.2 ultrasonic sensor
// # Product SKU : SEN0001
// # Version     : 1.0
// # Update the library to make it compatible with the Arduino IDE 1.0.1 or the latest version

// # Description:
// # The sketch for using the URM37 autonomous  mode from DFRobot  
// #   and writes the values to the serialport

// # Connection:
// #       Vcc (Arduino) -> Pin 1 VCC (URM V3.2)
// #       GND (Arduino)   -> Pin 2 GND (URM V3.2)
// #       Pin 0 (Arduino) -> Pin 9 TXD (URM V3.2)
// #       Pin 1 (Arduino) -> Pin 8 RXD (URM V3.2)
// #Set Working Mode: autonomous  mode.

uint8_t EnAutonomousCmd[4] = {0x44,0x02,0xaa,0xf0}; //distance measure command
uint8_t ThresholdLowCmd[4] = {0x44,0x00,0x50,0x94};
uint8_t ThresholdHighCmd[4]= {0x44,0x01,0x00,0x45};

byte urm37setting[4] = {
  0x44,0,0,0};

void setup() 
{
  //Serial initialization
  Serial.begin(9600);                  // Sets the baud rate to 9600
  delay(500);
  Serial.println("Init the sensor");

  initSensorSetting();               	// You dont need to setup the module every time. Just run this script once.
                                       // Just once for writing the setting value to the URM37 EEPROM successfully
                                      
  delay(200); //Give sensor some time to start up --Added By crystal  from Singapo, Thanks Crystal.
}

void loop()
{
} 


//PWM mode setup function
void initSensorSetting(){    //set the module to Autonomouse Mode
  pushCmds(0x00,0x00);
  pushCmds(0x01,0x11);
  pushCmds(0x02,0xAA);
}

void pushCmds(byte mode,byte details){  //Transmit setting command to the URM37
  urm37setting[1] = mode; 
  urm37setting[2] = details;
  byte sum = 0;
  for(int i = 0; i < 3; i++)  sum += urm37setting[i];
  urm37setting[3] = sum;
  for(int i = 0; i < 4; i++)  Serial.write(urm37setting[i]);
  delay(100);
  Serial.println();
  for(int i = 0; i < 4; i++)  Serial.print(urm37setting[i],HEX);
  Serial.println();
}