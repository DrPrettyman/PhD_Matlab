function [freq] = findFrequency(t,X, plotPS, cutoff)

%% a function to find the dominant frequency
%  of time series X(t). (column vector).
%  Also plots the powerspectrum.
%  When findin the dominant frequency, it only considers 
%  frequencies greater than the cutoff value.

if nargin < 4; cutoff = 0; end
if nargin < 3; plotPS = true; end

% if the arguments are not specified, use this example:
if nargin < 2
    t = linspace(25,32,2*10^4)';
    X = 5*sin(2*pi*2*t)+8*sin(2*pi*(1/3)*t)+3*sin(2*pi*(4)*t);
    % with plotPS turned on
    plotPS=true;
end

% find the power spectrum
P = abs(fft(X)); P = P(2:floor(end/2));
f = (1:size(P,1))./(t(end)-t(1));

% find the peak
peak = find(P == max(P(f > cutoff))) ; 
freq = f(peak);

% plot the figure
if plotPS
    disp(['peak at ' num2str(freq)])
    figure
    plot(f,P)
end