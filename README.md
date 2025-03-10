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
![image](https://github.com/user-attachments/assets/c93f6044-7c6e-4506-9e4c-6a767e0192e0)
the following is the simulations o fsuch a nonlinear control in terms of performance requirements:
![image](https://github.com/user-attachments/assets/e9326255-03b3-4433-abfe-12d575feec17)
LF control proves to be efficiently capable of handling nonlinearities in the plant.

3- Sliding Mode Control (SMC):
SMC is a type of Robust control algorithm that can be also used for nonlinear systems as a robust nonlinear control law. Main concept in SMC is to drive all states of the system towards a surface which is called: Switching / Sliding surface, which is a linear relationship between the states (this is the concept of linearization/linearizing in SMC). SMC is mainly focused to handle: un-modeled dynamics, uncertainties in the system. In contrast to adaptive control which in a real-time fashion changes its parameters and architecture, SMC is a static law but able to address slightly-varying plant dynamics. In SMC, there essentially 2 important steps: a- Reaching Law which drives the states towards the switching surface, and b- Main control law which ensures that states are staying around the switching surface. One challenge / drawback with SMC is: Chaterring which (physical interpretation: usually small-amplitude but high-frequency oscillations resulted from the jittering control signal around the switching / sliding surface). Small gains mitigates chattering but to the cost of non-robustness, strong gains handles robustness but results in chattering. A decent solution to this trade-off is: Boundary Layer. BL is a layer with a specific thickness at which the control law is gentle with smaller gains inside the layer and stronger gains outside. One approach that I have used is: Saturation type of BL. 
![image](https://github.com/user-attachments/assets/69ac8a9f-3a33-420e-b248-ba36126d091f)
![image](https://github.com/user-attachments/assets/44f00b03-b5d5-4974-90c3-14c501f32dda)
SMC also shows perfect handling of the nonlinearities in the Reference Tracking Control. 

3- C_FBL-SMC:
This is the novel type of controller at which a combination of the FeedBack Linearization and SMC is adopted. This is particularly feasile as FBL after canceling out the nonlinearities, allws for any type of controller to be implemented. 
![image](https://github.com/user-attachments/assets/5e07e708-e13f-4991-94e9-9fd2de458848)
which shows the same results as like: SMC and FBL separately. 
---
Besides to studying the controllers' performance on the designed profile's Trajectories, step input is among the best excitations signals to assess the capabilites of a control signals. This is particularly good as the step has abrupt jump in value which can measure the fast-response metrics. Meaning that a decent controller needs to be fast in tracking the sudden jump in value and at the same time to be able to avoid the resulting maximum peak overshoot. 
Agains simlple PID cannot even track the input yet alone difficulties in: very slow controlle rand terrible offset. 
1- SMC: 
![image](https://github.com/user-attachments/assets/53b15a7e-fe07-458d-962e-146db634a102)
the above SMC is tuned with: lambda=1e2 and eta=2e5. (S=lambda*e_dot + e). Decreasing lambda usually leads to slightly slow system and smaller Mp. Smaller values in BL Thicknes will lead to more jitter / chattering. 
below is the response using only FBL:
![image](https://github.com/user-attachments/assets/29dfa24f-1df3-4c47-9549-771ad3be62f4)
below is: Combinitation of SMC and FBL:
![image](https://github.com/user-attachments/assets/33e16c84-90c4-4392-9ca2-7ca938655348)
---
This is good to note that tuning a controller is a widespread realm and can be done in various fields. One approach is trial-error till achiving a satisfactory level. Other method is to use: Optimization algorithms. (whic I have done and will post in other files).




 









