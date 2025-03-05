%% Built-in FCN in matlab: trapveltraj
% Tune it as much as you reach to the desired performance 
% Run first time and then run from line: 278 
% clc;
% clear all;
% close all;
% SPG 
b = 1e-2;% [m] maximum RS range achievable - in reciprocating move   
wp2linsp1 = linspace(0, b, 10);
wp2linsp2 = linspace(b, 0, 10);
wp2linsp3 = linspace(0, -b, 10);
wp2linsp4 = linspace(-b, 0, 10);
wp2 = [wp2linsp1, wp2linsp2, wp2linsp3, wp2linsp4]; % waypoints 
ttraj = linspace(0, 1, length(wp2));% time for trajectory to be used in simulink for polynomial method 
NumSamp = 10;
% timepoints = linspace(0, 1, length(wp1));
% [q, qd, qdd, tvec, pp] = trapveltraj(wp2, NumSamp, 'EndTime', 0.1); 
[q, qd, qdd, tvec, pp] = trapveltraj(wp2, NumSamp); 
% [q, qd, qdd, tvec, pp] = trapveltraj(wp1, NumSamp, 'Time', timepoints); 
figure(21)
plot(tvec, q)
grid on 
xlabel('time vector [sec]', 'FontSize', 22)
ylabel('Trajectory Positions (q) [m]', 'FontSize', 22)
figure(22)
plot(tvec, qd)
grid on 
xlabel('time vector [sec]', 'FontSize', 22)
ylabel('Trajectory Velocities (qd) [m/s]', 'FontSize', 22)
figure(23)
plot(tvec, qdd)
grid on 
xlabel('time vector [sec]', 'FontSize', 22)
ylabel('Trajectory Accelerations (qdd) [m/s^2]', 'FontSize', 22)
%% Best way: use Simulink Polynomial profile trajectory 
% it requires: waypoints and the corresponding time. 
% so do a it of hand calcs to derive the corresponding time from a given
% Vel and ACC profile trajectories ...  
format long 
% t11 = 1/28 % to have exactly 1 Hz meaning finishing 1 cycle in 1 second 
t11 = 1/30 ; % just to make the b to be equal to 10 cm 
t12 = 5*t11
t13 = 2*t11+2*t12 % sanuty check and total of all ts should be = 1 
ttotal = 6*t11+2*t12+t13
a = (5-0) / t11 ; % given that matximum vel is 5 m/sec which needs to be passed in t11 
% Accelerating 
y1 = (1/2)*(a)*(t11)^2+0*t11 + 0
v1 = a*t11; % derivation using equations is mor etrusty than taking the derivatives - unless derivation works perfectly in Simulink!!!
a1 = a; % Assuming no 
% Contstant velocity 
y2 = 0 + 5*t12+y1
v2 = 5; 
a2 =0; 
% Decelerating 
y3 =  (1/2)*(-a)*(t11)^2+(5)*t11 + y2 
v3 = -a*t11+5;
a3 = -a;
% 4:
y4 =  (1/2)*(-a)*(t11)^2+(0)*t11 + y3  
v4 = -a*t11;
a4 = -a;
% 5 
y5 = 0 + (-5)*t12+y4 
v5 = -5;
a5 = 0;
% 6 
y6 =  (1/2)*(+a)*(t11)^2+(-5)*t11 + y5  
v6 = a*t11-5;
a6 = a;
% 7 
y7 =  (1/2)*(-a)*(t11)^2+(0)*t11 + y6
v7 = -a*t11;
a7 = -a;
% 8 
y8 = 0 + (-5)*t12+y7
v8 = -5;
a8 = 0;
% 9 
y9 = (1/2)*(a)*(t11)^2+(-5)*t11 + y8
v9 = a*t11-5;
a9 = a;
% 10
y10 = (1/2)*(a)*(t11)^2+(0)*t11 + y9
v10 = a*t11;
a10 = a;
% 11
y11 = 0 + 5*t12+y10
v11 = 5;
a11 = 0;
% 12
y12 =  (1/2)*(-a)*(t11)^2+(5)*t11 + y11  
v12 = -a*t11+5;
a12 = -a;
waypoints = [0, y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12]
vel_waypoints = [0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12]
acc_waypoints = [0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12]
corest = [0, t11, t11+t12, t11+t12+t11, t11+t12+t11+t11, t11+t12+t11+t11+t12, ...
t11+t12+t11+t11+t12+t11, t11+t12+t11+t11+t12+t11+t11, t11+t12+t11+t11+t12+t11+t11+t12, ...
t11+t12+t11+t11+t12+t11+t11+t12+t11, t11+t12+t11+t11+t12+t11+t11+t12+t11+t11, ...
t11+t12+t11+t11+t12+t11+t11+t12+t11+t11+t12, t11+t12+t11+t11+t12+t11+t11+t12+t11+t11+t12+t11]
% yfinal(0) = 0;
TotNumSamples = 4219;
t = linspace(0, ttotal, 1e3);
yfinal = zeros(size(t));
for i = 1 : length(t)
    if t(i) > corest(1) && t(i) < corest(2)
        yfinal(i) = (1/2)*(a)*(t(i)-corest(1))^2+0*(t(i)-corest(1)) + 0; % y1
    elseif t(i) > corest(2) && t(i) < corest(3)
        yfinal(i) = 0 + 5*(t(i)-corest(2))+y1 % y2
    elseif t(i) > corest(3) && t(i) < corest(4)
        yfinal(i) = (1/2)*(-a)*(t(i)-corest(3))^2+(5)*(t(i)-corest(3)) + y2 % y3
         elseif t(i) > corest(4) && t(i) < corest(5)
        yfinal(i) = (1/2)*(-a)*(t(i)-corest(4))^2+(0)*(t(i)-corest(4)) + y3 % y4
        elseif t(i) > corest(5) && t(i) < corest(6)
        yfinal(i) = 0 + (-5)*(t(i)-corest(5))+y4 % y5
          elseif t(i) > corest(6) && t(i) < corest(7)
        yfinal(i) =  (1/2)*(+a)*(t(i)-corest(6))^2+(-5)*(t(i)-corest(6)) + y5 % y6
          elseif t(i) > corest(7) && t(i) < corest(8)
        yfinal(i) =  (1/2)*(-a)*(t(i)-corest(7))^2+(0)*(t(i)-corest(7)) + y6 % y7
          elseif t(i) > corest(8) && t(i) < corest(9)
        yfinal(i) = 0 + (-5)*(t(i)-corest(8))+y7 % y8
           elseif t(i) > corest(9) && t(i) < corest(10)
        yfinal(i) = (1/2)*(a)*(t(i)-corest(9))^2+(-5)*(t(i)-corest(9)) + y8 % y9
         elseif t(i) > corest(10) && t(i) < corest(11)
        yfinal(i) = (1/2)*(a)*(t(i)-corest(10))^2+(0)*(t(i)-corest(10)) + y9 % y10
    elseif t(i) > corest(11) && t(i) < corest(12)
        yfinal(i) = 0 + 5*(t(i)-corest(11))+y10 % y11
           elseif t(i) > corest(12) && t(i) < corest(13)
        yfinal(i) =  (1/2)*(-a)*(t(i)-corest(12))^2+(5)*(t(i)-corest(12)) + y11 % y12
    end
end % BTW I proved that: diff(yfinal)./dt and cumtrapz(vfinal) proved all correctness
%%  velocity profile trajectory 
for i = 1 : length(t)
    if t(i) > corest(1) && t(i) < corest(2) % a*t11
        vfinal(i) = (a)*(t(i)-corest(1)); % v1
    elseif t(i) > corest(2) && t(i) < corest(3)
        vfinal(i) =  5 % v2
    elseif t(i) > corest(3) && t(i) < corest(4)
        vfinal(i) = (-a)*(t(i)-corest(3))+(5) + 0 % v3
         elseif t(i) > corest(4) && t(i) < corest(5)
        vfinal(i) = (-a)*(t(i)-corest(4))+(0) + 0 % v4
        elseif t(i) > corest(5) && t(i) < corest(6)
        vfinal(i) = 0 +(-5) % v5
          elseif t(i) > corest(6) && t(i) < corest(7)
        vfinal(i) =  (+a)*(t(i)-corest(6))+(-5) + 0 % v6
          elseif t(i) > corest(7) && t(i) < corest(8)
        vfinal(i) =  (-a)*(t(i)-corest(7))+(0)*(t(i)-corest(7)) + 0 % y7
          elseif t(i) > corest(8) && t(i) < corest(9)
        vfinal(i) = 0 + (-5)+0 % v8
           elseif t(i) > corest(9) && t(i) < corest(10)
        vfinal(i) = (a)*(t(i)-corest(9))+(-5) + 0 % y9
         elseif t(i) > corest(10) && t(i) < corest(11)
        vfinal(i) = (a)*(t(i)-corest(10))+(0)*(t(i)-corest(10)) + 0 % y10
    elseif t(i) > corest(11) && t(i) < corest(12)
        vfinal(i) = 0 + 5+0 % v11
           elseif t(i) > corest(12) && t(i) <= corest(13)
        vfinal(i) =  (-a)*(t(i)-corest(12))+(5) + 0 % v12
    end
end

%%  acceleration profile trajectory 
for i = 1 : length(t)
    if t(i) > corest(1) && t(i) < corest(2) % a*t11
        afinal(i) = a; % a1
    elseif t(i) > corest(2) && t(i) < corest(3)
        afinal(i) =  0 % a2
    elseif t(i) > corest(3) && t(i) < corest(4)
        afinal(i) = (-a)+0+ 0 % a3
         elseif t(i) > corest(4) && t(i) < corest(5)
        afinal(i) = (-a)+(0) + 0 % a4
        elseif t(i) > corest(5) && t(i) < corest(6)
        afinal(i) = 0 + (0)+0 % a5
          elseif t(i) > corest(6) && t(i) < corest(7)
        afinal(i) =  (+a) + 0 % a6
          elseif t(i) > corest(7) && t(i) < corest(8)
        afinal(i) =  (-a)+(0)* + 0 % a7
          elseif t(i) > corest(8) && t(i) < corest(9)
        afinal(i) = 0 + (0)+0 % a8
           elseif t(i) > corest(9) && t(i) < corest(10)
        afinal(i) = (a)+(0) + 0 % a9
         elseif t(i) > corest(10) && t(i) < corest(11)
        afinal(i) = (a)+(0) + 0 % a10
    elseif t(i) > corest(11) && t(i) < corest(12)
        afinal(i) = 0 + 0+0 % a11
           elseif t(i) > corest(12) && t(i) <= corest(13)
        afinal(i) =  (-a)*+(0) + 0 % a12
    end
end

figure(120)
plot(t , yfinal);
xlabel('Time (s)');
ylabel('Position (m)');
title('Generated Trajectory for: Position Profile');
grid on 
xlim('padded')
ylim('padded')
figure(121)
plot(t(1:end-1) , vfinal, 'r--', 'LineWidth', 1);
xlabel('Time (s)');
ylabel('Position (m)');
title('Generated Trajectory for: Velocity Profile');
grid on 
xlim([0, 1])
ylim('padded') % have no idea / clue why vel and acc profiles do not work!!!
figure(122)
plot(t(1:end-1) , afinal);
xlabel('Time (s)');
ylabel('Position (m)');
title('Generated Trajectory for: Acceleration Profile');
grid on 
xlim('padded')
ylim('padded')
% Use this dataset in Simulink to implement the controller 
iddata2 = iddata(yfinal, t);
data2 = [t', yfinal'];
save('RefProfTraj.mat','data2')
figure(11)
plot(corest, waypoints)
grid on 
xlim('padded')
ylim('padded')
xlabel('time [sec]', 'FontSize', 18)
ylabel('Position Profile Trajectory [m]', 'FontSize', 18)
iddata1 = iddata(waypoints, corest)
RefProfTraj = [corest', waypoints']

%% Plany Dynamics Definition
m = 1; 
k = 1e3;
kNL = 10; % Nonlinear Spring Cofficient 
ccr = 2 * sqrt(m*k); 
zeta = 0.01; 
c = zeta * ccr; 
% model in TF
modeltf1 = tf([1], [m , c, k])
get(modeltf1)
figure(51)
subplot(2, 1, 1)
bode(modeltf1)
grid on 
subplot(2, 1, 2)
step(modeltf1)
grid on 
Tend = max(t)

simdata = iddata(yfinal', t');
simdata2 = timeseries(yfinal, t);

directory = 'C:\Users\ababaei\OneDrive - ASML\Alireza\My MATLAB Codes\Optimization\NL_MSD_Opti_Ref_Tracking';
save(fullfile(directory, 'yfinal.mat'), 'yfinal')

% finding the RMSE 
tyfinal = [t', yfinal']; 
t_yfinal = t'; % 1000 by 1 
t_simres = out.test.Time; % 936 by 1 
[~, idx_t_yfinal] = arrayfun(@(t) min(abs(t_yfinal - t)), t_simres);
reduced_yfinal = yfinal(idx_t_yfinal);
% RMSE
e_rmse = out.test.Data - reduced_yfinal;
sqse_rmse = sum((e_rmse).^2);
mean_rmse = sqse_rmse/length(e_rmse);
RMSE = sqrt(mean_rmse)




