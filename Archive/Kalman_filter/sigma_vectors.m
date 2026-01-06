function [ X, Wm, Wc ] = sigma_vectors( x, kappa, alpha, beta )
%UKF Summary of this function goes here
%   Detailed explanation goes here

x_bar;
Px;
L;

lambda = (alpha^2)*(L+kappa) - L;
Matrix_sqrt = sqrt((L+lambda)*Px);

X = zeros(L, 2*L+1);
X(:,0) = x_bar;
for i = 1:L
    X(:,i) = X(:,0) - Matrix_sqrt(:,i);
end
for i = L+1:2*L
    X(:,i) = X(:,0) - Matrix_sqrt(:,i-L);
end


Wm = zeros(1, 2*L+1);
Wc = zeros(1, 2*L+1);
Wm(0) = lambda/(L+lambda);
Wc(0) = lambda/(L+lambda) + (1 - alpha^2 + beta);
for i = 1:2*L
    Wm(i) = 1/(2*(L+lambda));
    Wc(i) = Wm(i);
end

return