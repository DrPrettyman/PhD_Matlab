function A = estimate_A(x)

% x should be a multivariate time series such that
% x(:,1) is a time series for the first variable, etc.

mu = mean(x)';
musq = mu*mu';

B = autocov(x,1) - musq;
S = autocov(x,0) - musq;

A = B/S;

return


function Output = autocov(x, lag)
% finds the analouge to the lag-1 autocovariance 

Output = zeros(size(x,2));

for i = 1:(size(x,1)-lag)
    
    dummy = x(i+lag,:)'*x(i,:);
    
    Output = Output + dummy;
    
end

Output = Output/(size(x,1)-lag-1);

return

