#include <Stepper_Romeo.h>

//init the stepper on Romeo V2       
Stepper_Romeo myStepper(200,7,6,4,5);

void setup()
{
  
}

void loop()
{
  //set speed
  myStepper.setSpeed(200);
  //set the torque of the stepper
  myStepper.setTorque(170);
  //REV 1000 steps
  myStepper.step(1000);
  //delay 1 second
  delay(1000);
  //FWD 1000 steps
  myStepper.step(-1000);
  //delay 1 second
  delay(1000);
  //stop the stepper without torque
  myStepper.stop();
  //delay 1 second
  delay(1000);          
}

