function [tout,xout] = lorenz_attractor(T_0,Delt,T_1,x_0, sigma, beta, rho, epsilon)
options=odeset('AbsTol',10^(-9));

if nargin ==7
    epsilon = 0;
end

if isnumeric(sigma)
    sigma = @(t)sigma;
end
if isnumeric(beta)
    beta = @(t)beta;
end
if isnumeric(rho)
    rho = @(t)rho;
end

[tout,xout]=ode45(@(t,x)l_a(x, t, sigma, beta, rho,epsilon),(T_0:Delt:T_1),x_0,options);
return

function f = l_a(x, t, sigma, beta, rho, epsilon)
  % x should be size (3,1)
  
  f=zeros(3,1);
  
  f(1) = sigma(t)*(x(2)-x(1)) + epsilon*randn(1,1);
  f(2) = x(1)*(rho(t)-x(3))-x(2) + epsilon*randn(1,1);
  f(3) = x(1)*x(2) - beta(t)*x(3) + epsilon*randn(1,1);
return