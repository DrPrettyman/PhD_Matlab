
N = 4;
m = 3;
g = 2;
T = 100;

% find H and Q. H is the cov of epsilon (NxN) 
% and Q is the cov of eta (mxm).
a = rand(N,2);
epsilon = a*randn(2,1);
H = a*a';

b = rand(g,2);
eta = b*rand(2,1);
Q = b*b';


% define M, c and R
M = rand(m,m);
c = rand(m,1);
R = rand(m,g);

% define Z and d
Z = rand(N,m);
d = rand(N,1);

% alpha(t) = M(t)*alpha(t-1) + c(t) + R(t)*eta(t)
% y(t) = Z(t)*alpha(t) + d(t) + epsilon(t)
    
y = zeros(N,T);
alpha = zeros(m,T);

for t = 2:T
    eta = b*rand(2,1);
    alpha(:,t) = M*alpha(:,t-1) + c + R*eta;
end

for t = 1:T
    epsilon = a*rand(2,1);
    y(:,t) = Z*alpha(:,t);
end


plot(y')



