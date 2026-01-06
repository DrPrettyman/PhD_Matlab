function [out] = scalingexpMSM(X, ws)

% This method for estimating the scaling exponent segments
% the timeseries and estimates the SE by the classic 
% power spectrum method for each segment. The result is obtained
% by taking the mean from all these segments.

exponents = zeros(size(X,1)-ws+1,1);

for i = 1:size(exponents,1)
    window = X(i:i+ws-1);
    exponents(i) = classicMethod(window);
end

out = mean(exponents);
return


function [out] = classicMethod(X)

% This is the classic method for estimating the scaling exponent
% by estimating the slope of the log-log plot of the power spectrum.

% estimate the power spectrum of X
FFT = fft(X)/size(X,1);
PS = abs(FFT(1:floor(end/2))).^2;

% fit to the PS
poly = polyfit( log(1:size(PS,1))', log(PS), 1 );
out = poly(1);
return

