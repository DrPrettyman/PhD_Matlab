

%% Set parameters

N = 5000; % series length
s = 20;   % number of segments

alpha0 = 0; % initial parameter
alpha1 = 2; % final parameter

T = 5; % number of trials

wl = 100; % window length

%% Create the holders

AllSeries = zeros(N,T);

ACF1vals = zeros(N,T);
DFAvals  = zeros(N,T);
PSvals   = zeros(N,T);

%% run the trials

for j = 1:T
    j
    
    series = func6_ArtificalData(N, s, alpha0, alpha1);
    
    AllSeries(:,j) = series;
    
    PSvals(:,j) = PSE_sliding(series, wl);
end

%% take the mean

PSmean = mean(PSvals,2);
PSstd = std(PSvals')';
%% plot

figure
hold on
for j = 1:T
    plot(AllSeries(:,j))
end

figure
hold on
plot(PSmean, 'color', 'b')
plot(PSmean - PSstd, 'color', 'b')
plot(PSmean + PSstd, 'color', 'b')















