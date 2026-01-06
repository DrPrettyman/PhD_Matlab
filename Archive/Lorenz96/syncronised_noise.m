
%% Create a messgage 
% lets just make a sine wave
signal = 2*sin(0:0.01:100);
figure
plot(signal);
title('signal');

%% create chaotic noise
%A random initial vector
x_0=rand(3,1);
%Solving the Lorenz 96 system using ode45 over a given time interval
[tout, xout] = lorenz_attractor(0,0.01,100,x_0, @(t)10, @(t)8/3, @(t)28);
%Plotting the phase portrait
%plot3(xout(:,1),xout(:,2),xout(:,3))

figure
plot(signal+xout(:,1)');
title('signal+noise');

%% decode

u_in = signal+xout(:,1)';

%A random initial vector
x_0=rand(3,1);
%Solving the Lorenz 96 system using ode45 over a given time interval
[tout, xout] = signal_decode(0,0.01,100,x_0, @(t)10, @(t)8/3, @(t)28, u_in);

figure
plot(u_in - xout(:,1)')






