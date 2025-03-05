# Control
I locate some of the control projects that I have done so far in this repository. This repository does not contain all of the control-related projects, but some of them. 
I am gradually adding my projects done since 2015. 
---
Reference profile trajectory planning. Defining the reference profile trajectory using firs princples equations for: Position, Velocity, Acceleration:
![image](https://github.com/user-attachments/assets/64e9c8f5-8414-4fe9-bc26-9ff33b9c441e)
![image](https://github.com/user-attachments/assets/a4a54358-9c83-4ccd-8460-432d5d38a87d)
![image](https://github.com/user-attachments/assets/8b7957c5-3845-4cfb-9751-6024213a359a)
the stage is supposed to track a given position profile trjectory in a reciprocating shape (trajectory tracking) with: velocity and acceleration trajectory profiles as Constraints. 
(corresponding codes are attached in the pertinent folders). 
---
To drive the stage to track the iven trajectories, servo control design is needed. 
for control design:
Dynamics model of the system (stage)
Nonlinear model of the plant is designed in matlab editor and simulink. 
As for control: 4 different types of control laws are designed and tested: 
1- PID: 
Expectedly, PID control for a strongly-nonlinear system cannot yield proper performance requirements / specifications. 
![image](https://github.com/user-attachments/assets/3e6b1d6c-a5e7-4c05-a69c-e611fe8a18ff)
besides, very high values of control gains in PID can easily lead to actuator saturation and / or large control signal with another nonlinearity. 
More importantly, it is seen that the plant is not tracking the position trajectory profile well (there are remarkable offsets). So from performance perspective PID control even with strong gains (subject to the risk of: actuator saturation; fails.). 
Worse offsets (lack of precision in tracking the position profile) is observed on the reciprocated (returning phase of the motion to the left, where the position started from 0 comes back to 0 and starts to go towards the left-side (negative positions)). 

2- FeedBack Linearization Control Law:
Feedback linearization is a nonlinear control technique at which, the main effort is to cancel out the nonlinear terms. In simple words, the nonlinear controller, adds the opposite-sign of the nonlinear terms to cancel them out. 
some notes in this regard: 
Feedback Linearization
Feedback linearization is a control technique that transforms a nonlinear system into a linear one by applying a specific nonlinear control law. This method seeks to cancel out the nonlinearities in the system dynamics, resulting in a linear system that can be controlled using traditional linear control techniques.
Steps for Feedback Linearization:
1.	System Representation:
o	Represent the nonlinear system in state-space form.
o	Identify the state variables, inputs, and outputs.
2.	Define the Control Law:
o	Design a nonlinear control input that cancels out the nonlinear terms in the system equations. 
o	The control law is typically a function of the state variables and desired outputs.
3.	Transform the System:
o	Apply the control law to the system equations.
o	The resulting system should have linear dynamics.
4.	Design Linear Controller:
o	Use linear control techniques (e.g., PID, LQR) to design a controller for the linearized system.
o	Implement the controller in the transformed system.
Example:
Consider a nonlinear system described by: x˙=f(x)+g(x)u where (x) is the state vector, (u) is the control input, and (f(x)) and (g(x)) are nonlinear functions.
To linearize the system using feedback linearization, follow these steps:
1.	Define the Control Law: u = α(x) + β(x)v where (\alpha(x)) and (\beta(x)) are functions designed to cancel the nonlinearities, and (v) is the new control input for the linearized system.
2.	Transform the System: Substitute the control law into the system equations: x˙=f(x)+g(x)(α(x)+β(x)v) Choose (\alpha(x)) and (\beta(x)) such that: f(x)+g(x)α(x) = 0 and g(x)β(x) = 1 This simplifies the system to: x˙ = v which is a linear system.  
3.	Design Linear Controller: Design a linear controller (v) using traditional techniques to achieve the desired performance.







