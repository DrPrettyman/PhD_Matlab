function [tout,xout] = noisy_lorenz(T_0,T_1,x_0, sigma, beta, rho, epsilon)
options=odeset('AbsTol',10^(-9));
[tout,xout]=ode45(@(t,x)l_a(x, sigma, beta, rho, epsilon),[T_0 T_1],x_0,options);
return

function f = l_a(x, sigma, beta, rho, epsilon)
  % x should be size (3,1)
  
  f=zeros(3,1);
  
  f(1) = sigma*(x(2)-x(1)) + epsilon*randn(1,1);
  f(2) = x(1)*(rho-x(3))-x(2) + epsilon*randn(1,1);
  f(3) = x(1)*x(2) - beta*x(3) + epsilon*randn(1,1);
  
  return



    
