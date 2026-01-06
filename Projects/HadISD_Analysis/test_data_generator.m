function [ X ] = test_data_generator( n )
%TEST_DATA_GENERATOR Summary of this function goes here
%   Detailed explanation goes here

f = 2; %twice-daily ocsillation
sigma = 1;
mu = 3;

t = (0:(1/24):n)'; % make a time vector
X = (n/10)*sin(f*2*pi*t); % make a sine wave
X = X + sigma*randn(size(X)); % add some noise

X(end-48:end) =... % add a parabolic trend 48 hours from the end
    X(end-48:end) - mu*(t(end-48:end)-t(end-48)).^2;

%X(end) = 3*X(end); % make a sudden jump at the end

plot(t*24 - 24*n,X); % plot the result

end

