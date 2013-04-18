/*
 Stepper_Romeo.h - - Stepper library for DFrobot Romeo V2
 
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
 M1+    (Romeo PIN ) ->  blue wire   (stepper)
 M1-    (Romeo) ->  red wire    (stepper)
 M2+    (Romeo) ->  green wire  (stepper)
 M2-    (Romeo) ->  black wire  (stepper)
 
 M_VIN  (Romeo) ->  VCC         (6~20V)
 GND    (Romeo) ->  GND         (GND)
 
 use
 "Stepper_Romeo myStepper(200,7,6,4,5);"
 to init the stepper on Romeo V2
 */

// ensure this library description is only included once
#ifndef Stepper_Romeo_h
#define Stepper_Romeo_h

//set 1 to delay via millis() ;set 1 to delay via delay()
#define USE_MILLIS  1         

//The torque value should be confined to a suitable scope.
//This is the typical value for the motor 42BYGH1861A-C, you can change it by yourself
#define TORQUE_MAX    180     
#define TORQUE_MIN    100

//when stepper stops, current will rise. To confine the current in a proper state, you can change this value to control the pwm wave.
//This is the typical value for the motor 42BYGH1861A-C, you can change it by yourself
#define TORQUE_STOP   150     

// library interface description
class Stepper_Romeo {
  public:
    // constructors:
    Stepper_Romeo(int number_of_steps, int motor_pin_1, int motor_torque_pin_1, int motor_pin_2, int motor_torque_pin_2);

    // speed setter method:
    void setSpeed(long whatSpeed);
  
    // torque setter mothod:
    void setTorque(int whatTorque);

    // mover method:
    void step(int number_of_steps);
  
    // stop method:
    void stop();

    int version(void);

  private:
    void stepMotor();
    int direction;        // Direction of rotation
    int speed;          // Speed in RPMs
    unsigned long step_delay;    // delay between steps, in ms, based on speed
    int number_of_steps;      // total number of steps this motor can take
    int pin_count;        // whether you're driving the motor with 2 or 4 pins
    int torque;             // Torque from 0~255
  
    int motor_pin_1;
    int motor_pin_2;
    int motor_torque_pin_1;
    int motor_torque_pin_2;
  
    long last_step_time;      // time stamp in ms of when the last step was taken
  
    enum stepStateEnum {      // stepper state machine
      high_high,
      low_high,
      low_low,
      high_low
    };
};

#endif

