function [ z ] = AR1( N, phi )
%AR1 Summary of this function goes here
%   Detailed explanation goes here

z = zeros(N,1);

a = randn(N,1);

for i = 2:N
    z(i) = phi*z(i-1) + a(i);
end


end

