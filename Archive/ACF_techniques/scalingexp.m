function [out] = scalingexp(X)
plot = true;

% This is the classic method for estimating the scaling exponent
% by estimating the slope of the log-log plot of the power spectrum.

% estimate the power spectrum of X
FFT = fft(X)/size(X,1);
PS = abs(FFT(1:floor(end/3))).^2;

% fit to the PS
poly = polyfit( log(1:size(PS,1))', log(PS), 1 );
out = poly(1);

%% plot
if plot
    figure
    x = (1:size(PS,1))';
    loglog(x, PS )
    hold on
    fit = x.^poly(1);
    loglog(x, fit)
end
return

