%A random initial vector
x_0=rand(4,1)
%Solving the Lorenz 96 system using ode45 over a given time interval
[tout, xout] = lorenz96(0,10,x_0,0);
%Plotting the phase portrait
plot3(xout(:,1),xout(:,2),xout(:,3),'-x')

    