function [tout,xout] = Sutera(t_0,t_1,T_0, v, mu)

% a function to integrate the function f_system
% from t_0 to t_1 (output results at step 0.1)
% T_0 ----- initial value

I_0 = 1366;
sigma = 5.6704*10^(-8);
c = 10^8;
e = 0.62;
%mu = 1;
b_2 = (1.690*10^(-5));
a_2 = (1.6927);


a = e*sigma/c;
b_mu = (mu*I_0*b_2)/(4*e*sigma);
d_mu = -(mu*I_0*(1-a_2))/(4*e*sigma);


f_system = @(T,t)(c^(-1)*a*(-T^4+b_mu*T^2-d_mu));

options=odeset('AbsTol',10^(-9));
[tout,xout]=ode45(@(t,T)(f_system(T,t)+sqrt(v)*randn(1,1)),...
    (t_0:0.1:t_1),T_0,options);
return




