%% Load data

if ~exist('cyclones100','var'); load('cyclones100'); end

h=1;
disp(cyclones100(h).h_name)

% we choose the slp_data for the first field (hurricane Andrew)
slp1 = cyclones100(h).slp_data;
event1 = cyclones100(h).event_index;
time1 = (1:size(slp1,1))' - event1;

slp1  = slp1(event1-1200:event1+100);
time1 = time1(event1-1200:event1+100);
clear event1
%% plot slp data
%figure
%plot(time1, slp1 - mean(slp1))

%% we use two methods. 
%  1. we "deseasonalise" by subtracting the 12 hour mean
%  2. we find the period using Fourier and subtract a sine wave

N = 35*24;
X = slp1(1:N);
t = time1(1:N);


%% desasonalise
psize = 12; %partition size

Dwave = zeros(psize,1);
newslp_D = zeros(N,1);
for k = 1:psize
    Dwave(k) = mean(X(k:psize:end));
    newslp_D(k:psize:end) = X(k:psize:end) - Dwave(k);
end
clear k psize
newslp_D = newslp_D - mean(newslp_D);
    
%% Sine wave
freq = 1/12;

% find the amplitude
% subtract the min from the max in every 12 hour 
% window and take the mean
minmaxlist = zeros(N-12,1);
for i = 1:N-12
    window = X(i:(i+12));
    minmaxlist(i) = max(window)-min(window);
end
amp = mean(minmaxlist)/2;
clear i window minmaxlist
    
% find the best offset and make the wave
offsets = linspace(0,12,1000);
for i = 1:1000
    Swave = amp*sin(2*pi*freq*(t-offsets(i)));
    v(i) = var(X-Swave);
end
bestOffset = offsets(v == min(v));
Swave = amp*sin(2*pi*freq*(t-bestOffset));
clear i v offsets bestOffset
% create the new series
newslp_S = X-Swave;
newslp_S = newslp_S - mean(newslp_S);

%% Plot the original X with the new, oscillation-removed X
figure
hold on
plot(t,X)
plot(t,Swave+mean(X))
plot(t,newslp_S+mean(X))
title('removal via sine wave')

%% plot both together
figure
hold on
plot(t, newslp_D)
plot(t, newslp_S - mean(newslp_S))
title('both new series')

%% Now to find the ACF1 signal
lag = 1;
windowSize = 90;
ACF_R = ACF_sliding(X, lag, windowSize);
ACF_D = ACF_sliding(newslp_D, lag, windowSize);
ACF_S = ACF_sliding(newslp_S, lag, windowSize);

%% Plot
figure 
hold on
plot(t(windowSize+1:end), ACF_R(windowSize+1:end))
plot(t(windowSize+1:end), ACF_D(windowSize+1:end))
plot(t(windowSize+1:end), ACF_S(windowSize+1:end))
title('ACF indicator')
%xlim([-1000,0]);


%% Now to find the PS signal
windowSize = 102;
PS_R = PSE_sliding(X, windowSize);
PS_D = PSE_sliding(newslp_D, windowSize);
PS_S = PSE_sliding(newslp_S, windowSize);

%% Plot
figure 
hold on
plot(t(windowSize+1:end), PS_R(windowSize+1:end))
plot(t(windowSize+1:end), PS_D(windowSize+1:end))
plot(t(windowSize+1:end), PS_S(windowSize+1:end))
title('PS indicator')
%xlim([-1000,0]);

%% Now to find the DFA signal
windowSize = 90;
order = 2;
DFA_R = DFA_sliding(X, order, windowSize);
DFA_D = DFA_sliding(newslp_D, order, windowSize);
DFA_S = DFA_sliding(newslp_S, order, windowSize);

%% Plot
figure 
hold on
plot(t(windowSize:end), DFA_R)
plot(t(windowSize:end), DFA_D)
plot(t(windowSize:end), DFA_S)
title('DFA indicator')
%xlim([-1000,0]);


