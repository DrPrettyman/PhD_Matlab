function [ x1, y1 ] = smooth( x0, y0, step  )
%SMOOTH Summary of this function goes here
%   Detailed explanation goes here

x1 = ((x0(1)+step-1):step:x0(end))';
n = size(x1,1);
y1 = zeros(n,1);


for i = 1:n
    y1(i) = mean(y0(((i-1)*step+1):i*step));   
end

end

