function [sigma] = distanceFunction(distance)
%DISTANCEFUNCTION Summary of this function goes here
%   Detailed explanation goes here

d = abs(distance);

if d>500
    sigma = 0.7; 
else
    sigma = 0.7+0.3*0.002*(500-d);
end

end

