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
// #       Pin 5 (Arduino) -> Pin 6 COMP/TRIG (URM V3.2)
// #       Pin 3 (Arduino) -> Pin 4 PWM (URM V3.2)
// # Working Mode: autonomous  mode.

int URPWM = 3; // PWM Output 0-25000US,Every 50US represent 1cm
int URCOMP= 5; // PWM trigger pin

unsigned int DistanceMeasured= 0;



void setup() 
{
  //Serial initialization
  Serial.begin(9600);                  // Sets the baud rate to 9600
  delay(500);
  Serial.println("Init the sensor");

 }

void loop()
{
  AutonomousMode();
  delay(100);
} 



void AutonomousMode()
{ 
// if the reading is equal or smaller than the threshold, pin COMP/TRIG will have low output
//  if(digitalRead(URCOMP)==LOW){
//    Serial.print("the distance measured is equal or smaller than the threshold\t");
//  }
//  else if(digitalRead(URCOMP)==HIGH){
//    Serial.print("the distance measured is bigger than the threshold\t");
//  }
  //reading Pin PWM will output pulses
  unsigned long LowLevelTime = pulseIn(URPWM, LOW) ;

  if(LowLevelTime==50000) // the reading is invalid.
  {
    Serial.print("Invalid");
  }
  else{
    DistanceMeasured = LowLevelTime /50; // every 50us low level stands for 1cm
  }
  Serial.print("Distance Measured=");
  Serial.println(DistanceMeasured);
}



