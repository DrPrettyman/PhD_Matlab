function [tout,xout] = VDP_fun(T_0,T_1, x_0,epsilon, T_in)
options=odeset('AbsTol',10^(-5));

[tout,xout]=ode45(@(t,x)f_system(t,x,epsilon, T_in),(T_0:0.01:T_1),x_0,options);
return

function f = f_system(t,x,epsilon, T_in)
  %x should be a 2 by 1 vector
  F = 1.2;
  f=zeros(size(x));
  f(1)= epsilon(t)*(x(1) - x(1)^3/3) + x(2);
  f(2)= F*cos(2*pi*t/T_in) - x(1);
  return

