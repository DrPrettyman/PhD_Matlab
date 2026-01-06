function [tout,xout] = signal_decode(T_0,Delt,T_1,x_0, sigma, beta, rho, u_in)
options=odeset('AbsTol',10^(-9));

[tout,xout]=ode45(@(t,x)l_a(x, t, u_in, sigma, beta, rho, T_0, Delt),(T_0:Delt:T_1),x_0,options);
return

function f = l_a(x, t, u_in, sigma, beta, rho, T_0, Delt)
  % x should be size (3,1)
  
  f=zeros(3,1);
   
  i = floor(t/Delt-T_0)+1;
  
  f(1) = sigma(t)*(x(2)-x(1));
  f(2) = u_in(i)*(rho(t)-x(3))-x(2);
  f(3) = u_in(i)*x(2) - beta(t)*x(3);
return