clc; clf; clear all;

steplen = 1000;
Ts = 0.01;

% Controller Gains
Kp = 5;
Ki = 3;

% Feedback Gain
H = 1.5;

% Scaling
if Ki == 0
    Kinput = (Kp*H + 1)/Kp;
else
    Kinput = H;
end

% Creating a series of step changes.
INPUT = [zeros(steplen,1);...
         1*ones(steplen,1);...
         2*ones(steplen,1);...
         3*ones(steplen,1);...
         -2*ones(steplen,1);...
         -1*ones(steplen,1);...
         zeros(steplen,1)];
INPUT = [INPUT;INPUT];
INPUT = [(1:size(INPUT,1)).'*Ts,INPUT];

% Creating a disturbance halfway through the simulation
D_INPUT = [INPUT(:,1),zeros(size(INPUT,1),1)];
D_INPUT((length(D_INPUT)/2):end, 2) = 2;

L = length(INPUT)*Ts;

sim('PI_Controller.mdl');

% Extracting the simulation variables
t = (1:size(simout.signals.values,1));
ref = simout.signals.values(:,1);
unscaled = simout.signals.values(:,2);
scaled = simout.signals.values(:,3);

% Display
figure(1)
plot(t, ref, t, unscaled, t, scaled, 'Linewidth', 2), grid on
xlabel('Sample Index'), ylabel('Signal Amplitude')
title('Comparison of Scaled and Unscaled Closed Loop Control',...
      'Fontweight', 'Bold')
axis([0, length(t), -3, 4])
legend('Input Signal', 'Unscaled Control Signal',...
       'Scaled Control Signal', 'Location', 'North')