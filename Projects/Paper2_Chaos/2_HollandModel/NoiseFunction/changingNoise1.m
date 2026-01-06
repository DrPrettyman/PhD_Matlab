function [noise] = changingNoise1(alpha0, alpha1, seriesLength)
%CHANGINGNOISE Summary of this function goes here
%   Detailed explanation goes here

N = 1000;
alphaValues = linspace(alpha0,alpha1,10);

noiseLong = zeros(10*N,1);


for i = 1:10
    noiseObject = dsp.ColoredNoise(alphaValues(i), N,1);
    n = noiseObject();
    n = (n-mean(n))/std(n);
    
    noiseLong(((i-1)*1000+1):(i*1000)) = n;    
end

indices = 1:(floor(10*N/seriesLength)):10*N;
indices = indices(1:seriesLength);

noise = noiseLong(indices);

noise = (noise-mean(noise))/std(noise);


