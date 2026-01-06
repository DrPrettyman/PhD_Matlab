%A random initial vector
x_1 = rand(3,1);
x_2 = x_1 + [0.1; 0; 0];
%Solving the Lorenz 96 system using ode45 over a given time interval
[tout1, xout1] = lorenz_attractor(0,0.1,100,x_1, @(t)10, @(t)8/3, @(t)28);
[tout2, xout2] = lorenz_attractor(0,0.1,100,x_2, @(t)10, @(t)8/3, @(t)28);
%Plotting the phase portrait
M = min(size(xout1,1), size(xout2,1));
difference = xout1(1:M, 1:3) - xout2(1:M, 1:3);

D = sqrt(difference(:,1).^2 + ...
    difference(:,2).^2 + difference(:,3).^2);

plot(D)