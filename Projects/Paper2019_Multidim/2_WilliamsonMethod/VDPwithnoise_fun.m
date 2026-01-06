function [tout,xout] = VDPwithnoise_fun(T_0,T_1, x_0,epsilon, sigma)
options=odeset('AbsTol',10^(-5));
[tout,xout]=ode45(@(t,x)f_system(t,x,epsilon, sigma),(T_0:0.01:T_1),x_0,options);
return

function f = f_system(t,x,epsilon, sigma)
  %x should be a 2 by 1 vector
  f=zeros(size(x));
  f(1)= epsilon(t)*(x(1) - x(1)^3/3) + x(2);
  f(2)= - x(1) + sigma*randn;
  return

