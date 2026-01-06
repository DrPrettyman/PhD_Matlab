function [ z ] = ARp( phi, N )
if nargin<2
    N = 10000;
end
%AR1 Summary of this function goes here
%   Detailed explanation goes here

p = size(phi,2);

z = zeros(N,1);

a = randn(N,1);

for i = (p+1):N
    shift_term = 0;
    for j = 1:p
        shift_term = shift_term + phi(j)*z(i-j);
    end
    z(i) = shift_term + a(i);
end


end