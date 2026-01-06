function [X] = noiseGen2(length, alpha, tol)
%NOISEGEN2 Summary of this function goes here
%   Detailed explanation goes here

X = noise_generator(length,apha/0.75);
while abs(PSE_new(X)-alpha)>tol
    X = noise_generator(length,apha/0.75);
end

end

