function [Y] = smoothing(X,n)
%SMOOTHER Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    n=12;
end

Y = zeros(size(X,1),1);
for i = (n+1):size(X,1)
    Y(i) = mean(X(i-n:i,1));
end
Y(1:n) = Y(n+1);

end