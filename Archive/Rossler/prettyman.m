%A random initial vector
x_0=rand(1,3)
%Solving the Rossler system using ode45 over a given time interval
[tout xout]=prettyman_1(0,600,x_0,0.2,2,7);
%Plotting the phase portrait
plot3(xout(:,1),xout(:,2),xout(:,3))
pause
%Trimming the early solutions, leaving only the atractor
[tout2 xout2] = prettyman_2(200,tout,xout);
%Plotting the 'trimmed' phase portrait
plot3(xout2(:,1),xout2(:,2),xout2(:,3))
pause
%Showing how the x-component varies over time
plot(tout2,xout2(:,1))
pause
%Selecting only local maxima, corresponding to the peaks in the above plot
local_maxima = prettyman_3(0.2,xout2);
pause
%
%Plotting the bifurcation diagrams for varying b and c resp..
%These take a long time to run.
%
%prettyman_4(0,600,200,0.01,x_0,0.2,5.7,0.2,2,200)
%prettyman_5(0,600,200,0.01,x_0,0.3,35,200)