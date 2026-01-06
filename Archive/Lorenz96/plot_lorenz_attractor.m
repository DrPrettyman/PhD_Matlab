%A random initial vector
x_0=rand(3,1);
%Solving the Lorenz 96 system using ode45 over a given time interval
[tout, xout] = lorenz_attractor(0,0.01,100,x_0, @(t)10, @(t)8/3, @(t)10+0.3*t);
%Plotting the phase portrait
plot3(xout(:,1),xout(:,2),xout(:,3))

  
figure
plot(xout(:,1));






































































