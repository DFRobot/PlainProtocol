/*
 Stepper_Romeo.cpp - - Stepper library for DFrobot Romeo V2
 
 This library is only suitable for DFrobot Romeo V2, The change of pwm output(torque) pin may cause error
 
 inspired by the Stepper library for Wiring/Arduino - Version 0.4
 
 Drives a unipolar or bipolar stepper motor using  2 wires.
 and uses 2 wires to control the torque of the stepper via PWM wave.
 
 When wiring multiple stepper motors to a microcontroller,
 you quickly run out of output pins, with each motor requiring 4 connections.
 
 By making use of the fact that at any time two of the four motor
 coils are the inverse  of the other two, the number of
 control connections can be reduced from 4 to 2.
 
 A slightly modified circuit around a Darlington transistor array or an L293 H-bridge
 connects to only 2 microcontroler pins, inverts the signals received,
 and delivers the 4 (2 plus 2 inverted ones) output signals required
 for driving a stepper motor.
 The sequence of controls signals for 2 control wires is as follows
 (columns C1 and C2 from above):
 
 Step C0 C1
 1  0  1
 2  1  1
 3  1  0
 4  0  0
 
 Connection(DFRobot Romeo):
 M1+    (Romeo) ->  blue wire   (stepper)
 M1-    (Romeo) ->  red wire    (stepper)
 M2+    (Romeo) ->  green wire  (stepper)
 M2-    (Romeo) ->  black wire  (stepper)
 
 M_VIN  (Romeo) ->  VCC         (6~20V)
 GND    (Romeo) ->  GND         (GND)
                                                 
 use
 "Stepper_Romeo myStepper(200,7,6,4,5);"
 to init the stepper on Romeo V2
 
 */


#include "Arduino.h"
#include "Stepper_Romeo.h"
#include "wiring_private.h"


/*
 * "number_of_steps" is the total number of steps of a revolution for this motor
 * four-wire constructor.
 * Sets which wires should control the motor and the torque of the moter
 */
Stepper_Romeo::Stepper_Romeo(int number_of_steps, int motor_pin_1, int motor_torque_pin_1, int motor_pin_2, int motor_torque_pin_2)
{
  
  // This library is only suitable for DFrobot Romeo V2, The change of pwm output(torque) pin may cause error
  #if defined (__AVR_ATmega32U4__)
  cbi(TCCR3B, CS31);          //set timer3 with no prescaling
  cbi(TCCR4B, CS42);          //set timer4 with no prescaling
  cbi(TCCR4B, CS41);          //set timer4 with no prescaling
  #else
  //#error  This library is only for AVR_ATmega32U4 espeacially DFrobot Romeo V2
  #endif

  this->speed = 0;        // the motor speed, in revolutions per minute
  this->direction = 0;      // motor direction
  this->last_step_time = 0;    // time stamp in ms of the last step taken
  this->number_of_steps = number_of_steps;    // total number of steps of a revolution for this motor
  this->torque=150;               //the torque of the motor from TORQUE_MIN to TORQUE_MAX
  
  // Arduino pins for the motor control connection:
  this->motor_pin_1 = motor_pin_1;
  this->motor_pin_2 = motor_pin_2;
  this->motor_torque_pin_1 = motor_torque_pin_1;
  this->motor_torque_pin_2 = motor_torque_pin_2;

  // setup the pins on the microcontroller:
  pinMode(this->motor_pin_1, OUTPUT);
  pinMode(this->motor_pin_2, OUTPUT);
}

/*
  Sets the speed in revs per minute
*/
void Stepper_Romeo::setSpeed(long whatSpeed)
{
  this->step_delay =constrain( 60L * 1000L / this->number_of_steps / whatSpeed, 1, 60L * 1000L / this->number_of_steps );
}

/*
 Sets the torque of the motor from TORQUE_MIN to TORQUE_MAX
 */
void Stepper_Romeo::setTorque(int whatTorque)
{
  this->torque = constrain( whatTorque, TORQUE_MIN, TORQUE_MAX);
}


/*
  Moves the motor steps_to_move steps.  If the number is negative, 
   the motor moves in the reverse direction.
 */
void Stepper_Romeo::step(int steps_to_move)
{
  int steps_left = abs(steps_to_move);  // how many steps to take
  long millis_buf;
  
  // determine direction based on whether steps_to_mode is + or -:
  if (steps_to_move > 0) {this->direction = 1;}
  if (steps_to_move < 0) {this->direction = 0;}
 
  //PWM Control, change the torque of the stepper
  analogWrite(this->motor_torque_pin_1, this->torque);
  //PWM Control, change the torque of the stepper
  analogWrite(this->motor_torque_pin_2, this->torque);   
  
  #if (USE_MILLIS == 1)
  // decrement the number of steps, moving one step each time:
  while(steps_left > 0) {
    //buffer the value of millis()
    millis_buf=millis();
    // move only if the appropriate delay has passed:
    if (millis_buf - this->last_step_time >= this->step_delay) {
      // get the timeStamp of when you stepped:
      this->last_step_time = millis_buf;
      // decrement the steps left:
      steps_left--;
      // step the motor
      stepMotor();
    }
  }
  #else
    // decrement the number of steps, moving one step each time:
  while(steps_left > 0) {
      // delay
    delay(this->step_delay);
      // decrement the steps left:
    steps_left--;
      // step the motor
    stepMotor();
  }
  #endif
  //PWM Control, set the torque of the stepper to TORQUE_STOP to stop the stepper with torque
  analogWrite(this->motor_torque_pin_1, TORQUE_STOP);
  //PWM Control, set the torque of the stepper to TORQUE_STOP to stop the stepper with torque
  analogWrite(this->motor_torque_pin_2, TORQUE_STOP);   
}

void Stepper_Romeo::stop()
{
  //PWM Control, set the torque of the stepper to 0 to disable the stepper
  analogWrite(this->motor_torque_pin_1, 0);
  //PWM Control, set the torque of the stepper to 0 to disable the stepper
  analogWrite(this->motor_torque_pin_2, 0);   
}

/*
 * Moves the motor forward or backwards.
 */
void Stepper_Romeo::stepMotor()
{
  //stepper state machine
  static enum stepStateEnum stepState=high_high;
  //determine the direction
  if (this->direction == 1) {
    switch (stepState) {
      case high_high:
        digitalWrite(motor_pin_1, LOW);
        digitalWrite(motor_pin_2, HIGH);
        //change the state
        stepState=low_high;
        break;
      case low_high:
        digitalWrite(motor_pin_1, LOW);
        digitalWrite(motor_pin_2, LOW);
        //change the state
        stepState=low_low;
        break;
      case low_low:
        digitalWrite(motor_pin_1, HIGH);
        digitalWrite(motor_pin_2, LOW);
        //change the state
        stepState=high_low;
        break;
      case high_low:
        digitalWrite(motor_pin_1, HIGH);
        digitalWrite(motor_pin_2, HIGH);
        //change the state
        stepState=high_high;
        break;
      default:
        digitalWrite(motor_pin_1, HIGH);
        digitalWrite(motor_pin_2, HIGH);
        //change the state
        stepState=high_high;
        break;
    }
  } else {
    switch (stepState) {
      case low_low:
        digitalWrite(motor_pin_1, LOW);
        digitalWrite(motor_pin_2, HIGH);
        //change the state
        stepState=low_high;
        break;
      case high_low:
        digitalWrite(motor_pin_1, LOW);
        digitalWrite(motor_pin_2, LOW);
        //change the state
        stepState=low_low;
        break;
      case high_high:
        digitalWrite(motor_pin_1, HIGH);
        digitalWrite(motor_pin_2, LOW);
        //change the state
        stepState=high_low;
        break;
      case low_high:
        digitalWrite(motor_pin_1, HIGH);
        digitalWrite(motor_pin_2, HIGH);
        //change the state
        stepState=high_high;
        break;
      default:
        digitalWrite(motor_pin_1, HIGH);
        digitalWrite(motor_pin_2, HIGH);
        //change the state
        stepState=high_high;
        break;
    }
  }
}

/*
  version() returns the version of the library:
*/
int Stepper_Romeo::version(void)
{
  return 1;
}
