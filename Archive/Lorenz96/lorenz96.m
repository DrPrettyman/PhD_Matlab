function [tout,xout] = lorenz96(T_0,T_1,x_0,F)
options=odeset('AbsTol',10^(-9));
[tout,xout]=ode45(@(t,x)l96(x,F),[T_0 T_1],x_0,options);
return

function f = l96(x,F)
  N = size(x,1);
  
  f=zeros(N,1);
  
  for k = 1:N
      f(k) = -x(mod(k-3,N)+1)*x(mod(k-2,N)+1) + ...
          x(mod(k-2,N)+1)*x(mod(k,N)+1) + F;
  end
  
  return



    
