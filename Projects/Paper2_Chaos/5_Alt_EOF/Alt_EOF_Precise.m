function [P, u, ACF1] = Alt_EOF_Precise(X, nondimensionalise)
if nargin<2
    nondimensionalise = false;
end

% mean center the matrix to create new matrix Y
Y = X - ones(size(X,1),1)*mean(X,1);

if nondimensionalise
    Y = Y - ones(size(Y,1),1)*std(Y,1);
end 

% Calculate the matrices C_0 and C_1
SY = [[0,0];Y(1:end-1,:)];
C0 = Y'*Y;
C1 = Y'*SY;

% function gives the vector u which maximises the ACF of the
% projection Yu. 
acf_fun = @(u)(...
    -(u(1)^2*C1(1)+u(1)*u(2)*(C1(2)+C1(3))+u(2)^2*C1(4))/...
    (u(1)^2*C0(1)+u(1)*u(2)*(C0(2)+C0(3))+u(2)^2*C0(4))...
    );
options = optimoptions('fmincon','Display','off');
nonlcon = @unitcircle;
x0 = [1,0];
x = fmincon(acf_fun,x0,[],[],[],[],[],[],nonlcon, options);
u = [x(1);x(2)];

% project and find the ACF1
P = Y*u;
ACF1 = ACF(P, 1);
