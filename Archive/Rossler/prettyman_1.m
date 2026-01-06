function [tout,xout] = prettyman_1(T_0,T_1,x_0,a,b,c)
options=odeset('AbsTol',10^(-9));
[tout,xout]=ode45(@(T_0,x_0)f_rossler(x_0,a,b,c),[T_0 T_1],x_0,options);

function f = f_rossler(x,a,b,c)
  %x should be a 3 by 1 vector
  f=zeros(size(x));
  f(1)=-x(2)-x(3);
  f(2)=x(1)+a*x(2);
  f(3)=b+x(3)*(x(1)-c);



    
